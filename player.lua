local player = {
  
}
function player.init(i)
  player.points = 0
  player.skeletons = c_startingskeletons
  player.markers = c_startingshovels
  player.location = ((i-1)*6)%24+1
  player.id=i
  
end
function player.taketurn()
  print("----------------------player "..player.id.."'s turn!------------------------------")
  local r = d6()
  print("rolled a "..r)
  if r ~= 6 then
    local oldloc = player.location
    player.location = player.location + r
    if player.location > 25 then
      player.location = player.location - 25
    end
    print("moving "..r.." tiles from "..oldloc.." to "..player.location)
  else
    local x = d6() -- todo: make choice better
    print("player chose "..x)
    local oldloc = player.location
    player.location = player.location + x
    if player.location > 25 then
      player.location = player.location - 25
    end
    print("moving "..x.." tiles from "..oldloc.." to "..player.location)
  end
  if game.board[player.location].t == "checkpoint" then
    print("player got to a checkpoint")
    if game.board[player.location].skeletons ~= 0 then
      local oldskel = player.skeletons
      player.skeletons = player.skeletons + game.board[player.location].skeletons
      print("player got ".. game.board[player.location].skeletons.." skeletons. ")
      game.board[player.location].skeletons = 0
      print("went from "..oldskel.." to ".. player.skeletons)
    end
  else
    print("player got to a grave")
    if game.board[player.location].marker == 0 then
      print("grave is undisturbed")
      if player.skeletons >= 1 then
        if player.markers >= 1 then
          local x = d6()
          print("player rolled "..x.." skeletons")
          print("player placing marker")
          player.markers = tadd("player marker stock",player.markers,-1)
          game.board[player.location].marker = player.id
          if x > player.skeletons then --very greedy strategy?
            x = player.skeletons 
          end
          print("player summoning "..x.." skeletons")
          player.skeletons = tadd("player skeleton stock",player.skeletons,0-x)
          game.board[player.location].skeletons = x
          print("player gained "..x.." points!")
          player.points = tadd("player points",player.points,x)
        else
          print("player has no markers!")
        end
      else
        print("player has no skeletons!")
      end
    else
      print('uh oh, grave is occupied!')
      if game.board[player.location].marker == player.id then
        print('its your own grave, dummy!')
        if game.board[player.location].skeletons ~= 0 then
          print('harvesting skeletons...')
          x = game.board[player.location].skeletons
          player.skeletons = tadd("player skeleton stock",player.skeletons,x)
          game.board[player.location].skeletons = 0
          print("player gained "..x.." points!")
          player.points = tadd("player points",player.points,x)
        else
          print("no skeletons here...")
        end
      else
        if game.board[player.location].skeletons > 0 then
          local rob = coin() --highly advanced ai decisionmaking 
          local canrob = true
          local doaction = true
          if player.skeletons < 1 then
            print("player does not have enough skeletons to choose grave robbery.")
            canrob = false
            rob = false
          end
          if player.markers < 1 or game.board[player.location].skeletons == 6 then
            print("player can not crunch.")
            rob = true
            if canrob == false then
              doaction = false
              print("player can not do anything! next turn will be skipped.")
              -- TODO add turn skipping
            end
          end
          if doaction then
            if rob then
              print("Player has chosen to rob.")
              local success = coin()
              if success then
                print("Success!")
                local skeletonsmoved = math.ceil(game.board[player.location].skeletons / 2)
                game.board[player.location].skeletons = tadd("skeletons from tile",game.board[player.location].skeletons, (0 - skeletonsmoved))
                local chosencheckpoint = (math.random(0,3) * 6) + 1
                game.board[chosencheckpoint].skeletons = tadd("skeletons to checkpoint " .. (chosencheckpoint - 1) / 6, game.board[chosencheckpoint].skeletons, skeletonsmoved)
                
              else
                print("robbery failed...")
                
              end
            else
              
            end
          end
        else
          print("got to an empty grave with a marker."
        end
      end
    end
  end
end

return player