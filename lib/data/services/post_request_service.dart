
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParticipantService {
  ParticipantService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  static const _url =
      'https://core-api-11932-110cf291-x7iy5esr.onporter.run/api/participant/register-signup';

  /// Registers a participant 
  Future<void> registerParticipant(String participantCode) async {
    final headers = {'Content-Type': 'application/json'};
    print('In registerParticipant service');
    print('participant_code: $participantCode'); 
    
    final body = jsonEncode({
      'participant_code': participantCode,
      'research_arm': 'joymemos',
    });
    
    final res = await _client.post(
      Uri.parse(_url),
      headers: headers,
      body: body,
    );

    print('Registration response status: ${res.statusCode}');
    print('Registration response body: ${res.body}');

    if (res.statusCode != 200) {
      // Surface a useful error for the caller (repository / view model).
      throw Exception('Registration failed (${res.statusCode}): ${res.body}');
    }
  }
}

final participantServiceProvider = Provider<ParticipantService>((ref) {
  return ParticipantService();
});
