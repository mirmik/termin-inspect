# Интеграция

## Через CMake package

```cmake
find_package(termin_inspect REQUIRED)
target_link_libraries(my_target PRIVATE termin_inspect::termin_inspect)
```

## Внутри termin

Ожидаемый путь:
1. `termin-core` и `entity_lib` линкуются с `termin_inspect::termin_inspect`;
2. inspect adapters (component/pass) остаются в consumer-слое;
3. consumer вызывает core init и свои adapter init в нужном порядке.

## Runtime

Убедитесь, что `libtermin_inspect.so` доступна в runtime path
(`LD_LIBRARY_PATH`, install rpath или копирование в дистрибутив).
