local _, addon = ...;

local GetAchievementCriteriaInfo = _G.GetAchievementCriteriaInfo;
local GetAchievementInfo = _G.GetAchievementInfo;
local GetAchievementNumCriteria = _G.GetAchievementNumCriteria;
local GetItemIcon = _G.GetItemIcon;
local GetItemInfo = _G.GetItemInfo;
local GetMountInfoByID = _G.C_MountJournal.GetMountInfoByID;
local IsItemDataCachedByID = _G.C_Item.IsItemDataCachedByID;
local IsQuestFlaggedCompleted = _G.C_QuestLog.IsQuestFlaggedCompleted;
local Item = _G.Item;
local PlayerHasToy = _G.PlayerHasToy;
local wipe = _G.wipe;

local rareData = addon.rareData;
local treasureInfo = addon.treasureData;
local nodes = addon.nodeData;
local saved = addon.saved;
local playerFaction;
local dataCache = {
  rares = {},
  treasures = {},
  nodes = {},
};

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
  playerFaction = _G.UnitFactionGroup('player');
end);

local function setTextColor (text, color)
  return color .. text .. '|r';
end

local function queryItem (itemId)
  local item = Item:CreateFromItemID(itemId);

  if (not item:IsItemEmpty()) then
    item:ContinueOnItemLoad(function ()
      addon.yell('DATA_READY', item);
    end);
  end
end

local function getAchievementInfo (rareData)
  local achievementList = rareData.achievements;

  if (achievementList == nil) then return nil end

  local list = {};
  local totalCompleted = true;
  local totalIcon;

  for x = 1, #achievementList, 1 do
    local achievementData = achievementList[x];
    local achievementId = achievementData.id;
    local achievementInfo = {GetAchievementInfo(achievementId)};
    local text = achievementInfo[2];
    local completed = achievementInfo[4];
    -- local completedOnThisCharacter = achievementInfo[13];
    local criteriaIndex = achievementData.index;
    local icon = achievementInfo[10];

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
      local fulfilled = criteriaInfo[3];

      if (fulfilled) then
        completed = true;
        criteria = setTextColor(criteria, COLOR_MAP.green);
      else
        criteria = setTextColor(criteria, COLOR_MAP.red);
      end

      text = text .. ' - ' .. criteria;
    end

    if (not completed) then
      totalCompleted = false;
      totalIcon = totalIcon or icon;
    end

    list[x] = {
      completed = completed,
      text = text,
      icon = icon,
    };
  end

  return {
    completed = totalCompleted,
    icon = totalIcon,
    list = list,
  };
end

local function getToyInfo (rareData)
  local toyList = rareData.toys;

  if (toyList == nil) then return nil end

  local list = {};
  local totalCollected = true;
  local totalIcon;

  for x = 1, #toyList, 1 do
    local toy = toyList[x];
    local collected = PlayerHasToy(toy);
    local toyName;
    local icon;
    local queried;

    -- data is not cached yet
    if (IsItemDataCachedByID(toy)) then
      local toyInfo = {GetItemInfo(toy)};

      toyName = toyInfo[1];
      icon = toyInfo[10] or ICON_MAP.skullGreen;
    else
      toyName = 'waiting for data...';
      icon = GetItemIcon(toy) or ICON_MAP.skullGreen;
      queried = toy;
      queryItem(toy);
    end

    if (collected) then
      toyName = setTextColor(toyName, COLOR_MAP.green);
    else
      toyName = setTextColor(toyName, COLOR_MAP.red);
      totalCollected = false;
      totalIcon = totalIcon or icon;
    end

    list[x] = {
      text = toyName,
      name = toyName,
      collected = collected,
      queried = queried,
    };
  end

  return {
    collected = totalCollected,
    icon = totalIcon,
    list = list,
  };
end

local function getMountInfo (rareData)
  local mountList = rareData.mounts;

  if (mountList == nil) then return nil end

  local list = {};
  local totalCollected = true;
  local totalIcon;

  for x = 1, #mountList, 1 do
    local mountId = mountList[x];
    local mountInfo = {GetMountInfoByID(mountId)};
    local mountName = mountInfo[1];
    local icon = mountInfo[3] or ICON_MAP.skullOrange;
    local collected = mountInfo[11];

    if (collected) then
      mountName = setTextColor(mountName, COLOR_MAP.green);
    else
      mountName = setTextColor(mountName, COLOR_MAP.red);
      totalCollected = false;
      totalIcon = totalIcon or icon;
    end

    list[x] = {
      collected = collected,
      icon = icon,
      text = mountName,
    };
  end

  return {
    collected = totalCollected,
    icon = totalIcon,
    list = list,
  };
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
    questCompleted = rare.quest and IsQuestFlaggedCompleted(rare.quest);
  };

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
  local settings = saved.settings;

  if (settings.show_rares == true and rareInfo ~= nil) then
    if (rareInfo.questCompleted == true) then
      nodeInfo.display = false;
      return;
    end

    local mountInfo = rareInfo.mountInfo;

    if (settings.show_mounts == true and mountInfo ~= nil) then
      if (mountInfo.collected == false) then
        nodeInfo.icon = mountInfo.icon or ICON_MAP.skullPurple;
        nodeInfo.display = true;
        return;
      end
    end

    local toyInfo = rareInfo.toyInfo;

    if (settings.show_toys == true and toyInfo ~= nil) then
      if (toyInfo.collected == false) then
        nodeInfo.icon = toyInfo.icon or ICON_MAP.skullGreen;
        nodeInfo.display = true;
        return;
      end
    end

    local achievementInfo = rareInfo.achievementInfo;

    if (settings.show_achievements == true and achievementInfo ~= nil) then
      if (achievementInfo.completed == false) then
        -- nodeInfo.icon = achievementInfo.icon;
        nodeInfo.icon = ICON_MAP.skullYellow;
        nodeInfo.display = true;
        return;
      end
    end

    if (settings.show_special_rares == true and rareInfo.special == true) then
      nodeInfo.icon = ICON_MAP.skullBlue;
      nodeInfo.display = true;
      return;
    end

    if (settings.always_show_rares == true) then
      nodeInfo.display = true;
      nodeInfo.icon = ICON_MAP.skullGray;
      return;
    end
  end

  local treasureInfo = nodeInfo.treasureInfo;

  if (settings.show_treasures == true and treasureInfo ~= nil) then
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

  local nodeData = nodes[zone] and nodes[zone][coords];

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
  wipe(dataCache.rares);
  wipe(dataCache.treasures);
  wipe(dataCache.nodes);
end

addon.export('infoProvider', {
  getNodeInfo = getNodeInfo,
  flush = flush,
});
