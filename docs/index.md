# termin-inspect

`termin-inspect` — библиотека inspect/kind подсистемы, вынесенная из `termin`.

Пакет объединяет:
- C dispatcher для inspect (`tc_inspect_*`);
- C dispatcher для kind (`tc_kind_*`);
- C++ runtime (`InspectRegistry`, `KindRegistryCpp`);
- Python bridge (nanobind-слой для Python-классов и kind handlers).

## Рекомендуемый маршрут

1. [Быстрый старт](getting-started.md)
2. [Архитектура](architecture.md)
3. [Inspect Dispatcher](inspect-dispatcher.md)
4. [Kind System](kind-system.md)
5. [C++ API](cpp-api.md)
6. [Python bridge](python-bridge.md)
7. [Интеграция](integration.md)

## Scope

`termin-inspect` не зависит от `termin-scene`/`termin-graphics`/`termin-core`.
Базовые зависимости:
- `termin_base` (типы, `tc_value`, логирование);
- опционально Python + nanobind (если включен `TI_BUILD_PYTHON`).
