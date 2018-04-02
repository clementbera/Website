--宝石TD
--@author 萌小虾
if GemTD == nil then
	GemTD = class({})
end

--加载需要的模块
require('pathfinder/core/bheap')
md5 = require('md5')
json = require('dkjson')
require('Timers')
require('Physics')
require('util')
require('barebones')

BASE_MODULES = {
	'pathfinder/core/heuristics',
	'pathfinder/core/node', 'pathfinder/core/path',
	'pathfinder/grid', 'pathfinder/pathfinder',

	'pathfinder/search/astar', 'pathfinder/search/bfs',
	'pathfinder/search/dfs', 'pathfinder/search/dijkstra',
	'pathfinder/search/jps',  'timer/Timers',
	'bit', 'randomlua',
	'amhc_library/amhc'
}

local function load_module(mod_name)
	local status, err_msg = pcall(function()
		require(mod_name)
	end)
	if status then
		print('Load module <' .. mod_name .. '> OK')
	else
		print('Load module <' .. mod_name .. '> FAILED: '..err_msg)
	end
end

for i, mod_name in pairs(BASE_MODULES) do
	load_module(mod_name)
end


--全局变量
time_tick = 0
GameRules.gem_hero = {
	[0] = nil,
	[1] = nil,
	[2] = nil,
	[3] = nil
}

GameRules.crab = nil
GameRules.guangzhudaobiao = nil

GameRules.hero_sea = {
	h101 = "npc_dota_hero_enchantress",
	h102 = "npc_dota_hero_puck",
	h103 = "npc_dota_hero_omniknight",
	h104 = "npc_dota_hero_wisp",
	h105 = "npc_dota_hero_ogre_magi",
	h106 = "npc_dota_hero_lion",
	h107 = "npc_dota_hero_keeper_of_the_light",
	h108 = "npc_dota_hero_rubick",
	h109 = "npc_dota_hero_jakiro",
	h110 = "npc_dota_hero_sand_king", --new

	h201 = "npc_dota_hero_crystal_maiden",
	h202 = "npc_dota_hero_death_prophet",
	h203 = "npc_dota_hero_templar_assassin",
	h204 = "npc_dota_hero_lina",
	h205 = "npc_dota_hero_tidehunter",
	h206 = "npc_dota_hero_naga_siren",
	h207 = "npc_dota_hero_phoenix",
	h208 = "npc_dota_hero_dazzle",
	h209 = "npc_dota_hero_warlock",
	h210 = "npc_dota_hero_necrolyte",
	h211 = "npc_dota_hero_lich",
	h212 = "npc_dota_hero_furion",
	h213 = "npc_dota_hero_venomancer",
	h214 = "npc_dota_hero_kunkka",
	h215 = "npc_dota_hero_axe",
	h216 = "npc_dota_hero_slark",
	h217 = "npc_dota_hero_viper", --new
	h218 = "npc_dota_hero_tusk", --new
	h219 = "npc_dota_hero_abaddon", --new

	h301 = "npc_dota_hero_windrunner",
	h302 = "npc_dota_hero_phantom_assassin",
	h303 = "npc_dota_hero_sniper",
	h304 = "npc_dota_hero_sven",
	h305 = "npc_dota_hero_luna",
	h306 = "npc_dota_hero_mirana",
	h307 = "npc_dota_hero_nevermore",
	h308 = "npc_dota_hero_queenofpain",
	h309 = "npc_dota_hero_juggernaut",
	h310 = "npc_dota_hero_pudge",
	h311 = "npc_dota_hero_shredder",
	h312 = "npc_dota_hero_slardar",
	h313 = "npc_dota_hero_antimage",
	h314 = "npc_dota_hero_bristleback", --new
	h315 = "npc_dota_hero_lycan", --new
	h316 = "npc_dota_hero_lone_druid", --new

	h401 = "npc_dota_hero_vengefulspirit",
	h402 = "npc_dota_hero_invoker",
	h403 = "npc_dota_hero_alchemist",
	h404 = "npc_dota_hero_spectre",
	h405 = "npc_dota_hero_morphling",
	h406 = "npc_dota_hero_techies",
	h407 = "npc_dota_hero_chaos_knight",
	h408 = "npc_dota_hero_faceless_void",
	h409 = "npc_dota_hero_legion_commander",
	h410 = "npc_dota_hero_monkey_king", --new
	h411 = "npc_dota_hero_razor", --new
	h412 = "npc_dota_hero_tinker", --new
	h413 = "npc_dota_hero_pangolier", --new
	h414 = "npc_dota_hero_dark_willow", --new
}

GameRules.ability_sea = {
    a101 = "gemtd_hero_huichun",
    a102 = "gemtd_hero_shanbi",
    a103 = "gemtd_hero_shouhu",
    a105 = "gemtd_hero_beishuiyizhan",

    a201 = "gemtd_hero_lanse",
    a202 = "gemtd_hero_danbai",
    a203 = "gemtd_hero_baise",
    a204 = "gemtd_hero_hongse",
    a205 = "gemtd_hero_lvse",
    a206 = "gemtd_hero_fense",
    a207 = "gemtd_hero_huangse",
    a208 = "gemtd_hero_zise",
    a209 = "gemtd_hero_jingying",
    a210 = "gemtd_hero_putong",
    a211 = "gemtd_hero_qingyi",
    a212 = "gemtd_hero_shitou", --new

    a301 = "gemtd_hero_kuaisusheji",
    a302 = "gemtd_hero_baoji",
    a303 = "gemtd_hero_miaozhun",
    a304 = "gemtd_hero_fengbaozhichui",
    a305 = "gemtd_hero_wuxia",
    a306 = "gemtd_hero_huidaoguoqu",
    a307 = "gemtd_hero_lianjie",
    a308 = "gemtd_hero_xuanfeng", --new

    a401 = "gemtd_hero_yixinghuanwei",
    a402 = "gemtd_hero_wanmei",
    a403 = "gemtd_hero_guangzhudaobiao",

    a1001 = "tt1",
    a1002 = "tt2",
    a1003 = "tt3",
    a1004 = "tt4",
    a1005 = "tt5",
    a1006 = "tt6",
    a1007 = "tt7",
    a1008 = "tt8",

}

GameRules.stealable_ability_pool = {
	"tower_slow1","tower_slow2","tower_slow3","tower_slow4","tower_slow5","tower_slow6",
	"tower_true_sight",
	"tower_speed_aura1","tower_speed_aura2","tower_speed_aura3","tower_speed_aura4","tower_speed_aura5","tower_speed_aura6","tower_speed_aura_guichu",
	"tower_jianshe1","tower_jianshe2","tower_jianshe3","tower_jianshe4","tower_jianshe5","tower_jianshe6","tower_ranjin",
	"tower_du1","tower_du2","tower_du3","tower_du4","tower_du5","tower_du6",
	"tower_fenliejian","tower_fenliejian_xianyan",
	"tower_jianjia1","tower_jianjia2","tower_jianjia3","tower_jianjia4","tower_jianjia5","tower_jianjia6",
	"tower_huiyao","tower_huiyao2","tower_huiyao3",
	"tower_fenzheng","tower_zheyi","tower_zheyi2","tower_zheyi3","tower_bixi","tower_bixi2",
	"tower_baoji1","tower_lanbaoshi","tower_jihan","tower_jingzhun","tower_10jiyun","tower_5shihua",
	"tower_maoyan","tower_jin","tower_jin2","tower_shandianlian","tower_chazhuangshandian",
	"tower_fenliejian_you","tower_chenmoguanghuan","tower_lanbaoshi2","tower_aojiao",
	"tower_attack1","tower_attack2","tower_attack3","tower_attack4","tower_attack5","tower_attack6","tower_attack7","tower_speed1","tower_speed2","chain_frost",
}

GameRules.pet_list = {
	--普通信使 beginner
	h101 = "models/courier/skippy_parrot/skippy_parrot.vmdl",
	h102 = "models/courier/smeevil_mammoth/smeevil_mammoth.vmdl",
	h103 = "models/items/courier/arneyb_rabbit/arneyb_rabbit.vmdl",
	h104 = "models/items/courier/axolotl/axolotl.vmdl",
	h105 = "models/items/courier/coco_the_courageous/coco_the_courageous.vmdl",
	h106 = "models/items/courier/coral_furryfish/coral_furryfish.vmdl",
	h107 = "models/items/courier/corsair_ship/corsair_ship.vmdl",
	h108 = "models/items/courier/duskie/duskie.vmdl",
	h109 = "models/items/courier/itsy/itsy.vmdl",
	h110 = "models/items/courier/jumo/jumo.vmdl",
	h111 = "models/items/courier/mighty_chicken/mighty_chicken.vmdl",
	h112 = "models/items/courier/nexon_turtle_05_green/nexon_turtle_05_green.vmdl",
	h113 = "models/items/courier/pumpkin_courier/pumpkin_courier.vmdl",
	h114 = "models/items/courier/pw_ostrich/pw_ostrich.vmdl",
	h115 = "models/items/courier/scuttling_scotty_penguin/scuttling_scotty_penguin.vmdl",
	h116 = "models/items/courier/shagbark/shagbark.vmdl",
	h117 = "models/items/courier/snaggletooth_red_panda/snaggletooth_red_panda.vmdl",
	h118 = "models/items/courier/snail/courier_snail.vmdl",
	h119 = "models/items/courier/teron/teron.vmdl",
	h120 = "models/items/courier/xianhe_stork/xianhe_stork.vmdl",

	h121 = "models/items/courier/starladder_grillhound/starladder_grillhound.vmdl",
	h122 = "models/items/courier/pw_zombie/pw_zombie.vmdl",
	h123 = "models/items/courier/raiq/raiq.vmdl",
	h124 = "models/courier/frog/frog.vmdl",
	h125 = "models/courier/godhorse/godhorse.vmdl",
	h126 = "models/courier/imp/imp.vmdl",
	h127 = "models/courier/mighty_boar/mighty_boar.vmdl",
	h128 = "models/items/courier/onibi_lvl_03/onibi_lvl_03.vmdl",
	h129 = "models/items/courier/echo_wisp/echo_wisp.vmdl",  --蠕行水母

	--小英雄信使 ameteur
	h201 = "models/courier/doom_demihero_courier/doom_demihero_courier.vmdl",
	h202 = "models/courier/huntling/huntling.vmdl",
	h203 = "models/courier/minipudge/minipudge.vmdl",
	h204 = "models/courier/seekling/seekling.vmdl",
	h205 = "models/items/courier/baekho/baekho.vmdl",
	h206 = "models/items/courier/basim/basim.vmdl",
	h207 = "models/items/courier/devourling/devourling.vmdl",
	h208 = "models/items/courier/faceless_rex/faceless_rex.vmdl",
	h209 = "models/items/courier/tinkbot/tinkbot.vmdl",
	h210 = "models/items/courier/lilnova/lilnova.vmdl",

	h211 = "models/items/courier/amphibian_kid/amphibian_kid.vmdl",
	h212 = "models/courier/venoling/venoling.vmdl",
	h213 = "models/courier/juggernaut_dog/juggernaut_dog.vmdl",
	h214 = "models/courier/otter_dragon/otter_dragon.vmdl",
	h215 = "models/items/courier/boooofus_courier/boooofus_courier.vmdl",
	h216 = "models/courier/baby_winter_wyvern/baby_winter_wyvern.vmdl",
	h217 = "models/courier/yak/yak.vmdl",
	h218 = "models/items/furion/treant/eternalseasons_treant/eternalseasons_treant.vmdl",
	h219 = "models/items/courier/blue_lightning_horse/blue_lightning_horse.vmdl",
	h220 = "models/items/courier/waldi_the_faithful/waldi_the_faithful.vmdl",
	h221 = "models/items/courier/bajie_pig/bajie_pig.vmdl",
	h222 = "models/items/courier/courier_faun/courier_faun.vmdl",
	h223 = "models/items/courier/livery_llama_courier/livery_llama_courier.vmdl",
	h224 = "models/items/courier/onibi_lvl_10/onibi_lvl_10.vmdl",
	h225 = "models/items/courier/little_fraid_the_courier_of_simons_retribution/little_fraid_the_courier_of_simons_retribution.vmdl", --胆小南瓜人
	h226 = "models/items/courier/hermit_crab/hermit_crab.vmdl", --螃蟹1
	h227 = "models/items/courier/hermit_crab/hermit_crab_boot.vmdl", --螃蟹2
	h228 = "models/items/courier/hermit_crab/hermit_crab_shield.vmdl", --螃蟹3


	--珍藏信使 pro
	h301 = "models/items/courier/bookwyrm/bookwyrm.vmdl",
	h302 = "models/items/courier/captain_bamboo/captain_bamboo.vmdl",
	h303 = "models/items/courier/kanyu_shark/kanyu_shark.vmdl",
	h304 = "models/items/courier/tory_the_sky_guardian/tory_the_sky_guardian.vmdl",
	h305 = "models/items/courier/shroomy/shroomy.vmdl",
	h306 = "models/items/courier/courier_janjou/courier_janjou.vmdl",
	h307 = "models/items/courier/green_jade_dragon/green_jade_dragon.vmdl",
	h308 = "models/courier/drodo/drodo.vmdl",
	h309 = "models/courier/mech_donkey/mech_donkey.vmdl",

	h310 = "models/courier/donkey_crummy_wizard_2014/donkey_crummy_wizard_2014.vmdl",
	h311 = "models/courier/octopus/octopus.vmdl",
	h312 = "models/items/courier/scribbinsthescarab/scribbinsthescarab.vmdl",
	h313 = "models/courier/defense3_sheep/defense3_sheep.vmdl",
	h314 = "models/items/courier/snapjaw/snapjaw.vmdl",
	h315 = "models/items/courier/g1_courier/g1_courier.vmdl",
	h316 = "models/courier/donkey_trio/mesh/donkey_trio.vmdl",
	h317 = "models/items/courier/boris_baumhauer/boris_baumhauer.vmdl",
	h318 = "models/courier/baby_rosh/babyroshan.vmdl",
	h319 = "models/items/courier/bearzky/bearzky.vmdl",
	h320 = "models/items/courier/defense4_radiant/defense4_radiant.vmdl",
	h321 = "models/items/courier/defense4_dire/defense4_dire.vmdl",
	h322 = "models/items/courier/onibi_lvl_20/onibi_lvl_20.vmdl",
	h323 = "models/items/juggernaut/ward/fortunes_tout/fortunes_tout.vmdl", --招财猫
	h324 = "models/items/courier/hermit_crab/hermit_crab_necro.vmdl", --螃蟹4
	h325 = "models/items/courier/hermit_crab/hermit_crab_travelboot.vmdl", --螃蟹5
	h326 = "models/items/courier/hermit_crab/hermit_crab_lotus.vmdl", --螃蟹6
	h327 = "models/courier/donkey_ti7/donkey_ti7.vmdl",


	--战队信使 master
	h401 = "models/courier/navi_courier/navi_courier.vmdl",
	h402 = "models/items/courier/courier_mvp_redkita/courier_mvp_redkita.vmdl",
	h403 = "models/items/courier/ig_dragon/ig_dragon.vmdl",
	h404 = "models/items/courier/lgd_golden_skipper/lgd_golden_skipper.vmdl",
	h405 = "models/items/courier/vigilante_fox_red/vigilante_fox_red.vmdl",
	h406 = "models/items/courier/virtus_werebear_t3/virtus_werebear_t3.vmdl",
	h407 = "models/items/courier/throe/throe.vmdl",

	h408 = "models/items/courier/vaal_the_animated_constructradiant/vaal_the_animated_constructradiant.vmdl",
	h409 = "models/items/courier/vaal_the_animated_constructdire/vaal_the_animated_constructdire.vmdl",
	h410 = "models/items/courier/carty/carty.vmdl",
	h411 = "models/items/courier/carty_dire/carty_dire.vmdl",
	h412 = "models/items/courier/dc_angel/dc_angel.vmdl",
	h413 = "models/items/courier/dc_demon/dc_demon.vmdl",
	h414 = "models/items/courier/vigilante_fox_green/vigilante_fox_green.vmdl",
	h415 = "models/items/courier/bts_chirpy/bts_chirpy.vmdl",
	h416 = "models/items/courier/krobeling/krobeling.vmdl",
	h417 = "models/items/courier/jin_yin_black_fox/jin_yin_black_fox.vmdl",
	h418 = "models/items/courier/jin_yin_white_fox/jin_yin_white_fox.vmdl",
	h419 = "models/items/courier/fei_lian_blue/fei_lian_blue.vmdl",
	h420 = "models/items/courier/gama_brothers/gama_brothers.vmdl",
	h421 = "models/items/courier/onibi_lvl_21/onibi_lvl_21.vmdl",
	h422 = "models/items/courier/wabbit_the_mighty_courier_of_heroes/wabbit_the_mighty_courier_of_heroes.vmdl", --小飞侠
	h423 = "models/items/courier/hermit_crab/hermit_crab_octarine.vmdl", --螃蟹7
	h424 = "models/items/courier/hermit_crab/hermit_crab_skady.vmdl", --螃蟹8
	h425 = "models/items/courier/hermit_crab/hermit_crab_aegis.vmdl", --螃蟹9

	h499 = "models/items/courier/krobeling_gold/krobeling_gold_flying.vmdl",--金dp

	h444 = "models/props_gameplay/donkey.vmdl", 
}

GameRules.is_crazy = false

GameRules.heroindex = {}
userid2player = {}
isConnected = {}

GameRules.gem_difficulty = {
	[1] = 0.6,
	[2] = 2.0,
	[3] = 4.2,
	[4] = 5.6
}

GameRules.gem_difficulty_speed = {
	[1] = 0.85,
	[2] = 1.15,
	[3] = 1.36,
	[4] = 1.58
}

GameRules.gem_path_show = {}
GameRules.table_bubbles = {}

GameRules.gem_boss_damage_all = 0
GameRules.is_boss_entered = false

GameRules.kills = 0

GameRules.default_stone = {
	[1] = {
		[1] = { x = 1, y = 19 },
		[2] = { x = 2, y = 19 },
		[3] = { x = 3, y = 19 },
		[4] = { x = 4, y = 19 },
		[5] = { x = 37, y = 19 },
		[6] = { x = 36, y = 19 },
		[7] = { x = 35, y = 19 },
		[8] = { x = 34, y = 19 },
		[9] = { x = 19, y = 1 },
		[10] = { x = 19, y = 2 },
		[11] = { x = 19, y = 3 },
		[12] = { x = 19, y = 4 },
		[13] = { x = 19, y = 37 },
		[14] = { x = 19, y = 36 },
		[15] = { x = 19, y = 35 },
		[16] = { x = 19, y = 34 },
		[17] = { x = 6, y = 19 },
		[18] = { x = 7, y = 19 },
		[19] = { x = 8, y = 19 },
		[20] = { x = 9, y = 19 },
		[21] = { x = 32, y = 19 },
		[22] = { x = 31, y = 19 },
		[23] = { x = 30, y = 19 },
		[24] = { x = 29, y = 19 },
		[25] = { x = 19, y = 6 },
		[26] = { x = 19, y = 7 },
		[27] = { x = 19, y = 8 },
		[28] = { x = 19, y = 9 },
		[29] = { x = 19, y = 32 },
		[30] = { x = 19, y = 31 },
		[31] = { x = 19, y = 30 },
		[32] = { x = 19, y = 29 }
	},
	[2] = {
		[1] = { x = 1, y = 19 },
		[2] = { x = 2, y = 19 },
		[3] = { x = 3, y = 19 },
		[4] = { x = 4, y = 19 },
		[5] = { x = 37, y = 19 },
		[6] = { x = 36, y = 19 },
		[7] = { x = 35, y = 19 },
		[8] = { x = 34, y = 19 },
		[9] = { x = 19, y = 1 },
		[10] = { x = 19, y = 2 },
		[11] = { x = 19, y = 3 },
		[12] = { x = 19, y = 4 },
		[13] = { x = 19, y = 37 },
		[14] = { x = 19, y = 36 },
		[15] = { x = 19, y = 35 },
		[16] = { x = 19, y = 34 }
	},
	[3] = {
		[1] = { x = 1, y = 19 },
		[2] = { x = 2, y = 19 },
		[3] = { x = 37, y = 19 },
		[4] = { x = 36, y = 19 },
		[5] = { x = 19, y = 1 },
		[6] = { x = 19, y = 2 },
		[7] = { x = 19, y = 37 },
		[8] = { x = 19, y = 36 },
	},
	[4] = {}
}


GameRules.is_default_builded = false

GameRules.gem_nandu = 0

GameRules.is_debug = false

GameRules.gem_path = {
	{},{},{},{},{},{}
}
GameRules.gem_path_all = {}
GameRules.gem_path_speed = { {{},{},{},{},{},{}}, {{},{},{},{},{},{}}, {{},{},{},{},{},{}}, {{},{},{},{},{},{}}}
GameRules.gem_path_all_speed = {{},{},{},{}}


GameRules.game_status = 0   --0 = 准备时间, 1 = 建造时间, 2 = 刷怪时间

GameRules.start_level = 1
GameRules.level = GameRules.start_level
GameRules.level_speed = {GameRules.start_level, GameRules.start_level, GameRules.start_level, GameRules.start_level}
GameRules.gem_is_shuaguaiing = false
GameRules.gem_is_shuaguaiing_speed = {false,false,false,false}
GameRules.guai_count = 10
GameRules.guai_count_speed = {10,10,10,10}
GameRules.guai_live_count = 0
GameRules.guai_live_count_speed = {0,0,0,0}
GameRules.gemtd_pool_can_merge_all = {}

GameRules.gem_player_count = 0
GameRules.gem_hero_count = 0
GameRules.gem_maze_length = 0
GameRules.gem_maze_length_speed = {0,0,0,0}
GameRules.team_gold = 0
GameRules.gem_swap = {}
GameRules.damage = {}
GameRules.is_passed = false

GameRules.is_cheat = false
GameRules.check_cheat_interval = 5

GameRules.max_xy = 40
GameRules.max_grids = GameRules.max_xy * GameRules.max_xy
GameRules.start_time = 0
GameRules.random_seed_levels = 1
GameRules.online_player_count = 0

GameRules.guai = {
	[1] = "gemtd_kuangbaoyezhu",
	[2] = "gemtd_kuaidiqingwatiaotiao",
	[3] = "gemtd_zhongchenggaoshanmaoniu",
	[4] = "gemtd_moluokedejixiezhushou",
	[5] = "gemtd_wuweizhihuan_fly",
	[105] = "gemtd_xiaohongmao_fly",
	[6] = "gemtd_shudunziranzhizhu",
	[7] = "gemtd_chaomengjuxi",
	[8] = "gemtd_mengzhu",
	[9] = "gemtd_dashiqi",
	[10] = "gemtd_buquzhanquan_boss",
	[11] = "gemtd_maorongrongdefeiyangyang",
	[12] = "gemtd_caonimalama",
	[13] = "gemtd_fengtungongzhu",
	[14] = "gemtd_bugou",
	[15] = "gemtd_banzhuduizhang_fly",
	[115] = "gemtd_tianmaodigou_fly",
	[16] = "gemtd_xunjiemotong",
	[17] = "gemtd_yonggandexiaoji",
	[18] = "gemtd_xiaobajie",
	[19] = "gemtd_shentu",
	[119] = "gemtd_yaobaidelvgemi",
	[20] = "gemtd_huxiaotao_boss",
	[21] = "gemtd_siwangsiliezhe",
	[121] = "gemtd_xiexiaowo",
	[22] = "gemtd_yaorenxiangluoke",
	[23] = "gemtd_tiezuiyaorenxiang",
	[123] = "gemtd_dazuiyaorenxiang",
	[24] = "gemtd_jixieyaorenxiang",
	[124] = "gemtd_jixiezhanlv",
	[25] = "gemtd_fengbaozhizikesaier_fly",
	[125] = "gemtd_huoxingche_fly",
	[26] = "gemtd_niepanhuolieniao",
	[27] = "gemtd_lgddejinmengmeng_fly",
	[127] = "gemtd_ruxingshuimu_fly",
	[28] = "gemtd_youniekesizhinu_fly",
	[128] = "gemtd_xiaofamuji_fly",
	[29] = "gemtd_feihuxia_fly",
	[129] = "gemtd_yingwuchuanfu_fly",
	[30] = "gemtd_mofafeitanxiaoemo_boss_fly",
	[31] = "gemtd_modianxiaolong",
	[131] = "gemtd_talongaosiji",
	[32] = "gemtd_xiaoshayu",
	[33] = "gemtd_feijiangxiaobao",
	[133] = "gemtd_siwangxianzhi",
	[34] = "gemtd_shangjinbaobao_fly",
	[134] = "gemtd_xuemobaobao_fly",
	[35] = "gemtd_jinyinhuling_fly",
	[36] = "gemtd_cuihua",
	[37] = "gemtd_xiaobaihu",
	[38] = "gemtd_xiaoxingyue",
	[39] = "gemtd_liangqiyuhai_fly",
	[139] = "gemtd_fennenrongyuan_fly",
	[40] = "gemtd_guixiaoxieling_boss_fly",
	[41] = "gemtd_weilanlong",
	[141] = "gemtd_cuiyuxiaolong",
	[42] = "gemtd_saodiekupu_fly",
	[43] = "gemtd_maomaoyu",
	[44] = "gemtd_xiaomogu",
	[45] = "gemtd_jiujiu_fly",
	--[46] = "gemtd_juniaoduoduo_tester"
	[46] = "gemtd_siwangxintu",
	[47] = "gemtd_jilamofashi",
	[147] = "gemtd_xunjieyuanzumaolv",
	[48] = "gemtd_xiaofeixia_fly",
	[148] = "gemtd_jiwanghaidao_fly",
	[49] = "gemtd_juniaoduoduo",
	[50] = "gemtd_roushan_boss_fly",
}
GameRules.guai_ability = {
	[1] = {},
	[2] = {},
	[3] = {},
	[4] = {},
	[5] = {},
	[6] = {},
	[7] = {},
	[8] = {},
	[9] = {"guai_shanbi"},
	[10] ={},
	[11] = {},
	[12] = {"guai_jiaoxieguanghuan"},
	[13] = {},
	[14] = {"enemy_zheguang"},
	[15] = {},
	[16] = {},
	[17] = {"enemy_bukeqinfan"},
	[18] = {"guai_jiaoxieguanghuan"},
	[19] = {"enemy_shanshuo"},
	[20] = {},
	[21] = {},
	[22] = {"enemy_high_armor"},
	[23] = {"enemy_zheguang"},
	[24] = {"shredder_reactive_armor"},
	[25] = {"enemy_high_armor"},
	[26] = {},
	[27] = {"enemy_bukeqinfan"},
	[28] = {"shredder_reactive_armor"},
	[29] = {"guai_shanbi","enemy_zheguang"},
	[30] = {},
	[31] = {"enemy_zheguang"},
	[32] = {"enemy_recharge"},
	[33] = {"enemy_shanshuo"},
	[34] = {"guai_shanbi"},
	[35] = {},
	[36] = {},
	[37] = {"enemy_shanshuo"},
	[38] = {"guai_jiaoxieguanghuan"},
	[39] = {"enemy_bukeqinfan","tidehunter_kraken_shell","guai_shanbi"},
	[40] = {"tidehunter_kraken_shell"},
	[41] = {"enemy_zheguang"},
	[42] = {},
	[43] = {"enemy_bukeqinfan","guai_shanbi","enemy_recharge"},
	[44] = {"enemy_shanshuo"},
	[45] = {"guai_jiaoxieguanghuan"},
	[46] = {},
	[47] = {"enemy_bukeqinfan","enemy_shanshuo"},
	[48] = {"guai_jiaoxieguanghuan","guai_shanbi"},
	[49] = {"tidehunter_kraken_shell","enemy_recharge"},
	[50] = {"tidehunter_kraken_shell"},
}

GameRules.guai_50_ability = {
	"enemy_bukeqinfan",
	"guai_shanbi",
	"guai_jiaoxieguanghuan",
	"shredder_reactive_armor",
	"enemy_recharge",
	"riki_permanent_invisibility",
	"tidehunter_kraken_shell",
	"enemy_wumian",
	"enemy_momian",
	"enemy_zheguang",
	"enemy_shanshuo",
}

--合成配方
GameRules.gemtd_merge = {
	--初级塔
	gemtd_baiyin = { "gemtd_b1", "gemtd_y1", "gemtd_d1" },
	gemtd_kongqueshi = { "gemtd_e1", "gemtd_q1", "gemtd_g1" },
	gemtd_xingcaihongbaoshi = { "gemtd_r11", "gemtd_r1", "gemtd_p1" },
	gemtd_yu = { "gemtd_g111", "gemtd_e111", "gemtd_b11" },
	gemtd_furongshi = { "gemtd_g1111", "gemtd_r111", "gemtd_p11" },

	--中级塔
	gemtd_heianfeicui = { "gemtd_g11111", "gemtd_b1111", "gemtd_y11"  },
	gemtd_huangcailanbaoshi = { "gemtd_b11111", "gemtd_y1111", "gemtd_r1111"  },
	gemtd_palayibabixi = { "gemtd_q11111", "gemtd_e1111", "gemtd_g11" },
	gemtd_heisemaoyanshi = { "gemtd_e11111", "gemtd_d1111", "gemtd_q111"  },
	gemtd_jin = { "gemtd_p11111", "gemtd_p1111", "gemtd_d11"  },
	gemtd_fenhongzuanshi = { "gemtd_d11111", "gemtd_y111", "gemtd_d111"  },
	gemtd_jixueshi = { "gemtd_r11111", "gemtd_q1111", "gemtd_p111" },
	gemtd_you238 = { "gemtd_y11111", "gemtd_e11", "gemtd_b111" },
	gemtd_baiyinqishi = { "gemtd_baiyin", "gemtd_q11", "gemtd_r111" },
	gemtd_xianyandekongqueshi = { "gemtd_kongqueshi", "gemtd_d11", "gemtd_y111" },
	gemtd_xuehonghuoshan = { "gemtd_xingcaihongbaoshi", "gemtd_r1111", "gemtd_p111" },
	gemtd_shenhaizhenzhu = { "gemtd_q1111", "gemtd_d1111", "gemtd_e11" },
	gemtd_haiyangqingyu = { "gemtd_yu", "gemtd_b1111", "gemtd_q111" },
	
	--高级塔
	gemtd_jixiangdezhongguoyu = { "gemtd_yu", "gemtd_furongshi", "gemtd_g111" },
	gemtd_juxingfenhongzuanshi = { "gemtd_fenhongzuanshi", "gemtd_baiyinqishi", "gemtd_baiyin" },
	gemtd_you235 = { "gemtd_you238", "gemtd_xianyandekongqueshi", "gemtd_kongqueshi" },
	gemtd_jingxindiaozhuodepalayibabixi = { "gemtd_palayibabixi", "gemtd_heianfeicui", "gemtd_g11" },
	gemtd_gudaidejixueshi = { "gemtd_jixueshi", "gemtd_xuehonghuoshan", "gemtd_r11" },
	gemtd_mirendeqingjinshi = { "gemtd_furongshi", "gemtd_p1111", "gemtd_y11" },
	gemtd_aijijin = { "gemtd_jin", "gemtd_p11111", "gemtd_q11" },
	gemtd_hongshanhu = { "gemtd_heisemaoyanshi", "gemtd_shenhaizhenzhu", "gemtd_e1111" },
	gemtd_feicuimoxiang = { "gemtd_jin", "gemtd_heianfeicui", "gemtd_d111" },
	gemtd_huaguoshanxiandan = { "gemtd_haiyangqingyu", "gemtd_g1111", "gemtd_p11" },
	gemtd_tianranzumulv = { "gemtd_shenhaizhenzhu","gemtd_g11111","gemtd_d111" },
	gemtd_haibao = { "gemtd_huangcailanbaoshi","gemtd_jixueshi","gemtd_b11111" },

	--超级塔
	gemtd_keyinuoerguangmingzhishan = { "gemtd_juxingfenhongzuanshi","gemtd_p111111","gemtd_d111111" },
	gemtd_shuaibiankaipayou = { "gemtd_you235","gemtd_q111111","gemtd_y111111" },
	gemtd_heiwangzihuangguanhongbaoshi = { "gemtd_gudaidejixueshi","gemtd_r111111","gemtd_g111111" },
	gemtd_xingguanglanbaoshi = { "gemtd_huangcailanbaoshi","gemtd_b111111","gemtd_e111111" },
	gemtd_yijiazhishi = { "gemtd_hongshanhu","gemtd_e111111","gemtd_q111111" },
	gemtd_huguoshenyishi = { "gemtd_mirendeqingjinshi","gemtd_y111111","gemtd_r111111" },
	gemtd_jingangshikulinan = { "gemtd_huaguoshanxiandan","gemtd_d111111","gemtd_b111111" },
	gemtd_sililankazhixing = { "gemtd_jingxindiaozhuodepalayibabixi","gemtd_g111111","gemtd_p111111" },
}
GameRules.gemtd_merge_secret = {
	--8个home
	gemtd_keyinuoerguangmingzhishan = { "gemtd_p1", "gemtd_p11", "gemtd_p111", "gemtd_p1111", "gemtd_p11111" },
	gemtd_shuaibiankaipayou = { "gemtd_q1", "gemtd_q11", "gemtd_q111", "gemtd_q1111", "gemtd_q11111" },
	gemtd_heiwangzihuangguanhongbaoshi = { "gemtd_r1", "gemtd_r11", "gemtd_r111", "gemtd_r1111", "gemtd_r11111" },
	gemtd_xingguanglanbaoshi = { "gemtd_b1", "gemtd_b11", "gemtd_b111", "gemtd_b1111", "gemtd_b11111" },
	gemtd_yijiazhishi = { "gemtd_e1", "gemtd_e11", "gemtd_e111", "gemtd_e1111", "gemtd_e11111" },
	gemtd_huguoshenyishi = { "gemtd_y1", "gemtd_y11", "gemtd_y111", "gemtd_y1111", "gemtd_y11111" },
	gemtd_jingangshikulinan = { "gemtd_d1", "gemtd_d11", "gemtd_d111", "gemtd_d1111", "gemtd_d11111" },
	gemtd_sililankazhixing = { "gemtd_g1", "gemtd_g11", "gemtd_g111", "gemtd_g1111", "gemtd_g11111" },
	--其他
	gemtd_heiyaoshi = { "gemtd_b11111", "gemtd_y11111", "gemtd_d11111" },
	gemtd_manao = { "gemtd_q11111", "gemtd_e11111", "gemtd_g11111" },
	gemtd_ranshaozhishi = { "gemtd_r11111", "gemtd_p11111", "gemtd_r1111", "gemtd_p1111" },
	gemtd_xiameishi = { "gemtd_r11111", "gemtd_g11111", "gemtd_b11111" },
	gemtd_geluanshi = { "gemtd_g11111", "gemtd_r11111", "gemtd_p11111" },
}
GameRules.gemtd_merge_shiban = {
	gemtd_youbushiban = { "gemtd_y111", "gemtd_d11" }, --诱捕石板√
	gemtd_zhangqishiban = { "gemtd_g111", "gemtd_e11" }, --瘴气石板√
	gemtd_hongliushiban = { "gemtd_b111", "gemtd_q11" }, --洪流石板√

	gemtd_haojiaoshiban = { "gemtd_p111", "gemtd_r11" }, --嗥叫石板(狼人技能，给周围塔+25%攻)
	-- gemtd_feidanshiban = { "gemtd_d111", "gemtd_p11" }, --飞弹石板(飞机的大招)
	-- gemtd_bingfengshiban = { "gemtd_e111", "gemtd_b11" }, --冰封石板(双头龙冰封路径)
	gemtd_suanwushiban = { "gemtd_q111", "gemtd_y11" }, --酸雾石板(炼金酸雾)
	gemtd_mabishiban = { "gemtd_r111", "gemtd_g11" }, --麻痹石板(巫医麻痹药剂)
}
GameRules.gem_gailv = {
	[1] = { },
	[2] = { [80] = "11" },
	[3] = { [60] = "11", [90] = "111" },
	[4] = { [40] = "11", [70] = "111", [90] = "1111" },
	[5] = { [10] = "11", [40] = "111", [70] = "1111", [90] = "11111" }
}
GameRules.gem_tower_basic = {
	[1] = "gemtd_b",
	[2] = "gemtd_d",
	[3] = "gemtd_q",
	[4] = "gemtd_e",
	[5] = "gemtd_g",
	[6] = "gemtd_y",
	[7] = "gemtd_r",
	[8] = "gemtd_p"
}

