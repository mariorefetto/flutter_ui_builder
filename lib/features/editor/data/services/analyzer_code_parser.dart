import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/code_parser.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/code_value.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/sample_data.dart';

const String _buildMethod = 'build';
const String _wrapperVariable = '__widget';
final RegExp _classPattern = RegExp(r'\bclass\s+([A-Za-z_]\w*)');

/// Reads Dart source with the analyzer's parser, which only builds the syntax
/// tree and resolves nothing, so it needs no Flutter project around it.
class AnalyzerCodeParser implements CodeParser {
  const AnalyzerCodeParser();

  @override
  ParsedSource parse(String source) {
    final unit = parseString(content: source, throwIfDiagnostics: false);
    final build = _BuildFinder.find(unit.unit);
    if (build != null) {
      return ParsedSource(
        widget: _toValue(build),
        className: _classPattern.firstMatch(source)?.group(1),
        errors: _errors(unit),
      );
    }
    return _parseSnippet(source);
  }

  @override
  CodeValue? parseExpression(String source) {
    final result = _parseAsInitializer(source);
    return result.errors.isEmpty && result.expression != null
        ? _toValue(result.expression!)
        : null;
  }

  // Source that is not a class: a single widget expression.
  ParsedSource _parseSnippet(String source) {
    final trimmed = source.trim().replaceAll(RegExp(r';\s*$'), '');
    final result = _parseAsInitializer(trimmed);
    return ParsedSource(
      widget: result.errors.isEmpty && result.expression != null
          ? _toValue(result.expression!)
          : null,
      errors: result.errors,
    );
  }

  ({Expression? expression, List<String> errors}) _parseAsInitializer(
    String source,
  ) {
    final result = parseString(
      content: 'final $_wrapperVariable = $source;',
      throwIfDiagnostics: false,
    );
    final declarations = result.unit.declarations
        .whereType<TopLevelVariableDeclaration>();
    final variable = declarations.isEmpty
        ? null
        : declarations.first.variables.variables.firstOrNull;
    return (expression: variable?.initializer, errors: _errors(result));
  }

  List<String> _errors(ParseStringResult result) => [
    for (final error in result.errors)
      'line ${result.lineInfo.getLocation(error.offset).lineNumber}: '
          '${error.message}',
  ];

  CodeValue _toValue(Expression expression) {
    return switch (expression) {
      ParenthesizedExpression(:final expression) => _toValue(expression),
      SimpleStringLiteral(:final value) => CodeString(value),
      AdjacentStrings(:final strings)
          when strings.every((s) => s is SimpleStringLiteral) =>
        CodeString(
          strings.cast<SimpleStringLiteral>().map((s) => s.value).join(),
        ),
      StringInterpolation() => _interpolated(expression),
      IntegerLiteral(:final value) when value != null => CodeNumber(
        value.toDouble(),
        isInteger: true,
      ),
      DoubleLiteral(:final value) => CodeNumber(value, isInteger: false),
      PrefixExpression(:final operator, :final operand)
          when operator.lexeme == '-' && operand is Literal =>
        _negate(_toValue(operand), expression),
      BooleanLiteral(:final value) => CodeBool(value),
      ListLiteral(:final elements) => CodeList([
        for (final element in elements)
          element is Expression ? _toValue(element) : CodeUnknown('$element'),
      ]),
      PrefixedIdentifier(:final prefix, :final identifier) => CodeIdentifier(
        identifier.name,
        prefix: prefix.name,
      ),
      SimpleIdentifier(:final name) => CodeIdentifier(name),
      FunctionExpression(:final body) => CodeFunction(body: _bodyOf(body)),
      MethodInvocation() => _methodCall(expression),
      InstanceCreationExpression() => _creation(expression),
      _ => CodeUnknown(expression.toSource()),
    };
  }

  // The one expression a closure consists of, or null for a longer body.
  CodeValue? _bodyOf(FunctionBody body) {
    if (body is ExpressionFunctionBody) return _toValue(body.expression);
    if (body is BlockFunctionBody) {
      final statements = body.block.statements;
      final only = statements.length == 1 ? statements.first : null;
      if (only is ExpressionStatement) return _toValue(only.expression);
    }
    return null;
  }

  // `'Item ${index + 1}'` is the text "Item {n}": the number of the item in a
  // list that repeats a widget. Any other interpolation is not read.
  CodeValue _interpolated(StringInterpolation text) {
    final buffer = StringBuffer();
    for (final element in text.elements) {
      switch (element) {
        case InterpolationString(:final value):
          buffer.write(value);
        case InterpolationExpression(:final expression)
            when expression.toSource().replaceAll(' ', '') == 'index+1':
          buffer.write(sampleNumberToken);
        default:
          return CodeUnknown(text.toSource());
      }
    }
    return CodeString(buffer.toString());
  }

  CodeValue _negate(CodeValue value, Expression original) => value is CodeNumber
      ? CodeNumber(-value.value, isInteger: value.isInteger)
      : CodeUnknown(original.toSource());

  // `Column(...)` or `Image.network(...)` without `new` or `const`.
  CodeValue _methodCall(MethodInvocation call) {
    final target = call.target;
    if (target != null && target is! SimpleIdentifier) {
      return CodeUnknown(call.toSource());
    }
    return _call(
      name: target is SimpleIdentifier ? target.name : call.methodName.name,
      constructor: target is SimpleIdentifier ? call.methodName.name : null,
      arguments: call.argumentList.arguments,
    );
  }

  // Unresolved, `const Image.network(...)` reads as the type `network` behind
  // the prefix `Image`, so a prefix is the class and the type the constructor.
  CodeValue _creation(InstanceCreationExpression creation) {
    final type = creation.constructorName.type;
    final prefix = type.importPrefix?.name.lexeme;
    return _call(
      name: prefix ?? type.name.lexeme,
      constructor: prefix == null
          ? creation.constructorName.name?.name
          : type.name.lexeme,
      arguments: creation.argumentList.arguments,
    );
  }

  CodeValue _call({
    required String name,
    required String? constructor,
    required List<Expression> arguments,
  }) {
    final positional = <CodeValue>[];
    final named = <String, CodeValue>{};
    for (final argument in arguments) {
      if (argument is NamedExpression) {
        named[argument.name.label.name] = _toValue(argument.expression);
      } else {
        positional.add(_toValue(argument));
      }
    }
    return CodeCall(
      name: name,
      constructor: constructor,
      positional: positional,
      named: named,
    );
  }
}

/// Finds the expression a `build` method returns.
class _BuildFinder extends RecursiveAstVisitor<void> {
  Expression? _found;

  static Expression? find(CompilationUnit unit) {
    final finder = _BuildFinder();
    unit.accept(finder);
    return finder._found;
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (_found == null && node.name.lexeme == _buildMethod) {
      final body = node.body;
      if (body is ExpressionFunctionBody) {
        _found = body.expression;
      } else if (body is BlockFunctionBody) {
        body.block.accept(_ReturnFinder(this));
      }
    }
    super.visitMethodDeclaration(node);
  }
}

class _ReturnFinder extends RecursiveAstVisitor<void> {
  _ReturnFinder(this._owner);

  final _BuildFinder _owner;

  @override
  void visitReturnStatement(ReturnStatement node) {
    _owner._found ??= node.expression;
  }
}
