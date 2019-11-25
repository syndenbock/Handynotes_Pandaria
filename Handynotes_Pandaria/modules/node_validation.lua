local addonName, shared = ...;

local addon = shared.addon;
local rareInfo = shared.rareInfo;

local ICON_MAP = {
  skullGray = 'Interface\\Addons\\Handynotes_Pandaria\\icons\\RareIcon.tga',
  skullGreen = 'Interface\\Addons\\Handynotes_Pandaria\\icons\\RareIconGreen.tga',
  skullOrange = 'Interface\\Addons\\Handynotes_Pandaria\\icons\\RareIconOrange.tga',
  chest = 'Interface\\Icons\\TRADE_ARCHAEOLOGY_CHESTOFTINYGLASSANIMALS',
};

local function getItemIcon (itemId)
  local info = {GetItemInfo(itemId)};
  local icon = info[10];

  return icon;
end

local function updateToyInfo (info, rareData)
  local toyList = rareData.toys;

  if (toyList == nil) then return end

  for x = 1, #toyList, 1 do
    local toy = toyList[x];

    if (not PlayerHasToy(toy)) then
      --print('toy', rareId);
      info.display = true;
      info.icon = getItemIcon(toy) or ICON_MAP.skullGreen;
      -- @TODO fill in toy information
    end
  end
end

local function updateAchievementInfo (info, rareData)
  local achievementList = rareData.achievements;

  if (achievementList == nil) then return end

  for x = 1, #achievementList, 1 do
    local achievementData = achievementList[x];
    local achievementId = achievementData.id;
    local achievementInfo = {GetAchievementInfo(achievementId)};
    local completed = achievementInfo[4];

    if (not completed) then
      local criteriaIndex = achievementData.index;
      local numCriteria = GetAchievementNumCriteria(achievementId);

      -- some achievements and their indices are set statically, so we make
      -- sure the criteria exists
      if (criteriaIndex <= numCriteria) then
        local criteriaInfo = {GetAchievementCriteriaInfo(achievementId, criteriaIndex)};
        local completed = criteriaInfo[3];

        if (not completed) then
          --print('achieve', rareId);
          info.display = true;
          info.icon = ICON_MAP.skullGray;
          -- @TODO fill in achievement information
        end
      end
    end
  end
end

local function updateMountInfo (info, rareData)
  local mountList = rareData.mounts;

  if (mountList == nil) then return end

  for x = 1, #mountList, 1 do
    local mountId = mountList[x];
    local mountInfo = {C_MountJournal.GetMountInfoByID(mountId)};
    local collected = mountInfo[11];

    if (not collected) then
      info.display = true;
      info.icon = getItemIcon(mountId) or ICON_MAP.skullOrange;
    end
  end
end

local function updateRareInfo (info, nodeData)
  local rareId = nodeData.rare;

  if (rareId == nil) then return end

  local rareData = rareInfo[rareId];

  if (rareData == nil) then
    print('No data about rare', rareId);
    return
  end

  updateAchievementInfo(info, rareData);
  updateToyInfo(info, rareData);
  updateMountInfo(info, rareData);
end

local function updateTreasureInfo (info, nodeData)
  local treasureId = nodeData.treasure;

  if (treasureId == nil) then return end

  local completed = IsQuestFlaggedCompleted(treasureId);

  if (not completed) then
    info.display = true;
    info.icon = ICON_MAP.chest;
    -- @TODO fill in treasure information
  end
end

function addon:getNodeInfo(nodeData)
  local info = {};
  info.display = false;

  --print(nodeData.rare);
  updateRareInfo(info, nodeData);
  updateTreasureInfo(info, nodeData);

  return info;
end
