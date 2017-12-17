local m = {}

m.bit = require "common.bit"
m.knot_hash, m.knot_hash_round = require "common.knot_hash" (m)
m.count_groups, m.find_group = require "common.count_groups" (m)

function m.at(s, i)
    return string.sub(s, i+1, i+1)
end

function m.bytes(input)
  local acc = {}
  for i=1,#input do
    table.insert(acc, string.byte(input, i))
  end
  return acc
end

function m.chars(input)
  local acc = {}
  for i=1,#input do
    table.insert(acc, string.sub(input, i, i))
  end
  return acc
end

function m.grid(input)
  local rows = {}
  for line in string.gmatch(input, "([^\n]+)\n?") do
    local columns = {}
    for item in string.gmatch(line, "(%S+)%s*") do
      table.insert(columns, item)
    end
    table.insert(rows, columns)
  end
  return rows
end

function m.list(input)
  return m.split(input, "%s+")
end

function m.lines(input)
  return m.split(input, "\n", true, true)
end

function m.join(tt)
  return m.fmap(m.id, tt)
end

function m.split(input, pattern, plain, keep_empty)
  local plain = plain or false
  local keep_empty = keep_empty or false
  local acc = {}
  local function split_helper(start)
    if start > #input then return acc end
    local mstart, mend = string.find(input, pattern, start, plain)
    if not mstart then
      mstart = #input + 1
      mend = #input
    end
    --if mstart == start, then only add the empty
    --string to the acc list if keep_empty is true.
    if mstart == start and keep_empty then
      table.insert(acc, "")
    elseif mstart > start then
      table.insert(acc, string.sub(input, start, mstart-1))
    end  
    return split_helper(mend+1)
  end
  return split_helper(1)
end


function m.map(f, t)
  local acc = {}
  for _, v in ipairs(t) do
    local r = f(v)
    if r ~= nil then
      table.insert(acc, r)
    end
  end
  return acc
end

function m.fmap(f, t)
  local acc = {}
  for _, v in ipairs(t) do
    local r = f(v)
    if type(r) == "table" then
      m.append(acc, r)
    elseif type(r) ~= "nil" then
      table.insert(acc, r)
    end
  end
  return acc
end

function m.min(t)
  return m.fold_offset(math.min, t, t[1], 2)
end

function m.max(t)
  return m.fold_offset(math.max, t, t[1], 2)
end

function m.fold_offset(f, t, acc, i)
  if i > #t then
    return acc
  else
    return m.fold_offset(f, t, f(acc, t[i]), i+1)
  end
end

function m.fold(f, t, init)
  return m.fold_offset(f, t, init, 1)
end

function m.add(acc, first, ...)
  if first then
    return m.add(acc + first, ...)
  else
    return acc
  end
end

function m.sum(t)
  return m.fold(m.add, t, 0)
end

--compose : (X -> Y) -> (Y -> Z) -> (X -> Z)
function m.compose(f, g)
  return function(...)
    return g(f(...))
  end
end

function m.range(start, stop, step)
    assert(start)
  local step = step or 1
  if not stop then
    stop, start = start, 0
  end
  assert(stop)
  assert(step)
  local acc = {}
  for i=start,stop-1,step do
    table.insert(acc, i)
  end
  return acc
end

function m.rep(v, n)
  local acc = {}
  for i=1,n do
    table.insert(acc, v)
  end
  return acc
end

function m.append(t, t2)
  for _, v in ipairs(t2) do
    table.insert(t, v)
  end
end

function m.repeat_associative(zero, unit, add, times)
  local function addntimes(m, acc, accp)
    if m == 0 then return acc, accp end
    local n = 1
    local np = unit
    local stop = math.floor(m / 2)
    while n < stop do
      n = n + n
      np = add(np, np)
    end
    return addntimes(m - n, acc + n, add(accp, np))
  end
  local count, result = addntimes(times, 0, zero)
  assert(count == times)
  return result
end

function m.sequence_memo(generator)
  local memo_table = {}
  local current_max = 0
  return function(n)
    if n > current_max then
      for i=current_max+1, n do
        memo_table[i] = generator()
      end
      current_max = n
    end
    return memo_table[n]
  end
end

function m.count(pred, t)
  --return #(m.filter(m.id, m.map(pred, t)))
  local total = 0
  for _, v in ipairs(t) do
    if pred(v) then
      total = total + 1
    end
  end
  return total
end

function m.id(x) return x end

function m.filter(pred, t)
    local acc =  {}
    for _, v in ipairs(t) do
      if pred(v) then
        table.insert(acc, v)
      end
    end
    return acc
end

function m.not_equals(v)
  return function(x) return x ~= v end
end

--Find the odd one out of a group.
function m.odd_one_out_by(group, selector)
  local function find_odd_three(offset)
    local a, b, c = selector(group[offset]), selector(group[offset + 1]), selector(group[offset + 2])
    if a == b and b == c then return end
    if a == b then
        return group[offset + 2] --c
    elseif a == c then
        return group[offset + 1] --b
    elseif b == c then
        return group[offset + 0] --a
    end
    error()
  end
  local offset = 1
  local odd
  while not odd and offset + 2 <= #group do
    odd = find_odd_three(offset)
    offset = offset + 1
  end
  return odd
end

function m.anagram_normalise(word)
  local letters = {}
  for c in string.gmatch(word, "(.)") do
    table.insert(letters, c)
  end
  table.sort(letters)
  return table.concat(letters, "")
end

function m.puzzle_input(dayn)
  return io.input(string.format("input/%02d.txt",dayn)):read("*a")
end

function m.set(items)
  local seen = {}
  local acc = {}
  for _, v in ipairs(items) do
      if not seen[v] then table.insert(acc, v) end
      seen[v] = true
  end
  return acc
end

function m.pairs(t)
  local acc = {}
  for k, v in pairs(t) do
    table.insert(acc, {k, v})
  end
  return acc
end

function m.values(t)
  local acc = {}
  for _, v in pairs(t) do
    table.insert(acc, v)
  end
  return acc  
end

function m.keys(t)
  local acc = {}
  for k, _ in pairs(t) do
    table.insert(acc, k)
  end
  return acc   
end

return m