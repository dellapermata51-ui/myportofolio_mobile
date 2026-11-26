import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

Widget buildTestApp({http.Client? httpClient, String? token, Widget? home}) {
  final apiClient = ApiClient(
    client: httpClient ?? MockClient((_) async => http.Response('[]', 200)),
  );
  return MultiProvider(
    providers: [
      Provider.value(value: apiClient),
      ChangeNotifierProvider(
        create: (_) => AuthState(apiClient, initialToken: token),
      ),
    ],
    child: MaterialApp(home: home ?? MyHomePage()),
  );
}

Map<String, dynamic> educationJson({
  String id = '11111111-1111-1111-1111-111111111111',
  String institution = 'Universitas Indonesia',
  String program = 'Sistem Informasi',
  String level = 's1',
  String levelDisplay = 'S1',
  String description = 'Kuliah',
  String? thumbnail,
  String startedAt = '2023-08-01T00:00:00Z',
  String? endedAt,
}) {
  return {
    'id': id,
    'institution': institution,
    'program': program,
    'level': level,
    'level_display': levelDisplay,
    'description': description,
    'thumbnail': thumbnail,
    'started_at': startedAt,
    'ended_at': endedAt,
    'period': 'Aug 2023 – Sekarang',
    'is_ongoing': endedAt == null,
    'star_count': 2,
    'is_starred': false,
    'starred_by_names': 'owner, regular',
  };
}

http.Response jsonResponse(Object body, int statusCode) {
  return http.Response(
    jsonEncode(body),
    statusCode,
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}
