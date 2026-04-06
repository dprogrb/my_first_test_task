-- Run from project root: lua test/run_tests.lua
package.path = "?.lua;" .. package.path

local function run()
	require("test.test_board")()
	require("test.test_match")()
end

local ok, err = pcall(run)
if ok then
	print("All tests passed.")
	os.exit(0)
else
	print("Tests FAILED:", err)
	os.exit(1)
end
