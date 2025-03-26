class VoiceMemo {
  final int? id;
  final String path;
  final DateTime createdAt;

  VoiceMemo({
    this.id,
    required this.path,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory VoiceMemo.fromMap(Map<String, dynamic> map) {
    return VoiceMemo(
      id: map['id'],
      path: map['path'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
