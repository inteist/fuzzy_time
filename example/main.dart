import 'package:fuzzy_time/fuzzy_time.dart';

void main() {
  // ============================================
  // Basic Usage Examples
  // ============================================

  // Example 1: Fuzzy time from DateTime (past)
  final fiveMinutesAgo = DateTime.now().subtract(const Duration(minutes: 5));
  print(FuzzyTime.from(fiveMinutesAgo));
  // Output: "about 5 minutes ago"

  // Example 2: Fuzzy time from DateTime (future)
  final tenMinutesFromNow = DateTime.now().add(const Duration(minutes: 10));
  print(FuzzyTime.from(tenMinutesFromNow));
  // Output: "in about 10 minutes"

  // Example 3: Short form
  print(FuzzyTime.from(fiveMinutesAgo, form: FuzzyForm.short));
  // Output: "~5 min ago"

  // Example 4: Duration examples
  final duration = const Duration(hours: 2, minutes: 30);
  print(duration.fuzzy);
  // Output: "about 2 hours"

  print(duration.fuzzyShort);
  // Output: "~2 hr"

  // Example 5: Various duration formats
  print(const Duration(seconds: 30).fuzzy);
  // Output: "a few seconds"

  print(const Duration(minutes: 7).fuzzy);
  // Output: "about 5 minutes"

  print(const Duration(minutes: 8).fuzzy);
  // Output: "less than 10 minutes"

  print(const Duration(days: 3).fuzzy);
  // Output: "about 3 days"

  // ============================================
  // Localization Examples
  // ============================================

  final testDuration = const Duration(minutes: 5);
  final testTime = DateTime.now().subtract(const Duration(minutes: 5));

  // Spanish
  FuzzyTimeLocale.setLocale(FuzzyLocale.es);
  print('\n--- Spanish ---');
  print(testDuration.fuzzy); // "unos 5 minutos"
  print(FuzzyTime.from(testTime)); // "hace unos 5 minutos"

  // French
  FuzzyTimeLocale.setLocale(FuzzyLocale.fr);
  print('\n--- French ---');
  print(testDuration.fuzzy); // "environ 5 minutes"
  print(FuzzyTime.from(testTime)); // "il y a environ 5 minutes"

  // Portuguese
  FuzzyTimeLocale.setLocale(FuzzyLocale.pt);
  print('\n--- Portuguese ---');
  print(testDuration.fuzzy); // "cerca de 5 minutos"
  print(FuzzyTime.from(testTime)); // "há cerca de 5 minutos"

  // German
  FuzzyTimeLocale.setLocale(FuzzyLocale.de);
  print('\n--- German ---');
  print(testDuration.fuzzy); // "etwa 5 Minuten"
  print(FuzzyTime.from(testTime)); // "vor etwa 5 Minuten"

  // Italian
  FuzzyTimeLocale.setLocale(FuzzyLocale.it);
  print('\n--- Italian ---');
  print(testDuration.fuzzy); // "circa 5 minuti"
  print(FuzzyTime.from(testTime)); // "5 minuti fa"

  // Reset to English
  FuzzyTimeLocale.setLocale(FuzzyLocale.en);
  print('\n--- English (reset) ---');
  print(testDuration.fuzzy); // "about 5 minutes"
  print(FuzzyTime.from(testTime)); // "about 5 minutes ago"
}
