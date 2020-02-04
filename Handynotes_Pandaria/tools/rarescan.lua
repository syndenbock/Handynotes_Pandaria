local addonName, shared = ...;

local pow = math.pow;
local GetVignettes = C_VignetteInfo.GetVignettes;
local GetVignetteInfo = C_VignetteInfo.GetVignetteInfo;
local GetVignettePosition = C_VignetteInfo.GetVignettePosition;

local addon = shared.addon;

local newValeMapId = 1530;
local scanningActive = false;
local currentMapId;

local function truncate (number, digits)
  local factor = pow(10, digits);

  number = number * factor;
  number = floor(number);
  number = number / factor;

  return number;
end

local function readVignette (guid)
  if (guid == nil or currentMapId == nil) then return end

  local info = GetVignetteInfo(guid);

  if (info == nil) then return end

  local coords = GetVignettePosition(guid, currentMapId);

  if (coords == nil) then return end

  local x = truncate(coords.x * 100, 1);
  local y = truncate(coords.y * 100, 1);

  print(info.name, x, '/', y);
end

local function scanVignettes ()
  local list = GetVignettes();

  for x = 1, #list, 1 do
    readVignette(list[x]);
  end
end

addon.on({'PLAYER_ENTERING_WORLD', 'ZONE_CHANGED_NEW_AREA'}, function ()
  currentMapId = C_Map.GetBestMapForUnit('player');

  -- scanningActive = (currentMapId == newValeMapId);
  scanningActive = true;

  if (scanningActive) then
    print('enabled rare scanning');
    scanVignettes();
  else
    print('disabled rare scanning');
  end
end);

addon.on('VIGNETTE_MINIMAP_UPDATED', function (guid, onMinimap)
  if (scanningActive == false or onMinimap == false) then
    return
  end

  readVignette(guid);
end);
