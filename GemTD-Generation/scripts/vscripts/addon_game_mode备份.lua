--宝石TD
--@author 萌小虾
if GemTD == nil then
	GemTD = class({})
end

--加载需要的模块
require('pathfinder/core/bheap')
md5 = require('md5')
json = require('dkjson')

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
GameRules.heroindex = {}
GameRules.vUserIdToPly = {}

GameRules.gem_difficulty = {
	[1] = 0.60,
	[2] = 1.90,
	[3] = 3.70,
	[4] = 5.60
}

GameRules.gem_difficulty_speed = {
	[1] = 1,
	[2] = 1.1,
	[3] = 1.2,
	[4] = 1.3
}

GameRules.gem_path_show = {}

GameRules.gem_boss_damage_all = 0
GameRules.is_boss_entered = false

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
		[16] = { x = 19, y = 34 }
	},
	[2] = {
		[1] = { x = 1, y = 19 },
		[2] = { x = 2, y = 19 },
		[3] = { x = 37, y = 19 },
		[4] = { x = 36, y = 19 },
		[5] = { x = 19, y = 1 },
		[6] = { x = 19, y = 2 },
		[7] = { x = 19, y = 37 },
		[8] = { x = 19, y = 36 },
	},
	[3] = {},
	[4] = {}
}


GameRules.is_default_builded = false

GameRules.gem_nandu = 0

GameRules.is_debug = false

GameRules.gem_path = {
	{},{},{},{},{},{}
}
GameRules.gem_path_all = {}

GameRules.gem_castle_hp = 100

GameRules.game_status = 0   --0 = 准备时间, 1 = 建造时间, 2 = 刷怪时间

GameRules.start_level = 1
GameRules.level = GameRules.start_level
GameRules.gem_is_shuaguaiing=false
GameRules.guai_count = 10
GameRules.guai_live_count = 0
GameRules.gemtd_pool_can_merge_all = {}

GameRules.gem_player_count = 0
GameRules.gem_hero_count = 0
GameRules.gem_maze_length = 0
GameRules.team_gold = 0


GameRules.is_cheat = false
GameRules.check_cheat_interval = 5

GameRules.max_xy = 40
GameRules.max_grids = GameRules.max_xy * GameRules.max_xy
GameRules.start_time = 0

GameRules.random_seed_levels = 1

GameRules.hero_pool = {
	"npc_dota_hero_queenofpain",
	"npc_dota_hero_crystal_maiden",
	"npc_dota_hero_mirana",
	"npc_dota_hero_windrunner",
	"npc_dota_hero_templar_assassin",
	"npc_dota_hero_phantom_assassin",
	"npc_dota_hero_lina",
	"npc_dota_hero_luna",
	"npc_dota_hero_drow_ranger",
	"npc_dota_hero_vengefulspirit",
	"npc_dota_hero_broodmother",
	"npc_dota_hero_legion_commander",
	"npc_dota_hero_spectre",
	"npc_dota_hero_death_prophet",
	"npc_dota_hero_naga_siren",
	"npc_dota_hero_medusa",
	"npc_dota_hero_enchantress",
	"npc_dota_hero_puck",
	"npc_dota_hero_winter_wyvern",
	"npc_dota_hero_phoenix",
	"npc_dota_hero_wisp",
}

GameRules.guai = {
	[1] = "gemtd_kuangbaoyezhu",
	[2] = "gemtd_kuaidiqingwatiaotiao",
	[3] = "gemtd_zhongchenggaoshanmaoniu",
	[4] = "gemtd_moluokedejixiezhushou",
	[5] = "gemtd_wuweizhihuan_fly",
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
	[16] = "gemtd_xunjiemotong",
	[17] = "gemtd_yonggandexiaoji",
	[18] = "gemtd_xiaobajie",
	[19] = "gemtd_shentu",
	[20] = "gemtd_huxiaotao_boss",
	[21] = "gemtd_siwangsiliezhe",
	[22] = "gemtd_yaorenxiangluoke",
	[23] = "gemtd_tiezuiyaorenxiang",
	[24] = "gemtd_jixieyaorenxiang",
	[25] = "gemtd_fengbaozhizikesaier_fly",
	[26] = "gemtd_niepanhuolieniao",
	[27] = "gemtd_lgddejinmengmeng_fly",
	[28] = "gemtd_youniekesizhinu_fly",
	[29] = "gemtd_feihuxia_fly",
	[30] = "gemtd_mofafeitanxiaoemo_boss_fly",
	[31] = "gemtd_modianxiaolong",
	[32] = "gemtd_xiaoshayu",
	[33] = "gemtd_feijiangxiaobao",
	[34] = "gemtd_shangjinbaobao_fly",
	[35] = "gemtd_jinyinhuling_fly",
	[36] = "gemtd_cuihua",
	[37] = "gemtd_xiaobaihu",
	[38] = "gemtd_xiaoxingyue",
	[39] = "gemtd_liangqiyuhai_fly",
	[40] = "gemtd_guixiaoxieling_boss_fly",
	[41] = "gemtd_weilanlong",
	[42] = "gemtd_saodiekupu_fly",
	[43] = "gemtd_juniaoduoduo_tester"
}

GameRules.guai_tips = {
	[1] = "",
	[2] = "",
	[3] = "",
	[4] = "#text_tips_speed",
	[5] = "#text_tips_flying",
	[6] = "",
	[7] = "",
	[8] = "#text_tips_invisibility",
	[9] = "#text_tips_evade",
	[10] = "#text_tips_boss",
	[11] = "",
	[12] = "",
	[13] = "",
	[14] = "",
	[15] = "#text_tips_flying",
	[16] = "#text_tips_momian",
	[17] = "#text_tips_bukeqinfan",
	[18] = "#text_tips_invisibility",
	[19] = "#text_tips_evade",
	[20] = "#text_tips_boss",
	[21] = "",
	[22] = "",
	[23] = "#text_tips_wumian",
	[24] = "#text_tips_huoxinghujia",
	[25] = "#text_tips_flying",
	[26] = "#text_tips_momian",
	[27] = "#text_tips_flying_bukeqinfan",
	[28] = "#text_tips_huoxinghujia_flying",
	[29] = "#text_tips_evade_flying",
	[30] = "#text_tips_boss",
	[31] = "#text_tips_momian_evade",
	[32] = "#text_tips_huixue",
	[33] = "#text_tips_wumian",
	[34] = "#text_tips_evade_flying",
	[35] = "#text_tips_momian_or_wumian_flying",
	[36] = "#text_tips_momian_or_wumian",
	[37] = "#text_tips_speed_huixue_bukeqinfan",
	[38] = "#text_tips_shanbi_or_yinshen",
	[39] = "#text_tips_shanbi_huixue_flying",
	[40] = "#text_tips_boss",
	[41] = "#text_tips_jisu_huiguangfanzhao",
	[42] = "#text_tips_jisu_momian_fly",
	[43] = "#text_tips_tester",

}

