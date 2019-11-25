local addonName, shared = ...;

local addon = shared.addon;
local rareInfo = shared.rareInfo;
local treasureInfo = shared.treasureInfo;

local ICON_MAP = {
  question = 'Interface\\Icons\\inv_misc_questionmark',
  skullGray = 'Interface\\Addons\\Handynotes_Pandaria\\icons\\RareIcon.tga',
  skullGreen = 'Interface\\Addons\\Handynotes_Pandaria\\icons\\RareIconGreen.tga',
  skullOrange = 'Interface\\Addons\\Handynotes_Pandaria\\icons\\RareIconOrange.tga',
  chest = 'Interface\\Icons\\TRADE_ARCHAEOLOGY_CHESTOFTINYGLASSANIMALS',
};

local COLOR_MAP = {
  red = '|cFFFF0000',
  blue = '|cFF0000FF',
  green = '|cFF00FF00',
  yellow = '|cFFFFFF00',
};

local function setTextColor (text, color)
  return color .. text .. '|r';
end

local function getItemIcon (itemId)
  local info = {GetItemInfo(itemId)};
  local icon = info[10];

  return icon;
end

local function updateAchievementInfo (info, rareData)
  local achievementList = rareData.achievements;

  if (achievementList == nil) then return end

  for x = 1, #achievementList, 1 do
    local achievementData = achievementList[x];
    local achievementId = achievementData.id;
    local achievementInfo = {GetAchievementInfo(achievementId)};
    local text = achievementInfo[2];
    local completed = achievementInfo[4];
    local criteriaIndex = achievementData.index;
    local fulfilled;

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

    if (not completed and not fulfilled) then
      info.display = true;
      info.icon = ICON_MAP.skullGray;
    end

    table.insert(info.text, text);
  end
end

local function updateToyInfo (info, rareData)
  local toyList = rareData.toys;

  if (toyList == nil) then return end

  for x = 1, #toyList, 1 do
    local toy = toyList[x];
    local toyInfo = {GetItemInfo(toy)};
    local toyName = toyInfo[1];
    local text = 'Toy: ';

    if (PlayerHasToy(toy)) then
      text = setTextColor(text, COLOR_MAP.green);
    else
      text = setTextColor(text, COLOR_MAP.red);
      info.display = true;
      info.icon = getItemIcon(toy) or ICON_MAP.skullGreen;
      -- @TODO fill in toy information
    end

    text = text .. toyName;
    table.insert(info.text, text);
  end
end

local function updateMountInfo (info, rareData)
  local mountList = rareData.mounts;

  if (mountList == nil) then return end

  for x = 1, #mountList, 1 do
    local mountId = mountList[x];
    local mountInfo = {C_MountJournal.GetMountInfoByID(mountId)};
    local mountName = mountInfo[1];
    local collected = mountInfo[11];
    local text = 'Mount: ';

    if (collected) then
      text = setTextColor(text, COLOR_MAP.green);
    else
      text = setTextColor(text, COLOR_MAP.red);
      info.display = true;
      info.icon = mountInfo[3] or ICON_MAP.skullOrange;
    end

    text = text .. mountName;
    table.insert(info.text, text);
  end
end

local function updateRareInfo (info, nodeData)
  local rareId = nodeData.rare;

  if (rareId == nil) then return false end

  local rareData = rareInfo[rareId];

  if (rareData == nil) then
    return false;
  end

  updateAchievementInfo(info, rareData);
  updateToyInfo(info, rareData);
  updateMountInfo(info, rareData);

  return true;
end

local function updateTreasureInfo (info, nodeData)
  local treasureId = nodeData.treasure;

  if (treasureId == nil) then return false end

  local completed = IsQuestFlaggedCompleted(treasureId);
  local treasureData = treasureInfo[treasureId];

  if (treasureData == nil) then
    print('no information about treasure:', treasureId);
  else
    info.name = treasureData.name;
    info.description = treasureData.description;
  end

  if (not completed) then
    info.display = true;
    info.icon = ICON_MAP.chest;
    -- @TODO fill in treasure information
  end

  local achievementInfo = {text = {}};
  updateAchievementInfo(achievementInfo, treasureData);

  if (achievementInfo ~= nil) then
    for x = 1, #achievementInfo.text, 1 do
      table.insert(info.text, achievementInfo.text[x]);
    end
  else
    print(treasureData.achievements);
  end

  return true;
end

function addon:getNodeInfo(nodeData)
  local info = {
    display = false,
    text = {},
  };
  local hasInfo = false;

  --print(nodeData.rare);

  hasInfo = hasInfo or updateRareInfo(info, nodeData);
  hasInfo = hasInfo or updateTreasureInfo(info, nodeData);

  if (not hasInfo) then
    return nil;
  end

  return info;
end
