# XO — крестики-нолики (Defold)

![ViewGamePlay](https://github.com/user-attachments/assets/3613f904-d5a8-4d2e-afbd-dd7c188c82fb)

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


## Создание проекта с помощью Cursos

### Первый промпт:
```bat
I'm planning to create a tic-tac-toe game with three rounds and a point system for each winning round awarded to the corresponding player. After the third round, a pop-up should be displayed congratulating the winning player on their victory.

I'm assuming the project should be implemented in a similar way.
GAME STATE, which stores a table of cells selected by player N.
Three rounds in the game, a win for a player is +1 point.
Player 1 makes a move. - Clicks on the GUI node.
Player 2 makes a move. - Clicks on the GUI node.
Check for the winning number. (Check for a win/draw/loss condition).
After the third round, determine the winner based on the player's score.
If Player 1 has more points than Player 2, then Player 2 wins. If Player 2 has more points, then Player 2 wins. We'll show a priest congratulating the winner.
It's a classic tic-tac-toe game with three rounds.
It's important to use a modular approach when designing the structure. Structured programming is possible. Scripts can be used like game_manager or gui_manager, which are included in my game modules.
In other words, we'll try to separate as much code as possible from the visuals.
Most likely, each GUI node will correspond to its own field. So, when a player clicks on a node, an entry is made in GAME_STATE, which will record information about the player's turn. Then comes the next turn.
What do you think about the above? What nuances have I missed?
Basically, I need a plan to get started.
Please answer in English.
Create please UML DIAGRAMM, thanks

Answer me in Russhia language
```

### Второй промпт:
```bat
Нам нужен вариант: до 2 побед (best-of-3) — третий раунд может не понадобиться.
Нужно выбрать один вариант; от этого зависит условие показа финального попапа.
Чередование (X, O) тоже должно присутствовать.
Если требуется ничья, то покажем GUI для ничьи.
Давай попроубем так:
Логику победы лучше не класть в обработчик клика — только «запрос хода» → ответ «принято / отклонено / конец раунда / конец матча».

Да, так и есть, В GAME_STATE (или отдельной структуре матча) полезно хранить: round (1–3), scores {p1, p2}, current_player, board, phase (playing_round / between_rounds / match_over), флаг блокировки ввода на время анимации/попапа.

Давай попробуем так:
Рекомендуемые модули без привязки к узлам:

board.lua — применение хода, проверка линии, ничья.
match.lua — счёт, смена раунда, кто победил в матче.
GUI-скрипт: маппинг node_id → index, отрисовка X/O, показ попапа со священником.

Измени план в соответствии вышеуказанных правок.
```

### Третий промпт:
```bat
Составь тз для написания тестов.
Составь тз для написания кода программисту.
```

### Четвёртый промпт:
Создай файлы README проекта. Файлы UML, ТЗ. Выполни задачи по ТЗ по написанию тестов и кода игры.

А дальше токенов не хватило и пришлось ручками всё править.

## Работа без помощи Cursos:
По сути, он всё сделал, единственное, что он создал косячный игровой объект, не правильно добавил компонент и из-за этого пришлось самому создавать игровой объект, добавлять внутренний компонент.

Он использовал текстовые ноды, пришлось исправлять ноды на тип "box", чтобы добавить текстуру крестиков и ноликов, пустая ячейка.

Крестики и нолики сгенерированы Qwen3.6-Plus.

Также, дополнил код, написав две функции, одну для скрытия, другую для показа попапа после исхода матча.

По сути, правки в код были минимальны, дольше капался с расстановкой GUI.
