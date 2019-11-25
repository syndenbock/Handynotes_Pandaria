local addonName, shared = ...;

local addon = shared.addon;
local rareInfo = shared.rareInfo;
local treasureInfo = shared.treasureInfo;

local function addAchievementInfo (infoTable, id, achievementId, criteriaIndex)
  local data;

  infoTable[id] = infoTable[id] or {};
  data = infoTable[id];

  data.achievements = data.achievements or {};
  table.insert(data.achievements, {
    id = achievementId,
    index = criteriaIndex,
  });
end

local function addTreasureAchievementInfo (treasureId, achievementId, criteriaIndex)
  addAchievementInfo(treasureInfo, treasureId, achievementId, criteriaIndex);
end

local function addRareAchievementInfo (rareId, achievementId, criteriaIndex)
  local rareData;

  addAchievementInfo(rareInfo, rareId, achievementId, criteriaIndex);

  rareData = rareInfo[rareId];

  if (rareData.name == nil and criteriaIndex > 0) then
    local numCriteria = GetAchievementNumCriteria(achievementId);

    if (numCriteria >= criteriaIndex) then
      local criteriaInfo = {GetAchievementCriteriaInfo(achievementId, criteriaIndex)};

      rareData.name = criteriaInfo[1];
    end
  end
end

do
  local achievementId = 7997; -- Riches of Pandaria

  local treasureList = {
    31427, -- [1]
    31423, -- [2]
    31426, -- [3]
    31424, -- [4]
    31422, -- [5]
    31868, -- [6]
    31419, -- [7]
    31416, -- [8]
    31415, -- [9]
    31420, -- [10]
    31418, -- [11]
    31414, -- [12]
    31408, -- [13]
    31863, -- [14]
    31396, -- [15]
    31404, -- [16]
    31864, -- [17]
    31400, -- [18]
    31865, -- [19]
    31401, -- [20]
    31866, -- [21]
    31405, -- [22]
    31869, -- [23]
    31428, -- [24]
    31867, -- [25]
  };

  for x = 1, #treasureList, 1 do
    local treasureId = treasureList[x];

    addTreasureAchievementInfo(treasureId, achievementId, -1);
  end
end

-- make sure achievement data is available
addon:on('PLAYER_LOGIN', function ()
  -- commented out achievements are manually linked, see below
  local achievementList = {
    7439, -- Glorious!
    7932, -- I'm in Your Base, Killing Your Dudes
    -- 8078, -- Zul'Again
    -- 8101, -- It Was Worth Every Ritual Stone
    8103, -- Champions of Lei-Shen
    8712, -- Killing Time
    8714, -- Timeless Champion
    32640, -- Champions of the Thunder King
  };

  for x = 1, #achievementList, 1 do
    local achievementId = achievementList[x];
    local numCriteria  = GetAchievementNumCriteria(achievementId);

    for y = 1, numCriteria, 1 do
      local criteriaInfo = {GetAchievementCriteriaInfo(achievementId, y)};
      local rareId = criteriaInfo[8];

      -- -- this is for detecting unhandled rares
      -- if (rareId == nil or rareId == 0) then
      --   print(y, criteriaInfo[1], '-', rareId);
      -- end

      addRareAchievementInfo(rareId, achievementId, y);
    end
  end

  -- warscouts and warbringers are not properly returned in the achievement
  -- "Zul'Again"
  addRareAchievementInfo(69768, 8078, 1);
  addRareAchievementInfo(69769, 8078, 2);

  -- there are two npcs named "Archiereus of Flame" and therefor the Achievement
  -- returns no proper id
  addRareAchievementInfo(73174, 8714, 31);
  addRareAchievementInfo(73666, 8714, 31);

  -- "I'm in your base, killing your dudes" has faction specific NPCs
  if (UnitFactionGroup('player') == 'Alliance') then
    addRareAchievementInfo(68321, 7932, 1);
    addRareAchievementInfo(68320, 7932, 2);
    addRareAchievementInfo(68322, 7932, 3);
  else
    addRareAchievementInfo(68318, 7932, 1);
    addRareAchievementInfo(68317, 7932, 2);
    addRareAchievementInfo(68319, 7932, 3);
  end

  -- "It Was Worth Every Ritual Stone" for some reason returns weird assetIds
  addRareAchievementInfo(69471, 8101, 1);
  addRareAchievementInfo(69633, 8101, 2);
  addRareAchievementInfo(69341, 8101, 3);
  addRareAchievementInfo(69339, 8101, 4);
  addRareAchievementInfo(69749, 8101, 5);
  addRareAchievementInfo(69767, 8101, 6);
  addRareAchievementInfo(70080, 8101, 7);
  addRareAchievementInfo(69396, 8101, 8);
  addRareAchievementInfo(69347, 8101, 9);
end);
