function find_closest_big_rock()
  local player = game.players[1]
  local position = player.position
  local entities = player.surface.find_entities_filtered{type="simple-entity", name={"rock-big", "rock-huge", "sand-rock-big"}}
  local closest_distance = 9999
  local closest_entity = nil

  for _, entity in pairs(entities) do
    -- Check if the entity is mineable
    if entity.prototype.mineable_properties.minable then
      local distance = math.sqrt((position.x - entity.position.x) ^ 2 + (position.y - entity.position.y) ^ 2)
      if distance < closest_distance then
        closest_distance = distance
        closest_entity = entity
      end
    end
  end

  return closest_entity
end

function mine_closest_big_rock()
  local player = game.players[1]
  local entity = find_closest_big_rock()

  if entity then
    -- Calculate the direction to the entity
    local position = player.position
    local direction = math.atan2(entity.position.y - position.y, entity.position.x - position.x)
    
    -- Convert the direction to a defines.direction value
    local angle = direction * 180 / math.pi
    local direction_value = defines.direction.north
    if angle >= -22.5 and angle < 22.5 then
      direction_value = defines.direction.east
    elseif angle >= 22.5 and angle < 67.5 then
      direction_value = defines.direction.southeast
    elseif angle >= 67.5 and angle < 112.5 then
      direction_value = defines.direction.south
    elseif angle >= 112.5 and angle < 157.5 then
      direction_value = defines.direction.southwest
    elseif angle >= 157.5 or angle < -157.5 then
      direction_value = defines.direction.west
    elseif angle >= -157.5 and angle < -112.5 then
      direction_value = defines.direction.northwest
    elseif angle >= -112.5 and angle < -67.5 then
      direction_value = defines.direction.north
    elseif angle >= -67.5 and angle < -22.5 then
      direction_value = defines.direction.northeast
    end

    -- Move the player towards the entity
    player.walking_state = {
      walking = true,
      direction = direction_value
    }

    -- Wait until the player is close enough to the entity
    local distance = math.sqrt((player.position.x - entity.position.x) ^ 2 + (player.position.y - entity.position.y) ^ 2)
    if distance < 2.5 then
      -- Mine the entity
      player.mine_entity(entity, true)
    end
  end
end

script.on_event(defines.events.on_tick, function(event)
  mine_closest_big_rock()
end)