# Kind System

`tc_kind` — это language-aware dispatcher над kind handlers.

## Языковые реестры

Для каждого языка (`C++`, `Python`, ...) задается `tc_kind_lang_registry`:
- `has(kind)`
- `serialize(kind, input)`
- `deserialize(kind, input, context)`
- `list(...)`

## Основные вызовы

- `tc_kind_exists(name)`
- `tc_kind_has_lang(name, lang)`
- `tc_kind_serialize(name, lang, input)`
- `tc_kind_deserialize(name, lang, input, context)`
- `tc_kind_serialize_any(name, input)`
- `tc_kind_deserialize_any(name, input, context)`

## C++ runtime

`KindRegistryCpp` хранит C++ handlers (`std::any <-> tc_value`) и покрывает builtins:
- `bool`, `int`, `float`, `double`, `string`, `vec3`, `quat`, `enum`, и др.