GameRules.pray_gailv = {
	[1] = 40,
	[2] = 55,
	[3] = 65,
	[4] = 70,
}

-- GameRules.gem_tower_basic = {
-- 	[1] = "gemtd_heisemaoyanshi",
-- 	[2] = "gemtd_shenhaizhenzhu",
-- 	[3] = "gemtd_e1111",
-- }
GameRules.gemtd_pool = {}
GameRules.gemtd_pool_can_merge = {}
GameRules.gemtd_pool_can_merge_1 = {
	[0] = {},
	[1] = {},
	[2] = {},
	[3] = {}
}
GameRules.gemtd_pool_can_merge_shiban = {
	[0] = {},
	[1] = {},
	[2] = {},
	[3] = {}
}
GameRules.build_index = {
	[0] = 0,
	[1] = 0,
	[2] = 0,
	[3] = 0
}
GameRules.build_curr = {
	[0] = {},
	[1] = {},
	[2] = {},
	[3] = {}
}
playerInfoReceived = {}
GameRules.replced = {
	[0] = false, 
	[1] = false, 
	[2] = false, 
	[3] = false
}


--预加载游戏资源
function Precache( context )
	-- --[[
	-- 	Precache things we know we'll use.  Possible file types include (but not limited to):
	-- 		PrecacheResource( "model", "*.vmdl", context )
	-- 		PrecacheResource( "soundfile", "*.vsndevts", context )
	-- 		PrecacheResource( "particle", "*.vpcf", context )
	-- 		PrecacheResource( "particle_folder", "particles/folder", context )
	-- ]]
	local zr={
		"models/courier/mighty_boar/mighty_boar.vmdl",
		"models/props_stone/stone_column001a.vmdl",
		"models/props_gameplay/heart001.vmdl",
		"models/props_structures/good_barracks_melee002.vmdl",
		"models/courier/frog/frog.vmdl",
		"models/courier/yak/yak.vmdl",
		"models/props_debris/riveredge_rocks_small001_snow.vmdl",
		"particles/econ/events/snowball/snowball_projectile.vpcf",
		"models/particle/ice_shards.vmdl",
		"models/props_debris/candles003.vmdl",
		"particles/units/heroes/hero_jakiro/jakiro_base_attack_fire.vpcf",
		"models/props_destruction/lava_flow_clump.vmdl",
		"particles/units/heroes/hero_templar_assassin/templar_assassin_base_attack.vpcf",
		"particles/units/heroes/hero_lina/lina_base_attack.vpcf",
		"models/particle/green_rocks.vmdl",
		"particles/units/heroes/hero_phoenix/phoenix_base_attack.vpcf",
		"particles/base_attacks/ranged_goodguy_trail.vpcf",
		"models/particle/snowball.vmdl",
		"models/particle/skull.vmdl",
		"models/particle/sealife.vmdl",
		"models/particle/tormented_spike.vmdl",
		"models/props_mines/mine_tool_plate001.vmdl",
		"models/props_magic/bad_crystals002.vmdl",
		"models/props_nature/lily_flower00.vmdl",
		"models/buildings/building_racks_melee_reference.vmdl",
		"particles/units/heroes/hero_leshrac/leshrac_base_attack.vpcf",
		"particles/units/heroes/hero_vengeful/vengeful_base_attack.vpcf",
		"particles/units/heroes/hero_venomancer/venomancer_base_attack.vpcf",
		"models/props_winter/egg.vmdl",
		"models/items/wards/tide_bottom_watcher/tide_bottom_watcher.vmdl",
		"models/items/wards/skywrath_sentinel/skywrath_sentinel.vmdl",
		"models/items/wards/fairy_dragon/fairy_dragon.vmdl",
		"models/items/wards/echo_bat_ward/echo_bat_ward.vmdl",
		"models/items/wards/esl_wardchest_four_armed_observer/esl_wardchest_four_armed_observer.vmdl",
		"models/items/wards/crystal_maiden_ward/crystal_maiden_ward.vmdl",
		"models/items/wards/esl_wardchest_jungleworm_sentinel/esl_wardchest_jungleworm_sentinel.vmdl",
		"models/items/wards/jinnie_v2/jinnie_v2.vmdl",
		"models/items/wards/venomancer_ward/venomancer_ward.vmdl",
		"models/items/wards/frozen_formation/frozen_formation.vmdl",
		"models/items/wards/deep_observer/deep_observer.vmdl",
		"models/items/wards/eyeofforesight/eyeofforesight.vmdl",
		"models/courier/courier_mech/courier_mech.vmdl",
		"models/courier/badger/courier_badger_flying.vmdl",
		"particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_explosion_white_b_arcana1.vpcf",
		"particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_3.vpcf",
		"models/items/wards/esl_wardchest_ward_of_foresight/esl_wardchest_ward_of_foresight.vmdl",
		"models/items/wards/esl_wardchest_rockshell_terrapin/esl_wardchest_rockshell_terrapin.vmdl",
		"particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf",
		"models/courier/tegu/tegu.vmdl",
		"models/courier/stump/stump.vmdl",
		"models/items/courier/itsy/itsy.vmdl",
		"models/items/courier/duskie/duskie.vmdl",
		"models/courier/juggernaut_dog/juggernaut_dog.vmdl",
		"models/items/wards/deadwatch_ward/deadwatch_ward.vmdl",
		"models/items/wards/enchantedvision_ward/enchantedvision_ward.vmdl",
		"models/items/wards/esl_wardchest_sibling_spotter/esl_wardchest_sibling_spotter.vmdl",
		"models/courier/defense3_sheep/defense3_sheep.vmdl",
		"models/items/courier/livery_llama_courier/livery_llama_courier.vmdl",
		"models/items/courier/gnomepig/gnomepig.vmdl",
		"models/items/courier/butch_pudge_dog/butch_pudge_dog.vmdl",
		"models/items/courier/captain_bamboo/captain_bamboo_flying.vmdl",
		"models/courier/imp/imp.vmdl",
		"models/items/courier/mighty_chicken/mighty_chicken.vmdl",
		"models/items/courier/bajie_pig/bajie_pig.vmdl",
		"models/items/courier/arneyb_rabbit/arneyb_rabbit.vmdl",
		"models/items/courier/shagbark/shagbark.vmdl",
		"particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf",
		"models/items/wards/d2lp_4_ward/d2lp_4_ward.vmdl",
		"models/items/wards/jakiro_pyrexae_ward/jakiro_pyrexae_ward.vmdl",
		"models/items/wards/esl_wardchest_radling_ward/esl_wardchest_radling_ward.vmdl",
		"models/items/wards/dragon_ward/dragon_ward.vmdl",
		"particles/units/heroes/hero_enchantress/enchantress_base_attack.vpcf",
		"particles/base_attacks/ranged_tower_good_glow_b.vpcf",
		"models/items/wards/gazing_idol_ward/gazing_idol_ward.vmdl",
		"models/items/wards/chinese_ward/chinese_ward.vmdl",
		"particles/units/heroes/hero_slardar/slardar_amp_damage.vpcf",
		"particles/econ/items/effigies/status_fx_effigies/base_statue_destruction_gold_model.vpcf",
		"particles/showcase_fx/showcase_fx_base_3_b.vpcf",
		"particles/items_fx/aura_shivas_ring.vpcf",
		"particles/hw_fx/gravehands_grab_1_ground.vpcf",
		"particles/econ/courier/courier_trail_winter_2012/courier_trail_winter_2012_drifts.vpcf",
		"particles/econ/items/lone_druid/lone_druid_cauldron/lone_druid_bear_entangle_ground_soil_cauldron.vpcf",
		"particles/econ/items/earthshaker/earthshaker_gravelmaw/earthshaker_fissure_ground_b_gravelmaw.vpcf",
		"particles/units/heroes/hero_tusk/tusk_ice_shards_ground_burst.vpcf",
		"particles/units/heroes/hero_omniknight/omniknight_degen_aura_b.vpcf",
		"particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff_circle.vpcf",
		"particles/units/heroes/hero_slardar/slardar_amp_damage.vpcf",
		"particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_status_ice.vpcf",
		"models/items/courier/deathripper/deathripper.vmdl",
		"models/courier/lockjaw/lockjaw.vmdl",
		"models/courier/trapjaw/trapjaw.vmdl",
		"models/courier/mechjaw/mechjaw.vmdl",
		"models/items/courier/corsair_ship/corsair_ship.vmdl",
		"models/items/courier/courier_mvp_redkita/courier_mvp_redkita.vmdl",
		"models/items/courier/lgd_golden_skipper/lgd_golden_skipper_flying.vmdl",
		"models/items/courier/ig_dragon/ig_dragon_flying.vmdl",
		"models/items/courier/vigilante_fox_red/vigilante_fox_red_flying.vmdl",
		"models/courier/drodo/drodo_flying.vmdl",
		"particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf",
		"models/items/wards/augurys_guardian/augurys_guardian.vmdl",
		"particles/neutral_fx/skeleton_spawn.vpcf",
		"particles/units/heroes/hero_earth_spirit/espirit_spawn_ground.vpcf",
		"particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_impact_moonfall.vpcf",
		"particles/econ/items/luna/luna_lucent_ti5_gold/luna_eclipse_impact_moonfall_gold.vpcf",
		"particles/radiant_fx/tower_good3_dest_beam.vpcf",
		"particles/units/unit_greevil/loot_greevil_death_spark_pnt.vpcf",
		"particles/units/unit_greevil/loot_greevil_death_spark_pnt.vpcf",
		"particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf",
		"models/items/wards/blood_seeker_ward/bloodseeker_ward.vmdl",
		"particles/units/heroes/hero_zuus/zuus_base_attack.vpcf",
		"models/items/wards/alliance_ward/alliance_ward.vmdl",
		"particles/units/heroes/hero_razor/razor_static_link_projectile_a.vpcf",
		"particles/econ/items/natures_prophet/natures_prophet_weapon_scythe_of_ice/natures_prophet_scythe_of_ice.vpcf",
		"particles/units/heroes/hero_tinker/tinker_laser.vpcf",
		"particles/gem/team_0.vpcf",
		"particles/unit_team/unit_team_player1.vpcf",
		"particles/unit_team/unit_team_player2.vpcf",
		"particles/unit_team/unit_team_player3.vpcf",
		"particles/unit_team/unit_team_player4.vpcf",
		"particles/unit_team/unit_team_player0_a.vpcf",
		"particles/unit_team/unit_team_player1_a.vpcf",
		"particles/unit_team/unit_team_player2_a.vpcf",
		"particles/unit_team/unit_team_player3_a.vpcf",
		"particles/unit_team/unit_team_player4_a.vpcf",
		"models/items/wards/esl_wardchest_living_overgrowth/esl_wardchest_living_overgrowth.vmdl",
		"models/items/wards/mothers_eye/mothers_eye.vmdl",
		"models/items/wards/esl_one_jagged_vision/esl_one_jagged_vision.vmdl",
		"particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt_birds.vpcf",
		"particles/units/heroes/hero_phoenix/phoenix_sunray_tgt.vpcf",
		"models/items/wards/jakiro_pyrexae_ward/jakiro_pyrexae_ward.vmdl",
		"particles/units/heroes/hero_phoenix/phoenix_supernova_scepter_f.vpcf",
		"particles/tinker_laser2.vpcf",
		"models/items/wards/jimoward_omij/jimoward_omij.vmdl",
		"models/items/courier/corsair_ship/corsair_ship_flying.vmdl",
		"particles/items3_fx/star_emblem_brokenshield_caster.vpcf",
		"models/props_gameplay/heart001.vmdl",
		"soundevents/hehe.vsndevts",
		"models/items/wards/tink/tink.vmdl",
		"models/items/wards/warding_guise/warding_guise.vmdl",
		"models/courier/smeevil_magic_carpet/smeevil_magic_carpet_flying.vmdl",
		"models/items/courier/bookwyrm/bookwyrm.vmdl",
		"models/items/courier/kanyu_shark/kanyu_shark.vmdl",
		"models/items/courier/pw_zombie/pw_zombie.vmdl",
		"models/courier/huntling/huntling_flying.vmdl",
		"particles/kunkka_hehe.vpcf",
		"models/items/courier/jin_yin_black_fox/jin_yin_black_fox_flying.vmdl",
		"models/items/courier/jin_yin_white_fox/jin_yin_white_fox_flying.vmdl",
		"particles/units/heroes/hero_lion/lion_spell_mana_drain.vpcf",
		"particles/units/heroes/hero_pugna/pugna_life_drain.vpcf",
		"particles/units/heroes/hero_wisp/wisp_tether.vpcf",
		"models/items/courier/mei_nei_rabbit/mei_nei_rabbit_flying.vmdl",
		"models/items/courier/gama_brothers/gama_brothers_flying.vmdl",
		"models/courier/smeevil_mammoth/smeevil_mammoth_flying.vmdl",
		"models/items/courier/baekho/baekho.vmdl", 
		"models/items/courier/green_jade_dragon/green_jade_dragon_flying.vmdl", --翠玉小龙
		"models/items/courier/jumo/jumo.vmdl", 
		"models/items/courier/jumo_dire/jumo_dire.vmdl", 
		"models/items/courier/lilnova/lilnova.vmdl", 
		"models/items/courier/blue_lightning_horse/blue_lightning_horse.vmdl",  --蔚蓝之霆
		"models/items/courier/amphibian_kid/amphibian_kid_flying.vmdl",   --两栖鱼孩
		"models/items/wards/chicken_hut_ward/chicken_hut_ward.vmdl",
		"models/courier/greevil/gold_greevil_flying.vmdl",
		"models/items/courier/g1_courier/g1_courier_flying.vmdl",
		"models/items/courier/boooofus_courier/boooofus_courier_flying.vmdl",
		"models/items/courier/mlg_courier_wraith/mlg_courier_wraith_flying.vmdl",
		"particles/units/heroes/hero_shadowshaman/shadowshaman_ether_shock.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_shadowshaman.vsndevts",
		"particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf",
		"particles/items_fx/desolator_projectile.vpcf",
		"particles/units/heroes/hero_enchantress/enchantress_untouchable.vpcf",
		"models/items/wards/knightstatue_ward/knightstatue_ward.vmdl",
		"particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts",
		"particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost_explosion.vpcf",
		"models/props_structures/pumpkin003.vmdl",
		"models/props_gameplay/pumpkin_bucket.vmdl",
		"models/items/courier/pumpkin_courier/pumpkin_courier_flying.vmdl",
		"particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf",
		"sounds/weapons/hero/abaddon/borrowed_time.vsnd",
		"particles/units/heroes/hero_phantom_assassin/guai_shanbi.vpcf",
		"models/items/wards/f2p_ward/f2p_ward.vmdl",
		"models/items/wards/fairy_dragon/fairy_dragon.vmdl",
		"particles/econ/items/puck/puck_alliance_set/puck_base_attack_aproset.vpcf",
		"particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_casterribbons_arcana1.vpcf",
		"models/props_teams/logo_dire_fall_medium.vmdl",
		"models/props_teams/logo_radiant_medium.vmdl",
		"models/props/traps/spiketrap/spiketrap.vmdl",
		"models/items/courier/azuremircourierfinal/azuremircourierfinal.vmdl",
		"models/items/courier/kupu_courier/kupu_courier_flying.vmdl",
		"models/items/wards/esl_wardchest_jungleworm/esl_wardchest_jungleworm.vmdl",
		"models/items/wards/esl_wardchest_direling_ward/esl_wardchest_direling_ward.vmdl",
		"particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf",
		"particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_ambient_crystal_chorus_magic.vpcf",
		"models/items/courier/basim/basim_flying.vmdl",
		"models/props_teams/logo_radiant_winter_medium.vmdl",
		"models/creeps/nian/nian_creep.vmdl",
		"models/items/courier/mok/mok_flying.vmdl",
		"particles/units/heroes/hero_ogre_magi/ogre_magi_unr_fireblast.vpcf",
		"particles/units/heroes/hero_ogre_magi/ogre_magi_unr_fireblast_ring_fire.vpcf",
		"particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf",
    	"particles/gem/screen_arcane_drop.vpcf",
    	"particles/gem/immunity_sphere_buff.vpcf",
    	"particles/gem/immunity_sphere.vpcf",
    	"particles/gem/omniknight_guardian_angel_wings_buff.vpcf",
    	"particles/generic_gameplay/screen_damage_indicator.vpcf",
    	"particles/generic_gameplay/screen_arcane_drop.vpcf",
    	"particles/items2_fx/refresher.vpcf",
    	"particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf",
    	"particles/units/heroes/hero_medusa/medusa_base_attack.vpcf",
    	"particles/units/heroes/hero_silencer/silencer_base_attack.vpcf",
    	"particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf",
    	"models/props_debris/shop_set_seat001.vmdl",
    	"particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_sphere_final_explosion_smoke_ti5.vpcf",
    	"particles/units/heroes/hero_siren/naga_siren_portrait.vpcf",
    	"particles/units/heroes/hero_chen/chen_teleport.vpcf",
    	"particles/units/heroes/hero_chen/chen_teleport_flash_main.vpcf",
    	"particles/radiant_fx/radiant_tower002_destruction_a2.vpcf",
    	"particles/generic_gameplay/screen_damage_indicator.vpcf",
    	"models/items/wards/sea_dogs_watcher/sea_dogs_watcher.vmdl",
    	"models/items/wards/portal_ward/portal_ward.vmdl",
    	"particles/units/heroes/hero_stormspirit/stormspirit_electric_vortex_debuff.vpcf",
    	"models/items/courier/coral_furryfish/coral_furryfish.vmdl",
    	"models/items/courier/shroomy/shroomy.vmdl",
    	"models/items/courier/bts_chirpy/bts_chirpy_flying.vmdl",
    	"models/items/courier/boris_baumhauer/boris_baumhauer_flying.vmdl",
    	"models/items/courier/green_jade_dragon/green_jade_dragon.vmdl",
    	"models/courier/mech_donkey/mech_donkey.vmdl",
    	"models/items/wards/esl_wardchest_toadstool/esl_wardchest_toadstool.vmdl",
    	"models/courier/flopjaw/flopjaw.vmdl",
    	"models/courier/donkey_trio/mesh/donkey_trio.vmdl",
    	"models/items/courier/carty/carty_flying.vmdl",
    	"models/items/courier/axolotl/axolotl_flying.vmdl",
    	"models/courier/seekling/seekling_flying.vmdl",
    	"models/items/courier/shibe_dog_cat/shibe_dog_cat_flying.vmdl",
    	"models/items/courier/krobeling/krobeling.vmdl",
    	"models/items/courier/snaggletooth_red_panda/snaggletooth_red_panda_flying.vmdl",
    	"particles/items2_fx/refresher.vpcf",
    	"particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf",
    	"models/items/wards/phoenix_ward/phoenix_ward.vmdl",
    	"particles/econ/items/enchantress/enchantress_virgas/ench_impetus_virgas.vpcf",
    	"sm/2014.vpcf",
    	"particles/econ/courier/courier_trail_divine/courier_divine_ambient.vpcf",
    	"sm/ruby.vpcf",
    	"particles/econ/courier/courier_trail_fireworks/courier_trail_fireworks.vpcf",
    	"particles/econ/courier/courier_crystal_rift/courier_ambient_crystal_rift.vpcf",
    	"particles/econ/courier/courier_trail_cursed/courier_cursed_ambient.vpcf",
    	"particles/econ/courier/courier_trail_04/courier_trail_04.vpcf",
    	"particles/econ/courier/courier_trail_hw_2012/courier_trail_hw_2012.vpcf",
    	"particles/econ/courier/courier_trail_hw_2013/courier_trail_hw_2013.vpcf",
    	"particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf",
    	"particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf",
    	"particles/econ/courier/courier_polycount_01/courier_trail_polycount_01.vpcf",
    	"particles/econ/wards/bane/bane_ward/bane_ward_ambient.vpcf",
    	"sm/mogu.vpcf",
    	"sm/2012trail_international_2012.vpcf",
    	"sm/2013.vpcf",
    	"particles/econ/courier/courier_trail_05/courier_trail_05.vpcf",
    	"sm/ambient.vpcf",
    	"particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_arcana_ground_ambient.vpcf",
    	"sm/grass/03.vpcf",
    	"sm/lianhua.vpcf",
    	"sm/bingxueecon/courier/courier_trail_winter_2012/courier_trail_winter_2012.vpcf",
    	"particles/econ/courier/courier_trail_lava/courier_trail_lava.vpcf",
    	"sm/rongyanroushan.vpcf",
    	"sm/bingroushan.vpcf",
    	"sm/jinroushanambient.vpcf",
    	"sm/lizizhiqiambient.vpcf",
    	"particles/econ/courier/courier_trail_earth/courier_trail_earth.vpcf",
    	"sm/hapi.vpcf",
    	"sm/baoshiguangze.vpcf",
    	"particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_snow_b_arcana1.vpcf",
    	"sm/nihonghudieblue.vpcf",
    	"particles/econ/events/ti6/radiance_owner_ti6.vpcf",
    	"particles/econ/events/ti6/fountain_regen_ribbon_lvl3_a.vpcf",
    	"sm/xianqichanrao.vpcf",
    	"sm/ziyuanpurple/courier_greevil_purple_ambient_3.vpcf",
    	"sm/xuehua.vpcf",
    	"sm/xiehuodefault.vpcf",
    	"sm/jinbijinbigold.vpcf",
    	"sm/guanghuisuiyue.vpcf",
    	"sm/zisexingyunsecondary.vpcf",
    	"particles/econ/items/silencer/silencer_ti6/silencer_last_word_status_ti6.vpcf",
    	"sm/xingxingold.vpcf",
    	"particles/generic_gameplay/dropped_item_rapier.vpcf",
    	"models/items/courier/boooofus_courier/boooofus_courier.vmdl",
    	"models/courier/donkey_crummy_wizard_2014/donkey_crummy_wizard_2014.vmdl",
    	"models/items/courier/bts_chirpy/bts_chirpy_flying.vmdl",
    	"models/courier/drodo/drodo.vmdl",
    	"models/courier/baby_rosh/babyroshan_flying.vmdl",
    	"models/items/courier/little_fraid_the_courier_of_simons_retribution/little_fraid_the_courier_of_simons_retribution.vmdl",
    	"models/items/wards/monty_ward/monty_ward.vmdl",
    	"models/items/courier/wabbit_the_mighty_courier_of_heroes/wabbit_the_mighty_courier_of_heroes_flying.vmdl",
    	"soundevents/game_sounds_heroes/game_sounds_medusa.vsndevts",
    	"models/items/wards/stonebound_ward/stonebound_ward.vmdl",
    	"particles/units/heroes/hero_visage/visage_base_attack.vpcf",
    	"particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf",
    	"particles/events/ti6_teams/teleport_start_ti6_lvl3_mvp_phoenix.vpcf",
    	"sounds/misc/crowd_lv_01.vsnd",
    	"models/items/wards/the_monkey_sentinel/the_monkey_sentinel.vmdl",
    	"particles/dev/library/base_linear_projectile_model.vpcf",
    	"particles/items2_fx/skadi_projectile.vpcf",
    	"particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf",
    	"particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile.vpcf",
    	"particles/econ/events/ti5/dagon_ti5.vpcf",
    	"effects/bianpaofireworks.vpcf",
    	"particles/econ/courier/courier_polycount_01/courier_trail_polycount_01a.vpcf",
    	"particles/econ/courier/courier_axolotl_ambient/courier_axolotl_ambient.vpcf",
    	"particles/vr/player_light_godray.vpcf",
    	"particles/econ/events/killbanners/screen_killbanner_compendium14_doublekill.vpcf",
    	"particles/econ/events/killbanners/screen_killbanner_compendium14_firstblood.vpcf",
    	"particles/econ/events/killbanners/screen_killbanner_compendium16_triplekill.vpcf",
    	"particles/econ/events/killbanners/screen_killbanner_compendium14_rampage_swipe1.vpcf",
    	"particles/econ/events/killbanners/screen_killbanner_compendium14_triplekill.vpcf",
    	"particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf",
    	"particles/gem/dove.vpcf",
    	"particles/units/heroes/hero_enchantress/enchantress_death_butterfly.vpcf",
    	"particles/units/heroes/hero_beastmaster/beastmaster_call_bird.vpcf",
    	"particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt_birds.vpcf",
    	"models/props_teams/logo_radiant_winter_medium.vmdl",
    	"particles/units/heroes/hero_siren/siren_net_main.vpcf",
    	"soundevents/game_sounds_heroes/game_sounds_naga_siren.vsndevts",
    	"materials/youbushiban.vmdl",
    	"materials/zhangqishiban.vmdl",
    	"materials/zuzhoushiban.vmdl",
    	"materials/hongliushiban.vmdl",
    	"soundevents/game_sounds_heroes/game_sounds_witchdoctor.vsndevts",
    	"soundevents/game_sounds_heroes/game_sounds_venomancer.vsndevts",
    	"soundevents/game_sounds_heroes/game_sounds_kunkka.vsndevts",
    	"materials/stone.vmdl",
    	"materials/new_stone.vmdl",
    	"soundevents/game_sounds_heroes/game_sounds_lycan.vsndevts",
    	"particles/units/heroes/hero_axe/axe_battle_hunger.vpcf",
    	"particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff.vpcf",
    	"soundevents/game_sounds_heroes/game_sounds_phantom_assassin.vsndevts",
    	"particles/units/heroes/hero_tusk/tusk_snowball_ground_frost.vpcf",
    	"sounds/weapons/hero/gyrocopter/call_down_cast.vsnd",
    	"sounds/weapons/hero/gyrocopter/call_down_impact.vsnd",
    	"particles/units/heroes/hero_gyrocopter/gyro_calldown_marker.vpcf",
    	"particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_calldown_first.vpcf",
    	"particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_calldown_second.vpcf",
    	"particles/units/heroes/hero_witchdoctor/witchdoctor_cask.vpcf",
    	"soundevents/game_sounds_heroes/game_sounds_witchdoctor.vsndevts",
    	"soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts",
    	"particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_force.vpcf",
    	"soundevents/game_sounds_heroes/game_sounds_rubick.vsndevts",
    	"effect/lianhua/lianhua.vpcf",
    	"effect/xuehua/xuehua.vpcf",
    	"soundevents/game_sounds_heroes/game_sounds_earthshaker.vsndevts",
		"particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_leap_impact.vpcf",
		"particles/units/heroes/hero_dazzle/dazzle_weave_circle_ray.vpcf",
		"particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_swirl_center_fxset.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_furion.vsndevts",
		"particles/econ/items/tinker/boots_of_travel/teleport_end_bots_b.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts",
		"particles/econ/items/invoker/invoker_ti7/invoker_ti7_alacrity_buff_dark.vpcf",
		"models/items/wards/sylph_ward/sylph_ward.vmdl",
		"particles/units/heroes/hero_omniknight/omniknight_purification.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_omniknight.vsndevts",
		"models/props_magic/bad_magic_tower001.vmdl",
		"models/particle/snowball.vmdl",
		"models/items/crystal_maiden/snowman/crystal_maiden_snowmaiden.vmdl",
		"models/items/winter_wyvern/winter_wyvern_ti7_immortal/winter_wyvern_ti7_immortal_ice_shards.vmdl",
		"models/items/wards/eye_of_avernus_ward/eye_of_avernus_ward.vmdl",
		"particles/units/heroes/hero_warlock/warlock_fatal_bonds_icon.vpcf",
		"particles/units/heroes/hero_warlock/warlock_fatal_bonds_base.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_axe.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_antimage.vsndevts",

		"models/courier/donkey_ti7/donkey_ti7.vmdl",
		"models/courier/otter_dragon/otter_dragon.vmdl",
		"models/courier/skippy_parrot/skippy_parrot_flying_sailboat.vmdl",
		"models/items/courier/echo_wisp/echo_wisp_flying.vmdl",
		"models/items/courier/g1_courier/g1_courier_flying.vmdl",
		"models/items/courier/hermit_crab/hermit_crab.vmdl",
		"models/items/courier/white_the_crystal_courier/white_the_crystal_courier_flying.vmdl",
		"models/courier/defense3_sheep/defense3_sheep.vmdl",
		"models/items/courier/courier_faun/courier_faun.vmdl",
    }
     
    print("Precache...")
	local t=#zr;
	for i=1,t do
		if string.find(zr[i], "vpcf") then
			PrecacheResource( "particle",  zr[i], context)
		end
		if string.find(zr[i], "vmdl") then 	
			PrecacheResource( "model",  zr[i], context)
		end
		if string.find(zr[i], "vsndevts") then
			PrecacheResource( "soundfile",  zr[i], context)
		end
    end

    PrecacheUnitByNameSync("npc_dota_hero_gyrocopter", context)
    PrecacheUnitByNameSync("npc_dota_hero_lich", context)

    print("Precache OK")
end

--游戏开始
function Activate()
	print ("GemTD START!")
	GameRules.AddonTemplate = GemTD()
	GameRules.AddonTemplate:InitGameMode()

	--监听全局定时器事件
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 0.5 )
end

--游戏初始化
function GemTD:InitGameMode()

	AMHCInit();

  	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 4)
  	if GetMapName() == "gemtd_1p" then
  		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 1)
  	end
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 0)

	GameRules:SetHeroRespawnEnabled( true )
	GameRules:SetSameHeroSelectionEnabled( true )
	GameRules:SetGoldPerTick(0)
	GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(5)

	--GameRules:GetGameModeEntity():SetCameraDistanceOverride(1500)

	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(
		{
			[1] = 0,
			[2] = 200,
			[3] = 550,
			[4] = 1050,
			[5] = 1700
		}
	)
	GameRules:GetGameModeEntity().quest = {}
	GameRules:GetGameModeEntity().wave_enemy_count = 5
	GameRules:GetGameModeEntity().win_streak = 0
	GameRules:GetGameModeEntity().kuangbao_time = 0
	GameRules:GetGameModeEntity().win_streak_time = 0
	GameRules:GetGameModeEntity().perfect_this_level = true

	GameRules:SetUseCustomHeroXPValues(true)

	--设置玩家颜色
	PlayerResource:SetCustomPlayerColor(0, 255, 255, 0)
	PlayerResource:SetCustomPlayerColor(1, 64, 64, 255)
	PlayerResource:SetCustomPlayerColor(2, 255, 0, 0)
	PlayerResource:SetCustomPlayerColor(3, 255, 0, 255)

	--监听玩家成功连入游戏
    ListenToGameEvent("player_connect_full", Dynamic_Wrap(GemTD,"OnPlayerConnectFull" ),self) 
    --监听玩家断开连接
    ListenToGameEvent("player_disconnect", Dynamic_Wrap(GemTD, "OnPlayerDisconnect"), self)
    --监听玩家选择英雄事件
    ListenToGameEvent("dota_player_pick_hero",Dynamic_Wrap(GemTD,"OnPlayerPickHero"),self)
	--监听单位出生事件
    ListenToGameEvent("npc_spawned", Dynamic_Wrap(GemTD, "OnNPCSpawned"), self)
    --监听单位被击杀的事件
    ListenToGameEvent("entity_killed", Dynamic_Wrap(GemTD, "OnEntityKilled"), self)
    --监听玩家聊天事件
    ListenToGameEvent("player_chat", Dynamic_Wrap(GemTD, "OnPlayerSay"), self)
    --监听英雄升级事件
    ListenToGameEvent("dota_player_gained_level", Dynamic_Wrap(GemTD,"OnPlayerGainedLevel"), self)

    ListenToGameEvent("dota_player_used_ability", Dynamic_Wrap(GemTD,"OnPlayerUseAbility"), self)

    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(GemTD,"OnGameRulesStateChange"), self)
	
	CustomGameEventManager:RegisterListener("get_mvp_text", Dynamic_Wrap(GemTD, "OnReceiveMvpText") )
	CustomGameEventManager:RegisterListener("gather_steam_ids", Dynamic_Wrap(GemTD, "OnReceiveSteamIDs") )
	CustomGameEventManager:RegisterListener("player_share_map", Dynamic_Wrap(GemTD, "OnReceiveShareMap") )
	CustomGameEventManager:RegisterListener("gemtd_hero", Dynamic_Wrap(GemTD, "OnReceiveHeroInfo") )
	CustomGameEventManager:RegisterListener("gemtd_repick_hero", Dynamic_Wrap(GemTD, "OnRepickHero") )

	CustomGameEventManager:RegisterListener("lobster2", Dynamic_Wrap(GemTD, "OnLobster2") )
	CustomGameEventManager:RegisterListener("click_ggsimida", Dynamic_Wrap(GemTD, "OnGGsimida") )
	CustomGameEventManager:RegisterListener("catch_crab", Dynamic_Wrap(GemTD, "OnCatchCrab") )

	GameRules:GetGameModeEntity().gem_castle_hp = 100
	GameRules:GetGameModeEntity().gem_castle_hp_speed = { 100,100,100,100 }
	GameRules:GetGameModeEntity().gem_castle = nil
	GameRules:GetGameModeEntity().gem_castle_speed = { nil,nil,nil,nil }

	GameRules:GetGameModeEntity().is_build_ready = {
		[0] = true,
		[1] = true,
		[2] = true,
		[3] = true,
	}

    --创建宝石城堡
	local u = CreateUnitByName("gemtd_castle", Entities:FindByName(nil,"path7"):GetAbsOrigin() ,false,nil,nil, DOTA_TEAM_GOODGUYS) 
	u.ftd = 2009
	u:AddAbility("no_hp_bar")
	u:FindAbilityByName("no_hp_bar"):SetLevel(1)
	u:RemoveModifierByName("modifier_invulnerable")
	u:SetHullRadius(64)
	u:SetForwardVector(Vector(-1,0,0))
	GameRules:GetGameModeEntity().gem_castle = u

	--随机数
	gemtd_randomize()
	GameRules:GetGameModeEntity().navi = RandomInt(1000,9999)
	GameRules:GetGameModeEntity().hero = {}

	GameRules:GetGameModeEntity().online_player_count = 0

	--检测作弊
	GameRules:GetGameModeEntity():SetThink("DetectCheatsThinker")

	GameRules.quest_status = {
		q101 = true,
		q102 = true,
		q103 = true,
		q104 = false,
		q105 = false,
		q106 = true,
		q107 = true,
		q108 = false,

		q201 = true,
		q202 = true,
		q203 = true,
		q204 = true,
		q205 = true,
		q206 = true,
		q207 = true,
		q208 = true,
		q209 = false,
		
		q301 = true,
		q302 = false,
		q303 = false,
	}
end

