import 'package:flutter_test/flutter_test.dart';

import 'package:fuzzy_time/fuzzy_time.dart';

void main() {
  setUp(() {
    FuzzyTimeLocale.setLocale(FuzzyLocale.de);
  });

  tearDown(() {
    FuzzyTimeLocale.setLocale(FuzzyLocale.en);
  });

  group('German locale', () {
    test('hours', () {
      expect(const Duration(hours: 2).fuzzyTime, 'etwa 2 Stunden');
    });

    test('minutes', () {
      expect(const Duration(minutes: 5).fuzzyTime, 'etwa 5 Minuten');
      expect(const Duration(minutes: 58).fuzzyTime, 'weniger als 1 Stunde');
    });

    test('seconds (few)', () {
      expect(const Duration(seconds: 4).fuzzyTime, 'ein paar Sekunden');
    });

    test('now', () {
      expect(Duration.zero.fuzzyTime, 'jetzt');
    });
  });
}
