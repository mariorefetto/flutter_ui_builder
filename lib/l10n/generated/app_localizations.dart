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

  /// Problem: This widget shows a component that does not exist
  ///
  /// In en, this message translates to:
  /// **'This widget shows a component that does not exist'**
  String get problemUnknownComponent;

  /// Problem: This component would end up containing itself
  ///
  /// In en, this message translates to:
  /// **'This component would end up containing itself'**
  String get problemComponentCycle;

  /// Label: Components
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get editorCategoryComponents;

  /// Label: New component
  ///
  /// In en, this message translates to:
  /// **'New component'**
  String get componentNew;

  /// Label: New component
  ///
  /// In en, this message translates to:
  /// **'New component'**
  String get componentNewTitle;

  /// Suggested name: Component {number}
  ///
  /// In en, this message translates to:
  /// **'Component {number}'**
  String componentDefaultName(int number);

  /// Label: Make a component of this widget
  ///
  /// In en, this message translates to:
  /// **'Make a component of this widget'**
  String get componentExtract;

  /// Label: Component name
  ///
  /// In en, this message translates to:
  /// **'Component name'**
  String get componentExtractTitle;

  /// Label: Detach from the component
  ///
  /// In en, this message translates to:
  /// **'Detach from the component'**
  String get componentDetach;

  /// Label: Edit the component
  ///
  /// In en, this message translates to:
  /// **'Edit the component'**
  String get componentEdit;

  /// Label: No component
  ///
  /// In en, this message translates to:
  /// **'No component'**
  String get componentNone;

  /// Label: Open the component
  ///
  /// In en, this message translates to:
  /// **'Open the component'**
  String get componentOpenTarget;

  /// Label: New screen
  ///
  /// In en, this message translates to:
  /// **'New screen'**
  String get screenNewScreen;

  /// Label: Settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Label: General
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// Label: Designer
  ///
  /// In en, this message translates to:
  /// **'Designer'**
  String get settingsDesigner;

  /// Label: Editor
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get settingsEditor;

  /// Label: Language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Label: Follow the system
  ///
  /// In en, this message translates to:
  /// **'Follow the system'**
  String get settingsLanguageSystem;

  /// Label: Theme
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// Label: Device
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get settingsDevice;

  /// Label: Status bar
  ///
  /// In en, this message translates to:
  /// **'Status bar'**
  String get settingsStatusBar;

  /// Label: Draw the device frame
  ///
  /// In en, this message translates to:
  /// **'Draw the device frame'**
  String get settingsShowFrame;

  /// Label: Show the safe area
  ///
  /// In en, this message translates to:
  /// **'Show the safe area'**
  String get settingsShowSafeArea;

  /// Label: Code panel
  ///
  /// In en, this message translates to:
  /// **'Code panel'**
  String get settingsCodePlacement;

  /// Label: Settings...
  ///
  /// In en, this message translates to:
  /// **'Settings...'**
  String get menuSettings;

  /// Label: Close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// Label: Keyboard shortcuts
  ///
  /// In en, this message translates to:
  /// **'Keyboard shortcuts'**
  String get menuShortcuts;

  /// Label: Help
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get menuHelp;

  /// Label: Structure
  ///
  /// In en, this message translates to:
  /// **'Structure'**
  String get shortcutsStructure;

  /// Label: Select the next widget
  ///
  /// In en, this message translates to:
  /// **'Select the next widget'**
  String get shortcutSelectNext;

  /// Label: Select the previous widget
  ///
  /// In en, this message translates to:
  /// **'Select the previous widget'**
  String get shortcutSelectPrevious;

  /// Label: Select the parent widget
  ///
  /// In en, this message translates to:
  /// **'Select the parent widget'**
  String get shortcutSelectParent;

  /// Label: Select the first child
  ///
  /// In en, this message translates to:
  /// **'Select the first child'**
  String get shortcutSelectFirstChild;

  /// Label: Move the widget down
  ///
  /// In en, this message translates to:
  /// **'Move the widget down'**
  String get shortcutMoveDown;

  /// Label: Move the widget up
  ///
  /// In en, this message translates to:
  /// **'Move the widget up'**
  String get shortcutMoveUp;

  /// Label: Media
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get panelMedia;

  /// Label: Add pictures...
  ///
  /// In en, this message translates to:
  /// **'Add pictures...'**
  String get mediaAdd;

  /// Label: No pictures yet. Add some to use them in Image widgets.
  ///
  /// In en, this message translates to:
  /// **'No pictures yet. Add some to use them in Image widgets.'**
  String get mediaEmpty;

  /// Label: Click to add an Image that shows it
  ///
  /// In en, this message translates to:
  /// **'Click to add an Image that shows it'**
  String get mediaUseTooltip;

  /// Label: Remove the picture
  ///
  /// In en, this message translates to:
  /// **'Remove the picture'**
  String get mediaRemove;

  /// Label: Add this to pubspec.yaml
  ///
  /// In en, this message translates to:
  /// **'Add this to pubspec.yaml'**
  String get mediaPubspec;

  /// Label: Copy
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get mediaCopyPubspec;

  /// Option: no picture chosen
  ///
  /// In en, this message translates to:
  /// **'No picture'**
  String get assetNone;

  /// Screen template: Blank screen
  ///
  /// In en, this message translates to:
  /// **'Blank screen'**
  String get templateBlank;

  /// Screen template: Login
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get templateLogin;

  /// Screen template: Settings list
  ///
  /// In en, this message translates to:
  /// **'Settings list'**
  String get templateSettings;

  /// Screen template: Profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get templateProfile;

  /// Screen template: Inbox
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get templateInbox;

  /// Screen template: Onboarding
  ///
  /// In en, this message translates to:
  /// **'Onboarding'**
  String get templateOnboarding;

  /// What the widget Scaffold is
  ///
  /// In en, this message translates to:
  /// **'The basic structure of a screen: it holds an app bar, a body, a floating button and a bottom bar, and gives its content a Material surface.'**
  String get widgetHelpScaffold;

  /// What the widget AppBar is
  ///
  /// In en, this message translates to:
  /// **'The bar at the top of a screen, with a title and room for icons that act on the screen.'**
  String get widgetHelpAppBar;

  /// What the widget BottomAppBar is
  ///
  /// In en, this message translates to:
  /// **'A bar at the bottom of a screen that holds actions, often next to a floating button.'**
  String get widgetHelpBottomAppBar;

  /// What the widget NavigationBar is
  ///
  /// In en, this message translates to:
  /// **'The bar at the bottom for moving between the main places of an app.'**
  String get widgetHelpNavigationBar;

  /// What the widget FloatingActionButton is
  ///
  /// In en, this message translates to:
  /// **'A round button that floats over the content for the main action of the screen.'**
  String get widgetHelpFloatingActionButton;

  /// What the widget Column is
  ///
  /// In en, this message translates to:
  /// **'Places its children one under the other.'**
  String get widgetHelpColumn;

  /// What the widget Row is
  ///
  /// In en, this message translates to:
  /// **'Places its children side by side.'**
  String get widgetHelpRow;

  /// What the widget Stack is
  ///
  /// In en, this message translates to:
  /// **'Puts its children on top of each other, so they can overlap.'**
  String get widgetHelpStack;

  /// What the widget Container is
  ///
  /// In en, this message translates to:
  /// **'A box that can have a size, a margin, a padding, a colour, a border, a shadow and a shape.'**
  String get widgetHelpContainer;

  /// What the widget Padding is
  ///
  /// In en, this message translates to:
  /// **'Adds empty space around its child.'**
  String get widgetHelpPadding;

  /// What the widget Center is
  ///
  /// In en, this message translates to:
  /// **'Puts its child in the middle of the space it has.'**
  String get widgetHelpCenter;

  /// What the widget Align is
  ///
  /// In en, this message translates to:
  /// **'Puts its child at a chosen place in the space it has.'**
  String get widgetHelpAlign;

  /// What the widget SizedBox is
  ///
  /// In en, this message translates to:
  /// **'A box of a fixed size. Without a child it is an empty gap.'**
  String get widgetHelpSizedBox;

  /// What the widget Expanded is
  ///
  /// In en, this message translates to:
  /// **'Makes its child fill the free space of a Row or Column.'**
  String get widgetHelpExpanded;

  /// What the widget Flexible is
  ///
  /// In en, this message translates to:
  /// **'Lets its child take free space in a Row or Column, without having to fill it.'**
  String get widgetHelpFlexible;

  /// What the widget Spacer is
  ///
  /// In en, this message translates to:
  /// **'An empty gap that takes the free space of a Row or Column.'**
  String get widgetHelpSpacer;

  /// What the widget SafeArea is
  ///
  /// In en, this message translates to:
  /// **'Keeps its child clear of the notch, the status bar and the other parts of the screen the system covers.'**
  String get widgetHelpSafeArea;

  /// What the widget SingleChildScrollView is
  ///
  /// In en, this message translates to:
  /// **'Lets one child that is taller than the screen be scrolled.'**
  String get widgetHelpSingleChildScrollView;

  /// What the widget Wrap is
  ///
  /// In en, this message translates to:
  /// **'Places its children in a line and starts a new line when there is no room.'**
  String get widgetHelpWrap;

  /// What the widget ListView is
  ///
  /// In en, this message translates to:
  /// **'A list that scrolls, built from its children.'**
  String get widgetHelpListView;

  /// What the widget GridView is
  ///
  /// In en, this message translates to:
  /// **'A grid that scrolls, with a fixed number of columns.'**
  String get widgetHelpGridView;

  /// What the widget Text is
  ///
  /// In en, this message translates to:
  /// **'Shows a piece of text, with a size, a weight and a colour.'**
  String get widgetHelpText;

  /// What the widget Image is
  ///
  /// In en, this message translates to:
  /// **'Shows a picture from the web, from the project or from a file.'**
  String get widgetHelpImage;

  /// What the widget Icon is
  ///
  /// In en, this message translates to:
  /// **'Shows one of the Material icons.'**
  String get widgetHelpIcon;

  /// What the widget ElevatedButton is
  ///
  /// In en, this message translates to:
  /// **'A button with a raised look, for an important action.'**
  String get widgetHelpElevatedButton;

  /// What the widget FilledButton is
  ///
  /// In en, this message translates to:
  /// **'A button filled with colour, for the main action.'**
  String get widgetHelpFilledButton;

  /// What the widget OutlinedButton is
  ///
  /// In en, this message translates to:
  /// **'A button with an outline and no fill, for a secondary action.'**
  String get widgetHelpOutlinedButton;

  /// What the widget TextButton is
  ///
  /// In en, this message translates to:
  /// **'A flat button that looks like text, for the least important action.'**
  String get widgetHelpTextButton;

  /// What the widget IconButton is
  ///
  /// In en, this message translates to:
  /// **'A button that shows only an icon.'**
  String get widgetHelpIconButton;

  /// What the widget TextField is
  ///
  /// In en, this message translates to:
  /// **'A field where the user types text.'**
  String get widgetHelpTextField;

  /// What the widget Checkbox is
  ///
  /// In en, this message translates to:
  /// **'A box the user ticks on or off.'**
  String get widgetHelpCheckbox;

  /// What the widget Switch is
  ///
  /// In en, this message translates to:
  /// **'A switch the user turns on or off.'**
  String get widgetHelpSwitch;

  /// What the widget Slider is
  ///
  /// In en, this message translates to:
  /// **'A bar with a handle for choosing a value in a range.'**
  String get widgetHelpSlider;

  /// What the widget Card is
  ///
  /// In en, this message translates to:
  /// **'A panel with rounded corners and a slight shadow that groups related content.'**
  String get widgetHelpCard;

  /// What the widget ListTile is
  ///
  /// In en, this message translates to:
  /// **'A row of a list with a title, a second line, and an icon at each end.'**
  String get widgetHelpListTile;

  /// What the widget Divider is
  ///
  /// In en, this message translates to:
  /// **'A thin line that separates content.'**
  String get widgetHelpDivider;

  /// What the widget CircleAvatar is
  ///
  /// In en, this message translates to:
  /// **'A circle that holds a picture, an icon or initials, as for a person.'**
  String get widgetHelpCircleAvatar;

  /// What the widget Chip is
  ///
  /// In en, this message translates to:
  /// **'A small element with a label, for a tag, a choice or a filter.'**
  String get widgetHelpChip;

  /// What the widget InkWell is
  ///
  /// In en, this message translates to:
  /// **'Makes its child respond to a tap with the ripple of Material design.'**
  String get widgetHelpInkWell;

  /// What the widget GestureDetector is
  ///
  /// In en, this message translates to:
  /// **'Makes its child respond to taps and other gestures, with no visual effect.'**
  String get widgetHelpGestureDetector;

  /// What the widget Theme is
  ///
  /// In en, this message translates to:
  /// **'Gives everything inside it a colour scheme made from one colour.'**
  String get widgetHelpTheme;

  /// What the widget Component is
  ///
  /// In en, this message translates to:
  /// **'A use of a component of the project: it shows the component, and changing the component changes it here.'**
  String get widgetHelpComponent;

  /// About panel: About this widget
  ///
  /// In en, this message translates to:
  /// **'About this widget'**
  String get aboutTitle;

  /// About panel: Category: {category}
  ///
  /// In en, this message translates to:
  /// **'Category: {category}'**
  String aboutCategory(String category);

  /// About panel: A {category} widget.
  ///
  /// In en, this message translates to:
  /// **'A {category} widget.'**
  String aboutGeneric(String category);

  /// About panel: Holds no other widget.
  ///
  /// In en, this message translates to:
  /// **'Holds no other widget.'**
  String get aboutNoChild;

  /// About panel: Holds one widget.
  ///
  /// In en, this message translates to:
  /// **'Holds one widget.'**
  String get aboutOneChild;

  /// About panel: Holds any number of widgets.
  ///
  /// In en, this message translates to:
  /// **'Holds any number of widgets.'**
  String get aboutManyChildren;

  /// About panel: It needs a widget inside it.
  ///
  /// In en, this message translates to:
  /// **'It needs a widget inside it.'**
  String get aboutNeedsChild;

  /// About panel: Can only go inside: {parents}.
  ///
  /// In en, this message translates to:
  /// **'Can only go inside: {parents}.'**
  String aboutOnlyIn(String parents);

  /// About panel: Cannot go inside: {parents}.
  ///
  /// In en, this message translates to:
  /// **'Cannot go inside: {parents}.'**
  String aboutNotIn(String parents);

  /// About panel: Needs a Material surface around it: {ancestors}.
  ///
  /// In en, this message translates to:
  /// **'Needs a Material surface around it: {ancestors}.'**
  String aboutNeedsMaterial(String ancestors);

  /// About panel: Inside a Row or Column it is placed in an Expanded for you.
  ///
  /// In en, this message translates to:
  /// **'Inside a Row or Column it is placed in an Expanded for you.'**
  String get aboutWrapped;

  /// About panel: Flutter documentation
  ///
  /// In en, this message translates to:
  /// **'Flutter documentation'**
  String get aboutDocs;

  /// About panel: Copy the link
  ///
  /// In en, this message translates to:
  /// **'Copy the link'**
  String get aboutCopyLink;

  /// Palette: Show the widgets as a grid
  ///
  /// In en, this message translates to:
  /// **'Show the widgets as a grid'**
  String get paletteShowGrid;

  /// Palette: Show the widgets as a list
  ///
  /// In en, this message translates to:
  /// **'Show the widgets as a list'**
  String get paletteShowList;

  /// Widget guide: Widget guide
  ///
  /// In en, this message translates to:
  /// **'Widget guide'**
  String get guideTitle;

  /// Widget guide: Search the widgets
  ///
  /// In en, this message translates to:
  /// **'Search the widgets'**
  String get guideSearch;

  /// Widget guide: All
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get guideAll;

  /// Widget guide: button that adds the widget to the screen
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get guideAdd;

  /// Widget guide: Widget guide
  ///
  /// In en, this message translates to:
  /// **'Widget guide'**
  String get menuWidgetGuide;

  /// Welcome tour: Welcome: step {step} of {total}
  ///
  /// In en, this message translates to:
  /// **'Welcome: step {step} of {total}'**
  String tourTitle(int step, int total);

  /// Welcome tour: Add widgets
  ///
  /// In en, this message translates to:
  /// **'Add widgets'**
  String get tourAddTitle;

  /// Welcome tour: Drag widgets from the toolbox onto the screen, or click one to add it where the selection is. The grid and list buttons change how they are shown.
  ///
  /// In en, this message translates to:
  /// **'Drag widgets from the toolbox onto the screen, or click one to add it where the selection is. The grid and list buttons change how they are shown.'**
  String get tourAddBody;

  /// Welcome tour: Change them
  ///
  /// In en, this message translates to:
  /// **'Change them'**
  String get tourEditTitle;

  /// Welcome tour: Select a widget to edit its properties on the right. Hover a property name to see what it does, and read About this widget for where it can go.
  ///
  /// In en, this message translates to:
  /// **'Select a widget to edit its properties on the right. Hover a property name to see what it does, and read About this widget for where it can go.'**
  String get tourEditBody;

  /// Welcome tour: See the code
  ///
  /// In en, this message translates to:
  /// **'See the code'**
  String get tourCodeTitle;

  /// Welcome tour: The code is written as you design, and you can edit it too. Put it beside the screen or below it with the buttons at the bottom.
  ///
  /// In en, this message translates to:
  /// **'The code is written as you design, and you can edit it too. Put it beside the screen or below it with the buttons at the bottom.'**
  String get tourCodeBody;

  /// Welcome tour: Build the whole app
  ///
  /// In en, this message translates to:
  /// **'Build the whole app'**
  String get tourProjectTitle;

  /// Welcome tour: Add screens and components with the plus above the screen, try the navigation with the play button, and export the code from the File menu.
  ///
  /// In en, this message translates to:
  /// **'Add screens and components with the plus above the screen, try the navigation with the play button, and export the code from the File menu.'**
  String get tourProjectBody;

  /// Welcome tour: Skip
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get tourSkip;

  /// Welcome tour: Back
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get tourBack;

  /// Welcome tour: Next
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tourNext;

  /// Welcome tour: Start
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get tourDone;

  /// Welcome tour: Welcome tour
  ///
  /// In en, this message translates to:
  /// **'Welcome tour'**
  String get menuWelcomeTour;

  /// Overview: All the screens
  ///
  /// In en, this message translates to:
  /// **'All the screens'**
  String get overviewTitle;

  /// Overview: {name} (start)
  ///
  /// In en, this message translates to:
  /// **'{name} (start)'**
  String overviewStart(String name);

  /// Overview: See all the screens side by side
  ///
  /// In en, this message translates to:
  /// **'See all the screens side by side'**
  String get designerOverview;

  /// FAQ: Questions and answers
  ///
  /// In en, this message translates to:
  /// **'Questions and answers'**
  String get faqTitle;

  /// FAQ: Questions and answers
  ///
  /// In en, this message translates to:
  /// **'Questions and answers'**
  String get menuFaq;

  /// FAQ: Where is my project saved?
  ///
  /// In en, this message translates to:
  /// **'Where is my project saved?'**
  String get faqSaveQuestion;

  /// FAQ: Save writes a JSON file in the place you choose, w
  ///
  /// In en, this message translates to:
  /// **'Save writes a JSON file in the place you choose, with every screen, component and picture of the project. Open reads it back. Your settings are kept apart, in a folder named .flutter_ui_builder in your home folder.'**
  String get faqSaveAnswer;

  /// FAQ: How do I use the code in my app?
  ///
  /// In en, this message translates to:
  /// **'How do I use the code in my app?'**
  String get faqExportQuestion;

  /// FAQ: Export code writes one file for each screen and co
  ///
  /// In en, this message translates to:
  /// **'Export code writes one file for each screen and component into a folder. Copy them into the lib folder of your Flutter project, add the pictures and the lines for pubspec.yaml shown in the Media panel, and use the class of the first screen as the home of your app.'**
  String get faqExportAnswer;

  /// FAQ: Can I change the code and keep working?
  ///
  /// In en, this message translates to:
  /// **'Can I change the code and keep working?'**
  String get faqCodeQuestion;

  /// FAQ: Yes. Edit the code in the Code panel and press App
  ///
  /// In en, this message translates to:
  /// **'Yes. Edit the code in the Code panel and press Apply: the screen is redrawn from it and the change is one step of undo. Code the editor cannot read is listed and left out, so the screen always stays drawable.'**
  String get faqCodeAnswer;

  /// FAQ: Why can a widget not be added here?
  ///
  /// In en, this message translates to:
  /// **'Why can a widget not be added here?'**
  String get faqCannotAddQuestion;

  /// FAQ: Flutter widgets have rules: an AppBar only goes in
  ///
  /// In en, this message translates to:
  /// **'Flutter widgets have rules: an AppBar only goes in a Scaffold, a ListTile needs a Material surface, a Column cannot hold a ListView without an Expanded. About this widget lists the rules of the selected one, and the filter in the toolbox shows only what fits where you are.'**
  String get faqCannotAddAnswer;

  /// FAQ: How do screens open each other?
  ///
  /// In en, this message translates to:
  /// **'How do screens open each other?'**
  String get faqScreensQuestion;

  /// FAQ: Select a button or another widget that can be pres
  ///
  /// In en, this message translates to:
  /// **'Select a button or another widget that can be pressed and choose the screen it opens in its navigateTo property. In the code it becomes a Navigator.push. The play button of the designer lets you try it by clicking.'**
  String get faqScreensAnswer;

  /// FAQ: What is a component?
  ///
  /// In en, this message translates to:
  /// **'What is a component?'**
  String get faqComponentsQuestion;

  /// FAQ: A widget you make once and use in several places.
  ///
  /// In en, this message translates to:
  /// **'A widget you make once and use in several places. Right-click a widget and choose to make a component of it. Changing the component changes every place it is used.'**
  String get faqComponentsAnswer;

  /// FAQ: What do the problems mean?
  ///
  /// In en, this message translates to:
  /// **'What do the problems mean?'**
  String get faqProblemsQuestion;

  /// FAQ: They are things that will misbehave or be hard to
  ///
  /// In en, this message translates to:
  /// **'They are things that will misbehave or be hard to use, found without running the app: a missing label, text that is hard to read on its background, a button too small to hit, a screen that does not exist. Click one to select the widget.'**
  String get faqProblemsAnswer;

  /// FAQ: How do I undo a change?
  ///
  /// In en, this message translates to:
  /// **'How do I undo a change?'**
  String get faqUndoQuestion;

  /// FAQ: With the undo button or Cmd/Ctrl+Z, and redo with
  ///
  /// In en, this message translates to:
  /// **'With the undo button or Cmd/Ctrl+Z, and redo with Cmd/Ctrl+Shift+Z. Opening another screen is not a change and is not undone.'**
  String get faqUndoAnswer;

  /// Theme panel: Theme
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get panelTheme;

  /// Theme panel: The colours and fonts of the whole app, and how ea
  ///
  /// In en, this message translates to:
  /// **'The colours and fonts of the whole app, and how each kind of widget looks. The screens are drawn with this theme, and the code gets it as buildAppTheme.'**
  String get themeIntro;

  /// Theme panel: Back to the defaults
  ///
  /// In en, this message translates to:
  /// **'Back to the defaults'**
  String get themeReset;

  /// Theme panel: Colours and fonts
  ///
  /// In en, this message translates to:
  /// **'Colours and fonts'**
  String get themeScheme;

  /// Theme panel: App bar
  ///
  /// In en, this message translates to:
  /// **'App bar'**
  String get themeAppBar;

  /// Theme panel: Elevated button
  ///
  /// In en, this message translates to:
  /// **'Elevated button'**
  String get themeElevatedButton;

  /// Theme panel: Filled button
  ///
  /// In en, this message translates to:
  /// **'Filled button'**
  String get themeFilledButton;

  /// Theme panel: Outlined button
  ///
  /// In en, this message translates to:
  /// **'Outlined button'**
  String get themeOutlinedButton;

  /// Theme panel: Text button
  ///
  /// In en, this message translates to:
  /// **'Text button'**
  String get themeTextButton;

  /// Theme panel: Card
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get themeCard;

  /// Theme panel: Text fields
  ///
  /// In en, this message translates to:
  /// **'Text fields'**
  String get themeInput;

  /// Theme panel: Floating button
  ///
  /// In en, this message translates to:
  /// **'Floating button'**
  String get themeFab;

  /// Theme panel: List tile
  ///
  /// In en, this message translates to:
  /// **'List tile'**
  String get themeListTile;

  /// Theme panel: Divider
  ///
  /// In en, this message translates to:
  /// **'Divider'**
  String get themeDivider;

  /// Tooltip of the property seedColor
  ///
  /// In en, this message translates to:
  /// **'The colour the whole colour scheme is made from: Flutter derives the primary, secondary and surface colours from it.'**
  String get propHelpSeedColor;

  /// Tooltip of the property brightness
  ///
  /// In en, this message translates to:
  /// **'Whether the theme is light or dark.'**
  String get propHelpBrightness;

  /// Tooltip of the property useMaterial3
  ///
  /// In en, this message translates to:
  /// **'Uses the current Material 3 design rather than the older Material 2 one.'**
  String get propHelpUseMaterial3;

  /// Tooltip of the property filled
  ///
  /// In en, this message translates to:
  /// **'Fills the field with a colour.'**
  String get propHelpFilled;

  /// Tooltip of the property fillColor
  ///
  /// In en, this message translates to:
  /// **'The colour a filled field is filled with.'**
  String get propHelpFillColor;

  /// Tooltip of the property thickness
  ///
  /// In en, this message translates to:
  /// **'How thick the line is.'**
  String get propHelpThickness;

  /// Tooltip of the property iconColor
  ///
  /// In en, this message translates to:
  /// **'The colour of the icons.'**
  String get propHelpIconColor;

  /// Tooltip of the property textColor
  ///
  /// In en, this message translates to:
  /// **'The colour of the text.'**
  String get propHelpTextColor;

  /// Tooltip of the property tileColor
  ///
  /// In en, this message translates to:
  /// **'The colour behind the row.'**
  String get propHelpTileColor;
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
