import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/models/user_model.dart';
import '../../../data/services/shared_preferences_service.dart';

class UserViewModel extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  UserViewModel(this.ref) : super(const AsyncData(null));

  Future<void> logUserSession([String? nameInput]) async {
    state = const AsyncLoading();

    final prefsService = ref.read(sharedPreferencesProvider);

    String? id = prefsService.userId;
    String? name = prefsService.userName;

    if (id == null || name == null) {
      // First launch
      id = const Uuid().v4();
      name = nameInput;
      await prefsService.saveUserCredentials(id, name!);
    }

    final user = AppUser(
      user_id: id,
      name: name,
      openedAt: DateTime.now(),
    );

    final supabase = Supabase.instance.client;

    try {
      await supabase.from('user_table').insert(user.toJson());      
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final userViewModelProvider = StateNotifierProvider<UserViewModel, AsyncValue<void>>((ref) {
  return UserViewModel(ref);
});
