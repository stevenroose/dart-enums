library enums;

import "dart:collection";
@MirrorsUsed(override: '*', targets: 'Enum')
import "dart:mirrors";

abstract class Enum {

  const Enum();

  /**
   * Get the instance of [enumType] with the name [name].
   */
  static Enum valueOf(Type enumType, dynamic name) {
    if(name is! String)
      name = name.toString();
    if(!reflectType(enumType).isSubtypeOf(reflectType(Enum)))
      throw new ArgumentError("Given enumType is not a subtype of Enum");
    return _getEnumData(enumType).index[name];
  }

  /**
   * Get an iterator that iterates over all instances or
   * the enum [enumType].
   */
  static List<Enum> values(Type enumType) {
    if(!reflectType(enumType).isSubtypeOf(reflectType(Enum)))
      throw new ArgumentError("Given enumType is not a subtype of Enum");
    return new List.from(_getEnumData(enumType).values.keys);
  }

  /**
   * This method makes sure all static enum instances are instantiated.
   *
   * This can be required when the constructor handles static data. E.g.:
   *
   *     class MyEnum extends Enum {
   *       static final MyEnum VALUE1 = new MyEnum._("identifier");
   *       MyEnum._(String identifier) {
   *         _identifierMap[identifier] = this;
   *       }
   *       static Map<String, MyEnum> _identifierMap = new Map<String, MyEnum>();
   *       static MyEnum fromIdentifier(String id) {
   *         Enum.ensureValuesInstantiated(MyEnum);
   *         return _identifierMap[id];
   *       }
   *     }
   */
  static void ensureValuesInstantiated(Type enumType) {
    if(_enumData.containsKey(enumType))
      return;
    TypeMirror tm = reflectType(enumType);
    ClassMirror cm = reflectClass(enumType);
    int ordinal = 0;
    cm.declarations.values
        .where((dec) => dec is VariableMirror && dec.isStatic && dec.type == tm)
        .forEach((dec) => cm.getField(dec.simpleName).reflectee);
    _enumData[enumType] == null;
  }

  /**
   * Get the index value of this enum instance. This value depends on
   * the order in which the instances are declared.
   */
  int get index => _getEnumData(this.runtimeType).values[this].index;

  /**
   * Returns the string representation of this enum instance.
   */
  @override
  String toString() => _getEnumData(this.runtimeType).values[this].name;

  static Map<Type, _EnumData> _enumData = new Map<Type, _EnumData>();

  static _EnumData _getEnumData(Type type) {
    if(!_enumData.containsKey(type) || _enumData[type] == null)
      _enumData[type] = _generateEnumData(type);
    return _enumData[type];
  }

  static _generateEnumData(Type type) {
    _EnumData ed = new _EnumData(new LinkedHashMap(), new Map());
    TypeMirror tm = reflectType(type);
    ClassMirror cm = reflectClass(type);
    int ordinal = 0;
    for(var dec in cm.declarations.values) {
      if(dec is VariableMirror && dec.isStatic && dec.type == tm) {
        var instance = cm.getField(dec.simpleName).reflectee;
        ed.values[instance] = new _EnumValueMetaData(ordinal++, MirrorSystem.getName(dec.simpleName));
        ed.index[MirrorSystem.getName(dec.simpleName)] = instance;
      }
    }
    return ed;
  }

}

class _EnumData<E> {
  final LinkedHashMap<E, _EnumValueMetaData<E>> values;
  final Map<String, E> index;
  const _EnumData(this.values, this.index);
}

class _EnumValueMetaData<E> {
  final int index;
  final String name;
  const _EnumValueMetaData(this.index, this.name);
}