import 'package:flutter_test/flutter_test.dart';

import 'package:fuzzy_time/fuzzy_time.dart';

void main() {
  tearDown(() {
    FuzzyTimeLocale.setLocale('en');
  });

  group('Edge cases', () {
    test('midpoints resolve to upper threshold (< versus <= tie-breaker)', () {
      // 35 minutes is midway between 30 and 40 (rounding step 10)
      expect(const Duration(minutes: 35).fuzzyTime, 'less than 40 minutes');
      expect(const Duration(minutes: 35).fuzzyTimeShort, '<40 min');

      // 9 hours is midway between 6 and 12 (rounding step 6)
      expect(const Duration(hours: 9).fuzzyTime, 'less than 12 hours');
    });

    test('lower == 0 triggers correctly (less than first interval)', () {
      expect(const Duration(minutes: 2).fuzzyTime, 'less than 5 minutes');
      expect(const Duration(minutes: 2).fuzzyTimeShort, '<5 min');

      // Seconds specifically return "a few seconds" when lower == 0 (under 10s)
      expect(const Duration(seconds: 4).fuzzyTime, 'a few seconds');
      expect(const Duration(seconds: 4).fuzzyTimeShort, '<10s');
    });

    test('values less than 1 fallback format properly', () {
      expect(const Duration(milliseconds: 500).fuzzyTime, 'a few seconds');
      expect(const Duration(milliseconds: 500).fuzzyTimeShort, '<1s');
    });

    test('hour intervals jump correctly (quarter day bins)', () {
      expect(const Duration(hours: 6).fuzzyTime, 'about 6 hours');
      expect(const Duration(hours: 12).fuzzyTime, 'about 12 hours');
      expect(const Duration(hours: 18).fuzzyTime, 'about 18 hours');
      expect(const Duration(hours: 24).fuzzyTime, 'about 1 day');
    });
  });

  group('General coverage', () {
    test('seconds', () {
      expect(const Duration(seconds: 12).fuzzyTime, 'about 10 seconds');
      expect(const Duration(seconds: 56).fuzzyTime, 'less than 1 minute');
    });

    test('minutes', () {
      expect(const Duration(minutes: 7).fuzzyTime, 'about 5 minutes');
      expect(const Duration(minutes: 8).fuzzyTime, 'less than 10 minutes');
      expect(const Duration(minutes: 42).fuzzyTime, 'about 40 minutes');
    });

    test('hours (varied)', () {
      expect(const Duration(hours: 2).fuzzyTime, 'about 2 hours'); // step is 1
      expect(const Duration(hours: 5).fuzzyTime, 'about 5 hours');
      expect(const Duration(hours: 7).fuzzyTime, 'about 6 hours');
      expect(const Duration(hours: 10).fuzzyTime, 'less than 12 hours');
      expect(const Duration(hours: 22).fuzzyTime, 'less than 1 day');
    });

    test('days', () {
      expect(const Duration(days: 3).fuzzyTime, 'about 3 days');
      expect(const Duration(days: 12).fuzzyTime, 'about 12 days');
    });

    test('weeks (varied)', () {
      expect(const Duration(days: 14).fuzzyTime, 'about 2 weeks');
      expect(const Duration(days: 16).fuzzyTime, 'about 2 weeks');
      expect(const Duration(days: 20).fuzzyTime, 'less than 3 weeks');
      expect(const Duration(days: 22).fuzzyTime, 'about 3 weeks');
      expect(const Duration(days: 25).fuzzyTime, 'less than 4 weeks');
      expect(const Duration(days: 40).fuzzyTime, 'about 1 month');
    });

    test('months', () {
      expect(const Duration(days: 65).fuzzyTime, 'about 2 months');
      expect(const Duration(days: 70).fuzzyTime, 'about 2 months');
      expect(const Duration(days: 85).fuzzyTime, 'less than 3 months');
      expect(const Duration(days: 87).fuzzyTime, 'less than 3 months');
    });

    test('years', () {
      expect(const Duration(days: 400).fuzzyTime, 'about 1 year');
    });

    test('0 ms (exact now)', () {
      expect(Duration.zero.fuzzyTime, 'now');
      expect(Duration.zero.fuzzyTimeShort, 'now');
    });
  });

  group('DateTime extension relative to now', () {
    test('past datetimes format using past wrapper', () {
      final past = DateTime.now().subtract(const Duration(minutes: 5));
      expect(past.fuzzyTimeFromNow, 'about 5 minutes ago');
      expect(past.fuzzyTimeFromNowShort, '~5 min ago');
    });

    test('future datetimes format using future wrapper', () {
      final future = DateTime.now().add(const Duration(hours: 2));
      expect(
        future.fuzzyTimeFromNow,
        'in less than 2 hours',
      ); // due to execution time diff, it evaluates to < 2 hours instead of exact
      expect(future.fuzzyTimeFromNowShort, 'in <2 ho');
    });

    test('exact now circumvents wrappers', () {
      final now = DateTime.now();
      expect(now.fuzzyTimeFromNow, 'now');
      expect(now.fuzzyTimeFromNowShort, 'now');
    });

    test('a few seconds circumvents wrappers (long only)', () {
      final justNow = DateTime.now().subtract(const Duration(seconds: 4));
      expect(justNow.fuzzyTimeFromNow, 'a few seconds');
      expect(justNow.fuzzyTimeFromNowShort, '<10s ago');
    });
  });
}
