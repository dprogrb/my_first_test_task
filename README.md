# XO — крестики-нолики (Defold)

![GamePlay](https://github.com/user-attachments/assets/bdd3d5b3-ac64-4a83-a9cb-9c39e83d287b)

Модульная реализация: матч **до двух побед в партиях** (best-of-3), ничья в партии без очков, **чередование первого хода** между партиями. Логика доски и матча — в Lua-модулях без привязки к GUI; сцена интерфейса вызывает только `try_move` / `start_next_round` / `reset_match`.

## Структура

| Путь | Назначение |
|------|------------|
| [main/board.lua](main/board.lua) | Доска 3×3: ход, победитель, ничья |
| [main/match.lua](main/match.lua) | Счёт матча, фазы, чередование старта партии |
| [main/game.gui](main/game.gui) | Сцена GUI (клетки, счёт, попапы) |
| [main/game.gui_script](main/game.gui_script) | Ввод, отображение, попапы |
| [main/game.go](main/game.go) | Game object с встроенным GUI |
| [main/main.collection](main/main.collection) | Стартовая коллекция с `game.go` |
| [test/run_tests.lua](test/run_tests.lua) | Запуск автотестов логики (Lua 5.1) |
| [docs/UML.md](docs/UML.md) | Диаграммы UML (Mermaid) |
| [docs/TZ_TESTS.md](docs/TZ_TESTS.md) | ТЗ на тесты |
| [docs/TZ_CODE.md](docs/TZ_CODE.md) | ТЗ на код для разработчика |

## Запуск игры

1. Откройте проект в **Defold Editor**.
2. Соберите/запустите (**Project ▸ Build**).  
3. Управление: **клик мышью** по клеткам (см. [input/game.input_binding](input/game.input_binding), действие `touch`).

После партии (победа или ничья) появляется панель — **тап/клик** для следующей партии. После матча — тап для новой игры.

## Запуск тестов (без редактора)

Из корня проекта (нужен установленный **Lua 5.1**):

```bat
lua test\run_tests.lua
```

Ожидаемый вывод: `All tests passed.`

## Регенерация `game.gui` (опционально)

Файл [main/game.gui](main/game.gui) можно пересобрать скриптом:

```bat
python tools\_gen_gui.py
```

## Документация

- UML и сценарии взаимодействия: [docs/UML.md](docs/UML.md)
- Требования к тестам: [docs/TZ_TESTS.md](docs/TZ_TESTS.md)
- Требования к реализации: [docs/TZ_CODE.md](docs/TZ_CODE.md)
