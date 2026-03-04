# Inspect Dispatcher

`tc_inspect` в `termin-inspect` — это dispatcher, который вызывает backend по language vtable.

## Базовые операции

- `tc_inspect_has_type(type_name)`
- `tc_inspect_get(obj, type_name, path)`
- `tc_inspect_set(obj, type_name, path, value, context)`
- `tc_inspect_serialize(obj, type_name)`
- `tc_inspect_deserialize(obj, type_name, data, context)`

## Поля и метаданные

- `tc_inspect_field_count(type_name)`
- `tc_inspect_get_field_info(type_name, index, out)`
- `tc_inspect_find_field_info(type_name, path, out)`

## Поведение на ошибках

Модель fail-soft:
- при невалидном типе/поле — `nil`, no-op или `false`;
- WARN/ERROR пишутся через `tc_log`.
