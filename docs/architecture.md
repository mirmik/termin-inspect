# Архитектура

## Слои

1. C слой (`src/tc_inspect.c`, `src/tc_kind.c`)
- dispatch по language vtable;
- единый C API surface.

2. C++ слой (`include/tc_inspect_cpp.hpp`, `include/inspect/tc_kind_cpp.hpp`)
- `InspectRegistry` и `KindRegistryCpp`;
- сериализация/десериализация полей через `tc_value`.

3. Python bridge (`include/inspect/tc_inspect_python.hpp`, `include/inspect/tc_kind_python.hpp`)
- `KindRegistryPython`, `KindRegistry` facade;
- регистрация Python inspect-fields;
- интеграция с C dispatch через language registry/vtable.

## Инициализация

- C++ inspect vtable: `tc::init_cpp_inspect_vtable()`
- C kind registries:
  - C++ lang registry: инициализируется через C++ core
  - Python lang registry: `tc::init_python_lang_vtable()`

Совместимый entrypoint:
- `tc_inspect_kind_core_init()`

## Принцип контекста

Inspect/Kind не завязаны на `tc_scene_handle` внутри API.
Контекст передается как `void*` и интерпретируется consumer-слоем (например `termin`).
