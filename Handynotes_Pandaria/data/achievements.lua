local addonName, shared = ...;

local addon = shared.addon;

local achievementList = {
  7439, -- Glorious!
  7932, -- I'm in Your Base, Killing Your Dudes
  8078, -- Zul'Again
  8101, -- It Was Worth Every Ritual Stone
  8103, -- Champions of Lei-Shen
  8714, -- Timeless Champion
};

local rareInfo = shared.rareInfo;

for x = 1, #achievementList, 1 do
  local achievementId = achievementList[x];
  local numCriteria  = GetAchievementNumCriteria(achievementId);

  for y = 1, numCriteria, 1 do
    local criteriaInfo = {GetAchievementCriteriaInfo(achievementId, y)};
    local rareId = criteriaInfo[8];
    local data;

    rareInfo[rareId] = rareInfo[rareId] or {};
    data = rareInfo[rareId];

    data.achievements = data.achievements or {};
    table.insert(data.achievements, {
      id = achievementId,
      index = y,
    });
  end
end
