return function(common)
  local function circular_reverse(list, pos, length)
    for i=0,math.floor(length/2)-1 do
      local p1 = (pos + i) % #list
      local p2 = (pos + length - 1 - i) % #list
      if p1 ~= p2 then
        list[p1+1], list[p2+1] = list[p2+1], list[p1+1]
      end
    end
  end
  local function elfhash(list, lengths, pos, skip)
    local pos = pos or 0
    local skip = skip or 0
    for _, length in ipairs(lengths) do
      circular_reverse(list, pos, length)
      pos = (pos + length + skip) % #list
      skip = skip + 1
    end
    return pos, skip
  end
  local function knot_hash(input)
    local list = common.range(256)
    local codes = common.bytes(input)
    common.append(codes, {17, 31, 73, 47, 23})
    local pos, skip
    for i=1,64 do
      pos, skip = elfhash(list, codes, pos, skip)
    end
    local dense = common.rep(0, 16)
    for i=0,15 do
      for v=0,15 do
        dense[i+1] = common.bit.bxor(dense[i+1], list[i * 16 + v + 1])
      end
    end
    return table.concat(common.map(function(v) return string.format("%02x", v) end, dense), "")
  end
  return knot_hash, elfhash
end