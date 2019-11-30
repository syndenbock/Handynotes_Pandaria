local addonName, shared = ...;

local addon = shared.addon;
local HandyNotes = shared.HandyNotes;
local nodes = shared.nodeData;
local nodeInfo = {};
local handler = {};
local settings;
local tooltip;

local function makeIterator (zones, isMinimap)
  local zoneIndex, zone = next(zones, nil);
  local coords;

  local function iterator ()
    while (zone) do
      local zoneNodes = nodes[zone];

      if (zoneNodes) then
        coords, node = next(zoneNodes, coords);

        while (node) do
          local info = addon:getNodeInfo(node);

          if (info == nil) then
            local remCoords = coords;

            -- get the next node before deleting, so next() knows the coords
            coords, node = next(zoneNodes, coords);
            zoneNodes[remCoords] = nil;
          else
            nodeInfo[zone] = nodeInfo[zone] or {};
            nodeInfo[zone][coords] = info;

            if (info.display) then
              return coords, zone, info.icon, settings.icon_scale, settings.icon_alpha;
            end

            coords, node = next(zoneNodes, coords);
          end
        end
      end

      zoneIndex, zone = next(zones, zoneIndex);
    end
  end

  return iterator;
end

function handler:GetNodes2(uiMapId, isMinimap)
  if (isMinimap == true and settings.minimap_icons ~= true) then
    return function () return nil end
  end

  -- local zones = HandyNotes:GetContinentZoneList(uiMapId); -- Is this a continent?
  local zones;

  if not zones then
    zones = {uiMapId};
  end

  nodeInfo = {};

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
  local zoneNodes = nodeInfo[uiMapId];

  if (zoneNodes == nil) then return end

  local node = zoneNodes[coords];

  if (node == nil) then return end

  tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip;

  nodeData = node.rareInfo or node.treasureInfo;

  if (self:GetCenter() > UIParent:GetCenter()) then
    tooltip:SetOwner(self, "ANCHOR_LEFT")
  else
    tooltip:SetOwner(self, "ANCHOR_RIGHT")
  end

  tooltip:SetText(nodeData.name or node.rare or node.treasure);
  -- tooltip:SetText(nodeData.name .. ' ' .. (node.rare or node.treasure));

  if (nodeData.description ~= nil) then
    tooltip:AddLine(nodeData.description);
  end

  addTooltipText(tooltip, nodeData.mountInfo, 'Mounts:');
  addTooltipText(tooltip, nodeData.toyInfo, 'Toys:');
  addTooltipText(tooltip, nodeData.achievementInfo, 'Achievements:');

  tooltip:Show();
end

function handler:OnLeave(uiMapId, coords)
  tooltip:Hide();
end

local function replaceTable (oldTable, newTable)
  -- this clears the table without destroying old references
  table.wipe(oldTable);

  for key, value in pairs(newTable) do
    oldTable[key] = value;
  end
end

local function validateSettings (config, defaults)
  local new = {};

  for param, defaultValue in pairs(defaults) do
    local configValue = config[param];

    if (type(configValue) ~= type(defaultValue)) then
      new[param] = defaultValue;
    else
      new[param] = configValue;
    end
  end

  -- we replace the old settings table to wipe removed settings
  replaceTable(config, new);
end

local function updateNodes ()
  HandyNotes:SendMessage('HandyNotes_NotifyUpdate', addonName);
end

local function registerWithHandyNotes ()
  local defaults = {
    icon_scale = 1,
    icon_alpha = 1,
    minimap_icons = true,
  };

  if (storedData == nil) then
    storedData = {
      settings = {};
    };
  elseif (storedData.settings == nil) then
    storedData.settings = {};
  end

  settings = storedData.settings;
  validateSettings(settings, defaults);

  local options = {
    type = "group",
    name = 'Handynotes Pandaria',
    desc = 'Handynotes Pandaria',
    get = function(info) return settings[info.arg] end,
    set = function(info, v)
      settings[info.arg] = v;
      updateNodes();
    end,
    args = {
      minimap_icons = {
        order = 1,
        type = 'toggle',
        name = 'Minimap icons',
        desc = 'Show items on the minimap',
        arg = 'minimap_icons',
        width = 'full',
      },
      icon_scale = {
        order = 2,
        type = 'range',
        name = 'Icon Scale',
        desc = 'The scale of the icons',
        min = 0.5, max = 3, step = 0.1,
        arg = 'icon_scale',
        width = 'normal',
      },
      icon_alpha = {
        order = 3,
        type = 'range',
        name = 'Icon Alpha',
        desc = 'The alpha transparency of the icons',
        min = 0, max = 1, step = 0.01,
        arg = 'icon_alpha',
        width = 'normal',
      },
    },
  };

  HandyNotes:RegisterPluginDB(addonName, handler, options);
end


addon:on('PLAYER_LOGIN', function ()
  registerWithHandyNotes();
  addon:funnel({'CRITERIA_UPDATE'}, 2, updateNodes);
  addon:on({'NEW_TOY_ADDED', 'NEW_MOUNT_ADDED'}, updateNodes);
end);
