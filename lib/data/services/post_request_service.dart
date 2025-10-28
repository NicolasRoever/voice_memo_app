// lib/features/auth/data/participant_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParticipantService {
  ParticipantService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  static const _url =
      'https://core-api-11932-110cf291-x7iy5esr.onporter.run/api/participant/register-signup';

  /// Registers a participant by email (your "name" field) to research arm "sonia".
  Future<void> registerParticipant(String participantEmail) async {
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'participant_email': participantEmail,
      'research_arm': 'sonia',
    });

    final res = await _client.post(
      Uri.parse(_url),
      headers: headers,
      body: body,
    );

    if (res.statusCode != 200) {
      // Surface a useful error for the caller (repository / view model).
      throw Exception('Registration failed (${res.statusCode}): ${res.body}');
    }
  }
}

final participantServiceProvider = Provider<ParticipantService>((ref) {
  return ParticipantService();
});
