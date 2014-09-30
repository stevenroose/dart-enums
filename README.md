dart-enums
==========
[![Build Status](https://drone.io/github.com/stevenroose/dart-enums/status.png)](https://drone.io/github.com/stevenroose/dart-enums/latest)

Dart does not have native support for Enums and this library tries to fill this void. Largely inspired by Java's enum features, this library provides an extendable Enum class that provides all enum instances with an ordinal and a name. Also a `valueOf` constructor and `values()` iterable are provided.

Example use:

```dart
class MyEnum extends Enum {
  // the enum values
  static const MyEnum nr1 = const MyEnum._(5);
  static const MyEnum nr2 = const MyEnum._(10);
  static const MyEnum nr3 = const MyEnum._(15);

  // these two lines are required to add support for values and valueOf
  static MyEnum valueOf(String name) => Enum.valueOf(MyEnum, name);
  static Iterable<MyEnum> get values => Enum.values(MyEnum);

  // your own implementation
  final int value;
  const MyEnum._(this.value);
```
