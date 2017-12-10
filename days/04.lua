local common = require "common"

local function is_valid(words)
  --loop over all words
  --keep a record of the words seen so far
  --if the same word occurs twice, return false
  --otherwise (after all words are checked) return true.
  local store = {}
  for _, v in ipairs(words) do
    if store[v] then return false end
    store[v] = true
  end
  return true
end

local function is_valid_2(words)
  return is_valid(common.map(common.anagram_normalise, words))
end

function day4_part1(input)
  local phrases = common.grid(input)
  return common.count(is_valid, phrases)
end

function day4_part2(input)
  local phrases = common.grid(input)
  return common.count(is_valid_2, phrases)
end

--[[
For example:
    aa bb cc dd ee is valid.
    aa bb cc dd aa is not valid - the word aa appears more than once.
    aa bb cc dd aaa is valid - aa and aaa count as different words.
]]
assert(day4_part1 "aa bb cc dd ee" == 1)
assert(day4_part1 "aa bb cc dd aa" == 0)
assert(day4_part1 "aa bb cc dd aaa" == 1)

--[[
For example:

    abcde fghij is a valid passphrase.
    abcde xyz ecdab is not valid - the letters from the third word can be rearranged to form the first word.
    a ab abc abd abf abj is a valid passphrase, because all letters need to be used when forming another word.
    iiii oiii ooii oooi oooo is valid.
    oiii ioii iioi iiio is not valid - any of these words can be rearranged to form any other word.
]]

assert(day4_part2 "abcde fghij" == 1)
assert(day4_part2 "abcde xyz ecdab" == 0)
assert(day4_part2 "a ab abc abd abf abj" == 1)
assert(day4_part2 "iiii oiii ooii oooi oooo" == 1)
assert(day4_part2 "oiii ioii iioi iiio" == 0)

local puzzle_input = common.puzzle_input(4)
print(day4_part1(puzzle_input)) --451
print(day4_part2(puzzle_input)) --223