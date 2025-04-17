// lib/data/services/supabase_service.dart

import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String> uploadRecording(String userId, File file) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${userId}_$timestamp.m4a';
    final storagePath = 'voice-memo-bucket/$fileName';

    final response = await _client.storage
        .from('voice-memo-bucket')
        .upload(storagePath, file, fileOptions: const FileOptions(upsert: true));

    if (response.isEmpty) {
      throw Exception('Failed to upload file to Supabase Storage');
    }

    return _client.storage.from('voice-memo-bucket').getPublicUrl(storagePath);
  }

  Future<void> insertVoiceMemo({
    required String userId,
    required int timestamp,
    required String fileUrl,
  }) async {
    await _client.from('voice_memos').insert({
      'user_id': userId,
      'created_at': timestamp,
      'file_path': fileUrl,
    });
  }

  Future<void> insertUser(AppUser user) async {
    await _client.from('user_signup_table').insert(user.toJson());
  }
}


final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});