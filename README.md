# termin-inspect

Standalone inspect/kind core package extracted from `termin`.

## Current Scope

- C dispatcher core:
  - `inspect/tc_inspect.h`
  - `inspect/tc_kind.h`
  - `src/tc_inspect.c`
  - `src/tc_kind.c`
- C++ core runtime:
  - `tc_inspect_cpp.hpp`
  - `inspect/tc_kind_cpp.hpp`
  - `src/tc_inspect_core_instance.cpp`
  - `src/tc_kind_cpp.cpp`
- Minimal smoke test (`tests/test_main.c`):
  - lang vtable dispatch
  - `tc_kind_parse`

Adapters (`tc_component_inspect_*`, `tc_pass_inspect_*`) stay in `termin`.
Python inspect/kind bridge stays in `termin` for now.

## Build

```bash
cmake -S . -B build
cmake --build build -j4
ctest --test-dir build --output-on-failure
```

## Integration in termin

`termin/core_c/CMakeLists.txt` now supports optional external linkage:

- `TC_USE_EXTERNAL_INSPECT=ON` (default): tries `find_package(termin_inspect)`
- fallback: embedded `tc_inspect.c`/`tc_kind.c` if package is not found