GameRules.gemtd_merge = {
	gemtd_baiyin = { "gemtd_b1", "gemtd_y1", "gemtd_d1" },
	gemtd_kongqueshi = { "gemtd_e1", "gemtd_q1", "gemtd_g1" },
	gemtd_xingcaihongbaoshi = { "gemtd_r11", "gemtd_r1", "gemtd_p1" },
	gemtd_yu = { "gemtd_g111", "gemtd_e111", "gemtd_b11" },
	gemtd_furongshi = { "gemtd_g1111", "gemtd_r111", "gemtd_p11" },
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
	gemtd_jixiangdezhongguoyu = { "gemtd_yu", "gemtd_furongshi", "gemtd_g111" },
	gemtd_juxingfenhongzuanshi = { "gemtd_fenhongzuanshi", "gemtd_baiyinqishi", "gemtd_baiyin" },
	gemtd_you235 = { "gemtd_you238", "gemtd_xianyandekongqueshi", "gemtd_kongqueshi" },
	gemtd_jingxindiaozhuodepalayibabixi = { "gemtd_palayibabixi", "gemtd_jin", "gemtd_baiyin" },
	gemtd_gudaidejixueshi = { "gemtd_jixueshi", "gemtd_xuehonghuoshan", "gemtd_r11" },
	gemtd_mirendeqingjinshi = { "gemtd_furongshi", "gemtd_p1111", "gemtd_y11" },
	gemtd_aijijin = { "gemtd_jin", "gemtd_p11111", "gemtd_q111" }
}
GameRules.gemtd_merge_secret = {
	gemtd_yijiazhishi = { "gemtd_e1", "gemtd_e11", "gemtd_e111", "gemtd_e1111", "gemtd_e11111" },
	gemtd_heiyaoshi = { "gemtd_b11111", "gemtd_y11111", "gemtd_d11111" },
	gemtd_manao = { "gemtd_q11111", "gemtd_e11111", "gemtd_g11111" },
	gemtd_ranshaozhishi = { "gemtd_r11111", "gemtd_p11111", "gemtd_r1111", "gemtd_p1111" }
}
GameRules.gemtd_merge_shiban = {
	gemtd_zhiliushiban = { "gemtd_y111", "gemtd_p11" }
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

-- GameRules.gem_tower_basic = {
-- 	[1] = "gemtd_r",
-- 	[2] = "gemtd_p"
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


--预加载游戏资源
function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
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
		"particles/unit_team/unit_team_player0.vpcf",
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
		"particles/units/heroes/hero_phantom_assassin/phantom_assassin_blur.vpcf",
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
		"particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
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
    print("Precache OK")
end

--游戏开始
function Activate()
	print ("GemTD START!")
	GameRules.AddonTemplate = GemTD()
	GameRules.AddonTemplate:InitGameMode()

	--监听全局定时器事件
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 1 )
end

--游戏初始化
function GemTD:InitGameMode()

	AMHCInit();

  	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 4)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 0)

	GameRules:SetHeroRespawnEnabled( true )
	GameRules:SetSameHeroSelectionEnabled( true )
	GameRules:SetGoldPerTick(0)
	GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(5)

	GameRules:GetGameModeEntity():SetCameraDistanceOverride(1500)

	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(
		{
			[1] = 0,
			[2] = 200,
			[3] = 550,
			[4] = 1050,
			[5] = 1700
		}
	)
	GameRules:SetUseCustomHeroXPValues(true)

	--设置玩家颜色
	PlayerResource:SetCustomPlayerColor(0, 255, 255, 0)
	PlayerResource:SetCustomPlayerColor(1, 64, 64, 255)
	PlayerResource:SetCustomPlayerColor(2, 255, 0, 0)
	PlayerResource:SetCustomPlayerColor(3, 255, 0, 255)

	--监听单位出生事件
    ListenToGameEvent("npc_spawned", Dynamic_Wrap(GemTD, "OnNPCSpawned"), self)
    --监听单位被击杀的事件
    ListenToGameEvent("entity_killed", Dynamic_Wrap(GemTD, "OnEntityKilled"), self)
    --监听玩家聊天事件
    ListenToGameEvent("player_chat", Dynamic_Wrap(GemTD, "OnPlayerSay"), self)
    --监听玩家选择英雄事件
    ListenToGameEvent("dota_player_pick_hero",Dynamic_Wrap(GemTD,"OnPlayerPickHero"),self)
    --某玩家成功载入
    ListenToGameEvent("player_connect_full", Dynamic_Wrap(GemTD,"OnPlayerConnectFull" ),self) 
    --监听玩家断开连接的事件
    ListenToGameEvent("player_disconnect", Dynamic_Wrap(GemTD, "OnPlayerDisconnect"), self)

    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(GemTD,"OnGameRulesStateChange"), self)
	
	ListenToGameEvent("dota_player_gained_level", Dynamic_Wrap(GemTD,"OnPlayerGainedLevel"), self)
	
	-- Custom Event: gather players' steam ids
	CustomGameEventManager:RegisterListener("gather_steam_ids", Dynamic_Wrap(GemTD, "OnReceiveSteamIDs") )

	CustomGameEventManager:RegisterListener("player_share_map", Dynamic_Wrap(GemTD, "OnReceiveShareMap") )


    --创建宝石城堡
	local u = CreateUnitByName("gemtd_castle", Entities:FindByName(nil,"path7"):GetAbsOrigin() ,false,nil,nil, DOTA_TEAM_GOODGUYS) 
	u.ftd = 2009
	u:AddAbility("no_hp_bar")
	u:FindAbilityByName("no_hp_bar"):SetLevel(1)
	u:RemoveModifierByName("modifier_invulnerable")
	u:SetHullRadius(128)
	u:SetForwardVector(Vector(-1,0,0))
	GameRules.gem_castle = u
	
	--随机数
	gemtd_randomize()

	--检测作弊
	GameRules:GetGameModeEntity():SetThink("DetectCheatsThinker")
end

GameRules.hehe = 0

--玩家选择英雄
function GemTD:OnPlayerPickHero(keys)
	DeepPrintTable(keys)
    local i = keys.player
    local player = EntIndexToHScript(i)
    local hero = player:GetAssignedHero()
	local heroindex = keys.heroindex
    GameRules.heroindex[i]=heroindex

    GameRules.gem_hero_count = GameRules.gem_hero_count + 1
	--GameRules:SendCustomMessage("玩家"..i.."选择英雄，目前英雄总数:"..GameRules.gem_hero_count, 0, 0)

	-- Timers:CreateTimer(0.5, function()
	-- 	if (GameRules.hehe == 0) then
	-- 		GameRules:SendCustomMessage("换英雄", 0, 0)
	-- 		local id = hero:GetPlayerID()
	-- 		PlayerResource:ReplaceHeroWith(id,"npc_dota_hero_windrunner",PlayerResource:GetGold(id),0)
	-- 		GameRules.hehe = 1
	-- 	end
	-- end
	-- )

	--随机选择英雄
	--hero:Destroy()
	--hero:SetAbsOrigin(Vector(10000,0,0))

	--PlayerResource:ReplaceHeroWith(0,"npc_dota_hero_windrunner",0,0)
	
	-- local u = CreateUnitByName("npc_dota_hero_windrunner", Vector(0,0,0) ,false,nil,nil, DOTA_TEAM_GOODGUYS) 
	-- u.ftd = 2009
	-- u:SetOwner(hero:GetOwner())
	-- u:SetControllableByPlayer(i, true)

	-- hero:Destroy()

end


function GemTD:OnGameRulesStateChange(keys)
	local newState = GameRules:State_Get()

	if newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		--self.CustomRule:HeroSelect()
	elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
		--self.CustomRule:PreGame()
    elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    	--GameRules:SendCustomMessage("应有英雄数："..PlayerResource:GetPlayerCount(), 0, 0)
    	--GameRules:SendCustomMessage("实际英雄数："..GameRules.gem_hero_count, 0, 0)
    	
	   	Timers:CreateTimer(0, function()

	   		--GameRules:SendCustomMessage("应有英雄数："..PlayerResource:GetPlayerCount()..", 实际英雄数："..GameRules.gem_hero_count, 0, 0)

			if PlayerResource:GetPlayerCount() <=GameRules.gem_hero_count then
				local h = {}
				for i = 0, 9 do
					if ( PlayerResource:IsValidPlayer( i ) ) then
						table.insert(h, PlayerResource:GetSelectedHeroName(i))
					end
				end
				table.sort(h)
				GameRules:GetGameModeEntity().player_heros = table.concat(h, ",")
				print("game start: "..time_tick)
				local seed = RandomInt(1,100000).."s"
				GameRules:GetGameModeEntity().seed = seed
				gemtd_randomize(seed)
				GameRules:GetGameModeEntity().send_rank = true
				GameRules:SendCustomMessage("#text_game_start", 0, 0)
				start_build()

				local url = "http://101.200.189.65:2009/gemtd/v08g/seed/get?"
				url = url .. "player_id=" .. GameRules:GetGameModeEntity().player_ids
				url = url .. "&hero_id=" .. GameRules:GetGameModeEntity().player_heros
				url = url .. "&hehe=" .. RandomInt(1,10000)
				url = url .. "&seed=" .. GameRules:GetGameModeEntity().seed

				CustomNetTables:SetTableValue( "game_state", "send_http", { url = url } );



				CustomNetTables:SetTableValue( "game_state", "select_hero1", { p1 = PlayerResource:GetSelectedHeroName(0), p2 = PlayerResource:GetSelectedHeroName(1), p3 = PlayerResource:GetSelectedHeroName(2), p4 = PlayerResource:GetSelectedHeroName(3) } );


				-- --print (url)
				-- CreateHTTPRequest("GET", url):Send( function(response)
				-- 	local r = json.decode (response.Body)
				-- 	-- DeepPrintTable(r)
				-- 	GameRules:GetGameModeEntity().seed = r.seed
				-- 	--GameRules:SendCustomMessage(GameRules:GetGameModeEntity().seed, 0, 0)
				-- 	if (r) then
				-- 		GameRules:GetGameModeEntity().send_rank = true
				-- 		gemtd_randomize(GameRules:GetGameModeEntity().seed)
				-- 	end
				-- 	GameRules:SendCustomMessage("#text_game_start", 0, 0)
				-- 	--GameRules:SendCustomMessage("#text_random_seed_used", 0, 0)
				-- 	--GameRules:SendCustomMessage(GameRules:GetGameModeEntity().seed, 0, 0)
				-- 	start_build()
				-- end)
				return nil
			else
				GameRules:SendCustomMessage("#text_some_player_have_no_hero", 0, 0)
				return 5
			end
		end)
	end
