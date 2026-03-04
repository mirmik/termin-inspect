# termin-inspect

Standalone inspect/kind library for Termin.

Current state: extracted C dispatcher + C++ runtime + Python bridge.

## Documentation

Documentation is prepared for GitHub Pages via MkDocs.

- Source: [`docs/`](docs/)
- Config: [`mkdocs.yml`](mkdocs.yml)

Local preview:

```bash
pip install mkdocs mkdocs-material
mkdocs serve
```

## Build

```bash
cmake -S . -B build
cmake --build build -j4
ctest --test-dir build --output-on-failure
```
