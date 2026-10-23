import 'package:flutter/widgets.dart';

/// Whether the screen is being tried as it would run. Then the controls react
/// to the pointer and keep what is typed or chosen, until the mode is left.
class PrototypeScope extends InheritedWidget {
  const PrototypeScope({
    required this.prototype,
    required super.child,
    super.key,
  });

  final bool prototype;

  /// Whether the closest scope is on; off when there is none.
  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PrototypeScope>()?.prototype ??
      false;

  @override
  bool updateShouldNotify(PrototypeScope oldWidget) =>
      prototype != oldWidget.prototype;
}

/// Keeps a control from reacting to the pointer, so a tap on it selects the
/// widget on the canvas instead of pressing the control. In prototype mode it
/// lets the pointer through.
class Inert extends StatelessWidget {
  const Inert({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      PrototypeScope.of(context) ? child : IgnorePointer(child: child);
}

/// A control with a value of its own in prototype mode: it shows [initial],
/// and the control's own changes are kept, so a switch can be turned and a
/// slider moved. Outside prototype mode it shows [initial] and does nothing.
class LiveValue<T> extends StatefulWidget {
  const LiveValue({required this.initial, required this.builder, super.key});

  /// The value the node says the control has.
  final T initial;

  /// Builds the control for a value, with the function that changes it.
  final Widget Function(T value, ValueChanged<T> change) builder;

  @override
  State<LiveValue<T>> createState() => _LiveValueState<T>();
}

class _LiveValueState<T> extends State<LiveValue<T>> {
  late T _value = widget.initial;

  @override
  void didUpdateWidget(LiveValue<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A change in the designer is what the control shows again.
    if (oldWidget.initial != widget.initial) _value = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final live = PrototypeScope.of(context);
    return Inert(
      child: widget.builder(
        live ? _value : widget.initial,
        live ? (value) => setState(() => _value = value) : (_) {},
      ),
    );
  }
}
