local addonName, shared = ...;

local addon = shared.addon;

local achievementList = {
  7439, -- Glorious!
  7932, -- I'm in Your Base, Killing Your Dudes
  --8078, -- Zul'Again
  8101, -- It Was Worth Every Ritual Stone
  8103, -- Champions of Lei-Shen
  8714, -- Timeless Champion
};

local rareInfo = shared.rareInfo;

local function addAchievementInfo (rareId, achievementId, criteriaIndex)
  rareInfo[rareId] = rareInfo[rareId] or {};
  data = rareInfo[rareId];

  data.achievements = data.achievements or {};
  table.insert(data.achievements, {
    id = achievementId,
    index = criteriaIndex,
  });
end

for x = 1, #achievementList, 1 do
  local achievementId = achievementList[x];
  local numCriteria  = GetAchievementNumCriteria(achievementId);

  for y = 1, numCriteria, 1 do
    local criteriaInfo = {GetAchievementCriteriaInfo(achievementId, y)};
    local rareId = criteriaInfo[8];

    addAchievementInfo(rareId, achievementId, y);
  end
end


-- warscouts and warbringers are not properly returned in the achievement Zul'Again
addAchievementInfo(69768, 8078, 1);
addAchievementInfo(69769, 8078, 2);
