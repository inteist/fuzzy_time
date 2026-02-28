///
/// Supported locales for fuzzy time string localization.
/// Using ISO 639-1 (2 letter codes) language codes.
///
enum FuzzyLocale {
  /// English
  en('en'),

  /// Spanish
  es('es'),

  /// French
  fr('fr'),

  /// Portuguese
  pt('pt'),

  /// German
  de('de'),

  /// Italian
  it('it');

  final String code;
  const FuzzyLocale(this.code);
}

/// Canonical unit keys used by fuzzy-time formatters.
enum FuzzyTimeUnit { second, minute, hour, day, week, month, year }

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
  final FuzzyLocale locale;

  // Prefixes
  final String prefixAbout;
  final String prefixLessThan;

  // Wrappers for past/future (used by DateTime methods)
  final String Function(String) futureWrapper;
  final String Function(String) pastWrapper;
  final String Function(String) futureWrapperShort;
  final String Function(String) pastWrapperShort;

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

  // Time unit short labels used by compact formatting.
  final String secondShort;
  final String minuteShort;
  final String hourShort;
  final String dayShort;
  final String weekShort;
  final String monthShort;
  final String yearShort;

  // Pluralization function (some languages have complex plural rules)
  final String Function(String unit, int count) pluralize;

  // Current locale (defaults to English)
  static FuzzyTimeLocale _current = english;

  const FuzzyTimeLocale({
    required this.locale,
    required this.prefixAbout,
    required this.prefixLessThan,
    required this.futureWrapper,
    required this.pastWrapper,
    required this.futureWrapperShort,
    required this.pastWrapperShort,
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
    required this.secondShort,
    required this.minuteShort,
    required this.hourShort,
    required this.dayShort,
    required this.weekShort,
    required this.monthShort,
    required this.yearShort,
    required this.pluralize,
  });

  /// Set the global locale for fuzzy time formatting.
  static void setLocale(FuzzyLocale locale) {
    _current = _getLocale(locale);
  }

  /// Get the current locale.
  static FuzzyTimeLocale get current => _current;

  /// Get a locale configuration by enum.
  static FuzzyTimeLocale _getLocale(FuzzyLocale locale) {
    return switch (locale) {
      FuzzyLocale.es => spanish,
      FuzzyLocale.fr => french,
      FuzzyLocale.pt => portuguese,
      FuzzyLocale.de => german,
      FuzzyLocale.it => italian,
      FuzzyLocale.en => english,
    };
  }

  /// Default English locale
  static const english = FuzzyTimeLocale(
    locale: FuzzyLocale.en,
    prefixAbout: 'about',
    prefixLessThan: 'less than',
    futureWrapper: _englishFuture,
    pastWrapper: _englishPast,
    futureWrapperShort: _englishFuture,
    pastWrapperShort: _englishPast,
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
    secondShort: 's',
    minuteShort: 'min',
    hourShort: 'hr',
    dayShort: 'd',
    weekShort: 'w',
    monthShort: 'mo',
    yearShort: 'y',
    pluralize: _englishPlural,
  );

  static String _englishFuture(String time) => 'in $time';
  static String _englishPast(String time) => '$time ago';

  static String _englishPlural(String unit, int count) {
    return count == 1 ? unit : '${unit}s';
  }

  /// Spanish locale
  static const spanish = FuzzyTimeLocale(
    locale: FuzzyLocale.es,
    prefixAbout: 'unos',
    prefixLessThan: 'menos de',
    futureWrapper: _spanishFuture,
    pastWrapper: _spanishPast,
    futureWrapperShort: _spanishFuture,
    pastWrapperShort: _spanishPast,
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
    secondShort: 's',
    minuteShort: 'min',
    hourShort: 'h',
    dayShort: 'd',
    weekShort: 'sem',
    monthShort: 'mes',
    yearShort: 'a',
    pluralize: _spanishPlural,
  );

  static String _spanishFuture(String time) => 'en $time';
  static String _spanishPast(String time) => 'hace $time';

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
    locale: FuzzyLocale.fr,
    prefixAbout: 'environ',
    prefixLessThan: 'moins de',
    futureWrapper: _frenchFuture,
    pastWrapper: _frenchPast,
    futureWrapperShort: _frenchFuture,
    pastWrapperShort: _frenchPast,
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
    secondShort: 's',
    minuteShort: 'min',
    hourShort: 'h',
    dayShort: 'j',
    weekShort: 'sem',
    monthShort: 'mois',
    yearShort: 'a',
    pluralize: _frenchPlural,
  );

  static String _frenchFuture(String time) => 'dans $time';
  static String _frenchPast(String time) => 'il y a $time';

  static String _frenchPlural(String unit, int count) {
    if (count == 1) return unit;
    if (unit.endsWith('s') || unit.endsWith('x')) return unit;
    return '${unit}s';
  }

  /// Portuguese locale
  static const portuguese = FuzzyTimeLocale(
    locale: FuzzyLocale.pt,
    prefixAbout: 'cerca de',
    prefixLessThan: 'menos de',
    futureWrapper: _portugueseFuture,
    pastWrapper: _portuguesePast,
    futureWrapperShort: _portugueseFuture,
    pastWrapperShort: _portuguesePast,
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
    secondShort: 's',
    minuteShort: 'min',
    hourShort: 'h',
    dayShort: 'd',
    weekShort: 'sem',
    monthShort: 'm',
    yearShort: 'a',
    pluralize: _portuguesePlural,
  );

  static String _portugueseFuture(String time) => 'em $time';
  static String _portuguesePast(String time) => 'há $time';

  static String _portuguesePlural(String unit, int count) {
    if (count == 1) return unit;
    if (unit.endsWith('a')) return '${unit}s';
    if (unit.endsWith('o')) return '${unit}s';
    if (unit.endsWith('s')) return '${unit}es';
    return '${unit}s';
  }

  /// German locale
  static const german = FuzzyTimeLocale(
    locale: FuzzyLocale.de,
    prefixAbout: 'etwa',
    prefixLessThan: 'weniger als',
    futureWrapper: _germanFuture,
    pastWrapper: _germanPast,
    futureWrapperShort: _germanFuture,
    pastWrapperShort: _germanPast,
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
    secondShort: 's',
    minuteShort: 'min',
    hourShort: 'std',
    dayShort: 't',
    weekShort: 'w',
    monthShort: 'mo',
    yearShort: 'j',
    pluralize: _germanPlural,
  );

  static String _germanFuture(String time) => 'in $time';
  static String _germanPast(String time) => 'vor $time';

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

  /// Italian locale
  static const italian = FuzzyTimeLocale(
    locale: FuzzyLocale.it,
    prefixAbout: 'circa',
    prefixLessThan: 'meno di',
    futureWrapper: _italianFuture,
    pastWrapper: _italianPast,
    futureWrapperShort: _italianFuture,
    pastWrapperShort: _italianPast,
    now: 'ora',
    shortNow: 'ora',
    fewSeconds: 'alcuni secondi',
    second: 'secondo',
    minute: 'minuto',
    hour: 'ora',
    day: 'giorno',
    week: 'settimana',
    month: 'mese',
    year: 'anno',
    secondShort: 's',
    minuteShort: 'min',
    hourShort: 'h',
    dayShort: 'g',
    weekShort: 'sett',
    monthShort: 'm',
    yearShort: 'a',
    pluralize: _italianPlural,
  );

  static String _italianFuture(String time) => 'tra $time';
  static String _italianPast(String time) => '$time fa';

  static String _italianPlural(String unit, int count) {
    if (count == 1) return unit;
    if (unit == 'secondo') return 'secondi';
    if (unit == 'minuto') return 'minuti';
    if (unit == 'ora') return 'ore';
    if (unit == 'giorno') return 'giorni';
    if (unit == 'settimana') return 'settimane';
    if (unit == 'mese') return 'mesi';
    if (unit == 'anno') return 'anni';
    return unit;
  }

  String _unitLabel(FuzzyTimeUnit unit) {
    return switch (unit) {
      FuzzyTimeUnit.second => second,
      FuzzyTimeUnit.minute => minute,
      FuzzyTimeUnit.hour => hour,
      FuzzyTimeUnit.day => day,
      FuzzyTimeUnit.week => week,
      FuzzyTimeUnit.month => month,
      FuzzyTimeUnit.year => year,
    };
  }

  /// Helper to return a localized short unit label.
  String shortUnitLabel(FuzzyTimeUnit unit) {
    return switch (unit) {
      FuzzyTimeUnit.second => secondShort,
      FuzzyTimeUnit.minute => minuteShort,
      FuzzyTimeUnit.hour => hourShort,
      FuzzyTimeUnit.day => dayShort,
      FuzzyTimeUnit.week => weekShort,
      FuzzyTimeUnit.month => monthShort,
      FuzzyTimeUnit.year => yearShort,
    };
  }

  /// Helper to format a value with a localized unit.
  String formatUnit(int value, FuzzyTimeUnit unit) {
    final localized = _unitLabel(unit);
    final inflected = pluralize(localized, value);
    return '$value $inflected';
  }
}
