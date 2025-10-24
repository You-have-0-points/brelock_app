import 'package:brelock/domain/entities/consumer.dart';
import 'package:brelock/domain/usecases/folder_interactor.dart';
import 'package:brelock/domain/usecases/password_interactor.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:brelock/data/data_sources/subabase_datasource.dart';
import 'package:brelock/data/data_sources/consumer_datasource.dart';
import 'package:brelock/data/data_sources/folder_datasource.dart';
import 'package:brelock/data/data_sources/password_datasource.dart';

import 'package:brelock/data/repositories/folder_repository.dart';
import 'package:brelock/data/repositories/password_repository.dart';
import 'package:brelock/data/repositories/consumer_repository.dart';

import 'package:brelock/data/translators/consumer_setting_translator.dart';
import 'package:brelock/data/translators/consumer_translator.dart';
import 'package:brelock/data/translators/folder_translator.dart';
import 'package:brelock/data/translators/password_translator.dart';
import 'package:brelock/data/translators/service_translator.dart';

import 'package:brelock/domain/usecases/consumer_interactor.dart';
import 'package:brelock/domain/usecases/export_interactor.dart';
import 'package:brelock/domain/usecases/import_interactor.dart';

import 'package:brelock/domain/usecases/breach_check_interactor.dart';
import 'package:brelock/domain/usecases/password_analytics_interactor.dart';


final supabase = Supabase.instance.client;
SupabaseDataSource dataSource = SupabaseDataSource(supabase);
ConsumerDatasource consumerDatasource = ConsumerDatasource(supabase);
FolderDatasource folderDatasource = FolderDatasource(supabase);
PasswordDatasource passwordDatasource = PasswordDatasource(supabase);

ConsumerSettingsTranslator consumerSettingsTranslator = ConsumerSettingsTranslator();
ConsumerTranslator consumerTranslator = ConsumerTranslator(consumerSettingsTranslator);
FolderTranslator folderTranslator = FolderTranslator();
ServiceTranslator serviceTranslator = ServiceTranslator();
PasswordTranslator passwordTranslator = PasswordTranslator(serviceTranslator);

FolderRepository folderRepository = FolderRepository(dataSource: folderDatasource, folderTranslator: folderTranslator);
PasswordRepository passwordRepository = PasswordRepository(dataSource: passwordDatasource, passwordTranslator: passwordTranslator);
ConsumerRepository consumerRepository = ConsumerRepository(dataSource: consumerDatasource, translator: consumerTranslator, settingsTranslator: consumerSettingsTranslator);

FolderInteractor folderInteractor = FolderInteractor(folderRepository: folderRepository);
PasswordInteractor passwordInteractor = PasswordInteractor(passwordRepository);
ConsumerInteractor consumerInteractor = ConsumerInteractor(consumerRepository: consumerRepository, folderInteractor: folderInteractor);
ExportInteractor exportInteractor = ExportInteractor(
  passwordInteractor: passwordInteractor,
  folderInteractor: folderInteractor,
);

ImportInteractor importInteractor = ImportInteractor(
  passwordInteractor: passwordInteractor,
  folderInteractor: folderInteractor,
);

BreachCheckInteractor breachCheckInteractor = BreachCheckInteractor(
  passwordInteractor: passwordInteractor,
);

final PasswordAnalyticsInteractor passwordAnalyticsInteractor = PasswordAnalyticsInteractor(
  passwordInteractor: passwordInteractor,
);

Consumer current_consumer = Consumer.empty();
