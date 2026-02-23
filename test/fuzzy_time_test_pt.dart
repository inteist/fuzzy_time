import 'package:test/test.dart';

import 'package:fuzzy_time/fuzzy_time.dart';

void main() {
  setUp(() {
    FuzzyTimeLocale.setLocale(FuzzyLocale.pt);
  });

  tearDown(() {
    FuzzyTimeLocale.setLocale(FuzzyLocale.en);
  });

  group('Portuguese locale', () {
    test('hours', () {
      expect(const Duration(hours: 2).fuzzyTime(), 'cerca de 2 horas');
    });

    test('minutes', () {
      expect(const Duration(minutes: 5).fuzzyTime(), 'cerca de 5 minutos');
      expect(const Duration(minutes: 58).fuzzyTime(), 'menos de 1 hora');
    });

    test('seconds (few)', () {
      expect(const Duration(seconds: 4).fuzzyTime(), 'alguns segundos');
    });

    test('now', () {
      expect(Duration.zero.fuzzyTime(), 'agora');
    });
  });
}