end

function GemTD:OnReceiveSteamIDs(keys)
	DeepPrintTable(keys)
	GameRules:GetGameModeEntity().player_ids = keys.steam_ids
	GameRules:GetGameModeEntity().start_time = keys.start_time

	--GameRules:SendCustomMessage("black="..keys.is_black, 0, 0)

	if keys.is_black == 1 then
		GameRules:SendCustomMessage("#text_black", 0, 0)
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	end

end

function GemTD:OnReceiveShareMap(keys)
	DeepPrintTable(keys)
	GameRules:GetGameModeEntity().map = keys.map

	if GameRules:GetGameModeEntity().map ~= nil then
		GameRules:SendCustomMessage("#show_maze_pic", 0, 0)
		CustomNetTables:SetTableValue( "game_state", "show_maze_map", {map = GameRules:GetGameModeEntity().map} );
	end

end

function GemTD:OnPlayerConnectFull (keys)
	DeepPrintTable(keys)

	GameRules.vUserIdToPly[keys.userid] = keys.index+1

	if GameRules.is_debug == true then
		GameRules:SendCustomMessage("index="..keys.index..", userid="..keys.userid.." 的玩家加入了游戏。", 0, 0)
	end

	CustomNetTables:SetTableValue( "game_state", "player_connect", { id = keys.index } );

	if GameRules.is_debug == true then
		GameRules:SendCustomMessage(PlayerResource:GetSelectedHeroName(0), 0, 0)
		GameRules:SendCustomMessage(PlayerResource:GetSelectedHeroName(1), 0, 0)
		GameRules:SendCustomMessage(PlayerResource:GetSelectedHeroName(2), 0, 0)
		GameRules:SendCustomMessage(PlayerResource:GetSelectedHeroName(3), 0, 0)
	end

	if PlayerResource:GetSelectedHeroName(0) ~= nil then
		CustomNetTables:SetTableValue( "game_state", "select_hero1", { p1 = PlayerResource:GetSelectedHeroName(0), p2 = PlayerResource:GetSelectedHeroName(1), p3 = PlayerResource:GetSelectedHeroName(2), p4 = PlayerResource:GetSelectedHeroName(3) } );
	end
end

function GemTD:OnPlayerDisconnect (keys)
	print("OnPlayerDisconnect")
	DeepPrintTable(keys)

	if GameRules.is_debug == true then
		GameRules:SendCustomMessage("index="..keys.index..", userid="..keys.userid.." 的玩家离开了游戏。", 0, 0)
	end

	CustomNetTables:SetTableValue( "game_state", "player_disconnect", { id = keys.index } );
	
end

function GemTD:OnPlayerGainedLevel(keys)
	DeepPrintTable(keys)
	--判断作弊
	if (GameRules.level<3 and keys.level > 1 or
		GameRules.level<5 and keys.level > 2 or
	    GameRules.level<7 and keys.level > 3 or
		GameRules.level<9 and keys.level > 4) then
		zuobi()
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	end
end

