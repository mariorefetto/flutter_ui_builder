import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

/// Which theme the app uses.
enum ThemeChoice { system, light, dark }

/// What the user prefers, kept between sessions. The designer's choices are
/// stored by name, so the domain does not depend on the types that draw them.
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(ThemeChoice.system) ThemeChoice theme,

    /// The language code, or null to follow the system's.
    String? languageCode,

    /// The device the designer starts on: phone, tablet or desktop.
    @Default('phone') String device,

    /// Whether the designer starts with the body of the device drawn.
    @Default(true) bool showFrame,

    /// How the status bar starts: auto, light, dark or hidden.
    @Default('auto') String statusBar,
    @Default(false) bool showSafeArea,

    /// Where the code starts: tab, right or bottom.
    @Default('tab') String codePlacement,

    /// Whether the palette shows its widgets as a grid rather than a list.
    @Default(false) bool paletteGrid,

    /// Whether the welcome tour has been seen, so it is not shown again.
    @Default(false) bool tourSeen,
  }) = _AppSettings;
}
