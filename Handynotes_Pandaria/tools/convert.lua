local addonName, shared = ...;

local addon = shared.addon;

addon:RegisterEvent('PLAYER_LOGIN', function ()
  local MAP_IDS = {
    jadeforest = 371,
    valleyoffourwinds = 376,
    kunlai = 379,
    townlong = 388,
    valeofblossoms = 390,
    krasarang = 418,
    dreadwastes = 422,
    veiledstar = 433,
    isleofthunder = 504,
    isleofgiants = 507,
    timelessisle = 554,
  };
  local nodes = {};
  local convertedNodes = {};

  nodes[MAP_IDS.jadeforest] = {
    [50750] = {{33605080}, "", "skull_rare", "rare_tjf", "970003"},
    [51078] = {{56404880, 53604960, 53804560, 52204440, 54204240}, "", "skull_rare", "rare_tjf", "970004"},
    [50338] = {{44007500}, "", "skull_rare", "rare_tjf", "970005"},
    [50363] = {{39606260}, "", "skull_rare", "rare_tjf", "970006"},
    [50350] = {{48202060, 48001860, 46601680, 42601620, 42201760, 40801520}, "", "skull_rare", "rare_tjf", "970007"},
    [50782] = {{64607420}, "", "skull_rare", "rare_tjf", "970008"},
    [50808] = {{57407140}, "", "skull_rare", "rare_tjf", "970009"},
    [50823] = {{42603880}, "", "skull_rare", "rare_tjf", "970010"},
  };

  nodes[MAP_IDS.valleyoffourwinds] = {
    [50828] = {{16604100, 14003820, 19003580, 16803520, 15603200}, "", "default", "rare_fw", "970011"},
    [50364] = {{09206060, 09204740, 12604880, 08205960}, "", "default", "rare_fw", "970012"},
    [51059] = {{32806280, 37806060, 34605960, 39605760}, "", "default", "rare_fw", "970013"},
    [50811] = {{88601800}, "", "default", "rare_fw", "970014"},
    [50351] = {{18607760}, "", "default", "rare_fw", "970015"},
    [50339] = {{37002560}, "", "default", "rare_fw", "970016"},
    [50783] = {{67605960, 71005240, 74605180, 75804640}, "", "default", "rare_fw", "970017"},
    [50766] = {{52802860, 54003160, 54603660, 57603380, 59003860}, "", "skull_rare", "rare_fw", "970018"},
    [50339] = {{37002560}, "", "skull_rare", "rare_fw", "970019"},
  }

  nodes[MAP_IDS.krasarang] = {
    [50787] = {{56204680}, "", "skull_rare", "rare_kra", "970020"},
    [50768] = {{30603820}, "", "skull_rare", "rare_kra", "970021"},
    [50340] = {{53603880}, "", "skull_rare", "rare_kra", "970022"},
    [50331] = {{39602900}, "", "skull_rare", "rare_kra", "970023"},
    [50352] = {{67202300}, "", "skull_rare", "rare_kra", "970024"},
    [50816] = {{39405520, 41605520}, "", "skull_rare", "rare_kra", "970025"},
    [50830] = {{52208800}, "", "skull_rare", "rare_kra", "970026"},
    [50388] = {{15203560}, "", "skull_rare", "rare_kra", "970027"},

    --5.1 killing your dudes elites
    [68318] = {{85002760}, "", "skull_grey", "rare_kra", "970115"},
    [68317] = {{84603100}, "", "skull_grey", "rare_kra", "970116"},
    [68319] = {{87402920}, "", "skull_grey", "rare_kra", "970117"},
    [68321] = {{14805720}, "", "skull_grey", "rare_kra", "970118"},
    [68320] = {{13206600}, "", "skull_grey", "rare_kra", "970119"},
    [68322] = {{10605700}, "", "skull_grey", "rare_kra", "970120"},
  }

  nodes[MAP_IDS.kunlai] = {
    [50817] = {{40804240}, "", "default", "rare_ks", "970028"},
    [50769] = {{73207640,73807740,74407920}, "", "default", "rare_ks", "970029"},
    [50733] = {{36607960}, "", "default", "rare_ks", "970030"},
    [50354] = {{59207380, 57007580, 57607500}, "", "default", "rare_ks", "970031"},
    [50831] = {{47206300, 46206180, 44806360, 44806520}, "Chance to drop item that increases reputation with all Pandaria's factions by 1000.", "default", "rare_ks", "970032"},
    [50341] = {{56004340}, "", "skull_rare", "rare_ks", "970033"},
    [50332] = {{51608100, 47408120}, "", "skull_rare", "rare_ks", "970034"},
    [50789] = {{63801380}, "", "default", "rare_ks", "970035"},
  }

  nodes[MAP_IDS.townlong] = {
    [50772] = {{68808920, 67808760, 66408680, 65408760}, "", "skull_rare", "rare_ts", "970036"},
    [50355] = {{63003560}, "", "skull_rare", "rare_ts", "970037"},
    [50734] = {{46407440, 42007840, 47608420, 47808860}, "", "skull_rare", "rare_ts", "970038"},
    [50333] = {{66804440, 67805080, 64204980}, "", "skull_rare", "rare_ts", "970039"},
    [50344] = {{54006340}, "", "skull_rare", "rare_ts", "970040"},
    [50791] = {{59208560}, "", "skull_rare", "rare_ts", "970041"},
    [50832] = {{67607440}, "", "skull_rare", "rare_ts", "970042"},
    [50820] = {{32006180}, "", "skull_rare", "rare_ts", "970043"},
    [66900] = {{37205760}, "", "default", "rare_ts", "970120"},
  }

  nodes[MAP_IDS.dreadwastes] = {
    [50836] = {{55406340}, "", "default", "rare_dw", "970044"},
    [50821] = {{34802320}, "", "default", "rare_dw", "970045"},
    [50356] = {{73602360, 74002080, 73202040, 73002220}, "Drops item that increases experience gains by 300% for 1 hour. Does not work above level 84.", "default", "rare_dw", "970046"},
    [50776] = {{64205860}, "Drops battle pet Aqua Strider", "default", "rare_dw", "970047"},
    [50334] = {{25202860}, "", "skull_rare", "rare_dw", "970048"},
    [50739] = {{39204180, 37802960, 35603080}, "", "default", "rare_dw", "970049"},
    [50347] = {{71803760}, "", "skull_rare", "rare_dw", "970050"},
    [50805] = {{39606180, 36606460, 39605840, 36806060}, "", "skull_rare", "rare_dw", "970051"},
  }

  nodes[MAP_IDS.valeofblossoms] = {
    [50822] = {{42606900}, "", "default", "rare_eb", "970052"},
    [50359] = {{39802500}, "", "default", "rare_eb", "970053"},
    [50806] = {{35206180, 43805180, 39005340, 36805780,43405340}, "Roams in the old river between the location points.", "default", "rare_eb", "970054"},
    [50749] = {{14005860, 14005820}, "", "default", "rare_eb", "970055"},
    [50349] = {{15003560}, "", "default", "rare_eb", "970056"},
    [50336] = {{87804460}, "", "default", "rare_eb", "970057"},
    [50780] = {{69603080}, "", "default", "rare_eb", "970058"},
    [64403] = {{51404300, 38806560, 16804040}, "Giant serpent dragon flying arround the Vale. Needs Sky Crystal to remove immunity.", "default", "rare_eb", "970059"},
    [50840] = {{31009160}, "", "default", "rare_eb", "970060"},
  }

  nodes[MAP_IDS.timelessisle] = {
    [72898] = {{35003240, 34802940, 45002600, 49603360, 50602340, 57602640, 55803560}, "", "skull_grey", "rare_ti", "970061"},
    [73171] = {{59605280, 62804360, 66004260, 70604580, 70805260, 68005740}, "", "default", "rare_ti", "970062"},
    [72896] = {{35603620, 68803440, 56005960, 56003820, 54002400, 41603020}, "", "default", "rare_ti", "970063"},
    [72970] = {{61606360}, "", "default", "rare_ti", "970064"},
    [73281] = {{25802320}, "", "default", "rare_ti", "970065"},
    [73169] = {{53608300}, "", "default", "rare_ti", "970066"},
    [73167] = {{65605680}, "", "default", "rare_ti", "970067"},
    [73666] = {{50202290}, "", "skull_grey", "rare_ti", "970068"},
    [73174] = {{34803120}, "", "skull_grey", "rare_ti", "970114"},
    [72775] = {{63807300}, "", "skull_grey", "rare_ti", "970069"},
    [72045] = {{25203600}, "", "skull_grey", "rare_ti", "970070"},
    [72049] = {{43806960}, "", "skull_grey", "rare_ti", "970071"},
    [73158] = {{31004920}, "", "skull_grey", "rare_ti", "970072"},
    [73279] = {{72808480}, "", "skull_grey", "rare_ti", "970073"},
    [73172] = {{46603960}, "", "skull_grey", "rare_ti", "970074"},
    [73282] = {{64602860}, "", "skull_grey", "rare_ti", "970075"},
    [72970] = {{61606400}, "", "skull_grey", "rare_ti", "970076"},
    [73161] = {{24605760}, "", "skull_grey", "rare_ti", "970077"},
    [72909] = {{40607960}, "", "skull_grey", "rare_ti", "970078"},
    [73163] = {{34207340}, "", "skull_grey", "rare_ti", "970079"},
    [73160] = {{29804560}, "", "skull_grey", "rare_ti", "970080"},
    [72193] = {{33808580}, "", "skull_grey", "rare_ti", "970081"},
    [73277] = {{67604400}, "", "skull_grey", "rare_ti", "970082"},
    [73166] = {{22803240}, "", "skull_grey", "rare_ti", "970083"},
    [72048] = {{60608780}, "", "skull_grey", "rare_ti", "970084"},
    [73157] = {{44203100}, "Inside cave\n", "skull_grey", "rare_ti", "970085"},
    [71864] = {{59004880}, "", "skull_grey", "rare_ti", "970086"},
    [72769] = {{44803880}, "Inside cave\n", "skull_grey", "rare_ti", "970087"},
    [73704] = {{71408140}, "", "skull_grey", "rare_ti", "970088"},
    [72808] = {{54204280}, "", "skull_grey", "rare_ti", "970089"},
    [73173] = {{44202660}, "", "skull_grey", "rare_ti", "970090"},
    [73170] = {{57607720}, "", "skull_grey", "rare_ti", "970091"},
    [72245] = {{47608780}, "", "skull_grey", "rare_ti", "970092"},
    [71919] = {{37807720}, "", "skull_grey", "rare_ti", "970093"},
    [73175] = {{54005240}, "", "skull_grey", "rare_ti", "970094"},
    [73854] = {{43806960}, "", "skull_grey", "rare_ti", "970121"},
  }

  nodes[MAP_IDS.isleofthunder] = {
    [50358] = {{39608120}, "", "ritual_stone", "rare_it", "970095"},
    [69996] = {{37608300}, "", "skull_grey", "rare_it", "970096"},
    [69998] = {{53705310}, "", "skull_grey", "rare_it", "970097"},
    [69664] = {{35006200}, "", "skull_grey", "rare_it", "970098"},
    [69999] = {{61604980}, "", "skull_grey", "rare_it", "970099"},
    [70000] = {{44602960}, "", "skull_grey", "rare_it", "970100"},
    [70001] = {{48202560}, "", "skull_grey", "rare_it", "970101"},
    [70002] = {{54403580}, "", "skull_grey", "rare_it", "970102"},
    [70003] = {{63404900}, "", "skull_grey", "rare_it", "970103"},
    [69997] = {{51007120}, "", "skull_grey", "rare_it", "970113"},
    [69471] = {{35706380}, "Needs 3x[Shan'ze Ritual Stone] to summon", "skull_grey", "rare_it", "970104"},
    [69633] = {{30705860}, "Needs 3x[Shan'ze Ritual Stone] to summon", "skull_grey", "rare_it", "970105"},
    [69341] = {{55208770}, "Needs 3x[Shan'ze Ritual Stone] to summon", "skull_grey", "rare_it", "970106"},
    [69339] = {{44506100}, "Needs 3x[Shan'ze Ritual Stone] to summon", "skull_grey", "rare_it", "970107"},
    [69749] = {{48002600}, "Needs 3x[Shan'ze Ritual Stone] to summon", "skull_grey", "rare_it", "970108"},
    [69767] = {{55304790}, "Needs 3x[Shan'ze Ritual Stone] to summon", "skull_grey", "rare_it", "970109"},
    [70080] = {{68903930}, "Needs 3x[Shan'ze Ritual Stone] to summon", "skull_grey", "rare_it", "970110"},
    [69396] = {{57907920}, "Needs 3x[Shan'ze Ritual Stone] to summon", "skull_grey", "rare_it", "970111"},
    [69347] = {{49902070}, "Needs 3x[Shan'ze Ritual Stone] to summon", "skull_grey", "rare_it", "970112"},
  }

  for zone, nodeList in pairs(nodes) do
    local zoneData = {};

    convertedNodes[zone] = zoneData;

    for asset, data in pairs(nodeList) do
      local coordList = data[1];

      for x = 1, #coordList, 1 do
        zoneData[coordList[x]] = {
          rare = asset,
        };
      end
    end
  end

  convertedData = convertedNodes;
end);
