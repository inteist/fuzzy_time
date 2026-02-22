import 'package:flutter_test/flutter_test.dart';
import 'package:fuzzy_time/fuzzy_time.dart';

void main() {
  test('es', () {
    FuzzyTimeLocale.setLocale('es');
    print(const Duration(hours: 1).fuzzyTime);
  });
}
