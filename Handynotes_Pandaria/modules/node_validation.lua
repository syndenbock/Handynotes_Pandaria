local addonName, shared = ...;

local addon = shared.addon;
local rareData = shared.rareData;
local treasureInfo = shared.treasureData;
local nodes = shared.nodeData;
local playerFaction;
local dataCache;
local pendingData = {};

local nodeHider = addon.import('nodeHider');

local ICON_MAP = {
  question = 'Interface\\Icons\\inv_misc_questionmark',
  skullGray = 'Interface\\Addons\\Handynotes_Pandaria\\icons\\RareIcon.tga',
  skullGreen = 'Interface\\Addons\\Handynotes_Pandaria\\icons\\RareIconGreen.tga',
  skullBlue = 'Interface\\Addons\\Handynotes_Pandaria\\icons\\RareIconBlue.tga',
  skullOrange = 'Interface\\Addons\\Handynotes_Pandaria\\icons\\RareIconOrange.tga',
  skullYellow = 'Interface\\Addons\\Handynotes_Pandaria\\icons\\RareIconYellow.tga',
  skullPurple = 'Interface\\Addons\\Handynotes_Pandaria\\icons\\RareIconPurple.tga',
  chest = 'Interface\\Icons\\TRADE_ARCHAEOLOGY_CHESTOFTINYGLASSANIMALS',
};

local COLOR_MAP = {
  red = '|cFFFF0000',
  blue = '|cFF0000FF',
  green = '|cFF00FF00',
  yellow = '|cFFFFFF00',
};

addon.on('PLAYER_LOGIN', function ()
  playerFaction = UnitFactionGroup('player');
end);

addon.on('GET_ITEM_INFO_RECEIVED', function (itemId, success)
  local info = pendingData[itemId];

  if (info == nil) then return end

  if (success) then
    local itemInfo = {GetItemInfo(itemId)};

    info.name = itemInfo[1];
    addon.yell('DATA_READY', info);
  end

  pendingData[itemId] = nil;
end);

local function setTextColor (text, color)
  return color .. text .. '|r';
end

local function getAchievementInfo (rareData)
  local achievementList = rareData.achievements;

  if (achievementList == nil) then return nil end

  local list = {};
  local totalInfo = {
    list = list,
    completed = true,
  };

  for x = 1, #achievementList, 1 do
    local achievementData = achievementList[x];
    local achievementId = achievementData.id;
    local achievementInfo = {GetAchievementInfo(achievementId)};
    local text = achievementInfo[2];
    local completed = achievementInfo[4];
    local criteriaIndex = achievementData.index;
    local fulfilled = false;
    local info = {
      icon = achievementInfo[10],
    };

    if (completed) then
      text = setTextColor(text, COLOR_MAP.green);
    else
      text = setTextColor(text, COLOR_MAP.red);
    end

    -- some achievements and their indices are set statically, so we make
    -- sure the criteria exists
    if (criteriaIndex > 0 and
        criteriaIndex <= GetAchievementNumCriteria(achievementId)) then
      local criteriaInfo = {GetAchievementCriteriaInfo(achievementId, criteriaIndex)};
      local criteria = criteriaInfo[1];

      fulfilled = criteriaInfo[3];

      if (fulfilled or completed) then
        criteria = setTextColor(criteria, COLOR_MAP.green);
      else
        criteria = setTextColor(criteria, COLOR_MAP.red);
      end

      text = text .. ' - ' .. criteria;
    end

    info.completed = (completed or fulfilled);
    info.text = text;

    if (not info.completed) then
      totalInfo.completed = false;
    end

    totalInfo.icon = totalInfo.icon or info.icon;
    list[x] = info;
  end

  return totalInfo;
end

local function getToyInfo (rareData)
  local toyList = rareData.toys;

  if (toyList == nil) then return nil end

  local list = {};
  local totalData = {
    collected = true,
    list = list,
  };

  for x = 1, #toyList, 1 do
    local toy = toyList[x];
    local toyInfo = {GetItemInfo(toy)};
    local toyName = toyInfo[1];
    local info = {
      collected = PlayerHasToy(toy),
    };

    -- data is not cached yet
    if (toyName == nil) then
      toyName = 'waiting for data...';
      pendingData[toy] = info;
      info.icon = GetItemIcon(toy) or ICON_MAP.skullGreen;
    else
      info.icon = toyInfo[10] or ICON_MAP.skullGreen;
    end

    info.name = toyName;

    if (info.collected) then
      toyName = setTextColor(toyName, COLOR_MAP.green);
    else
      toyName = setTextColor(toyName, COLOR_MAP.red);
      totalData.collected = false;
      totalData.icon = totalData.icon or info.icon;
    end

    info.text = toyName;
    list[x] = info;
  end

  return totalData;
end

