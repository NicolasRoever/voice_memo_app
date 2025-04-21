import '../../../domain/models/user_model.dart';
import '../services/supabase_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRepository {
  final SupabaseService _supabaseService;

  UserRepository(this._supabaseService);

  Future<void> saveUserToDatabase(AppUser user) async {
    await _supabaseService.insertUser(user);
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final supabaseService = ref.read(supabaseServiceProvider);
  return UserRepository(supabaseService);
});