--全局定时器事件
function OnThink()
	
    time_tick = time_tick +1
	--print(time_tick)

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

		local i = 0
		for i = 0, 9 do
			if ( PlayerResource:IsValidPlayer( i ) ) then
				local player = PlayerResource:GetPlayer(i)
				if player ~= nil then
					local h = player:GetAssignedHero()
					if h ~= nil and h:GetAbilityPoints() ~=0 then
						h:DestroyAllSpeechBubbles()
						h:AddSpeechBubble(2,"#text_i_level_up",3,0,30)
						h:SetAbilityPoints(0)
						CustomNetTables:SetTableValue( "game_state", "gem_team_level", { level = h:GetLevel() } );
					end
				end
			end
		end



		--刷怪
		if time_tick%1 ==0 then
			if ( GameRules.gem_is_shuaguaiing==true and not GameRules:IsGamePaused()) then
				local ShuaGuai_entity = Entities:FindByName(nil,"path1")
				local position = ShuaGuai_entity:GetAbsOrigin() 
				position.z = 150

				local u = nil

				local guai_name  = GameRules.guai[GameRules.level]

				--有些关卡有特殊刷怪逻辑
				if (GameRules.level ==35 and RandomInt(1,100)>50 ) then
					guai_name = guai_name.."1"
				end
				if (GameRules.level ==36 and RandomInt(1,100)>50 ) then
					guai_name = guai_name.."1"
				end
				if (GameRules.level ==38 and RandomInt(1,100)>50 ) then
					guai_name = guai_name.."1"
				end
				if (GameRules.level ==30 and RandomInt(1,100)>90 ) then
					guai_name = "gemtd_zard_boss_fly"
				end

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

			    local random_hit = 1
			    if (not string.find(guai_name, "boss")) and (not string.find(guai_name, "fly")) and (not string.find(guai_name, "tester")) then
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
				u:SetBaseMaxHealth(maxhealth)
				u:SetMaxHealth(maxhealth)
				u:SetHealth(maxhealth)

				u:AddNewModifier(u,nil,"modifier_bloodseeker_thirst",nil)
				u:SetBaseMoveSpeed(u:GetBaseMoveSpeed()*GameRules.gem_difficulty_speed[GameRules.gem_nandu])


			    u:SetHullRadius(1)
				u:SetContextNum("step",1,0)
				u.damage = 5
				if GameRules.level >10 and GameRules.level <20 then
					u.damage = 5+RandomInt(0,5)
				elseif GameRules.level >20 and GameRules.level <30 then
					u.damage = 5+RandomInt(0,10)
				elseif GameRules.level >30 and GameRules.level <40 then
					u.damage = 5+RandomInt(0,15)
				elseif GameRules.level >40 and GameRules.level <50 then
					u.damage = 5+RandomInt(0,20)
				end

				if GameRules.level ==10 then
					u.damage = 100
				end
				if GameRules.level ==20 then
					u.damage = 100
				end
				if GameRules.level ==30 then
					u.damage = 100
				end
				if GameRules.level ==40 then
					u.damage = 100
				end
				if GameRules.level ==43 then
					u.damage = 0
				end


				u:SetBaseDamageMin(u.damage)
				u:SetBaseDamageMax(u.damage)

				u.position = u:GetAbsOrigin() 

				GameRules.guai_count = GameRules.guai_count -1
				GameRules.guai_live_count = GameRules.guai_live_count + 1



				if string.find(guai_name, "boss") then
					--PrecacheResource( "soundfile",  zr[i], context)
					GameRules.guai_count = GameRules.guai_count -100
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
							if ( u:GetAbsOrigin() - GameRules.gem_path_all[u.target] ):Length2D() <32 then
								u.target = u.target + 1
								u:MoveToPosition(GameRules.gem_path_all[u.target]+Vector(RandomInt(-5,5),RandomInt(-5,5),0))
								return 0.1
							else
								u:MoveToPosition(GameRules.gem_path_all[u.target]+Vector(RandomInt(-5,5),RandomInt(-5,5),0))
								return 0.1
							end
						end
					end
				)

				--[[--给怪下命令序列
				for i = 1,6 do
					for j = 1,table.maxn(GameRules.gem_path[i])-1 do
						local t_order = 
						    {                                       
						        UnitIndex = u:entindex(), 
						        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
						        TargetIndex = nil, 
						        AbilityIndex = 0, 
						        Position = GameRules.gem_path[i][j],
						        Queue = true 
						    }
						u:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(t_order) end, 0.01)
						--path_gogogo(GameRules.gem_path[i][j],GameRules.gem_path[i][j+1],i) 
					end
				end

				local t_order = 
				    {                                       
				        UnitIndex = u:entindex(), 
				        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				        TargetIndex = nil, 
				        AbilityIndex = 0, 
				        Position = Entities:FindByName(nil,"path7"):GetAbsOrigin(),
				        Queue = true 
				    }
				u:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(t_order) end, 0.01)
				]]


				if GameRules.guai_count<=0 then
					GameRules.gem_is_shuaguaiing=false
				end

				show_board()


			end
		end

		--[[
	    --怪按路径移动
		for i = 1,6 do
			for j = 1,table.maxn(GameRules.gem_path[i])-1 do
				path_gogogo(GameRules.gem_path[i][j],GameRules.gem_path[i][j+1],i) 
			end
		end

		--判断怪升step
		local p2 = Entities:FindByName(nil,"path2"):GetAbsOrigin()
		path_upstep(p2,1,2)
		local p3 = Entities:FindByName(nil,"path3"):GetAbsOrigin()
		path_upstep(p3,2,3)
		local p4 = Entities:FindByName(nil,"path4"):GetAbsOrigin()
		path_upstep(p4,3,4)
		local p5 = Entities:FindByName(nil,"path5"):GetAbsOrigin()
		path_upstep(p5,4,5)
		local p6 = Entities:FindByName(nil,"path6"):GetAbsOrigin()
		path_upstep(p6,5,6)
		]]


		--判断是否有怪到达城堡
		local ShuaGuai_entity = Entities:FindByName(nil,"path7")
		local position = ShuaGuai_entity:GetAbsOrigin() 
		local direUnits = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              position,
                              nil,
                              256,
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

        		GameRules:SendCustomMessage("DAMAGE +"..boss_damage, 0, 0)
        		GameRules.is_boss_entered = true
        	end


        	EmitGlobalSound("Loot_Drop_Stinger_Short")

			GameRules.gem_castle_hp = GameRules.gem_castle_hp - damage

			CustomNetTables:SetTableValue( "game_state", "gem_life", { gem_life = GameRules.gem_castle_hp } );

			AMHC:CreateNumberEffect(GameRules.gem_castle,damage,5,AMHC.MSG_DAMAGE,"red",3)

			GameRules.gem_castle:SetHealth(GameRules.gem_castle_hp)
			ScreenShake(Vector(150,150,0), 320, 3.2, 2, 10000, 0, false)  --无效? vsb

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
							h:SetHealth(GameRules.gem_castle_hp)
						end
					end
				end
			end


			-- --给玩家经验
			-- local exp_count = 5
			-- if GameRules.level ==10 then
			-- 	exp_count = 200
			-- end
			-- if GameRules.level ==20 then
			-- 	exp_count = 300
			-- end
			-- if GameRules.level ==30 then
			-- 	exp_count = 400
			-- end
			-- if GameRules.level ==40 then
			-- 	exp_count = 500
			-- end
			-- if GameRules.level >=11 and GameRules.level <=19 then
			-- 	exp_count = 10
			-- end
			-- if GameRules.level >=21 and GameRules.level <=29 then
			-- 	exp_count = 15
			-- end
			-- if GameRules.level >=31 and GameRules.level <=39 then
			-- 	exp_count = 20
			-- end
			-- local exp_percent = 1

			-- exp_count = exp_count * exp_percent

			-- if (unit~= nil and unit.is_jingying == true) then
			-- 	exp_count = exp_count * 4
			-- end

			-- local i = 0
			-- for i = 0, 9 do
			-- 	if ( PlayerResource:IsValidPlayer( i ) ) then
			-- 		local player = PlayerResource:GetPlayer(i)
			-- 		if player ~= nil then
			-- 			local h = player:GetAssignedHero()
			-- 			if h ~= nil then
			-- 				h:AddExperience (-exp_count,0,false,false)
			-- 			end
			-- 		end
			-- 	end
			-- end

			-- GameRules.team_gold = GameRules.team_gold - exp_count
			-- --同步玩家金钱
			-- local ii = 0
			-- for ii = 0, 20 do
			-- 	if ( PlayerResource:IsValidPlayer( ii ) ) then
			-- 		local player = PlayerResource:GetPlayer(ii)
			-- 		if player ~= nil then
			-- 			PlayerResource:SetGold(ii, GameRules.team_gold, true)
			-- 		end
			-- 	end
			-- end
			-- CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = GameRules.team_gold } );

			--城堡被摧毁则游戏失败
			if GameRules.gem_castle_hp <=0 then
				GameRules.game_status = 3
				GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
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
	
		--GameRules:SendCustomMessage(killed_unit:GetUnitName().."("..killed_unit:GetMaxHealth()..") 被击杀了", 0, 0)
		--print(GameRules.is_boss_entered)
		
		if (string.find(killed_unit:GetUnitName(), "boss") or string.find(killed_unit:GetUnitName(), "tester") ) and GameRules.is_boss_entered == false  then
			GameRules.gem_boss_damage_all = GameRules.gem_boss_damage_all + killed_unit:GetMaxHealth()
			GameRules:SendCustomMessage("#text_you_killed_the_boss", 0, 0)

			GameRules:SendCustomMessage("DAMAGE +"..killed_unit:GetMaxHealth(), 0, 0)
			GameRules.is_boss_entered = true
		end

		if killed_unit.is_jingying == true then
			GameRules.gem_boss_damage_all = GameRules.gem_boss_damage_all + killed_unit:GetMaxHealth()
			GameRules:SendCustomMessage("DAMAGE +"..killed_unit:GetMaxHealth(), 0, 0)
		end

		if keys.entindex_attacker ~= nil then
			local killer_unit = EntIndexToHScript(keys.entindex_attacker)
			local killer_owner = killer_unit:GetOwner()
			local killer_player_id = killer_owner:GetPlayerID()

			--计击杀数
			--if killer_unit.is_merged == true then
				if killer_unit.kill_count == nil then
					killer_unit.kill_count = 0
				end

				if (killed_unit ~= nil and string.find(killed_unit:GetUnitName(), "boss")) then
					killer_unit.kill_count = killer_unit.kill_count + 10

					local gongji_level = math.floor(killer_unit.kill_count/10)
					if gongji_level<=10 then
						
						local a_name = "tower_gongji"..gongji_level
						local m_name = "modifier_tower_gongji"..(gongji_level-1)
						if (killer_unit:GetUnitName() == "gemtd_xingcaihongbaoshi" or killer_unit:GetUnitName() == "gemtd_xuehonghuoshan" or killer_unit:GetUnitName() == "gemtd_jixueshi" or killer_unit:GetUnitName() == "gemtd_gudaidejixueshi" or killer_unit:GetUnitName() == "gemtd_yu" or killer_unit:GetUnitName() == "gemtd_jixiangdezhongguoyu" or killer_unit:GetUnitName() == "gemtd_ranshaozhishi") then
							a_name = "tower_mofa"..gongji_level
							m_name = "modifier_mofa_aura"..(gongji_level-1)
						end

						killer_unit:RemoveAbility(killer_unit.aaa)
						killer_unit:RemoveModifierByName(m_name)

						killer_unit:AddAbility(a_name)
						killer_unit:FindAbilityByName(a_name):SetLevel(1)

						killer_unit.aaa = a_name

						killer_unit:DestroyAllSpeechBubbles()
						killer_unit:AddSpeechBubble(1,"#text_i_level_up",3,0,-30)
					end
				else
					killer_unit.kill_count = killer_unit.kill_count + 1

					if killer_unit.kill_count%10 == 0 then
						local gongji_level = math.floor(killer_unit.kill_count/10)
						if gongji_level<=10 then
							
							local a_name = "tower_gongji"..gongji_level
							local m_name = "modifier_tower_gongji"..(gongji_level-1)
							if (killer_unit:GetUnitName() == "gemtd_xingcaihongbaoshi" or killer_unit:GetUnitName() == "gemtd_xuehonghuoshan" or killer_unit:GetUnitName() == "gemtd_jixueshi" or killer_unit:GetUnitName() == "gemtd_gudaidejixueshi" or killer_unit:GetUnitName() == "gemtd_yu" or killer_unit:GetUnitName() == "gemtd_jixiangdezhongguoyu" or killer_unit:GetUnitName() == "gemtd_ranshaozhishi") then
								a_name = "tower_mofa"..gongji_level
								m_name = "modifier_mofa_aura"..(gongji_level-1)
							end


							killer_unit:RemoveAbility(killer_unit.aaa)
							killer_unit:RemoveModifierByName(m_name)

							killer_unit:AddAbility(a_name)
							killer_unit:FindAbilityByName(a_name):SetLevel(1)

							killer_unit.aaa = a_name

							killer_unit:DestroyAllSpeechBubbles()
							killer_unit:AddSpeechBubble(1,"#text_i_level_up",3,0,-30)
						end

					end
				end
				--GameRules:SendCustomMessage(killer_unit:GetUnitName().."击杀数："..killer_unit.kill_count, 0, 0)

				
			--end
		end


		if killed_unit~= nil and not killed_unit.is_entered == true then

			--给玩家经验
			local exp_count = 5
					if GameRules.level ==10 then
						exp_count = 200
					end
					if GameRules.level ==20 then
						exp_count = 300
					end
					if GameRules.level ==30 then
						exp_count = 400
					end
					if GameRules.level ==40 then
						exp_count = 500
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
		--[[local bad_units = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                          Vector(0,0,0),
                          nil,
                          100000,
                          DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                          DOTA_UNIT_TARGET_ALL,
                          DOTA_UNIT_TARGET_FLAG_NONE,
                          FIND_ANY_ORDER,
                          false)]]
		--GameRules:SendCustomMessage("怪还剩"..GameRules.guai_live_count, 0, 0)
		if GameRules.guai_live_count<=0 and GameRules.gem_is_shuaguaiing == false then

			--是否通关了
			if GameRules.level >= table.maxn(GameRules.guai) then
				GameRules.level = GameRules.level +1
				PlayerResource:IncrementKills(0 , 1)
				PlayerResource:IncrementKills(1 , 1)
				PlayerResource:IncrementKills(2 , 1)
				PlayerResource:IncrementKills(3 , 1)
				GameRules.guai_count = 10
				EmitGlobalSound("Loot_Drop_Stinger_Arcana")
				ShowCenterMessage( "#text_win", 10 )

				send_ranking ()

				Timers:CreateTimer(10, function()
						GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
						return -1
					end)

				
				
				
			end

			--DeepPrintTable(bad_units[1])
			

			--GameRules:SendCustomMessage("怪死光了", 0, 0)
			if (killed_unit ~= nil and string.find(killed_unit:GetUnitName(), "boss")) or GameRules.is_boss_entered ==true then
				
				GameRules.is_boss_entered = false
				if GameRules.level > table.maxn(GameRules.guai)+1 then
					return
				end
				GameRules:SendCustomMessage("#text_enemy_is_stonger", 0, 0)
				Timers:CreateTimer(5, function()
						GameRules.level = GameRules.level +1
							PlayerResource:IncrementKills(0 , 1)
							PlayerResource:IncrementKills(1 , 1)
							PlayerResource:IncrementKills(2 , 1)
							PlayerResource:IncrementKills(3 , 1)
						GameRules.guai_count = 10
						start_build()
						return nil
					end)

				
			else
				GameRules.level = GameRules.level +1
				PlayerResource:IncrementKills(0 , 1)
				PlayerResource:IncrementKills(1 , 1)
				PlayerResource:IncrementKills(2 , 1)
				PlayerResource:IncrementKills(3 , 1)
				-- Before wave two, we would kindly ask if you want to save.
				-- local r = RandomInt(1, 10)
				-- if ( GameRules.level ==2 and r == 1) then
				-- 	GameRules:SendCustomMessage("#text_tip_use_save_to_store_seed", 0, 0)
				-- end
				GameRules.guai_count = 10
				start_build()
			end

		end
	end

	show_board()
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
		spawned_unit:DestroyAllSpeechBubbles()
		spawned_unit:AddSpeechBubble(0,"#text_hello",3,0,30)
		spawned_unit:SetAbilityPoints(0)


		spawned_unit:AddAbility("no_hp_bar")
		spawned_unit:FindAbilityByName("no_hp_bar"):SetLevel(1)

		spawned_unit:AddAbility("razor_plasma_field")
		spawned_unit:FindAbilityByName("razor_plasma_field"):SetLevel(1)



		--添加玩家颜色底盘
		local particle = ParticleManager:CreateParticle("particles/unit_team/unit_team_player"..(player_id+1)..".vpcf", PATTACH_ABSORIGIN_FOLLOW, spawned_unit) 
		spawned_unit.ppp = particle

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


		show_board()
	end

	Timers:CreateTimer(0.5, function()
			if (spawned_unit:IsNull()) or (not spawned_unit:IsAlive()) then
				return nil
			end

			if (spawned_unit.ftd ~= 2009) then
				DeepPrintTable(spawned_unit)
				print(spawned_unit:GetAttackDamage())
				if spawned_unit:GetAttackDamage()>2 or spawned_unit:GetHullRadius()>10 then
					zuobi()
					GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
					if GameRules.is_debug == true then
						GameRules:SendCustomMessage("非法单位: "..spawned_unit_name, 0, 0)
					end
				end

				if spawned_unit:ishero() == true then
					zuobi()
					GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
					if GameRules.is_debug == true then
						GameRules:SendCustomMessage("非法单位: "..spawned_unit_name, 0, 0)
					end
				end

				return nil
			end
		end
	)
