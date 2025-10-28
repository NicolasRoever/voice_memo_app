import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/models/user_model.dart';
import '../../../data/services/shared_preferences_service.dart';
import '../../../data/repositories/user_repository.dart';

class UserViewModel extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  UserViewModel(this.ref) : super(const AsyncData(null));

  Future<void> logUserSession([String? nameInput]) async {
    state = const AsyncLoading();

    final prefsService = ref.read(sharedPreferencesProvider);
    final userRepo = ref.read(userRepositoryProvider);

    String? id = prefsService.userId;
    String? name = prefsService.userName;

    if (id == null || name == null) {
      id = const Uuid().v4();
      name = nameInput;
      await prefsService.saveUserCredentials(id, name!);
    }

    final user = AppUser(
      user_id: id,
      name: name,
      openedAt: DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000,
    );

    try {
      await userRepo.registerAndSaveUser(user);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final userViewModelProvider = StateNotifierProvider<UserViewModel, AsyncValue<void>>(
  (ref) => UserViewModel(ref),
);
