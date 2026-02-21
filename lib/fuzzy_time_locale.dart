/// Configuration for localizing fuzzy time strings.
///
/// Each locale provides its own translations for time units and prefixes/suffixes.
class FuzzyTimeLocale {
  final String code;

  // Future prefixes
  final String prefixAbout;
  final String prefixLessThan;

  // Past wrappers
  final String pastPrefixAbout;
  final String pastPrefixLessThan;
  final String pastSuffix;

  // Generic labels
  final String anyMoment;
  final String justNow;
  final String fewSeconds;
  final String shortSoon;
  final String shortNow;
  final String shortPastSuffix;

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
    required this.pastPrefixAbout,
    required this.pastPrefixLessThan,
    required this.pastSuffix,
    required this.anyMoment,
    required this.justNow,
    required this.fewSeconds,
    required this.shortSoon,
    required this.shortNow,
    required this.shortPastSuffix,
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
    prefixAbout: 'in about',
    prefixLessThan: 'in less than',
    pastPrefixAbout: 'about',
    pastPrefixLessThan: 'less than',
    pastSuffix: 'ago',
    anyMoment: 'any moment now',
    justNow: 'just now',
    fewSeconds: 'a few seconds',
    shortSoon: 'soon',
    shortNow: 'now',
    shortPastSuffix: 'ago',
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
    prefixAbout: 'en unos',
    prefixLessThan: 'en menos de',
    pastPrefixAbout: 'hace unos',
    pastPrefixLessThan: 'hace menos de',
    pastSuffix: '',
    anyMoment: 'en cualquier momento',
    justNow: 'justo ahora',
    fewSeconds: 'unos segundos',
    shortSoon: 'pronto',
    shortNow: 'ahora',
    shortPastSuffix: '',
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
    prefixAbout: 'dans environ',
    prefixLessThan: 'dans moins de',
    pastPrefixAbout: 'il y a environ',
    pastPrefixLessThan: 'il y a moins de',
    pastSuffix: '',
    anyMoment: 'à tout moment',
    justNow: "à l'instant",
    fewSeconds: 'quelques secondes',
    shortSoon: 'bientot',
    shortNow: 'maintenant',
    shortPastSuffix: '',
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
    prefixAbout: 'em cerca de',
    prefixLessThan: 'em menos de',
    pastPrefixAbout: 'ha cerca de',
    pastPrefixLessThan: 'ha menos de',
    pastSuffix: '',
    anyMoment: 'a qualquer momento',
    justNow: 'agora mesmo',
    fewSeconds: 'alguns segundos',
    shortSoon: 'logo',
    shortNow: 'agora',
    shortPastSuffix: '',
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
    prefixAbout: 'in etwa',
    prefixLessThan: 'in weniger als',
    pastPrefixAbout: 'vor etwa',
    pastPrefixLessThan: 'vor weniger als',
    pastSuffix: '',
    anyMoment: 'jeden Moment',
    justNow: 'gerade eben',
    fewSeconds: 'ein paar Sekunden',
    shortSoon: 'bald',
    shortNow: 'jetzt',
    shortPastSuffix: '',
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
