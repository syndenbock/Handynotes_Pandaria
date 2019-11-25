local addonName, shared = ...;

local addon = shared.addon;
local rareInfo = shared.rareInfo;
local nodes = shared.nodes;

--if true then return end

addon:on('PLAYER_STOPPED_MOVING', function ()
  local rares = {};

  for rareId, data in pairs(rareInfo) do
    rares[rareId] = true;
  end

  for zone, zoneNodes in pairs(nodes) do
    for coords, node in pairs(zoneNodes) do
      local rareId = node.rare;

      if (rareId ~= nil) then
        local rare = rareInfo[rareId];

        if (rare == nil) then
          print('no information for rare:', rareId);
        else
          rares[rareId] = false;
        end
      end
    end
  end

  for rareId, flag in pairs(rares) do
    if (flag == true) then
      print('rare has no node:', rareId);
    end
  end
end);
