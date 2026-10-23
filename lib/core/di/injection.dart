import 'package:flutter_ui_builder/features/editor/data/datasources/file_dialog_data_source.dart';
import 'package:flutter_ui_builder/features/editor/data/datasources/local_file_data_source.dart';
import 'package:flutter_ui_builder/features/editor/data/repositories/code_export_repository_impl.dart';
import 'package:flutter_ui_builder/features/editor/data/repositories/document_repository_impl.dart';
import 'package:flutter_ui_builder/features/editor/data/repositories/file_dialog_repository_impl.dart';
import 'package:flutter_ui_builder/features/editor/data/repositories/source_file_repository_impl.dart';
import 'package:flutter_ui_builder/features/editor/data/services/analyzer_code_parser.dart';
import 'package:flutter_ui_builder/features/editor/data/services/dart_style_code_formatter.dart';
import 'package:flutter_ui_builder/features/editor/data/services/document_json_codec.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/code_importer.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/code_parser.dart';
import 'package:flutter_ui_builder/features/editor/domain/repositories/code_export_repository.dart';
import 'package:flutter_ui_builder/features/editor/domain/repositories/document_repository.dart';
import 'package:flutter_ui_builder/features/editor/domain/repositories/file_dialog_repository.dart';
import 'package:flutter_ui_builder/features/editor/domain/repositories/source_file_repository.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/code_formatter.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_code_generator.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_linter.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_validator.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/drop_planner.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/tree_editor.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/code_usecases.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/import_usecases.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/lint_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/project_usecases.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/code_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/code_edit_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/drag_session_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_use_cases.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/import_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/problems_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/project_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_settings.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/builtin_previews.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_registry.dart';
import 'package:flutter_ui_builder/features/settings/data/datasources/settings_path.dart';
import 'package:flutter_ui_builder/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:flutter_ui_builder/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter_ui_builder/features/settings/domain/usecases/settings_usecases.dart';
import 'package:flutter_ui_builder/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:talker/talker.dart';

final GetIt sl = GetIt.instance;

/// Registers every dependency of the app, one init function per feature.
Future<void> configureDependencies() async {
  _initCore();
  _initEditor();
}

void _initCore() {
  sl
    ..registerSingleton<Talker>(Talker())
    ..registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(sl(), settingsFilePath()),
    )
    ..registerLazySingleton(() => LoadSettings(sl()))
    ..registerLazySingleton(() => SaveSettings(sl()))
    ..registerLazySingleton(
      () => SettingsCubit(loadSettings: sl(), saveSettings: sl()),
    );
}

void _initEditor() {
  sl
    ..registerFactory(
      () => WorkspaceCubit(workspaceFromSettings(sl<SettingsCubit>().state)),
    )
    ..registerFactory(DragSessionCubit.new)
    ..registerFactory(() => CodeEditCubit(importCode: sl()))
    ..registerFactory(() => ImportCubit(importCode: sl(), pickDartSource: sl()))
    ..registerLazySingleton(() => ImportCode(sl()))
    ..registerLazySingleton(() => PickDartSource(sl()))
    ..registerLazySingleton(() => CodeImporter(sl(), sl()))
    ..registerLazySingleton<CodeParser>(() => const AnalyzerCodeParser())
    ..registerLazySingleton<SourceFileRepository>(
      () => SourceFileRepositoryImpl(sl(), sl(), sl()),
    )
    ..registerFactoryParam<ProblemsCubit, EditorDocument, void>(
      (document, _) => ProblemsCubit(document: document, lintDocument: sl()),
    )
    ..registerLazySingleton(() => LintDocument(sl()))
    ..registerLazySingleton(() => DocumentLinter(sl()))
    ..registerFactoryParam<CodeCubit, EditorDocument, void>(
      (document, _) => CodeCubit(
        document: document,
        generateCode: sl(),
        pickDirectory: sl(),
        exportCode: sl(),
      ),
    )
    ..registerLazySingleton(() => GenerateCode(sl()))
    ..registerLazySingleton(() => PickExportDirectory(sl()))
    ..registerLazySingleton(() => ExportCode(sl()))
    ..registerLazySingleton(() => DocumentCodeGenerator(sl(), sl()))
    ..registerLazySingleton<CodeFormatter>(() => const DartStyleCodeFormatter())
    ..registerLazySingleton<CodeExportRepository>(
      () => CodeExportRepositoryImpl(sl(), sl()),
    )
    ..registerLazySingleton<FileDialogRepository>(
      () => FileDialogRepositoryImpl(sl(), sl()),
    )
    ..registerLazySingleton<LocalFileDataSource>(
      () => const LocalFileDataSourceImpl(),
    )
    ..registerLazySingleton<FileDialogDataSource>(
      () => const FileDialogDataSourceImpl(),
    )
    ..registerFactoryParam<ProjectCubit, EditorDocument, void>(
      (document, _) => ProjectCubit(
        initialDocument: document,
        saveDocument: sl(),
        saveDocumentAs: sl(),
        openDocument: sl(),
        pickImages: sl(),
      ),
    )
    ..registerLazySingleton(() => PickImages(sl()))
    ..registerLazySingleton(() => SaveDocument(sl()))
    ..registerLazySingleton(() => SaveDocumentAs(sl()))
    ..registerLazySingleton(() => OpenDocument(sl(), sl()))
    ..registerLazySingleton(() => DocumentValidator(sl()))
    ..registerLazySingleton(() => const DocumentJsonCodec())
    ..registerLazySingleton<DocumentRepository>(
      () => DocumentRepositoryImpl(sl(), sl(), sl(), sl()),
    )
    ..registerFactoryParam<EditorCubit, EditorDocument, void>(
      (document, _) => EditorCubit(initialDocument: document, useCases: sl()),
    )
    ..registerLazySingleton(
      () => EditorUseCases.from(editor: sl(), planner: sl(), registry: sl()),
    )
    ..registerLazySingleton(() => DropPlanner(sl()))
    ..registerLazySingleton(() => TreeEditor(sl()))
    ..registerLazySingleton(() => WidgetRegistry(builtinDefinitions))
    ..registerLazySingleton(
      () => PreviewRegistry(
        registry: sl(),
        previews: builtinPreviews,
        parentDataTypes: parentDataPreviewTypes,
      ),
    );
}
