# Python bridge

Python bridge построен на nanobind и добавляет inspect/kind поддержку для Python-классов.

## Основные сущности

- `tc::InspectRegistryPythonExt`
  - регистрация Python fields (`register_python_fields`)
  - Python `get/set`
  - `deserialize_all_py`

- `tc::KindRegistryPython`
  - Python handlers `serialize/deserialize`
  - mapping Python type -> kind

- `tc::KindRegistry`
  - facade, объединяющий C++ и Python registry.

## Наследование Python типов

Наследование полей задается так же, как в C++:
- зарегистрировать поля каждого типа;
- вызвать `InspectRegistry::set_type_parent(child, parent)`.

`all_fields(child)` включает поля предка.
