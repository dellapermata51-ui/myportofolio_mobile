import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

import 'test_helpers.dart';

void main() {
  group('ApiClient Education', () {
    test('getEducations mengambil daftar tanpa header Authorization', () async {
      late http.Request captured;
      final client = ApiClient(
        baseUrl: 'http://test',
        client: MockClient((request) async {
          captured = request;
          return jsonResponse([educationJson()], 200);
        }),
      );

      final educations = await client.getEducations();

      expect(captured.method, 'GET');
      expect(captured.url.toString(), 'http://test/api/v1/education/');
      expect(captured.headers.containsKey('Authorization'), isFalse);
      expect(educations, hasLength(1));
      expect(educations.first.institution, 'Universitas Indonesia');
    });

    test('getEducations melempar ApiException pada respons non-2xx', () async {
      final client = ApiClient(
        baseUrl: 'http://test',
        client: MockClient((_) async => http.Response('gagal', 500)),
      );

      await expectLater(
        client.getEducations(),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500),
        ),
      );
    });

    test('createEducation mengirim POST dengan token tanpa id', () async {
      late http.Request captured;
      final client = ApiClient(
        baseUrl: 'http://test',
        client: MockClient((request) async {
          captured = request;
          return jsonResponse(educationJson(), 201);
        }),
      );

      final created = await client.createEducation(
        Education(
          institution: 'Universitas Indonesia',
          program: 'Sistem Informasi',
          startedAt: DateTime.utc(2023, 8),
          id: 'tidak-boleh-terkirim',
        ),
        token: 'rahasia',
      );

      final body = jsonDecode(captured.body) as Map<String, dynamic>;
      expect(captured.method, 'POST');
      expect(captured.url.path, '/api/v1/education/');
      expect(captured.headers['Authorization'], 'Token rahasia');
      expect(body['institution'], 'Universitas Indonesia');
      expect(body['started_at'], '2023-08-01T00:00:00.000Z');
      expect(body.containsKey('id'), isFalse);
      expect(created.id, '11111111-1111-1111-1111-111111111111');
    });

    test('createEducation melempar ApiException 401', () async {
      final client = ApiClient(
        baseUrl: 'http://test',
        client: MockClient(
          (_) async => jsonResponse({'detail': 'Invalid token.'}, 401),
        ),
      );

      await expectLater(
        client.createEducation(
          Education(institution: 'UI', startedAt: DateTime.utc(2023, 8)),
          token: 'kedaluwarsa',
        ),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 401),
        ),
      );
    });
  });
}
