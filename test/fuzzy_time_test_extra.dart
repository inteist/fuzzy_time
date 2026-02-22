import 'package:flutter_test/flutter_test.dart';
import 'package:fuzzy_time/fuzzy_time.dart';

void main() {
  test('extra', () {
    print(const Duration(seconds: 119).fuzzyTime);
    print(const Duration(seconds: 56).fuzzyTime);
    print(const Duration(minutes: 56).fuzzyTime);
    print(const Duration(hours: 23).fuzzyTime);
    print(const Duration(days: 28).fuzzyTime);
    print(const Duration(days: 30).fuzzyTime);
  });
}
