local common = require "common"

local function select_manhattan_accel(p)
  return math.abs(p.a.x) + math.abs(p.a.y) + math.abs(p.a.z)
end

local function parse_line(line)
  --p=<2949,1077,-291>, v=<422,152,-39>, a=<-22,-8,4>
  local px, py, pz, vx, vy, vz, ax, ay, az = string.match(line, "p%=%<(%-?%d+)%,(%-?%d+)%,(%-?%d+)%>%, v%=%<(%-?%d+)%,(%-?%d+)%,(%-?%d+)%>%, a%=%<(%-?%d+)%,(%-?%d+)%,(%-?%d+)%>")
  return {
    a = {
      x = ax, y = ay, z = az
    },
    v = {
      x = vx, y = vy, z = vz
    },
    p = {
      x = px, y = py, z = pz
    }
  }
end

function day20_part1(input)
  local max, i = common.min_by(select_manhattan_accel, common.map(parse_line, common.lines(input)))
  return i - 1
end

local function simultaneous_update(particles)
  for _, p in ipairs(particles) do
    p.v.x = p.v.x + p.a.x
    p.v.y = p.v.y + p.a.y
    p.v.z = p.v.z + p.a.z
    p.p.x = p.p.x + p.v.x
    p.p.y = p.p.y + p.v.y
    p.p.z = p.p.z + p.v.z
  end
end

local function detect_collisions(particles)
  local count = {}
  for i, p in ipairs(particles) do
    local name = string.format("%d,%d,%d", p.p.x, p.p.y, p.p.z)
    count[name] = count[name] or {}
    table.insert(count[name], i)
  end
  local acc = {}
  for k, c in pairs(count) do
    if #c > 1 then
      common.append(acc, c)
    end
  end
  return common.set(acc)
end

function day20_part2(input)
  local particles = common.map(parse_line, common.lines(input))
  local loops_since_collision = 0
  while loops_since_collision < 100 do --loop a big enough number of times to remove all collisions
    local collided = detect_collisions(particles)
    table.sort(collided, common.gt)
    for _, i in ipairs(collided) do
      table.remove(particles, i)
    end
    simultaneous_update(particles)
    loops_since_collision = loops_since_collision + 1
  end
  return #particles
end

--Answers
local puzzle_input = common.puzzle_input (20)
print("Day 20, Part 1: ", day20_part1(puzzle_input)) --??
print("Day 20, Part 2: ", day20_part2(puzzle_input)) --??