# UML (Mermaid)

Диаграммы можно просмотреть в GitHub, VS Code / Cursor с расширением Mermaid или на [mermaid.live](https://mermaid.live).

## Классы (логические роли)

```mermaid
classDiagram
    direction TB
    class BoardModule {
        +empty_board()
        +apply_move(board, player, index)
        +winner(board)
        +is_draw(board)
    }
    class MatchModule {
        +new()
        +try_move(cell_index) MoveResult
        +start_next_round()
        +reset_match()
        +scores table
        +round number
        +phase string
    }
    class GameGuiScript {
        +init()
        +on_input(action_id, action)
        +full_refresh()
    }
    class MoveResult {
        <<record>>
        ok boolean
        reason string
        round_ended boolean
        round_draw boolean
        winner_round int|nil
        match_ended boolean
        winner_match int|nil
    }
    MatchModule --> BoardModule : uses
    MatchModule ..> MoveResult : returns
    GameGuiScript --> MatchModule : calls
```

## Последовательность хода

```mermaid
sequenceDiagram
    participant User
    participant Gui as GameGuiScript
    participant Match as MatchModule
    participant Board as BoardModule
    User->>Gui: click cell
    Gui->>Gui: if input_locked then continue popup
    Gui->>Match: try_move(index)
    Match->>Board: apply_move / winner / is_draw
    Board-->>Match: state
    Match-->>Gui: MoveResult
    alt invalid
        Gui-->>User: ignore
    else round continues
        Gui->>Gui: refresh cells
    else round end, match continues
        Gui->>Gui: show round popup
    else match end
        Gui->>Gui: show match popup
    end
```

## Состояния матча

```mermaid
stateDiagram-v2
    [*] --> playing_round
    playing_round --> between_rounds: round finished (win or draw)
    playing_round --> match_over: score 2 for one player
    between_rounds --> playing_round: start_next_round()
    match_over --> playing_round: reset_match()
```
