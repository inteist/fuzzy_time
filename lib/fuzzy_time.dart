import 'fuzzy_time_locale.dart';
export 'fuzzy_time_locale.dart';

/// Defines the format of the output string for fuzzy time.
enum FuzzyForm {
  /// The short, compact format (e.g. "~5 min ago").
  short,

  /// The long, more conversational format (e.g. "about 5 minutes ago").
  long,
}

/// Extension on [Duration] that provides human-friendly, "fuzzy" time descriptions.
///
/// Instead of showing exact times, rounds to conversational values using "about"
/// (when closer to the lower bound) or "less than" (when closer to the upper bound).
///
/// Supports localization via [FuzzyTimeLocale.setLocale()].
extension FuzzyDurationExtension on Duration {
  /// Returns a human-friendly, fuzzy time description.
  /// uses [fuzzyTime] with [FuzzyForm.long] by default.
  String get fuzzy => fuzzyTime();

  /// Returns a human-friendly, fuzzy time description.
  /// uses [fuzzyTime] with [FuzzyForm.short] parameter.
  String get fuzzyShort => fuzzyTime(form: FuzzyForm.short);

  /// Returns a human-friendly, fuzzy time description.
  ///
  /// Examples:
  /// - 30 seconds → "a few seconds"
  /// - 5 minutes → "about 5 minutes"
  /// - 7 minutes → "about 5 minutes" (closer to 5 than 10)
  /// - 8 minutes → "less than 10 minutes" (closer to 10 than 5)
  /// - 130 minutes → "about 2 hours"
  ///
  /// Use [form] to specify [FuzzyForm.short] or [FuzzyForm.long] (default).
  String fuzzyTime({FuzzyForm form = FuzzyForm.long}) {
    final locale = FuzzyTimeLocale.current;
    final isShort = form == FuzzyForm.short;

    final duration = isNegative ? -this : this;
    if (duration.inMilliseconds == 0) return isShort ? locale.shortNow : locale.now;

    final (value, unit, roundTo) = _normalizedValueFor(duration);

    if (value < 1) {
      if (isShort) return '<1${_shortUnit('second', locale)}';
      return locale.fewSeconds;
    }

    final lower = (value / roundTo).floor() * roundTo;
    final upper = lower + roundTo;

    if (lower == 0) {
      if (isShort) return '<$roundTo${_shortUnit(unit, locale)}';
      if (unit == 'second') return locale.fewSeconds;
      return '${locale.prefixLessThan} ${locale.formatUnit(roundTo, unit)}';
    }

    final distToLower = value - lower;
    final distToUpper = upper - value;

    var roundedValue = distToLower < distToUpper ? lower : upper;
    var finalUnit = unit;

    if (roundedValue == 60 && unit == 'second') {
      roundedValue = 1;
      finalUnit = 'minute';
    } else if (roundedValue == 60 && unit == 'minute') {
      roundedValue = 1;
      finalUnit = 'hour';
    } else if (roundedValue == 24 && unit == 'hour') {
      roundedValue = 1;
      finalUnit = 'day';
    } else if (roundedValue == 12 && unit == 'month') {
      roundedValue = 1;
      finalUnit = 'year';
    }

    if (isShort) {
      final prefix = distToLower < distToUpper ? '~' : '<';
      return '$prefix${roundedValue.round()}${_shortUnit(finalUnit, locale)}';
    } else {
      final prefix = distToLower < distToUpper ? locale.prefixAbout : locale.prefixLessThan;
      return '$prefix ${locale.formatUnit(roundedValue.round(), finalUnit)}';
    }
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
      return (hours, 'hour', hours >= 6 ? 6 : 1);
    }

    // Days: >= 1 day
    final days = totalSeconds / 86400;
    if (days < 14) {
      return (days, 'day', 1);
    }
    if (days < 28) {
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

/// An API for generating human-friendly, "fuzzy" time descriptions
/// relative to the current time (`DateTime.now()`).
class FuzzyTime {
  //
  /// Returns a human-friendly, fuzzy time description of passed DateTime relative to now.
  ///
  /// Examples:
  ///
  /// - A DateTime 5 minutes ago → "5 minutes ago"
  /// - A DateTime 5 minutes from now → "in 5 minutes"
  static String from(DateTime time, {FuzzyForm form = FuzzyForm.long}) {
    final now = DateTime.now();
    final diff = time.difference(now);

    final locale = FuzzyTimeLocale.current;
    final isShort = form == FuzzyForm.short;
    final amount = diff.fuzzyTime(form: form);

    // Special cases that should not be wrapped in past/future
    // and should be returned as-is
    if (diff.inMilliseconds == 0 ||
        amount == locale.now ||
        amount == locale.fewSeconds ||
        amount == locale.shortNow ||
        amount == '<1s') {
      return amount;
    }

    if (time.isBefore(now)) {
      return isShort ? locale.pastWrapperShort(amount) : locale.pastWrapper(amount);
    } else {
      return isShort ? locale.futureWrapperShort(amount) : locale.futureWrapper(amount);
    }
  }
}
