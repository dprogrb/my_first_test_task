--- Match state: best-of-3 (first to 2 game wins), alternating starters per round.
local board = require("main.board")

local M = {}

local Match = {}
Match.__index = Match

function M.new()
	local self = setmetatable({}, Match)
	self:reset_match()
	return self
end

function Match:reset_match()
	self.board = board.empty_board()
	self.scores = { [1] = 0, [2] = 0 }
	self.starting_player = 1
	self.current_player = 1
	self.round = 1
	self.phase = "playing_round"
end

--- @return table result
function Match:try_move(index)
	if self.phase == "match_over" then
		return { ok = false, reason = "match_over" }
	end
	if self.phase ~= "playing_round" then
		return { ok = false, reason = "wrong_phase" }
	end

	local ok, err = board.apply_move(self.board, self.current_player, index)
	if not ok then
		return { ok = false, reason = err or "invalid" }
	end

	local w = board.winner(self.board)
	if w then
		self.scores[w] = self.scores[w] + 1
		local match_ended = self.scores[w] >= 2
		if match_ended then
			self.phase = "match_over"
		else
			self.phase = "between_rounds"
		end
		return {
			ok = true,
			round_ended = true,
			round_draw = false,
			winner_round = w,
			match_ended = match_ended,
			winner_match = match_ended and w or nil,
		}
	end

	if board.is_draw(self.board) then
		self.phase = "between_rounds"
		return {
			ok = true,
			round_ended = true,
			round_draw = true,
			winner_round = nil,
			match_ended = false,
			winner_match = nil,
		}
	end

	self.current_player = (self.current_player == 1) and 2 or 1
	return {
		ok = true,
		round_ended = false,
		round_draw = false,
	}
end

--- After a round ends (win or draw), call this to begin the next round if the match continues.
function Match:start_next_round()
	if self.phase ~= "between_rounds" then
		return false
	end
	if self.scores[1] >= 2 or self.scores[2] >= 2 then
		return false
	end
	self.starting_player = (self.starting_player == 1) and 2 or 1
	self.current_player = self.starting_player
	self.board = board.empty_board()
	self.round = self.round + 1
	self.phase = "playing_round"
	return true
end

return M
