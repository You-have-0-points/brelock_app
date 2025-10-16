import 'package:brelock/data/repositories/consumer_repository.dart';
import 'package:brelock/domain/entities/consumer.dart';
import 'package:brelock/di_injector.dart';
import 'package:brelock/domain/entities/folder.dart';
import 'package:brelock/domain/usecases/folder_interactor.dart';

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
    //current_consumer.copy(consumer);
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
}