local addonName, shared = ...;

local addon = shared.addon;

local achievementList = {
  7439, -- Glorious!
  7932, -- I'm in Your Base, Killing Your Dudes
  --8078, -- Zul'Again
  8101, -- It Was Worth Every Ritual Stone
  8103, -- Champions of Lei-Shen
  8712, -- Killing Time
  8714, -- Timeless Champion
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
  print('achieve!');
  for x = 1, #achievementList, 1 do
    local achievementId = achievementList[x];
    local numCriteria  = GetAchievementNumCriteria(achievementId);

    for y = 1, numCriteria, 1 do
      local criteriaInfo = {GetAchievementCriteriaInfo(achievementId, y)};
      local rareId = criteriaInfo[8];

--      -- this is for detecting unhandled rares
--      if (rareId == nil or rareId == 0) then
--        print(y, criteriaInfo[1], '-', rareId);
--      end

      addAchievementInfo(rareId, achievementId, y);
    end
  end

  -- warscouts and warbringers are not properly returned in the achievement
  -- Zul'Again
  addAchievementInfo(69768, 8078, 1);
  addAchievementInfo(69769, 8078, 2);

  -- there are two npcs named "Archiereus of Flame" and therefor the Achievement
  -- returns no proper id
  addAchievementInfo(73174, 8103, 31);
  addAchievementInfo(73666, 8103, 31);
end);
