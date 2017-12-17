local common = require "common"

--Part 2 was difficult.
--The necessary insight was that dances
--are associative if we keep parter moves and exchange moves
--in seperate structures.
--The associativity property allows us to calculate 1 billion
--dances in a fraction of a second.

local function parse_command(v)
  local command, arg1, arg2
  command, arg1 = string.match(v, "(s)(%d+)")
  if command then return command, tonumber(arg1) end
  command, arg1, arg2 = string.match(v, "(x)(%d+)%/(%d+)")
  if command then return command, tonumber(arg1), tonumber(arg2) end
  command, arg1, arg2 = string.match(v, "(p)(%a)%/(%a)")
  if command then return command, arg1, arg2 end
  error "no such command"
end

local function get_commands(input)
  local items = common.split(input, ",", true)
  return coroutine.wrap(function()
    for i, v in ipairs(items) do
      coroutine.yield(parse_command(v))
    end
  end)
end

local function itoa(i) return string.char(i + string.byte "a" - 1) end
local function atoi(c) return string.byte(c) - string.byte "a" + 1 end

local function exec_spin(arr, arg1)
  for i = 1, arg1 do
    table.insert(arr, 1, table.remove(arr))
  end
end
local function exec_exchange(arr, arg1, arg2)
  arg1, arg2 = arg1 + 1, arg2 + 1
  arr[arg1], arr[arg2] = arr[arg2], arr[arg1]
end
local function exec_partner(rename, arg1, arg2)
  local a, b = atoi(arg1), atoi(arg2)
  rename[a], rename[b] = rename[b], rename[a]
end
local function exec_add(dance1, dance2)
  local n = #dance1.exchange
  local dance3 = {exchange = {}, partners = {}}
  for i = 1,n do
    dance3.exchange[i] = dance2.exchange[dance1.exchange[i]]
    dance3.partners[i] = dance2.partners[dance1.partners[i]]
  end
  return dance3
end

local function build_dance_repeat(times, unit)
  local n = #unit.exchange
  local zero = {
    exchange = common.range(1,n+1),
    partners = common.range(1,n+1),
  }
  return common.repeat_associative(zero, unit, exec_add, times)
end
local function build_dance_unit(input, n)
  local arr = common.range(1,n+1)
  --map a letter to its "original" name.
  local rename = common.range(1,n+1)
  for c, arg1, arg2 in get_commands(input) do
    if c == "p" then
      exec_partner(rename, arg1, arg2)
    elseif c == "s" then
      exec_spin(arr, arg1)
    elseif c == "x" then
      exec_exchange(arr, arg1, arg2)
    end
  end
  --to apply the rename we want to convert into a map
  --from a given letter to the resulting name.
  local reversed = {}
  for i, v in ipairs(rename) do
    reversed[v] = i
  end
  return { exchange = arr, partners = reversed }
end
local function apply_dance(arr, dance)
  local result1 = {}
  for i, v in ipairs(dance.exchange) do
    result1[i] = arr[v]
  end
  local result2 = {}
  for i, v in ipairs(result1) do
    result2[i] = itoa(dance.partners[atoi(v)])
  end
  return result2
end

function day16_part1_helper(input, start)
  local arr = common.chars(start)
  local dance = build_dance_unit(input, #start)
  local result = apply_dance(arr, dance)
  return table.concat(result, "")
end
function day16_part1(input)
  return day16_part1_helper(input, "abcdefghijklmnop")
end

local function day16_part2_helper(input, start, times)
  local dance = build_dance_repeat(times, build_dance_unit(input,#start))
  local result = apply_dance(common.chars(start), dance)
  return table.concat(result, "")
end
function day16_part2(input)
  return day16_part2_helper(input, "abcdefghijklmnop", 1000000000)
end

--[[rename doesn't commute]]
assert(day16_part1_helper("pa/b,pb/c", "abc") == "cab")
assert(day16_part1_helper("pb/c,pa/b", "abc") == "bca")

--[[exchange doesn't commute either]]
assert(day16_part1_helper("x1/2,x0/1", "abc") == "cab")
assert(day16_part1_helper("x0/1,x1/2", "abc") == "bca")

--[[
For example, with only five programs standing in a line (abcde), they could do the following dance:

    s1, a spin of size 1: eabcd.
    x3/4, swapping the last two programs: eabdc.
    pe/b, swapping programs e and b: baedc.
]]
assert(day16_part1_helper("", "baedc") == "baedc")
assert(day16_part1_helper("s1", "baedc") == "cbaed")
assert(day16_part1_helper("s3", "abcde") == "cdeab")
assert(day16_part1_helper("x3/4", "eabcd")  == "eabdc")
assert(day16_part1_helper("pe/b", "eabdc") == "baedc")
assert(day16_part1_helper("s1,pe/b,x3/4", "abcde") == "baedc")
assert(day16_part1_helper("s1,x3/4,pe/b", "abcde") == "baedc")

--[[
  Tests Part 2
]]
assert(day16_part2_helper("s1,x3/4,pe/b", "abcde", 1) == "baedc")
assert(day16_part2_helper("s1,x3/4,pe/b", "baedc", 1) == "ceadb")
assert(day16_part2_helper("s1,x3/4,pe/b", "abcde", 2) == "ceadb")
assert(day16_part2_helper("s1,x3/4,pe/b", "abcde", 3) == "ecbda")

--Answers
local puzzle_input = common.puzzle_input (16)
print("Day 16, Part 1: ", day16_part1(puzzle_input)) --ebjpfdgmihonackl
print("Day 16, Part 2: ", day16_part2(puzzle_input)) --abocefghijklmndp