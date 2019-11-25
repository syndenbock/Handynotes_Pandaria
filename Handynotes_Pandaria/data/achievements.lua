local addonName, shared = ...;

local addon = shared.addon;

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

local rareInfo = shared.rareInfo;

local function addAchievementInfo (rareId, achievementId, criteriaIndex)
  local data;

  rareInfo[rareId] = rareInfo[rareId] or {};
  data = rareInfo[rareId];

  data.achievements = data.achievements or {};
  table.insert(data.achievements, {
    id = achievementId,
    index = criteriaIndex,
  });
end

-- make sure achievement data is available
addon:on('PLAYER_LOGIN', function ()
  for x = 1, #achievementList, 1 do
    local achievementId = achievementList[x];
    local numCriteria  = GetAchievementNumCriteria(achievementId);

    for y = 1, numCriteria, 1 do
      local criteriaInfo = {GetAchievementCriteriaInfo(achievementId, y)};
      local rareId = criteriaInfo[8];

      -- this is for detecting unhandled rares
      if (rareId == nil or rareId == 0) then
        print(y, criteriaInfo[1], '-', rareId);
      end

      addAchievementInfo(rareId, achievementId, y);
    end
  end

  -- warscouts and warbringers are not properly returned in the achievement
  -- "Zul'Again"
  addAchievementInfo(69768, 8078, 1);
  addAchievementInfo(69769, 8078, 2);

  -- there are two npcs named "Archiereus of Flame" and therefor the Achievement
  -- returns no proper id
  addAchievementInfo(73174, 8103, 31);
  addAchievementInfo(73666, 8103, 31);

  -- "I'm in your base, killing your dudes" has faction specific NPCs
  if (UnitFactionGroup('player') == 'Alliance') then
    addAchievementInfo(68321, 7932, 1);
    addAchievementInfo(68320, 7932, 2);
    addAchievementInfo(68322, 7932, 3);
  else
    addAchievementInfo(68318, 7932, 1);
    addAchievementInfo(68317, 7932, 2);
    addAchievementInfo(68319, 7932, 3);
  end

  -- "It Was Worth Every Ritual Stone" for some reason returns weird assetIds
  addAchievementInfo(69471, 8101, 1);
  addAchievementInfo(69633, 8101, 2);
  addAchievementInfo(69341, 8101, 3);
  addAchievementInfo(69339, 8101, 4);
  addAchievementInfo(69749, 8101, 5);
  addAchievementInfo(69767, 8101, 6);
  addAchievementInfo(70080, 8101, 7);
  addAchievementInfo(69396, 8101, 8);
  addAchievementInfo(69347, 8101, 9);
end);
