# Быстрый старт

Минимальный цикл:
1. собрать и установить `termin-base`;
2. собрать `termin-inspect`;
3. прогнать `ctest`.

## Сборка

```bash
cmake -S . -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DTI_BUILD_TESTS=ON \
  -DTI_BUILD_PYTHON=ON \
  -DCMAKE_PREFIX_PATH=/path/to/termin-base/install

cmake --build build --parallel
ctest --test-dir build --output-on-failure
```

## Минимальная конфигурация (без Python bridge)

```bash
cmake -S . -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DTI_BUILD_TESTS=ON \
  -DTI_BUILD_PYTHON=OFF \
  -DCMAKE_PREFIX_PATH=/path/to/termin-base/install
```

## Что проверяют тесты

- C dispatcher и базовые контракты;
- C++ `InspectRegistry` с наследованием;
- Python integration path для Python-классов с наследованием.
