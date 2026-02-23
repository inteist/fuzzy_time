import 'package:fuzzy_time/fuzzy_time.dart';

void main() {
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
}
