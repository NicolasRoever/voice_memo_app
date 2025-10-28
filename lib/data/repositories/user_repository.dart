// lib/features/auth/data/user_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/user_model.dart';
import '../services/supabase_service.dart';
import 'participant_service.dart';

class UserRepository {
  final SupabaseService _supabaseService;
  final ParticipantService _participantService;

  UserRepository(this._supabaseService, this._participantService);

  /// Registers the user via the API (using AppUser.name as email),
  /// then persists to Supabase if registration succeeds.
  Future<void> registerAndSaveUser(AppUser user) async {
    // name is the email
    final email = user.name;

    // 1) remote registration
    await _participantService.registerParticipant(email);

    // 2) persist locally (Supabase) only on success
    await _supabaseService.insertUser(user);
  }

  /// If you still want a direct save without API registration:
  Future<void> saveUserToDatabase(AppUser user) async {
    await _supabaseService.insertUser(user);
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final supabaseService = ref.read(supabaseServiceProvider);
  final participantService = ref.read(participantServiceProvider);
  return UserRepository(supabaseService, participantService);
});
