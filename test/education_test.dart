import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/education.dart';

import 'test_helpers.dart';

void main() {
  group('Education', () {
    test('fromJson membaca key snake_case dari API', () {
      final education = Education.fromJson(
        educationJson(thumbnail: 'https://contoh.com/ui.png'),
      );

      expect(education.id, '11111111-1111-1111-1111-111111111111');
      expect(education.institution, 'Universitas Indonesia');
      expect(education.levelDisplay, 'S1');
      expect(education.thumbnail, 'https://contoh.com/ui.png');
      expect(education.startedAt, DateTime.utc(2023, 8));
      expect(education.endedAt, isNull);
      expect(education.isOngoing, isTrue);
      expect(education.starCount, 2);
      expect(education.starredByNames, 'owner, regular');
    });

    test('field opsional memakai nilai default saat key tidak ada', () {
      final education = Education.fromJson({
        'institution': 'SMA Negeri 1',
        'started_at': '2020-07-01T00:00:00Z',
      });

      expect(education.program, '');
      expect(education.level, 's1');
      expect(education.description, '');
      expect(education.thumbnail, isNull);
      expect(education.endedAt, isNull);
      expect(education.starCount, 0);
      expect(education.isStarred, isFalse);
    });

    test('toJson memakai snake_case dan membuang field milik server', () {
      final json = Education(
        institution: 'SMA Negeri 1',
        program: 'IPA',
        level: 'sma',
        description: 'SMA',
        startedAt: DateTime.utc(2020, 7),
        endedAt: DateTime.utc(2023, 6),
        id: 'abc',
        levelDisplay: 'SMA',
        period: 'palsu',
        starCount: 99,
      ).toJson();

      expect(json, {
        'institution': 'SMA Negeri 1',
        'program': 'IPA',
        'level': 'sma',
        'description': 'SMA',
        'thumbnail': null,
        'started_at': '2020-07-01T00:00:00.000Z',
        'ended_at': '2023-06-01T00:00:00.000Z',
      });
    });

    test('ended_at bernilai null saat masih menempuh pendidikan', () {
      final json = Education(
        institution: 'Universitas Indonesia',
        startedAt: DateTime.utc(2023, 8),
      ).toJson();

      expect(json.containsKey('ended_at'), isTrue);
      expect(json['ended_at'], isNull);
    });
  });
}
