local m = {}

function m.at(s, i)
    return string.sub(s, i+1, i+1)
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

function m.map(f, t)
  local acc = {}
  for _, v in ipairs(t) do
    table.insert(acc, f(v))
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
  local step = step or 1
  local acc = {}
  for i=start,stop,step do
    table.insert(acc, i)
  end
  return acc
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

return m