--玩家连入游戏
function GemTD:OnPlayerConnectFull (keys)
	-- DeepPrintTable(keys)

	CustomNetTables:SetTableValue( "game_state", "player_connect", { id = keys.PlayerID, hehe = RandomInt(1,10000) } );
	if PlayerResource:GetSelectedHeroName(0) ~= nil then
		CustomNetTables:SetTableValue( "game_state", "select_hero1", { p1 = PlayerResource:GetSelectedHeroName(0), p2 = PlayerResource:GetSelectedHeroName(1), p3 = PlayerResource:GetSelectedHeroName(2), p4 = PlayerResource:GetSelectedHeroName(3) } );
	end
	userid2player[keys.userid] = keys.index+1

	--重连
	if GameRules.is_debug == true then
		-- GameRules:SendCustomMessage("PlayerID="..keys.PlayerID.." 的玩家加入了游戏。", 0, 0)
	end

	if isConnected[keys.index + 1] == true then
		local hero = PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero()
		-- GameRules:SendCustomMessage("PlayerID="..keys.PlayerID.." 的玩家加入了游戏。", 0, 0)
		GameRules:SendCustomMessage(hero:GetUnitName(), 0, 0)
		hero:RemoveAbility("silence_self")
		hero:RemoveModifierByName("modifier_tower_chenmo")

		if GameRules.game_state == 1 and hero:FindAbilityByName("gemtd_build_stone"):IsActivated() == false and hero.build_level ~= GameRules.level then
			GameRules:GetGameModeEntity().is_build_ready[keys.PlayerID]=false

			hero:FindAbilityByName("gemtd_build_stone"):SetActivated(true)
			hero:FindAbilityByName("gemtd_remove"):SetActivated(true)

			hero.build_level = GameRules.level

			hero:SetMana(5.0)
		end
		
		if GameRules.is_debug == true then
			-- GameRules:SendCustomMessage("PlayerID="..keys.PlayerID.." 的玩家是断线重连的。", 0, 0)
		end

		--同步玩家金钱
		local ii = 0
		for ii = 0, 20 do
			if ( PlayerResource:IsValidPlayer( ii ) ) then
				local player = PlayerResource:GetPlayer(ii)
				if player ~= nil then
					PlayerResource:SetGold(ii, GameRules.team_gold, true)
				end
			end
		end
		CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = GameRules.team_gold } )
		
		--重连
		CustomNetTables:SetTableValue( "game_state", "reconnect", { hehe = RandomInt(1,10000) })
	end

	isConnected[keys.index+1] = true

	GameRules:GetGameModeEntity().online_player_count = GameRules:GetGameModeEntity().online_player_count + 1
	if GameRules.is_debug == true then
		GameRules:SendCustomMessage("当前玩家总数: "..GameRules:GetGameModeEntity().online_player_count, 0, 0)
	end

	-- if GameRules:GetGameModeEntity().online_player_count == PlayerResource:GetPlayerCount() then
	-- 	if GameRules.is_debug == true then
	-- 		GameRules:SendCustomMessage("全都连进来了", 0, 0)
	-- 	end
	-- 	CustomNetTables:SetTableValue( "game_state", "all_connected", { hehe = RandomInt(1,10000) })
	-- end
end

--玩家断开连接
function GemTD:OnPlayerDisconnect (keys)
	-- DeepPrintTable(keys)
	CustomNetTables:SetTableValue( "game_state", "player_disconnect", { id = keys.PlayerID, user_name = keys.name, hehe = RandomInt(1,10000) } );

	GameRules:GetGameModeEntity().online_player_count = GameRules:GetGameModeEntity().online_player_count - 1
	if GameRules.is_debug == true then
		GameRules:SendCustomMessage("当前玩家总数: "..GameRules.online_player_count, 0, 0)
	end

	local hero = PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero()
	-- GameRules:SendCustomMessage("PlayerID="..keys.PlayerID.." 的玩家离开了游戏。", 0, 0)
	-- GameRules:SendCustomMessage(hero:GetUnitName(), 0, 0)
	hero:AddAbility("silence_self")
	hero:FindAbilityByName("silence_self"):SetLevel(1)
	-- PauseGame(true)

	-- if GameRules.online_player_count == 0 then
		
	-- end
end

--玩家选择英雄
function GemTD:OnPlayerPickHero(keys)
	-- DeepPrintTable(keys)
	local player = EntIndexToHScript(keys.player)
    local hero = EntIndexToHScript(keys.heroindex) --player:GetAssignedHero()
    hero.ftd = 2009
    SetHeroLevelShow(hero)
    --GameRules:SendCustomMessage("玩家选择英雄:"..hero:GetUnitName(), 0, 0)

    if GameRules.replced[id] == true then
    	return
    end

    --清空占位技能
	-- for i,vi in pairs (GameRules.ability_sea) do
	-- 	if hero:FindAbilityByName(vi) ~= nil then
	-- 		hero:RemoveAbility(vi)
	-- 		-- hero:FindAbilityByName(vi):SetLevel(1)
	-- 	end
	-- end

	for i=0,23 do
		if hero:GetAbilityByIndex(i) ~= nil then
			hero:RemoveAbility(hero:GetAbilityByIndex(i):GetAbilityName())
		end
	end

    --将所有玩家的英雄存到一个数组
	local heroindex = keys.heroindex
    GameRules:GetGameModeEntity().hero[heroindex] = hero
 --    hero:AddAbility("no_hp_bar")
	-- hero:FindAbilityByName("no_hp_bar"):SetLevel(1)
    --GameRules:SendCustomMessage("玩家选择英雄:"..hero:GetUnitName(), 0, 0)
    if hero:GetUnitName() == "npc_dota_hero_riki" then
	    local pp = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
	    hero.pp = pp
	end

	-- 技能测试
	-- hero:AddAbility("axe_berserkers_call_new")
	-- hero:FindAbilityByName("axe_berserkers_call_new"):SetLevel(4)
	-- hero:AddAbility("antimage_blink_new")
	-- hero:FindAbilityByName("antimage_blink_new"):SetLevel(4)
	-- hero:AddAbility("templar_assassin_refraction_new")
	-- hero:FindAbilityByName("templar_assassin_refraction_new"):SetLevel(4)


    --判断是否所有的人都已经选择结束
    local playercount = 0
    for i,vi in pairs(GameRules:GetGameModeEntity().hero) do
    	playercount = playercount +1
    end

    if playercount == PlayerResource:GetPlayerCount() then
    	--GameRules:SendCustomMessage("发请求", 0, 0)
    	CustomNetTables:SetTableValue( "game_state", "startgame",{})

   --  	Timers:CreateTimer(5,function()
			
   --  	end)
    end
	
end

function SetHeroLevelShow(hero_new)
	hero_new:SetAbilityPoints(0)
	hero_new:RemoveAbility('hero_level_show_1')
	hero_new:RemoveAbility('hero_level_show_2')
	hero_new:RemoveAbility('hero_level_show_3')
	hero_new:RemoveAbility('hero_level_show_4')
	hero_new:RemoveAbility('hero_level_show_5')
	hero_new:RemoveModifierByName('modifier_hero_level_show_1')
	hero_new:RemoveModifierByName('modifier_hero_level_show_2')
	hero_new:RemoveModifierByName('modifier_hero_level_show_3')
	hero_new:RemoveModifierByName('modifier_hero_level_show_4')
	hero_new:RemoveModifierByName('modifier_hero_level_show_5')
	hero_new:AddAbility('hero_level_show_'..hero_new:GetLevel())
	hero_new:FindAbilityByName('hero_level_show_'..hero_new:GetLevel()):SetLevel(hero_new:GetLevel())
end

--接收客户端发来的玩家服务器数据
function GemTD:OnReceiveHeroInfo(keys)
	DeepPrintTable(keys)
	local heroindex = tonumber(keys.heroindex)
	local steam_id = keys.steam_id
	local onduty_hero = keys.onduty_hero.hero_id;
	local onduty_hero_info = keys.onduty_hero;
	local pet = keys.pet

	if keys.is_black == 1 then
		GameRules:SendCustomMessage("#text_black", 0, 0)
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		return
	end

	local heroindex_old = heroindex

	local hero = EntIndexToHScript(heroindex)

	local id = hero:GetPlayerID()
	--GameRules:SendCustomMessage("换英雄"..id.."--"..GameRules.hero_list[curr_hero], 0, 0)
	
	-- if (GameRules.replced[id] == false) then
		-- GameRules.replced[id] = true

	local is_can_build = false
	if hero:FindAbilityByName("gemtd_build_stone") ~= nil then
		is_can_build = hero:FindAbilityByName("gemtd_build_stone"):IsActivated()
	end

	local change_pet = nil
	if hero.pet ~= nil then
		change_pet = hero.pet
	end

	print(onduty_hero)
	print(GameRules.hero_sea[onduty_hero])

		PrecacheUnitByNameAsync( GameRules.hero_sea[onduty_hero], function()
			local pppp = hero:GetAbsOrigin()
			hero:SetAbsOrigin(Vector(10000,10000,0))
			if hero.ppp ~= nil then
				ParticleManager:DestroyParticle(hero.ppp,true)
			end
			if hero.pp ~= nil then
				ParticleManager:DestroyParticle(hero.pp,true)
			end


			local hero_new = PlayerResource:ReplaceHeroWith(id,GameRules.hero_sea[onduty_hero],PlayerResource:GetGold(id),0)

			hero_new:RemoveAbility("techies_suicide")
			hero_new:RemoveAbility("techies_focused_detonate")
			hero_new:RemoveAbility("techies_land_mines")
			hero_new:RemoveAbility("techies_remote_mines")
			hero_new:RemoveAbility("techies_remote_mines_self_detonate")
			hero_new:RemoveAbility("techies_stasis_trap") 	
			hero_new:RemoveAbility("techies_minefield_sign") 	

			hero_new:SetAbsOrigin(Vector(0,0,0))
			FindClearSpaceForUnit(hero_new,Vector(0,0,0),false)

			

			heroindex = hero_new:GetEntityIndex()

			--存在一个table里
			playerInfoReceived[heroindex] = {
				["heroindex"] = heroindex,
				["steam_id"] = steam_id,
				["onduty_hero"] = onduty_hero,
			};

			--test
			-- for hh,hv in pairs(GameRules.hero_sea) do
			-- 	local u = CreateUnitByName(hv, Vector(0,0,0) ,false,nil,nil, DOTA_TEAM_GOODGUYS) 
			-- 	u.ftd = 2009
			-- 	u:SetOwner(hero_new:GetOwner())
			-- 	u:SetControllableByPlayer(0, true)
			-- end
			-- hero_new:AddAbility("e303")
			-- hero_new:FindAbilityByName("e303"):SetLevel(1)
			
			-- play_particle("particles/units/heroes/hero_siren/naga_siren_portrait.vpcf",PATTACH_EYES_FOLLOW,hero_new,20)

			--加技能
			hero_new:RemoveAbility("gemtd_build_stone")
			hero_new:RemoveAbility("gemtd_remove")
			hero_new.build_level = GameRules.level

			hero_new:AddAbility("gemtd_build_stone")
			hero_new:FindAbilityByName("gemtd_build_stone"):SetLevel(1)
			hero_new:AddAbility("gemtd_remove")
			hero_new:FindAbilityByName("gemtd_remove"):SetLevel(1)

			hero_new:FindAbilityByName("gemtd_build_stone"):SetActivated(is_can_build)
			hero_new:FindAbilityByName("gemtd_remove"):SetActivated(is_can_build)

			-- hero_new:AddAbility("gemtd_hero_beishuiyizhan")
			-- hero_new:FindAbilityByName("gemtd_hero_beishuiyizhan"):SetLevel(3)
			-- hero_new:AddAbility("gemtd_hero_qingyi")
			-- hero_new:FindAbilityByName("gemtd_hero_qingyi"):SetLevel(4)
			-- hero_new:AddAbility("warlock_fatal_bonds")
			-- hero_new:FindAbilityByName("warlock_fatal_bonds"):SetLevel(4)

			-- hero_new:AddAbility("gemtd_hero_putong")
			-- hero_new:FindAbilityByName("gemtd_hero_putong"):SetLevel(1)
			-- hero_new:AddAbility("gemtd_hero_wuxia")
			-- hero_new:FindAbilityByName("gemtd_hero_wuxia"):SetLevel(1)
			-- hero_new:AddAbility("gemtd_hero_wanmei")
			-- hero_new:FindAbilityByName("gemtd_hero_wanmei"):SetLevel(1)
			

			local a_count = 0
			if onduty_hero_info.ability ~= nil then

				--排序显示
				local key_test ={}
				-- print(onduty_hero_info.ability)
				for i,v in pairs(onduty_hero_info.ability) do
				   table.insert(key_test,i)   --提取test1中的键值插入到key_test表中
				end
				table.sort(key_test)

				for i,v in pairs(key_test) do
					a_count = a_count+1
					local a = v
					local va = onduty_hero_info.ability[v]
					if GameRules.ability_sea[a]~=nil then
						-- print(">>>>"..GameRules.ability_sea[a]);
						hero_new:AddAbility(GameRules.ability_sea[a])
						hero_new:FindAbilityByName(GameRules.ability_sea[a]):SetLevel(va)
					end
				end
				hero_new.ability = onduty_hero_info.ability
			end
			local total_count = tonumber(string.sub(onduty_hero,2,2))
			if onduty_hero_info.extend == nil then
				onduty_hero_info.extend = 0
			end
			total_count = total_count + tonumber(onduty_hero_info.extend)
			local empty_count = total_count - a_count
			if empty_count > 0 then
				for i=1,empty_count do
					hero_new:AddAbility("empty"..i)
					hero_new:FindAbilityByName("empty"..i):SetLevel(1)
				end
			end
			
			if onduty_hero_info.effect ~= nil and onduty_hero_info.effect ~= "" then
				hero_new:AddAbility(onduty_hero_info.effect)
				hero_new:FindAbilityByName(onduty_hero_info.effect):SetLevel(1)	
				hero_new.effect = onduty_hero_info.effect
			end

			--送tp问题
			for slot=0,8 do
				if hero_new:GetItemInSlot(slot)~= nil then
					hero_new:RemoveItem(hero_new:GetItemInSlot(slot))
				end
			end
			-- hero_new:AddItemByName("fix_tool")

			

			-- for iii,abi in pairs(temp_a) do
			-- 	if hero_new:GetAbilityByIndex(iii)~= abi then
			-- 		hero_new:SwapAbilities(abi,hero_new:GetAbilityByIndex(iii):GetAbilityName(),true,true)
			-- 	end
			-- end

			for iii=0,20 do
				if hero_new:GetAbilityByIndex(iii) ~= nil then
					print("ability"..iii..": "..hero_new:GetAbilityByIndex(iii):GetAbilityName())
				end
			end

			DeepPrintTable(hero_new.ability)

			--调整技能顺序
			local temp_a = {}
			for iii,abi in pairs(hero_new.ability) do
				table.insert(temp_a,iii)
			end
			DeepPrintTable(temp_a)
			for iii,abi in pairs(temp_a) do
				if hero_new:GetAbilityByIndex(iii+1):GetAbilityName()~= GameRules.ability_sea[abi] then
					hero_new:SwapAbilities(GameRules.ability_sea[abi],hero_new:GetAbilityByIndex(iii+1):GetAbilityName(),true,true)
				end
			end

			for iii=0,20 do
				if hero_new:GetAbilityByIndex(iii) ~= nil then
					print("ability"..iii..": "..hero_new:GetAbilityByIndex(iii):GetAbilityName())
				end
			end

			hero_new:AddAbility('no_hp_bar')
			hero_new:FindAbilityByName('no_hp_bar'):SetLevel(1)
			
			play_particle("particles/radiant_fx/radiant_tower002_destruction_a2.vpcf",PATTACH_ABSORIGIN_FOLLOW,hero_new,2)

			GameRules:GetGameModeEntity().hero[heroindex_old] = nil
			GameRules:GetGameModeEntity().hero[hero_new:GetEntityIndex()] = hero_new

			CustomNetTables:SetTableValue( "game_state", "repick_hero", { old_index = heroindex_old, new_index = hero_new:GetEntityIndex() } );

			CustomNetTables:SetTableValue( "game_state", "select_hero1", { p1 = PlayerResource:GetSelectedHeroName(0), p2 = PlayerResource:GetSelectedHeroName(1), p3 = PlayerResource:GetSelectedHeroName(2), p4 = PlayerResource:GetSelectedHeroName(3) } );

			-- createHintBubble(hero_new,"#text_hello")

			SetHeroLevelShow(hero_new)

			Timers:CreateTimer(1,function()
				--hero_new:DestroyAllSpeechBubbles()
				--hero_new:AddSpeechBubble(0,"#text_hello",3,0,30)
				
				-- if hero_new:FindAbilityByName("no_hp_bar") ~= nil then
				-- 	hero_new:AddAbility("no_hp_bar")
				-- 	hero_new:FindAbilityByName("no_hp_bar"):SetLevel(1)
				-- end

				-- hero_new:RemoveAbility("gemtd_build_stone")
				-- hero_new:RemoveAbility("gemtd_remove")

				-- hero_new:AddAbility("gemtd_build_stone")
				-- hero_new:FindAbilityByName("gemtd_build_stone"):SetLevel(is_can_build)
				-- hero_new:AddAbility("gemtd_remove")
				-- hero_new:FindAbilityByName("gemtd_remove"):SetLevel(is_can_build)

				--添加玩家颜色底盘
				local particle = ParticleManager:CreateParticle("particles/gem/team_"..(id+1)..".vpcf", PATTACH_ABSORIGIN_FOLLOW, hero_new) 
				hero_new.ppp = particle
				CustomNetTables:SetTableValue( "game_state", "hide_curtain", {} )

				if change_pet ~= nil then
					change_pet.owner = hero_new
				end

				--生成宠物
				if pet ~= nil and GameRules.pet_list[pet] ~= nil then
					local my_pet = CreateUnitByName("gemtd_pet", Vector(0,0,0) ,false,nil,nil, DOTA_TEAM_GOODGUYS) 
					my_pet.ftd = 2009
					my_pet:SetOwner(hero_new:GetOwner())
					my_pet:SetOriginalModel(GameRules.pet_list[pet])
					my_pet:SetModel(GameRules.pet_list[pet])
					hero_new.pet = my_pet
					my_pet.owner = hero_new

					Timers:CreateTimer(1,function()
						if my_pet.owner == nil then
							return 1
						end
						if (my_pet:GetAbsOrigin() - my_pet.owner:GetAbsOrigin()):Length2D() >200 then
							local ran1 = RandomInt(50,200)
							local ran11 = RandomInt(0,1)
							if ran11 == 0 then 
								ran1 = -ran1
							end
							local ran2 = RandomInt(50,200)
							local ran22 = RandomInt(0,1)
							if ran22 == 0 then 
								ran2 = -ran2
							end
							my_pet:MoveToPosition(my_pet.owner:GetAbsOrigin()+Vector(ran1,ran2,0))
							return 1
						else
							return 1
						end
					end)
				end

			end
			)
		end, id)
	-- end


	-- --服务器存的当前英雄仍有效，直接调用
	-- if curr_hero ~= 0 then
	-- 	print("ohyehaiyouyingxiong")
	--     hero:SetOriginalModel(GameRules.hero_list[tonumber(curr_hero)])
	--     hero:SetModel(GameRules.hero_list[tonumber(curr_hero)])
	--     GameRules.currHeroIds[steam_id] = tonumber(curr_hero)
	--     RandomAbility(tonumber(curr_hero), hero)
	-- --当前英雄已失效（服务器端置为0了）
	-- else
	-- 	--服务器发送的英雄池也为空，或不为空，50%概率仍然从基础角色中随机
 --    	if hero_pool == nil or string.len(hero_pool) <=0 or RandomInt(0,100) > 50 then
	-- 	    local random0 = RandomInt(1,20)
	-- 	    while GameRules.hero_list[random0] == nil do
	-- 	    	random0 = RandomInt(1,20)
	-- 	    end
	-- 	    hero:SetOriginalModel(GameRules.hero_list[random0])
	-- 	    hero:SetModel(GameRules.hero_list[random0])
	-- 	    GameRules.currHeroIds[steam_id] = random0
	-- 	    RandomAbility(random0, hero)
	-- 	--服务器发送的英雄池非空，50%概率从自有角色中随机
	-- 	else
	-- 		local pool = string.split(player_info.hero_pool,",")
	-- 		local random1 = RandomInt(1,table.maxn(pool))
	-- 		local random1_hero_id = pool[random1]
	-- 		local random1_hero_model = GameRules.hero_list[tonumber(random1_hero_id)]
	-- 	    hero:SetOriginalModel(random1_hero_model)
	-- 	    hero:SetModel(random1_hero_model)
	-- 	    GameRules.currHeroIds[steam_id] = pool[random1]
	-- 	    RandomAbility(tonumber(random1_hero_id), hero)
 --    	end
 --    end
end

--重选英雄
function GemTD:OnRepickHero(keys)
	local heroindex = keys.heroindex
	local steam_id = keys.steam_id
	local repick_hero = tonumber(keys.repick_hero)
	local repipck_hero_level = tonumber(keys.repipck_hero_level)

	-- print("GameRules:GetGameModeEntity().hero:")
	-- for iii,jjj in pairs(GameRules:GetGameModeEntity().hero) do
	-- 	print(iii..">>>"..jjj:GetUnitName())
	-- end

	local hero = GameRules:GetGameModeEntity().hero[heroindex]
	local id = hero:GetPlayerID()
	--GameRules:SendCustomMessage(heroindex.."换英雄"..id.."--"..GameRules.hero_list[repick_hero], 0, 0)

	play_particle("particles/items2_fx/refresher.vpcf",PATTACH_ABSORIGIN_FOLLOW,hero,2)

	PrecacheUnitByNameAsync( GameRules.hero_sea[repick_hero], function()

		if hero.ppp ~= nil then
			ParticleManager:DestroyParticle(hero.ppp,true)
		end

		local hero_new = PlayerResource:ReplaceHeroWith(id,GameRules.hero_sea[repick_hero],PlayerResource:GetGold(id),0)
		GameRules.replced[id] = true

		GameRules:GetGameModeEntity().hero[heroindex] = nil
		GameRules:GetGameModeEntity().hero[hero_new:GetEntityIndex()] = hero_new

		CustomNetTables:SetTableValue( "game_state", "repick_hero", { old_index = heroindex, new_index = hero_new:GetEntityIndex() } );

		CustomNetTables:SetTableValue( "game_state", "select_hero1", { p1 = PlayerResource:GetSelectedHeroName(0), p2 = PlayerResource:GetSelectedHeroName(1), p3 = PlayerResource:GetSelectedHeroName(2), p4 = PlayerResource:GetSelectedHeroName(3) } );
		
		-- CustomNetTables:SetTableValue( "game_state", "disable_repick", { heroindex = hero_new:GetEntityIndex(), hehe = RandomInt(1,1000) } );

		--hero_new:DestroyAllSpeechBubbles()
		--hero_new:AddSpeechBubble(0,"#text_hello",3,0,30)
		-- createHintBubble(hero_new,"#text_hello")

		hero_new:RemoveAbility("gemtd_build_stone")
		hero_new:RemoveAbility("gemtd_remove")

		hero_new:AddAbility("gemtd_build_stone")
		hero_new.build_level = GameRules.level
		hero_new:FindAbilityByName("gemtd_build_stone"):SetLevel(1)
		hero_new:AddAbility("gemtd_remove")
		hero_new:FindAbilityByName("gemtd_remove"):SetLevel(1)

		local a = GameRules.ability_sea[repick_hero]
		hero_new:AddAbility(a)
		hero_new:FindAbilityByName(a):SetLevel(repipck_hero_level)
		hero_new.ability = a;
		hero_new.ability_level = repipck_hero_level;

		--添加玩家颜色底盘
		local particle = ParticleManager:CreateParticle("particles/gem/team_"..(id+1)..".vpcf", PATTACH_ABSORIGIN_FOLLOW, hero_new) 
		hero_new.ppp = particle

		SetHeroLevelShow(hero_new)

		-- if hero_new:FindAbilityByName("no_hp_bar") ~= nil then
		-- 	hero_new:AddAbility("no_hp_bar")
		-- 	hero_new:FindAbilityByName("no_hp_bar"):SetLevel(1)
		-- end

	end, id)
end

function GemTD:OnGameRulesStateChange(keys)
	local newState = GameRules:State_Get()

	if newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		--self.CustomRule:HeroSelect()
	elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
		--self.CustomRule:PreGame()
    elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    	
	end
end

function GemTD:OnReceiveMvpText(keys)
	GameRules:GetGameModeEntity().mvp_text_1 = keys.mvp_text_1
	GameRules:GetGameModeEntity().mvp_text_2 = keys.mvp_text_2
end

function GemTD:OnReceiveSteamIDs(keys)
	-- DeepPrintTable(keys)
	GameRules:GetGameModeEntity().player_ids = keys.steam_ids
	GameRules:GetGameModeEntity().steam_ids_only = keys.steam_ids_only
	GameRules:GetGameModeEntity().start_time = keys.start_time

	--GameRules:SendCustomMessage("black="..keys.is_black, 0, 0)

	if keys.is_black == 1 then
		GameRules:SendCustomMessage("#text_black", 0, 0)
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	end

	--请求英雄数据
	-- print("Gather Steam Ids!")
	-- print(keys.steam_ids)
	GameRules.steam_ids = keys.steam_ids

	local url = "http://101.200.189.65:430/gemtd/201803/heros/get/@"..keys.steam_ids.."?ver=v1&compen_shell=2"

	local req = CreateHTTPRequestScriptVM("GET", url)
	req:SetHTTPRequestAbsoluteTimeoutMS(20000)
	req:Send(function (result)
		local t = json.decode(result["Body"])
		GemTD:OnLobster2({
			data = t["data"]
		})
		GameRules:GetGameModeEntity().kuangbao_time = PlayerResource:GetPlayerCount()*120 + 60
		GameRules:GetGameModeEntity().win_streak_time = GameRules:GetGameModeEntity().kuangbao_time/2
	end)

	-- CustomNetTables:SetTableValue( "game_state", "lobster", {url = url, hehe = RandomInt(0,10000)})

	GameRules.is_lobster_ok = false;
	Timers:CreateTimer(10,function ()
		if GameRules.is_lobster_ok == false then
			GameRules:SendCustomMessage('连接服务器失败',0,0)
			GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		end
	end)
	-- end
	-- print(url)

	-- local req = CreateHTTPRequest("GET", url)
	-- req:SetHTTPRequestAbsoluteTimeoutMS(20000)
	-- req:Send(function (result)

	-- 	local t = json.decode (result["Body"])

	-- 	-- local heroindex = keys.heroindex
	-- 	-- local steam_id = keys.steam_id
	-- 	-- local onduty_hero = keys.onduty_hero.hero_id;
	-- 	-- local onduty_hero_info = keys.onduty_hero;

	-- 	-- if keys.is_black == 1 then
	-- 	for u,v in pairs(t["data"]) do
	-- 		if v["steam_id"] == "76561198101849234" or v["steam_id"] == "76561198090931971" or v["steam_id"] == "76561198090961025" then
	-- 			GameRules.myself = true
	-- 		end

	-- 		--随机任务
	-- 		-- print(v.quest.quest.."-------------"..v.quest.quest_expire)
	-- 		if v.quest.quest ~= nil and v.quest.quest_expire == -2 then
	-- 			GameRules:GetGameModeEntity().quest[v.quest.quest] = GameRules.quest_status[v.quest.quest]
	-- 		end
	-- 		-- DeepPrintTable(GameRules:GetGameModeEntity().quest)

	-- 		GemTD:OnReceiveHeroInfo({
	-- 			heroindex = tonumber(v["hero_index"]),
	-- 			steam_id = v["steam_id"],
	-- 			hero_sea = v["hero_sea"],
	-- 			onduty_hero = v["onduty_hero"],
	-- 			is_black = v["is_black"],
	-- 		})
	-- 	end

	-- 	print("set_hero_sea......")
	-- 	t["data"]["hehe"] = RandomInt(1,10000)

	-- 	DeepPrintTable(t["data"])

	-- 	CustomNetTables:SetTableValue( "game_state", "crab", t["data"])



	-- 	Timers:CreateTimer(10,function()
	-- 		-- GameRules:SendCustomMessage("#text_game_start", 0, 0)
	-- 		GameRules:GetGameModeEntity().game_time = GameRules:GetGameTime()
	-- 		GameRules.game_status = 1
	-- 		start_build()
 --    	end)
	-- end)

end

function GemTD:OnLobster2(t)
	GameRules.is_lobster_ok = true
	-- DeepPrintTable(t.data)
	for u,v in pairs(t["data"]) do
		if u == "76561198101849234" or u == "76561198090931971" or u == "76561198090961025" or u == "76561198132023205" or u == "76561198079679584" then
			GameRules.myself = true
		end

		--随机任务
		-- print(v.quest.quest.."-------------"..v.quest.quest_expire)
		if v.quest.quest ~= nil and v.quest.quest_expire == -2 then
			GameRules:GetGameModeEntity().quest[v.quest.quest] = GameRules.quest_status[v.quest.quest]
		end
		-- DeepPrintTable(GameRules:GetGameModeEntity().quest)

		show_quest()

		GemTD:OnReceiveHeroInfo({
			heroindex = tonumber(v["hero_index"]),
			steam_id = u,
			hero_sea = v["hero_sea"],
			onduty_hero = v["onduty_hero"],
			is_black = v["is_black"],
			pet = v["pet"],
		})
	end

	-- if GameRules.myself ~= true then
	-- 	--测试模式不允许外人参与
	-- 	GameRules:SendCustomMessage('对不起，您没有参与测试模式的资格！',0,0)
	-- 	GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	-- end

	-- print("set_hero_sea......")
	t["data"]["hehe"] = RandomInt(1,10000)

	-- DeepPrintTable(t["data"])

	CustomNetTables:SetTableValue( "game_state", "crab", t["data"])

	CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = GameRules.level, enemy_show = "gemtd_stone" } );

	Timers:CreateTimer(10,function()
		-- GameRules:SendCustomMessage("#text_game_start", 0, 0)
		GameRules:GetGameModeEntity().game_time = GameRules:GetGameTime()
		GameRules.game_status = 1
		start_build()
	end)
end

function GemTD:OnReceiveShareMap(keys)
	-- DeepPrintTable(keys)
	GameRules:GetGameModeEntity().map = keys.map

	if GameRules:GetGameModeEntity().map ~= nil then
		GameRules:SendCustomMessage("#show_maze_pic", 0, 0)
		CustomNetTables:SetTableValue( "game_state", "show_maze_map", {map = GameRules:GetGameModeEntity().map} );
	end

end


function GemTD:OnPlayerGainedLevel(keys)
	local i = 0
	for i = 0, 9 do
		if ( PlayerResource:IsValidPlayer( i ) ) then
			local player = PlayerResource:GetPlayer(i)
			if player ~= nil then
			local h = player:GetAssignedHero()
				if h ~= nil and h:GetAbilityPoints() ~=0 then
					SetHeroLevelShow(h)
					CustomNetTables:SetTableValue( "game_state", "gem_team_level", { level = h:GetLevel() } );
				end
			end
		end
	end
	-- DeepPrintTable(keys)
	--判断作弊
	-- if (GameRules.level<3 and keys.level > 1 or
	-- 	GameRules.level<5 and keys.level > 2 or
	--     GameRules.level<7 and keys.level > 3 or
	-- 	GameRules.level<9 and keys.level > 4) then
	-- 	-- zuobi()
	-- 	GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	-- end
end

