import 'fuzzy_time_locale.dart';
export 'fuzzy_time_locale.dart';

/// Extension on [Duration] that provides human-friendly, "fuzzy" time descriptions.
///
/// Instead of showing exact times, rounds to conversational values using "about"
/// (when closer to the lower bound) or "less than" (when closer to the upper bound).
///
/// Supports localization via [FuzzyTimeLocale.setLocale()].
extension FuzzyTime on Duration {
  /// Returns a human-friendly, fuzzy time description.
  ///
  /// Examples:
  /// - 30 seconds → "a few seconds"
  /// - 5 minutes → "in about 5 minutes"
  /// - 7 minutes → "in about 5 minutes" (closer to 5 than 10)
  /// - 8 minutes → "in less than 10 minutes" (closer to 10 than 5)
  /// - 130 minutes → "in about 2 hours"
  String get fuzzyTime => _fuzzyTime(locale: FuzzyTimeLocale.current);

  /// Returns a shorter, compact fuzzy time description.
  ///
  /// Examples:
  /// - 7 minutes → "~5 min"
  /// - 8 minutes → "<10 min"
  String get fuzzyTimeShort => _fuzzyTimeShort(locale: FuzzyTimeLocale.current);

  /// Internal implementation with explicit locale parameter.
  String _fuzzyTime({required FuzzyTimeLocale locale}) {
    if (isNegative || inMilliseconds == 0) return locale.anyMoment;

    final (value, unit, roundTo) = _normalizedValue;

    if (value < 1) {
      return locale.fewSeconds;
    }

    final lower = (value / roundTo).floor() * roundTo;
    final upper = lower + roundTo;

    // Handle edge cases for very small values
    if (lower == 0) {
      return unit == 'second'
          ? locale.fewSeconds
          : '${locale.prefixAbout} ${locale.formatUnit(roundTo, unit)}';
    }

    final distToLower = value - lower;
    final distToUpper = upper - value;

    final roundedValue = distToLower <= distToUpper ? lower : upper;
    final prefix = distToLower <= distToUpper
        ? locale.prefixAbout
        : locale.prefixLessThan;

    return '$prefix ${locale.formatUnit(roundedValue.round(), unit)}';
  }

  /// Internal implementation for short format with explicit locale parameter.
  String _fuzzyTimeShort({required FuzzyTimeLocale locale}) {
    if (isNegative || inMilliseconds == 0) return 'soon';

    final (value, unit, roundTo) = _normalizedValue;

    if (value < 1) return _shortUnit('second', locale);

    final lower = (value / roundTo).floor() * roundTo;
    final upper = lower + roundTo;

    if (lower == 0) {
      return _shortUnit(unit, locale);
    }

    final distToLower = value - lower;
    final distToUpper = upper - value;

    final roundedValue = distToLower <= distToUpper ? lower : upper;
    final prefix = distToLower <= distToUpper ? '~' : '<';

    return '$prefix${roundedValue.round()}${_shortUnit(unit, locale)}';
  }

  /// Returns normalized (value, unit, roundingStep) tuple.
  (double, String, int) get _normalizedValue {
    final totalSeconds = inSeconds;

    // Seconds: < 2 minutes
    if (totalSeconds < 120) {
      return (totalSeconds.toDouble(), 'second', 10);
    }

    // Minutes: < 1 hour
    if (totalSeconds < 3600) {
      final minutes = totalSeconds / 60;
      return (minutes, 'minute', minutes >= 30 ? 10 : 5);
    }

    // Hours: < 1 day
    if (totalSeconds < 86400) {
      final hours = totalSeconds / 3600;
      return (hours, 'hour', hours >= 6 ? 4 : 1);
    }

    // Days: >= 1 day
    final days = totalSeconds / 86400;
    if (days < 14) {
      return (days, 'day', 1);
    } else if (days < 60) {
      return (days / 7, 'week', 1);
    } else if (days < 365) {
      return (days / 30, 'month', 1);
    } else {
      return (days / 365, 'year', 1);
    }
  }

  String _shortUnit(String unit, FuzzyTimeLocale locale) {
    return switch (unit) {
      'second' => 's',
      'minute' => ' ${locale.minute.substring(0, 3)}',
      'hour' => ' ${locale.hour.substring(0, 2)}',
      'day' => 'd',
      'week' => 'w',
      'month' => 'mo',
      'year' => 'y',
      _ => '',
    };
  }
}
