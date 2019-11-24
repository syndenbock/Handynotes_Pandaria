local addonName, shared = ...;

local addon = shared.addon;
local rareInfo = shared.rareInfo;

local function getToyIcon (toyId)
  local info = {GetItemInfo(toyId)};
  local icon = info[10];

  return icon;
end

local function updateRareInfo (info, nodeData)
  local rareId = nodeData.rare;

  if (rareId == nil) then return end

  local rareData = rareInfo[rareId];

  if (rareData == nil) then
    --print('No data about rare', rareId);
  else
    local toyList = rareData.toys;
    local achievementList = rareData.achievements;

    if (toyList ~= nil) then
      for x = 1, #toyList, 1 do
        local toy = toyList[x];

        if (not PlayerHasToy(toy)) then
          --print('toy', rareId);
          info.display = true;
          info.icon = getToyIcon(toy) or 'Interface\\Addons\\Handynotes_Pandaria\\icons\\RareIconGreen.tga';
          -- @TODO fill in toy information
        end
      end
    end

    if (achievementList ~= nil) then
      for x = 1, #achievementList, 1 do
        local achievementData = achievementList[x];
        local achievementId = achievementData.id;
        local achievementInfo = {GetAchievementInfo(achievementId)};
        local completed = achievementInfo[4];

        if (not completed) then
          local criteriaIndex = achievementData.index;
          local criteriaInfo = {GetAchievementCriteriaInfo(achievementId, criteriaIndex)};
          local completed = criteriaInfo[3];

          if (not completed) then
            --print('achieve', rareId);
            info.display = true;
            info.icon = 'Interface\\Addons\\Handynotes_Pandaria\\icons\\RareIcon.tga';
            -- @TODO fill in achievement information
          end
        end
      end
    end
  end
end

local function updateTreasureInfo (info, nodeData)
  local treasureId = nodeData.treasure;

  if (treasureId == nil) then return end

  local completed = IsQuestFlaggedCompleted(treasureId);

  if (not completed) then
    info.display = true;
    info.icon = 'Interface\\Icons\\TRADE_ARCHAEOLOGY_CHESTOFTINYGLASSANIMALS';
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