--全局定时器事件
function OnThink()
	
    time_tick = time_tick +1
	--print(time_tick)

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

		-- local i = 0
		-- for i = 0, 9 do
		-- 	if ( PlayerResource:IsValidPlayer( i ) ) then
		-- 		local player = PlayerResource:GetPlayer(i)
		-- 		if player ~= nil then
		-- 			local h = player:GetAssignedHero()
		-- 			if h ~= nil and h:GetAbilityPoints() ~=0 then
		-- 				--h:DestroyAllSpeechBubbles()
		-- 				--h:AddSpeechBubble(2,"#text_i_level_up",3,0,30)
		-- 				if h:GetLevel() > 1 then
		-- 					-- createHintBubble(h,"#text_i_level_up")
		-- 				end
		-- 				SetHeroLevelShow(h)
		-- 				CustomNetTables:SetTableValue( "game_state", "gem_team_level", { level = h:GetLevel() } );
						

		-- 			end
		-- 		end
		-- 	end
		-- end

		--超时加狂暴
		local time_this_level = 0
		if GameRules.stop_watch == nil then
			time_this_level = 0
		else
			time_this_level = math.floor(GameRules:GetGameTime() - GameRules.stop_watch)
		end

		if GameRules.stop_watch ~= nil then

			GameRules:GetGameModeEntity().kuangbao_time = PlayerResource:GetPlayerCount()*120 + 60
			GameRules:GetGameModeEntity().win_streak_time = GameRules:GetGameModeEntity().kuangbao_time/2

			--触发狂暴
			if time_this_level > GameRules:GetGameModeEntity().kuangbao_time and not GameRules.is_crazy == true then
				GameRules.is_crazy = true
				GameRules:SendCustomMessage("#text_enemy_crazy", 0, 0)
				EmitGlobalSound("diretide_eventstart_Stinger")

				GameRules:GetGameModeEntity().gem_castle:AddAbility("enemy_crazy")
				GameRules:GetGameModeEntity().gem_castle:FindAbilityByName("enemy_crazy"):SetLevel(1)
			end

			
		end

		--发送当前游戏时间给客户端
		if GameRules:GetGameModeEntity().game_time ~= nil then
			CustomGameEventManager:Send_ServerToAllClients("show_time",{
				total_time = math.floor(GameRules:GetGameTime() - GameRules:GetGameModeEntity().game_time),
				wave_time = time_this_level,
				win_streak = GameRules:GetGameModeEntity().win_streak, 
				kuangbao_time = GameRules:GetGameModeEntity().kuangbao_time,
				win_streak_time = GameRules:GetGameModeEntity().win_streak_time,
			})
		end


		--刷怪
		if ( GameRules.gem_is_shuaguaiing==true and not GameRules:IsGamePaused()) then
			local ShuaGuai_entity = Entities:FindByName(nil,"path1")
			local position = ShuaGuai_entity:GetAbsOrigin() 
			position.z = 150

			GameRules.is_passed = false
			if GameRules.level > 50 then
				GameRules.is_passed = true
				GameRules.guai_level = GameRules.level - 50
			else
				GameRules.guai_level = GameRules.level
			end

			local u = nil

			local guai_name  = GameRules.guai[GameRules.guai_level]

			--有些关卡有特殊刷怪逻辑
			if (GameRules.guai_level ==35 and RandomInt(1,100)>50 ) then
				guai_name = guai_name.."1"
			end
			if (GameRules.guai_level ==36 and RandomInt(1,100)>50 ) then
				guai_name = guai_name.."1"
			end
			if (GameRules.guai_level ==38 and RandomInt(1,100)>50 ) then
				guai_name = guai_name.."1"
			end
			
			-- if (GameRules.level ==46) then
			-- 	for i,vi in pairs (GameRules.gemtd_pool) do
			-- 		vi:RemoveModifierByName('modifier_gemtd_hero_miaozhun')
			-- 		vi:RemoveModifierByName('modifier_gemtd_hero_baoji')
			-- 		vi:RemoveModifierByName('modifier_gemtd_hero_kuaisusheji')
			-- 	end			
			-- end

		    u = CreateUnitByName(guai_name, position,true,nil,nil,DOTA_TEAM_BADGUYS) 
		    u.ftd = 2009
		    
		    if GameRules.is_debug == true then
		    	GameRules:SendCustomMessage("PlayerResource里的玩家数: "..PlayerResource:GetPlayerCount(), 0, 0)
		    end

		    if GameRules.gem_nandu <= PlayerResource:GetPlayerCount() then
		    	GameRules.gem_nandu = PlayerResource:GetPlayerCount()
		    end

		    if GameRules.is_debug == true then
			    GameRules:SendCustomMessage("难度等级： "..GameRules.gem_nandu, 0, 0)
			    GameRules:SendCustomMessage("难度系数： "..GameRules.gem_difficulty[GameRules.gem_nandu], 0, 0)
			end

		    if GameRules.gem_difficulty[GameRules.gem_nandu] == nil then
		    	GameRules:SendCustomMessage("BUG le", 0, 0)
		    end

		    --添加技能
		    for ab,abab in pairs(GameRules.guai_ability[GameRules.guai_level]) do
		    	u:AddAbility(abab)
				u:FindAbilityByName(abab):SetLevel(GameRules.gem_nandu)
		    end

		    local random_hit = 1
		    if (not string.find(guai_name, "boss")) and (not string.find(guai_name, "tester")) then
			    if RandomInt(1,400) <= (1) then
			    	GameRules:SendCustomMessage("#text_a_elite_enemy_is_coming", 0, 0)
			    	EmitGlobalSound("DOTA_Item.ClarityPotion.Activate")
			    	random_hit = 4.0
			    	u:SetModelScale(u:GetModelScale()*2.0)
			    	u.is_jingying = true
			    end
			end

			-- if (GameRules.level ==20) then
			-- 	--回光返照
			-- 	u:FindAbilityByName("abaddon_borrowed_time"):SetLevel(1)
			-- end


		    local maxhealth = u:GetBaseMaxHealth() * GameRules.gem_difficulty[GameRules.gem_nandu] * random_hit

		    local speed_t = 1.0
		    if GameRules.is_passed == true then --50关以后
		    	if string.find(guai_name, "fly") then
					maxhealth = maxhealth * 0.4
				end

		    	u:SetModelScale(u:GetModelScale()*2)

		    	--随机给2个技能
		    	for iiii =1,2 do
			    	-- u:AddAbility("tidehunter_kraken_shell")
			    	-- u:FindAbilityByName("tidehunter_kraken_shell"):SetLevel(GameRules.gem_nandu)
			    	
			    	local random_a = RandomInt(1,table.maxn(GameRules.guai_50_ability))
			    	local aaaaa = GameRules.guai_50_ability[random_a]
			    	if aaaaa == "enemy_momian" then
			    		maxhealth = maxhealth / 2
			    	end
			    	if u:FindAbilityByName(aaaaa) == nil then
			    		u:AddAbility(aaaaa)
						u:FindAbilityByName(aaaaa):SetLevel(GameRules.gem_nandu)
					end
				end

				if maxhealth > 12000 then
		    		maxhealth = 999999999
		    	else
		    		maxhealth = maxhealth * 80000
		    	end

		    	speed_t = speed_t * 2
		    end

			u:SetBaseMaxHealth(maxhealth)
			u:SetMaxHealth(maxhealth)
			u:SetHealth(maxhealth)

			u:AddNewModifier(u,nil,"modifier_bloodseeker_thirst",nil)
			u:SetBaseMoveSpeed(u:GetBaseMoveSpeed()*GameRules.gem_difficulty_speed[GameRules.gem_nandu]*speed_t)


		    u:SetHullRadius(1)

		    u:AddAbility("no_pengzhuang")
			u:FindAbilityByName("no_pengzhuang"):SetLevel(1)

			u:SetContextNum("step",1,0)
			u.damage = 1+RandomInt(0,2)
			if GameRules.level >10 and GameRules.level <20 then
				u.damage = 1+RandomInt(0,6)
			elseif GameRules.level >20 and GameRules.level <30 then
				u.damage = 1+RandomInt(0,10)
			elseif GameRules.level >30 and GameRules.level <40 then
				u.damage = 1+RandomInt(0,14)
			elseif GameRules.level >40 and GameRules.level <50 then
				u.damage = 1+RandomInt(0,18)
			elseif GameRules.level >50 and GameRules.level <60 then
				u.damage = 1+RandomInt(0,26)
			elseif GameRules.level >60 and GameRules.level <70 then
				u.damage = 1+RandomInt(0,34)
			elseif GameRules.level >70 and GameRules.level <80 then
				u.damage = 1+RandomInt(0,42)
			elseif GameRules.level >80 and GameRules.level <90 then
				u.damage = 1+RandomInt(0,50)
			elseif GameRules.level >90 and GameRules.level <100 then
				u.damage = 1+RandomInt(0,58)
			end

			if GameRules.level ==10 then
				u.damage = 80
			end
			if GameRules.level ==20 then
				u.damage = 80
			end
			if GameRules.level ==30 then
				u.damage = 80
			end
			if GameRules.level ==40 then
				u.damage = 80
			end
			if GameRules.level ==50 then
				u.damage = 80
			end
			if GameRules.level ==60 then
				u.damage = 80
			end
			if GameRules.level ==70 then
				u.damage = 80
			end
			if GameRules.level ==80 then
				u.damage = 80
			end
			if GameRules.level ==90 then
				u.damage = 80
			end
			if GameRules.level ==100 then
				u.damage = 80
			end


			u:SetBaseDamageMin(u.damage)
			u:SetBaseDamageMax(u.damage)

			u.position = u:GetAbsOrigin() 

			GameRules.guai_count = GameRules.guai_count -1
			GameRules.guai_live_count = GameRules.guai_live_count + 1



			if string.find(guai_name, "boss") then
				--PrecacheResource( "soundfile",  zr[i], context)
				GameRules.guai_count = GameRules.guai_count -100

				-- u:AddAbility("e_snow")
				-- u:FindAbilityByName("e_snow"):SetLevel(1)
			end

			if string.find(guai_name, "tester") then		
				--PrecacheResource( "soundfile",  zr[i], context)		
				GameRules.guai_count = GameRules.guai_count -100		
			end

			--u是刚刷的怪
			--目标点数组：GameRules.gem_path_all

			--命令移动
			Timers:CreateTimer(0.1, function()
				if (u:IsNull()) or (not u:IsAlive()) then
					--GameRules:SendCustomMessage(u:GetUnitName().."死亡了", 0, 0)
					return nil
				end

				if (u.target == nil) then  --无目标点
					u.target = 1
					u:MoveToPosition(GameRules.gem_path_all[u.target]+Vector(RandomInt(-5,5),RandomInt(-5,5),0))
					return 0.1
				else  --有目标点
					if GameRules.gem_path_all[u.target] ~= nil and ( u:GetAbsOrigin() - GameRules.gem_path_all[u.target] ):Length2D() <32 then
						--走到了，决定下一个动作

						if u:IsNull() == ture or u:IsAlive() == false then
							return
						end

						--主动技能
						if u.target > 1 and u:FindAbilityByName('enemy_zheguang') ~= nil and u:FindModifierByName('modifier_damage_absorb') == nil and RandomInt(1,100)<=20 then

							if u:FindAbilityByName('templar_assassin_refraction_new') == nil then
								u:AddAbility('templar_assassin_refraction_new')
								u:FindAbilityByName('templar_assassin_refraction_new'):SetLevel(u:FindAbilityByName('enemy_zheguang'):GetLevel())
							end
							local newOrder = {
						 		UnitIndex = u:entindex(), 
						 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
						 		TargetIndex = nil, --Optional.  Only used when targeting units
						 		AbilityIndex = u:FindAbilityByName('templar_assassin_refraction_new'):entindex(), --Optional.  Only used when casting abilities
						 		Position = nil, --Optional.  Only used when targeting the ground
						 		Queue = 0 --Optional.  Used for queueing up abilities
						 	}
							ExecuteOrderFromTable(newOrder)

							return 0.1
						elseif u.target > 1 and u:FindAbilityByName('enemy_shanshuo') ~= nil and 
							(u:FindAbilityByName('antimage_blink_new') == nil or u:FindAbilityByName('antimage_blink_new'):IsCooldownReady()) and RandomInt(1,100)<=10 then
							if u:FindAbilityByName('antimage_blink_new') == nil then
								u:AddAbility('antimage_blink_new')
								u:FindAbilityByName('antimage_blink_new'):SetLevel(u:FindAbilityByName('enemy_shanshuo'):GetLevel())
							end
							local shanshuo_steps = math.ceil(table.maxn(GameRules.gem_path_all) / 25)
							u.target = u.target + shanshuo_steps
							if u.target > table.maxn(GameRules.gem_path_all) then
								u.target = table.maxn(GameRules.gem_path_all)
							end
							local newOrder = {
						 		UnitIndex = u:entindex(), 
						 		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						 		TargetIndex = nil, --Optional.  Only used when targeting units
						 		AbilityIndex = u:FindAbilityByName('antimage_blink_new'):entindex(), --Optional.  Only used when casting abilities
						 		Position = GameRules.gem_path_all[u.target]+Vector(RandomInt(-5,5),RandomInt(-5,5),0), --Optional.  Only used when targeting the ground
						 		Queue = 0 --Optional.  Used for queueing up abilities
						 	}
							ExecuteOrderFromTable(newOrder)

							return 0.5
						else
							--继续走
							u.target = u.target + 1
							if u.target > table.maxn(GameRules.gem_path_all) then
								u.target = table.maxn(GameRules.gem_path_all)
							end
							if GameRules.gem_path_all[u.target] ~= nil then
								u:MoveToPosition(GameRules.gem_path_all[u.target]+Vector(RandomInt(-5,5),RandomInt(-5,5),0))
							end
							return 0.1
						end
						
						
					else
						if u:IsNull() == ture or u:IsAlive() == false then
							return
						end
						if GameRules.gem_path_all[u.target] ~= nil then
							u:MoveToPosition(GameRules.gem_path_all[u.target]+Vector(RandomInt(-5,5),RandomInt(-5,5),0))
						end
						return 0.1
					end
				end
			end)


			if GameRules.guai_count<=0 then
				GameRules.gem_is_shuaguaiing=false
			end
		end

		--判断是否有怪到达城堡
		local ShuaGuai_entity = Entities:FindByName(nil,"path7")
		local position = ShuaGuai_entity:GetAbsOrigin() 
		local direUnits = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              position,
                              nil,
                              400,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
		for aaa,unit in pairs(direUnits) do
			--对城堡造成伤害

			local damage = unit.damage

        	if string.find(unit:GetUnitName(), "boss") or string.find(unit:GetUnitName(), "tester") then
        		--BOSS, 根据血量计算伤害
        		local boss_damage = unit:GetMaxHealth() - unit:GetHealth()
        		local boss_damage_per = math.floor(boss_damage / unit:GetMaxHealth() * 100)

        		if damage >0 then 
	        		damage = math.floor(damage * (100-boss_damage_per)/100) + 10
	        	else
	        		damage = 0
	        	end

        		GameRules.gem_boss_damage_all = GameRules.gem_boss_damage_all + boss_damage

        		--GameRules:SendCustomMessage("DAMAGE +"..boss_damage, 0, 0)
        		GameRules.is_boss_entered = true
        	end

        	-- 判断闪避
        	if GameRules:GetGameModeEntity().gem_castle.shanbi ~= nil then
        		if RandomInt(0,100) < tonumber(GameRules:GetGameModeEntity().gem_castle.shanbi) then
        			EmitGlobalSound("n_creep_ghost.Death")
        			damage = 0
					local particle = ParticleManager:CreateParticle("particles/gem/immunity_sphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, GameRules:GetGameModeEntity().gem_castle) 

					Timers:CreateTimer(2, function()
						ParticleManager:DestroyParticle(particle,true)
					end)
        		end
        	end
        	-- 判断格挡
        	if GameRules:GetGameModeEntity().gem_castle.shouhu ~= nil then
    			EmitGlobalSound("Item.LotusOrb.Destroy")
    			damage = damage - tonumber(GameRules:GetGameModeEntity().gem_castle.shouhu)
    			if damage < 0 then
    				damage = 0
    			end
        	end

			GameRules:GetGameModeEntity().gem_castle_hp = GameRules:GetGameModeEntity().gem_castle_hp - damage

			CustomNetTables:SetTableValue( "game_state", "gem_life", { gem_life = GameRules:GetGameModeEntity().gem_castle_hp } );
			if damage > 0 then

				GameRules:GetGameModeEntity().wave_enemy_count = GameRules:GetGameModeEntity().wave_enemy_count - 1
				GameRules:GetGameModeEntity().win_streak = 0
				GameRules:GetGameModeEntity().perfect_this_level = false
				if GameRules:GetGameModeEntity().wave_enemy_count < 5 then
					GameRules:GetGameModeEntity().wave_enemy_count = 5
				end


				

				EmitGlobalSound("DOTA_Item.Maim")
				play_particle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_sphere_final_explosion_smoke_ti5.vpcf",PATTACH_OVERHEAD_FOLLOW,GameRules:GetGameModeEntity().gem_castle,2)
				AMHC:CreateNumberEffect(GameRules:GetGameModeEntity().gem_castle,damage,5,AMHC.MSG_DAMAGE,"red",3)

				-- for k,h in pairs(GameRules:GetGameModeEntity().hero) do
				-- 	play_particle("particles/generic_gameplay/screen_damage_indicator.vpcf",PATTACH_EYES_FOLLOW,h,2)

				-- 	-- Timers:CreateTimer(2,function()
				-- 	-- 	ParticleManager:DestroyParticle(blood_pfx,true)
				-- 	-- end)
				-- end

			end

			GameRules:GetGameModeEntity().gem_castle:SetHealth(GameRules:GetGameModeEntity().gem_castle_hp)
			-- ScreenShake(Vector(150,150,0), 320, 3.2, 2, 10000, 0, false)  --无效? vsb

			PlayerResource:IncrementDeaths(0 , 1)
			PlayerResource:IncrementDeaths(1 , 1)
			PlayerResource:IncrementDeaths(2 , 1)
			PlayerResource:IncrementDeaths(3 , 1)

			--英雄同步血量
			local ii = 0
			for ii = 0, 9 do
				if ( PlayerResource:IsValidPlayer( ii ) ) then
					local player = PlayerResource:GetPlayer(ii)
					if player ~= nil then
						local h = player:GetAssignedHero()
						if h~= nil then
							h:SetHealth(GameRules:GetGameModeEntity().gem_castle_hp)
						end
					end
				end
			end

			-- --背水一战等级调整
			-- if GameRules:GetGameModeEntity().gem_castle.beishuiyizhan ~= nil then
			-- 	local beishui_level = (100-GameRules:GetGameModeEntity().gem_castle_hp)/10+1
			-- 	-- print(beishui_level)

			-- 	GameRules:GetGameModeEntity().gem_castle:FindAbilityByName(GameRules:GetGameModeEntity().gem_castle.beishuiyizhan):SetLevel(tonumber(beishui_level))
			-- end

			--城堡被摧毁则游戏结束
			if GameRules:GetGameModeEntity().gem_castle_hp <=0 then
				GameRules.game_status = 3
				-- ShowCenterMessage("failed", 5)
				Timers:CreateTimer(20, function()
					if GameRules.level > 50 then
						GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
					else
						GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
					end
				end)
				
				send_ranking ()
				return
			end

			unit.is_entered = true

		   	unit:Destroy()
		   	GemTD:OnEntityKilled( nil )
		end

	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function GemTD:OnEntityKilled( keys )
	if keys ~= nil then
		local killed_unit = EntIndexToHScript(keys.entindex_killed)
		
		if killed_unit:GetUnitName() == "gemtd_feicuimoxiang_yinxing" then
			return
		end

		if killed_unit:GetUnitName() == "gemtd_guangzhudaobiao" then
			return
		end

		
	
		--GameRules:SendCustomMessage(killed_unit:GetUnitName().."("..killed_unit:GetMaxHealth()..") 被击杀了", 0, 0)
		--print(GameRules.is_boss_entered)
		
		if (string.find(killed_unit:GetUnitName(), "boss") or string.find(killed_unit:GetUnitName(), "tester") ) and GameRules.is_boss_entered == false  then

			GameRules.kills = GameRules.kills + 10
			for k=1,10 do
				PlayerResource:IncrementKills(0,1)
				PlayerResource:IncrementKills(1,1)
				PlayerResource:IncrementKills(2,1)
				PlayerResource:IncrementKills(3,1)
			end

			if killed_unit:GetUnitName() == "gemtd_zard_boss_fly" or killed_unit:GetUnitName() == "gemtd_kongxinnanguaren_boss" or killed_unit:GetUnitName() == "gemtd_yuediyang_boss" or killed_unit:GetUnitName() == "gemtd_gugubiao_boss_fly" then
				GameRules.kills = GameRules.kills + 5
				for k=1,5 do
					PlayerResource:IncrementKills(0,1)
					PlayerResource:IncrementKills(1,1)
					PlayerResource:IncrementKills(2,1)
					PlayerResource:IncrementKills(3,1)
				end
			end

			if killed_unit:GetUnitName() == "gemtd_roushan_boss_fly_jin" or killed_unit:GetUnitName() == "gemtd_roushan_boss_fly_bojin" then
				GameRules.kills = GameRules.kills + 10
				for k=1,10 do
					PlayerResource:IncrementKills(0,1)
					PlayerResource:IncrementKills(1,1)
					PlayerResource:IncrementKills(2,1)
					PlayerResource:IncrementKills(3,1)
				end
			end

			if GameRules.is_debug == true then
				GameRules:SendCustomMessage("kills: "..GameRules.kills, 0, 0)
			end

			--GameRules.gem_boss_damage_all = GameRules.gem_boss_damage_all + killed_unit:GetMaxHealth()
			GameRules:SendCustomMessage("#text_you_killed_the_boss", 0, 0)

			--GameRules:SendCustomMessage("DAMAGE +"..killed_unit:GetMaxHealth(), 0, 0)
			GameRules.is_boss_entered = true

			if killed_unit:GetUnitName() == "gemtd_zard_boss_fly" then
				GameRules.quest_status["q104"] = true
				show_quest()
			end
			if killed_unit:GetUnitName() == "gemtd_roushan_boss_fly_jin" then
				GameRules.quest_status["q303"] = true
				show_quest()
			end

		end

		if killed_unit.is_jingying == true then
			--GameRules.gem_boss_damage_all = GameRules.gem_boss_damage_all + killed_unit:GetMaxHealth()
			--GameRules:SendCustomMessage("DAMAGE +"..killed_unit:GetMaxHealth(), 0, 0)
			GameRules.kills = GameRules.kills + 4
			for k=1,4 do
				PlayerResource:IncrementKills(0,1)
				PlayerResource:IncrementKills(1,1)
				PlayerResource:IncrementKills(2,1)
				PlayerResource:IncrementKills(3,1)
			end
			if GameRules.is_debug == true then
				GameRules:SendCustomMessage("kills: "..GameRules.kills, 0, 0)
			end
		end

		if (not (string.find(killed_unit:GetUnitName(), "boss")) and (not killed_unit.is_jingying == true)) then
			GameRules.kills = GameRules.kills + 1
			for k=1,1 do
				PlayerResource:IncrementKills(0,1)
				PlayerResource:IncrementKills(1,1)
				PlayerResource:IncrementKills(2,1)
				PlayerResource:IncrementKills(3,1)
			end
			if GameRules.is_debug == true then
				GameRules:SendCustomMessage("kills: "..GameRules.kills, 0, 0)
			end
		end

		if keys.entindex_attacker ~= nil then
			local killer_unit = EntIndexToHScript(keys.entindex_attacker)
			local killer_owner = killer_unit:GetOwner()
			-- local killer_player_id = killer_owner:GetPlayerID()
		end

		if killed_unit~= nil and not killed_unit.is_entered == true then

			--给玩家经验
			local exp_count = 5
			if GameRules.level ==10 then
				exp_count = 300
			end
			if GameRules.level ==20 then
				exp_count = 300
			end
			if GameRules.level ==30 then
				exp_count = 300
			end
			if GameRules.level ==40 then
				exp_count = 300
			end
			if GameRules.level ==50 then
				exp_count = 300
			end
			if GameRules.level >=11 and GameRules.level <=19 then
				exp_count = 10
			end
			if GameRules.level >=21 and GameRules.level <=29 then
				exp_count = 15
			end
			if GameRules.level >=31 and GameRules.level <=39 then
				exp_count = 20
			end
			if GameRules.level >=41 and GameRules.level <=49 then
				exp_count = 25
			end
			local exp_percent = 1

			exp_count = exp_count * exp_percent
			if (killed_unit~= nil and killed_unit.is_jingying == true) then
				exp_count = exp_count * 4
			end

			local i = 0
			for i = 0, 20 do
				if ( PlayerResource:IsValidPlayer( i ) ) then
					local player = PlayerResource:GetPlayer(i)
					if player ~= nil then
						local h = player:GetAssignedHero()
						if h ~= nil then
							h:AddExperience (exp_count,0,false,false)
						end
					end
				end
			end

			--给玩家团队金钱
			if exp_count >= 100 then
				exp_count = exp_count/2
			end
			if keys.entindex_attacker ~= nil then
				local killer_unit = EntIndexToHScript(keys.entindex_attacker)
				local killer_owner = killer_unit:GetOwner()

				if killer_unit ~= nil and killer_unit:FindModifierByName("modifier_tower_tanlan") ~= nil and RandomInt(1,100)<=5 then
					exp_count = exp_count * 10
				end
			end
			AMHC:CreateNumberEffect(killed_unit,exp_count,5,AMHC.MSG_GOLD,"yellow",0)
			GameRules.team_gold = GameRules.team_gold + exp_count

			if exp_count >= 100 then
				EmitGlobalSound("General.CoinsBig")
			else
				EmitGlobalSound("General.Coins")
			end

			--同步玩家金钱
			local ii = 0
			for ii = 0, 20 do
				if ( PlayerResource:IsValidPlayer( ii ) ) then
					local player = PlayerResource:GetPlayer(ii)
					if player ~= nil then
						PlayerResource:SetGold(ii, GameRules.team_gold, true)
					end
				end
			end
			CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = GameRules.team_gold } );

		end

	end

	GameRules.guai_live_count = GameRules.guai_live_count - 1

	--判断是不是怪死光了
	if GameRules.game_status == 2 then

		--过关了
		if GameRules.guai_live_count<=0 and GameRules.gem_is_shuaguaiing == false then
			GameRules.game_status = 1

			Timers:CreateTimer(1, function()

				--统计过关时间，计算怪数量的增加
				local time_this_level = math.floor(GameRules:GetGameTime() - GameRules.stop_watch)
				-- GameRules:SendCustomMessage('time_this_level:'..time_this_level,0,0)
				-- GameRules:SendCustomMessage('win_streak_time:'..GameRules:GetGameModeEntity().win_streak_time,0,0)
				if time_this_level < GameRules:GetGameModeEntity().win_streak_time and GameRules:GetGameModeEntity().perfect_this_level then
					GameRules:GetGameModeEntity().win_streak = GameRules:GetGameModeEntity().win_streak + 1
					if GameRules:GetGameModeEntity().win_streak >= 3 then
						GameRules:SendCustomMessage('#text_win_streak_3',0,0)
						EmitGlobalSound("ui.courier_in_use")
						
						GameRules:GetGameModeEntity().win_streak = 0
						GameRules:GetGameModeEntity().wave_enemy_count = GameRules:GetGameModeEntity().wave_enemy_count + 1

						-- ameRules:SendCustomMessage('win_streak:'..GameRules:GetGameModeEntity().win_streak,0,0)
					end
				else
					GameRules:GetGameModeEntity().win_streak = 0
					-- GameRules:SendCustomMessage('no win_streak:'..GameRules:GetGameModeEntity().win_streak,0,0)
				end

				-- GameRules:SendCustomMessage('wave_enemy_count:'..GameRules:GetGameModeEntity().wave_enemy_count,0,0)

				if GameRules.level <= 50 then

					--统计本关mvp
					local mvp_tower_id = 0
					local mvp_tower_damage = 0
					for mvp_i,mvp_v in pairs(GameRules.damage) do
						local u = EntIndexToHScript(mvp_i)
						if u ~= nil and not u:IsNull()then
							if u.level == nil then
								u.level = 0
							end
							if mvp_v > mvp_tower_damage and u.level < 10 then
								mvp_tower_id = mvp_i
								mvp_tower_damage = mvp_v
							end
						end
					end
					if mvp_tower_id > 0 then
						local mvp_tower = EntIndexToHScript(mvp_tower_id)
						if mvp_tower ~= nil and not mvp_tower:IsNull() then
							--mvp_tower:AddSpeechBubble(1,"总伤害:"..mvp_tower_damage,3,0,30)

							-- createHintBubble(mvp_tower,GameRules:GetGameModeEntity().mvp_text_1..mvp_tower_damage..GameRules:GetGameModeEntity().mvp_text_2)

							play_particle("particles/events/ti6_teams/teleport_start_ti6_lvl3_mvp_phoenix.vpcf",PATTACH_ABSORIGIN_FOLLOW,mvp_tower,5)

							EmitGlobalSound("crowd.lv_01")

							CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = GameRules.level, enemy_show = mvp_tower:GetUnitName() } )

							level_up(mvp_tower,1)
							-- Timers:CreateTimer(2,function()
							-- 	createHintBubble(mvp_tower,"#text_i_level_up")
							-- end)
							
						end
					end

				end

				CustomNetTables:SetTableValue( "game_state", "damage_stat", { level = GameRules.level, damage_table = GameRules.damage , time_this_level = time_this_level, hehe = RandomInt(1,100000) } )
				
				GameRules.damage = {}
				GameRules:GetGameModeEntity().perfect_this_level = true



				--是否通关了
				-- if GameRules.level >= 50 then
				-- 	GameRules.level = GameRules.level +1
				-- 	PlayerResource:IncrementAssists(0 , 1)
				-- 	PlayerResource:IncrementAssists(1 , 1)
				-- 	PlayerResource:IncrementAssists(2 , 1)
				-- 	PlayerResource:IncrementAssists(3 , 1)
				-- 	GameRules.guai_count = 10

				-- 	-- ShowCenterMessage( "#text_win", 10 )
				-- end

				--DeepPrintTable(bad_units[1])
				

				--GameRules:SendCustomMessage("怪死光了", 0, 0)
				if (killed_unit ~= nil and string.find(killed_unit:GetUnitName(), "boss")) or GameRules.is_boss_entered ==true then
					
					GameRules.is_boss_entered = false
					-- if GameRules.level > table.maxn(GameRules.guai)+1 then
					-- 	return
					-- end
					if GameRules.level == 50 then

						GameRules:SendCustomMessage("#text_enemy_is_stonger2", 0, 0)
						ShowCenterMessage("youwin", 5)
						EmitGlobalSound("crowd.lv_03")

						Timers:CreateTimer(5, function()
							GameRules:SendCustomMessage("#text_enemy_is_stonger3", 0, 0)
							EmitGlobalSound("diretide_eventstart_Stinger")

							Timers:CreateTimer(5, function()
								GameRules.level = GameRules.level +1
								PlayerResource:IncrementAssists(0 , 1)
								PlayerResource:IncrementAssists(1 , 1)
								PlayerResource:IncrementAssists(2 , 1)
								PlayerResource:IncrementAssists(3 , 1)
								GameRules.guai_count = 10
								GameRules.game_status = 1
								start_build()
								return nil
							end)
						end)
					else
						GameRules:SendCustomMessage("#text_enemy_is_stonger", 0, 0)

						Timers:CreateTimer(5, function()
							GameRules.level = GameRules.level +1
							PlayerResource:IncrementAssists(0 , 1)
							PlayerResource:IncrementAssists(1 , 1)
							PlayerResource:IncrementAssists(2 , 1)
							PlayerResource:IncrementAssists(3 , 1)
							GameRules.guai_count = 10
							GameRules.game_status = 1
							start_build()
							return nil
						end)
					end
					
				else
					GameRules.level = GameRules.level +1
					PlayerResource:IncrementAssists(0 , 1)
					PlayerResource:IncrementAssists(1 , 1)
					PlayerResource:IncrementAssists(2 , 1)
					PlayerResource:IncrementAssists(3 , 1)
					GameRules.guai_count = 10
					GameRules.game_status = 1
					start_build()
				end
			end)
			

		end
	end

end



function GemTD:OnNPCSpawned( keys )

	local spawned_unit = EntIndexToHScript(keys.entindex)

	local spawned_unit_name = spawned_unit:GetUnitName()

	--英雄出生
	if spawned_unit:IsHero() then
		spawned_unit.ftd = 2009

		local owner = spawned_unit:GetOwner()
		local player_id = owner:GetPlayerID()


		-- print ("hero select")
		-- GameRules.gem_hero_count = GameRules.gem_hero_count + 1
		-- print ("hero_count:"..GameRules.gem_hero_count)
		-- GameRules:SendCustomMessage("实际英雄数："..GameRules.gem_hero_count, 0, 0)


		-- local particle2 = ParticleManager:CreateParticle("particles/kunkka_hehe.vpcf", PATTACH_ABSORIGIN_FOLLOW, spawned_unit)
		-- ParticleManager:SetParticleControl(particle2, 0, spawned_unit:GetAbsOrigin())
		-- spawned_unit.xxx = particle2

		--spawned_unit:AddAbility("tower_fenliejian_you")
		--spawned_unit:FindAbilityByName("tower_fenliejian_you"):SetLevel(1)

		spawned_unit:SetHullRadius(2)

		GameRules.gem_hero[player_id] = spawned_unit

		
		GameRules:SetTimeOfDay(0.8)


		--table.insert(GameRules.gem_hero,keys.entindex)

		--GameRules.gem_hero1 = spawned_unit


	end

	Timers:CreateTimer(0.5, function()
			if (spawned_unit:IsNull()) or (not spawned_unit:IsAlive()) then
				return nil
			end

			if (spawned_unit.ftd ~= 2009 and spawned_unit:GetUnitName() ~= "npc_dota_thinker" and spawned_unit:GetUnitName() ~= "npc_dota_companion" and spawned_unit:GetUnitName() ~= nil and string.len(spawned_unit:GetUnitName())>0 ) then
				
				-- print(spawned_unit:GetAttackDamage())
				if spawned_unit:GetAttackDamage()>2 or spawned_unit:GetHullRadius()>10 then
					zuobi()
					GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
					-- if GameRules.is_debug == true then
						GameRules:SendCustomMessage("非法单位: "..spawned_unit:GetUnitName(), 0, 0)
					-- end
				end

				-- if spawned_unit~=nil and spawned_unit:IsHero() == true then
				-- 	zuobi()
				-- 	GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
				-- 	-- if GameRules.is_debug == true then
				-- 		GameRules:SendCustomMessage("非法单位: "..spawned_unit:GetUnitName(), 0, 0)
				-- 		DeepPrintTable(spawned_unit)
				-- 	-- end
				-- end

				return nil
			end
		end
	)
end

function GemTD:OnGGsimida( keys )
	GameRules.game_status = 3
	send_ranking ()
	Timers:CreateTimer(20, function()
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	end)
end

function GemTD:OnPlayerSay( keys )

	local player = userid2player[keys.userid]
	local hero = EntIndexToHScript(player):GetAssignedHero()
	local heroindex = hero:GetEntityIndex()
	-- print(heroindex)
	local steam_id = playerInfoReceived[heroindex].steam_id

	local tokens =  string.split (string.trim(string.lower(keys.text)))
	if (
		tokens[1] == "-lvlup" or
		tokens[1] == "-createhero" or
		tokens[1] == "-item" or
		tokens[1] == "-refresh" or
		tokens[1] == "-startgame" or 
		tokens[1] == "-killcreeps" or
		tokens[1] == "-wtf" or 
		tokens[1] == "-disablecreepspawn" or
		tokens[1] == "-gold" or 
		tokens[1] == "-lvlup" or
		tokens[1] == "-refresh" or
		tokens[1] == "-respawn" or
		tokens[1] == "dota_create_unit"
		) then
		zuobi()
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	-- elseif (tokens[1] == "-seed" or tokens[1] == "-kaiju" or tokens[1] == "-id") then
	--	if GameRules.game_status == 0 then
	--		GameRules.game_seed = tokens[2]
	--		gemtd_randomize(tokens[2])
	--	else
	--		GameRules:SendCustomMessage("#text_seed_in_session")
	--	end
	elseif tokens[1] == "-ggsimida" then
		GameRules.game_status = 3
		send_ranking ()
		Timers:CreateTimer(20, function()
			GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		end)
	elseif tokens[1] == "-state" then
		GameRules:SendCustomMessage('game_status:'..GameRules.game_status,0,0)
	elseif tokens[1] == "-quest" then
		-- DeepPrintTable(GameRules.quest_status)
	elseif tokens[1] == "-crab" and GameRules.myself == true then
		GameRules.crab = tokens[2]
	elseif tokens[1] == "-choose" and GameRules.myself == true then
		GameRules.level = tonumber(tokens[2])
	elseif tokens[1] == "-debug" and GameRules.myself == true then
		GameRules.is_debug = true
		GameRules:SendCustomMessage("开启调试信息", 0, 0)
	elseif tokens[1] == "-undebug" and GameRules.myself == true then
		GameRules.is_debug = false
		GameRules:SendCustomMessage("关闭调试信息", 0, 0)
	elseif tokens[1] == "-map" then
		GameRules:SendCustomMessage("#show_maze_pic", 0, 0)
		CustomNetTables:SetTableValue( "game_state", "show_maze_map", {map = tokens[2]} )
	end

	CustomNetTables:SetTableValue( "game_state", "say_bubble", {text = keys.text, unit = heroindex, hehe = RandomInt(1,10000)} )

	if string.find(keys.text,"^%w%w%w%w%w%p%w%w%w%w%w%p%w%w%w%w%w$") ~= nil then
		local key = string.upper(keys.text)
		--GameRules:SendCustomMessage("玩家heroindex="..hero:entindex().."激活码: "..key, 0, 0)
		CustomNetTables:SetTableValue( "game_state", "cdkey", {user = hero:entindex(), steam_id = steam_id ,text = key,hehe = RandomInt(1,10000)})
		return
	end

	--特效测试
	if string.find(keys.text,"^e%w%w%w$") ~= nil and GameRules.myself == true then
		GameRules:SendCustomMessage("特效:"..keys.text, 0, 0)
		if hero.effect ~= nil then
			hero:RemoveAbility(hero.effect)
			hero:RemoveModifierByName('modifier_texiao_star')
		end
		hero:AddAbility(keys.text)
		hero:FindAbilityByName(keys.text):SetLevel(1)
		hero.effect = keys.text
	end

	-- if GameRules.is_debug == true then
		
	-- end
	-- local shuohuade = EntIndexToHScript(keys.userid)

	-- local player = GameRules.vUserIdToPly[keys.userid]
	-- if GameRules.is_debug == true then
	-- 	GameRules:SendCustomMessage("玩家player="..player.."说: "..keys.text, 0, 0)
	-- end
	-- if GameRules.heroindex[player] ~= nil then
	-- 	local shuohuade = EntIndexToHScript(GameRules.heroindex[player])
	-- 	--shuohuade:DestroyAllSpeechBubbles()
	-- 	--shuohuade:AddSpeechBubble(1,keys.text,3,0,30)
	-- 	createHintBubble(shuohuade,"#keys.text")
	-- end
end

function gemtd_randomize(s)
	if (not s) then
		s = tostring(RandomInt(100000, 999999))
	end
	
	hs = hash32(s)
	rng = mwc(hs)
	rng_pure = mwc()
	GameRules:GetGameModeEntity().rng ={}
	GameRules:GetGameModeEntity().rng.offset = rng:random(0)
	GameRules:GetGameModeEntity().rng.build_count = 0
		
	for i, v in pairs(GameRules.guai) do
		if (i > GameRules.random_seed_levels) then
			GameRules:GetGameModeEntity().rng[i] = rng_pure:random(0)
		else
			GameRules:GetGameModeEntity().rng[i] = rng:random(0)
		end
	end
end



--命令行走p11->p22
function path_gogogo(p11, p22, step)
	local direUnits = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              p11,
                              nil,
                              128,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
 
	for aaa,unit in pairs(direUnits) do
		if unit:GetContext("step")==step then
	   		unit:MoveToPosition(p22)
	   	end
	end
end

