/// Configuration for localizing fuzzy time strings.
///
/// Supported locales:
///  - English
///  - Spanish
///  - French
///  - Portuguese
///  - German
///  - Italian
///
/// Each locale provides its own translations for time units and prefixes.
class FuzzyTimeLocale {
  final String code;

  // Prefixes
  final String prefixAbout;
  final String prefixLessThan;

  // Generic labels
  final String now;
  final String shortNow;
  final String fewSeconds;

  // Time units (localized base forms)
  final String second;
  final String minute;
  final String hour;
  final String day;
  final String week;
  final String month;
  final String year;

  // Pluralization function (some languages have complex plural rules)
  final String Function(String unit, int count) pluralize;

  // Current locale (defaults to English)
  static FuzzyTimeLocale _current = english;

  const FuzzyTimeLocale({
    required this.code,
    required this.prefixAbout,
    required this.prefixLessThan,
    required this.now,
    required this.shortNow,
    required this.fewSeconds,
    required this.second,
    required this.minute,
    required this.hour,
    required this.day,
    required this.week,
    required this.month,
    required this.year,
    required this.pluralize,
  });

  /// Set the global locale for fuzzy time formatting.
  static void setLocale(String code) {
    _current = _getLocale(code);
  }

  /// Get the current locale.
  static FuzzyTimeLocale get current => _current;

  /// Get a locale by code.
  static FuzzyTimeLocale _getLocale(String code) {
    if (code.startsWith('es')) return spanish;
    if (code.startsWith('fr')) return french;
    if (code.startsWith('pt')) return portuguese;
    if (code.startsWith('de')) return german;
    return english;
  }

  /// Default English locale
  static const english = FuzzyTimeLocale(
    code: 'en',
    prefixAbout: 'about',
    prefixLessThan: 'less than',
    now: 'now',
    shortNow: 'now',
    fewSeconds: 'a few seconds',
    second: 'second',
    minute: 'minute',
    hour: 'hour',
    day: 'day',
    week: 'week',
    month: 'month',
    year: 'year',
    pluralize: _englishPlural,
  );

  static String _englishPlural(String unit, int count) {
    return count == 1 ? unit : '${unit}s';
  }

  /// Spanish locale
  static const spanish = FuzzyTimeLocale(
    code: 'es',
    prefixAbout: 'unos',
    prefixLessThan: 'menos de',
    now: 'ahora',
    shortNow: 'ahora',
    fewSeconds: 'unos segundos',
    second: 'segundo',
    minute: 'minuto',
    hour: 'hora',
    day: 'día',
    week: 'semana',
    month: 'mes',
    year: 'año',
    pluralize: _spanishPlural,
  );

  static String _spanishPlural(String unit, int count) {
    if (count == 1) return unit;
    if (unit.endsWith('a')) return '${unit}s';
    if (unit.endsWith('o')) return '${unit}s';
    if (unit.endsWith('e')) return '${unit}s';
    if (unit.endsWith('s')) return '${unit}es';
    return '${unit}s';
  }

  /// French locale
  static const french = FuzzyTimeLocale(
    code: 'fr',
    prefixAbout: 'environ',
    prefixLessThan: 'moins de',
    now: 'maintenant',
    shortNow: 'maintenant',
    fewSeconds: 'quelques secondes',
    second: 'seconde',
    minute: 'minute',
    hour: 'heure',
    day: 'jour',
    week: 'semaine',
    month: 'mois',
    year: 'an',
    pluralize: _frenchPlural,
  );

  static String _frenchPlural(String unit, int count) {
    if (count == 1) return unit;
    if (unit.endsWith('s') || unit.endsWith('x')) return unit;
    return '${unit}s';
  }

  /// Portuguese locale
  static const portuguese = FuzzyTimeLocale(
    code: 'pt',
    prefixAbout: 'cerca de',
    prefixLessThan: 'menos de',
    now: 'agora',
    shortNow: 'agora',
    fewSeconds: 'alguns segundos',
    second: 'segundo',
    minute: 'minuto',
    hour: 'hora',
    day: 'dia',
    week: 'semana',
    month: 'mês',
    year: 'ano',
    pluralize: _portuguesePlural,
  );

  static String _portuguesePlural(String unit, int count) {
    if (count == 1) return unit;
    if (unit.endsWith('a')) return '${unit}s';
    if (unit.endsWith('o')) return '${unit}s';
    if (unit.endsWith('s')) return '${unit}es';
    return '${unit}s';
  }

  /// German locale
  static const german = FuzzyTimeLocale(
    code: 'de',
    prefixAbout: 'etwa',
    prefixLessThan: 'weniger als',
    now: 'jetzt',
    shortNow: 'jetzt',
    fewSeconds: 'ein paar Sekunden',
    second: 'Sekunde',
    minute: 'Minute',
    hour: 'Stunde',
    day: 'Tag',
    week: 'Woche',
    month: 'Monat',
    year: 'Jahr',
    pluralize: _germanPlural,
  );

  static String _germanPlural(String unit, int count) {
    if (count == 1) return unit;
    if (unit == 'Stunde') return 'Stunden';
    if (unit == 'Minute') return 'Minuten';
    if (unit == 'Woche') return 'Wochen';
    if (unit == 'Monat') return 'Monate';
    if (unit == 'Jahr') return 'Jahre';
    if (unit == 'Tag') return 'Tage';
    if (unit == 'Sekunde') return 'Sekunden';
    return unit;
  }

  String _unitLabel(String unit) {
    return switch (unit) {
      'second' => second,
      'minute' => minute,
      'hour' => hour,
      'day' => day,
      'week' => week,
      'month' => month,
      'year' => year,
      _ => unit,
    };
  }

  /// Helper to format a value with a localized unit.
  String formatUnit(int value, String unit) {
    final localized = _unitLabel(unit);
    final inflected = pluralize(localized, value);
    return '$value $inflected';
  }
}
