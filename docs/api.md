# API Reference

## Публичные заголовки

- `include/inspect/tc_inspect.h`
- `include/inspect/tc_kind.h`
- `include/tc_inspect_cpp.hpp`
- `include/inspect/tc_kind_cpp.hpp`
- `include/inspect/tc_inspect_python.hpp` (при `TI_BUILD_PYTHON=ON`)
- `include/inspect/tc_kind_python.hpp` (при `TI_BUILD_PYTHON=ON`)

## Точки инициализации

- `tc_inspect_kind_core_init()`
- `tc::init_cpp_inspect_vtable()`
- `tc::init_python_lang_vtable()`

## Совместимость

Сохранены совместимые symbols для существующих consumers:
- `tc_inspect_python_adapter_init()`
- `tc_init_full()`