function path_upstep(pp, step_from, step_to)

	local direUnits = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              pp,
                              nil,
                              128,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
 
	for aaa,unit in pairs(direUnits) do
		if unit:GetContext("step")==step_from then
	   		unit:SetContextNum("step",step_to,0)
	   	end
	end
end


--开始建造
function start_build()

	GameRules.game_status = 1

	GameRules:GetGameModeEntity().gem_castle:RemoveAbility("enemy_crazy")
	GameRules:GetGameModeEntity().gem_castle:RemoveModifierByName("modifier_enemy_crazy")

	GameRules.stop_watch = nil
	GameRules.is_crazy = false

	if GameRules.guangzhudaobiao ~= nil then
		GameRules.guangzhudaobiao:ForceKill(false)
		GameRules.guangzhudaobiao:Destroy()
		GameRules.guangzhudaobiao = nil
	end

	if GameRules.level > table.maxn(GameRules.guai)+1 then
		return
	end

	if GameRules.level > 50 then
		--50关以后没有建造阶段了
		GameRules.game_status = 2
		start_shuaguai()
		return
	end

	if GameRules.is_debug == true then
		GameRules:SendCustomMessage(PlayerResource:GetSelectedHeroName(0), 0, 0)
		GameRules:SendCustomMessage(PlayerResource:GetSelectedHeroName(1), 0, 0)
		GameRules:SendCustomMessage(PlayerResource:GetSelectedHeroName(2), 0, 0)
		GameRules:SendCustomMessage(PlayerResource:GetSelectedHeroName(3), 0, 0)
	end

	if PlayerResource:GetSelectedHeroName(0) ~= nil then
		CustomNetTables:SetTableValue( "game_state", "select_hero1", { p1 = PlayerResource:GetSelectedHeroName(0), p2 = PlayerResource:GetSelectedHeroName(1), p3 = PlayerResource:GetSelectedHeroName(2), p4 = PlayerResource:GetSelectedHeroName(3) } );
	end
	
	if GameRules.level == GameRules.start_level and GameRules.is_default_builded == false then

		-- if GameRules.is_debug == true then
			-- GameRules:SendCustomMessage("放置初始石头", 0, 0)
		-- end

		local url = "http://101.200.189.65:430/gemtd/welcome?hehe="..RandomInt(1,10000).."&host="..tostring(GameRules.hostid)

		local req = CreateHTTPRequestScriptVM("GET", url)
		req:SetHTTPRequestAbsoluteTimeoutMS(20000)
		req:Send(function (result)
			local t = json.decode(result["Body"])
			if t~=nil and t["msg_schinese"]~= nil then
				GameRules:SendCustomMessage(t["msg_schinese"], 0, 0)
			end
			if t~=nil and t["msg_english"]~= nil then
				GameRules:SendCustomMessage(t["msg_english"], 0, 0)
			end
		end)

		GameRules:GetGameModeEntity().gem_map ={}
		for i=1,37 do
		    GameRules:GetGameModeEntity().gem_map[i] = {}   
		    for j=1,37 do
		       GameRules:GetGameModeEntity().gem_map[i][j] = 0
		    end
		end

		--创建初始的石头
		for i = 1,table.maxn(GameRules.default_stone[PlayerResource:GetPlayerCount()]) do
			--网格化坐标
			local x = GameRules.default_stone[PlayerResource:GetPlayerCount()][i].x
			local y = GameRules.default_stone[PlayerResource:GetPlayerCount()][i].y
			local xxx = (x-19)*128
			local yyy = (y-19)*128

			if GameRules:GetGameModeEntity().gem_map[y][x] == 0 then

				GameRules:GetGameModeEntity().gem_map[y][x]=1

				local p = Vector(xxx,yyy,128)
				p.z=1400
				local u2 = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
				u2.ftd = 2009

				u2:SetOwner(PlayerResource:GetPlayer(0))
				u2:SetControllableByPlayer(0, true)
				u2:SetForwardVector(Vector(-1,0,0))

				u2:AddAbility("no_hp_bar")
				u2:FindAbilityByName("no_hp_bar"):SetLevel(1)
				u2:RemoveModifierByName("modifier_invulnerable")
				u2:SetHullRadius(64)
			end
		end

		GameRules.is_default_builded = true

		
	end

	find_all_path()

	GameRules:SetTimeOfDay(0.3)

	EmitGlobalSound("Loot_Drop_Stinger_Legendary")
	--GameRules:SendCustomMessage("<font size='24'>#text_please_build_5_stones</font>", 0, 0)
	
	--给所有英雄建造和拆除的技能
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				local h = player:GetAssignedHero()
				if h~= nil then
					GameRules:GetGameModeEntity().is_build_ready[ii]=false

					-- if h:FindAbilityByName("gemtd_build_stone") == nil then
						
						-- createHintBubble(h,"#text_please_build_5_stones")
						h.build_level = GameRules.level

						h:FindAbilityByName("gemtd_build_stone"):SetActivated(true)
						h:FindAbilityByName("gemtd_remove"):SetActivated(true)
						h:SetMana(5.0)
					-- end

					-- if h.ability ~= nil then
					-- 	for a,va in pairs(h.ability) do
					-- 		h:RemoveAbility(a)
					-- 		h:AddAbility(a)
					-- 		if h:FindAbilityByName(a) ~= nil then
					-- 			h:FindAbilityByName(a):SetLevel(va)
					-- 		end
					-- 	end
					-- end

					--只有建造阶段能用的技能
					SetAbilityActiveStatus(h,true)
				end
			end
		end
	end

	for i=0,3 do
		if GameRules.gem_hero[i] ~= nil then
			--GameRules:SendCustomMessage("给技能"..i, 0, 0)
			local h = GameRules.gem_hero[i]
			
			GameRules:GetGameModeEntity().is_build_ready[i]=false

			-- if h:FindAbilityByName("gemtd_build_stone") == nil then

				h.build_level = GameRules.level
				h:FindAbilityByName("gemtd_build_stone"):SetActivated(true)
				h:FindAbilityByName("gemtd_remove"):SetActivated(true)

				h:SetMana(5.0)
			-- end

			-- if h.ability ~= nil then
			-- 	for a,va in pairs(h.ability) do
			-- 		h:RemoveAbility(a)
			-- 		h:AddAbility(a)
			-- 		if h:FindAbilityByName(a) ~= nil then
			-- 			h:FindAbilityByName(a):SetLevel(va)
			-- 		end
			-- 	end
			-- end

			SetAbilityActiveStatus(h,true)

		end
	end
end

--小鹿-回春
function gemtd_jidihuixue(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_huichun"):GetLevel()

	local hp_count = RandomInt(1,3*level+2)
	EmitGlobalSound("DOTAMusic_Stinger.004")

	GameRules:GetGameModeEntity().gem_castle_hp = GameRules:GetGameModeEntity().gem_castle_hp + hp_count
    if GameRules:GetGameModeEntity().gem_castle_hp > 100 then
        GameRules:GetGameModeEntity().gem_castle_hp = 100
    end
    GameRules:GetGameModeEntity().gem_castle:SetHealth(GameRules:GetGameModeEntity().gem_castle_hp)

    CustomNetTables:SetTableValue( "game_state", "gem_life", { gem_life = GameRules:GetGameModeEntity().gem_castle_hp } );
    AMHC:CreateNumberEffect(caster,hp_count,5,AMHC.MSG_MISS,"green",0)

	--英雄同步血量
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				local h = player:GetAssignedHero()
				if h~= nil then
					h:SetHealth(GameRules:GetGameModeEntity().gem_castle_hp)
				end
			end
		end
	end
	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );
end

--帕克-闪避
function gemtd_hero_shanbi(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_shanbi"):GetLevel()

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );

	--为宝石基地增加闪避buff
	GameRules:GetGameModeEntity().gem_castle.shanbi = level*5 + 5

	EmitGlobalSound("n_creep_ghost.Death")

	if GameRules:GetGameModeEntity().gem_castle.shanbi_particle ~= nil then
		ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().gem_castle.shanbi_particle,true)
	end
	local particle = ParticleManager:CreateParticle("particles/gem/immunity_sphere_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, GameRules:GetGameModeEntity().gem_castle) 
	GameRules:GetGameModeEntity().gem_castle.shanbi_particle = particle

	Timers:CreateTimer(300,function()
		GameRules:GetGameModeEntity().gem_castle.shanbi = 0
		ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().gem_castle.shanbi_particle,true)
	end)
end

--全能-守护
function gemtd_hero_shouhu(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_shouhu"):GetLevel()

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );

	--为宝石基地增加守护buff
	GameRules:GetGameModeEntity().gem_castle.shouhu = level

	EmitGlobalSound("Item.CrimsonGuard.Cast")

	if GameRules:GetGameModeEntity().gem_castle.shouhu_particle ~= nil then
		ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().gem_castle.shouhu_particle,true)
	end
	local particle = ParticleManager:CreateParticle("particles/gem/omniknight_guardian_angel_wings_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, GameRules:GetGameModeEntity().gem_castle) 
	GameRules:GetGameModeEntity().gem_castle.shouhu_particle = particle

	Timers:CreateTimer(300,function()
		GameRules:GetGameModeEntity().gem_castle.shouhu = 0
		ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().gem_castle.shouhu_particle,true)
	end)
end

