local player = {
  
}
function player.init(i)
  player = {
    points = 0,
    skeletons = 10,
    markers = 10,
    location = (i-1)*6+1,
    id=i
  }
end
player.taketurn = function()
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
end

return player