import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brelock/core/errors/DublicateException.dart';
import 'package:brelock/core/errors/NotFoundException.dart';
import 'package:uuid/uuid.dart';

class FolderDatasource{
  final SupabaseClient _client;

  FolderDatasource(this._client);

  Future<void> create(Map<String, dynamic> folderData) async {
    try {
      await _client.from('folders').insert(folderData);
    }catch(e){
      throw DublicateException(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getAll(List<UuidValue> folderIds) async {
    try {
      if (folderIds.isEmpty) {
        return [];
      }

      final response = await _client
          .from('folders')
          .select()
          .inFilter('id', folderIds)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch(e) {
      throw NotFoundException(e.toString());
    }
  }

  Future<Map<String, dynamic>> get(String id) async {
    try {
      final response = await _client
          .from('folders')
          .select()
          .eq('id', id)
          .single();

      return Map<String, dynamic>.from(response);
    }catch(e){
      throw NotFoundException(e.toString());
    }
  }

  Future<void> update(String id, Map<String, dynamic> folderData) async {
    try {
      await _client.from('folders').update(folderData).eq('id', id);
    }catch(e){
      throw NotFoundException(e.toString());
    }
  }

  Future<void> delete(String id) async {
    try {
      await _client.from('folders').delete().eq('id', id);
    }catch(e){
      throw NotFoundException(e.toString());
    }
  }
}