// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Flutter UI Builder';

  @override
  String get editorTitle => 'Editor';

  @override
  String get editorUndo => 'Annulla';

  @override
  String get editorRedo => 'Ripeti';

  @override
  String get errorUnknownNode => 'Il widget selezionato non esiste più';

  @override
  String get errorUnknownParent =>
      'Il contenitore di destinazione non esiste più';

  @override
  String get errorUnknownType => 'Questo tipo di widget non è disponibile';

  @override
  String get errorChildNotAllowed =>
      'Questo widget non può contenere altri widget';

  @override
  String get errorParentFull => 'Questo widget accetta un solo figlio';

  @override
  String get errorInvalidIndex => 'La posizione di rilascio non è valida';

  @override
  String get errorRootProtected =>
      'Il widget radice non può essere spostato o rimosso';

  @override
  String get errorCyclicMove =>
      'Un widget non può essere spostato dentro se stesso';

  @override
  String get errorNothingToUndo => 'Niente da annullare';

  @override
  String get errorNothingToRedo => 'Niente da ripetere';

  @override
  String get editorPaletteTitle => 'Widget';

  @override
  String get editorTreeTitle => 'Albero dei widget';

  @override
  String get editorDelete => 'Elimina il widget selezionato';

  @override
  String get editorCategoryLayout => 'Layout';

  @override
  String get errorUnknownProp => 'Questo widget non ha questa proprietà';

  @override
  String get errorInvalidValue => 'Il valore non è valido per questa proprietà';

  @override
  String get editorPropertiesTitle => 'Proprietà';

  @override
  String get editorNoSelection =>
      'Seleziona un widget per modificarne le proprietà';

  @override
  String get editorInvalidValue => 'Valore non valido';

  @override
  String get editorClearValue => 'Cancella valore';

  @override
  String get editorValueUnset => 'Non impostato';

  @override
  String get editorInsetLeft => 'Sinistra';

  @override
  String get editorInsetTop => 'Alto';

  @override
  String get editorInsetRight => 'Destra';

  @override
  String get editorInsetBottom => 'Basso';

  @override
  String get editorColorHint =>
      'Colore esadecimale, ad esempio 2196F3 o FF2196F3';

  @override
  String get errorStorageAccess => 'Impossibile leggere o scrivere il file';

  @override
  String get errorStorageNotGenerated =>
      'Esiste già un file con questo nome non generato dal builder. Non è stato modificato';

  @override
  String get errorCodeGeneration => 'Il codice generato non è Dart valido';

  @override
  String get editorViewCode => 'Mostra il codice';

  @override
  String get codeTitle => 'Codice generato';

  @override
  String get codeCopy => 'Copia';

  @override
  String get codeCopied => 'Codice copiato';

  @override
  String get codeExport => 'Esporta';

  @override
  String codeExported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count file esportati',
      one: '1 file esportato',
    );
    return '$_temp0';
  }

  @override
  String get commonRetry => 'Riprova';

  @override
  String get errorDocumentInvalidFormat =>
      'Questo file non è un progetto valido';

  @override
  String get errorDocumentUnsupportedVersion =>
      'Questo progetto è stato salvato da una versione più recente dell\'app';

  @override
  String get errorDocumentUnknownWidget =>
      'Questo progetto usa un widget non disponibile';

  @override
  String get errorDocumentInvalidStructure =>
      'La struttura di questo progetto non è valida';

  @override
  String get errorDocumentEmptyName =>
      'Il nome del progetto non può essere vuoto';

  @override
  String get fileMenuTooltip => 'File';

  @override
  String get fileNew => 'Nuovo progetto';

  @override
  String get fileOpen => 'Apri...';

  @override
  String get fileSave => 'Salva';

  @override
  String get fileSaveAs => 'Salva come...';

  @override
  String get fileSaved => 'Progetto salvato';

  @override
  String get fileDiscardTitle => 'Scartare le modifiche non salvate?';

  @override
  String get fileDiscardMessage =>
      'Le modifiche fatte dall\'ultimo salvataggio andranno perse.';

  @override
  String get fileDiscard => 'Scarta';

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonConfirm => 'OK';

  @override
  String get renameTitle => 'Nome del progetto';

  @override
  String editorTitleModified(String name) {
    return '$name (modificato)';
  }

  @override
  String get errorParentNotAllowed =>
      'Questo widget non può essere inserito qui';

  @override
  String get errorSlotTaken => 'Questa parte della schermata è già occupata';

  @override
  String get editorCategoryScreen => 'Schermata';

  @override
  String get editorCategoryText => 'Testo';

  @override
  String get editorCategoryImagesIcons => 'Immagini e icone';

  @override
  String get editorCategoryButtons => 'Pulsanti';

  @override
  String get editorCategoryInput => 'Input';

  @override
  String get editorCategoryInformation => 'Informazioni';

  @override
  String get editorCategoryScrolling => 'Scorrimento';

  @override
  String get editorCategoryPainting => 'Pittura ed effetti';

  @override
  String get editorCategoryAnimation => 'Animazione';

  @override
  String get editorCategoryInteraction => 'Interazione';

  @override
  String get editorCategoryAccessibility => 'Accessibilità';

  @override
  String get editorCategoryCupertino => 'Cupertino';

  @override
  String get editorPaletteSearch => 'Cerca widget';

  @override
  String get settingsThemeTooltip => 'Tema';

  @override
  String get settingsThemeSystem => 'Segui il sistema';

  @override
  String get settingsThemeLight => 'Chiaro';

  @override
  String get settingsThemeDark => 'Scuro';

  @override
  String get errorAncestorRequired =>
      'Questo widget richiede uno Scaffold o una Card sopra di sé';

  @override
  String get errorRootNotAllowed =>
      'Questo widget non può essere la radice di una schermata';

  @override
  String get menuFile => 'File';

  @override
  String get menuEdit => 'Modifica';

  @override
  String get menuView => 'Visualizza';

  @override
  String get menuExportCode => 'Esporta il codice...';

  @override
  String get menuRename => 'Rinomina il progetto...';

  @override
  String get menuToolbox => 'Casella degli strumenti';

  @override
  String get menuOutline => 'Struttura del documento';

  @override
  String get menuProperties => 'Proprietà';

  @override
  String get menuDesign => 'Progettazione';

  @override
  String get menuCode => 'Codice';

  @override
  String get menuTheme => 'Tema';

  @override
  String get panelToolbox => 'Casella degli strumenti';

  @override
  String get panelOutline => 'Struttura del documento';

  @override
  String get panelProperties => 'Proprietà';

  @override
  String get panelClose => 'Chiudi il pannello';

  @override
  String get tabDesign => 'Progettazione';

  @override
  String get tabCode => 'Codice';

  @override
  String get propsSearch => 'Cerca proprietà';

  @override
  String get propsCategorized => 'Per categoria';

  @override
  String get propsAlphabetical => 'In ordine alfabetico';

  @override
  String get propsReset => 'Ripristina il valore predefinito';

  @override
  String get propsNoSelectionTitle => 'Nessuna selezione';

  @override
  String get propsGroupAppearance => 'Aspetto';

  @override
  String get propsGroupLayout => 'Layout';

  @override
  String get propsGroupContent => 'Contenuto';

  @override
  String get propsGroupText => 'Testo';

  @override
  String get propsGroupBehavior => 'Comportamento';

  @override
  String get propsGroupAccessibility => 'Accessibilità';

  @override
  String get propsTypeString => 'Testo';

  @override
  String get propsTypeNumber => 'Numero';

  @override
  String get propsTypeBoolean => 'Sì o no';

  @override
  String get propsTypeColor => 'Colore';

  @override
  String get propsTypeChoice => 'Uno da un elenco';

  @override
  String get propsTypeInsets => 'Quattro lati';

  @override
  String get propsNoDefault => 'Nessun valore predefinito';

  @override
  String get statusReady => 'Pronto';

  @override
  String get statusModified => 'Modificato';

  @override
  String get statusSaved => 'Salvato';

  @override
  String get statusNoSelection => 'Nessuna selezione';

  @override
  String get editorPaletteCannotAdd => 'Non si può aggiungere alla selezione';

  @override
  String get editorDocumentTabTooltip => 'Fai clic per rinominare il progetto';

  @override
  String propsDefault(String value) {
    return 'Predefinito: $value';
  }

  @override
  String statusWidgets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count widget',
      one: '1 widget',
    );
    return '$_temp0';
  }

  @override
  String get errorNoChildren =>
      'Questo widget non contiene nulla che possa prendere il suo posto';

  @override
  String get menuAdd => 'Aggiungi widget';

  @override
  String get menuCut => 'Taglia';

  @override
  String get menuCopy => 'Copia';

  @override
  String get menuPaste => 'Incolla';

  @override
  String get menuDuplicate => 'Duplica';

  @override
  String get menuWrapWith => 'Avvolgi con';

  @override
  String get menuUnwrap => 'Rimuovi involucro';

  @override
  String get menuProblems => 'Problemi';

  @override
  String get problemsEmpty => 'Nessun problema trovato';

  @override
  String get statusProblemsTooltip => 'Mostra i problemi';

  @override
  String get menuNothingToAdd => 'Qui non si può aggiungere nulla';

  @override
  String panelProblems(int count) {
    return 'Problemi ($count)';
  }

  @override
  String problemRequiredChildMissing(String type) {
    return '$type richiede un widget al suo interno; nel codice si usa un riquadro vuoto';
  }

  @override
  String get problemNavigationBarFewDestinations =>
      'Una NavigationBar richiede almeno due destinazioni';

  @override
  String get problemHiddenTextMultiline =>
      'Un campo di testo nascosto può avere una sola riga';

  @override
  String get problemAvatarRadiusConflict =>
      'radius non si può usare insieme a minRadius o maxRadius';

  @override
  String get problemPositionedOverconstrained =>
      'Imposta al massimo due tra left, right e width, e due tra top, bottom e height';

  @override
  String get problemImageWithoutLabel =>
      'L\'immagine non ha un\'etichetta semantica per gli screen reader';

  @override
  String get problemImageWithoutUrl =>
      'L\'immagine non ha un URL e non si caricherà';

  @override
  String get problemSliderRange => 'Il massimo deve essere maggiore del minimo';

  @override
  String get problemThreeLineWithoutSubtitle =>
      'Una voce a tre righe richiede un sottotitolo';

  @override
  String get problemMissingTooltip =>
      'Il pulsante non ha un suggerimento per gli screen reader';

  @override
  String get designerDevicePhone => 'Telefono';

  @override
  String get designerDeviceTablet => 'Tablet';

  @override
  String get designerDeviceDesktop => 'Desktop';

  @override
  String get designerRotate => 'Ruota lo schermo';

  @override
  String get designerZoomIn => 'Ingrandisci';

  @override
  String get designerZoomOut => 'Riduci';

  @override
  String get designerZoomReset => 'Dimensione reale';

  @override
  String get menuZoomIn => 'Ingrandisci';

  @override
  String get menuZoomOut => 'Riduci';

  @override
  String get menuZoomReset => 'Dimensione reale';

  @override
  String get menuAddInside => 'Aggiungi dentro';

  @override
  String get menuAddBeside => 'Aggiungi accanto';

  @override
  String get colorPickerTitle => 'Scegli un colore';

  @override
  String get colorPickerOpen => 'Apri il selettore di colori';

  @override
  String get errorCodeSyntax => 'Il codice contiene errori di sintassi';

  @override
  String get errorCodeNoWidget =>
      'Nessun widget trovato: scrivi una classe widget con un metodo build, oppure un singolo widget';

  @override
  String get menuImportCode => 'Importa codice...';

  @override
  String get importTitle => 'Importa codice';

  @override
  String get importHint =>
      'Incolla il codice Dart di un widget, oppure una singola espressione di widget';

  @override
  String get importRender => 'Mostra';

  @override
  String get importOpenFile => 'Apri un file .dart...';

  @override
  String get importApply => 'Apri nel designer';

  @override
  String get importIssuesTitle => 'Non importato';

  @override
  String get importIssueWrappedInScaffold =>
      'Il codice richiede uno Scaffold attorno, quindi ne è stato aggiunto uno';

  @override
  String importFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count widget trovati',
      one: '1 widget trovato',
    );
    return '$_temp0';
  }

  @override
  String importIssueUnknownWidget(String type) {
    return '$type non è disponibile ed è stato sostituito';
  }

  @override
  String importIssueUnsupportedArgument(String type, String argument) {
    return '$type: l\'argomento $argument non è supportato ed è stato ignorato';
  }

  @override
  String importIssueInvalidValue(String type, String argument) {
    return '$type: il valore di $argument non è leggibile ed è stato ignorato';
  }

  @override
  String get designerFrame => 'Cornice del dispositivo';

  @override
  String get designerSafeArea => 'Mostra l\'area sicura';

  @override
  String get designerStatusBar => 'Barra di stato';

  @override
  String get statusBarAuto => 'Automatica';

  @override
  String get statusBarLight => 'Icone chiare';

  @override
  String get statusBarDark => 'Icone scure';

  @override
  String get statusBarHidden => 'Nascosta';

  @override
  String get codeApply => 'Applica';

  @override
  String get codeRevert => 'Ripristina';

  @override
  String get codeEdited => 'Modificato';

  @override
  String get codeInSync => 'Allineato';

  @override
  String get codeExportAfterApply =>
      'Applica o annulla le modifiche prima di esportare';

  @override
  String dropInside(String type) {
    return 'Dentro $type';
  }

  @override
  String dropBefore(String type) {
    return 'Prima di $type';
  }

  @override
  String dropAfter(String type) {
    return 'Dopo $type';
  }

  @override
  String get outlineSearch => 'Cerca nella struttura';

  @override
  String get menuRenameWidget => 'Rinomina il widget...';

  @override
  String get renameWidgetTitle => 'Nome del widget';

  @override
  String get renameWidgetHint => 'Lascia vuoto per togliere il nome';

  @override
  String get iconPickerTitle => 'Scegli un\'icona';

  @override
  String get iconPickerSearch => 'Cerca icone';

  @override
  String get iconPickerNotSet => 'Nessuna icona';

  @override
  String get propHelpWidth =>
      'Larghezza in pixel logici. Lascia vuoto per adattarla al contenuto o allo spazio del genitore.';

  @override
  String get propHelpHeight =>
      'Altezza in pixel logici. Lascia vuoto per adattarla al contenuto o allo spazio del genitore.';

  @override
  String get propHelpPadding =>
      'Spazio tra il bordo del widget e il suo contenuto, su ogni lato.';

  @override
  String get propHelpMargin =>
      'Spazio attorno all\'esterno del widget, su ogni lato.';

  @override
  String get propHelpAlignment =>
      'Dove si trova il contenuto nello spazio disponibile.';

  @override
  String get propHelpColor =>
      'Il colore usato per riempire o disegnare il widget.';

  @override
  String get propHelpBackgroundColor => 'Il colore dietro al widget.';

  @override
  String get propHelpForegroundColor =>
      'Il colore di testo e icone sopra il widget.';

  @override
  String get propHelpElevation =>
      'Di quanto il widget è sollevato dalla superficie, e quindi la dimensione della sua ombra.';

  @override
  String get propHelpBorderRadius =>
      'Arrotonda i quattro angoli con questo raggio.';

  @override
  String get propHelpBorderColor => 'Il colore del bordo.';

  @override
  String get propHelpBorderWidth => 'Lo spessore del bordo su ogni lato.';

  @override
  String get propHelpShadowColor =>
      'Il colore dell\'ombra. Qualsiasi proprietà dell\'ombra la crea.';

  @override
  String get propHelpShadowBlur =>
      'Quanto è morbido il bordo dell\'ombra. Valori maggiori la sfumano e la allargano.';

  @override
  String get propHelpShadowSpread =>
      'Di quanto l\'ombra è più grande del widget prima di sfumarla.';

  @override
  String get propHelpShadowOffsetX =>
      'Sposta l\'ombra di lato. I valori positivi vanno a destra.';

  @override
  String get propHelpShadowOffsetY =>
      'Sposta l\'ombra in alto o in basso. I valori positivi vanno in basso.';

  @override
  String get propHelpGradientStart =>
      'Il primo colore di una sfumatura. Impostare uno dei due colori la crea.';

  @override
  String get propHelpGradientEnd => 'L\'ultimo colore di una sfumatura.';

  @override
  String get propHelpGradientDirection =>
      'La direzione in cui corre la sfumatura.';

  @override
  String get propHelpFontSize =>
      'La dimensione delle lettere, in pixel logici.';

  @override
  String get propHelpFontWeight => 'Quanto sono spessi i tratti delle lettere.';

  @override
  String get propHelpFontFamily =>
      'Il nome del carattere. Deve essere disponibile nell\'app.';

  @override
  String get propHelpTextAlign =>
      'Come si allineano orizzontalmente le righe di testo.';

  @override
  String get propHelpMaxLines =>
      'Il massimo di righe che il testo può usare. Lascia vuoto per nessun limite.';

  @override
  String get propHelpOverflow => 'Cosa succede al testo che non entra.';

  @override
  String get propHelpLetterSpacing => 'Spazio extra tra le lettere.';

  @override
  String get propHelpFlex =>
      'Quanto dello spazio libero prende questo widget rispetto ai fratelli.';

  @override
  String get propHelpSpacing => 'Spazio tra i figli.';

  @override
  String get propHelpMainAxisAlignment =>
      'Come i figli sono disposti lungo la direzione principale: in verticale in una Column, in orizzontale in una Row.';

  @override
  String get propHelpCrossAxisAlignment =>
      'Come i figli sono disposti trasversalmente alla direzione principale.';

  @override
  String get propHelpMainAxisSize =>
      'Se il widget occupa tutto lo spazio lungo la sua direzione principale o solo quello che serve ai figli.';

  @override
  String get propHelpFit =>
      'Come il contenuto viene dimensionato per riempire lo spazio.';

  @override
  String get propHelpTitle => 'Il testo principale del widget.';

  @override
  String get propHelpSubtitle =>
      'Una riga di testo più piccola sotto al titolo.';

  @override
  String get propHelpLabel => 'Il testo che dà il nome al widget.';

  @override
  String get propHelpIcon =>
      'L\'icona mostrata. Fai clic per cercare tra tutte le icone Material.';

  @override
  String get propHelpUrl =>
      'L\'indirizzo, il percorso dell\'asset o del file dell\'immagine, secondo la sorgente.';

  @override
  String get propHelpSource =>
      'Da dove viene l\'immagine: il web, un asset incluso o un file.';

  @override
  String get propHelpValue => 'Il valore attuale del controllo.';

  @override
  String get propHelpMin =>
      'Il valore più piccolo che il controllo può assumere.';

  @override
  String get propHelpMax =>
      'Il valore più grande che il controllo può assumere.';

  @override
  String get propHelpEnabled => 'Se il controllo risponde all\'utente.';

  @override
  String get propHelpObscureText =>
      'Nasconde ciò che si scrive, come per una password.';

  @override
  String get propHelpKeyboardType =>
      'Il tipo di tastiera mostrata per il campo.';

  @override
  String get propHelpDuration => 'Quanto dura l\'animazione, in millisecondi.';

  @override
  String get propHelpCurve => 'Come l\'animazione accelera e rallenta.';

  @override
  String get propHelpOpacity =>
      'Quanto è opaco il widget: 1 è pieno, 0 è invisibile.';

  @override
  String get propHelpScale =>
      'Di quanto il widget è ingrandito o ridotto: 1 è la sua dimensione.';

  @override
  String get propHelpTooltip =>
      'Il testo mostrato quando il puntatore si ferma sul widget, e letto dagli screen reader.';

  @override
  String get propHelpSemanticLabel =>
      'Cosa dice uno screen reader per questo widget.';

  @override
  String get propHelpStatusBarStyle =>
      'Se la barra di stato mostra icone chiare o scure sopra questa barra.';

  @override
  String get propHelpCenterTitle =>
      'Centra il titolo invece di metterlo all\'inizio.';

  @override
  String get propHelpShape =>
      'Il contorno del widget: un rettangolo o un cerchio.';

  @override
  String propsOptions(String list) {
    return 'Opzioni: $list';
  }

  @override
  String propsCodeArgument(String argument) {
    return 'Nel codice: $argument';
  }

  @override
  String propsGroupedArgument(String argument, String group) {
    return 'Nel codice: $argument di $group';
  }

  @override
  String get problemCircleWithRadius =>
      'Un cerchio non ha angoli: il raggio è ignorato e Flutter lo rifiuta';

  @override
  String get problemLowContrast =>
      'Il colore del testo è troppo vicino allo sfondo per leggerlo bene (le WCAG chiedono 4,5:1)';

  @override
  String get problemSmallTapTarget =>
      'Il bersaglio del tocco è più piccolo di 48 pixel e si colpisce con difficoltà';

  @override
  String get codeAsTab => 'Codice in una scheda';

  @override
  String get codeBeside => 'Codice accanto al designer';

  @override
  String get codeBelow => 'Codice sotto il designer';

  @override
  String get outlineCollapseAll => 'Comprimi tutto';

  @override
  String get outlineExpandAll => 'Espandi tutto';

  @override
  String get paletteRecent => 'Aggiunti di recente';

  @override
  String get paletteOnlyFitting => 'Mostra solo ciò che si può aggiungere qui';

  @override
  String get paletteNoMatches => 'Nessun widget corrisponde alla ricerca';

  @override
  String get paletteTakesNoChild => 'Non accetta figli';

  @override
  String get paletteTakesOneChild => 'Accetta un figlio';

  @override
  String get paletteTakesChildren => 'Accetta più figli';

  @override
  String get paletteClickToAdd =>
      'Fai clic per aggiungere, oppure trascina sullo schermo o sulla struttura';

  @override
  String get errorScreenDuplicate => 'Un\'altra schermata ha già questo nome';

  @override
  String get errorScreenLast =>
      'Un progetto ha bisogno di almeno una schermata';

  @override
  String get errorScreenUnknown => 'Questa schermata non esiste più';

  @override
  String get problemUnknownScreen =>
      'Questo widget apre una schermata che non esiste';

  @override
  String get screenNew => 'Nuova schermata';

  @override
  String get screenNewTitle => 'Nuova schermata';

  @override
  String get screenNameHint => 'Nome della schermata';

  @override
  String screenDefaultName(int number) {
    return 'Schermata $number';
  }

  @override
  String screenOpenTooltip(String name) {
    return 'Apri $name';
  }

  @override
  String get screenRename => 'Rinomina la schermata';

  @override
  String get screenMakeHome => 'Imposta come schermata iniziale';

  @override
  String get screenDelete => 'Elimina la schermata';

  @override
  String get screenNavigateNone => 'Non apre nessuna schermata';

  @override
  String get screenNavigateBack => 'Torna indietro';

  @override
  String get screenOpenTarget => 'Apri la schermata di destinazione';

  @override
  String get designerPrototype =>
      'Prova la navigazione: un clic su un widget apre la sua schermata';

  @override
  String get problemUnknownComponent =>
      'Questo widget mostra un componente che non esiste';

  @override
  String get problemComponentCycle =>
      'Questo componente finirebbe per contenere se stesso';

  @override
  String get editorCategoryComponents => 'Componenti';

  @override
  String get componentNew => 'Nuovo componente';

  @override
  String get componentNewTitle => 'Nuovo componente';

  @override
  String componentDefaultName(int number) {
    return 'Componente $number';
  }

  @override
  String get componentExtract => 'Crea un componente da questo widget';

  @override
  String get componentExtractTitle => 'Nome del componente';

  @override
  String get componentDetach => 'Stacca dal componente';

  @override
  String get componentEdit => 'Modifica il componente';

  @override
  String get componentNone => 'Nessun componente';

  @override
  String get componentOpenTarget => 'Apri il componente';

  @override
  String get screenNewScreen => 'Nuova schermata';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsGeneral => 'Generali';

  @override
  String get settingsDesigner => 'Designer';

  @override
  String get settingsEditor => 'Editor';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsLanguageSystem => 'Segui il sistema';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsDevice => 'Dispositivo';

  @override
  String get settingsStatusBar => 'Barra di stato';

  @override
  String get settingsShowFrame => 'Disegna la cornice del dispositivo';

  @override
  String get settingsShowSafeArea => 'Mostra l\'area sicura';

  @override
  String get settingsCodePlacement => 'Pannello del codice';

  @override
  String get menuSettings => 'Impostazioni...';

  @override
  String get commonClose => 'Chiudi';

  @override
  String get menuShortcuts => 'Scorciatoie da tastiera';

  @override
  String get menuHelp => 'Aiuto';

  @override
  String get shortcutsStructure => 'Struttura';

  @override
  String get shortcutSelectNext => 'Seleziona il widget successivo';

  @override
  String get shortcutSelectPrevious => 'Seleziona il widget precedente';

  @override
  String get shortcutSelectParent => 'Seleziona il widget genitore';

  @override
  String get shortcutSelectFirstChild => 'Seleziona il primo figlio';

  @override
  String get shortcutMoveDown => 'Sposta il widget in basso';

  @override
  String get shortcutMoveUp => 'Sposta il widget in alto';

  @override
  String get panelMedia => 'Media';

  @override
  String get mediaAdd => 'Aggiungi immagini...';

  @override
  String get mediaEmpty =>
      'Ancora nessuna immagine. Aggiungine per usarle nei widget Image.';

  @override
  String get mediaUseTooltip =>
      'Fai clic per aggiungere un Image che la mostra';

  @override
  String get mediaRemove => 'Rimuovi l\'immagine';

  @override
  String get mediaPubspec => 'Aggiungi questo a pubspec.yaml';

  @override
  String get mediaCopyPubspec => 'Copia';

  @override
  String get assetNone => 'Nessuna immagine';

  @override
  String get templateBlank => 'Schermata vuota';

  @override
  String get templateLogin => 'Accesso';

  @override
  String get templateSettings => 'Elenco impostazioni';

  @override
  String get templateProfile => 'Profilo';

  @override
  String get templateInbox => 'Posta in arrivo';

  @override
  String get templateOnboarding => 'Benvenuto';

  @override
  String get widgetHelpScaffold =>
      'La struttura base di una schermata: contiene barra superiore, corpo, pulsante flottante e barra inferiore, e dà ai contenuti una superficie Material.';

  @override
  String get widgetHelpAppBar =>
      'La barra in cima a una schermata, con un titolo e spazio per icone che agiscono sulla schermata.';

  @override
  String get widgetHelpBottomAppBar =>
      'Una barra in fondo alla schermata che contiene azioni, spesso accanto a un pulsante flottante.';

  @override
  String get widgetHelpNavigationBar =>
      'La barra in basso per spostarsi tra i luoghi principali di un\'app.';

  @override
  String get widgetHelpFloatingActionButton =>
      'Un pulsante tondo che galleggia sul contenuto per l\'azione principale della schermata.';

  @override
  String get widgetHelpColumn => 'Dispone i figli uno sotto l\'altro.';

  @override
  String get widgetHelpRow => 'Dispone i figli uno accanto all\'altro.';

  @override
  String get widgetHelpStack =>
      'Sovrappone i figli, che possono quindi coprirsi a vicenda.';

  @override
  String get widgetHelpContainer =>
      'Una scatola che può avere dimensioni, margine, padding, colore, bordo, ombra e forma.';

  @override
  String get widgetHelpPadding => 'Aggiunge spazio vuoto attorno al figlio.';

  @override
  String get widgetHelpCenter =>
      'Mette il figlio al centro dello spazio disponibile.';

  @override
  String get widgetHelpAlign =>
      'Mette il figlio in un punto scelto dello spazio disponibile.';

  @override
  String get widgetHelpSizedBox =>
      'Una scatola di dimensioni fisse. Senza figlio è uno spazio vuoto.';

  @override
  String get widgetHelpExpanded =>
      'Fa riempire al figlio lo spazio libero di una Row o di una Column.';

  @override
  String get widgetHelpFlexible =>
      'Lascia che il figlio prenda spazio libero in una Row o Column, senza doverlo riempire.';

  @override
  String get widgetHelpSpacer =>
      'Uno spazio vuoto che prende lo spazio libero di una Row o Column.';

  @override
  String get widgetHelpSafeArea =>
      'Tiene il figlio lontano da notch, barra di stato e dalle altre parti dello schermo coperte dal sistema.';

  @override
  String get widgetHelpSingleChildScrollView =>
      'Permette di scorrere un figlio più alto dello schermo.';

  @override
  String get widgetHelpWrap =>
      'Dispone i figli in una riga e va a capo quando non c\'è più spazio.';

  @override
  String get widgetHelpListView =>
      'Un elenco che scorre, costruito dai suoi figli.';

  @override
  String get widgetHelpGridView =>
      'Una griglia che scorre, con un numero fisso di colonne.';

  @override
  String get widgetHelpText =>
      'Mostra un testo, con dimensione, peso e colore.';

  @override
  String get widgetHelpImage =>
      'Mostra un\'immagine dal web, dal progetto o da un file.';

  @override
  String get widgetHelpIcon => 'Mostra una delle icone Material.';

  @override
  String get widgetHelpElevatedButton =>
      'Un pulsante in rilievo, per un\'azione importante.';

  @override
  String get widgetHelpFilledButton =>
      'Un pulsante pieno di colore, per l\'azione principale.';

  @override
  String get widgetHelpOutlinedButton =>
      'Un pulsante con bordo e senza riempimento, per un\'azione secondaria.';

  @override
  String get widgetHelpTextButton =>
      'Un pulsante piatto che sembra testo, per l\'azione meno importante.';

  @override
  String get widgetHelpIconButton => 'Un pulsante che mostra solo un\'icona.';

  @override
  String get widgetHelpTextField =>
      'Un campo in cui l\'utente scrive del testo.';

  @override
  String get widgetHelpCheckbox => 'Una casella che l\'utente spunta o toglie.';

  @override
  String get widgetHelpSwitch =>
      'Un interruttore che l\'utente accende o spegne.';

  @override
  String get widgetHelpSlider =>
      'Una barra con un cursore per scegliere un valore in un intervallo.';

  @override
  String get widgetHelpCard =>
      'Un pannello con angoli arrotondati e una leggera ombra che raggruppa contenuti collegati.';

  @override
  String get widgetHelpListTile =>
      'Una riga di un elenco con un titolo, una seconda riga e un\'icona a ciascun estremo.';

  @override
  String get widgetHelpDivider => 'Una linea sottile che separa i contenuti.';

  @override
  String get widgetHelpCircleAvatar =>
      'Un cerchio che contiene un\'immagine, un\'icona o delle iniziali, come per una persona.';

  @override
  String get widgetHelpChip =>
      'Un piccolo elemento con un\'etichetta, per un tag, una scelta o un filtro.';

  @override
  String get widgetHelpInkWell =>
      'Fa rispondere il figlio al tocco con l\'increspatura del Material design.';

  @override
  String get widgetHelpGestureDetector =>
      'Fa rispondere il figlio a tocchi e altri gesti, senza effetti visivi.';

  @override
  String get widgetHelpTheme =>
      'Dà a tutto ciò che contiene uno schema di colori ricavato da un solo colore.';

  @override
  String get widgetHelpComponent =>
      'Un uso di un componente del progetto: mostra il componente, e modificare il componente lo cambia anche qui.';

  @override
  String get aboutTitle => 'Informazioni sul widget';

  @override
  String aboutCategory(String category) {
    return 'Categoria: $category';
  }

  @override
  String aboutGeneric(String category) {
    return 'Un widget della categoria $category.';
  }

  @override
  String get aboutNoChild => 'Non contiene altri widget.';

  @override
  String get aboutOneChild => 'Contiene un solo widget.';

  @override
  String get aboutManyChildren => 'Contiene un numero qualsiasi di widget.';

  @override
  String get aboutNeedsChild => 'Ha bisogno di un widget al suo interno.';

  @override
  String aboutOnlyIn(String parents) {
    return 'Può stare solo dentro: $parents.';
  }

  @override
  String aboutNotIn(String parents) {
    return 'Non può stare dentro: $parents.';
  }

  @override
  String aboutNeedsMaterial(String ancestors) {
    return 'Ha bisogno di una superficie Material attorno: $ancestors.';
  }

  @override
  String get aboutWrapped =>
      'In una Row o Column viene messo in un Expanded per te.';

  @override
  String get aboutDocs => 'Documentazione di Flutter';

  @override
  String get aboutCopyLink => 'Copia il link';

  @override
  String get paletteShowGrid => 'Mostra i widget in griglia';

  @override
  String get paletteShowList => 'Mostra i widget in elenco';

  @override
  String get guideTitle => 'Guida ai widget';

  @override
  String get guideSearch => 'Cerca tra i widget';

  @override
  String get guideAll => 'Tutti';

  @override
  String get guideAdd => 'Aggiungi';

  @override
  String get menuWidgetGuide => 'Guida ai widget';

  @override
  String tourTitle(int step, int total) {
    return 'Benvenuto: passo $step di $total';
  }

  @override
  String get tourAddTitle => 'Aggiungi i widget';

  @override
  String get tourAddBody =>
      'Trascina i widget dalla casella degli strumenti sulla schermata, oppure fai clic su uno per aggiungerlo dove c\'è la selezione. I pulsanti griglia ed elenco cambiano come sono mostrati.';

  @override
  String get tourEditTitle => 'Modificali';

  @override
  String get tourEditBody =>
      'Seleziona un widget per modificarne le proprietà a destra. Passa sul nome di una proprietà per vedere cosa fa e leggi Informazioni sul widget per sapere dove può stare.';

  @override
  String get tourCodeTitle => 'Guarda il codice';

  @override
  String get tourCodeBody =>
      'Il codice viene scritto mentre disegni e puoi modificarlo anche tu. Mettilo accanto alla schermata o sotto con i pulsanti in basso.';

  @override
  String get tourProjectTitle => 'Costruisci tutta l\'app';

  @override
  String get tourProjectBody =>
      'Aggiungi schermate e componenti con il più sopra la schermata, prova la navigazione con il pulsante di riproduzione ed esporta il codice dal menu File.';

  @override
  String get tourSkip => 'Salta';

  @override
  String get tourBack => 'Indietro';

  @override
  String get tourNext => 'Avanti';

  @override
  String get tourDone => 'Inizia';

  @override
  String get menuWelcomeTour => 'Tutorial di benvenuto';

  @override
  String get overviewTitle => 'Tutte le schermate';

  @override
  String overviewStart(String name) {
    return '$name (iniziale)';
  }

  @override
  String get designerOverview => 'Vedi tutte le schermate affiancate';

  @override
  String get faqTitle => 'Domande e risposte';

  @override
  String get menuFaq => 'Domande e risposte';

  @override
  String get faqSaveQuestion => 'Dove viene salvato il mio progetto?';

  @override
  String get faqSaveAnswer =>
      'Salva scrive un file JSON nel posto che scegli, con tutte le schermate, i componenti e le immagini del progetto. Apri lo rilegge. Le tue impostazioni stanno a parte, in una cartella chiamata .flutter_ui_builder nella tua cartella personale.';

  @override
  String get faqExportQuestion => 'Come uso il codice nella mia app?';

  @override
  String get faqExportAnswer =>
      'Esporta il codice scrive un file per ogni schermata e componente in una cartella. Copiali nella cartella lib del tuo progetto Flutter, aggiungi le immagini e le righe per pubspec.yaml mostrate nel pannello Media, e usa la classe della prima schermata come home della tua app.';

  @override
  String get faqCodeQuestion =>
      'Posso cambiare il codice e continuare a lavorare?';

  @override
  String get faqCodeAnswer =>
      'Sì. Modifica il codice nel pannello Codice e premi Applica: la schermata viene ridisegnata da esso e la modifica è un solo passo di annullamento. Il codice che l\'editor non sa leggere viene elencato e lasciato fuori, così la schermata resta sempre disegnabile.';

  @override
  String get faqCannotAddQuestion =>
      'Perché un widget non si può aggiungere qui?';

  @override
  String get faqCannotAddAnswer =>
      'I widget di Flutter hanno regole: una AppBar sta solo in uno Scaffold, un ListTile ha bisogno di una superficie Material, una Column non può contenere una ListView senza un Expanded. Informazioni sul widget elenca le regole di quello selezionato e il filtro nella casella degli strumenti mostra solo ciò che entra dove ti trovi.';

  @override
  String get faqScreensQuestion => 'Come si aprono le schermate tra loro?';

  @override
  String get faqScreensAnswer =>
      'Seleziona un pulsante o un altro widget che si può premere e scegli la schermata che apre nella sua proprietà navigateTo. Nel codice diventa un Navigator.push. Il pulsante di riproduzione del designer ti permette di provarlo facendo clic.';

  @override
  String get faqComponentsQuestion => 'Che cos\'è un componente?';

  @override
  String get faqComponentsAnswer =>
      'Un widget che crei una volta e usi in più punti. Fai clic destro su un widget e scegli di farne un componente. Cambiare il componente lo cambia in ogni punto in cui è usato.';

  @override
  String get faqProblemsQuestion => 'Che cosa significano i problemi?';

  @override
  String get faqProblemsAnswer =>
      'Sono cose che funzioneranno male o saranno difficili da usare, trovate senza avviare l\'app: un\'etichetta mancante, un testo difficile da leggere sul suo sfondo, un pulsante troppo piccolo da colpire, una schermata che non esiste. Fai clic su uno per selezionare il widget.';

  @override
  String get faqUndoQuestion => 'Come annullo una modifica?';

  @override
  String get faqUndoAnswer =>
      'Con il pulsante annulla o Cmd/Ctrl+Z, e ripeti con Cmd/Ctrl+Shift+Z. Aprire un\'altra schermata non è una modifica e non si annulla.';

  @override
  String get panelTheme => 'Tema';

  @override
  String get themeIntro =>
      'I colori e i caratteri di tutta l\'app, e l\'aspetto di ogni tipo di widget. Le schermate sono disegnate con questo tema e il codice lo riceve come buildAppTheme.';

  @override
  String get themeReset => 'Torna ai valori predefiniti';

  @override
  String get themeScheme => 'Colori e caratteri';

  @override
  String get themeAppBar => 'Barra superiore';

  @override
  String get themeElevatedButton => 'Pulsante in rilievo';

  @override
  String get themeFilledButton => 'Pulsante pieno';

  @override
  String get themeOutlinedButton => 'Pulsante con bordo';

  @override
  String get themeTextButton => 'Pulsante di testo';

  @override
  String get themeCard => 'Card';

  @override
  String get themeInput => 'Campi di testo';

  @override
  String get themeFab => 'Pulsante flottante';

  @override
  String get themeListTile => 'Riga di elenco';

  @override
  String get themeDivider => 'Divisore';

  @override
  String get propHelpSeedColor =>
      'Il colore da cui è ricavato tutto lo schema di colori: Flutter ne deriva i colori primario, secondario e di superficie.';

  @override
  String get propHelpBrightness => 'Se il tema è chiaro o scuro.';

  @override
  String get propHelpUseMaterial3 =>
      'Usa l\'attuale design Material 3 invece del vecchio Material 2.';

  @override
  String get propHelpFilled => 'Riempie il campo con un colore.';

  @override
  String get propHelpFillColor =>
      'Il colore con cui è riempito un campo pieno.';

  @override
  String get propHelpThickness => 'Quanto è spessa la linea.';

  @override
  String get propHelpIconColor => 'Il colore delle icone.';

  @override
  String get propHelpTextColor => 'Il colore del testo.';

  @override
  String get propHelpTileColor => 'Il colore dietro la riga.';

  @override
  String get errorParameterInvalid =>
      'Questa proprietà non può essere un parametro, oppure il nome non è valido. Usa un nome come titolo o coloreCard.';

  @override
  String get paramBind =>
      'Rendi un parametro: ogni uso del componente può dare il suo valore';

  @override
  String get paramUnbind => 'Libera dal parametro';

  @override
  String get paramBindTitle => 'Nome del parametro';

  @override
  String get paramNameHint => 'Un nome come titolo o coloreCard';
}