local function getMountInfo (rareData)
  local mountList = rareData.mounts;

  if (mountList == nil) then return nil end

  local list = {};
  local totalData = {
    list = list,
    collected = true,
  };

  for x = 1, #mountList, 1 do
    local mountId = mountList[x];
    local mountInfo = {C_MountJournal.GetMountInfoByID(mountId)};
    local mountName = mountInfo[1];
    local info = {
      icon = mountInfo[3] or ICON_MAP.skullOrange,
      collected = mountInfo[11],
    };

    if (info.collected) then
      mountName = setTextColor(mountName, COLOR_MAP.green);
    else
      mountName = setTextColor(mountName, COLOR_MAP.red);
      totalData.collected = false;
      totalData.icon = totalData.icon or info.icon;
    end

    info.text = mountName;
    list[x] = info;
  end

  return totalData;
end

local function getRareInfo (nodeData)
  local rareId = nodeData.rare;

  if (rareId == nil) then return nil end

  local rareCache = dataCache.rares;

  if (rareCache[rareId] ~= nil) then
    return rareCache[rareId];
  end

  local rare = rareData[rareId];

  if (rare == nil) then
    return nil;
  end

  if (rare.faction and rare.faction ~= playerFaction) then
    return nil;
  end

  local info = {
    name = rare.name,
    description = rare.description,
    special = rare.special,
    achievementInfo = getAchievementInfo(rare),
    toyInfo = getToyInfo(rare),
    mountInfo = getMountInfo(rare),
  };

  if (rare.quest ~= nil) then
    info.questCompleted = IsQuestFlaggedCompleted(rare.quest);
  end

  rareCache[rareId] = info;
  return info;
end

local function getTreasureInfo (nodeData)
  local treasureId = nodeData.treasure;

  if (treasureId == nil) then return nil end

  local treasureData = treasureInfo[treasureId];

  if (treasureData == nil) then
    -- print('no information about treasure:', treasureId);
    return nil;
  end

  if (treasureData.faction and treasureData.faction ~= playerFaction) then
    return nil;
  end

  local info = {
    name = treasureData.name,
    description = treasureData.description,
    achievementInfo = getAchievementInfo(treasureData),
    collected = IsQuestFlaggedCompleted(treasureId),
    icon = ICON_MAP.chest,
  };

  return info;
end

local function interpreteNodeInfo (nodeInfo)
  local rareInfo = nodeInfo.rareInfo;

  if (rareInfo ~= nil) then
    if (rareInfo.questCompleted == true) then
      nodeInfo.display = false;
      return;
    end

    local mountInfo = rareInfo.mountInfo;

    if (mountInfo ~= nil) then
      if (mountInfo.collected == false) then
        nodeInfo.icon = mountInfo.icon or ICON_MAP.skullPurple;
        nodeInfo.display = true;
        return;
      end
    end

    local toyInfo = rareInfo.toyInfo;

    if (toyInfo ~= nil) then
      if (toyInfo.collected == false) then
        nodeInfo.icon = toyInfo.icon or ICON_MAP.skullGreen;
        nodeInfo.display = true;
        return;
      end
    end

    local achievementInfo = rareInfo.achievementInfo;

    if (achievementInfo ~= nil) then
      if (achievementInfo.completed == false) then
--        nodeInfo.icon = achievementInfo.icon;
        nodeInfo.icon = ICON_MAP.skullYellow;
        nodeInfo.display = true;
        return;
      end
    end

    if (rareInfo.special == true) then
      nodeInfo.icon = ICON_MAP.skullBlue;
      nodeInfo.display = true;
      return;
    end

    nodeInfo.icon = ICON_MAP.skullGray;
  end

  local treasureInfo = nodeInfo.treasureInfo;

  if (treasureInfo ~= nil) then
    if (treasureInfo.collected == false) then
      nodeInfo.icon = treasureInfo.icon;
      nodeInfo.display = true;
      return;
    end

    nodeInfo.icon = nodeInfo.icon or ICON_MAP.chest;
  end

  nodeInfo.icon = nodeInfo.icon or ICON_MAP.question;
  nodeInfo.display = false;
end

local function getNodeInfo (zone, coords)
  if (nodeHider.isHidden(zone, coords)) then
    return {
      display = false,
    };
  end

  local nodeCache = dataCache.nodes;

  if (nodeCache[zone] ~= nil and nodeCache[zone][coords] ~= nil) then
    return nodeCache[zone][coords];
  end

  local nodeData = nodes[zone];

  if (nodeData == nil) then return nil end
  nodeData = nodeData[coords];
  if (nodeData == nil) then return nil end

  local info = {
    rareInfo = getRareInfo(nodeData),
    treasureInfo = getTreasureInfo(nodeData),
  };

  if (info.rareInfo == nil and info.treasureInfo == nil) then return nil end

  interpreteNodeInfo(info);

  nodeCache[zone] = nodeCache[zone] or {};
  nodeCache[zone][coords] = info or {};

  return info;
end

local function flush ()
  dataCache = {
    rares = {},
    treasures = {},
    nodes = {},
  };
end

flush();

local module = {
  getNodeInfo = getNodeInfo,
  flush = flush,
};

addon.export('infoProvider', module);
