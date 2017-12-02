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
  local a = t[1]
  for i=2, #t do
    a = math.min(a, t[i])
  end
  return a
end

function m.max(t)
  local a = t[1]
  for i=2, #t do
    a = math.max(a, t[i])
  end
  return a  
end

return m