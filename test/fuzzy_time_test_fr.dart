import 'package:test/test.dart';

import 'package:fuzzy_time/fuzzy_time.dart';

void main() {
  setUp(() {
    FuzzyTimeLocale.setLocale(FuzzyLocale.fr);
  });

  tearDown(() {
    FuzzyTimeLocale.setLocale(FuzzyLocale.en);
  });

  group('French locale', () {
    test('hours', () {
      expect(const Duration(hours: 2).fuzzyTime(), 'environ 2 heures');
    });

    test('minutes', () {
      expect(const Duration(minutes: 5).fuzzyTime(), 'environ 5 minutes');
      expect(const Duration(minutes: 58).fuzzyTime(), 'moins de 1 heure');
    });

    test('seconds (few)', () {
      expect(const Duration(seconds: 4).fuzzyTime(), 'quelques secondes');
    });

    test('now', () {
      expect(Duration.zero.fuzzyTime(), 'maintenant');
    });
  });
}
