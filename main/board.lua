--- Pure board logic (no match rules, no GUI).
local M = {}

local LINES = {
	{ 1, 2, 3 }, { 4, 5, 6 }, { 7, 8, 9 },
	{ 1, 4, 7 }, { 2, 5, 8 }, { 3, 6, 9 },
	{ 1, 5, 9 }, { 3, 5, 7 },
}

function M.empty_board()
	return { nil, nil, nil, nil, nil, nil, nil, nil, nil }
end

function M.clone(board)
	local b = {}
	for i = 1, 9 do
		b[i] = board[i]
	end
	return b
end

--- @return integer|nil 1, 2, or nil
function M.winner(board)
	for _, line in ipairs(LINES) do
		local a, c, d = line[1], line[2], line[3]
		local v = board[a]
		if v ~= nil and v == board[c] and v == board[d] then
			return v
		end
	end
	return nil
end

function M.is_full(board)
	for i = 1, 9 do
		if board[i] == nil then
			return false
		end
	end
	return true
end

function M.is_draw(board)
	return M.is_full(board) and M.winner(board) == nil
end

--- Mutates board. Returns ok, err_reason
function M.apply_move(board, player, index)
	if type(index) ~= "number" or index < 1 or index > 9 then
		return false, "bad_index"
	end
	if board[index] ~= nil then
		return false, "occupied"
	end
	board[index] = player
	return true
end

return M
