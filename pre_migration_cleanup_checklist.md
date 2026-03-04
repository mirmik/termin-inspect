# Pre-Migration Cleanup Checklist (`termin` -> `termin-inspect`)

Дата среза: **March 4, 2026**.

Цель: вычистить текущие смешанные зависимости до фактического переноса кода в `termin-inspect`.

## 1. API boundary cleanup (C layer)

- [ ] Разделить `tc_inspect.h` на core API и adapter API.
- [ ] В core-хедере оставить только generic:
  - `tc_inspect_*`
  - `tc_kind_*`
  - `tc_kind_parse`
- [ ] Убрать из core-хедера:
  - `tc_component_inspect_*`
  - `tc_pass_inspect_*`
  - `tc_component_set_field_*`/`tc_component_get_field_*`
  - включения `tc_mesh.h`/`tc_material.h`
- [ ] Вынести component/pass/FFI функции в adapter headers (scene/render level).

Критерий:
- core header не содержит зависимостей на `tc_component`, `tc_pass`, `tc_mesh`, `tc_material`.

## 2. C++ inspect action abstraction

- [ ] Убрать component-centric тип action callback:
  - заменить `std::function<void(tc_component*)>` на generic callback.
- [ ] Ввести `InspectContext` (scene handle + user context).
- [ ] Обновить `InspectFieldInfo::action` и вызовы `action_field(...)`.
- [ ] Переписать `INSPECT_BUTTON` macro на generic вариант (без обязательного `CxxComponent::from_tc` в core).

Критерий:
- в core C++ inspect runtime нет прямой зависимости action-механизма от `tc_component`.

## 3. Split mixed runtime file (`tc_inspect_instance.cpp`)

- [ ] Разделить текущий mixed файл на:
  - core vtable wiring / registry bootstrap
  - scene component adapter
  - render pass adapter
- [ ] Из core части убрать include-ы на render (`frame_pass`) и domain resources.

Критерий:
- core inspect C++ файл не включает `render/tc_pass.h`, `frame_pass.hpp`, mesh/material registry API.

## 4. KindRegistryCpp domain cleanup

- [ ] Убрать auto-registration `tc_mesh`/`tc_material` из `KindRegistryCpp::instance()`.
- [ ] Оставить в core только builtin kinds (bool/int/float/double/string/vec3/quat + универсальные list-паттерны, если есть).
- [ ] Перенести регистрацию domain kinds в consumer adapters (scene/render layer).

Критерий:
- `tc_kind_cpp` в core не включает `termin/mesh/*` и `termin/material/*`.

## 5. Python inspect/kind abstraction cleanup

- [ ] Отделить generic Python bridge от scene-specific mapping.
- [ ] Убрать из core Python inspect bridge прямой доступ к `tc_component`/`tc->body`.
- [ ] Ввести adapter callback/object resolver для:
  - object unwrap
  - action invocation target
- [ ] Оставить nanobind module wiring, завязанный на `termin._native`, в consumer слое.

Критерий:
- Python core bridge работает с абстрактным `void*`/`PyObject*` без include/use `core/tc_component.h`.

## 6. Initialization decoupling

- [ ] Убрать склейку “всё сразу” через `tc_init_full()`.
- [ ] Разделить init-функции по слоям:
  - inspect/kind core init
  - scene adapter init
  - render adapter init
  - python adapter init
- [ ] Явно определить порядок вызова init в `termin` startup.

Критерий:
- core init не вызывает регистрацию scene/render domain kinds автоматически.

## 7. Adapter compatibility window

- [ ] Сохранить текущие внешние API как thin wrappers:
  - `tc_component_inspect_*`
  - `tc_pass_inspect_*`
  - C#/Python FFI входы
- [ ] Перевести реализации wrappers на новый generic core API.
- [ ] Зафиксировать deprecation notes (без fallback-слоёв в core).

Критерий:
- существующие callsites в `termin`/C#/Python работают без массовой одномоментной переписи.

## 8. Singleton/link topology guardrails

- [ ] Определить единый binary owner для `InspectRegistry` и `KindRegistryCpp`.
- [ ] Проверить, что при линковке `termin-inspect` + adapters не возникает дублей singleton.
- [ ] Добавить smoke-проверку на shared-lib topology.

Критерий:
- runtime видит единые registry instance во всех потребителях.

## 9. Test baseline before extraction

- [ ] C tests:
  - `tc_kind_parse`
  - inspect/kind dispatcher with mock lang registries
- [ ] C++ tests:
  - `InspectRegistry` add/get/set
  - inheritance field traversal
  - generic action callback invocation
- [ ] Python tests:
  - register fields + get/set/serialize/deserialize для generic объектов
  - lazy list handler
- [ ] Integration tests:
  - component adapter path
  - pass adapter path
  - external domain kind registration path (`tc_mesh`, `tc_material`)

Критерий:
- тесты зелёные до начала фактического переноса файлов.

## 10. Execution gate (go/no-go)

- [ ] Все пункты 1-6 закрыты.
- [ ] Есть совместимость через adapter wrappers (пункт 7).
- [ ] Зафиксирован владелец singleton (пункт 8).
- [ ] Есть зелёный тестовый baseline (пункт 9).

После этого можно начинать перенос кода в `termin-inspect` по этапам `inspect_kind_extraction_plan.md`.
