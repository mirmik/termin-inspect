# C++ API

## InspectRegistry

Ключевые задачи:
- регистрация полей (`add`, `add_with_callbacks`, `add_with_accessors`);
- настройка inheritance (`set_type_parent`);
- get/set и serialize/deserialize через `tc_value`.

Пример:

```cpp
struct Base { int hp = 100; };
struct Derived : Base { std::string name = "unit"; };

auto& reg = tc::InspectRegistry::instance();
reg.add<Base, int>("Base", &Base::hp, "hp", "HP", "int");
reg.add<Derived, std::string>("Derived", &Derived::name, "name", "Name", "string");
reg.set_type_parent("Derived", "Base");
```

## KindRegistryCpp

- `register_kind(name, serialize, deserialize)`
- `serialize(kind, any)`
- `deserialize(kind, tc_value*, context)`
- `kinds()`

## Макросы регистрации

В `tc_inspect_cpp.hpp` доступны helper-макросы:
- `INSPECT_FIELD`
- `INSPECT_FIELD_RANGE`
- `INSPECT_FIELD_CALLBACK`
- `INSPECT_FIELD_CHOICES`
- `INSPECT_BUTTON`
- `SERIALIZABLE_FIELD`
