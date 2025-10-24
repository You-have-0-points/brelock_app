import 'package:brelock/data/repositories/consumer_repository.dart';
import 'package:brelock/domain/entities/consumer.dart';
import 'package:brelock/di_injector.dart';
import 'package:brelock/domain/entities/folder.dart';
import 'package:brelock/domain/usecases/folder_interactor.dart';
import 'dart:math';
import 'package:otp/otp.dart';

class ConsumerInteractor{
  final ConsumerRepository consumerRepository;
  final FolderInteractor folderInteractor;

  ConsumerInteractor({
    required this.consumerRepository,
    required this.folderInteractor
  });

  Future<void> create(String email, String password) async{
    Consumer consumer = Consumer.base(email, password);
    current_consumer.copy(consumer);
    await folderInteractor.create(null);
    await consumerRepository.create(current_consumer);
  }

  Future<Consumer?> getByLoginData(String email, String password) async{
    return await consumerRepository.getByLoginData(email, password);
  }

  Future<Consumer> getByEmail(String email) async{
    return await consumerRepository.getByEmail(email);
  }

  Future<void> update(Consumer consumer) async{
    await consumerRepository.update(consumer);
  }

  Future<void> deleteFolder(Folder folder, Consumer consumer) async{
    consumer.deleteFolder(folder.id);
    consumerRepository.update(consumer);
  }

  Future<void> enableTwoFactorAuth(String secret) async {
    current_consumer.updateTwoFactorAuth(secret, true);
    await consumerRepository.update(current_consumer);
  }

  Future<void> disableTwoFactorAuth() async {
    current_consumer.updateTwoFactorAuth(null, false);
    await consumerRepository.update(current_consumer);
  }

  Future<bool> verifyTwoFactorCode(String code) async {
    if (!current_consumer.twoFactorEnabled || current_consumer.twoFactorSecret == null) {
      return false;
    }

    return _verifyTotpCode(current_consumer.twoFactorSecret!, code);
  }

  String _generateTotpCode(String secret) {
    return OTP.generateTOTPCodeString(
        secret,
        DateTime.now().millisecondsSinceEpoch,
        algorithm: Algorithm.SHA1,
        isGoogle: true
    );
  }

  bool _verifyTotpCode(String secret, String code) {
    try {
      final generatedCode = OTP.generateTOTPCodeString(
          secret,
          DateTime.now().millisecondsSinceEpoch,
          algorithm: Algorithm.SHA1,
          isGoogle: true
      );

      // Также проверяем предыдущий и следующий интервалы на случай рассинхронизации времени
      final previousCode = OTP.generateTOTPCodeString(
          secret,
          DateTime.now().millisecondsSinceEpoch - 30000,
          algorithm: Algorithm.SHA1,
          isGoogle: true
      );

      final nextCode = OTP.generateTOTPCodeString(
          secret,
          DateTime.now().millisecondsSinceEpoch + 30000,
          algorithm: Algorithm.SHA1,
          isGoogle: true
      );

      return code == generatedCode || code == previousCode || code == nextCode;
    } catch (e) {
      return false;
    }
  }

  String _simpleHash(String input) {
    int hash = 0;
    for (int i = 0; i < input.length; i++) {
      hash = (hash << 5) - hash + input.codeUnitAt(i);
      hash = hash & hash;
    }
    return hash.abs().toString().padLeft(6, '0').substring(0, 6);
  }
}