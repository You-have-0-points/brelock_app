import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brelock/core/errors/DublicateException.dart';
import 'package:brelock/core/errors/NotFoundException.dart';

class ConsumerDatasource{
  final SupabaseClient _client;

  ConsumerDatasource(this._client);

  Future<void> create(Map<String, dynamic> consumerData) async{
    try{
      await _client.from("consumers").insert(consumerData);
    }catch(e){
      throw DublicateException(e.toString());
    }
  }

  //TODO: maybe i need smth like DataSourceException, but better read documentation about errors in subabase
  //FOR ME IN FUTURE i dont need method like CHECK coz i just can correct use get by login data and econom requests

  Future<Map<String, dynamic>> getByLoginData(String email, String password) async{
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

  Future<Map<String, dynamic>> getById(String id) async{
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

  Future<Map<String, dynamic>> getByEmail(String email) async {
    try {
      final response = await _client
          .from('consumers')
          .select()
          .eq('email', email)
          .order('created_at', ascending: false).single();

      return Map<String, dynamic>.from(response);
    } catch (e) {
      throw NotFoundException(e.toString());
    }
  }

  Future<void> update(String id, Map<String, dynamic> consumerData) async {
    try {
      await _client.from('consumers').update(consumerData).eq('id', id);
    }catch(e){
      throw NotFoundException(e.toString());
    }
  }

  Future<void> delete(String id) async {
    try {
      await _client.from('consumers').delete().eq('id', id);
    }catch(e){
      throw NotFoundException(e.toString());
    }
  }
}