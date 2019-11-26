local addonName, shared = ...;

local addon = shared.addon;
local HandyNotes = shared.HandyNotes;
local nodes = shared.nodes;

local handler = {};

local function makeIterator (zones, isMinimap)
  local zoneIndex, zone = next(zones, nil);
  local coords;

  local function iterator ()
    while (zone) do
      local zoneNodes = nodes[zone];

      if (zoneNodes) then
        local nextCoords, node = next(zoneNodes, coords);

        while (node) do
          local info = addon:getNodeInfo(node);

          if (info == nil) then
            zoneNodes[nextCoords] = nil;
          else
            coords = nextCoords;

            node.info = info;

            if (info.display) then
              return coords, zone, info.icon, 1, 1;
            end
          end

          nextCoords, node = next(zoneNodes, coords);
        end
      end

      zoneIndex, zone = next(zones, zoneIndex);
    end
  end

  return iterator;
end

function handler:GetNodes2(uiMapId, isMinimap)
  --local zones = HandyNotes:GetContinentZoneList(uiMapId) -- Is this a continent?
  local zones;

  if not zones then
    zones = {uiMapId}
  end

  return makeIterator(zones, isMinimap);
end

local function addTooltipText (tooltip, info, header)
  if (info == nil or info.completed == true or info.collected == true) then return end

  local list = info.list;

  for x = 1, #list, 1 do
    if (list[x].collected == false or list[x].completed == false) then
      tooltip:AddDoubleLine(header, list[x].text);
      header = ' ';
    end
  end
end

function handler:OnEnter(uiMapId, coords)
  local zoneNodes = nodes[uiMapId];

  if (zoneNodes == nil) then return end

  local node = zoneNodes[coords];

  if (node == nil) then return end

  local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip;
  local nodeInfo = node.info.rareInfo or node.info.treasureInfo;

  if (self:GetCenter() > UIParent:GetCenter()) then
    tooltip:SetOwner(self, "ANCHOR_LEFT")
  else
    tooltip:SetOwner(self, "ANCHOR_RIGHT")
  end

  tooltip:SetText(nodeInfo.name or node.rare or node.treasure);

  if (nodeInfo.description ~= nil) then
    tooltip:AddLine(nodeInfo.description);
  end

  addTooltipText(tooltip, nodeInfo.mountInfo, 'Mounts:');
  addTooltipText(tooltip, nodeInfo.toyInfo, 'Toys:');
  addTooltipText(tooltip, nodeInfo.achievementInfo, 'Achievements:');

  tooltip:Show();
end

function handler:OnLeave(uiMapId, coords)
  local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip;

  tooltip:Hide();
end

local db = {};

local options = {
  type = "group",
  name = 'Handynotes Pandaria',
  desc = 'Handynotes Pandaria',
  get = function(info) return db[info.arg] end,
  set = function(info, v)
    db[info.arg] = v
  end,
  args = {
    desc = {
      name = 'Handynotes Pandaria Options.',
      type = "description",
      order = 0,
    },
    icon_scale = {
      type = 'range',
      name = 'Icon Scale',
      desc = 'The scale of the icons',
      min = 0.25, max = 2, step = 0.01,
      arg = "icon_scale",
      order = 10,
    },
    icon_alpha = {
      type = 'range',
      name = 'Icon Alpha',
      desc = 'The alpha transparency of the icons',
      min = 0, max = 1, step = 0.01,
      arg = "icon_alpha",
      order = 20,
    },
  },
}

local function updateNodes ()
  HandyNotes:SendMessage('HandyNotes_NotifyUpdate', addonName);
end

addon:on('PLAYER_LOGIN', function ()
  HandyNotes:RegisterPluginDB(addonName, handler, options);
  addon:funnel({'CRITERIA_UPDATE'}, 2, updateNodes);
  addon:on({'NEW_TOY_ADDED', 'NEW_MOUNT_ADDED'}, updateNodes);
end);
