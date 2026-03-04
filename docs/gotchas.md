# Ограничения и gotchas

- Dispatch не «угадывает» типы: `type_name` должен совпадать с зарегистрированным именем.
- `set_type_parent` задает inheritance только на уровне registry metadata.
- В `deserialize` context — это `void*`; интерпретация контекста лежит на consumer-слое.
- Python bridge требует валидной инициализации Python runtime.
- Если собран `TI_BUILD_PYTHON=ON`, в системе должен быть доступен nanobind и Python dev.
