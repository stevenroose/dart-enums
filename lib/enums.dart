library enums;

import "dart:mirrors";
import "dart:collection";

abstract class Enum {

  const Enum();

  static Enum valueOf(Type enumType, String name) {
    if(!reflectType(enumType).isSubtypeOf(reflectType(Enum)))
      throw new ArgumentError("Given enumType is not a subtype of Enum");
    return _getEnumData(enumType).index[name];
  }

  static Iterable<Enum> values(Type enumType) {
    if(!reflectType(enumType).isSubtypeOf(reflectType(Enum)))
      throw new ArgumentError("Given enumType is not a subtype of Enum");
    return _getEnumData(enumType).values.keys;
  }

  int get ordinal => _getEnumData(this.runtimeType).values[this].ordinal;

  String get name => _getEnumData(this.runtimeType).values[this].name;

  @override
  String toString() => name;

  static Map<Type, _EnumData> _enumData;

  static _EnumData _getEnumData(Type type) {
    if(_enumData == null)
      _enumData = new Map<Type, _EnumData>();
    if(!_enumData.containsKey(type))
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
  final int ordinal;
  final String name;
  const _EnumValueMetaData(this.ordinal, this.name);
}