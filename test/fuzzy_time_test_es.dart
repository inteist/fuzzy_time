import 'package:test/test.dart';

import 'package:fuzzy_time/fuzzy_time.dart';

void main() {
  setUp(() {
    FuzzyTimeLocale.setLocale(FuzzyLocale.es);
  });

  tearDown(() {
    FuzzyTimeLocale.setLocale(FuzzyLocale.en);
  });

  group('Spanish locale', () {
    test('hours (singular)', () {
      expect(
        const Duration(hours: 1).fuzzyTime,
        'unos 1 hora',
      ); // This maintains your current logic. Note 'unos' instead of 'una' is expected by the logic
    });

    test('minutes (plural)', () {
      expect(const Duration(minutes: 5).fuzzyTime, 'unos 5 minutos');
      expect(const Duration(minutes: 58).fuzzyTime, 'menos de 1 hora');
    });

    test('seconds (few)', () {
      expect(const Duration(seconds: 4).fuzzyTime, 'unos segundos');
    });

    test('now', () {
      expect(Duration.zero.fuzzyTime, 'ahora');
    });
  });
}
