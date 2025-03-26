class VoiceMemo {
  final int id; // Unix timestamp
  final String filePath;
  final DateTime createdAt;
  final Duration duration;

  VoiceMemo({
    required this.id,
    required this.filePath,
    required this.createdAt,
    required this.duration,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'filePath': filePath,
        'createdAt': createdAt.toIso8601String(),
        'duration': duration.inMilliseconds,
      };

  factory VoiceMemo.fromMap(Map<String, dynamic> map) => VoiceMemo(
        id: map['id'],
        filePath: map['filePath'],
        createdAt: DateTime.parse(map['createdAt']),
        duration: Duration(milliseconds: map['duration']),
      );
}
