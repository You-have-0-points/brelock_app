import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brelock/core/errors/NotFoundException.dart';
import 'package:brelock/core/errors/DublicateException.dart';

class PasswordDatasource{
  final SupabaseClient _client;

  PasswordDatasource(this._client);

  Future<void> create(Map<String, dynamic> passwordData) async {
    try {
      await _client.from('passwords').insert(passwordData);
    }catch(e){
      throw DublicateException(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getAll(String consumerId) async {
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

  Future<Map<String, dynamic>> get(String id) async {
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

  Future<void> update(String id, Map<String, dynamic> passwordData) async {
    try {
      await _client.from('passwords').update(passwordData).eq('id', id);
    }catch(e){
      throw NotFoundException(e.toString());
    }
  }

  Future<void> delete(String id) async {
    try {
      await _client.from('passwords').delete().eq('id', id);
    }catch(e){
      throw NotFoundException(e.toString());
    }
  }

}