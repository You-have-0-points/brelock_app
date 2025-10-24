import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brelock/core/errors/NotFoundException.dart';
import 'package:brelock/core/errors/DublicateException.dart';

class SupabaseDataSource {
  final SupabaseClient _client;

  SupabaseDataSource(this._client);

  Future<void> create(Map<String, dynamic> consumerData) async{
    try{
      await _client.from("consumers").insert(consumerData);
    }catch(e){
      throw DublicateException(e.toString());
    }
  }

  Future<bool> login(String email, String password) async{
    try{
       final response = await _client.from("consumers").select().match({
         'email': email,
         'password': password
       });
       if(!response.isEmpty)
         return true;
       else
         return false;
    }catch(e){
      throw DublicateException(e.toString());
      //TODO: maybe i need smth like DataSourceException, but better read documentation about errors in subabase
    }
  }

  Future<Map<String, dynamic>> getConsumerByLoginData(String email, String password) async{
    try {
      final response = await _client.from("consumers").select().match({
        'email': email,
        'password': password
      }).single();
      return Map<String, dynamic>.from(response);
    }catch(e){
      throw NotFoundException(e.toString());
    }
  }

  Future<Map<String, dynamic>> getConsumerById(String id) async{
    try {
      final response = await _client
          .from('consumers')
          .select()
          .eq('id', id)
          .single();
      return Map<String, dynamic>.from(response);
    }catch(e){
      throw NotFoundException(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getConsumersByEmail(String email) async {
    try {
      final response = await _client
          .from('consumers')
          .select()
          .eq('email', email)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw NotFoundException(e.toString());
    }
  }

  Future<void> updateConsumer(String id, Map<String, dynamic> consumerData) async {
    try {
      await _client.from('consumers').update(consumerData).eq('id', id);
    }catch(e){
      throw NotFoundException(e.toString());
    }
  }

  Future<void> deleteConsumer(String id) async {
    try {
      await _client.from('consumers').delete().eq('id', id);
    }catch(e){
      throw NotFoundException(e.toString());
      //TODO: maybe i dont need this catch
    }
  }

  Future<List<Map<String, dynamic>>> getPasswords(String consumerId) async { //TODO: should split data sources i think
    try {
      final response = await _client
          .from('passwords')
          .select()
          .eq('user_id', consumerId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    }catch(e){
      throw NotFoundException(e.toString());
    }
  }

  Future<Map<String, dynamic>> getPassword(String id) async {
    try {
      final response = await _client
          .from('passwords')
          .select()
          .eq('id', id)
          .single();

      return Map<String, dynamic>.from(response);
    }catch(e){
      throw NotFoundException(e.toString());
    }
  }

  Future<void> insertPassword(Map<String, dynamic> passwordData) async {
    try {
      await _client.from('passwords').insert(passwordData);
    }catch(e){
      throw DublicateException(e.toString());
    }
  }

  Future<void> updatePassword(String id, Map<String, dynamic> passwordData) async {
    try {
      await _client.from('passwords').update(passwordData).eq('id', id);
    }catch(e){
      throw NotFoundException(e.toString());
    }
  }

  Future<void> deletePassword(String id) async {
    await _client.from('passwords').delete().eq('id', id);
  }

  /*Future<List<Map<String, dynamic>>> getFolders(String userId) async {
    final response = await _client
        .from('folders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }*/

  Future<List<Map<String, dynamic>>> getFolders(String userId) async {
    final response = await _client
        .from('folders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    final folders = List<Map<String, dynamic>>.from(response);

    return [
      ...folders.where((f) => f['name'] == 'base'),
      ...folders.where((f) => f['name'] != 'base'),
    ];
  }

  Future<Map<String, dynamic>> getFolder(String id) async {
    final response = await _client
        .from('folders')
        .select()
        .eq('id', id)
        .single();

    return Map<String, dynamic>.from(response);
  }

  Future<void> insertFolder(Map<String, dynamic> folderData) async {
    await _client.from('folders').insert(folderData);
  }

  Future<void> updateFolder(String id, Map<String, dynamic> folderData) async {
    await _client.from('folders').update(folderData).eq('id', id);
  }

  Future<void> deleteFolder(String id) async {
    await _client.from('folders').delete().eq('id', id);
  }
}