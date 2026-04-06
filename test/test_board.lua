local board = require("main.board")

local function assert_eq(a, b, msg)
	assert(a == b, (msg or "") .. tostring(a) .. " ~= " .. tostring(b))
end

local function test_empty_winner_nil()
	local b = board.empty_board()
	assert_eq(board.winner(b), nil)
end

local function test_row_win()
	local b = board.empty_board()
	b[1], b[2], b[3] = 1, 1, 1
	assert_eq(board.winner(b), 1)
end

local function test_col_win()
	local b = board.empty_board()
	b[2], b[5], b[8] = 2, 2, 2
	assert_eq(board.winner(b), 2)
end

local function test_diag_win()
	local b = board.empty_board()
	b[3], b[5], b[7] = 1, 1, 1
	assert_eq(board.winner(b), 1)
end

local function test_draw()
	local b = board.empty_board()
	-- Full board, no line (verified manually)
	b[1], b[2], b[3] = 1, 2, 1
	b[4], b[5], b[6] = 2, 1, 1
	b[7], b[8], b[9] = 2, 1, 2
	assert(board.is_full(b))
	assert_eq(board.winner(b), nil)
	assert(board.is_draw(b))
end

local function test_apply_invalid()
	local b = board.empty_board()
	local ok, err = board.apply_move(b, 1, 10)
	assert(not ok and err == "bad_index")
	ok, err = board.apply_move(b, 1, 1)
	assert(ok)
	ok, err = board.apply_move(b, 2, 1)
	assert(not ok and err == "occupied")
end

local function test_apply_valid()
	local b = board.empty_board()
	assert(board.apply_move(b, 1, 5))
	assert_eq(b[5], 1)
end

return function()
	test_empty_winner_nil()
	test_row_win()
	test_col_win()
	test_diag_win()
	test_draw()
	test_apply_invalid()
	test_apply_valid()
end
