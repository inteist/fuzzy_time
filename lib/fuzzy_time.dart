import 'fuzzy_time_locale.dart';
export 'fuzzy_time_locale.dart';

/// Extension on [Duration] that provides human-friendly, "fuzzy" time descriptions.
///
/// Instead of showing exact times, rounds to conversational values using "about"
/// (when closer to the lower bound) or "less than" (when closer to the upper bound).
///
/// Supports localization via [FuzzyTimeLocale.setLocale()].
extension FuzzyTime on Duration {
  /// Returns a human-friendly, fuzzy future time description.
  ///
  /// Examples:
  /// - 30 seconds → "a few seconds"
  /// - 5 minutes → "in about 5 minutes"
  /// - 7 minutes → "in about 5 minutes" (closer to 5 than 10)
  /// - 8 minutes → "in less than 10 minutes" (closer to 10 than 5)
  /// - 130 minutes → "in about 2 hours"
  String get fuzzyTime => _fuzzyFuture(locale: FuzzyTimeLocale.current);

  /// Returns a short, compact fuzzy future time description.
  ///
  /// Examples:
  /// - 7 minutes → "~5 min"
  /// - 8 minutes → "<10 min"
  String get fuzzyTimeShort =>
      _fuzzyFutureShort(locale: FuzzyTimeLocale.current);

  /// Returns a human-friendly, fuzzy past time description.
  ///
  /// Examples:
  /// - 7 minutes → "about 5 minutes ago"
  /// - 8 minutes → "less than 10 minutes ago"
  String get fuzzyTimePast => _fuzzyPast(locale: FuzzyTimeLocale.current);

  /// Returns a short, compact fuzzy past time description.
  ///
  /// Examples:
  /// - 7 minutes → "~5 min ago"
  /// - 8 minutes → "<10 min ago"
  String get fuzzyTimePastShort =>
      _fuzzyPastShort(locale: FuzzyTimeLocale.current);

  String _fuzzyFuture({required FuzzyTimeLocale locale}) {
    if (isNegative || inMilliseconds == 0) return locale.anyMoment;
    return _fuzzyLong(
      duration: this,
      locale: locale,
      prefixAbout: locale.prefixAbout,
      prefixLessThan: locale.prefixLessThan,
      zeroText: locale.anyMoment,
      suffix: '',
    );
  }

  String _fuzzyPast({required FuzzyTimeLocale locale}) {
    final duration = isNegative ? -this : this;
    return _fuzzyLong(
      duration: duration,
      locale: locale,
      prefixAbout: locale.pastPrefixAbout,
      prefixLessThan: locale.pastPrefixLessThan,
      zeroText: locale.justNow,
      suffix: locale.pastSuffix,
    );
  }

  String _fuzzyLong({
    required Duration duration,
    required FuzzyTimeLocale locale,
    required String prefixAbout,
    required String prefixLessThan,
    required String zeroText,
    required String suffix,
  }) {
    if (duration.inMilliseconds == 0) return zeroText;

    final (value, unit, roundTo) = _normalizedValueFor(duration);

    if (value < 1) return locale.fewSeconds;

    final lower = (value / roundTo).floor() * roundTo;
    final upper = lower + roundTo;

    if (lower == 0) {
      if (unit == 'second') return locale.fewSeconds;
      return _joinWithSuffix(
        '$prefixAbout ${locale.formatUnit(roundTo, unit)}',
        suffix,
      );
    }

    final distToLower = value - lower;
    final distToUpper = upper - value;

    final roundedValue = distToLower <= distToUpper ? lower : upper;
    final prefix = distToLower <= distToUpper ? prefixAbout : prefixLessThan;

    return _joinWithSuffix(
      '$prefix ${locale.formatUnit(roundedValue.round(), unit)}',
      suffix,
    );
  }

  String _fuzzyFutureShort({required FuzzyTimeLocale locale}) {
    if (isNegative || inMilliseconds == 0) return locale.shortSoon;
    return _fuzzyShort(duration: this, locale: locale, suffix: '');
  }

  String _fuzzyPastShort({required FuzzyTimeLocale locale}) {
    final duration = isNegative ? -this : this;
    return _fuzzyShort(
      duration: duration,
      locale: locale,
      suffix: locale.shortPastSuffix,
    );
  }

  String _fuzzyShort({
    required Duration duration,
    required FuzzyTimeLocale locale,
    required String suffix,
  }) {
    if (duration.inMilliseconds == 0) return locale.shortNow;

    final (value, unit, roundTo) = _normalizedValueFor(duration);

    if (value < 1) {
      return _joinWithSuffix(_shortUnit('second', locale), suffix);
    }

    final lower = (value / roundTo).floor() * roundTo;
    final upper = lower + roundTo;

    if (lower == 0) {
      return _joinWithSuffix(_shortUnit(unit, locale), suffix);
    }

    final distToLower = value - lower;
    final distToUpper = upper - value;

    final roundedValue = distToLower <= distToUpper ? lower : upper;
    final prefix = distToLower <= distToUpper ? '~' : '<';

    return _joinWithSuffix(
      '$prefix${roundedValue.round()}${_shortUnit(unit, locale)}',
      suffix,
    );
  }

  static String _joinWithSuffix(String value, String suffix) {
    if (suffix.isEmpty) return value;
    return '$value $suffix';
  }

  /// Returns normalized (value, unit, roundingStep) tuple.
  static (double, String, int) _normalizedValueFor(Duration duration) {
    final totalSeconds = duration.inSeconds;

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
    }
    if (days < 60) {
      return (days / 7, 'week', 1);
    }
    if (days < 365) {
      return (days / 30, 'month', 1);
    }
    return (days / 365, 'year', 1);
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
