library enums.test;

import "package:enums/enums.dart";
import "package:unittest/unittest.dart";


class TestEnum extends Enum {
  static const TestEnum nr1 = const TestEnum._(5);
  static const TestEnum nr2 = const TestEnum._(10);
  static const TestEnum nr3 = const TestEnum._(15);

  static TestEnum valueOf(String name) => Enum.valueOf(TestEnum, name);
  static List<TestEnum> get values => Enum.values(TestEnum);

  final int value;
  const TestEnum._(this.value);
}

class OtherTestEnum extends Enum {
  static const OtherTestEnum nr1 = const OtherTestEnum._(5);
  static const OtherTestEnum nr2 = const OtherTestEnum._(10);
  static const OtherTestEnum nr3 = const OtherTestEnum._(15);

  static OtherTestEnum valueOf(String name) => Enum.valueOf(OtherTestEnum, name);

  final int value;
  const OtherTestEnum._(this.value);
}

void main() {
  test("ordinal", () {
    expect(TestEnum.nr1.index, equals(0));
    expect(TestEnum.nr2.index, equals(1));
    expect(TestEnum.nr3.index, equals(2));
  });
  test("name", () {
    expect(TestEnum.nr1.toString(), equals("nr1"));
    expect(TestEnum.nr2.toString(), equals("nr2"));
    expect(TestEnum.nr3.toString(), equals("nr3"));
  });
  test("valueOf", () {
    expect(TestEnum.valueOf("nr1"), equals(TestEnum.nr1));
    expect(TestEnum.valueOf("nr2"), equals(TestEnum.nr2));
    expect(TestEnum.valueOf("nr3"), equals(TestEnum.nr3));
    expect(TestEnum.valueOf("nr3").value, equals(15));
  });
  test("values", () {
    expect(TestEnum.values, equals([TestEnum.nr1, TestEnum.nr2, TestEnum.nr3]));
    expect(TestEnum.values[1], equals(TestEnum.nr2));
  });
  test("other", () {
    expect(OtherTestEnum.nr1.index, equals(0));
    expect(OtherTestEnum.valueOf("nr1"), equals(OtherTestEnum.nr1));
  });
}