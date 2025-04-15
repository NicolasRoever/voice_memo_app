class AppUser {
  final String user_id; // Unique ID (UUID)
  final String name;
  final DateTime openedAt;

  AppUser({
    required this.user_id,
    required this.name,
    required this.openedAt,
  });

  Map<String, dynamic> toJson() => {
    'user_id': user_id,
    'name': name,
    'opened_at': openedAt.toIso8601String(),
  };
}
