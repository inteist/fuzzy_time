import 'package:flutter_test/flutter_test.dart';

import 'package:fuzzy_time/fuzzy_time.dart';

void main() {
  tearDown(() {
    FuzzyTimeLocale.setLocale('en');
  });

  test('returns fuzzy text for future minute values with threshold logic', () {
    expect(const Duration(minutes: 7).fuzzyTime, 'in about 5 minutes');
    expect(const Duration(minutes: 8).fuzzyTime, 'in less than 10 minutes');
  });

  test('returns fuzzy text for past minute values with threshold logic', () {
    expect(const Duration(minutes: 7).fuzzyTimePast, 'about 5 minutes ago');
    expect(
      const Duration(minutes: 8).fuzzyTimePast,
      'less than 10 minutes ago',
    );
  });

  test('returns short fuzzy format for future and past', () {
    expect(const Duration(minutes: 7).fuzzyTimeShort, '~5 min');
    expect(const Duration(minutes: 8).fuzzyTimeShort, '<10 min');

    expect(const Duration(minutes: 7).fuzzyTimePastShort, '~5 min ago');
    expect(const Duration(minutes: 8).fuzzyTimePastShort, '<10 min ago');
  });

  test(
    'localization uses localized units and supports past/future prefixes',
    () {
      FuzzyTimeLocale.setLocale('es');
      expect(const Duration(minutes: 5).fuzzyTime, 'en unos 5 minutos');
      expect(const Duration(minutes: 5).fuzzyTimePast, 'hace unos 5 minutos');
    },
  );
}
