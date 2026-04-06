local match = require("main.match")

local function assert_eq(a, b, msg)
	assert(a == b, (msg or "") .. tostring(a) .. " ~= " .. tostring(b))
end

local function test_reject_wrong_phase()
	local m = match.new()
	m.phase = "between_rounds"
	local r = m:try_move(5)
	assert(not r.ok and r.reason == "wrong_phase")
end

local function test_reject_occupied()
	local m = match.new()
	m:try_move(5)
	local r = m:try_move(5)
	assert(not r.ok and r.reason == "occupied")
end

local function test_alternate_moves()
	local m = match.new()
	local r = m:try_move(1)
	assert(r.ok and not r.round_ended)
	assert_eq(m.current_player, 2)
end

local function test_round_win_not_match()
	local m = match.new()
	-- P1 wins row 1
	m:try_move(1)
	m:try_move(4)
	m:try_move(2)
	m:try_move(5)
	local r = m:try_move(3)
	assert(r.ok and r.round_ended and r.winner_round == 1)
	assert(not r.match_ended)
	assert_eq(m.phase, "between_rounds")
	assert_eq(m.scores[1], 1)
end

local function test_start_next_round_alternates_starter()
	local m = match.new()
	m:try_move(1)
	m:try_move(4)
	m:try_move(2)
	m:try_move(5)
	m:try_move(3)
	assert_eq(m.phase, "between_rounds")
	assert(m:start_next_round())
	assert_eq(m.phase, "playing_round")
	assert_eq(m.starting_player, 2)
	assert_eq(m.current_player, 2)
	assert_eq(m.round, 2)
end

local function test_match_2_0()
	local m = match.new()
	-- Round 1: P1 wins top row
	m:try_move(1)
	m:try_move(4)
	m:try_move(2)
	m:try_move(5)
	m:try_move(3)
	assert(m:start_next_round())
	-- Round 2: P2 starts; P1 wins middle row (4,5,6) without P2 getting a line first
	m:try_move(1)
	m:try_move(4)
	m:try_move(9)
	m:try_move(5)
	m:try_move(2)
	local last = m:try_move(6)
	assert(last.ok and last.round_ended and last.winner_round == 1)
	assert(last.match_ended and last.winner_match == 1)
	assert_eq(m.phase, "match_over")
	local bad = m:try_move(8)
	assert(not bad.ok and bad.reason == "match_over")
end

local function test_draw_round()
	local m = match.new()
	m:try_move(1)
	m:try_move(2)
	m:try_move(3)
	m:try_move(4)
	m:try_move(5)
	m:try_move(7)
	m:try_move(6)
	m:try_move(9)
	local r = m:try_move(8)
	assert(r.ok and r.round_draw and r.round_ended)
	assert_eq(m.scores[1], 0)
	assert_eq(m.scores[2], 0)
	assert_eq(m.phase, "between_rounds")
end

return function()
	test_reject_wrong_phase()
	test_reject_occupied()
	test_alternate_moves()
	test_round_win_not_match()
	test_start_next_round_alternates_starter()
	test_match_2_0()
	test_draw_round()
end
