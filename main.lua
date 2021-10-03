lovebird = require "lovebird"

db = true

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
  for i=1,4 do
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
  local turncount = 0
  while true do
    turncount = turncount + 1
    if game.step() == 0 then
      break
    end
    
  end
  for i,v in ipairs(game.players) do
    print("player "..i,v.points .. " points")
  end
  print("turncount: "..turncount)
end


game.init()


while true do
  lovebird.update()  
end