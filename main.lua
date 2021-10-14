-- CONFIG
c_playercount = 4
c_startingskeletons = 12
c_startingshovels = 8



lovebird = require "lovebird"

db = true

function coin()
  return (math.random(1,2) == 1)
end

function d6()
  return math.random(1,6)
end
function p(s)
  if db then print(s) end
end
function tadd(c,a,b)
  print(c.." from "..a.. " to " .. a+b)
  return a+b
end

game = {}

function game.init()
  game.board = {}

  for i=1,25 do
    p("making tile "..i)
    if (i-1)%6==0 then
      p("corner tile")
      game.board[i] = {
        t = "checkpoint",
        skeletons = 0
      }
    else
      p("grave tile")
      game.board[i] = {
        t = "grave",
        marker = 0,
        skeletons = 0
      }
    end
  end

  game.players = {}
  for i=1,c_playercount do
    p("making player "..i)
    game.players[i] = dofile("player.lua")
    game.players[i].init(i)
  end
end
function game.checkforend()
  local emptytiles = 0
  for i,v in ipairs(game.board) do
    
    if v.marker == 0 then
      emptytiles = emptytiles + 1
    end
  end
  p(emptytiles.." empty tiles")
  return emptytiles
end

function game.turn()
  for i,v in ipairs(game.players) do
    game.players[i].taketurn()
  end
  
end
function game.step()
  game.turn()
  return game.checkforend()
end

function game.play()
  local results = {}
  results.turncount = 0
  while true do
    results.turncount = results.turncount + 1
    if game.step() == 0 then
      break
    end
    
  end
  results.players = {}
  for i,v in ipairs(game.players) do
    results.players[i]= {points = v.points}
    print("player "..i,v.points .. " points")
  end
  print("turncount: "..results.turncount)
  return results
end

function multiplay(x)
  local mpgames = {}
  for i=1,x do
    game.init()
    results = game.play()
    table.insert(mpgames,results)
  end
  local minturns = 9999999999
  local maxturns = 0
  local totalpoints = 0
  local totalturns = 0
  for i,v in ipairs(mpgames) do
    totalturns = totalturns + v.turncount
    if v.turncount > maxturns then
      maxturns = v.turncount
    end
    if v.turncount < minturns then
      minturns = v.turncount
    end
    for a,b in ipairs(v.players) do
      totalpoints = totalpoints + b.points
    end
  end
  print("TOTALTURNS: ".. totalturns)
  print("TOTALPOINTS: ".. totalpoints)
  print("AVERAGE TURNS: ".. totalturns / x)
  print("AVERAGE POINTS: ".. (totalpoints / x) / c_playercount)
  print("MAX TURNS TAKEN: " .. maxturns)
  print("MIN TURNS TAKEN: " .. minturns)
end

game.init()


while true do
  lovebird.update()  
end