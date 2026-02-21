import 'package:flutter_test/flutter_test.dart';

import 'package:fuzzy_time/fuzzy_time.dart';

void main() {
  tearDown(() {
    FuzzyTimeLocale.setLocale('en');
  });

  group('Edge cases', () {
    test('midpoints resolve to upper threshold (< versus <= tie-breaker)', () {
      // 35 minutes is midway between 30 and 40 (rounding step 10)
      expect(const Duration(minutes: 35).fuzzyTime, 'in less than 40 minutes');
      expect(const Duration(minutes: 35).fuzzyTimeShort, '<40 min');

      // 9 hours is midway between 6 and 12 (rounding step 6)
      expect(const Duration(hours: 9).fuzzyTime, 'in less than 12 hours');
    });

    test('lower == 0 triggers correctly (less than first interval)', () {
      expect(const Duration(minutes: 2).fuzzyTime, 'in less than 5 minutes');
      expect(const Duration(minutes: 2).fuzzyTimeShort, '<5 min');
      expect(const Duration(minutes: 2).fuzzyTimePast, 'less than 5 minutes ago');

      // Seconds specifically return "a few seconds" when lower == 0 (under 10s)
      expect(const Duration(seconds: 4).fuzzyTime, 'a few seconds');
      expect(const Duration(seconds: 4).fuzzyTimeShort, '<10s');
    });

    test('values less than 1 fallback format properly', () {
      expect(const Duration(milliseconds: 500).fuzzyTime, 'a few seconds');
      expect(const Duration(milliseconds: 500).fuzzyTimeShort, '<1s');
      expect(const Duration(milliseconds: 500).fuzzyTimePast, 'a few seconds ago');
      expect(const Duration(milliseconds: 500).fuzzyTimePastShort, '<1s ago');
    });

    test('hour intervals jump correctly (quarter day bins)', () {
      expect(const Duration(hours: 6).fuzzyTime, 'in about 6 hours');
      expect(const Duration(hours: 12).fuzzyTime, 'in about 12 hours');
      expect(const Duration(hours: 18).fuzzyTime, 'in about 18 hours');
      expect(const Duration(hours: 24).fuzzyTime, 'in about 1 day');
    });
  });

  group('General coverage', () {
    test('seconds', () {
      expect(const Duration(seconds: 12).fuzzyTime, 'in about 10 seconds');
      expect(const Duration(seconds: 56).fuzzyTime, 'in less than 60 seconds');
    });

    test('minutes', () {
      expect(const Duration(minutes: 7).fuzzyTime, 'in about 5 minutes');
      expect(const Duration(minutes: 8).fuzzyTime, 'in less than 10 minutes');
      expect(const Duration(minutes: 42).fuzzyTime, 'in about 40 minutes');
    });

    test('hours', () {
      expect(const Duration(hours: 2).fuzzyTime, 'in about 2 hours'); // step is 1
      expect(const Duration(hours: 5).fuzzyTime, 'in about 5 hours');
    });

    test('days', () {
      expect(const Duration(days: 3).fuzzyTime, 'in about 3 days');
      expect(const Duration(days: 12).fuzzyTime, 'in about 12 days');
    });

    test('weeks', () {
      expect(const Duration(days: 16).fuzzyTime, 'in about 2 weeks');
      expect(const Duration(days: 40).fuzzyTime, 'in less than 6 weeks');
    });

    test('months', () {
      expect(const Duration(days: 65).fuzzyTime, 'in about 2 months');
    });

    test('years', () {
      expect(const Duration(days: 400).fuzzyTime, 'in about 1 year');
    });

    test('0 ms (exact now)', () {
      expect(Duration.zero.fuzzyTime, 'any moment now');
      expect(Duration.zero.fuzzyTimeShort, 'soon');
      expect(Duration.zero.fuzzyTimePast, 'just now');
      expect(Duration.zero.fuzzyTimePastShort, 'now');
    });

    test('localization uses localized units and supports past/future prefixes', () {
      FuzzyTimeLocale.setLocale('es');
      expect(const Duration(minutes: 5).fuzzyTime, 'en unos 5 minutos');
      expect(const Duration(minutes: 5).fuzzyTimePast, 'hace unos 5 minutos');
    });
  });
}
