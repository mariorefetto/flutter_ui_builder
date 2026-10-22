import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// Title of the application
  ///
  /// In en, this message translates to:
  /// **'Flutter UI Builder'**
  String get appTitle;

  /// Title of the editor page
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get editorTitle;

  /// Tooltip of the undo button
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get editorUndo;

  /// Tooltip of the redo button
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get editorRedo;

  /// Shown when an edit refers to a missing widget
  ///
  /// In en, this message translates to:
  /// **'The selected widget no longer exists'**
  String get errorUnknownNode;

  /// Shown when the drop target is missing
  ///
  /// In en, this message translates to:
  /// **'The target container no longer exists'**
  String get errorUnknownParent;

  /// Shown when a widget type is not registered
  ///
  /// In en, this message translates to:
  /// **'This widget type is not available'**
  String get errorUnknownType;

  /// Shown when dropping into a widget without children
  ///
  /// In en, this message translates to:
  /// **'This widget cannot contain other widgets'**
  String get errorChildNotAllowed;

  /// Shown when dropping into a full single-child widget
  ///
  /// In en, this message translates to:
  /// **'This widget accepts only one child'**
  String get errorParentFull;

  /// Shown when the insertion index is out of range
  ///
  /// In en, this message translates to:
  /// **'The drop position is not valid'**
  String get errorInvalidIndex;

  /// Shown when editing the root widget
  ///
  /// In en, this message translates to:
  /// **'The root widget cannot be moved or removed'**
  String get errorRootProtected;

  /// Shown when moving a widget into its own subtree
  ///
  /// In en, this message translates to:
  /// **'A widget cannot be moved into itself'**
  String get errorCyclicMove;

  /// Shown when undo is requested with an empty history
  ///
  /// In en, this message translates to:
  /// **'Nothing to undo'**
  String get errorNothingToUndo;

  /// Shown when redo is requested with an empty history
  ///
  /// In en, this message translates to:
  /// **'Nothing to redo'**
  String get errorNothingToRedo;

  /// Title of the widget palette
  ///
  /// In en, this message translates to:
  /// **'Widgets'**
  String get editorPaletteTitle;

  /// Title of the widget tree panel
  ///
  /// In en, this message translates to:
  /// **'Widget tree'**
  String get editorTreeTitle;

  /// Tooltip of the delete button
  ///
  /// In en, this message translates to:
  /// **'Delete selected widget'**
  String get editorDelete;

  /// Palette category of layout widgets
  ///
  /// In en, this message translates to:
  /// **'Layout'**
  String get editorCategoryLayout;

  /// Shown when editing a property that does not exist
  ///
  /// In en, this message translates to:
  /// **'This widget has no such property'**
  String get errorUnknownProp;

  /// Shown when a property value has the wrong type
  ///
  /// In en, this message translates to:
  /// **'The value is not valid for this property'**
  String get errorInvalidValue;

  /// Title of the properties panel
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get editorPropertiesTitle;

  /// Hint shown when no widget is selected
  ///
  /// In en, this message translates to:
  /// **'Select a widget to edit its properties'**
  String get editorNoSelection;

  /// Error text of a property field
  ///
  /// In en, this message translates to:
  /// **'Invalid value'**
  String get editorInvalidValue;

  /// Tooltip of the button that clears a property
  ///
  /// In en, this message translates to:
  /// **'Clear value'**
  String get editorClearValue;

  /// Dropdown entry meaning the property has no value
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get editorValueUnset;

  /// Label of the left edge inset field
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get editorInsetLeft;

  /// Label of the top edge inset field
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get editorInsetTop;

  /// Label of the right edge inset field
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get editorInsetRight;

  /// Label of the bottom edge inset field
  ///
  /// In en, this message translates to:
  /// **'Bottom'**
  String get editorInsetBottom;

  /// Hint of the color property field
  ///
  /// In en, this message translates to:
  /// **'Hex color, for example 2196F3 or FF2196F3'**
  String get editorColorHint;

  /// Shown when a file operation fails
  ///
  /// In en, this message translates to:
  /// **'The file could not be read or written'**
  String get errorStorageAccess;

  /// Shown when exporting would overwrite a hand written file
  ///
  /// In en, this message translates to:
  /// **'A file with this name already exists and was not generated by the builder. It was left untouched'**
  String get errorStorageNotGenerated;

  /// Shown when code generation produces invalid code
  ///
  /// In en, this message translates to:
  /// **'The generated code is not valid Dart'**
  String get errorCodeGeneration;

  /// Tooltip of the button that opens the generated code
  ///
  /// In en, this message translates to:
  /// **'View code'**
  String get editorViewCode;

  /// Title of the generated code page
  ///
  /// In en, this message translates to:
  /// **'Generated code'**
  String get codeTitle;

  /// Label of the copy code button
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get codeCopy;

  /// Confirmation after copying the code
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get codeCopied;

  /// Label of the export button
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get codeExport;

  /// Confirmation after exporting generated files
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 file exported} other{{count} files exported}}'**
  String codeExported(int count);

  /// Label of buttons that retry a failed operation
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// Shown when opening a file that is not a project
  ///
  /// In en, this message translates to:
  /// **'This file is not a valid project'**
  String get errorDocumentInvalidFormat;

  /// Shown when the project schema version is too new
  ///
  /// In en, this message translates to:
  /// **'This project was saved by a newer version of the app'**
  String get errorDocumentUnsupportedVersion;

  /// Shown when a project has an unregistered widget type
  ///
  /// In en, this message translates to:
  /// **'This project uses a widget that is not available'**
  String get errorDocumentUnknownWidget;

  /// Shown when a project tree breaks the child rules
  ///
  /// In en, this message translates to:
  /// **'The structure of this project is not valid'**
  String get errorDocumentInvalidStructure;

  /// Shown when renaming a project to an empty name
  ///
  /// In en, this message translates to:
  /// **'The project name cannot be empty'**
  String get errorDocumentEmptyName;

  /// Tooltip of the file menu
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get fileMenuTooltip;

  /// Menu entry that starts an empty project
  ///
  /// In en, this message translates to:
  /// **'New project'**
  String get fileNew;

  /// Menu entry that opens a project file
  ///
  /// In en, this message translates to:
  /// **'Open...'**
  String get fileOpen;

  /// Menu entry that saves the project
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get fileSave;

  /// Menu entry that saves the project to a new file
  ///
  /// In en, this message translates to:
  /// **'Save as...'**
  String get fileSaveAs;

  /// Confirmation after saving the project
  ///
  /// In en, this message translates to:
  /// **'Project saved'**
  String get fileSaved;

  /// Title of the unsaved changes dialog
  ///
  /// In en, this message translates to:
  /// **'Discard unsaved changes?'**
  String get fileDiscardTitle;

  /// Body of the unsaved changes dialog
  ///
  /// In en, this message translates to:
  /// **'The changes made since the last save will be lost.'**
  String get fileDiscardMessage;

  /// Button that discards unsaved changes
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get fileDiscard;

  /// Label of buttons that cancel a dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// Label of buttons that confirm a dialog
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonConfirm;

  /// Title of the rename dialog
  ///
  /// In en, this message translates to:
  /// **'Project name'**
  String get renameTitle;

  /// App bar title when the project has unsaved changes
  ///
  /// In en, this message translates to:
  /// **'{name} (modified)'**
  String editorTitleModified(String name);

  /// Shown when a widget is dropped into a parent that does not accept it
  ///
  /// In en, this message translates to:
  /// **'This widget cannot be placed here'**
  String get errorParentNotAllowed;

  /// Shown when a Scaffold slot already has a widget
  ///
  /// In en, this message translates to:
  /// **'This part of the screen is already filled'**
  String get errorSlotTaken;

  /// Palette category of Scaffold and its parts
  ///
  /// In en, this message translates to:
  /// **'Screen'**
  String get editorCategoryScreen;

  /// Palette category: Text
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get editorCategoryText;

  /// Palette category: Images and icons
  ///
  /// In en, this message translates to:
  /// **'Images and icons'**
  String get editorCategoryImagesIcons;

  /// Palette category: Buttons
  ///
  /// In en, this message translates to:
  /// **'Buttons'**
  String get editorCategoryButtons;

  /// Palette category: Input
  ///
  /// In en, this message translates to:
  /// **'Input'**
  String get editorCategoryInput;

  /// Palette category: Information
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get editorCategoryInformation;

  /// Palette category: Scrolling
  ///
  /// In en, this message translates to:
  /// **'Scrolling'**
  String get editorCategoryScrolling;

  /// Palette category: Painting and effects
  ///
  /// In en, this message translates to:
  /// **'Painting and effects'**
  String get editorCategoryPainting;

  /// Palette category: Animation
  ///
  /// In en, this message translates to:
  /// **'Animation'**
  String get editorCategoryAnimation;

  /// Palette category: Interaction
  ///
  /// In en, this message translates to:
  /// **'Interaction'**
  String get editorCategoryInteraction;

  /// Palette category: Accessibility
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get editorCategoryAccessibility;

  /// Palette category: Cupertino
  ///
  /// In en, this message translates to:
  /// **'Cupertino'**
  String get editorCategoryCupertino;

  /// Hint of the palette search field
  ///
  /// In en, this message translates to:
  /// **'Search widgets'**
  String get editorPaletteSearch;

  /// Tooltip of the theme menu
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeTooltip;

  /// Theme menu entry that follows the system setting
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get settingsThemeSystem;

  /// Theme menu entry for the light theme
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// Theme menu entry for the dark theme
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// Shown when a widget that needs a Material ancestor is placed outside one
  ///
  /// In en, this message translates to:
  /// **'This widget needs a Scaffold or a Card above it'**
  String get errorAncestorRequired;

  /// Shown when a document starts with a widget that needs a parent
  ///
  /// In en, this message translates to:
  /// **'This widget cannot be the root of a screen'**
  String get errorRootNotAllowed;

  /// Label: File
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get menuFile;

  /// Label: Edit
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get menuEdit;

  /// Label: View
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get menuView;

  /// Label: Export code...
  ///
  /// In en, this message translates to:
  /// **'Export code...'**
  String get menuExportCode;

  /// Label: Rename project...
  ///
  /// In en, this message translates to:
  /// **'Rename project...'**
  String get menuRename;

  /// Label: Toolbox
  ///
  /// In en, this message translates to:
  /// **'Toolbox'**
  String get menuToolbox;

  /// Label: Document outline
  ///
  /// In en, this message translates to:
  /// **'Document outline'**
  String get menuOutline;

  /// Label: Properties
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get menuProperties;

  /// Label: Design
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get menuDesign;

  /// Label: Code
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get menuCode;

  /// Label: Theme
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get menuTheme;

  /// Label: Toolbox
  ///
  /// In en, this message translates to:
  /// **'Toolbox'**
  String get panelToolbox;

  /// Label: Document outline
  ///
  /// In en, this message translates to:
  /// **'Document outline'**
  String get panelOutline;

  /// Label: Properties
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get panelProperties;

  /// Label: Close panel
  ///
  /// In en, this message translates to:
  /// **'Close panel'**
  String get panelClose;

  /// Label: Design
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get tabDesign;

  /// Label: Code
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get tabCode;

  /// Label: Search properties
  ///
  /// In en, this message translates to:
  /// **'Search properties'**
  String get propsSearch;

  /// Label: Categorized
  ///
  /// In en, this message translates to:
  /// **'Categorized'**
  String get propsCategorized;

  /// Label: Alphabetical
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get propsAlphabetical;

  /// Label: Reset to default
  ///
  /// In en, this message translates to:
  /// **'Reset to default'**
  String get propsReset;

  /// Label: No selection
  ///
  /// In en, this message translates to:
  /// **'No selection'**
  String get propsNoSelectionTitle;

  /// Label: Appearance
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get propsGroupAppearance;

  /// Label: Layout
  ///
  /// In en, this message translates to:
  /// **'Layout'**
  String get propsGroupLayout;

  /// Label: Content
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get propsGroupContent;

  /// Label: Text
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get propsGroupText;

  /// Label: Behavior
  ///
  /// In en, this message translates to:
  /// **'Behavior'**
  String get propsGroupBehavior;

  /// Label: Accessibility
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get propsGroupAccessibility;

  /// Label: Text
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get propsTypeString;

  /// Label: Number
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get propsTypeNumber;

  /// Label: Yes or no
  ///
  /// In en, this message translates to:
  /// **'Yes or no'**
  String get propsTypeBoolean;

  /// Label: Color
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get propsTypeColor;

  /// Label: One of a list
  ///
  /// In en, this message translates to:
  /// **'One of a list'**
  String get propsTypeChoice;

  /// Label: Four sides
  ///
  /// In en, this message translates to:
  /// **'Four sides'**
  String get propsTypeInsets;

  /// Label: No default value
  ///
  /// In en, this message translates to:
  /// **'No default value'**
  String get propsNoDefault;

  /// Label: Ready
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get statusReady;

  /// Label: Modified
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get statusModified;

  /// Label: Saved
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get statusSaved;

  /// Label: No selection
  ///
  /// In en, this message translates to:
  /// **'No selection'**
  String get statusNoSelection;

  /// Label: Cannot be added to the selection
  ///
  /// In en, this message translates to:
  /// **'Cannot be added to the selection'**
  String get editorPaletteCannotAdd;

  /// Label: Click to rename the project
  ///
  /// In en, this message translates to:
  /// **'Click to rename the project'**
  String get editorDocumentTabTooltip;

  /// Footer of the properties panel with the default value
  ///
  /// In en, this message translates to:
  /// **'Default: {value}'**
  String propsDefault(String value);

  /// Number of widgets in the document, in the status bar
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 widget} other{{count} widgets}}'**
  String statusWidgets(int count);

  /// Shown when unwrapping a widget without children
  ///
  /// In en, this message translates to:
  /// **'This widget has nothing inside to take its place'**
  String get errorNoChildren;

  /// Label: Add widget
  ///
  /// In en, this message translates to:
  /// **'Add widget'**
  String get menuAdd;

  /// Label: Cut
  ///
  /// In en, this message translates to:
  /// **'Cut'**
  String get menuCut;

  /// Label: Copy
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get menuCopy;

  /// Label: Paste
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get menuPaste;

  /// Label: Duplicate
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get menuDuplicate;

  /// Label: Wrap with
  ///
  /// In en, this message translates to:
  /// **'Wrap with'**
  String get menuWrapWith;

  /// Label: Remove wrapper
  ///
  /// In en, this message translates to:
  /// **'Remove wrapper'**
  String get menuUnwrap;

  /// Label: Problems
  ///
  /// In en, this message translates to:
  /// **'Problems'**
  String get menuProblems;

  /// Label: No problems found
  ///
  /// In en, this message translates to:
  /// **'No problems found'**
  String get problemsEmpty;

  /// Label: Show problems
  ///
  /// In en, this message translates to:
  /// **'Show problems'**
  String get statusProblemsTooltip;

  /// Label: Nothing can be added here
  ///
  /// In en, this message translates to:
  /// **'Nothing can be added here'**
  String get menuNothingToAdd;

  /// Title of the problems panel
  ///
  /// In en, this message translates to:
  /// **'Problems ({count})'**
  String panelProblems(int count);

  /// Problem: a widget that requires a child has none
  ///
  /// In en, this message translates to:
  /// **'{type} needs a widget inside; an empty box is used in the code'**
  String problemRequiredChildMissing(String type);

  /// Problem: A NavigationBar needs at least two destinations
  ///
  /// In en, this message translates to:
  /// **'A NavigationBar needs at least two destinations'**
  String get problemNavigationBarFewDestinations;

  /// Problem: A hidden text field can only have one line
  ///
  /// In en, this message translates to:
  /// **'A hidden text field can only have one line'**
  String get problemHiddenTextMultiline;

  /// Problem: radius cannot be used together with minRadius or maxRadius
  ///
  /// In en, this message translates to:
  /// **'radius cannot be used together with minRadius or maxRadius'**
  String get problemAvatarRadiusConflict;

  /// Problem: Set at most two of left, right and width, and two of top, bottom and height
  ///
  /// In en, this message translates to:
  /// **'Set at most two of left, right and width, and two of top, bottom and height'**
  String get problemPositionedOverconstrained;

  /// Problem: The image has no semantic label for screen readers
  ///
  /// In en, this message translates to:
  /// **'The image has no semantic label for screen readers'**
  String get problemImageWithoutLabel;

  /// Problem: The image has no URL, so it will fail to load
  ///
  /// In en, this message translates to:
  /// **'The image has no URL, so it will fail to load'**
  String get problemImageWithoutUrl;

  /// Problem: The maximum must be greater than the minimum
  ///
  /// In en, this message translates to:
  /// **'The maximum must be greater than the minimum'**
  String get problemSliderRange;

  /// Problem: A three line tile needs a subtitle
  ///
  /// In en, this message translates to:
  /// **'A three line tile needs a subtitle'**
  String get problemThreeLineWithoutSubtitle;

  /// Problem: The button has no tooltip for screen readers
  ///
  /// In en, this message translates to:
  /// **'The button has no tooltip for screen readers'**
  String get problemMissingTooltip;

  /// Label: Phone
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get designerDevicePhone;

  /// Label: Tablet
  ///
  /// In en, this message translates to:
  /// **'Tablet'**
  String get designerDeviceTablet;

  /// Label: Desktop
  ///
  /// In en, this message translates to:
  /// **'Desktop'**
  String get designerDeviceDesktop;

  /// Label: Rotate the screen
  ///
  /// In en, this message translates to:
  /// **'Rotate the screen'**
  String get designerRotate;

  /// Label: Zoom in
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get designerZoomIn;

  /// Label: Zoom out
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get designerZoomOut;

  /// Label: Actual size
  ///
  /// In en, this message translates to:
  /// **'Actual size'**
  String get designerZoomReset;

  /// Label: Zoom in
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get menuZoomIn;

  /// Label: Zoom out
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get menuZoomOut;

  /// Label: Actual size
  ///
  /// In en, this message translates to:
  /// **'Actual size'**
  String get menuZoomReset;

  /// Label: Add inside
  ///
  /// In en, this message translates to:
  /// **'Add inside'**
  String get menuAddInside;

  /// Label: Add next to
  ///
  /// In en, this message translates to:
  /// **'Add next to'**
  String get menuAddBeside;

  /// Label: Choose a color
  ///
  /// In en, this message translates to:
  /// **'Choose a color'**
  String get colorPickerTitle;

  /// Label: Open the color picker
  ///
  /// In en, this message translates to:
  /// **'Open the color picker'**
  String get colorPickerOpen;

  /// Shown when importing code: The code has syntax errors
  ///
  /// In en, this message translates to:
  /// **'The code has syntax errors'**
  String get errorCodeSyntax;

  /// Shown when importing code: No widget found: write a widget class with a build method, or a single widget
  ///
  /// In en, this message translates to:
  /// **'No widget found: write a widget class with a build method, or a single widget'**
  String get errorCodeNoWidget;

  /// Label: Import code...
  ///
  /// In en, this message translates to:
  /// **'Import code...'**
  String get menuImportCode;

  /// Label: Import code
  ///
  /// In en, this message translates to:
  /// **'Import code'**
  String get importTitle;

  /// Label: Paste the Dart code of a widget, or a single widget expression
  ///
  /// In en, this message translates to:
  /// **'Paste the Dart code of a widget, or a single widget expression'**
  String get importHint;

  /// Label: Render
  ///
  /// In en, this message translates to:
  /// **'Render'**
  String get importRender;

  /// Label: Open a .dart file...
  ///
  /// In en, this message translates to:
  /// **'Open a .dart file...'**
  String get importOpenFile;

  /// Label: Open in the designer
  ///
  /// In en, this message translates to:
  /// **'Open in the designer'**
  String get importApply;

  /// Label: Left out
  ///
  /// In en, this message translates to:
  /// **'Left out'**
  String get importIssuesTitle;

  /// Label: The code needs a Scaffold around it, so one was added
  ///
  /// In en, this message translates to:
  /// **'The code needs a Scaffold around it, so one was added'**
  String get importIssueWrappedInScaffold;

  /// Result of importing code
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 widget found} other{{count} widgets found}}'**
  String importFound(int count);

  /// Import issue: unknown widget
  ///
  /// In en, this message translates to:
  /// **'{type} is not available and was replaced'**
  String importIssueUnknownWidget(String type);

  /// Import issue: unsupported argument
  ///
  /// In en, this message translates to:
  /// **'{type}: the argument {argument} is not supported and was ignored'**
  String importIssueUnsupportedArgument(String type, String argument);

  /// Import issue: unreadable value
  ///
  /// In en, this message translates to:
  /// **'{type}: the value of {argument} could not be read and was ignored'**
  String importIssueInvalidValue(String type, String argument);

  /// Label: Device frame
  ///
  /// In en, this message translates to:
  /// **'Device frame'**
  String get designerFrame;

  /// Label: Show the safe area
  ///
  /// In en, this message translates to:
  /// **'Show the safe area'**
  String get designerSafeArea;

  /// Label: Status bar
  ///
  /// In en, this message translates to:
  /// **'Status bar'**
  String get designerStatusBar;

  /// Label: Automatic
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get statusBarAuto;

  /// Label: Light icons
  ///
  /// In en, this message translates to:
  /// **'Light icons'**
  String get statusBarLight;

  /// Label: Dark icons
  ///
  /// In en, this message translates to:
  /// **'Dark icons'**
  String get statusBarDark;

  /// Label: Hidden
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get statusBarHidden;

  /// Label: Apply to the designer
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get codeApply;

  /// Label: Revert to the generated code
  ///
  /// In en, this message translates to:
  /// **'Revert'**
  String get codeRevert;

  /// Label: Edited
  ///
  /// In en, this message translates to:
  /// **'Edited'**
  String get codeEdited;

  /// Label: In sync with the designer
  ///
  /// In en, this message translates to:
  /// **'In sync'**
  String get codeInSync;

  /// Label: Apply or revert the edits before exporting
  ///
  /// In en, this message translates to:
  /// **'Apply or revert the edits before exporting'**
  String get codeExportAfterApply;

  /// Drop target label: Inside {type}
  ///
  /// In en, this message translates to:
  /// **'Inside {type}'**
  String dropInside(String type);

  /// Drop target label: Before {type}
  ///
  /// In en, this message translates to:
  /// **'Before {type}'**
  String dropBefore(String type);

  /// Drop target label: After {type}
  ///
  /// In en, this message translates to:
  /// **'After {type}'**
  String dropAfter(String type);

  /// Label: Search the outline
  ///
  /// In en, this message translates to:
  /// **'Search the outline'**
  String get outlineSearch;

  /// Label: Rename widget...
  ///
  /// In en, this message translates to:
  /// **'Rename widget...'**
  String get menuRenameWidget;

  /// Label: Widget name
  ///
  /// In en, this message translates to:
  /// **'Widget name'**
  String get renameWidgetTitle;

  /// Label: Leave empty to remove the name
  ///
  /// In en, this message translates to:
  /// **'Leave empty to remove the name'**
  String get renameWidgetHint;

  /// Label: Choose an icon
  ///
  /// In en, this message translates to:
  /// **'Choose an icon'**
  String get iconPickerTitle;

  /// Label: Search icons
  ///
  /// In en, this message translates to:
  /// **'Search icons'**
  String get iconPickerSearch;

  /// Label: No icon
  ///
  /// In en, this message translates to:
  /// **'No icon'**
  String get iconPickerNotSet;

  /// Tooltip of the property width
  ///
  /// In en, this message translates to:
  /// **'Width in logical pixels. Leave empty to fit the content or the space the parent gives.'**
  String get propHelpWidth;

  /// Tooltip of the property height
  ///
  /// In en, this message translates to:
  /// **'Height in logical pixels. Leave empty to fit the content or the space the parent gives.'**
  String get propHelpHeight;

  /// Tooltip of the property padding
  ///
  /// In en, this message translates to:
  /// **'Space between the edge of the widget and its content, on each side.'**
  String get propHelpPadding;

  /// Tooltip of the property margin
  ///
  /// In en, this message translates to:
  /// **'Space around the outside of the widget, on each side.'**
  String get propHelpMargin;

  /// Tooltip of the property alignment
  ///
  /// In en, this message translates to:
  /// **'Where the content sits inside the available space.'**
  String get propHelpAlignment;

  /// Tooltip of the property color
  ///
  /// In en, this message translates to:
  /// **'The color used to fill or draw the widget.'**
  String get propHelpColor;

  /// Tooltip of the property backgroundColor
  ///
  /// In en, this message translates to:
  /// **'The color behind the widget.'**
  String get propHelpBackgroundColor;

  /// Tooltip of the property foregroundColor
  ///
  /// In en, this message translates to:
  /// **'The color of the text and icons on top of the widget.'**
  String get propHelpForegroundColor;

  /// Tooltip of the property elevation
  ///
  /// In en, this message translates to:
  /// **'How far the widget is raised above the surface, which sets the size of its shadow.'**
  String get propHelpElevation;

  /// Tooltip of the property borderRadius
  ///
  /// In en, this message translates to:
  /// **'Rounds all four corners by this radius.'**
  String get propHelpBorderRadius;

  /// Tooltip of the property borderColor
  ///
  /// In en, this message translates to:
  /// **'The color of the border.'**
  String get propHelpBorderColor;

  /// Tooltip of the property borderWidth
  ///
  /// In en, this message translates to:
  /// **'The thickness of the border on every side.'**
  String get propHelpBorderWidth;

  /// Tooltip of the property shadowColor
  ///
  /// In en, this message translates to:
  /// **'The color of the shadow. Any shadow property creates a shadow.'**
  String get propHelpShadowColor;

  /// Tooltip of the property shadowBlur
  ///
  /// In en, this message translates to:
  /// **'How soft the shadow edge is. Larger values spread and fade it.'**
  String get propHelpShadowBlur;

  /// Tooltip of the property shadowSpread
  ///
  /// In en, this message translates to:
  /// **'How much larger than the widget the shadow is before it is blurred.'**
  String get propHelpShadowSpread;

  /// Tooltip of the property shadowOffsetX
  ///
  /// In en, this message translates to:
  /// **'Moves the shadow sideways. Positive values go right.'**
  String get propHelpShadowOffsetX;

  /// Tooltip of the property shadowOffsetY
  ///
  /// In en, this message translates to:
  /// **'Moves the shadow up or down. Positive values go down.'**
  String get propHelpShadowOffsetY;

  /// Tooltip of the property gradientStart
  ///
  /// In en, this message translates to:
  /// **'The first color of a gradient. Setting either color creates one.'**
  String get propHelpGradientStart;

  /// Tooltip of the property gradientEnd
  ///
  /// In en, this message translates to:
  /// **'The last color of a gradient.'**
  String get propHelpGradientEnd;

  /// Tooltip of the property gradientDirection
  ///
  /// In en, this message translates to:
  /// **'The direction the gradient runs in.'**
  String get propHelpGradientDirection;

  /// Tooltip of the property fontSize
  ///
  /// In en, this message translates to:
  /// **'The size of the letters, in logical pixels.'**
  String get propHelpFontSize;

  /// Tooltip of the property fontWeight
  ///
  /// In en, this message translates to:
  /// **'How thick the strokes of the letters are.'**
  String get propHelpFontWeight;

  /// Tooltip of the property fontFamily
  ///
  /// In en, this message translates to:
  /// **'The name of the font. It must be available to the app.'**
  String get propHelpFontFamily;

  /// Tooltip of the property textAlign
  ///
  /// In en, this message translates to:
  /// **'How lines of text line up horizontally.'**
  String get propHelpTextAlign;

  /// Tooltip of the property maxLines
  ///
  /// In en, this message translates to:
  /// **'The most lines the text may use. Leave empty for no limit.'**
  String get propHelpMaxLines;

  /// Tooltip of the property overflow
  ///
  /// In en, this message translates to:
  /// **'What happens to text that does not fit.'**
  String get propHelpOverflow;

  /// Tooltip of the property letterSpacing
  ///
  /// In en, this message translates to:
  /// **'Extra space between letters.'**
  String get propHelpLetterSpacing;

  /// Tooltip of the property flex
  ///
  /// In en, this message translates to:
  /// **'How much of the free space this widget takes compared to its siblings.'**
  String get propHelpFlex;

  /// Tooltip of the property spacing
  ///
  /// In en, this message translates to:
  /// **'Space between the children.'**
  String get propHelpSpacing;

  /// Tooltip of the property mainAxisAlignment
  ///
  /// In en, this message translates to:
  /// **'How the children are placed along the main direction: down a Column, across a Row.'**
  String get propHelpMainAxisAlignment;

  /// Tooltip of the property crossAxisAlignment
  ///
  /// In en, this message translates to:
  /// **'How the children are placed across the main direction.'**
  String get propHelpCrossAxisAlignment;

  /// Tooltip of the property mainAxisSize
  ///
  /// In en, this message translates to:
  /// **'Whether the widget takes all the room along its main direction or only what its children need.'**
  String get propHelpMainAxisSize;

  /// Tooltip of the property fit
  ///
  /// In en, this message translates to:
  /// **'How the content is sized to fill the space.'**
  String get propHelpFit;

  /// Tooltip of the property title
  ///
  /// In en, this message translates to:
  /// **'The main text of the widget.'**
  String get propHelpTitle;

  /// Tooltip of the property subtitle
  ///
  /// In en, this message translates to:
  /// **'A smaller line of text under the title.'**
  String get propHelpSubtitle;

  /// Tooltip of the property label
  ///
  /// In en, this message translates to:
  /// **'The text that names the widget.'**
  String get propHelpLabel;

  /// Tooltip of the property icon
  ///
  /// In en, this message translates to:
  /// **'The icon shown. Click to search all Material icons.'**
  String get propHelpIcon;

  /// Tooltip of the property url
  ///
  /// In en, this message translates to:
  /// **'The address, asset path or file path of the picture, depending on the source.'**
  String get propHelpUrl;

  /// Tooltip of the property source
  ///
  /// In en, this message translates to:
  /// **'Where the picture comes from: the web, a bundled asset or a file.'**
  String get propHelpSource;

  /// Tooltip of the property value
  ///
  /// In en, this message translates to:
  /// **'The current value of the control.'**
  String get propHelpValue;

  /// Tooltip of the property min
  ///
  /// In en, this message translates to:
  /// **'The smallest value the control can take.'**
  String get propHelpMin;

  /// Tooltip of the property max
  ///
  /// In en, this message translates to:
  /// **'The largest value the control can take.'**
  String get propHelpMax;

  /// Tooltip of the property enabled
  ///
  /// In en, this message translates to:
  /// **'Whether the control reacts to the user.'**
  String get propHelpEnabled;

  /// Tooltip of the property obscureText
  ///
  /// In en, this message translates to:
  /// **'Hides what is typed, as for a password.'**
  String get propHelpObscureText;

  /// Tooltip of the property keyboardType
  ///
  /// In en, this message translates to:
  /// **'The kind of keyboard shown for the field.'**
  String get propHelpKeyboardType;

  /// Tooltip of the property duration
  ///
  /// In en, this message translates to:
  /// **'How long the animation takes, in milliseconds.'**
  String get propHelpDuration;

  /// Tooltip of the property curve
  ///
  /// In en, this message translates to:
  /// **'How the animation speeds up and slows down.'**
  String get propHelpCurve;

  /// Tooltip of the property opacity
  ///
  /// In en, this message translates to:
  /// **'How opaque the widget is: 1 is solid, 0 is invisible.'**
  String get propHelpOpacity;

  /// Tooltip of the property scale
  ///
  /// In en, this message translates to:
  /// **'How much the widget is enlarged or reduced: 1 is its own size.'**
  String get propHelpScale;

  /// Tooltip of the property tooltip
  ///
  /// In en, this message translates to:
  /// **'The text shown when the pointer rests on the widget, and read by screen readers.'**
  String get propHelpTooltip;

  /// Tooltip of the property semanticLabel
  ///
  /// In en, this message translates to:
  /// **'What a screen reader says for the widget.'**
  String get propHelpSemanticLabel;

  /// Tooltip of the property statusBarStyle
  ///
  /// In en, this message translates to:
  /// **'Whether the status bar shows light or dark icons over this bar.'**
  String get propHelpStatusBarStyle;

  /// Tooltip of the property centerTitle
  ///
  /// In en, this message translates to:
  /// **'Centers the title instead of putting it at the start.'**
  String get propHelpCenterTitle;

  /// Tooltip of the property shape
  ///
  /// In en, this message translates to:
  /// **'The outline of the widget: a rectangle or a circle.'**
  String get propHelpShape;

  /// Tooltip line listing the values a property accepts
  ///
  /// In en, this message translates to:
  /// **'Options: {list}'**
  String propsOptions(String list);

  /// Tooltip line naming the constructor argument
  ///
  /// In en, this message translates to:
  /// **'In the code: {argument}'**
  String propsCodeArgument(String argument);

  /// Tooltip line naming an argument nested in another
  ///
  /// In en, this message translates to:
  /// **'In the code: {argument} of {group}'**
  String propsGroupedArgument(String argument, String group);

  /// Problem: A circle has no corners: the radius is ignored and Flutter rejects it
  ///
  /// In en, this message translates to:
  /// **'A circle has no corners: the radius is ignored and Flutter rejects it'**
  String get problemCircleWithRadius;

  /// Problem: The text color is too close to its background to read comfortably (WCAG asks 4.5:1)
  ///
  /// In en, this message translates to:
  /// **'The text color is too close to its background to read comfortably (WCAG asks 4.5:1)'**
  String get problemLowContrast;

  /// Problem: The tap target is smaller than 48 pixels, which is hard to hit
  ///
  /// In en, this message translates to:
  /// **'The tap target is smaller than 48 pixels, which is hard to hit'**
  String get problemSmallTapTarget;

  /// Tooltip: Code as a tab
  ///
  /// In en, this message translates to:
  /// **'Code as a tab'**
  String get codeAsTab;

  /// Tooltip: Code beside the designer
  ///
  /// In en, this message translates to:
  /// **'Code beside the designer'**
  String get codeBeside;

  /// Tooltip: Code below the designer
  ///
  /// In en, this message translates to:
  /// **'Code below the designer'**
  String get codeBelow;

  /// Tooltip: Collapse all
  ///
  /// In en, this message translates to:
  /// **'Collapse all'**
  String get outlineCollapseAll;

  /// Tooltip: Expand all
  ///
  /// In en, this message translates to:
  /// **'Expand all'**
  String get outlineExpandAll;

  /// Palette: Recently added
  ///
  /// In en, this message translates to:
  /// **'Recently added'**
  String get paletteRecent;

  /// Palette: Show only what can be added here
  ///
  /// In en, this message translates to:
  /// **'Show only what can be added here'**
  String get paletteOnlyFitting;

  /// Palette: No widget matches the search
  ///
  /// In en, this message translates to:
  /// **'No widget matches the search'**
  String get paletteNoMatches;

  /// Palette: Takes no child
  ///
  /// In en, this message translates to:
  /// **'Takes no child'**
  String get paletteTakesNoChild;

  /// Palette: Takes one child
  ///
  /// In en, this message translates to:
  /// **'Takes one child'**
  String get paletteTakesOneChild;

  /// Palette: Takes any number of children
  ///
  /// In en, this message translates to:
  /// **'Takes any number of children'**
  String get paletteTakesChildren;

  /// Palette: Click to add, or drag onto the screen or the outline
  ///
  /// In en, this message translates to:
  /// **'Click to add, or drag onto the screen or the outline'**
  String get paletteClickToAdd;

  /// Message: Another screen already has this name
  ///
  /// In en, this message translates to:
  /// **'Another screen already has this name'**
  String get errorScreenDuplicate;

  /// Message: A project needs at least one screen
  ///
  /// In en, this message translates to:
  /// **'A project needs at least one screen'**
  String get errorScreenLast;

  /// Message: This screen no longer exists
  ///
  /// In en, this message translates to:
  /// **'This screen no longer exists'**
  String get errorScreenUnknown;

  /// Message: This widget opens a screen that does not exist
  ///
  /// In en, this message translates to:
  /// **'This widget opens a screen that does not exist'**
  String get problemUnknownScreen;

  /// Tooltip: add a screen
  ///
  /// In en, this message translates to:
  /// **'New screen'**
  String get screenNew;

  /// Dialog title: add a screen
  ///
  /// In en, this message translates to:
  /// **'New screen'**
  String get screenNewTitle;

  /// Hint of the screen name field
  ///
  /// In en, this message translates to:
  /// **'Screen name'**
  String get screenNameHint;

  /// Suggested name of a new screen
  ///
  /// In en, this message translates to:
  /// **'Screen {number}'**
  String screenDefaultName(int number);

  /// Tooltip of a screen tab
  ///
  /// In en, this message translates to:
  /// **'Open {name}'**
  String screenOpenTooltip(String name);

  /// Menu: rename a screen
  ///
  /// In en, this message translates to:
  /// **'Rename screen'**
  String get screenRename;

  /// Menu: make a screen the first
  ///
  /// In en, this message translates to:
  /// **'Make it the start screen'**
  String get screenMakeHome;

  /// Menu: delete a screen
  ///
  /// In en, this message translates to:
  /// **'Delete screen'**
  String get screenDelete;

  /// Option: no navigation
  ///
  /// In en, this message translates to:
  /// **'Does not open a screen'**
  String get screenNavigateNone;

  /// Option: pop the screen
  ///
  /// In en, this message translates to:
  /// **'Goes back'**
  String get screenNavigateBack;

  /// Tooltip: go to the screen a widget opens
  ///
  /// In en, this message translates to:
  /// **'Open the target screen'**
  String get screenOpenTarget;

  /// Tooltip: prototype mode
  ///
  /// In en, this message translates to:
  /// **'Try the navigation: clicking a widget opens its screen'**
  String get designerPrototype;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