end

function GemTD:OnPlayerSay( keys )
	DeepPrintTable(keys)
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
	elseif tokens[1] == "-save" then
		if (GameRules.game_status ~= 0) then
			save_game()
		end
	elseif tokens[1] == "-ggsimida" then
		GameRules.game_status = 3
		send_ranking ()
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	elseif tokens[1] == "-debug" then
		GameRules.is_debug = true
		GameRules:SendCustomMessage("开启调试信息", 0, 0)
	elseif tokens[1] == "-undebug" then
		GameRules.is_debug = false
		GameRules:SendCustomMessage("关闭调试信息", 0, 0)
	elseif tokens[1] == "-map" then
		GameRules:SendCustomMessage("#show_maze_pic", 0, 0)
		CustomNetTables:SetTableValue( "game_state", "show_maze_map", {map = tokens[2]} );
	end
	-- if GameRules.is_debug == true then
		
	-- end
	-- local shuohuade = EntIndexToHScript(keys.userid)

	local player = GameRules.vUserIdToPly[keys.userid]
	if GameRules.is_debug == true then
		GameRules:SendCustomMessage("玩家player="..player.."说: "..keys.text, 0, 0)
	end
	if GameRules.heroindex[player] ~= nil then
		local shuohuade = EntIndexToHScript(GameRules.heroindex[player])
		shuohuade:DestroyAllSpeechBubbles()
		shuohuade:AddSpeechBubble(1,keys.text,3,0,30)
	end
end

function gemtd_randomize(s)
	if (not s) then
		s = tostring(RandomInt(100000, 999999))
		GameRules:GetGameModeEntity().send_rank = false
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

	if GameRules.level > table.maxn(GameRules.guai)+1 then
		return
	end

	GameRules:GetGameModeEntity().is_build_ready = {
		[0] = true,
		[1] = true,
		[2] = true,
		[3] = true
	}

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

		if GameRules.is_debug == true then
			GameRules:SendCustomMessage("放置初始石头", 0, 0)
		end

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

				local u2 = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
				u2.ftd = 2009

				u2:SetOwner(PlayerResource:GetPlayer(0))
				u2:SetControllableByPlayer(0, true)
				u2:SetForwardVector(Vector(-1,-1,0))

				u2:AddAbility("no_hp_bar")
				u2:FindAbilityByName("no_hp_bar"):SetLevel(1)
				u2:RemoveModifierByName("modifier_invulnerable")
				u2:SetHullRadius(64)
			end
		end

		GameRules.is_default_builded = true

		find_all_path()
	end


	ShowCenterMessage( GameRules.guai_tips[GameRules.level], 10 )

	GameRules:SetTimeOfDay(0.3)

	GameRules.game_status = 1
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
					--GameRules:SendCustomMessage("玩家"..ii.."的英雄:"..h:GetUnitName(), 0, 0)
					--h.hero_index = ii
					GameRules:GetGameModeEntity().is_build_ready[ii]=false
					h:DestroyAllSpeechBubbles()
					h:AddSpeechBubble(1,"#text_please_build_5_stones",3,0,30)

					h:RemoveAbility("gemtd_build_stone")
					h:RemoveAbility("gemtd_remove")
					h:RemoveAbility("gemtd_jidihuixue")

					h:AddAbility("gemtd_build_stone")
					h:FindAbilityByName("gemtd_build_stone"):SetLevel(1)
					h:AddAbility("gemtd_remove")
					h:FindAbilityByName("gemtd_remove"):SetLevel(1)
					h:AddAbility("gemtd_jidihuixue")
					h:FindAbilityByName("gemtd_jidihuixue"):SetLevel(1)

					
				end
			end
		end
	end

	for i=0,3 do
		if GameRules.gem_hero[i] ~= nil then
			--GameRules:SendCustomMessage("给技能"..i, 0, 0)
			local h = GameRules.gem_hero[i]
			GameRules:GetGameModeEntity().is_build_ready[i]=false

			h:RemoveAbility("gemtd_build_stone")
			h:RemoveAbility("gemtd_remove")
			h:RemoveAbility("gemtd_jidihuixue")

			h:AddAbility("gemtd_build_stone")
			h:FindAbilityByName("gemtd_build_stone"):SetLevel(1)
			h:AddAbility("gemtd_remove")
			h:FindAbilityByName("gemtd_remove"):SetLevel(1)
			h:AddAbility("gemtd_jidihuixue")
			h:FindAbilityByName("gemtd_jidihuixue"):SetLevel(1)

		end
	end


end

