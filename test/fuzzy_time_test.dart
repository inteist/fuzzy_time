import 'package:flutter_test/flutter_test.dart';

import 'package:fuzzy_time/fuzzy_time.dart';

void main() {
  test('returns fuzzy text for minute values', () {
    expect(const Duration(minutes: 7).fuzzyTime, 'in about 5 minutes');
    expect(const Duration(minutes: 8).fuzzyTime, 'in less than 10 minutes');
  });

  test('returns short fuzzy format', () {
    expect(const Duration(minutes: 7).fuzzyTimeShort, '~5 min');
    expect(const Duration(minutes: 8).fuzzyTimeShort, '<10 min');
  });

  test('supports locale switch', () {
    FuzzyTimeLocale.setLocale('es');
    expect(const Duration(minutes: 5).fuzzyTime, startsWith('en unos'));

    FuzzyTimeLocale.setLocale('en');
    expect(const Duration(minutes: 5).fuzzyTime, 'in about 5 minutes');
  });
}
