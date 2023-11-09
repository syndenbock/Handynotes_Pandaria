local _, shared = ...;

shared.achievementData = {
  rares = {
    auto = {
      7439, -- Glorious!
      7932, -- I'm in Your Base, Killing Your Dudes
      -- 8101, -- It Was Worth Every Ritual Stone
      8103, -- Champions of Lei-Shen
      8712, -- Killing Time
      8714, -- Timeless Champion
      32640, -- Champions of the Thunder King
    },
    static = {
      -- warscouts and warbringers are not properly returned in the achievement
      -- "Zul'Again"
      [8078] = {
        {
          id = 69768,
        }, {
          id = 69769,
        }
      },
      -- there are two npcs named "Archiereus of Flame" and therefor the Achievement
      -- returns no proper id
      [8714] = {
        {
          id = 73174,
          index = 31,
        }, {
          id = 73666,
          index = 31,
        }
      },
      -- "It Was Worth Every Ritual Stone" for some reason returns weird assetIds
      [8101] = {
        {
          id = 69471,
        }, {
          id = 69633,
        }, {
          id = 69341,
        }, {
          id = 69339,
        }, {
          id = 69749,
        }, {
          id = 69767,
        }, {
          id = 70080,
        }, {
          id = 69396,
        }, {
          id = 69347,
          description = 'Needs 3x Shan\'ze Ritual Stone to summon',
        },
      },
    },
  },
  treasures = {
    static = {
      [7997] = { -- Riches of Pandaria
        31400,
        31396,
        31401,
        31404,
        31405,
        31408,
        31414,
        31415,
        31416,
        31418,
        31419,
        31420,
        31422,
        31423,
        31424,
        31426,
        31427,
        31428,
      },
    },
  },
}

-- "I'm in your base, killing your dudes" has faction specific NPCs
if (_G.UnitFactionGroup('player') == 'Alliance') then
  shared.achievementData.rares.static[7932] = {
    {
      id = 68321,
    }, {
      id = 68320,
    }, {
      id = 68322,
    },
  };
else
  shared.achievementData.rares.static[7932] = {
    {
      id = 68318,
    }, {
      id = 68317,
    },  {
      id = 68319,
    },
  };
end