--为基地回血
function gemtd_jidihuixue(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()

	local hp_count = RandomInt(1,5)

	EmitGlobalSound("DOTAMusic_Stinger.004")

	GameRules.gem_castle_hp = GameRules.gem_castle_hp + hp_count
    if GameRules.gem_castle_hp > 100 then
        GameRules.gem_castle_hp = 100
    end
    GameRules.gem_castle:SetHealth(GameRules.gem_castle_hp)

    CustomNetTables:SetTableValue( "game_state", "gem_life", { gem_life = GameRules.gem_castle_hp } );
    AMHC:CreateNumberEffect(caster,hp_count,5,AMHC.MSG_MISS,"green",0)

	--英雄同步血量
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				local h = player:GetAssignedHero()
				if h~= nil then
					h:SetHealth(GameRules.gem_castle_hp)
				end
			end
		end
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

end

--建造石头
function gemtd_build_stone(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local p = keys.target_points[1]

	local hero_level = caster:GetLevel()

	--网格化坐标
	local xxx = math.floor((p.x+64)/128)+19
	local yyy = math.floor((p.y+64)/128)+19
	p.x = math.floor((p.x+64)/128)*128
	p.y = math.floor((p.y+64)/128)*128

	--GameRules:SendCustomMessage("x="..xxx..",y="..yyy, 0, 0)

	--path1和path7附近 不能造
	if xxx>=29 and yyy<=9 then
		EmitGlobalSound("ui.crafting_gem_drop")
		caster:DestroyAllSpeechBubbles()
		caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
		return
	end

	if xxx<=10 and yyy>=31 then
		EmitGlobalSound("ui.crafting_gem_drop")
		caster:DestroyAllSpeechBubbles()
		caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
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
		caster:DestroyAllSpeechBubbles()
		caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
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
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
	if table.getn(uuu) > 0 then
		EmitGlobalSound("ui.crafting_gem_drop")
		caster:DestroyAllSpeechBubbles()
		caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
		--GameRules:SendCustomMessage("附近有友军单位了，不能造", 0, 0)
		return
	end

	--附近有友军英雄，不能造
	--[[local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                              p,
                              nil,
                              192,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_HERO,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
	if table.getn(uuu) > 0 then
		EmitGlobalSound("ui.crafting_gem_drop")
		caster:DestroyAllSpeechBubbles()
		caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,-30)
		return
	end]]

	--路径点，不能造
	for i=1,7 do
		local p1 = Entities:FindByName(nil,"path"..i):GetAbsOrigin()
		local xxx1 = math.floor((p1.x+64)/128)+19
		local yyy1 = math.floor((p1.y+64)/128)+19
		if xxx==xxx1 and yyy==yyy1 then
			EmitGlobalSound("ui.crafting_gem_drop")
			caster:DestroyAllSpeechBubbles()
			caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
			--GameRules:SendCustomMessage("路径点，不能造", 0, 0)
			return
		end
	end

	--地图范围外，不能造
	if xxx<1 or xxx>37 or yyy<1 or yyy>37 then
		EmitGlobalSound("ui.crafting_gem_drop")
		caster:DestroyAllSpeechBubbles()
		caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
		--GameRules:SendCustomMessage("地图范围外，不能造", 0, 0)
		return
	end


	GameRules:GetGameModeEntity().gem_map[yyy][xxx]=1
	--尝试寻找路径
	find_all_path()

	--路完全堵死了，不能造
	for i=1,6 do
		if table.maxn(GameRules.gem_path[i])<1 then
			EmitGlobalSound("ui.crafting_gem_drop")
			caster:DestroyAllSpeechBubbles()
			caster:AddSpeechBubble(1,"#text_donnot_block_the_path",2,0,30)
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
			if ran>=per and curr_per<per then
				curr_per = per
				stone_level = lv
			end
		end
	end

	--随机决定石头种类
	-- local ran = math.floor(ran32_modulo_m / 100) + 1

	--随机决定石头种类
	local ran = RandomInt(1,table.maxn(GameRules.gem_tower_basic))
	local create_stone_name = GameRules.gem_tower_basic[ran]..stone_level

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

	--添加玩家颜色底盘
	local particle = ParticleManager:CreateParticle("particles/unit_team/unit_team_player"..(player_id+1)..".vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
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

	if GameRules.build_index[player_id]>=5 then
		GameRules.build_index[player_id] = 0
		--GameRules:SendCustomMessage("玩家"..player_id.."选择石头", 0, 0)
		--给英雄去掉建造和拆除的技能
		--local h = PlayerResource:GetPlayer(player_id):GetAssignedHero()
		--caster:RemoveAbility("gemtd_build_stone")
		--caster:RemoveAbility("gemtd_remove")
		caster:FindAbilityByName("gemtd_build_stone"):SetLevel(0)
		caster:FindAbilityByName("gemtd_remove"):SetLevel(0)

		caster:DestroyAllSpeechBubbles()
		caster:AddSpeechBubble(1,"#text_please_select_a_stone",3,0,30)

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
			end

			GameRules.build_curr[player_id][i]:AddAbility("gemtd_choose_stone")
			GameRules.build_curr[player_id][i]:FindAbilityByName("gemtd_choose_stone"):SetLevel(1)

			if repeat_count>=4 then
				GameRules.build_curr[player_id][i]:AddAbility("gemtd_choose_update_stone")
				GameRules.build_curr[player_id][i]:FindAbilityByName("gemtd_choose_update_stone"):SetLevel(1)
				GameRules.build_curr[player_id][i]:AddAbility("gemtd_choose_update_update_stone")
				GameRules.build_curr[player_id][i]:FindAbilityByName("gemtd_choose_update_update_stone"):SetLevel(1)
			elseif repeat_count>=2 then
				GameRules.build_curr[player_id][i]:AddAbility("gemtd_choose_update_stone")
				GameRules.build_curr[player_id][i]:FindAbilityByName("gemtd_choose_update_stone"):SetLevel(1)
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

					table.insert (GameRules.gemtd_pool_can_merge_1[player_id], a_unit) 
				end
			end
		end


		-- --检查能否合成石板
		-- for h,h_merge in pairs(GameRules.gemtd_merge_shiban) do
		-- 	local can_merge = true
		-- 	local merge_pool = {}

		-- 	for k,k_unitname in pairs(h_merge) do
		-- 		local have_merge = false
		-- 		for c,c_unit in pairs(GameRules.build_curr[player_id]) do
		-- 			if c_unit:GetUnitName()==k_unitname then
		-- 				--有这个合成配方
		-- 				have_merge =true
		-- 				table.insert (merge_pool, c_unit)
		-- 			end
		-- 		end
		-- 		if have_merge==false then
		-- 			can_merge = false
		-- 		end
		-- 	end

		-- 	if can_merge == true then
		-- 		--可以合成，给它们增加技能
		-- 		GameRules.gemtd_pool_can_merge_shiban[h] = {}

		-- 		for a,a_unit in pairs(merge_pool) do
		-- 			a_unit:AddAbility(h.."_sb")
		-- 			a_unit:FindAbilityByName(h.."_sb"):SetLevel(1)
		-- 			--GameRules:SendCustomMessage("可以合成"..h, 0, 0)

		-- 			table.insert (GameRules.gemtd_pool_can_merge_shiban[player_id], a_unit) 
		-- 		end
		-- 	end
		-- end
	end
end

--移除石头
function gemtd_remove(keys)
	local caster = keys.caster
	local target = keys.target
	local owner =  caster:GetOwner()

	if target:GetUnitName() ~= "gemtd_stone" then
		caster:DestroyAllSpeechBubbles()
		caster:AddSpeechBubble(2,"#text_cannot_remove_it",3,0,30)
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
			local u = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
			u.ftd = 2009

			u:SetOwner(owner)
			u:SetControllableByPlayer(player_id, true)
			u:SetForwardVector(Vector(-1,-1,0))

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

	local u = CreateUnitByName(unit_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
	u.ftd = 2009
	u:DestroyAllSpeechBubbles()
	u:AddSpeechBubble(1,"#"..unit_name,3,0,-30)

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
	local particle = ParticleManager:CreateParticle("particles/unit_team/unit_team_player0.vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
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
					a_unit:DestroyAllSpeechBubbles()
					a_unit:AddSpeechBubble(1,"#text_can_merge_high_level_stone",3,0,-30)
					--GameRules:SendCustomMessage("可以合成"..h, 0, 0)


					table.insert (GameRules.gemtd_pool_can_merge[h], a_unit) 

					table.insert (GameRules.gemtd_pool_can_merge_all, h ) 
				end
			end

		end

	end

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
			local u = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
			u.ftd = 2009

			u:SetOwner(owner)
			u:SetControllableByPlayer(player_id, true)
			u:SetForwardVector(Vector(-1,-1,0))

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

	local u = CreateUnitByName(unit_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
	u.ftd = 2009
	u:DestroyAllSpeechBubbles()
	u:AddSpeechBubble(1,"#"..unit_name,3,0,-30)
	u:SetOwner(owner)
	u:SetControllableByPlayer(player_id, true)
	u:SetForwardVector(Vector(0,-1,0))

	u:AddAbility("no_hp_bar")
	u:FindAbilityByName("no_hp_bar"):SetLevel(1)
	u:AddAbility("gemtd_tower_select")
	u:FindAbilityByName("gemtd_tower_select"):SetLevel(1)

	--添加玩家颜色底盘
	local particle = ParticleManager:CreateParticle("particles/unit_team/unit_team_player0.vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
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
					--GameRules:SendCustomMessage("可以合成"..h, 0, 0)

					table.insert (GameRules.gemtd_pool_can_merge[h], a_unit) 

					table.insert (GameRules.gemtd_pool_can_merge_all, h ) 
				end
			end
		end
	end
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
			local u = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
			u.ftd = 2009

			u:SetOwner(owner)
			u:SetControllableByPlayer(player_id, true)
			u:SetForwardVector(Vector(-1,-1,0))

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


	local u = CreateUnitByName(unit_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
	u.ftd = 2009
	u:DestroyAllSpeechBubbles()
	u:AddSpeechBubble(1,"#"..unit_name,3,0,-30)

	u:SetOwner(owner)
	u:SetControllableByPlayer(player_id, true)
	u:SetForwardVector(Vector(0,-1,0))

	u:AddAbility("no_hp_bar")
	u:FindAbilityByName("no_hp_bar"):SetLevel(1)
	u:AddAbility("gemtd_tower_merge")
	u:FindAbilityByName("gemtd_tower_merge"):SetLevel(1)
	
	--添加玩家颜色底盘
	local particle = ParticleManager:CreateParticle("particles/unit_team/unit_team_player0.vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
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

	--所有玩家都建造就绪了，开始刷怪
	if GameRules:GetGameModeEntity().is_build_ready[0]==true and GameRules:GetGameModeEntity().is_build_ready[1]==true and GameRules:GetGameModeEntity().is_build_ready[2]==true and GameRules:GetGameModeEntity().is_build_ready[3]==true then
		GameRules.game_status = 2
		start_shuaguai()

		--检查能否合成高级塔
		--GameRules:SendCustomMessage("检查能否合成高级塔", 0, 0)
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

end

function gemtd_downgrade_stone (keys)
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
			local u = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
			u.ftd = 2009

			u:SetOwner(owner)
			u:SetControllableByPlayer(player_id, true)
			u:SetForwardVector(Vector(-1,-1,0))

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

	local u = CreateUnitByName(unit_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS)
	u.ftd = 2009 
	u:DestroyAllSpeechBubbles()
	u:AddSpeechBubble(1,"#"..unit_name,3,0,-30)

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
	local particle = ParticleManager:CreateParticle("particles/unit_team/unit_team_player0.vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
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
					a_unit:DestroyAllSpeechBubbles()
					a_unit:AddSpeechBubble(1,"#text_can_merge_high_level_stone",3,0,-30)
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
		caster:DestroyAllSpeechBubbles()
		caster:AddSpeechBubble(1,"#text_cannot_merge_now",3,0,-30)
		return
	end

	--辅助table，用来缩小can merge的范围
	local merge_helper = {};
	local total_kills = 0

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

				if i_unit.kill_count == nil then
					i_unit.kill_count = 0
				end

				--GameRules:SendCustomMessage(i_unit:GetUnitName().."待合并："..i_unit.kill_count, 0, 0)

				if i_unit.kill_count ~= nil and i_unit.kill_count > 0 then
					total_kills = total_kills + i_unit.kill_count
					--GameRules:SendCustomMessage(i_unit:GetUnitName().."待合并击杀数："..i_unit.kill_count, 0, 0)
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
			
			local u = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
			u.ftd = 2009

			u:SetOwner(owner)
			u:SetControllableByPlayer(player_id, true)
			u:SetForwardVector(Vector(-1,-1,0))

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

	if caster.kill_count == nil then
		caster.kill_count = 0
	end

	if caster.kill_count ~= nil and caster.kill_count > 0 then
		total_kills = total_kills + caster.kill_count
	end
	caster:Destroy()

	local u = CreateUnitByName(tower_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
	u.ftd = 2009
	u:DestroyAllSpeechBubbles()
	u:AddSpeechBubble(1,"#"..tower_name,3,0,-30)
	
	u:SetOwner(owner)
	u:SetControllableByPlayer(player_id, true)
	u:SetForwardVector(Vector(0,-1,0))

	u.is_merged = true
	u.kill_count = 0

	u:AddAbility("no_hp_bar")
	u:FindAbilityByName("no_hp_bar"):SetLevel(1)
	EmitGlobalSound("Loot_Drop_Stinger_Mythical")

	u:AddAbility("gemtd_tower_merge")
	u:FindAbilityByName("gemtd_tower_merge"):SetLevel(1)

	--添加玩家颜色底盘
	--local particle = ParticleManager:CreateParticle("particles/unit_team/unit_team_player"..(player_id+1)..".vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
	--u.ppp = particle

	--攻击加成奖励
	u.kill_count = total_kills
	--GameRules:SendCustomMessage(u:GetUnitName().."合并击杀数："..u.kill_count, 0, 0)

	if u.kill_count >10 then
		local gongji_level = math.floor(u.kill_count/10)
		if gongji_level>10 then
			gongji_level = 10
		end
		local a_name = "tower_gongji"..gongji_level
		if (u:GetUnitName() == "gemtd_xingcaihongbaoshi" or u:GetUnitName() == "gemtd_xuehonghuoshan" or u:GetUnitName() == "gemtd_jixueshi" or u:GetUnitName() == "gemtd_gudaidejixueshi" or u:GetUnitName() == "gemtd_yu" or u:GetUnitName() == "gemtd_jixiangdezhongguoyu" or u:GetUnitName() == "gemtd_ranshaozhishi") then
			a_name = "tower_mofa"..gongji_level
		end

		u:AddAbility(a_name)
		u:FindAbilityByName(a_name):SetLevel(1)

		u.aaa = a_name

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

	PlayerResource:IncrementAssists(0 , 1)
	PlayerResource:IncrementAssists(1 , 1)
	PlayerResource:IncrementAssists(2 , 1)
	PlayerResource:IncrementAssists(3 , 1)


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
			local u = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
			u.ftd = 2009

			u:SetOwner(owner)
			u:SetControllableByPlayer(player_id, true)
			u:SetForwardVector(Vector(-1,-1,0))

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
	u:DestroyAllSpeechBubbles()
	u:AddSpeechBubble(1,"#"..unit_name,3,0,-30)

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
	local particle = ParticleManager:CreateParticle("particles/unit_team/unit_team_player0.vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
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

	--所有玩家都建造就绪了，开始刷怪
	if GameRules:GetGameModeEntity().is_build_ready[0]==true and GameRules:GetGameModeEntity().is_build_ready[1]==true and GameRules:GetGameModeEntity().is_build_ready[2]==true and GameRules:GetGameModeEntity().is_build_ready[3]==true then
		GameRules.game_status = 2
		start_shuaguai()

		--检查能否合成高级塔
		--GameRules:SendCustomMessage("检查能否合成高级塔", 0, 0)
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
end

function gemtd_baiyin( keys )
	local caster = keys.caster
	merge_tower( "gemtd_baiyin", caster )
end

function gemtd_baiyinqishi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_baiyinqishi", caster )
end

function gemtd_kongqueshi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_kongqueshi", caster )
end

function gemtd_xianyandekongqueshi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_xianyandekongqueshi", caster )
end

function gemtd_xingcaihongbaoshi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_xingcaihongbaoshi", caster )
end

function gemtd_xuehonghuoshan( keys )
	local caster = keys.caster
	merge_tower( "gemtd_xuehonghuoshan", caster )
end

function gemtd_yu( keys )
	local caster = keys.caster
	merge_tower( "gemtd_yu", caster )
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

function gemtd_jin( keys )
	local caster = keys.caster
	merge_tower( "gemtd_jin", caster )
end

function gemtd_aijijin( keys )
	local caster = keys.caster
	merge_tower( "gemtd_aijijin", caster )
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

--一回合合成的
function gemtd_baiyin1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_baiyin", caster )
end

function gemtd_baiyinqishi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_baiyinqishi", caster )
end

function gemtd_kongqueshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_kongqueshi", caster )
end

function gemtd_xianyandekongqueshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_xianyandekongqueshi", caster )
end

function gemtd_xingcaihongbaoshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_xingcaihongbaoshi", caster )
end

function gemtd_xuehonghuoshan1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_xuehonghuoshan", caster )
end

function gemtd_yu1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_yu", caster )
end

function gemtd_jixiangdezhongguoyu1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_jixiangdezhongguoyu", caster )
end

function gemtd_furongshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_furongshi", caster )
end

function gemtd_mirendeqingjinshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_mirendeqingjinshi", caster )
end

function gemtd_heianfeicui1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_heianfeicui", caster )
end

function gemtd_huangcailanbaoshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_huangcailanbaoshi", caster )
end

function gemtd_palayibabixi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_palayibabixi", caster )
end

function gemtd_heisemaoyanshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_heisemaoyanshi", caster )
end

function gemtd_jin1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_jin", caster )
end

function gemtd_aijijin1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_aijijin", caster )
end

function gemtd_fenhongzuanshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_fenhongzuanshi", caster )
end

function gemtd_jixueshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_jixueshi", caster )
end

function gemtd_gudaidejixueshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_gudaidejixueshi", caster )
end

function gemtd_you2381( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_you238", caster )
end

function gemtd_you2351( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_you235", caster )
end
function gemtd_juxingfenhongzuanshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_juxingfenhongzuanshi", caster )
end
function gemtd_jingxindiaozhuodepalayibabixi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_jingxindiaozhuodepalayibabixi", caster )
end

--隐藏的
function gemtd_yijiazhishi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_yijiazhishi", caster )
end
function gemtd_heiyaoshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_heiyaoshi", caster )
end
function gemtd_manao1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_manao", caster )
end
function gemtd_ranshaozhishi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_ranshaozhishi", caster )
end

--石板
function gemtd_zhiliushiban_sb( keys )
	print("shiban:")
	DeepPrintTable(keys.target_points)

	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()

	local p = keys.target_points

	GameRules:SendCustomMessage("滞留石板", 0, 0)
	--local caster = keys.caster
	--merge_tower1( "gemtd_zhiliushiban", caster )

	local u = CreateUnitByName("gemtd_zhiliushiban", p[1],false,nil,nil,DOTA_TEAM_GOODGUYS) 
	u.ftd = 2009

	u:SetOwner(owner)
	u:SetControllableByPlayer(player_id, true)
	u:SetForwardVector(Vector(-1,-1,0))

	u:AddAbility("no_hp_bar")
	u:FindAbilityByName("no_hp_bar"):SetLevel(1)
	u:RemoveModifierByName("modifier_invulnerable")
	u:SetHullRadius(64)
end



--寻找所有路径
function find_all_path()
	--print('find all path...')
	--print_gem_map()
	

	GameRules.gem_maze_length = 0

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

	CustomNetTables:SetTableValue( "game_state", "gem_maze_length", { length = math.modf(GameRules.gem_maze_length) } );

	GameRules.gem_path_all = {}
	for i = 1,6 do
		for j = 1,table.maxn(GameRules.gem_path[i])-1 do
			table.insert (GameRules.gem_path_all, GameRules.gem_path[i][j])
		end
	end
	table.insert (GameRules.gem_path_all, p7)

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

	--print_gem_map()
	--print('find all path...')

	
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
	--[[
	local map = {
		{0,0,1,0,0,0,0,0,0,0},
		{0,0,1,0,0,0,0,0,0,0},
		{0,0,1,0,0,0,0,0,0,0},
		{0,1,1,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0}
	}]]
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



--显示计分面板
function show_board()
	--[[
	UTIL_ResetMessageTextAll()

	local hp_count = GameRules.gem_castle_hp / 5
	local hp_text = "\t宝石城堡 "
	for i=1,hp_count do
		hp_text = hp_text.."♥"
	end
	hp_text  = hp_text.." "..GameRules.gem_castle_hp.."%"
	UTIL_MessageTextAll(hp_text, 255, 255, 255, 255)

	
	UTIL_MessageTextAll("\t ", 255, 255, 255, 255)
	for j,j_unit in pairs(GameRules.gemtd_pool) do
		if j_unit:IsNull() then
			UTIL_MessageTextAll("\t["..j.."] null", 255, 255, 255, 255)
		else
			UTIL_MessageTextAll("\t["..j.."] "..j_unit:GetUnitName(), 255, 255, 255, 255)
		end
	end
	]]

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
function ShowCenterMessage( msg, dur )
	local msg = {
		message = msg,
		duration = dur
	}
	--print( "Sending message to all clients." )
	FireGameEvent("show_center_message",msg)
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
	local owner =  attacker:GetOwner()
	local player_id = owner:GetPlayerID()
	local damage = math.floor(keys.DamageTaken)
	if damage<=0 then
		damage = 1
	end
	
	if damage >= (GameRules.level*2) then
		AMHC:CreateNumberEffect(caster,damage,2,AMHC.MSG_DAMAGE,"red",3)
	end

end


function start_shuaguai()
	GameRules:SetTimeOfDay(0.8)
	EmitGlobalSound("GameStart.RadiantAncient")
	show_board()
	ShowCenterMessage("#"..GameRules.guai[GameRules.level], 8)

	CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = GameRules.level } );


	--GameRules:SendCustomMessage("玩家人数:"..player_count, 0, 0)

	GameRules.gem_is_shuaguaiing=true
	GameRules.guai_live_count = 0
	GameRules.guai_count = 10 --(player_count-1)*3 + 9


	--[[GameRules.gem_castle:RemoveAbility("enemy_buff1")
	GameRules.gem_castle:RemoveAbility("enemy_buff2")
	GameRules.gem_castle:RemoveAbility("enemy_buff3")
	GameRules.gem_castle:RemoveAbility("enemy_buff4")

	GameRules.gem_castle:AddAbility("enemy_buff"..player_count)
	GameRules.gem_castle:FindAbilityByName("enemy_buff"..player_count):SetLevel(1)]]

	local guai_name  = GameRules.guai[GameRules.level]
	if string.find(guai_name, "fly") then
		find_all_path_fly()
		--GameRules:SendCustomMessage("飞行怪", 0, 0)
	end
	if string.find(guai_name, "boss") then
		--find_all_path_fly()
		GameRules:SendCustomMessage("BOSS", 0, 0)
	end
end

function save_game()
	local url = "http://101.200.189.65:2009/gemtd/v6/seed/save?"
	url = url .. "player_id=" .. GameRules:GetGameModeEntity().player_ids
	url = url .. "&hero_id=" .. GameRules:GetGameModeEntity().player_heros
	url = url .. "&seed=" .. GameRules:GetGameModeEntity().seed
	print (url)
	local req = CreateHTTPRequest("GET", url)
	req:Send(function (result)
		print (result["Body"])
		local t = json.decode (result["Body"])
		if (t and t.seed == GameRules:GetGameModeEntity().seed) then
			GameRules:SendCustomMessage("#text_seed_saved", 0, 0)
		else
			GameRules:SendCustomMessage("#text_seed_save_failed", 0, 0)
		end
	end)
end

function send_ranking ()
	if GameRules.is_cheat == true then
		GameRules:SendCustomMessage("#text_no_upload_because_cheat", 0, 0)
	elseif GameRules:GetGameModeEntity().send_rank == true then
		local t = {}
		GameRules.player_count = 0
		for nPlayerID = 0, 9 do
			if ( PlayerResource:IsValidPlayer( nPlayerID ) ) then
				table.insert(t, PlayerResource:GetPlayerName(nPlayerID))
				GameRules.player_count = GameRules.player_count + 1
			end
		end
		GameRules:SendCustomMessage("#text_jiluchengji", 0, 0)
		GameRules:SendCustomMessage(table.concat(t, " "), 0, 0)
		GameRules:SendCustomMessage("LEVEL: "..GameRules.level, 0, 0)
		GameRules:SendCustomMessage("BOSS DAMAGE: "..GameRules.gem_boss_damage_all, 0, 0)

		--发送给pui来发请求
		--CustomNetTables:SetTableValue( "game_state", "send_ranking", { level = GameRules.level, boss_damage = GameRules.gem_boss_damage_all } );

		
		-- 大家好，作者祈求阅读到这里的同学不要影响其他玩家的游戏乐趣。下面是auth参数的计算方式
		-- auth 参数是用标准随机数生成方式 ANSI Multiply-with-carry，产生的第(level+1)个随机数
		-- Multiply-with-carry 随机数的生成方式请移步：
		-- https://en.wikipedia.org/wiki/Multiply-with-carry
		-- 具体实现在 randomlua.lua 文件内，谢谢大家。
		-- Help us by not uploading non-gameplay data with this API. The authors of this map would like to 
		-- thank all of the players for enjoying the game.
	
		for i = GameRules.random_seed_levels+1,GameRules.level do
			GameRules:GetGameModeEntity().rng[i] = rng:random(0)
		end
		local url= "http://101.200.189.65:2009/gemtd/v08g/ranking/add?"
		url = url .. "level=" .. GameRules.level
		url = url .. "&player_ids=" .. GameRules:GetGameModeEntity().player_ids
		url = url .. "&boss_damage=" .. GameRules.gem_boss_damage_all
		url = url .. "&player_count=" .. GameRules.player_count
		url = url .. "&time=" .. GameRules:GetGameModeEntity().start_time
		url = url .. "&seed=" .. GameRules:GetGameModeEntity().seed
		url = url .. "&auth=" .. tostring(GameRules:GetGameModeEntity().rng[GameRules.level])

		CustomNetTables:SetTableValue( "game_state", "send_http", { url = url } );



		print (url)
		-- local req = CreateHTTPRequest("GET", url)
		-- req:Send(function (result)
		-- 	DeepPrintTable (result)
		-- 	GameRules:SendCustomMessage("ok", 0, 0)
		-- end)
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
	print("hehe!!!!")
	DeepPrintTable(keys)
end