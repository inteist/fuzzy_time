# fuzzy_time

A simple, dependency-free Flutter/Dart package that converts `DateTime` and `Duration` objects into human-friendly, "fuzzy" conversational strings like "about 5 minutes ago" or "in less than 2 hours".

## Features
- **Relative DateTime Formatting**: Generate relative timestamps (e.g. "5 minutes ago", "in a few seconds", "about 2 weeks ago") using the static `FuzzyTime` API e.g. `FuzzyTime.from(DateTime.now().subtract(const Duration(minutes: 5)))`.
  - supports times both in the past and in the future (relative to `DateTime.now()`)
- **Standalone Duration Formatting**: (via Duration extension) - convert strict durations into readable approximations e.g. `Duration(minutes: 5).fuzzyTime` will return "about 5 minutes".
- **Short & Long Forms**: Support for both conversational (long) formats and compact (short) formats (e.g., "about 5 minutes ago" or "~5 min ago").
- **Built-in Localization**: Out-of-the-box support for multiple languages using strongly-typed enums (English, Spanish, French, Portuguese, German, Italian).
- **Zero Third-Party Dependencies**: Extremely lightweight and fast.

## Getting started

Add `fuzzy_time` to your `pubspec.yaml`:

```yaml
dependencies:
  fuzzy_time:
```

Import it in your Dart code:

```dart
import 'package:fuzzy_time/fuzzy_time.dart';
```

## Usage

### Relative Time (`DateTime`)

Use the static `FuzzyTime` API to convert a `DateTime` relative to `DateTime.now()`. It automatically identifies whether the time is in the past or future and applies the appropriate tense ("ago" or "in").

```dart
// Past times
final past = DateTime.now().subtract(const Duration(minutes: 5));

print(FuzzyTime.from(past)); 
// Output: "about 5 minutes ago"

print(FuzzyTime.from(past, form: FuzzyForm.short)); 
// Output: "~5 min ago"

// Future times
final future = DateTime.now().add(const Duration(hours: 2));

print(FuzzyTime.from(future)); 
// Output: "in about 2 hours"
```

### Duration Length (`Duration`)

If you just need to know the length of a `Duration` without the past/future tense context, use the included **extension** on `Duration`.

```dart
final duration = const Duration(minutes: 42);

print(duration.fuzzyTime);
// Output: "about 40 minutes"

print(duration.fuzzyTimeShort);
// Output: "~40 min"
```

## Localization

`fuzzy_time` supports a variety of languages via the `FuzzyLocale` enum. You can change the global locale used by the package at any time, for instance, during the initialization of your app or when the user changes their language setting.

```dart
// Simply pass the target locale from the predefined enum:
FuzzyTimeLocale.setLocale(FuzzyLocale.es);

final past = DateTime.now().subtract(const Duration(days: 3));
print(FuzzyTime.from(past)); 
// Output: "hace unos 3 días"
```

Currently supported locales:
- `FuzzyLocale.en` (English - Default)
- `FuzzyLocale.es` (Spanish)
- `FuzzyLocale.fr` (French)
- `FuzzyLocale.pt` (Portuguese)
- `FuzzyLocale.de` (German)
- `FuzzyLocale.it` (Italian)

*Note, locales were auto generated with Gemini 3.1 model.


## Additional information

Contributions to add more languages or address issues are welcome. Feel free to open an issue or pull request on the repository!