--回到过去
function gemtd_hero_huidaoguoqu(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_huidaoguoqu"):GetLevel()

	if GameRules.game_status ~= 1 then
		EmitGlobalSound("General.CastFail_NoMana")
		-- createHintBubble(caster,"#text_cannot_huidaoguoqu")
		return
	end

	if GameRules:GetGameModeEntity().is_build_ready[player_id] == true then
		EmitGlobalSound("General.CastFail_NoMana")
		-- createHintBubble(caster,"#text_cannot_huidaoguoqu")
		return
	end

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );

	--开始回到过去
	for m,vm in pairs(GameRules.build_curr[player_id]) do
		local xxx = math.floor((vm:GetAbsOrigin().x+64)/128)+19
		local yyy = math.floor((vm:GetAbsOrigin().y+64)/128)+19

		GameRules:GetGameModeEntity().gem_map[yyy][xxx]=0

		if vm.ppp then
			ParticleManager:DestroyParticle(vm.ppp,true)
		end
		vm:Destroy()
	end
	find_all_path()

	GameRules.build_curr[player_id] = {}

	GameRules.build_index[player_id] = 0

	--发送merge_board_curr
	local send_pool = {}

	for c,c_unit in pairs(GameRules.build_curr[0]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[1]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[2]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[3]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	CustomNetTables:SetTableValue( "game_state", "gem_merge_board_curr", send_pool )


	caster:FindAbilityByName("gemtd_build_stone"):SetActivated(true)
	caster:FindAbilityByName("gemtd_remove"):SetActivated(true)
	--只有建造阶段能用的技能
	SetAbilityActiveStatus(caster,true)
	caster.build_level = GameRules.level
	play_particle("particles/items2_fx/refresher.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,2)
	EmitGlobalSound("DOTA_Item.Refresher.Activate")

end

--各种颜色的祈祷
function gemtd_hero_lanse(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_lanse"):GetLevel()

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );

	EmitGlobalSound("Item.DropGemShop")

	--增加几率
	caster.pray_color = 1
	caster.pray = GameRules.pray_gailv[level]
end

function gemtd_hero_danbai(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_danbai"):GetLevel()

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );

	EmitGlobalSound("Item.DropGemShop")

	--增加几率
	caster.pray_color = 4
	caster.pray = GameRules.pray_gailv[level]
end

function gemtd_hero_baise(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_baise"):GetLevel()

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );

	EmitGlobalSound("Item.DropGemShop")

	--增加几率
	caster.pray_color = 2
	caster.pray = GameRules.pray_gailv[level]
end

function gemtd_hero_hongse(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_hongse"):GetLevel()

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );

	EmitGlobalSound("Item.DropGemShop")

	--增加几率
	caster.pray_color = 7
	caster.pray = GameRules.pray_gailv[level]
end

function gemtd_hero_zise(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_zise"):GetLevel()

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );

	EmitGlobalSound("Item.DropGemShop")

	--增加几率
	caster.pray_color = 8
	caster.pray = GameRules.pray_gailv[level]
end

function gemtd_hero_lvse(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_lvse"):GetLevel()

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );

	EmitGlobalSound("Item.DropGemShop")

	--增加几率
	caster.pray_color = 5
	caster.pray = GameRules.pray_gailv[level]
end

function gemtd_hero_fense(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_fense"):GetLevel()

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );

	EmitGlobalSound("Item.DropGemShop")

	--增加几率
	caster.pray_color = 3
	caster.pray = GameRules.pray_gailv[level]
end

function gemtd_hero_huangse(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_huangse"):GetLevel()

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );

	EmitGlobalSound("Item.DropGemShop")

	--增加几率
	caster.pray_color = 6
	caster.pray = GameRules.pray_gailv[level]
end

function gemtd_hero_putong(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_putong"):GetLevel()

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );

	EmitGlobalSound("Item.DropGemShop")

	--增加几率
	caster.pray_level = "111"
	local gailv_putong = {
		[1] = 50,
		[2] = 65,
		[3] = 75,
		[4] = 80,
	}
	caster.pray_l = gailv_putong[level]
end

function gemtd_hero_wuxia(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_wuxia"):GetLevel()

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );

	EmitGlobalSound("Item.DropGemShop")

	--增加几率
	caster.pray_level = "1111"
	local gailv_wuxia = {
		[1] = 29,
		[2] = 41,
		[3] = 47,
		[4] = 50,
	}
	caster.pray_l = gailv_wuxia[level]
end

function gemtd_hero_wanmei(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_wanmei"):GetLevel()

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );

	EmitGlobalSound("Item.DropGemShop")

	--增加几率
	caster.pray_level = "11111"
	local gailv_wanmei = {
		[1] = 6,
		[2] = 14,
		[3] = 18,
		[4] = 20,
	}
	caster.pray_l = gailv_wanmei[level]
end

--风行-快速射击
function gemtd_hero_kuaisusheji(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_kuaisusheji"):GetLevel()

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );
end

--幻刺-暴击
function gemtd_hero_baoji(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_baoji"):GetLevel()

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );
end

--火枪-瞄准
function gemtd_hero_miaozhun(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_miaozhun"):GetLevel()

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );
end

--致命链接
function GemTD:OnPlayerUseAbility(keys)
	local player_id = keys.PlayerID
	if keys.abilityname == "gemtd_hero_lianjie" then
		--同步玩家金钱
		local gold_count = PlayerResource:GetGold(player_id)
		local ii = 0
		for ii = 0, 20 do
			if ( PlayerResource:IsValidPlayer( ii ) ) then
				local player = PlayerResource:GetPlayer(ii)
				if player ~= nil then
					PlayerResource:SetGold(ii, gold_count, true)
				end
			end
		end
		GameRules.team_gold = gold_count
		CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );
	end
end

--VS换
function gemtd_hero_yixinghuanwei(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_yixinghuanwei"):GetLevel()
	local target = keys.target

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );

	if target:GetUnitName() == "gemtd_castle" then
		EmitGlobalSound("General.InvalidTarget_Invulnerable")
		GameRules:SendCustomMessage("#cannot_swap_gem_castle",0,0)
		return
	end

	--go!
	if GameRules.gem_swap[player_id] == nil or GameRules.gem_swap[player_id]:IsNull() == true then
		--存
		GameRules.gem_swap[player_id] = target
		EmitGlobalSound("DOTA_Item.Daedelus.Crit")
	else
		--换
		play_particle("particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf",PATTACH_OVERHEAD_FOLLOW,target,2)
		EmitGlobalSound("DOTA_Item.Daedelus.Crit")
		local u1 = GameRules.gem_swap[player_id]
		local u2 = target
		local p1 = u1:GetAbsOrigin()
		local p2 = u2:GetAbsOrigin()
		u1:SetAbsOrigin(Vector(5000,5000,0))
		u2:SetAbsOrigin(p1)
		u1:SetAbsOrigin(p2)

		GameRules.gem_swap[player_id] = nil
	end

end

--轻移
function gemtd_hero_qingyi(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local target = keys.target

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );

	if target:GetUnitName() == "gemtd_castle" then
		EmitGlobalSound("General.InvalidTarget_Invulnerable")
		GameRules:SendCustomMessage("#cannot_swap_gem_castle",0,0)
		return
	end

	local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                              target:GetAbsOrigin(),
                              nil,
                              128,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
	if table.getn(uuu) > 0 then
		for i,v in pairs(uuu) do
			if v:GetUnitName() == "gemtd_stone" then
				play_particle("particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf",PATTACH_OVERHEAD_FOLLOW,target,2)
				EmitGlobalSound("DOTA_Item.Daedelus.Crit")
				local u1 = v
				local u2 = target
				local p1 = u1:GetAbsOrigin()
				local p2 = u2:GetAbsOrigin()
				u1:SetAbsOrigin(Vector(5000,5000,0))
				u2:SetAbsOrigin(p1)
				u1:SetAbsOrigin(p2)
				break
			end
		end
	end


end



--建造石头
function gemtd_build_stone(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local p = keys.target_points[1]

	local hero_level = caster:GetLevel()

	-- if GameRules.game_status ~= 1 then
	-- 	return
	-- end

	-- find_all_path()

	--play_particle("particles/generic_gameplay/screen_arcane_drop.vpcf",PATTACH_EYES_FOLLOW,caster,2)

	-- print("GameRules:GetGameModeEntity().hero:")
	-- for iii,jjj in pairs(GameRules:GetGameModeEntity().hero) do
	-- 	print(iii..">>>"..jjj:GetUnitName())
	-- end
	
	CustomNetTables:SetTableValue( "game_state", "disable_repick", { heroindex = caster:GetEntityIndex(), hehe = RandomInt(1,10000) } );

	--网格化坐标
	local xxx = math.floor((p.x+64)/128)+19
	local yyy = math.floor((p.y+64)/128)+19
	p.x = math.floor((p.x+64)/128)*128
	p.y = math.floor((p.y+64)/128)*128

	--GameRules:SendCustomMessage("x="..xxx..",y="..yyy, 0, 0)

	--path1和path7附近 不能造
	if xxx>=29 and yyy<=9 then
		EmitGlobalSound("ui.crafting_gem_drop")
		--caster:DestroyAllSpeechBubbles()
		--caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
		-- createHintBubble(caster,"#text_cannot_build_here")
		return
	end

	if xxx<=9 and yyy>=29 then
		EmitGlobalSound("ui.crafting_gem_drop")
		--caster:DestroyAllSpeechBubbles()
		--caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
		-- createHintBubble(caster,"#text_cannot_build_here")
		return
	end




	--附近有怪，不能造
	local uu = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              p,
                              nil,
                              192,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
	if table.getn(uu) > 0 then
		EmitGlobalSound("ui.crafting_gem_drop")
		--caster:DestroyAllSpeechBubbles()
		--caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
		-- createHintBubble(caster,"#text_cannot_build_here")
		--GameRules:SendCustomMessage("附近有怪，不能造", 0, 0)
		return
	end

	--附近有友军单位了，不能造
	local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                              p,
                              nil,
                              58,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
                              FIND_ANY_ORDER,
                              false)
	if table.getn(uuu) == 1 and uuu[1]:GetUnitName() == 'gemtd_stone' then
		uuu[1]:Destroy()
	elseif table.getn(uuu) > 0 then
		EmitGlobalSound("ui.crafting_gem_drop")
		return false
	end

	
	--路径点，不能造
	for i=1,7 do
		local p1 = Entities:FindByName(nil,"path"..i):GetAbsOrigin()
		local xxx1 = math.floor((p1.x+64)/128)+19
		local yyy1 = math.floor((p1.y+64)/128)+19
		if xxx==xxx1 and yyy==yyy1 then
			EmitGlobalSound("ui.crafting_gem_drop")
			--caster:DestroyAllSpeechBubbles()
			--caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
			-- createHintBubble(caster,"#text_cannot_build_here")
			--GameRules:SendCustomMessage("路径点，不能造", 0, 0)
			return
		end
	end
	

	--地图范围外，不能造
	if xxx<1 or xxx>37 or yyy<1 or yyy>37 then
		EmitGlobalSound("ui.crafting_gem_drop")
		--caster:DestroyAllSpeechBubbles()
		--caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
		-- createHintBubble(caster,"#text_cannot_build_here")
		--GameRules:SendCustomMessage("地图范围外，不能造", 0, 0)
		return
	end

	if (GameRules:GetGameModeEntity().gem_map == nil) then
		GameRules:GetGameModeEntity().gem_map ={}
		for i=1,37 do
		    GameRules:GetGameModeEntity().gem_map[i] = {}   
		    for j=1,37 do
		       GameRules:GetGameModeEntity().gem_map[i][j] = 0
		    end
		end
	end
	GameRules:GetGameModeEntity().gem_map[yyy][xxx]=1
	--尝试寻找路径
	find_all_path()
	--路完全堵死了，不能造
	for i=1,6 do
		if table.maxn(GameRules.gem_path[i])<1 then
			EmitGlobalSound("ui.crafting_gem_drop")
			--caster:DestroyAllSpeechBubbles()
			--caster:AddSpeechBubble(1,"#text_donnot_block_the_path",2,0,30)
			-- createHintBubble(caster,"#text_donnot_block_the_path")
			--回退地图，重新寻路
			GameRules:GetGameModeEntity().gem_map[yyy][xxx]=0

			find_all_path()
			return
		end
	end
	

	---------------------------------------------------------------------
	--至此验证ok了，可以正式开始建造石头了
	--------------------------------------------------------------------

	-- --概率用百分比来表示，所以有一百种选择
	-- --石头种类有table.maxn(GameRules.gem_tower_basic)种
	-- --所以模这两个数的乘积，下面出现的所有100 都表示百分比
	-- local hero_name = PlayerResource:GetSelectedHeroName(player_id)
	-- local conflict_solver = 0
	-- for i = 1,player_id-1 do
	-- 	if (PlayerResource:IsValidPlayer(i) and PlayerResource:GetSelectedHeroName(i) == hero_name) then
	-- 		conflict_solver = conflict_solver + 1
	-- 	end
	-- end
	-- if (conflict_solver ~= 0) then
	-- 	hero_name = hero_name .. conflict_solver
	-- end

	-- local m = 100*table.maxn(GameRules.gem_tower_basic)
	-- --local d = RandomInt(1, 100)
	-- --local ran32_modulo_m = RandomInt(1, m)
	-- --if (d < GameRules.map_similarity[hero_level]) then -- 用预设值，而不是纯随机
	-- 	-- tostring(...) 给了每一轮不同位置的点一个不同的值
	-- 	-- +offset 防御差分攻击
	-- 	-- idx 确保每次生成的格子都是唯一的
	-- 	local idx = GameRules.level * GameRules.max_grids + xxx * GameRules.max_xy + yyy + GameRules:GetGameModeEntity().rng.offset
	-- 	local ran32 = hash32( tostring(idx) ..  hero_name .. GameRules:GetGameModeEntity().rng.build_count)
	-- 	GameRules:GetGameModeEntity().rng.build_count = GameRules:GetGameModeEntity().rng.build_count + 1
	-- 	ran32 = bit.bxor(ran32, GameRules:GetGameModeEntity().rng[GameRules.level])
	-- 	ran32 = ran32 % 0x80000000
	-- 	ran32_modulo_m = ran32 % m
	-- --end
	
	local ran = RandomInt(1,100)
	local stone_level = "1"
	local curr_per = 0
	if GameRules.gem_gailv[hero_level] ~= nil then
		--Say(owner,"level:"..hero_level,false)
		for per,lv in pairs(GameRules.gem_gailv[hero_level]) do
			--Say(owner,ran..">"..per.."--"..lv,false)
			if ran>per and curr_per<=per then
				curr_per = per
				stone_level = lv
			end
		end
	end
	if caster.pray_level ~= nil and GameRules.perfected ~= true then
		if RandomInt(1,100) < tonumber(caster.pray_l) then
			stone_level = tonumber(caster.pray_level)
			-- createHintBubble(caster,"#renpinbaofa")
			GameRules.perfected = true
		end
	end
	caster.pray_level = nil
	caster.pray_l = nil

	--随机决定石头种类
	-- local ran = math.floor(ran32_modulo_m / 100) + 1

	--随机决定石头种类
	local ran = RandomInt(1,table.maxn(GameRules.gem_tower_basic))
	if caster.pray ~= nil then
		if RandomInt(1,100) < tonumber(caster.pray) then
			ran = tonumber(caster.pray_color)
			-- createHintBubble(caster,"#renpinbaofa")
		end
	end
	caster.pray_color = nil
	caster.pray = nil
	
	local create_stone_name = GameRules.gem_tower_basic[ran]..stone_level

	-- if GameRules.build_index[player_id] == 0 then
	-- 	create_stone_name = "gemtd_palayibabixi"
	-- end
	-- if GameRules.build_index[player_id] == 1 then
	-- 	create_stone_name = "gemtd_heianfeicui"
	-- end
	-- if GameRules.build_index[player_id] == 2 then
	-- 	create_stone_name = "gemtd_g11"
	-- end
	-- -- if GameRules.build_index[player_id] == 3 then
	-- -- 	create_stone_name = "gemtd_y1111"
	-- -- end
	-- -- if GameRules.build_index[player_id] == 4 then
	-- -- 	create_stone_name = "gemtd_y11111"
	-- -- end

	if GameRules.crab ~= nil then
		create_stone_name = "gemtd_"..GameRules.crab
		GameRules.crab = nil
	end

	--创建石头
	u = CreateUnitByName(create_stone_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS)
	u.ftd = 2009
    --u = AMHC:CreateUnit( create_stone_name,p,270,caster,caster:GetTeamNumber())
	u:SetOwner(caster)
	--u:SetParent(caster,caster:GetUnitName())
	u:SetControllableByPlayer(player_id, true)
	u:SetForwardVector(Vector(0,-1,0))
	u:AddAbility("no_hp_bar")
	u:FindAbilityByName("no_hp_bar"):SetLevel(1)
	u:AddAbility("gemtd_tower_new")
	u:FindAbilityByName("gemtd_tower_new"):SetLevel(1)

	EmitGlobalSound("Item.DropWorld")

	-- u:AddAbility("tower_mofa10")
	-- u:FindAbilityByName("tower_mofa10"):SetLevel(1)

	--添加玩家颜色底盘
	local particle = ParticleManager:CreateParticle("particles/gem/team_"..(player_id+1)..".vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
	u.ppp = particle


	u:RemoveModifierByName("modifier_invulnerable")
	u:SetHullRadius(64)

	GameRules.build_curr[player_id][GameRules.build_index[player_id]] = u
	GameRules.build_index[player_id] = GameRules.build_index[player_id] +1
	--GameRules:SendCustomMessage("玩家"..player_id.."建造了"..GameRules.build_index[player_id].."个石头", 0, 0)

	--发送merge_board_curr
	local send_pool = {}

	for c,c_unit in pairs(GameRules.build_curr[0]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[1]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[2]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[3]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	CustomNetTables:SetTableValue( "game_state", "gem_merge_board_curr", send_pool )

	caster:SetMana(5 - GameRules.build_index[player_id])

	if GameRules.build_index[player_id]>=5 then
		GameRules.build_index[player_id] = 0
		--GameRules:SendCustomMessage("玩家"..player_id.."选择石头", 0, 0)
		--给英雄去掉建造和拆除的技能
		--local h = PlayerResource:GetPlayer(player_id):GetAssignedHero()
		--caster:RemoveAbility("gemtd_build_stone")
		--caster:RemoveAbility("gemtd_remove")
		caster:FindAbilityByName("gemtd_build_stone"):SetActivated(false)
		caster:FindAbilityByName("gemtd_remove"):SetActivated(false)

		SetAbilityActiveStatus(caster,false)

		--caster:DestroyAllSpeechBubbles()
		--caster:AddSpeechBubble(1,"#text_please_select_a_stone",3,0,30)
		-- createHintBubble(caster,"#text_please_select_a_stone")

		--给石头增加选择技能

		-- GameRules.build_curr[player_id][1]:AddAbility("gemtd_choose_stone")
		-- GameRules.build_curr[player_id][1]:FindAbilityByName("gemtd_choose_stone"):SetLevel(1)
		-- GameRules.build_curr[player_id][2]:AddAbility("gemtd_choose_stone")
		-- GameRules.build_curr[player_id][2]:FindAbilityByName("gemtd_choose_stone"):SetLevel(1)
		-- GameRules.build_curr[player_id][3]:AddAbility("gemtd_choose_stone")
		-- GameRules.build_curr[player_id][3]:FindAbilityByName("gemtd_choose_stone"):SetLevel(1)
		-- GameRules.build_curr[player_id][4]:AddAbility("gemtd_choose_stone")
		-- GameRules.build_curr[player_id][4]:FindAbilityByName("gemtd_choose_stone"):SetLevel(1)

		--判断能不能合并成+1 +2级的
		for i=0,4 do
			local curr_name = GameRules.build_curr[player_id][i]:GetUnitName()
			local repeat_count = 0
			for j=0,4 do
				local curr_name2 = GameRules.build_curr[player_id][j]:GetUnitName()
				if curr_name == curr_name2 then
					repeat_count = repeat_count + 1
				end
			end


			local unit_name = GameRules.build_curr[player_id][i]:GetUnitName()
			local string_length = string.len(unit_name)
			local count_1  = 0
			for i=1,string_length do
				local index = string_length+1-i
				if string.sub(unit_name,index,index) == "1" then
					count_1 = count_1 + 1
				end
			end
			if count_1 >=2 then
				GameRules.build_curr[player_id][i]:AddAbility("gemtd_downgrade_stone")
				GameRules.build_curr[player_id][i]:FindAbilityByName("gemtd_downgrade_stone"):SetLevel(1)
				--风暴之锤
				if caster:FindAbilityByName("gemtd_hero_fengbaozhichui") ~= nil then
					local fengbaozhichui_level = caster:FindAbilityByName("gemtd_hero_fengbaozhichui"):GetLevel()
					GameRules.build_curr[player_id][i]:AddAbility("gemtd_downgrade_stone_fengbaozhichui")
					GameRules.build_curr[player_id][i]:FindAbilityByName("gemtd_downgrade_stone_fengbaozhichui"):SetLevel(fengbaozhichui_level)
				end
			end

			GameRules.build_curr[player_id][i]:AddAbility("gemtd_choose_stone")
			GameRules.build_curr[player_id][i]:FindAbilityByName("gemtd_choose_stone"):SetLevel(1)

			if repeat_count>=4 then
				GameRules.build_curr[player_id][i]:AddAbility("gemtd_choose_update_stone")
				GameRules.build_curr[player_id][i]:FindAbilityByName("gemtd_choose_update_stone"):SetLevel(1)
				GameRules.build_curr[player_id][i]:AddAbility("gemtd_choose_update_update_stone")
				GameRules.build_curr[player_id][i]:FindAbilityByName("gemtd_choose_update_update_stone"):SetLevel(1)

				if caster.effect ~= nil and caster.effect ~= "" then
					GameRules.build_curr[player_id][i]:AddAbility(caster.effect)
					GameRules.build_curr[player_id][i]:FindAbilityByName(caster.effect):SetLevel(1)	
					GameRules.build_curr[player_id][i].effect = caster.effect
				end

			elseif repeat_count>=2 then
				GameRules.build_curr[player_id][i]:AddAbility("gemtd_choose_update_stone")
				GameRules.build_curr[player_id][i]:FindAbilityByName("gemtd_choose_update_stone"):SetLevel(1)

				-- if caster.effect ~= nil and caster.effect ~= "" then
				-- 	GameRules.build_curr[player_id][i]:AddAbility(caster.effect)
				-- 	GameRules.build_curr[player_id][i]:FindAbilityByName(caster.effect):SetLevel(1)	
				-- 	GameRules.build_curr[player_id][i].effect = caster.effect
				-- end
			end

		end

		
		--检查能否一回合合成高级塔
		for h,h_merge in pairs(GameRules.gemtd_merge) do
			local can_merge = true
			local merge_pool = {}

			for k,k_unitname in pairs(h_merge) do
				local have_merge = false
				for c,c_unit in pairs(GameRules.build_curr[player_id]) do
					if c_unit:GetUnitName()==k_unitname then
						--有这个合成配方
						have_merge =true
						table.insert (merge_pool, c_unit)
					end
				end
				if have_merge==false then
					can_merge = false
				end
			end

			if can_merge == true then
				--可以合成，给它们增加技能
				GameRules.gemtd_pool_can_merge_1[h] = {}

				for a,a_unit in pairs(merge_pool) do
					a_unit:AddAbility(h.."1")
					a_unit:FindAbilityByName(h.."1"):SetLevel(1)
					--GameRules:SendCustomMessage("可以合成"..h, 0, 0)

					if caster.effect ~= nil and caster.effect ~= "" then
						a_unit:AddAbility(caster.effect)
						a_unit:FindAbilityByName(caster.effect):SetLevel(1)	
						a_unit.effect = caster.effect
					end

					table.insert (GameRules.gemtd_pool_can_merge_1[player_id], a_unit) 
				end
			end
		end

		--检查能否一回合合成隐藏塔
		for h,h_merge in pairs(GameRules.gemtd_merge_secret) do
			local can_merge = true
			local merge_pool = {}

			for k,k_unitname in pairs(h_merge) do
				local have_merge = false
				for c,c_unit in pairs(GameRules.build_curr[player_id]) do
					if c_unit:GetUnitName()==k_unitname then
						--有这个合成配方
						have_merge =true
						table.insert (merge_pool, c_unit)
					end
				end
				if have_merge==false then
					can_merge = false
				end
			end

			if can_merge == true then
				--可以合成，给它们增加技能
				GameRules.gemtd_pool_can_merge_1[h] = {}

				for a,a_unit in pairs(merge_pool) do
					a_unit:AddAbility(h.."1")
					a_unit:FindAbilityByName(h.."1"):SetLevel(1)
					--GameRules:SendCustomMessage("可以合成"..h, 0, 0)

					if caster.effect ~= nil and caster.effect ~= "" then
						a_unit:AddAbility(caster.effect)
						a_unit:FindAbilityByName(caster.effect):SetLevel(1)	
						a_unit.effect = caster.effect
					end

					table.insert (GameRules.gemtd_pool_can_merge_1[player_id], a_unit) 
				end
			end
		end

		--检查能否一回合合成石板
		for h,h_merge in pairs(GameRules.gemtd_merge_shiban) do
			local can_merge = true
			local merge_pool = {}

			for k,k_unitname in pairs(h_merge) do
				local have_merge = false
				for c,c_unit in pairs(GameRules.build_curr[player_id]) do
					if c_unit:GetUnitName()==k_unitname then
						--有这个合成配方
						have_merge =true
						table.insert (merge_pool, c_unit)
					end
				end
				if have_merge==false then
					can_merge = false
				end
			end

			if can_merge == true then
				--可以合成，给它们增加技能
				GameRules.gemtd_pool_can_merge_shiban[h] = {}

				for a,a_unit in pairs(merge_pool) do
					a_unit:AddAbility(h.."_sb")
					a_unit:FindAbilityByName(h.."_sb"):SetLevel(1)
					--GameRules:SendCustomMessage("可以合成"..h, 0, 0)

					if caster.effect ~= nil and caster.effect ~= "" then
						a_unit:AddAbility(caster.effect)
						a_unit:FindAbilityByName(caster.effect):SetLevel(1)	
						a_unit.effect = caster.effect
					end

					table.insert (GameRules.gemtd_pool_can_merge_shiban[player_id], a_unit) 
				end
			end
		end
	end
end

--移除石头
function gemtd_remove(keys)
	local caster = keys.caster
	local target = keys.target
	local owner =  caster:GetOwner()

	if target:GetUnitName() ~= "gemtd_stone" then
		--caster:DestroyAllSpeechBubbles()
		--caster:AddSpeechBubble(2,"#text_cannot_remove_it",3,0,30)
		-- createHintBubble(caster,"#text_cannot_remove_it")

		return
	end

	local xxx = math.floor((target:GetAbsOrigin().x+64)/128)+19
	local yyy = math.floor((target:GetAbsOrigin().y+64)/128)+19

	GameRules:GetGameModeEntity().gem_map[yyy][xxx]=0

	if target.ppp then
		ParticleManager:DestroyParticle(target.ppp,true)
	end
	target:Destroy()

	EmitGlobalSound("ui.browser_click_right")


	find_all_path()

end

--留石头的任务
function stone_quest(s)
	if s == "gemtd_d1" or s == "gemtd_d11" or s == "gemtd_d111" or s == "gemtd_d1111" or s == "gemtd_d11111"  or s == "gemtd_d111111" then
		GameRules.quest_status["q202"] = false
		show_quest()
	end
	if s == "gemtd_b1" or s == "gemtd_b11" or s == "gemtd_b111" or s == "gemtd_b1111" or s == "gemtd_b11111"  or s == "gemtd_b111111" then
		GameRules.quest_status["q203"] = false
		show_quest()
	end
	if s == "gemtd_r1" or s == "gemtd_r11" or s == "gemtd_r111" or s == "gemtd_r1111" or s == "gemtd_r11111"  or s == "gemtd_r111111" then
		GameRules.quest_status["q204"] = false
		show_quest()
	end
	if s == "gemtd_y1" or s == "gemtd_y11" or s == "gemtd_y111" or s == "gemtd_y1111" or s == "gemtd_y11111"  or s == "gemtd_y111111" then
		GameRules.quest_status["q205"] = false
		show_quest()
	end
	if s == "gemtd_p1" or s == "gemtd_p11" or s == "gemtd_p111" or s == "gemtd_p1111" or s == "gemtd_p11111"  or s == "gemtd_p111111" then
		GameRules.quest_status["q206"] = false
		show_quest()
	end
	if s == "gemtd_q1" or s == "gemtd_q11" or s == "gemtd_q111" or s == "gemtd_q1111" or s == "gemtd_q11111"  or s == "gemtd_q111111" then
		GameRules.quest_status["q207"] = false
		show_quest()
	end
	if s == "gemtd_g1" or s == "gemtd_g11" or s == "gemtd_g111" or s == "gemtd_g1111" or s == "gemtd_g11111"  or s == "gemtd_g111111" then
		GameRules.quest_status["q208"] = false
		show_quest()
	end
end

--选择石头
function choose_stone(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()

	caster:RemoveAbility("gemtd_choose_stone")
	caster:RemoveAbility("gemtd_choose_update_stone")
	caster:RemoveAbility("gemtd_choose_update_update_stone")

	for i=0,4 do
		if GameRules.build_curr[player_id][i]~=caster then
			--移除其他的石头
			local p = GameRules.build_curr[player_id][i]:GetAbsOrigin()
			--删除玩家颜色底盘
			if GameRules.build_curr[player_id][i].ppp then
				ParticleManager:DestroyParticle(GameRules.build_curr[player_id][i].ppp,true)
			end
			GameRules.build_curr[player_id][i]:Destroy()
			--用普通石头代替
			p.z=1400
			local u = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
			u.ftd = 2009

			u:SetOwner(owner)
			u:SetControllableByPlayer(player_id, true)
			u:SetForwardVector(Vector(-1,0,0))

			u:AddAbility("no_hp_bar")
			u:FindAbilityByName("no_hp_bar"):SetLevel(1)

			u:RemoveModifierByName("modifier_invulnerable")
			u:SetHullRadius(64)
		end
	end

	--移除caster，用同级的代替
	local unit_name = caster:GetUnitName()
	local p = caster:GetAbsOrigin()
	local caster_died = caster
	--删除玩家颜色底盘
	if caster.ppp then
		ParticleManager:DestroyParticle(caster.ppp,true)
	end
	caster:Destroy()

	EmitGlobalSound("ui.npe_objective_given")

	stone_quest(unit_name)

	local u = CreateUnitByName(unit_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
	u.ftd = 2009

	--u:DestroyAllSpeechBubbles()
	--u:AddSpeechBubble(1,"#"..unit_name,3,0,-30)
	-- createHintBubble(u,"#"..unit_name)

	u:SetOwner(owner)
	u:SetControllableByPlayer(player_id, true)
	u:SetForwardVector(Vector(0,-1,0))

	u:AddAbility("no_hp_bar")
	u:FindAbilityByName("no_hp_bar"):SetLevel(1)
	u:AddAbility("gemtd_tower_base")
	u:FindAbilityByName("gemtd_tower_base"):SetLevel(1)
	u:AddAbility("gemtd_tower_select")
	u:FindAbilityByName("gemtd_tower_select"):SetLevel(1)

	-- 特效测试
	-- local blood_pfx = ParticleManager:CreateParticle("particles/gem/screen_arcane_drop.vpcf", PATTACH_EYES_FOLLOW, u)
	
	-- 添加玩家颜色底盘
	local particle = ParticleManager:CreateParticle("particles/gem/team_0.vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
	u.ppp = particle

	u:RemoveModifierByName("modifier_invulnerable")
	u:SetHullRadius(64)

	table.insert (GameRules.gemtd_pool, u)

	GameRules.build_curr[player_id] = {}
	GameRules:GetGameModeEntity().is_build_ready[player_id] = true

	--发送merge_board
	local send_pool = {}
	for c,c_unit in pairs(GameRules.gemtd_pool) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	CustomNetTables:SetTableValue( "game_state", "gem_merge_board", send_pool )

	--发送merge_board_curr
	local send_pool = {}

	for c,c_unit in pairs(GameRules.build_curr[0]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[1]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[2]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[3]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	CustomNetTables:SetTableValue( "game_state", "gem_merge_board_curr", send_pool )

	finish_build()

end

function choose_update_stone(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()

	--GameRules:SendCustomMessage("选择了石头", 0, 0)
	caster:RemoveAbility("gemtd_choose_stone")
	caster:RemoveAbility("gemtd_choose_update_stone")
	caster:RemoveAbility("gemtd_choose_update_update_stone")

	for i=0,4 do
		if GameRules.build_curr[player_id][i]~=caster then
			--移除其他的石头
			local p = GameRules.build_curr[player_id][i]:GetAbsOrigin()
			--删除玩家颜色底盘
			if GameRules.build_curr[player_id][i].ppp then
				ParticleManager:DestroyParticle(GameRules.build_curr[player_id][i].ppp,true)
			end
			GameRules.build_curr[player_id][i]:Destroy()
			--用普通石头代替
			p.z=1400
			local u = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
			u.ftd = 2009

			u:SetOwner(owner)
			u:SetControllableByPlayer(player_id, true)
			u:SetForwardVector(Vector(-1,0,0))

			u:AddAbility("no_hp_bar")
			u:FindAbilityByName("no_hp_bar"):SetLevel(1)
			u:RemoveModifierByName("modifier_invulnerable")
			u:SetHullRadius(64)
		end
	end

	--移除caster，用高一级的代替
	local unit_name = caster:GetUnitName().."1"
	local p = caster:GetAbsOrigin()
	local caster_died = caster
	--删除玩家颜色底盘
	if caster.ppp then
		ParticleManager:DestroyParticle(caster.ppp,true)
	end
	caster:Destroy()

	EmitGlobalSound("ui.npe_objective_given")

	stone_quest(unit_name)

	local u = CreateUnitByName(unit_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
	u.ftd = 2009
	--u:DestroyAllSpeechBubbles()
	--u:AddSpeechBubble(1,"#"..unit_name,3,0,-30)
	-- createHintBubble(u,"#"..unit_name)

	u:SetOwner(owner)
	u:SetControllableByPlayer(player_id, true)
	u:SetForwardVector(Vector(0,-1,0))

	u:AddAbility("no_hp_bar")
	u:FindAbilityByName("no_hp_bar"):SetLevel(1)
	u:AddAbility("gemtd_tower_select")
	u:FindAbilityByName("gemtd_tower_select"):SetLevel(1)

	--添加玩家颜色底盘
	local particle = ParticleManager:CreateParticle("particles/gem/team_0.vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
	u.ppp = particle
	
	
	u:RemoveModifierByName("modifier_invulnerable")

	u:SetHullRadius(64)

	table.insert (GameRules.gemtd_pool, u)

	--AMHC:CreateNumberEffect(u,1,2,AMHC.MSG_DAMAGE,"yellow",0)


	GameRules.build_curr[player_id] = {}
	GameRules:GetGameModeEntity().is_build_ready[player_id] = true

	--发送merge_board
	local send_pool = {}
	for c,c_unit in pairs(GameRules.gemtd_pool) do
		if (not c_unit:IsNull()) then
			table.insert (send_pool, c_unit:GetUnitName())
		end
	end
	CustomNetTables:SetTableValue( "game_state", "gem_merge_board", send_pool )

	--发送merge_board_curr
	local send_pool = {}

	for c,c_unit in pairs(GameRules.build_curr[0]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[1]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[2]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[3]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	CustomNetTables:SetTableValue( "game_state", "gem_merge_board_curr", send_pool )

	finish_build()
end

function choose_update_update_stone(keys)
	--print("------------------------")
	--DeepPrintTable(keys)

	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()

	--GameRules:SendCustomMessage("选择了石头", 0, 0)
	caster:RemoveAbility("gemtd_choose_stone")
	caster:RemoveAbility("gemtd_choose_update_stone")
	caster:RemoveAbility("gemtd_choose_update_update_stone")

	for i=0,4 do
		if GameRules.build_curr[player_id][i]~=caster then
			--移除其他的石头
			local p = GameRules.build_curr[player_id][i]:GetAbsOrigin()
			--删除玩家颜色底盘
			if GameRules.build_curr[player_id][i].ppp then
				ParticleManager:DestroyParticle(GameRules.build_curr[player_id][i].ppp,true)
			end
			GameRules.build_curr[player_id][i]:Destroy()
			--用普通石头代替
			p.z=1400
			local u = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
			u.ftd = 2009

			u:SetOwner(owner)
			u:SetControllableByPlayer(player_id, true)
			u:SetForwardVector(Vector(-1,0,0))

			u:AddAbility("no_hp_bar")
			u:FindAbilityByName("no_hp_bar"):SetLevel(1)
			u:RemoveModifierByName("modifier_invulnerable")
			u:SetHullRadius(64)
		end
	end

	--移除caster，用高两级的代替
	local unit_name = caster:GetUnitName()
	if unit_name=="gemtd_y11111" or 
		unit_name=="gemtd_p11111" or
		unit_name=="gemtd_b11111" or
		unit_name=="gemtd_r11111" or
		unit_name=="gemtd_g11111" or
		unit_name=="gemtd_d11111" or
		unit_name=="gemtd_q11111" or
		unit_name=="gemtd_e11111" 
	then
		unit_name = "gemtd_zhenjiazhishi"
	else
		unit_name = unit_name.."11"
	end
	local p = caster:GetAbsOrigin()
	local caster_died = caster
	--删除玩家颜色底盘
	if caster.ppp then
		ParticleManager:DestroyParticle(caster.ppp,true)
	end
	caster:Destroy()

	EmitGlobalSound("ui.npe_objective_given")

	stone_quest(unit_name)

	local u = CreateUnitByName(unit_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
	u.ftd = 2009
	--u:DestroyAllSpeechBubbles()
	--u:AddSpeechBubble(1,"#"..unit_name,3,0,-30)
	-- createHintBubble(u,"#"..unit_name)

	u:SetOwner(owner)
	u:SetControllableByPlayer(player_id, true)
	u:SetForwardVector(Vector(0,-1,0))

	u:AddAbility("no_hp_bar")
	u:FindAbilityByName("no_hp_bar"):SetLevel(1)
	u:AddAbility("gemtd_tower_merge")
	u:FindAbilityByName("gemtd_tower_merge"):SetLevel(1)
	
	--添加玩家颜色底盘
	local particle = ParticleManager:CreateParticle("particles/gem/team_0.vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
	u.ppp = particle
	
	u:RemoveModifierByName("modifier_invulnerable")
	u:SetHullRadius(64)

	table.insert (GameRules.gemtd_pool, u)

	--AMHC:CreateNumberEffect(u,1,2,AMHC.MSG_DAMAGE,"yellow",0)


	GameRules.build_curr[player_id] = {}
	GameRules:GetGameModeEntity().is_build_ready[player_id] = true

	--发送merge_board
	local send_pool = {}
	for c,c_unit in pairs(GameRules.gemtd_pool) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	CustomNetTables:SetTableValue( "game_state", "gem_merge_board", send_pool )

	--发送merge_board_curr
	local send_pool = {}

	for c,c_unit in pairs(GameRules.build_curr[0]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[1]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[2]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[3]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	CustomNetTables:SetTableValue( "game_state", "gem_merge_board_curr", send_pool )

	finish_build()

end

function gemtd_downgrade_stone (keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()

	caster:RemoveAbility("gemtd_choose_stone")
	caster:RemoveAbility("gemtd_choose_stone_fengbaozhichui")
	caster:RemoveAbility("gemtd_choose_update_stone")
	caster:RemoveAbility("gemtd_choose_update_update_stone")

	for i=0,4 do
		if GameRules.build_curr[player_id][i]~=caster then
			--移除其他的石头
			local p = GameRules.build_curr[player_id][i]:GetAbsOrigin()
			--删除玩家颜色底盘
			if GameRules.build_curr[player_id][i].ppp then
				ParticleManager:DestroyParticle(GameRules.build_curr[player_id][i].ppp,true)
			end
			GameRules.build_curr[player_id][i]:Destroy()
			--用普通石头代替
			p.z=1400
			local u = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
			u.ftd = 2009

			u:SetOwner(owner)
			u:SetControllableByPlayer(player_id, true)
			u:SetForwardVector(Vector(-1,0,0))

			u:AddAbility("no_hp_bar")
			u:FindAbilityByName("no_hp_bar"):SetLevel(1)

			u:RemoveModifierByName("modifier_invulnerable")
			u:SetHullRadius(64)
		end
	end

	--移除caster，用降级的代替
	local unit_name = caster:GetUnitName()

	--处理成 随机降级
	local string_length = string.len(unit_name)
	local count_1  = 0
	for i=1,string_length do
		local index = string_length+1-i
		if string.sub(unit_name,index,index) == "1" then
			count_1 = count_1 + 1
		end
	end

	--GameRules:SendCustomMessage("count_1:"..count_1, 0, 0)

	if count_1>=2 then
		local del_count = RandomInt(1,count_1-1)

		if count_1==2 then
			del_count = 1
		elseif count_1==3 then
			local r = RandomInt(1,100)
			if r > 66 then
				del_count = 2
			else
				del_count = 1
			end
		elseif count_1==4 then
			local r = RandomInt(1,100)
			if r > 80 then
				del_count = 3
			elseif r > 50 then
				del_count = 2
			else
				del_count = 1
			end

		elseif count_1==5 then
			local r = RandomInt(1,100)
			if r > 90 then
				del_count = 4
			elseif r > 75 then
				del_count = 3
			elseif r > 50 then
				del_count = 2
			else
				del_count = 1
			end

		end

		--GameRules:SendCustomMessage("del_count:"..del_count, 0, 0)
		unit_name = string.sub(unit_name,1,string_length-del_count)
	end

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	--GameRules:SendCustomMessage("玩家"..player_id.."= "..gold_count, 0, 0)

	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
				--GameRules:SendCustomMessage("玩家"..ii.."= "..gold_count, 0, 0)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );

	--GameRules:SendCustomMessage("unit_name:"..unit_name, 0, 0)




	local p = caster:GetAbsOrigin()
	local caster_died = caster
	--删除玩家颜色底盘
	if caster.ppp then
		ParticleManager:DestroyParticle(caster.ppp,true)
	end
	caster:Destroy()

	EmitGlobalSound("DOTA_Item.Buckler.Activate")

	stone_quest(unit_name)

	local u = CreateUnitByName(unit_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS)
	u.ftd = 2009 
	--u:DestroyAllSpeechBubbles()
	--u:AddSpeechBubble(1,"#"..unit_name,3,0,-30)
	-- createHintBubble(u,"#"..unit_name)

	u:SetOwner(owner)
	u:SetControllableByPlayer(player_id, true)
	u:SetForwardVector(Vector(0,-1,0))

	u:AddAbility("no_hp_bar")
	u:FindAbilityByName("no_hp_bar"):SetLevel(1)
	u:AddAbility("gemtd_tower_base")
	u:FindAbilityByName("gemtd_tower_base"):SetLevel(1)
	u:AddAbility("gemtd_tower_select")
	u:FindAbilityByName("gemtd_tower_select"):SetLevel(1)
	
	--添加玩家颜色底盘
	local particle = ParticleManager:CreateParticle("particles/gem/team_0.vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
	u.ppp = particle

	u:RemoveModifierByName("modifier_invulnerable")
	u:SetHullRadius(64)

	table.insert (GameRules.gemtd_pool, u)

	GameRules.build_curr[player_id] = {}
	GameRules:GetGameModeEntity().is_build_ready[player_id] = true

	--发送merge_board
	local send_pool = {}
	for c,c_unit in pairs(GameRules.gemtd_pool) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	CustomNetTables:SetTableValue( "game_state", "gem_merge_board", send_pool )

	--发送merge_board_curr
	local send_pool = {}

	for c,c_unit in pairs(GameRules.build_curr[0]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[1]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[2]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[3]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	CustomNetTables:SetTableValue( "game_state", "gem_merge_board_curr", send_pool )

	finish_build()
end

function gemtd_downgrade_stone_fengbaozhichui (keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()

	caster:RemoveAbility("gemtd_choose_stone")
	caster:RemoveAbility("gemtd_choose_stone_fengbaozhichui")
	caster:RemoveAbility("gemtd_choose_update_stone")
	caster:RemoveAbility("gemtd_choose_update_update_stone")

	for i=0,4 do
		if GameRules.build_curr[player_id][i]~=caster then
			--移除其他的石头
			local p = GameRules.build_curr[player_id][i]:GetAbsOrigin()
			--删除玩家颜色底盘
			if GameRules.build_curr[player_id][i].ppp then
				ParticleManager:DestroyParticle(GameRules.build_curr[player_id][i].ppp,true)
			end
			GameRules.build_curr[player_id][i]:Destroy()
			--用普通石头代替
			p.z=1400
			local u = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
			u.ftd = 2009

			u:SetOwner(owner)
			u:SetControllableByPlayer(player_id, true)
			u:SetForwardVector(Vector(-1,0,0))

			u:AddAbility("no_hp_bar")
			u:FindAbilityByName("no_hp_bar"):SetLevel(1)

			u:RemoveModifierByName("modifier_invulnerable")
			u:SetHullRadius(64)
		end
	end

	--移除caster，用降级的代替
	local unit_name = caster:GetUnitName()

	--处理成 随机降级
	local string_length = string.len(unit_name)
	local count_1  = 0
	for i=1,string_length do
		local index = string_length+1-i
		if string.sub(unit_name,index,index) == "1" then
			count_1 = count_1 + 1
		end
	end

	if count_1>=2 then
		local del_count = 1

		unit_name = string.sub(unit_name,1,string_length-del_count)
	end

	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	--GameRules:SendCustomMessage("玩家"..player_id.."= "..gold_count, 0, 0)

	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
				--GameRules:SendCustomMessage("玩家"..ii.."= "..gold_count, 0, 0)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );

	--GameRules:SendCustomMessage("unit_name:"..unit_name, 0, 0)

	local p = caster:GetAbsOrigin()
	local caster_died = caster
	--删除玩家颜色底盘
	if caster.ppp then
		ParticleManager:DestroyParticle(caster.ppp,true)
	end
	caster:Destroy()

	EmitGlobalSound("DOTA_Item.Buckler.Activate")

	stone_quest(unit_name)

	local u = CreateUnitByName(unit_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS)
	u.ftd = 2009 
	--u:DestroyAllSpeechBubbles()
	--u:AddSpeechBubble(1,"#"..unit_name,3,0,-30)
	-- createHintBubble(u,"#"..unit_name)

	u:SetOwner(owner)
	u:SetControllableByPlayer(player_id, true)
	u:SetForwardVector(Vector(0,-1,0))

	u:AddAbility("no_hp_bar")
	u:FindAbilityByName("no_hp_bar"):SetLevel(1)
	u:AddAbility("gemtd_tower_base")
	u:FindAbilityByName("gemtd_tower_base"):SetLevel(1)
	u:AddAbility("gemtd_tower_select")
	u:FindAbilityByName("gemtd_tower_select"):SetLevel(1)
	
	--添加玩家颜色底盘
	local particle = ParticleManager:CreateParticle("particles/gem/team_0.vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
	u.ppp = particle

	u:RemoveModifierByName("modifier_invulnerable")
	u:SetHullRadius(64)

	table.insert (GameRules.gemtd_pool, u)

	GameRules.build_curr[player_id] = {}
	GameRules:GetGameModeEntity().is_build_ready[player_id] = true

	--发送merge_board
	local send_pool = {}
	for c,c_unit in pairs(GameRules.gemtd_pool) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	CustomNetTables:SetTableValue( "game_state", "gem_merge_board", send_pool )

	--发送merge_board_curr
	local send_pool = {}

	for c,c_unit in pairs(GameRules.build_curr[0]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[1]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[2]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[3]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	CustomNetTables:SetTableValue( "game_state", "gem_merge_board_curr", send_pool )

	finish_build()
end

--完成建造
function finish_build()

	--所有玩家都建造就绪了，开始刷怪
	if GameRules:GetGameModeEntity().is_build_ready[0]==true and GameRules:GetGameModeEntity().is_build_ready[1]==true and GameRules:GetGameModeEntity().is_build_ready[2]==true and GameRules:GetGameModeEntity().is_build_ready[3]==true then
		GameRules.game_status = 2
		start_shuaguai()

		--检查能否合成高级塔
		----GameRules:SendCustomMessage("检查能否合成高级塔", 0, 0)
		for h,h_merge in pairs(GameRules.gemtd_merge) do
			----GameRules:SendCustomMessage(h, 0, 0)
			local can_merge = true
			local merge_pool = {}

			for k,k_unitname in pairs(h_merge) do
				local have_merge = false
				for c,c_unit in pairs(GameRules.gemtd_pool) do
					if c_unit:GetUnitName()==k_unitname then
						--有这个合成配方
						have_merge =true
						table.insert (merge_pool, c_unit)
						--GameRules:SendCustomMessage("有"..k_unitname, 0, 0)
					end
				end
				if have_merge==false then
					can_merge = false
				end
			end

			if can_merge == true then
				--可以合成，给它们增加技能
				GameRules.gemtd_pool_can_merge[h] = {}

				for a,a_unit in pairs(merge_pool) do
					a_unit:RemoveAbility(h)
					a_unit:AddAbility(h)
					a_unit:FindAbilityByName(h):SetLevel(1)
					--a_unit:DestroyAllSpeechBubbles()
					--a_unit:AddSpeechBubble(1,"#text_can_merge_high_level_stone",3,0,-30)
					-- createHintBubble(a_unit,"#text_can_merge_high_level_stone")
					--GameRules:SendCustomMessage("可以合成"..h, 0, 0)

					table.insert (GameRules.gemtd_pool_can_merge[h], a_unit) 

					table.insert (GameRules.gemtd_pool_can_merge_all, h ) 
				end
			end

		end

	end
end


function merge_tower( tower_name, caster )
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()

	if GameRules.game_status ~= 2 then
		--caster:DestroyAllSpeechBubbles()
		--caster:AddSpeechBubble(1,"#text_cannot_merge_now",3,0,-30)
		createHintBubble(caster,"#text_cannot_merge_now")
		return
	end

	--辅助table，用来缩小can merge的范围
	local merge_helper = {};
	local total_level = 0

	--优先标记caster
	caster.merge_mark = 1
	merge_helper[caster:GetUnitName()] = 1

	--遍历第一遍，标记要合并的石头
	for i,i_unit in pairs(GameRules.gemtd_pool_can_merge[tower_name]) do
		if i_unit ~= caster then
			local i_name = i_unit:GetUnitName()
			if merge_helper[i_name] ==1 then
				--如果这种配件有了，这一个不作为合成的配件，直接删除合成技能
				i_unit:RemoveAbility(tower_name)
			else
				--没有的话，标记一下，一会儿把它替换成普通石头
				i_unit.merge_mark = 1
				merge_helper[i_name] = 1

				if i_unit.level == nil then
					i_unit.level = 0
				end

				if i_unit.level ~= nil and i_unit.level > 0 then
					total_level = total_level + i_unit.level
				end
			end
		end
	end

	--遍历第二遍，执行合并	
	for i,i_unit in pairs(GameRules.gemtd_pool_can_merge[tower_name]) do
		if i_unit ~= caster and i_unit.merge_mark == 1 then
			local p = i_unit:GetAbsOrigin()

			--从宝石池删除
			local delete_index = nil
			for j,j_unit in pairs(GameRules.gemtd_pool) do
				if j_unit:entindex() == i_unit:entindex() then
					table.remove(GameRules.gemtd_pool, j)
				end
			end

			--删除玩家颜色底盘
			if i_unit.ppp then
				ParticleManager:DestroyParticle(i_unit.ppp,true)
			end

			i_unit:Destroy()
			p.z=1400
			local u = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
			u.ftd = 2009

			u:SetOwner(owner)
			u:SetControllableByPlayer(player_id, true)
			u:SetForwardVector(Vector(-1,0,0))

			u:AddAbility("no_hp_bar")
			u:FindAbilityByName("no_hp_bar"):SetLevel(1)
			u:RemoveModifierByName("modifier_invulnerable")
			u:SetHullRadius(64)
		end
	end

	--替换caster
	local p = caster:GetAbsOrigin()

	for j,j_unit in pairs(GameRules.gemtd_pool) do
		if j_unit:entindex() == caster:entindex() then
			table.remove(GameRules.gemtd_pool, j)
		end
	end



	--删除玩家颜色底盘
	if caster.ppp then
		ParticleManager:DestroyParticle(caster.ppp,true)
	end

	if caster.level == nil then
		caster.level = 0
	end

	if caster.level ~= nil and caster.level > 0 then
		total_level = total_level + caster.level
	end
	caster:Destroy()

	local u = CreateUnitByName(tower_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
	u.ftd = 2009
	--u:DestroyAllSpeechBubbles()
	--u:AddSpeechBubble(1,"#"..tower_name,3,0,-30)
	createHintBubble(u,"#"..tower_name)

	if tower_name == "gemtd_huguoshenyishi" then
		local random_attack = RandomInt(1,1024)
		u:SetBaseDamageMin(random_attack)
		u:SetBaseDamageMax(random_attack)
		GameRules:SendCustomMessage("-random: "..random_attack,0,0)
	end
	
	u:SetOwner(owner)
	u:SetControllableByPlayer(player_id, true)
	u:SetForwardVector(Vector(0,-1,0))

	u.is_merged = true
	u.level = 0

	u:AddAbility("no_hp_bar")
	u:FindAbilityByName("no_hp_bar"):SetLevel(1)
	EmitGlobalSound("Loot_Drop_Stinger_Mythical")

	u:AddAbility("gemtd_tower_merge")
	u:FindAbilityByName("gemtd_tower_merge"):SetLevel(1)

	--天然祖母绿，获取技能
	if tower_name == "gemtd_tianranzumulv" then
		local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
	                              u:GetAbsOrigin(),
	                              nil,
	                              128,
	                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	                              DOTA_UNIT_TARGET_ALL,
	                              DOTA_UNIT_TARGET_FLAG_RANGED_ONLY,
	                              FIND_ANY_ORDER,
	                              false)
		if table.maxn(uuu) > 0 then
			local luckydog = uuu[RandomInt(1,table.maxn(uuu))]
			local times = 0
			while (luckydog==nil or luckydog:GetUnitName()=="gemtd_tianranzumulv") and times<500 do
				luckydog = uuu[RandomInt(1,table.maxn(uuu))]
				times = times+1
			end
			--偷攻击
			-- GameRules:SendCustomMessage('attack--> '..luckydog:GetUnitName(),0,0)
			-- GameRules:SendCustomMessage('attack1--> '..luckydog:GetBaseDamageMin(),0,0)
			-- GameRules:SendCustomMessage('attack2--> '..luckydog:GetBaseDamageMax(),0,0)

			-- u:SetBaseAttackRange(luckydog:GetBaseAttackRange())
			-- u:SetBaseAttackTime(luckydog:GetBaseAttackTime())
			-- u:SetProjectileSpeed(luckydog:GetProjectileSpeed())

			-- u:SetBaseDamageMin(luckydog:GetBaseDamageMin())
			-- u:SetBaseDamageMax(luckydog:GetBaseDamageMax())
			u:SetRangedProjectileName(luckydog:GetRangedProjectileName())

			--偷3个技能
			local steal_table = {}
			for uuuuu,vvvvv in pairs(uuu) do
				for uuuu,vvvv in pairs(GameRules.stealable_ability_pool) do
					if vvvvv:HasAbility(vvvv) then
						if vvvvv:GetUnitName()~="gemtd_tianranzumulv" then
							table.insert(steal_table,vvvv)
						end
					end
				end
			end

			if table.maxn(steal_table) <1 then
				return
			end

			local random_count = 0
			local ability_count = 0
			while random_count<100 and ability_count<3 do
				local random_a = steal_table[RandomInt(1,table.maxn(steal_table))]
				if u:HasAbility(random_a) == false then
					u:AddAbility(random_a)
					u:FindAbilityByName(random_a):SetLevel(1)
					ability_count = ability_count + 1
					-- GameRules:SendCustomMessage('ability--> '..random_a,0,0)
				end
				random_count = random_count + 1
			end

			play_particle("particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_force.vpcf",PATTACH_OVERHEAD_FOLLOW,u,3)
			EmitGlobalSound("Hero_Rubick.SpellSteal.Cast")

		end
	end

	--添加玩家颜色底盘
	--local particle = ParticleManager:CreateParticle("particles/gem/team_"..(player_id+1)..".vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
	--u.ppp = particle

	--攻击加成奖励
	-- u.kill_count = total_kills
	--GameRules:SendCustomMessage(u:GetUnitName().."合并击杀数："..u.kill_count, 0, 0)

	--合并等级！
	if total_level > 0 then 
		level_up(u,total_level)
	end
	
	
	u:RemoveModifierByName("modifier_invulnerable")
	u:SetHullRadius(64)

	table.insert(GameRules.gemtd_pool, u)

	GameRules.gemtd_pool_can_merge[tower_name] = {}

	--发送merge_board
	local send_pool = {}
	for c,c_unit in pairs(GameRules.gemtd_pool) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	CustomNetTables:SetTableValue( "game_state", "gem_merge_board", send_pool )

	--发送merge_board_curr
	local send_pool = {}

	for c,c_unit in pairs(GameRules.build_curr[0]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[1]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[2]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[3]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	CustomNetTables:SetTableValue( "game_state", "gem_merge_board_curr", send_pool )

	--先清空合成技能
	for i,j in pairs(GameRules.gemtd_pool_can_merge_all) do
		for k,i_unit in pairs(GameRules.gemtd_pool_can_merge[j]) do
			if ( not i_unit:IsNull()) and ( i_unit:IsAlive()) then
				i_unit:RemoveAbility(j)
			end
			
		end
	end
	GameRules.gemtd_pool_can_merge_all = {}

	--检查能否合成高级塔
	for h,h_merge in pairs(GameRules.gemtd_merge) do
		----GameRules:SendCustomMessage(h, 0, 0)
		local can_merge = true
		local merge_pool = {}

		for k,k_unitname in pairs(h_merge) do
			local have_merge = false
			for c,c_unit in pairs(GameRules.gemtd_pool) do
				if c_unit:GetUnitName()==k_unitname then
					--有这个合成配方
					have_merge =true
					table.insert (merge_pool, c_unit)
					--GameRules:SendCustomMessage("有"..k_unitname, 0, 0)
				end
			end
			if have_merge==false then
				can_merge = false
			end
		end

		if can_merge == true then
			--可以合成，给它们增加技能
			GameRules.gemtd_pool_can_merge[h] = {}

			for a,a_unit in pairs(merge_pool) do
				a_unit:RemoveAbility(h)
				a_unit:AddAbility(h)
				a_unit:FindAbilityByName(h):SetLevel(1)
				--GameRules:SendCustomMessage("可以合成"..h, 0, 0)

				table.insert (GameRules.gemtd_pool_can_merge[h], a_unit) 

				table.insert (GameRules.gemtd_pool_can_merge_all, h ) 
			end
		end
	end
end

--一回合合成
function merge_tower1( tower_name, caster )

	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()

	--GameRules:SendCustomMessage("选择了石头", 0, 0)
	caster:RemoveAbility(tower_name.."1")

	for i=0,4 do
		if GameRules.build_curr[player_id][i]~=caster then
			--移除其他的石头
			local p = GameRules.build_curr[player_id][i]:GetAbsOrigin()
			--删除玩家颜色底盘
			if GameRules.build_curr[player_id][i].ppp then
				ParticleManager:DestroyParticle(GameRules.build_curr[player_id][i].ppp,true)
			end
			GameRules.build_curr[player_id][i]:Destroy()
			--用普通石头代替
			p.z=1400
			local u = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
			u.ftd = 2009

			u:SetOwner(owner)
			u:SetControllableByPlayer(player_id, true)
			u:SetForwardVector(Vector(-1,0,0))

			u:AddAbility("no_hp_bar")
			u:FindAbilityByName("no_hp_bar"):SetLevel(1)
			u:RemoveModifierByName("modifier_invulnerable")
			u:SetHullRadius(64)
		end
	end

	--移除caster，用高两级的代替
	local unit_name = tower_name
	local p = caster:GetAbsOrigin()
	local caster_died = caster
	--删除玩家颜色底盘
	if caster.ppp then
		ParticleManager:DestroyParticle(caster.ppp,true)
	end
	caster:Destroy()

	local u = CreateUnitByName(unit_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
	u.ftd = 2009
	--u:DestroyAllSpeechBubbles()
	--u:AddSpeechBubble(1,"#"..unit_name,3,0,-30)

	if unit_name == "gemtd_huguoshenyishi" then
		local random_attack = RandomInt(1,1024)
		u:SetBaseDamageMin(random_attack)
		u:SetBaseDamageMax(random_attack)
		GameRules:SendCustomMessage("-random: "..random_attack,0,0)
	end

	u:SetOwner(owner)
	u:SetControllableByPlayer(player_id, true)
	u:SetForwardVector(Vector(0,-1,0))

	u.is_merged = true
	u.kill_count = 0

	u:AddAbility("no_hp_bar")
	u:FindAbilityByName("no_hp_bar"):SetLevel(1)
	u:AddAbility("gemtd_tower_merge")
	u:FindAbilityByName("gemtd_tower_merge"):SetLevel(1)
	EmitGlobalSound("Loot_Drop_Stinger_Mythical")
	
	--添加玩家颜色底盘
	local particle = ParticleManager:CreateParticle("particles/gem/team_0.vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
	u.ppp = particle
	
	u:RemoveModifierByName("modifier_invulnerable")
	u:SetHullRadius(64)

	table.insert (GameRules.gemtd_pool, u)

	--AMHC:CreateNumberEffect(u,1,2,AMHC.MSG_DAMAGE,"yellow",0)


	GameRules.build_curr[player_id] = {}
	GameRules:GetGameModeEntity().is_build_ready[player_id] = true

	--发送merge_board
	local send_pool = {}
	for c,c_unit in pairs(GameRules.gemtd_pool) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	CustomNetTables:SetTableValue( "game_state", "gem_merge_board", send_pool )

	--发送merge_board_curr
	local send_pool = {}

	for c,c_unit in pairs(GameRules.build_curr[0]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[1]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[2]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[3]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	CustomNetTables:SetTableValue( "game_state", "gem_merge_board_curr", send_pool )

	finish_build()
end

function gemtd_baiyin( keys )
	local caster = keys.caster
	merge_tower( "gemtd_baiyin", caster )

	GameRules.quest_status["q101"] = false
	show_quest()
end

function gemtd_baiyinqishi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_baiyinqishi", caster )
end

function gemtd_kongqueshi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_kongqueshi", caster )

	GameRules.quest_status["q102"] = false
	show_quest()
end

function gemtd_xianyandekongqueshi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_xianyandekongqueshi", caster )
end

function gemtd_xingcaihongbaoshi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_xingcaihongbaoshi", caster )

	GameRules.quest_status["q103"] = false
	show_quest()
end

function gemtd_xuehonghuoshan( keys )
	local caster = keys.caster
	merge_tower( "gemtd_xuehonghuoshan", caster )
end

function gemtd_yu( keys )
	local caster = keys.caster
	merge_tower( "gemtd_yu", caster )

	GameRules.quest_status["q201"] = false
	show_quest()
end

function gemtd_jixiangdezhongguoyu( keys )
	local caster = keys.caster
	merge_tower( "gemtd_jixiangdezhongguoyu", caster )
end

function gemtd_furongshi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_furongshi", caster )
end

function gemtd_mirendeqingjinshi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_mirendeqingjinshi", caster )
end

function gemtd_heianfeicui( keys )
	local caster = keys.caster
	merge_tower( "gemtd_heianfeicui", caster )
end

function gemtd_feicuimoxiang( keys )
	local caster = keys.caster
	merge_tower( "gemtd_feicuimoxiang", caster )
end

function gemtd_huangcailanbaoshi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_huangcailanbaoshi", caster )
end

function gemtd_palayibabixi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_palayibabixi", caster )
end

function gemtd_heisemaoyanshi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_heisemaoyanshi", caster )
end

function gemtd_hongshanhu( keys )
	local caster = keys.caster
	merge_tower( "gemtd_hongshanhu", caster )
end

function gemtd_huaguoshanxiandan( keys )
	local caster = keys.caster
	merge_tower( "gemtd_huaguoshanxiandan", caster )
end

function gemtd_jin( keys )
	local caster = keys.caster
	merge_tower( "gemtd_jin", caster )
end

function gemtd_aijijin( keys )
	local caster = keys.caster
	merge_tower( "gemtd_aijijin", caster )
end

function gemtd_shenhaizhenzhu( keys )
	local caster = keys.caster
	merge_tower( "gemtd_shenhaizhenzhu", caster )

	GameRules.quest_status["q301"] = false
	show_quest()
end

function gemtd_haiyangqingyu( keys )
	local caster = keys.caster
	merge_tower( "gemtd_haiyangqingyu", caster )
end

function gemtd_fenhongzuanshi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_fenhongzuanshi", caster )
end

function gemtd_jixueshi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_jixueshi", caster )
end

function gemtd_gudaidejixueshi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_gudaidejixueshi", caster )
end

function gemtd_you238( keys )
	local caster = keys.caster
	merge_tower( "gemtd_you238", caster )
end

function gemtd_you235( keys )
	local caster = keys.caster
	merge_tower( "gemtd_you235", caster )
end
function gemtd_juxingfenhongzuanshi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_juxingfenhongzuanshi", caster )
end
function gemtd_jingxindiaozhuodepalayibabixi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_jingxindiaozhuodepalayibabixi", caster )
end

function gemtd_tianranzumulv( keys )
	local caster = keys.caster
	merge_tower( "gemtd_tianranzumulv", caster )
end

function gemtd_keyinuoerguangmingzhishan( keys )
	local caster = keys.caster
	merge_tower( "gemtd_keyinuoerguangmingzhishan", caster )
end

function gemtd_shuaibiankaipayou( keys )
	local caster = keys.caster
	merge_tower( "gemtd_shuaibiankaipayou", caster )
end

function gemtd_heiwangzihuangguanhongbaoshi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_heiwangzihuangguanhongbaoshi", caster )
end
function gemtd_xingguanglanbaoshi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_xingguanglanbaoshi", caster )
end
function gemtd_haibao( keys )
	local caster = keys.caster
	merge_tower( "gemtd_haibao", caster )
end
function gemtd_yijiazhishi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_yijiazhishi", caster )
end
function gemtd_huguoshenyishi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_huguoshenyishi", caster )
end
function gemtd_jingangshikulinan( keys )
	local caster = keys.caster
	merge_tower( "gemtd_jingangshikulinan", caster )
end
function gemtd_sililankazhixing( keys )
	local caster = keys.caster
	merge_tower( "gemtd_sililankazhixing", caster )
end

--一回合合成的
function gemtd_baiyin1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_baiyin", caster )

	GameRules.quest_status["q101"] = false
	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_baiyinqishi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_baiyinqishi", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_kongqueshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_kongqueshi", caster )

	GameRules.quest_status["q102"] = false
	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_xianyandekongqueshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_xianyandekongqueshi", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_xingcaihongbaoshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_xingcaihongbaoshi", caster )

	GameRules.quest_status["q103"] = false
	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_xuehonghuoshan1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_xuehonghuoshan", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_yu1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_yu", caster )

	GameRules.quest_status["q106"] = false
	GameRules.quest_status["q201"] = false
	show_quest()
end

function gemtd_jixiangdezhongguoyu1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_jixiangdezhongguoyu", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_furongshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_furongshi", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_mirendeqingjinshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_mirendeqingjinshi", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_heianfeicui1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_heianfeicui", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_feicuimoxiang1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_feicuimoxiang", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_huangcailanbaoshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_huangcailanbaoshi", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_palayibabixi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_palayibabixi", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_heisemaoyanshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_heisemaoyanshi", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_hongshanhu1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_hongshanhu", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_jin1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_jin", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_aijijin1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_aijijin", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_shenhaizhenzhu1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_shenhaizhenzhu", caster )

	GameRules.quest_status["q106"] = false
	GameRules.quest_status["q301"] = false
	show_quest()
end

function gemtd_haiyangqingyu1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_haiyangqingyu", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_fenhongzuanshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_fenhongzuanshi", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_jixueshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_jixueshi", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_gudaidejixueshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_gudaidejixueshi", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_you2381( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_you238", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_you2351( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_you235", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end
function gemtd_juxingfenhongzuanshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_juxingfenhongzuanshi", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end
function gemtd_jingxindiaozhuodepalayibabixi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_jingxindiaozhuodepalayibabixi", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end
function gemtd_huaguoshanxiandan1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_huaguoshanxiandan", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_tianranzumulv1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_tianranzumulv", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_keyinuoerguangmingzhishan1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_keyinuoerguangmingzhishan", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_shuaibiankaipayou1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_shuaibiankaipayou", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end

function gemtd_heiwangzihuangguanhongbaoshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_heiwangzihuangguanhongbaoshi", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end
function gemtd_xingguanglanbaoshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_xingguanglanbaoshi", caster )

	GameRules.quest_status["q106"] = false
	show_quest()
end
function gemtd_haibao1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_haibao", caster )
end

--隐藏的
function gemtd_yijiazhishi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_yijiazhishi", caster )

	GameRules.quest_status["q106"] = false
	GameRules.quest_status["q108"] = true
	show_quest()
end
function gemtd_huguoshenyishi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_huguoshenyishi", caster )

	GameRules.quest_status["q106"] = false
	GameRules.quest_status["q108"] = true
	show_quest()
end
function gemtd_jingangshikulinan1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_jingangshikulinan", caster )

	GameRules.quest_status["q106"] = false
	GameRules.quest_status["q108"] = true
	show_quest()
end
function gemtd_sililankazhixing1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_sililankazhixing", caster )

	GameRules.quest_status["q106"] = false
	GameRules.quest_status["q108"] = true
	show_quest()
end
function gemtd_geluanshi1( keys )
	local caster = keys.caster
	-- if RandomInt(1,5) <= 1 then
		merge_tower1( "gemtd_geluanshi", caster )
	-- else
	-- 	merge_tower1( "gemtd_stone", caster )
	-- 	GameRules:SendCustomMessage("鸽了。", 0, 0)
	-- end

	GameRules.quest_status["q106"] = false
	GameRules.quest_status["q108"] = true
	show_quest()
end
function gemtd_heiyaoshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_heiyaoshi", caster )

	GameRules.quest_status["q106"] = false
	GameRules.quest_status["q108"] = true
	show_quest()
end
function gemtd_manao1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_manao", caster )

	GameRules.quest_status["q106"] = false
	GameRules.quest_status["q108"] = true
	show_quest()
end
function gemtd_ranshaozhishi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_ranshaozhishi", caster )

	GameRules.quest_status["q106"] = false
	GameRules.quest_status["q108"] = true
	show_quest()
end
function gemtd_xiameishi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_xiameishi", caster )

	GameRules.quest_status["q106"] = false
	GameRules.quest_status["q108"] = true
	show_quest()
end

--石板
function gemtd_youbushiban_sb( keys )
	local caster = keys.caster
	merge_shiban( "gemtd_youbushiban", "naga_siren_ensnare", 10, caster )
end
function gemtd_zhangqishiban_sb( keys )
	local caster = keys.caster
	merge_shiban( "gemtd_zhangqishiban", "new_venomous_gale", 10, caster )
end
function gemtd_zuzhoushiban_sb( keys )
	local caster = keys.caster
	merge_shiban( "gemtd_zuzhoushiban", "new_maledict", 10, caster )
end
function gemtd_hongliushiban_sb( keys )
	local caster = keys.caster
	merge_shiban( "gemtd_hongliushiban", "new_torrent", 10, caster )
end
function gemtd_haojiaoshiban_sb( keys )
	local caster = keys.caster
	merge_shiban( "gemtd_haojiaoshiban", "new_haojiao", 10, caster )
end
-- function gemtd_fukongshiban_sb( keys )
-- 	local caster = keys.caster
-- 	merge_shiban( "gemtd_fukongshiban", "new_telekinesis", 10, caster )
-- end
function gemtd_suanwushiban_sb( keys )
	local caster = keys.caster
	merge_shiban( "gemtd_suanwushiban", "new_acid_spray", 10, caster )
end
function gemtd_mabishiban_sb( keys )
	local caster = keys.caster
	merge_shiban( "gemtd_mabishiban", "new_cask", 10, caster )
end

function merge_shiban( shiban_name, shiban_ability, shiban_cd, caster )

	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()

	local p = owner:GetAbsOrigin()
		--网格化坐标
	local xxx = math.floor((p.x+64)/128)+19
	local yyy = math.floor((p.y+64)/128)+19
	p.x = math.floor((p.x+64)/128)*128
	p.y = math.floor((p.y+64)/128)*128

	--path1和path7附近 不能造
	if xxx>=29 and yyy<=9 then
		EmitGlobalSound("ui.crafting_gem_drop")
		--caster:DestroyAllSpeechBubbles()
		--caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
		createHintBubble(caster,"#text_cannot_build_here")
		return
	end

	if xxx<=9 and yyy>=29 then
		EmitGlobalSound("ui.crafting_gem_drop")
		--caster:DestroyAllSpeechBubbles()
		--caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
		createHintBubble(caster,"#text_cannot_build_here")
		return
	end

	--附近有怪，不能造
	local uu = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              p,
                              nil,
                              192,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
	if table.getn(uu) > 0 then
		EmitGlobalSound("ui.crafting_gem_drop")
		--caster:DestroyAllSpeechBubbles()
		--caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
		createHintBubble(caster,"#text_cannot_build_here")
		--GameRules:SendCustomMessage("附近有怪，不能造", 0, 0)
		return
	end

	--附近有友军单位了，不能造
	local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                              p,
                              nil,
                              58,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_BASIC,
                              DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
                              FIND_ANY_ORDER,
                              false)
	if table.getn(uuu) > 0 then
		EmitGlobalSound("ui.crafting_gem_drop")
		--caster:DestroyAllSpeechBubbles()
		--caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
		createHintBubble(caster,"#text_cannot_build_here")
		--GameRules:SendCustomMessage("附近有友军单位了，不能造", 0, 0)
		return
	end

	
	--路径点，不能造
	for i=1,7 do
		local p1 = Entities:FindByName(nil,"path"..i):GetAbsOrigin()
		local xxx1 = math.floor((p1.x+64)/128)+19
		local yyy1 = math.floor((p1.y+64)/128)+19
		if xxx==xxx1 and yyy==yyy1 then
			EmitGlobalSound("ui.crafting_gem_drop")
			--caster:DestroyAllSpeechBubbles()
			--caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
			createHintBubble(caster,"#text_cannot_build_here")
			--GameRules:SendCustomMessage("路径点，不能造", 0, 0)
			return
		end
	end
		

	--地图范围外，不能造
	if xxx<1 or xxx>37 or yyy<1 or yyy>37 then
		EmitGlobalSound("ui.crafting_gem_drop")
		--caster:DestroyAllSpeechBubbles()
		--caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
		createHintBubble(caster,"#text_cannot_build_here")
		--GameRules:SendCustomMessage("地图范围外，不能造", 0, 0)
		return
	end

	--local caster = keys.caster
	--merge_tower1( "gemtd_zhiliushiban", caster )

	local u = CreateUnitByName(shiban_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
	u.ftd = 2009

	u:SetOwner(owner)
	u:SetControllableByPlayer(player_id, true)

	u:AddAbility("no_hp_bar")
	u:FindAbilityByName("no_hp_bar"):SetLevel(1)
	u:RemoveModifierByName("modifier_invulnerable")
	u:SetHullRadius(64)

	table.insert(GameRules.gemtd_pool, u)

	u:SetForwardVector(Vector(1,0,0))

	u.is_merged = true
	u.kill_count = 0

	u:AddAbility("gemtd_tower_merge")
	u:FindAbilityByName("gemtd_tower_merge"):SetLevel(1)
	EmitGlobalSound("Loot_Drop_Stinger_Rare")

	for i=0,4 do
		local p = GameRules.build_curr[player_id][i]:GetAbsOrigin()
		--删除玩家颜色底盘
		if GameRules.build_curr[player_id][i].ppp then
			ParticleManager:DestroyParticle(GameRules.build_curr[player_id][i].ppp,true)
		end
		GameRules.build_curr[player_id][i]:Destroy()
		--用普通石头代替
		p.z=1400
		local u = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
		u.ftd = 2009

		u:SetOwner(owner)
		u:SetControllableByPlayer(player_id, true)
		u:SetForwardVector(Vector(-1,0,0))

		u:AddAbility("no_hp_bar")
		u:FindAbilityByName("no_hp_bar"):SetLevel(1)
		u:RemoveModifierByName("modifier_invulnerable")
		u:SetHullRadius(64)
	end

	GameRules.build_curr[player_id] = {}
	GameRules:GetGameModeEntity().is_build_ready[player_id] = true

	--发送merge_board
	local send_pool = {}
	for c,c_unit in pairs(GameRules.gemtd_pool) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	CustomNetTables:SetTableValue( "game_state", "gem_merge_board", send_pool )

	--发送merge_board_curr
	local send_pool = {}

	for c,c_unit in pairs(GameRules.build_curr[0]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[1]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[2]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	for c,c_unit in pairs(GameRules.build_curr[3]) do
		table.insert (send_pool, c_unit:GetUnitName())
	end
	CustomNetTables:SetTableValue( "game_state", "gem_merge_board_curr", send_pool )

	
	finish_build()

	--开启石板的计时器
	Timers:CreateTimer(0.1,function()
		
		local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                          u:GetAbsOrigin(),
                          nil,
                          128,
                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                          DOTA_UNIT_TARGET_BASIC,
                          DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                          FIND_ANY_ORDER,
                          false)
		if table.maxn(uuu) > 0 then

			local unluckydog = uuu[1]
			-- GameRules:SendCustomMessage(unluckydog:GetUnitName(),0,0)
			--对unluckydog施暴
			local uu = CreateUnitByName("gemtd_feicuimoxiang_yinxing", u:GetAbsOrigin() ,false,nil,nil, DOTA_TEAM_GOODGUYS) 
			uu.ftd = 2009

			uu:AddAbility(shiban_ability)
			uu:FindAbilityByName(shiban_ability):SetLevel(5-PlayerResource:GetPlayerCount())
			Timers:CreateTimer(0.05,function()
				if shiban_ability == "naga_siren_ensnare" or shiban_ability == "new_telekinesis" or shiban_ability == "new_cask" then
					local newOrder = {
				 		UnitIndex = uu:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				 		TargetIndex = unluckydog:entindex(), --Optional.  Only used when targeting units
				 		AbilityIndex = uu:FindAbilityByName(shiban_ability):entindex(), --Optional.  Only used when casting abilities
				 		Position = nil, --Optional.  Only used when targeting the ground
				 		Queue = 0 --Optional.  Used for queueing up abilities
				 	}
					ExecuteOrderFromTable(newOrder)
				elseif shiban_ability == "new_haojiao" then
					local newOrder = {
				 		UnitIndex = uu:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				 		TargetIndex = unluckydog:entindex(), --Optional.  Only used when targeting units
				 		AbilityIndex = uu:FindAbilityByName(shiban_ability):entindex(), --Optional.  Only used when casting abilities
				 		Position = nil, --Optional.  Only used when targeting the ground
				 		Queue = 0 --Optional.  Used for queueing up abilities
				 	}
					ExecuteOrderFromTable(newOrder)
				else
					local newOrder = {
				 		UnitIndex = uu:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				 		TargetIndex = unluckydog:entindex(), --Optional.  Only used when targeting units
				 		AbilityIndex = uu:FindAbilityByName(shiban_ability):entindex(), --Optional.  Only used when casting abilities
				 		Position = unluckydog:GetAbsOrigin(), --Optional.  Only used when targeting the ground
				 		Queue = 0 --Optional.  Used for queueing up abilities
				 	}
					ExecuteOrderFromTable(newOrder)
				end
				Timers:CreateTimer(shiban_cd,function()
					uu:ForceKill(false)
					uu:Destroy()
				end)
			end)

			TriggerShiban(unluckydog)

			return shiban_cd
		else
			return 0.1
		end
	end)
end

function TriggerShiban(dog)
	if RandomInt(1,100) >= 50 then
		return
	end
	local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                          dog:GetAbsOrigin(),
                          nil,
                          500,
                          DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                          DOTA_UNIT_TARGET_BASIC,
                          DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                          FIND_ANY_ORDER,
                          false)
	if table.maxn(uuu) > 0 then
		for u,v in pairs(uuu) do
			-- GameRules:SendCustomMessage(v:GetUnitName(),0,0)
			if v:FindAbilityByName('tower_chain_frost')~= nil then
				ChainFrost(v,dog)
			end
		end
	end
end

function ChainFrost(u,t)
	local uu = CreateUnitByName("gemtd_feicuimoxiang_yinxing", u:GetAbsOrigin() ,false,nil,nil, DOTA_TEAM_GOODGUYS) 
	uu.father = u
	uu:SetOwner(u)
	uu.ftd = 2009
	uu:AddAbility("chain_frost")
	uu:FindAbilityByName("chain_frost"):SetLevel(1)
	Timers:CreateTimer(0.05,function()
		local newOrder = {
	 		UnitIndex = uu:entindex(), 
	 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
	 		TargetIndex = t:entindex(), --Optional.  Only used when targeting units
	 		AbilityIndex = uu:FindAbilityByName("chain_frost"):entindex(), --Optional.  Only used when casting abilities
	 		Position = nil, --Optional.  Only used when targeting the ground
	 		Queue = 0 --Optional.  Used for queueing up abilities
	 	}
		ExecuteOrderFromTable(newOrder)

		Timers:CreateTimer(200,function()
			uu:ForceKill(false)
			uu:Destroy()
		end)
	end)
end

--寻找所有路径
function find_all_path()
	

	GameRules.gem_maze_length = 0

	if GameRules.guangzhudaobiao == nil then
		GameRules.gem_path = {
			{},{},{},{},{},{}
		}
		local p1 = Entities:FindByName(nil,"path1"):GetAbsOrigin()
		local p2 = Entities:FindByName(nil,"path2"):GetAbsOrigin()
		find_path(p1,p2,1)
		local p3 = Entities:FindByName(nil,"path3"):GetAbsOrigin()
		find_path(p2,p3,2)
		local p4 = Entities:FindByName(nil,"path4"):GetAbsOrigin()
		find_path(p3,p4,3)
		local p5 = Entities:FindByName(nil,"path5"):GetAbsOrigin()
		find_path(p4,p5,4)
		local p6 = Entities:FindByName(nil,"path6"):GetAbsOrigin()
		find_path(p5,p6,5)
		local p7 = Entities:FindByName(nil,"path7"):GetAbsOrigin()
		find_path(p6,p7,6)

		CustomNetTables:SetTableValue( "game_state", "gem_maze_length", { length = math.modf(GameRules.gem_maze_length),hehe=RandomInt(1,10000) } );

		GameRules.gem_path_all = {}
		for i = 1,6 do
			for j = 1,table.maxn(GameRules.gem_path[i])-1 do
				table.insert (GameRules.gem_path_all, GameRules.gem_path[i][j])
			end
		end
		table.insert (GameRules.gem_path_all, p7)
	else
		GameRules.gem_path = {
			{},{},{},{},{},{},{}
		}
		local p1 = Entities:FindByName(nil,"path1"):GetAbsOrigin()
		local p0 = GameRules.guangzhudaobiao:GetAbsOrigin()
		find_path(p1,p0,1)
		local p2 = Entities:FindByName(nil,"path2"):GetAbsOrigin()
		find_path(p0,p2,2)
		local p3 = Entities:FindByName(nil,"path3"):GetAbsOrigin()
		find_path(p2,p3,3)
		local p4 = Entities:FindByName(nil,"path4"):GetAbsOrigin()
		find_path(p3,p4,4)
		local p5 = Entities:FindByName(nil,"path5"):GetAbsOrigin()
		find_path(p4,p5,5)
		local p6 = Entities:FindByName(nil,"path6"):GetAbsOrigin()
		find_path(p5,p6,6)
		local p7 = Entities:FindByName(nil,"path7"):GetAbsOrigin()
		find_path(p6,p7,7)

		CustomNetTables:SetTableValue( "game_state", "gem_maze_length", { length = math.modf(GameRules.gem_maze_length),hehe=RandomInt(1,10000) } );

		GameRules.gem_path_all = {}
		for i = 1,7 do
			for j = 1,table.maxn(GameRules.gem_path[i])-1 do
				table.insert (GameRules.gem_path_all, GameRules.gem_path[i][j])
			end
		end
		table.insert (GameRules.gem_path_all, p7)
	end

	-- --删除路径
	-- if GameRules:GetGameModeEntity().gem_path_show == nil then
	-- 	GameRules:GetGameModeEntity().gem_path_show = {}
	-- end

	-- for i = 1,table.maxn(GameRules:GetGameModeEntity().gem_path_show) do
	-- 	ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().gem_path_show[i],false)
	-- 	ParticleManager:ReleaseParticleIndex(GameRules:GetGameModeEntity().gem_path_show[i])
	-- end
	-- GameRules:GetGameModeEntity().gem_path_show = {}

	-- --显示路径
	-- for i = 2,table.maxn(GameRules.gem_path_all) do
	-- 	local ice_wall_particle_effect_b = ParticleManager:CreateParticle("particles/units/heroes/hero_lion/lion_spell_mana_drain.vpcf", PATTACH_ABSORIGIN, GameRules.gem_castle)
	-- 	ParticleManager:SetParticleControl(ice_wall_particle_effect_b, 0, GameRules.gem_path_all[i-1])
	-- 	ParticleManager:SetParticleControl(ice_wall_particle_effect_b, 1, GameRules.gem_path_all[i])

	-- 	table.insert (GameRules:GetGameModeEntity().gem_path_show, ice_wall_particle_effect_b)
	-- end

end

--寻找所有路径
function find_all_path_fly()

	if GameRules.guangzhudaobiao == nil then
		local p1 = Entities:FindByName(nil,"path1"):GetAbsOrigin()
		local p2 = Entities:FindByName(nil,"path2"):GetAbsOrigin()
		local p3 = Entities:FindByName(nil,"path3"):GetAbsOrigin()
		local p4 = Entities:FindByName(nil,"path4"):GetAbsOrigin()
		local p5 = Entities:FindByName(nil,"path5"):GetAbsOrigin()
		local p6 = Entities:FindByName(nil,"path6"):GetAbsOrigin()
		local p7 = Entities:FindByName(nil,"path7"):GetAbsOrigin()

		GameRules.gem_path = {
			{p1,p2},{p2,p3},{p3,p4},{p4,p5},{p5,p6},{p6,p7}
		}

		GameRules.gem_path_all = {}
		for i = 1,6 do
			for j = 1,table.maxn(GameRules.gem_path[i])-1 do
				table.insert (GameRules.gem_path_all, GameRules.gem_path[i][j])
			end
		end
		table.insert (GameRules.gem_path_all, p7)
	else
		local p0 = GameRules.guangzhudaobiao:GetAbsOrigin()
		local p1 = Entities:FindByName(nil,"path1"):GetAbsOrigin()
		local p2 = Entities:FindByName(nil,"path2"):GetAbsOrigin()
		local p3 = Entities:FindByName(nil,"path3"):GetAbsOrigin()
		local p4 = Entities:FindByName(nil,"path4"):GetAbsOrigin()
		local p5 = Entities:FindByName(nil,"path5"):GetAbsOrigin()
		local p6 = Entities:FindByName(nil,"path6"):GetAbsOrigin()
		local p7 = Entities:FindByName(nil,"path7"):GetAbsOrigin()

		GameRules.gem_path = {
			{p1,p0},{p0,p2},{p2,p3},{p3,p4},{p4,p5},{p5,p6},{p6,p7}
		}

		GameRules.gem_path_all = {}
		for i = 1,7 do
			for j = 1,table.maxn(GameRules.gem_path[i])-1 do
				table.insert (GameRules.gem_path_all, GameRules.gem_path[i][j])
			end
		end
		table.insert (GameRules.gem_path_all, p7)
	end
end


--调用寻路算法
function find_path(p1,p2,step)

	-- Value for walkable tiles
	local walkable = 0

	-- Library setup
	local Grid = require ("pathfinder/grid") -- The grid class
	local Pathfinder = require ("pathfinder/pathfinder") -- The pathfinder lass

	-- Creates a grid object
	local grid = nil

	grid = Grid(GameRules:GetGameModeEntity().gem_map)
	--grid = Grid(map)

	-- Creates a pathfinder object using Jump Point Search
	local myFinder = nil
	myFinder = Pathfinder(grid, 'JPS', walkable)

	local xxx1 = math.floor((p1.x+64)/128)+19
	local yyy1 = math.floor((p1.y+64)/128)+19
	local xxx2 = math.floor((p2.x+64)/128)+19
	local yyy2 = math.floor((p2.y+64)/128)+19

	-- Define start and goal locations coordinates
	local startx, starty = xxx1,yyy1
	local endx, endy = xxx2, yyy2

	--local startx, starty = 2,2
	--local endx, endy = 9,9

	-- Calculates the path, and its length
	local path, length = myFinder:getPath(startx, starty, endx, endy)

	if path then
		--这部分算法待优化
		local dx = 0
		local dy = 0
		local lastx = -100
		local lasty = -100
		local lastdx = -100
		local lastdy = -100
		local lastd = -100
		local d = 0

		--print(('Path found! Length: %.2f'):format(length))
		GameRules.gem_maze_length = GameRules.gem_maze_length + length
		
		for node, count in path:iter() do
			

				dx = node.x-lastx
				dy = node.y-lasty

				if dy==0 then
					d = 999
				else
					d = dx/dy
				end

				--print(('Step%d - %d,%d'):format(count, node.x, node.y))

				local lastindex = table.maxn (GameRules.gem_path[step])

				if d~=lastd or lastindex<=1 then
					local xxx = (node.x-19)*128
					local yyy = (node.y-19)*128
					local p = Vector(xxx,yyy,137)
					table.insert (GameRules.gem_path[step], p)
				else
					local xxx = (node.x-19)*128
					local yyy = (node.y-19)*128
					local p = Vector(xxx,yyy,137)
					
					GameRules.gem_path[step][lastindex] = p
				end


				lastdx = dx
				lastdy = dy
				lastx = node.x
				lasty = node.y
				lastd = d

		end
	else
		GameRules.gem_path[step] = {}
	end
end


--打印网格地图
function print_gem_map()
	local s = ""
	for i=1,37 do
	    s = ""    
	    for j=1,37 do
	       s = s .. GameRules:GetGameModeEntity().gem_map[j][i]
	    end
	    print (s)
	end
end


--显示错误信息
--抄来的，实测无效
function ShowErrorMessage( msg )
	local msg = {
		error_number = 80,
		text_error = msg
	}
	--print( "Sending message to all clients." )
	FireGameEvent("tower_position_error",msg)
end

--在屏幕中央上方显示大字
function ShowCenterMessage( msg, dur, wave, count )
	if msg == nil then
		return
	end
	if wave == nil then
		wave = 0
	end
	if count == nil then
		count = 0
	end

	-- local msg = {
	-- 	message = msg,
	-- 	duration = dur
	-- }
	--print( "Sending message to all clients." )
	-- FireGameEvent("show_center_message",msg)
	
	if msg == "youwin" then
		CustomNetTables:SetTableValue( "game_state", "show_top_tips", { text = msg, time= dur, hehe = RandomInt(1,10000) } );
		play_particle("particles/econ/events/killbanners/screen_killbanner_compendium16_triplekill.vpcf",PATTACH_EYES_FOLLOW, GameRules:GetGameModeEntity().gem_castle,8)
	elseif string.find(msg, "boss") then
		CustomNetTables:SetTableValue( "game_state", "show_top_tips", { text = msg, time= dur, wave = wave, count= 1, hehe = RandomInt(1,10000) } );
		play_particle("particles/econ/events/killbanners/screen_killbanner_compendium14_triplekill.vpcf",PATTACH_EYES_FOLLOW, GameRules:GetGameModeEntity().gem_castle,5)
	else
		CustomNetTables:SetTableValue( "game_state", "show_top_tips", { text = msg, time= dur, wave = wave, count=count, hehe = RandomInt(1,10000) } );
		play_particle("particles/econ/events/killbanners/screen_killbanner_compendium14_rampage_swipe1.vpcf",PATTACH_EYES_FOLLOW, GameRules:GetGameModeEntity().gem_castle,5)
	end
end

--文字上色
function ColorIt( sStr, sColor )
	if sStr == nil or sColor == nil then
		return
	end

	--Default is cyan.
	local color = "00FFFF"

	if sColor == "green" then
		color = "ADFF2F"
	elseif sColor == "purple" then
		color = "EE82EE"
	elseif sColor == "blue" then
		color = "00BFFF"
	elseif sColor == "orange" then
		color = "FFA500"
	elseif sColor == "pink" then
		color = "DDA0DD"
	elseif sColor == "red" then
		color = "FF0000"
	elseif sColor == "cyan" then
		color = "00FFFF"
	elseif sColor == "yellow" then
		color = "FFFF00"
	elseif sColor == "brown" then
		color = "A52A2A"
	elseif sColor == "magenta" then
		color = "FF00FF"
	elseif sColor == "teal" then
		color = "008080"
	elseif sColor == "white" then
		color = "FFFFFF"
	end
	return "<font color='#" .. color .. "'>" .. sStr .. "</font>"
end

--伤害显示
function show_damage( keys )
	local caster = keys.caster
	local attacker = keys.attacker

	if attacker == nil or attacker:IsHero() then
		return
	end
	
	local owner = attacker:GetOwner()
	if owner == nil then
		return
	end
	local damage = math.floor(keys.DamageTaken)
	if damage<=0 then
		damage = 0
	end
	
	-- if damage >= (GameRules.level*2) then
	-- 	AMHC:CreateNumberEffect(caster,damage,2,AMHC.MSG_DAMAGE,"red",3)
	-- end

	--伤害统计
	local attacker_id = attacker:GetEntityIndex()
	if attacker.father ~= nil then
		attacker_id = attacker.father:GetEntityIndex()
	end
	local curr_damage = GameRules.damage[attacker_id]
	if curr_damage == nil then
		curr_damage = 0
	end
	curr_damage = curr_damage + damage
	GameRules.damage[attacker_id] = curr_damage


end


function start_shuaguai()

	if GameRules.level == 51 then
		CustomNetTables:SetTableValue( "game_state", "show_ggsimida", {hehe=RandomInt(1,10000)} )
	end

	CustomNetTables:SetTableValue( "game_state", "disable_all_repick", { hehe = RandomInt(1,10000) } );


	if GameRules.level == 1 then
		--背水一战技能
		-- local max_beishuiyizhan_level = 0
		-- for i,h in pairs(GameRules:GetGameModeEntity().hero) do
		-- 	if h:FindAbilityByName("gemtd_hero_beishuiyizhan") ~= nil and h:FindAbilityByName("gemtd_hero_beishuiyizhan"):GetLevel() > max_beishuiyizhan_level then
		-- 		max_beishuiyizhan_level = h:FindAbilityByName("gemtd_hero_beishuiyizhan"):GetLevel()
		-- 	end
		-- end
		-- if max_beishuiyizhan_level > 0 then
		-- 	GameRules:GetGameModeEntity().gem_castle.beishuiyizhan = "tower_beishuiyizhan"..max_beishuiyizhan_level
		-- 	GameRules:GetGameModeEntity().gem_castle:AddAbility("tower_beishuiyizhan"..max_beishuiyizhan_level)
		-- 	GameRules:GetGameModeEntity().gem_castle:FindAbilityByName("tower_beishuiyizhan"..max_beishuiyizhan_level):SetLevel(1)
		-- end
	end


	GameRules:SetTimeOfDay(0.8)
	GameRules.stop_watch = GameRules:GetGameTime()
	EmitGlobalSound("GameStart.RadiantAncient")

	--如果本关有备选怪，就随机
	if GameRules.guai[GameRules.level+100] ~= nil then
		if RandomInt(1,2) == 1 then
			GameRules.guai[GameRules.level] = GameRules.guai[GameRules.level+100]
		end
	end

	if (GameRules.level ==20 and RandomInt(1,100)>90 ) then
		GameRules.guai[GameRules.level] =  "gemtd_yuediyang_boss"
	end
	if (GameRules.level ==30 and RandomInt(1,100)>90 ) then
		GameRules.guai[GameRules.level] = "gemtd_zard_boss_fly"
	end
	if (GameRules.level ==40 and RandomInt(1,100)>90 ) then
		GameRules.guai[GameRules.level] =  "gemtd_gugubiao_boss_fly"
	end
	if (GameRules.level ==50 and RandomInt(1,100)>80 ) then
		GameRules.guai[GameRules.level] =  "gemtd_roushan_boss_fly_jin"
	end
	if (GameRules.level ==50 and RandomInt(1,100)>90 ) then
		GameRules.guai[GameRules.level] =  "gemtd_roushan_boss_fly_bojin"
	end

	if GameRules.level > 50 then
		GameRules.guai_level = GameRules.level - 50
	else
		GameRules.guai_level = GameRules.level
	end

	if GameRules.level > 100 then
		GameRules.game_status = 3
		send_ranking ()
		Timers:CreateTimer(20, function()
			GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		end)
	end

	ShowCenterMessage(GameRules.guai[GameRules.guai_level], 5,GameRules.level,GameRules:GetGameModeEntity().wave_enemy_count)

	CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = GameRules.level, enemy_show = GameRules.guai[GameRules.level] } );


	--GameRules:SendCustomMessage("玩家人数:"..player_count, 0, 0)

	GameRules.gem_is_shuaguaiing=true
	GameRules.guai_live_count = 0
	GameRules.guai_count = GameRules:GetGameModeEntity().wave_enemy_count


	-- GameRules:GetGameModeEntity().gem_castle:RemoveAbility("enemy_buff1")
	-- GameRules:GetGameModeEntity().gem_castle:RemoveAbility("enemy_buff2")
	-- GameRules:GetGameModeEntity().gem_castle:RemoveAbility("enemy_buff3")
	-- GameRules:GetGameModeEntity().gem_castle:RemoveAbility("enemy_buff4")

	-- GameRules:GetGameModeEntity().gem_castle:AddAbility("enemy_buff"..player_count)
	-- GameRules:GetGameModeEntity().gem_castle:FindAbilityByName("enemy_buff"..player_count):SetLevel(1)

	local guai_name  = GameRules.guai[GameRules.guai_level]
	find_all_path()
	if string.find(guai_name, "fly") then
		find_all_path_fly()
		--GameRules:SendCustomMessage("飞行怪", 0, 0)
	end
	if string.find(guai_name, "boss") then
		--find_all_path_fly()
		GameRules:SendCustomMessage("BOSS", 0, 0)
	end

	--清空pray
	local i = 0
	for i = 0, 20 do
		if ( PlayerResource:IsValidPlayer( i ) ) then
			local player = PlayerResource:GetPlayer(i)
			if player ~= nil then
				local h = player:GetAssignedHero()
				if h ~= nil then
					h.pray = nil
					h.pray_color = nil
					
					h.pray_count = 0
				end
			end
		end
	end
	GameRules.perfected = false
end

function send_ranking ()
	if GameRules.is_cheat == true then
		GameRules:SendCustomMessage("#text_no_upload_because_cheat", 0, 0)
	else
		local t = {}

		local g_time = GameRules:GetGameTime() - GameRules:GetGameModeEntity().game_time

		GameRules.player_count = 0
		for nPlayerID = 0, 9 do
			if ( PlayerResource:IsValidPlayer( nPlayerID ) ) then
				table.insert(t, PlayerResource:GetPlayerName(nPlayerID))
				GameRules.player_count = GameRules.player_count + 1
			end
		end
		-- GameRules:SendCustomMessage("#text_jiluchengji", 0, 0)
		-- GameRules:SendCustomMessage("Lv"..(GameRules.level-1)..", "..GameRules.kills.."kills, "..math.floor(g_time).."s", 0, 0)

		--统计任务完成情况
		if g_time/60 <= 60 then
			GameRules.quest_status["q105"] = true
			show_quest()
		end
		if g_time/60 <= 50 then
			GameRules.quest_status["q209"] = true
			show_quest()
		end
		if g_time/60 <= 40 then
			GameRules.quest_status["q302"] = true
			show_quest()
		end

		if GameRules:GetGameModeEntity().gem_castle_hp >=100 then
			GameRules.quest_status["q107"] = true
			show_quest()
		else
			GameRules.quest_status["q107"] = false
			show_quest()
		end
		

		local no_color_count = 0
		if GameRules.quest_status["q201"] == true then
			no_color_count = no_color_count + 1
		end
		if GameRules.quest_status["q202"] == true then
			no_color_count = no_color_count + 1
		end
		if GameRules.quest_status["q203"] == true then
			no_color_count = no_color_count + 1
		end
		if GameRules.quest_status["q204"] == true then
			no_color_count = no_color_count + 1
		end
		if GameRules.quest_status["q205"] == true then
			no_color_count = no_color_count + 1
		end
		if GameRules.quest_status["q206"] == true then
			no_color_count = no_color_count + 1
		end
		if GameRules.quest_status["q207"] == true then
			no_color_count = no_color_count + 1
		end
		if GameRules.quest_status["q208"] == true then
			no_color_count = no_color_count + 1
		end

		-- if no_color_count >=2 then
		-- 	GameRules.quest_status["q301"] = true
		-- end

		local finishd_quest = "";
		if GameRules.level > 50 then
			GameRules:SendCustomMessage("FINISH QUEST: ", 0, 0)

			for m,n in pairs(GameRules:GetGameModeEntity().quest) do
				if GameRules.quest_status[m] == true then 
					finishd_quest = finishd_quest .. m .. ","
					GameRules:SendCustomMessage("#"..m, 0, 0)
				end
			end
			GameRules:SendCustomMessage("FAILED QUEST: ", 0, 0)
			for m,n in pairs(GameRules:GetGameModeEntity().quest) do
				if GameRules.quest_status[m] == false then 
					GameRules:SendCustomMessage("#"..m, 0, 0)
				end
			end
		end

		--统计towers
		local towers = {}
		for u,v in pairs(GameRules.gemtd_pool) do
			if v ~= nil and v:GetUnitName() ~= nil then
				local t_name = v:GetUnitName()
				if string.find(t_name,"1") == nil then
					if towers[t_name] == nil then
						towers[t_name] = 1
					else
						towers[t_name] = towers[t_name] + 1
					end
				end
			end
		end
		local towers_str = ""
		for u,v in pairs(towers) do
			towers_str = towers_str..u..':'..v..','
		end

		towers_str = towers_str..'|'..GameRules.level..'|'..g_time

		--发送给pui来发请求
		CustomNetTables:SetTableValue( "game_state", "send_ranking", { 
			level = GameRules.level, 
			kills = GameRules.kills, 
			player_ids = GameRules:GetGameModeEntity().steam_ids_only,
			player_count = GameRules.player_count,
			seed = GameRules:GetGameModeEntity().navi,
			start_time = GameRules:GetGameModeEntity().start_time,
			time_cost = g_time,
			finishd_quest = finishd_quest,
			towers = towers_str,
		} );
	end
end

function DetectCheatsThinker ()
	if (Convars:GetBool("sv_cheats")) then
		zuobi()
		return nil
	end
	return GameRules.check_cheat_interval

end

function decodeURI(s)
    s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    return s
end

function encodeURI(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "+")
end

function string.trim(s)
	return s:match "^%s*(.-)%s*$"
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string.split(s, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(s, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function hash32(s)
	local h = md5.sumhexa(s)
	h = h.sub(h, -8)
	return tonumber("0x"..h)
end

function zuobi()
	GameRules:SendCustomMessage("#text_cheat_detected", 0, 0)
	--GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	GameRules.is_cheat = true
	
end

function jiyun_cd(keys)
	-- DeepPrintTable(keys)
end

function play_particle(p, pos, u, d)
	local pp = ParticleManager:CreateParticle(p, pos, u)
	Timers:CreateTimer(d,function()
		ParticleManager:DestroyParticle(pp,true)
	end)
end

function createHintBubble(unit, hint)
  -- Timers:CreateTimer(0.01, function()
  --   -- speech bubbles have a cap of 4 at the same time
  --   local duration = 3
    
  --   --check for active speech bubbles
  --   local bubble_index = table.getn(GameRules.table_bubbles)+1
  --   --print("bubble_index of current bubble", bubble_index)
  --   -- too many speech bubbles?
  --   if bubble_index > 4 then
  --     --local num = table.getn(table_bubbles)
  --     print("Too many speech bubbles at the moment : ", bubble_index)
  --     -- wait until bubbles expire
  --     Timers:CreateTimer(1,
  --     function()
  --       --try again
  --       createHintBubble(unit, hint)
  --       return nil
  --     end)
  --   else
  --     --less than 4 table_bubbles active
  --     -- +1 active bubble

  --     if unit:IsNull() then
  --     	return nil
  --     end
  --     table.insert(GameRules.table_bubbles, bubble_index)
  --     unit:AddSpeechBubble(bubble_index-1, hint, duration, 0, -20)
  --     local new_bubble_index = bubble_index
  --     Timers:CreateTimer(3,
  --     function()
  --       --print("removing bubble_index", new_bubble_index)
  --       -- -1 active bubble
  --       GameRules.table_bubbles[new_bubble_index] = nil
  --       --table.remove(table_bubbles, new_bubble_index)
  --       --PrintTable(table_bubbles)
  --       return nil
  --     end)
  --   end
  -- end)
end

--新版 塔升级！
function level_up(u,lv)
	if lv == nil then
		lv = 1
	end
	if lv > 10 then
		lv = 10
	end

	if u.level == nil then
		u.level = 0
	end
	local a_name = "tower_mofa"..u.level
	local m_name = "modifier_mofa_aura"..u.level
	u:RemoveAbility(a_name)
	u:RemoveModifierByName(m_name)

	u.level = u.level + lv
	if u.level > 10 then
		u.level = 10
	end
	u:AddAbility("tower_mofa"..u.level)
	u:FindAbilityByName("tower_mofa"..u.level):SetLevel(1)

	-- if u.level == 10 then
	-- 	GameRules.quest_status["q303"] = false
	-- end
end

--石化
function shihua(keys)
	local caster = keys.caster

	local u = CreateUnitByName("gemtd_feicuimoxiang_yinxing", caster:GetAbsOrigin() ,false,nil,nil, DOTA_TEAM_GOODGUYS) 
	u.ftd = 2009
	u:AddAbility('medusa_stone_gaze')
	u:FindAbilityByName('medusa_stone_gaze'):SetLevel(1)
	Timers:CreateTimer(0.1,function()
		local newOrder = {
	 		UnitIndex = u:entindex(), 
	 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
	 		TargetIndex = nil, --Optional.  Only used when targeting units
	 		AbilityIndex = u:FindAbilityByName("medusa_stone_gaze"):entindex(), --Optional.  Only used when casting abilities
	 		Position = nil, --Optional.  Only used when targeting the ground
	 		Queue = 0 --Optional.  Used for queueing up abilities
	 	}
		ExecuteOrderFromTable(newOrder)
		Timers:CreateTimer(20,function()
			u:ForceKill(false)
			u:Destroy()
		end)
	end)
end


function jianshe1( keys )
    local caster = keys.caster
    local target = keys.target

    local direUnits = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              target:GetAbsOrigin(),
                              nil,
                              300,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                              FIND_ANY_ORDER,
                              false)
	for aaa,unit in pairs(direUnits) do
		--获取攻击伤害
	    local attack_damage = keys.Damage
	    local damage = attack_damage*0.3
	    local damageTable = {
	    	victim=unit,
	    	attacker=caster,
	    	damage_type=DAMAGE_TYPE_PURE,
	    	damage=damage
	    }
	    ApplyDamage(damageTable)

	    -- print(damage)
	end
end

function jianshe2( keys )
    local caster = keys.caster
    local target = keys.target

    local direUnits = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              target:GetAbsOrigin(),
                              nil,
                              350,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                              FIND_ANY_ORDER,
                              false)
	for aaa,unit in pairs(direUnits) do
		--获取攻击伤害
	    local attack_damage = keys.Damage
	    local damage = attack_damage*0.4
	    local damageTable = {
	    	victim=unit,
	    	attacker=caster,
	    	damage_type=DAMAGE_TYPE_PURE,
	    	damage=damage
	    }
	    ApplyDamage(damageTable)
	end
end

function jianshe3( keys )
    local caster = keys.caster
    local target = keys.target

    local direUnits = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              target:GetAbsOrigin(),
                              nil,
                              400,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                              FIND_ANY_ORDER,
                              false)
	for aaa,unit in pairs(direUnits) do
		--获取攻击伤害
	    local attack_damage = keys.Damage
	    local damage = attack_damage*0.5
	    local damageTable = {
	    	victim=unit,
	    	attacker=caster,
	    	damage_type=DAMAGE_TYPE_PURE,
	    	damage=damage
	    }
	    ApplyDamage(damageTable)
	end
end

function jianshe4( keys )
    local caster = keys.caster
    local target = keys.target

    local direUnits = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              target:GetAbsOrigin(),
                              nil,
                              450,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                              FIND_ANY_ORDER,
                              false)
	for aaa,unit in pairs(direUnits) do
		--获取攻击伤害
	    local attack_damage = keys.Damage
	    local damage = attack_damage*0.6
	    local damageTable = {
	    	victim=unit,
	    	attacker=caster,
	    	damage_type=DAMAGE_TYPE_PURE,
	    	damage=damage
	    }
	    ApplyDamage(damageTable)
	end
end

function jianshe5( keys )
    local caster = keys.caster
    local target = keys.target

    local direUnits = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              target:GetAbsOrigin(),
                              nil,
                              500,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                              FIND_ANY_ORDER,
                              false)
	for aaa,unit in pairs(direUnits) do
		--获取攻击伤害
	    local attack_damage = keys.Damage
	    local damage = attack_damage*0.7
	    local damageTable = {
	    	victim=unit,
	    	attacker=caster,
	    	damage_type=DAMAGE_TYPE_PURE,
	    	damage=damage
	    }
	    ApplyDamage(damageTable)
	end
end

function jianshe6( keys )
    local caster = keys.caster
    local target = keys.target

    local direUnits = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              target:GetAbsOrigin(),
                              nil,
                              700,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                              FIND_ANY_ORDER,
                              false)
	for aaa,unit in pairs(direUnits) do
		--获取攻击伤害
	    local attack_damage = keys.Damage
	    local damage = attack_damage
	    local damageTable = {
	    	victim=unit,
	    	attacker=caster,
	    	damage_type=DAMAGE_TYPE_PURE,
	    	damage=damage
	    }
	    ApplyDamage(damageTable)
	end
end

function ranjin( keys )
    local caster = keys.caster
    local target = keys.target

    GameRules:SendCustomMessage(target:GetUnitName(),0,0)

	--获取攻击伤害
    local damage = keys.Damage
    local damageTable = {
    	victim=target,
    	attacker=caster,
    	damage_type=DAMAGE_TYPE_MAGICAL,
    	damage=damage
    }
    ApplyDamage(damageTable)
end

function show_quest()
	
	local quest_status_send = {}
	for m,n in pairs(GameRules:GetGameModeEntity().quest) do
		if GameRules.quest_status[m] == true then 
			quest_status_send[m] = true
		else
			quest_status_send[m] = false
		end
	end

	CustomNetTables:SetTableValue( "game_state", "show_quest", quest_status_send)
end

--捕捉一只螃蟹，发回pui
function GemTD:OnCatchCrab(keys)
	local url = keys.url
	local cb = keys.cb
	if url == null or cb == null then
		return
	end
	local user = keys.user

	url = string.gsub(url,"gemtd/ranking/add/","gemtd/201804/ranking/add/")
	local r = RandomFloat(0,1)
	
	Timers:CreateTimer(r,function()
		local req = CreateHTTPRequestScriptVM("GET", url)
		req:SetHTTPRequestAbsoluteTimeoutMS(20000)
		req:Send(function (result)
			-- local t = json.decode(result["Body"])
			CustomNetTables:SetTableValue( "game_state", cb, { crab = result["Body"], user = user, hehe = RandomInt(1,100000)})			
		end)
    end)
	
end

function gemtd_hero_shitou(keys)
	local caster = keys.caster
	local level = caster:FindAbilityByName("gemtd_hero_shitou"):GetLevel()

	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );


	--制造石头
	local max_stone_count = level*4
	local pp = caster:GetAbsOrigin()
	--网格化坐标
	local xxx = math.floor((pp.x+64)/128)+19
	local yyy = math.floor((pp.y+64)/128)+19
	pp.x = math.floor((pp.x+64)/128)*128
	pp.y = math.floor((pp.y+64)/128)*128

	local d = caster:GetForwardVector():Normalized()*128

	Timers:CreateTimer(function()
		--移动1格
		pp = pp + d
		pp.x = math.floor((pp.x+64)/128)*128
		pp.y = math.floor((pp.y+64)/128)*128
		--建！
		local r = build_1_stone({
			p = pp,
			caster = caster,
		})
		max_stone_count = max_stone_count - 1
		if max_stone_count <= 0 or r == false then
			return
		else
			return 0.3
		end
	end)
end

function build_1_stone(keys)
	local p = keys.p
	local caster = keys.caster
	local xxx = math.floor((p.x+64)/128)+19
	local yyy = math.floor((p.y+64)/128)+19
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()

	--path1和path7附近 不能造
	if xxx>=29 and yyy<=9 then
		return false
	end
	if xxx<=9 and yyy>=29 then
		return false
	end
	--附近有怪，不能造
	local uu = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              p,
                              nil,
                              192,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
	if table.getn(uu) > 0 then
		return false
	end
	--附近有友军单位了，不能造
	local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                              p,
                              nil,
                              58,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
                              FIND_ANY_ORDER,
                              false)
	if table.getn(uuu) > 0 then
		return false
	end
	--路径点，不能造
	for i=1,7 do
		local p1 = Entities:FindByName(nil,"path"..i):GetAbsOrigin()
		local xxx1 = math.floor((p1.x+64)/128)+19
		local yyy1 = math.floor((p1.y+64)/128)+19
		if xxx==xxx1 and yyy==yyy1 then
			return false
		end
	end
	--地图范围外，不能造
	if xxx<1 or xxx>37 or yyy<1 or yyy>37 then
		return false
	end
	if (GameRules:GetGameModeEntity().gem_map == nil) then
		GameRules:GetGameModeEntity().gem_map ={}
		for i=1,37 do
		    GameRules:GetGameModeEntity().gem_map[i] = {}   
		    for j=1,37 do
		       GameRules:GetGameModeEntity().gem_map[i][j] = 0
		    end
		end
	end
	GameRules:GetGameModeEntity().gem_map[yyy][xxx]=1
	--尝试寻找路径
	find_all_path()
	--路完全堵死了，不能造
	for i=1,6 do
		if table.maxn(GameRules.gem_path[i])<1 then
			--回退地图，重新寻路
			GameRules:GetGameModeEntity().gem_map[yyy][xxx]=0
			find_all_path()
			return false
		end
	end

	---------------------------------------------------------------------
	--至此验证ok了，可以正式开始建造石头了
	---------------------------------------------------------------------
	local u = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS)
	u.ftd = 2009
	u:SetOwner(caster)
	u:SetControllableByPlayer(player_id, true)
	u:SetForwardVector(Vector(0,-1,0))
	u:AddAbility("no_hp_bar")
	u:FindAbilityByName("no_hp_bar"):SetLevel(1)

	u:RemoveModifierByName("modifier_invulnerable")
	u:SetHullRadius(64)
	EmitSoundOn("Hero_EarthShaker.Fissure",u)
	play_particle("particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_leap_impact.vpcf",PATTACH_ABSORIGIN_FOLLOW,u,2)

	return true

end

function gemtd_hero_xuanfeng(keys)
	local caster = keys.caster
	local level = caster:FindAbilityByName("gemtd_hero_xuanfeng"):GetLevel()
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local p = keys.target_points[1]

	--同步玩家金钱
	SyncPlayerGold(player_id)

	--新版旋风方案
	--网格化坐标
	local x = math.floor((p.x+64)/128)+19
	local y = math.floor((p.y+64)/128)+19
	p.x = math.floor((p.x+64)/128)*128
	p.y = math.floor((p.y+64)/128)*128

	local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                              p,
                              nil,
                              128,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
	
	if table.getn(uuu) > 0 then
		local xuanfeng_index = {}
		for i,v in pairs(uuu) do
			if v:GetUnitName() ~= "gemtd_castle" and v:GetUnitName() ~= "gemtd_pet" and v:IsHero() == false and (not string.find(v:GetUnitName(), "shiban")) then
				local vp = v:GetAbsOrigin()
				local vx = math.floor((vp.x+64)/128)+19
				local vy = math.floor((vp.y+64)/128)+19
				xuanfeng_index[vx..'_'..vy] = v:entindex()
			end
		end


		local xuanfeng_count = 1
		local xuanfeng_units = {}
		local xuanfeng_positions = {}

		--按逆时针顺序填入数组
		y = y + 1
		x = x - 1
		if xuanfeng_index[x..'_'..y] ~= nil then
			xuanfeng_units[xuanfeng_count] = xuanfeng_index[x..'_'..y]
			xuanfeng_positions[xuanfeng_count] = EntIndexToHScript(xuanfeng_units[xuanfeng_count]):GetAbsOrigin()
			xuanfeng_count = xuanfeng_count + 1
		end
		y = y - 1
		if xuanfeng_index[x..'_'..y] ~= nil then
			xuanfeng_units[xuanfeng_count] = xuanfeng_index[x..'_'..y]
			xuanfeng_positions[xuanfeng_count] = EntIndexToHScript(xuanfeng_units[xuanfeng_count]):GetAbsOrigin()
			xuanfeng_count = xuanfeng_count + 1
		end
		y = y - 1
		if xuanfeng_index[x..'_'..y] ~= nil then
			xuanfeng_units[xuanfeng_count] = xuanfeng_index[x..'_'..y]
			xuanfeng_positions[xuanfeng_count] = EntIndexToHScript(xuanfeng_units[xuanfeng_count]):GetAbsOrigin()
			xuanfeng_count = xuanfeng_count + 1
		end
		x = x + 1
		if xuanfeng_index[x..'_'..y] ~= nil then
			xuanfeng_units[xuanfeng_count] = xuanfeng_index[x..'_'..y]
			xuanfeng_positions[xuanfeng_count] = EntIndexToHScript(xuanfeng_units[xuanfeng_count]):GetAbsOrigin()
			xuanfeng_count = xuanfeng_count + 1
		end
		x = x + 1
		if xuanfeng_index[x..'_'..y] ~= nil then
			xuanfeng_units[xuanfeng_count] = xuanfeng_index[x..'_'..y]
			xuanfeng_positions[xuanfeng_count] = EntIndexToHScript(xuanfeng_units[xuanfeng_count]):GetAbsOrigin()
			xuanfeng_count = xuanfeng_count + 1
		end
		y = y + 1
		if xuanfeng_index[x..'_'..y] ~= nil then
			xuanfeng_units[xuanfeng_count] = xuanfeng_index[x..'_'..y]
			xuanfeng_positions[xuanfeng_count] = EntIndexToHScript(xuanfeng_units[xuanfeng_count]):GetAbsOrigin()
			xuanfeng_count = xuanfeng_count + 1
		end
		y = y + 1
		if xuanfeng_index[x..'_'..y] ~= nil then
			xuanfeng_units[xuanfeng_count] = xuanfeng_index[x..'_'..y]
			xuanfeng_positions[xuanfeng_count] = EntIndexToHScript(xuanfeng_units[xuanfeng_count]):GetAbsOrigin()
			xuanfeng_count = xuanfeng_count + 1
		end
		x = x - 1
		if xuanfeng_index[x..'_'..y] ~= nil then
			xuanfeng_units[xuanfeng_count] = xuanfeng_index[x..'_'..y]
			xuanfeng_positions[xuanfeng_count] = EntIndexToHScript(xuanfeng_units[xuanfeng_count]):GetAbsOrigin()
			xuanfeng_count = xuanfeng_count + 1
		end

		xuanfeng_count = xuanfeng_count  - 1

		local uu = EntIndexToHScript(xuanfeng_units[xuanfeng_count])
		Timers:CreateTimer(0.3,function()
			uu:SetAbsOrigin(Vector(5000,5000,0))

			if xuanfeng_count > 1 then
				local r = xuanfeng_count
				Timers:CreateTimer(0.3,function()
					local r2 = r - 1
					if r2<1 then 
						r2 = xuanfeng_count
					end
					if xuanfeng_units[r] ~= nil and xuanfeng_units[r2] ~= nil then

						local u1 = EntIndexToHScript(xuanfeng_units[r2])
						local p2 = xuanfeng_positions[r]
						
						u1:SetAbsOrigin(p2)
						r = r - 1
						if r<1 then 
							uu:SetAbsOrigin(xuanfeng_positions[1])
							return
						end
						return 0.3
					end
					r =r - 1
					if r<1 then 
						uu:SetAbsOrigin(xuanfeng_positions[1])
						return
					end
					return 0.01
				end)

				-- for r = 1,xuanfeng_count do
				-- 	local r2 = r + 1
				-- 	if r2>xuanfeng_count then 
				-- 		r2 = 1
				-- 	end
				-- 	if xuanfeng_units[r] ~= nil and xuanfeng_units[r2] ~= nil then
				-- 		local u1 = EntIndexToHScript(xuanfeng_units[r])
				-- 		local u2 = EntIndexToHScript(xuanfeng_units[r2])
				-- 		SwapUnitPosition(u1,u2)
				-- 	end
				-- end
			else
				Timers:CreateTimer(0.3,function()
					uu:SetAbsOrigin(xuanfeng_positions[1])
				end)
			end
		end)

	end



	--旧版旋风方案，已废弃
	-- local unit_table = {}
	-- local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
 --                              p,
 --                              nil,
 --                              180,
 --                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
 --                              DOTA_UNIT_TARGET_ALL,
 --                              DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
 --                              FIND_ANY_ORDER,
 --                              false)
	-- if table.getn(uuu) > 0 then
	-- 	for i,v in pairs(uuu) do
	-- 		if v:GetUnitName() ~= "gemtd_castle" and v:GetUnitName() ~= "gemtd_pet" and v:IsHero() == false and (not string.find(v:GetUnitName(), "shiban")) then
	-- 			table.insert(unit_table,v)
	-- 			-- play_particle("particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf",PATTACH_OVERHEAD_FOLLOW,target,2)
	-- 			-- EmitGlobalSound("DOTA_Item.Daedelus.Crit")
	-- 			-- local u1 = v
	-- 			-- local u2 = target
	-- 			-- local p1 = u1:GetAbsOrigin()
	-- 			-- local p2 = u2:GetAbsOrigin()
	-- 			-- u1:SetAbsOrigin(Vector(5000,5000,0))
	-- 			-- u2:SetAbsOrigin(p1)
	-- 			-- u1:SetAbsOrigin(p2)
	-- 			-- break
	-- 		end
	-- 	end
	-- end
	-- local change_count = 50
	-- Timers:CreateTimer(0.5,function()
	-- 	if table.maxn(unit_table) >= 2 then 
	-- 		local u1 = unit_table[RandomInt(1,table.maxn(unit_table))]
	-- 		local u2 = unit_table[RandomInt(1,table.maxn(unit_table))]
	-- 		local p1 = u1:GetAbsOrigin()
	-- 		local p2 = u2:GetAbsOrigin()
	-- 		u1:SetAbsOrigin(Vector(5000,5000,0))
	-- 		u2:SetAbsOrigin(p1)
	-- 		u1:SetAbsOrigin(p2)
	-- 		change_count = change_count -1
	-- 		if change_count <=0 then
	-- 			return
	-- 		else
	-- 			return 0.02
	-- 		end
	-- 	end
	-- end)
end

function SwapUnitPosition(u1,u2)
	local p1 = u1:GetAbsOrigin()
	local p2 = u2:GetAbsOrigin()
	u1:SetAbsOrigin(Vector(5000,5000,0))
	u2:SetAbsOrigin(p1)
	u1:SetAbsOrigin(p2)
end

function SyncPlayerGold(player_id)
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );
end

function ReportHeroAbilities(hHero)
  if IsValidEntity(hHero) then
    for i=1,24 do
        local ability=hHero:GetAbilityByIndex(i-1)
        if ability then
            print("Abilities Report: "..hHero:GetUnitName().."ability["..i.."] is "..ability:GetAbilityName())
        else
            print("Abilities Report: "..hHero:GetUnitName().."ability["..i.."] is empty")
        end
    end
  end
end


function FixTool(keys)
	local u = keys.target

	play_particle("particles/econ/items/tinker/boots_of_travel/teleport_end_bots_b.vpcf",PATTACH_OVERHEAD_FOLLOW,u,1)

	local timer_count = 20
	Timers:CreateTimer(function()
		timer_count = timer_count - 1
		if timer_count <=0 then return end
		local random_count = 0
		local a = RandomInt(0,23)
		local b = RandomInt(0,23)
		while (u:GetAbilityByIndex(a)== nil or u:GetAbilityByIndex(b)== nil or u:GetAbilityByIndex(a):IsHidden() == true or u:GetAbilityByIndex(b):IsHidden() == true or u:GetAbilityByIndex(a):GetAbilityName()=="gemtd_build_stone" or u:GetAbilityByIndex(b):GetAbilityName()=="gemtd_build_stone" or u:GetAbilityByIndex(a):GetAbilityName()=="gemtd_remove" or u:GetAbilityByIndex(b):GetAbilityName()=="gemtd_remove") and random_count < 100 do
			a = RandomInt(0,23)
			b = RandomInt(0,23)
			random_count = random_count + 1
		end
		if random_count < 100 then
			u:SwapAbilities(u:GetAbilityByIndex(a):GetAbilityName(),u:GetAbilityByIndex(b):GetAbilityName(),true,true)
		end
		return 0.02
	end)
	
end

function  gemtd_hero_beishuiyizhan( keys )
	local caster = keys.caster
	local target = keys.target
	local level = caster:FindAbilityByName("gemtd_hero_beishuiyizhan"):GetLevel()
	local beishui_level = (100-GameRules:GetGameModeEntity().gem_castle_hp)/20+1

	sync_player_gold(caster)
	
	-- target:AddNewModifier(caster, caster:FindAbilityByName("gemtd_hero_beishuiyizhan"), "modifier_gemtd_hero_beishuiyizhan1", nil)

	local u = CreateUnitByName("gemtd_feicuimoxiang_yinxing", target:GetAbsOrigin() ,false,nil,nil, DOTA_TEAM_GOODGUYS) 
	u.ftd = 2009
	u:AddAbility('gemtd_hero_beishuiyizhan_unit'..level)
	u:FindAbilityByName('gemtd_hero_beishuiyizhan_unit'..level):SetLevel(beishui_level)
	Timers:CreateTimer(0.1,function()
		local newOrder = {
	 		UnitIndex = u:entindex(), 
	 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
	 		TargetIndex = target:entindex(), --Optional.  Only used when targeting units
	 		AbilityIndex = u:FindAbilityByName("gemtd_hero_beishuiyizhan_unit"..level):entindex(), --Optional.  Only used when casting abilities
	 		Position = nil, --Optional.  Only used when targeting the ground
	 		Queue = 0 --Optional.  Used for queueing up abilities
	 	}
		ExecuteOrderFromTable(newOrder)
		Timers:CreateTimer(20,function()
			u:ForceKill(false)
			u:Destroy()
		end)
	end)
end

function SetAbilityActiveStatus(h,is_build_status)

	local build_a_list = {
		"gemtd_hero_shitou",
		"gemtd_hero_lanse",
		"gemtd_hero_danbai",
		"gemtd_hero_baise",
		"gemtd_hero_hongse",
		"gemtd_hero_lvse",
		"gemtd_hero_fense",
		"gemtd_hero_huangse",
		"gemtd_hero_zise",
		"gemtd_hero_putong",
		"gemtd_hero_wuxia",
		"gemtd_hero_wanmei",
		"gemtd_hero_guangzhudaobiao",
	}

	local shuaguai_a_list = {
		"gemtd_hero_shanbi",
		"gemtd_hero_shouhu",
		"gemtd_hero_beishuiyizhan",
		"gemtd_hero_kuaisusheji",
		"gemtd_hero_baoji",
		"gemtd_hero_miaozhun",
		"gemtd_hero_lianjie",
	}

	if is_build_status == true then
		for u,i in pairs(build_a_list) do
			if h:FindAbilityByName(i) ~= nil then
				h:FindAbilityByName(i):SetActivated(true)
			end
		end
		for u,j in pairs(shuaguai_a_list) do
			if h:FindAbilityByName(j) ~= nil then
				h:FindAbilityByName(j):SetActivated(false)
			end
		end
	else
		for u,i in pairs(build_a_list) do
			if h:FindAbilityByName(i) ~= nil then
				h:FindAbilityByName(i):SetActivated(false)
			end
		end
		for u,j in pairs(shuaguai_a_list) do
			if h:FindAbilityByName(j) ~= nil then
				h:FindAbilityByName(j):SetActivated(true)
			end
		end
	end

	
end

function sync_player_gold(caster)
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );
end

--光柱道标
function guangzhudaobiao(keys)
	local caster = keys.caster
	local level = caster:FindAbilityByName("gemtd_hero_guangzhudaobiao"):GetLevel()
	local p = keys.target_points[1]

	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	--同步玩家金钱
	local gold_count = PlayerResource:GetGold(player_id)
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				PlayerResource:SetGold(ii, gold_count, true)
			end
		end
	end
	GameRules.team_gold = gold_count
	CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );

	--网格化坐标
	local xxx = math.floor((p.x+64)/128)+19
	local yyy = math.floor((p.y+64)/128)+19
	p.x = math.floor((p.x+64)/128)*128
	p.y = math.floor((p.y+64)/128)*128

	--path1和path7附近 不能造
	if xxx>=29 and yyy<=9 then
		EmitGlobalSound("ui.crafting_gem_drop")
		--caster:DestroyAllSpeechBubbles()
		--caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
		-- createHintBubble(caster,"#text_cannot_build_here")
		return
	end

	if xxx<=9 and yyy>=29 then
		EmitGlobalSound("ui.crafting_gem_drop")
		--caster:DestroyAllSpeechBubbles()
		--caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
		-- createHintBubble(caster,"#text_cannot_build_here")
		return
	end

	--附近有怪，不能造
	local uu = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              p,
                              nil,
                              192,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
	if table.getn(uu) > 0 then
		EmitGlobalSound("ui.crafting_gem_drop")
		--caster:DestroyAllSpeechBubbles()
		--caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
		-- createHintBubble(caster,"#text_cannot_build_here")
		--GameRules:SendCustomMessage("附近有怪，不能造", 0, 0)
		return
	end

	--附近有友军单位了，不能造
	local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                              p,
                              nil,
                              58,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
                              FIND_ANY_ORDER,
                              false)
	if table.getn(uuu) > 0 then
		EmitGlobalSound("ui.crafting_gem_drop")
		--caster:DestroyAllSpeechBubbles()
		--caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
		-- createHintBubble(caster,"#text_cannot_build_here")
		--GameRules:SendCustomMessage("附近有友军单位了，不能造", 0, 0)
		return
	end

	
	--路径点，不能造
	for i=1,7 do
		local p1 = Entities:FindByName(nil,"path"..i):GetAbsOrigin()
		local xxx1 = math.floor((p1.x+64)/128)+19
		local yyy1 = math.floor((p1.y+64)/128)+19
		if xxx==xxx1 and yyy==yyy1 then
			EmitGlobalSound("ui.crafting_gem_drop")
			--caster:DestroyAllSpeechBubbles()
			--caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
			-- createHintBubble(caster,"#text_cannot_build_here")
			--GameRules:SendCustomMessage("路径点，不能造", 0, 0)
			return
		end
	end
		

	--地图范围外，不能造
	if xxx<1 or xxx>37 or yyy<1 or yyy>37 then
		EmitGlobalSound("ui.crafting_gem_drop")
		--caster:DestroyAllSpeechBubbles()
		--caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
		-- createHintBubble(caster,"#text_cannot_build_here")
		--GameRules:SendCustomMessage("地图范围外，不能造", 0, 0)
		return
	end

	if GameRules.guangzhudaobiao ~= nil then
		GameRules.guangzhudaobiao:ForceKill(false)
		GameRules.guangzhudaobiao:Destroy()
		GameRules.guangzhudaobiao = nil
	end

	--创建道标
	u = CreateUnitByName("gemtd_guangzhudaobiao", p,false,nil,nil,DOTA_TEAM_GOODGUYS)
	u.ftd = 2009
    --u = AMHC:CreateUnit( create_stone_name,p,270,caster,caster:GetTeamNumber())
	u:SetOwner(caster)
	--u:SetParent(caster,caster:GetUnitName())
	u:SetControllableByPlayer(player_id, true)
	u:SetForwardVector(Vector(0,-1,0))

	GameRules.guangzhudaobiao = u

	--尝试寻找路径
	find_all_path()
	--路完全堵死了，不能造
	for i=1,7 do
		if table.maxn(GameRules.gem_path[i])<1 then
			EmitGlobalSound("ui.crafting_gem_drop")
			
			--回退地图，重新寻路
			GameRules.guangzhudaobiao:ForceKill(false)
			GameRules.guangzhudaobiao:Destroy()
			GameRules.guangzhudaobiao = nil

			find_all_path()
			return
		end
	end
end

