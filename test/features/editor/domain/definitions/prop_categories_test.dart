import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_categories.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';

void main() {
  test('every property of every widget falls in a known group', () {
    for (final definition in builtinDefinitions) {
      for (final prop in definition.props) {
        expect(
          propGroups,
          contains(propCategoryOf(prop)),
          reason: '${definition.type}.${prop.name}',
        );
      }
    }
  });

  test('the group follows the name, then the type', () {
    expect(
      propCategoryOf(const PropSchema(name: 'fontSize', type: PropType.number)),
      textGroup,
    );
    expect(
      propCategoryOf(const PropSchema(name: 'width', type: PropType.number)),
      layoutGroup,
    );
    expect(
      propCategoryOf(const PropSchema(name: 'other', type: PropType.color)),
      appearanceGroup,
    );
    expect(
      propCategoryOf(
        const PropSchema(
          name: 'width',
          type: PropType.number,
          category: contentGroup,
        ),
      ),
      contentGroup,
    );
  });
}
