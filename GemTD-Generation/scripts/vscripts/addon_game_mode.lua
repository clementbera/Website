--宝石TD
--@author 萌小虾
if GemTD == nil then
	GemTD = class({})
end

--加载需要的模块
md5 = require('md5')
json = require('dkjson')
BASE_MODULES = {
	'pathfinder/core/heuristics',
	'pathfinder/core/node', 'pathfinder/core/path',
	'pathfinder/grid', 'pathfinder/pathfinder',
	'pathfinder/core/bheap',
	'pathfinder/search/astar', 'pathfinder/search/bfs',
	'pathfinder/search/dfs', 'pathfinder/search/dijkstra',
	'pathfinder/search/jps',  'timer/Timers',
	'bit', 'randomlua','util','barebones',
	'amhc_library/amhc','Timers','Physics',
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
userid2player = {}
isConnected = {}

--通用的
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
		"effect/omniwings/omni.vpcf",
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
		"particles/units/unit_greevil/loot_greevil_death.vpcf",
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
		"particles/units/heroes/hero_siren/siren_net_projectile.vpcf",
		"particles/units/heroes/hero_siren/siren_net.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_vengefulspirit.vsndevts",
		"particles/units/heroes/hero_dark_willow/dark_willow_bramble_projectile.vpcf",
		"particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_debuff.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_pugna.vsndevts",
		"particles/units/heroes/hero_pugna/pugna_decrepify.vpcf",
		"models/items/courier/mole_messenger/mole_messenger_lvl6_flying.vmdl",
		"particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_magic_missle.vpcf",
		"particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_stifling_dagger.vpcf",
		"particles/econ/items/bristleback/ti7_head_nasal_goo/bristleback_ti7_nasal_goo_proj.vpcf",
		"particles/units/heroes/hero_razor/razor_static_link.vpcf",
		"effect/u/u1.vpcf",
		"effect/u2/2.vpcf",
		"effect/dakongque/hantomlancer_spiritlance_projectile.vpcf",
		"effect/dabaiyin/tinker_laser.vpcf",
		"particles/econ/items/necrolyte/necronub_death_pulse/necrolyte_pulse_ka_enemy.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts",
		"effect/merge/ui/plus/ui_hero_level_4_icon_ambient.vpcf",

		"particles/units/heroes/hero_witchdoctor/witchdoctor_maledict_tick.vpcf",
		"particles/econ/items/necrolyte/necrophos_sullen/necro_sullen_pulse_enemy.vpcf",
		"particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt.vpcf",

		"models/courier/mighty_boar/mighty_boar_wings.vmdl",
		"models/courier/yak/yak_flying.vmdl",
		"models/courier/courier_mech/courier_mech_flying.vmdl",
		"models/courier/stump/stump_flying.vmdl",
		"models/courier/tegu/tegu_flying.vmdl",
		"models/items/courier/itsy/itsy_flying.vmdl",
		"models/items/courier/duskie/duskie_flying.vmdl",
		"models/items/courier/courier_faun/courier_faun_flying.vmdl",
		"models/items/courier/livery_llama_courier/livery_llama_courier_flying.vmdl",
		"models/items/courier/gnomepig/gnomepig_flying.vmdl",
		"models/items/courier/butch_pudge_dog/butch_pudge_dog_flying.vmdl",
		"models/courier/imp/imp_flying.vmdl",
		"models/items/courier/mighty_chicken/mighty_chicken_flying.vmdl",
		"models/items/courier/bajie_pig/bajie_pig_flying.vmdl",
		"models/items/courier/arneyb_rabbit/arneyb_rabbit_flying.vmdl",
		"models/courier/donkey_trio/mesh/donkey_trio_flying.vmdl",
		"models/items/courier/deathripper/deathripper_flying.vmdl",
		"models/items/courier/hermit_crab/hermit_crab_flying.vmdl",
		"models/courier/lockjaw/lockjaw_flying.vmdl",
		"models/courier/trapjaw/trapjaw_flying.vmdl",
		"models/courier/flopjaw/flopjaw_flying.vmdl",
		"models/courier/mechjaw/mechjaw_flying.vmdl",
		"models/courier/mech_donkey/mech_donkey_flying.vmdl",
		"models/items/courier/courier_mvp_redkita/courier_mvp_redkita_flying.vmdl",
		"models/items/courier/bookwyrm/bookwyrm_flying.vmdl",
		"models/courier/otter_dragon/otter_dragon_flying.vmdl",
		"models/items/courier/kanyu_shark/kanyu_shark_flying.vmdl",
		"models/items/courier/pw_zombie/pw_zombie_flying.vmdl",
		"models/items/courier/krobeling/krobeling_flying.vmdl",
		"models/items/courier/jumo/jumo_flying.vmdl",
		"models/items/courier/jumo_dire/jumo_dire_flying.vmdl",
		"models/items/courier/baekho/baekho_flying.vmdl",
		"models/items/courier/lilnova/lilnova_flying.vmdl",
		"models/items/courier/azuremircourierfinal/azuremircourierfinal_flying.vmdl",
		"models/items/courier/green_jade_dragon/green_jade_dragon_flying.vmdl",
		"models/items/courier/coral_furryfish/coral_furryfish_flying.vmdl",
		"models/items/courier/shroomy/shroomy_flying.vmdl",
		"models/items/courier/boooofus_courier/boooofus_courier_flying.vmdl",
		"models/courier/donkey_crummy_wizard_2014/donkey_crummy_wizard_2014_flying.vmdl",
		"models/courier/donkey_ti7/donkey_ti7_flying.vmdl",
		"models/courier/drodo/drodo_flying.vmdl",
		"particles/generic_gameplay/generic_stunned_old.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_alchemist.vsndevts",
		"particles/neutral_fx/gnoll_poison_debuff.vpcf",
		"particles/econ/items/viper/viper_ti7_immortal/viper_poison_crimson_debuff_ti7.vpcf",
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
--初始化1
function Activate()
	print ("GemTD START!")
	GameRules:GetGameModeEntity().AddonTemplate = GemTD()
	GameRules:GetGameModeEntity().AddonTemplate:InitGameMode()

	--监听全局定时器事件
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 0.5 )
end
function InitVaribles()
	GameRules:GetGameModeEntity().zaotui_table = {
		[0] = 0,
		[1] = 0,
		[2] = 0,
		[3] = 0
	}
	GameRules:GetGameModeEntity().level = 1
  	GameRules:GetGameModeEntity().guangzhudaobiao_race = {}
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 0)
	GameRules:SetHeroRespawnEnabled( false )
	GameRules:GetGameModeEntity():SetBuybackEnabled( false )
	GameRules:SetSameHeroSelectionEnabled( true )
	GameRules:SetGoldPerTick(0)
	GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(5)
	GameRules:GetGameModeEntity().top_runner = nil
	GameRules:GetGameModeEntity().is_maze_guide_show = false
	GameRules:GetGameModeEntity().last_mvp = {
	}
	GameRules:GetGameModeEntity().build_curr = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {}
	}
	GameRules:GetGameModeEntity().gemtd_pool = {}
	GameRules:GetGameModeEntity().gemtd_pool_race = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {}
	}
	GameRules:GetGameModeEntity().gemtd_pool_can_merge = {}
	GameRules:GetGameModeEntity().gemtd_pool_can_merge_race = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {}
	}
	GameRules:GetGameModeEntity().gemtd_pool_can_merge_1 = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {}
	}
	GameRules:GetGameModeEntity().gemtd_pool_can_merge_shiban = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {}
	}
	GameRules:GetGameModeEntity().gemtd_pool_can_merge_all = {}
	GameRules:GetGameModeEntity().gemtd_pool_can_merge_all_race = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {}
	}
	GameRules:GetGameModeEntity().usermaze = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
	}
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(
		{
			[1] = 0,
			[2] = 200,
			[3] = 550,
			[4] = 1050,
			[5] = 1700
		}
	)
	GameRules:GetGameModeEntity().DROP_PER = 1
	GameRules:GetGameModeEntity().playerInfoReceived = {}
	GameRules:GetGameModeEntity().death_stack = ""
	GameRules:GetGameModeEntity().race_stat = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
	}
	GameRules:GetGameModeEntity().maze_guide = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
	}
	GameRules:GetGameModeEntity().playerid2hero = {}
	GameRules:GetGameModeEntity().quest = {}
	GameRules:GetGameModeEntity().wave_enemy_count = 5
	GameRules:GetGameModeEntity().win_streak = 0
	GameRules:GetGameModeEntity().kuangbao_time = 0
	GameRules:GetGameModeEntity().win_streak_time = 0
	GameRules:GetGameModeEntity().perfect_this_level = true
	GameRules:GetGameModeEntity().last_g_time = 0
	GameRules:SetUseCustomHeroXPValues(true)
	GameRules:GetGameModeEntity().navi = RandomInt(1000,9999)
	GameRules:GetGameModeEntity().hero = {}
	GameRules:GetGameModeEntity().online_player_count = 0
	GameRules:GetGameModeEntity().shiban_index = {}
	GameRules:GetGameModeEntity().is_build_ready = {
		[0] = true,
		[1] = true,
		[2] = true,
		[3] = true,
	}
	GameRules:GetGameModeEntity().build_ready_wave = {
		[0] = 0,
		[1] = 0,
		[2] = 0,
		[3] = 0,
	}
	GameRules:GetGameModeEntity().enemy_live_count = {
		[0] = 0,
		[1] = 0,
		[2] = 0,
		[3] = 0,
	}
	GameRules:GetGameModeEntity().damage = {}
	GameRules:GetGameModeEntity().damage_race = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
	}
	GameRules:GetGameModeEntity().enemy_spawned_wave = 0
	GameRules:GetGameModeEntity():SetThink("DetectCheatsThinker")
	GameRules:GetGameModeEntity().is_boss_entered = false
	GameRules:GetGameModeEntity().quest_status = {
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
	GameRules:GetGameModeEntity().gem_hero = {
		[0] = nil,
		[1] = nil,
		[2] = nil,
		[3] = nil
	}
	GameRules:GetGameModeEntity().crab = nil
	GameRules:GetGameModeEntity().guangzhudaobiao = nil
	GameRules:GetGameModeEntity().hero_sea = {
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
	GameRules:GetGameModeEntity().ability_sea = {
	    a101 = "gemtd_hero_huichun",--OK
	    a102 = "gemtd_hero_shanbi",--OK
	    a103 = "gemtd_hero_shouhu",--OK
	    a105 = "gemtd_hero_beishuiyizhan",--OK

	    a201 = "gemtd_hero_lanse",--OK
	    a202 = "gemtd_hero_danbai",--OK
	    a203 = "gemtd_hero_baise",--OK
	    a204 = "gemtd_hero_hongse",--OK
	    a205 = "gemtd_hero_lvse",--OK
	    a206 = "gemtd_hero_fense",--OK
	    a207 = "gemtd_hero_huangse",--OK
	    a208 = "gemtd_hero_zise",--OK
	    a210 = "gemtd_hero_putong",--OK
	    a211 = "gemtd_hero_qingyi",--OK
	    a212 = "gemtd_hero_shitou",--OK

	    a301 = "gemtd_hero_kuaisusheji",--OK
	    a302 = "gemtd_hero_baoji",--OK
	    a303 = "gemtd_hero_miaozhun",--OK
	    a304 = "gemtd_hero_fengbaozhichui",--OK
	    a305 = "gemtd_hero_wuxia",--OK
	    a306 = "gemtd_hero_huidaoguoqu",--OK
	    a307 = "gemtd_hero_lianjie",--OK
	    a308 = "gemtd_hero_xuanfeng",--OK

	    a401 = "gemtd_hero_yixinghuanwei",--OK
	    a402 = "gemtd_hero_wanmei",--OK
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
	GameRules:GetGameModeEntity().stealable_ability_pool = {
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
		"tower_attack1","tower_attack2","tower_attack3","tower_attack4","tower_attack5","tower_attack6","tower_attack7","tower_speed1","tower_speed2",
	}
	GameRules:GetGameModeEntity().pet_list = {
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
	GameRules:GetGameModeEntity().is_crazy = false
	GameRules:GetGameModeEntity().heroindex = {}
	GameRules:GetGameModeEntity().gem_difficulty = {
		[1] = 0.6,
		[2] = 2.1,
		[3] = 4.3,
		[4] = 5.8
	}
	GameRules:GetGameModeEntity().gem_difficulty_speed = {
		[1] = 0.85,
		[2] = 1.15,
		[3] = 1.36,
		[4] = 1.58
	}
	GameRules:GetGameModeEntity().gem_difficulty_race = 1.15
	GameRules:GetGameModeEntity().gem_difficulty_speed_race = 0.6


	GameRules:GetGameModeEntity().gem_path_show = {}
	GameRules:GetGameModeEntity().table_bubbles = {}
	GameRules:GetGameModeEntity().gem_boss_damage_all = 0
	GameRules:GetGameModeEntity().kills = 0
	GameRules:GetGameModeEntity().default_stone = {
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
	GameRules:GetGameModeEntity().default_stone_race = {
	}
	GameRules:GetGameModeEntity().is_default_builded = false
	GameRules:GetGameModeEntity().gem_nandu = 0
	GameRules:GetGameModeEntity().is_debug = false
	GameRules:GetGameModeEntity().gem_path = {
		{},{},{},{},{},{}
	}
	GameRules:GetGameModeEntity().gem_path_race = {
		[0] = {{},{},{},{},{},{}},
		[1] = {{},{},{},{},{},{}},
		[2] = {{},{},{},{},{},{}},
		[3] = {{},{},{},{},{},{}},
	}

	GameRules:GetGameModeEntity().gem_path_all = {}
	GameRules:GetGameModeEntity().gem_path_all_race = {{},{},{},{}}
	GameRules:GetGameModeEntity().game_status = 0   --0 = 准备时间, 1 = 建造时间, 2 = 刷怪时间
	GameRules:GetGameModeEntity().gem_is_shuaguaiing = false
	GameRules:GetGameModeEntity().guai_count = 10
	GameRules:GetGameModeEntity().guai_count_speed = {10,10,10,10}
	GameRules:GetGameModeEntity().guai_live_count = 0
	GameRules:GetGameModeEntity().guai_live_count_speed = {0,0,0,0}

	GameRules:GetGameModeEntity().gem_player_count = 0
	GameRules:GetGameModeEntity().gem_hero_count = 0
	GameRules:GetGameModeEntity().gem_maze_length = 0
	GameRules:GetGameModeEntity().gem_maze_length_race = {
		[0] = 0,
		[1] = 0,
		[2] = 0,
		[3] = 0
	}
	GameRules:GetGameModeEntity().team_gold = 0
	GameRules:GetGameModeEntity().gem_swap = {}
	GameRules:GetGameModeEntity().is_passed = false
	GameRules:GetGameModeEntity().is_cheat = false
	GameRules:GetGameModeEntity().check_cheat_interval = 5
	GameRules:GetGameModeEntity().max_xy = 40
	GameRules:GetGameModeEntity().max_grids = GameRules:GetGameModeEntity().max_xy * GameRules:GetGameModeEntity().max_xy
	GameRules:GetGameModeEntity().start_time = 0
	GameRules:GetGameModeEntity().random_seed_levels = 1
	GameRules:GetGameModeEntity().online_player_count = 0
	GameRules:GetGameModeEntity().guai = {
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
	GameRules:GetGameModeEntity().guai_ability = {
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
		[19] = {"runrunrun"},
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
		[42] = {"runrunrun"},
		[43] = {"enemy_bukeqinfan","guai_shanbi","enemy_recharge"},
		[44] = {"enemy_shanshuo"},
		[45] = {"guai_jiaoxieguanghuan"},
		[46] = {},
		[47] = {"enemy_bukeqinfan","runrunrun"},
		[48] = {"guai_jiaoxieguanghuan","guai_shanbi"},
		[49] = {"tidehunter_kraken_shell","enemy_recharge"},
		[50] = {"tidehunter_kraken_shell"},
	}
	GameRules:GetGameModeEntity().guai_50_ability = {
		"enemy_bukeqinfan",
		"guai_shanbi",
		"guai_jiaoxieguanghuan",
		"shredder_reactive_armor",
		"enemy_recharge",
		"tidehunter_kraken_shell",
		"enemy_wumian",
		"enemy_momian",
		"enemy_zheguang",
		"enemy_shanshuo",
		"runrunrun",
	}
	GameRules:GetGameModeEntity().shiban_ability_list = {
		gemtd_youbushiban = "naga_siren_ensnare",
		gemtd_youbushiban_yin = "new_youbu2",
		gemtd_youbushiban_jin = "new_youbu3",
		gemtd_zhangqishiban = "new_venomous_gale",
		gemtd_zhangqishiban_yin = "new_venomous_gale2",
		gemtd_zhangqishiban_jin = "new_venomous_gale3",
		gemtd_hongliushiban = "new_torrent",
		gemtd_hongliushiban_yin = "new_torrent2",
		gemtd_hongliushiban_jin = "new_torrent3",
		gemtd_haojiaoshiban = "new_haojiao",
		gemtd_haojiaoshiban_yin = "new_haojiao2",
		gemtd_haojiaoshiban_jin = "new_haojiao3",
		gemtd_suanwushiban = "new_acid_spray",
		gemtd_suanwushiban_yin = "new_acid_spray2",
		gemtd_suanwushiban_jin = "new_acid_spray3",
		gemtd_mabishiban = "new_cask",
		gemtd_mabishiban_yin = "new_cask2",
		gemtd_mabishiban_jin = "new_cask3",
		gemtd_kongheshiban = "new_konghe",
		gemtd_kongheshiban_yin = "new_konghe2",
		gemtd_kongheshiban_jin = "new_konghe3",
		gemtd_xuwushiban = "new_xuwu",
		gemtd_xuwushiban_yin = "new_xuwu2",
		gemtd_xuwushiban_jin = "new_xuwu3",
	}
	--合成配方
	GameRules:GetGameModeEntity().gemtd_merge = {
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
	GameRules:GetGameModeEntity().gemtd_merge_secret = {
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
		gemtd_xiameishi = { "gemtd_r11111", "gemtd_g11111", "gemtd_b11111" },
		gemtd_ranshaozhishi = { "gemtd_r11111", "gemtd_p11111", "gemtd_r1111", "gemtd_p1111" },
		gemtd_geluanshi = { "gemtd_b11111", "gemtd_g11111", "gemtd_b1111", "gemtd_g1111" },
	}
	GameRules:GetGameModeEntity().gemtd_merge_shiban = {
		gemtd_youbushiban = { "gemtd_y111", "gemtd_d11" }, --诱捕石板√ 单控
		gemtd_zhangqishiban = { "gemtd_g111", "gemtd_e11" }, --瘴气石板√ 群减速
		gemtd_hongliushiban = { "gemtd_b111", "gemtd_q11" }, --洪流石板√ 群控群减速
		gemtd_haojiaoshiban = { "gemtd_p111", "gemtd_r11" }, --嗥叫石板√ 加塔攻击力
		gemtd_suanwushiban = { "gemtd_q111", "gemtd_y11" }, --酸雾石板√ 减怪护甲
		gemtd_mabishiban = { "gemtd_r111", "gemtd_g11" }, --麻痹石板√ 群控
		gemtd_kongheshiban = { "gemtd_d111", "gemtd_p11" }, --恐吓石板 加速加伤害
		gemtd_xuwushiban = { "gemtd_e111", "gemtd_b11" }, --虚无石板 减速加魔法伤害
	}
	GameRules:GetGameModeEntity().gemtd_merge_shiban_update = {
		gemtd_youbushiban = "gemtd_youbushiban_yin",
		gemtd_zhangqishiban = "gemtd_zhangqishiban_yin",
		gemtd_hongliushiban = "gemtd_hongliushiban_yin",
		gemtd_haojiaoshiban = "gemtd_haojiaoshiban_yin",
		gemtd_suanwushiban = "gemtd_suanwushiban_yin",
		gemtd_mabishiban = "gemtd_mabishiban_yin",
		gemtd_kongheshiban = "gemtd_kongheshiban_yin",
		gemtd_xuwushiban = "gemtd_xuwushiban_yin",
		gemtd_youbushiban_yin = "gemtd_youbushiban_jin",
		gemtd_zhangqishiban_yin = "gemtd_zhangqishiban_jin",
		gemtd_hongliushiban_yin = "gemtd_hongliushiban_jin",
		gemtd_haojiaoshiban_yin = "gemtd_haojiaoshiban_jin",
		gemtd_suanwushiban_yin = "gemtd_suanwushiban_jin",
		gemtd_mabishiban_yin = "gemtd_mabishiban_jin",
		gemtd_kongheshiban_yin = "gemtd_kongheshiban_jin",
		gemtd_xuwushiban_yin = "gemtd_xuwushiban_jin",
	}
	GameRules:GetGameModeEntity().gem_gailv = {
		[1] = { },
		[2] = { [80] = "11" },
		[3] = { [60] = "11", [90] = "111" },
		[4] = { [40] = "11", [70] = "111", [90] = "1111" },
		[5] = { [10] = "11", [40] = "111", [70] = "1111", [90] = "11111" }
	}
	GameRules:GetGameModeEntity().gem_tower_basic = {
		[1] = "gemtd_b",
		[2] = "gemtd_d",
		[3] = "gemtd_q",
		[4] = "gemtd_e",
		[5] = "gemtd_g",
		[6] = "gemtd_y",
		[7] = "gemtd_r",
		[8] = "gemtd_p"
	}
	GameRules:GetGameModeEntity().pray_gailv = {
		[1] = 40,
		[2] = 55,
		[3] = 65,
		[4] = 70,
	}
	GameRules:GetGameModeEntity().build_index = {
		[0] = 0,
		[1] = 0,
		[2] = 0,
		[3] = 0
	}

	GameRules:GetGameModeEntity().replced = {
		[0] = false, 
		[1] = false, 
		[2] = false, 
		[3] = false
	}
	GameRules:GetGameModeEntity().offset_maze = {
		[0] = {x=0,y=20},
		[1] = {x=20,y=20},
		[2] = {x=0,y=0},
		[3] = {x=20,y=0},
	}
	--创建宝石城堡
    GameRules:GetGameModeEntity().gem_castle_hp = 100
	GameRules:GetGameModeEntity().gem_castle_hp_race = { [0] = 100,[1] = 100,[2] = 100,[3] = 100 }
	GameRules:GetGameModeEntity().gem_castle = nil
	GameRules:GetGameModeEntity().gem_castle_race = { [0] = nil, [1] = nil, [2] = nil, [3] = nil }
	GameRules:GetGameModeEntity().is_precache_finished = {
		[0] = false,
		[1] = false,
		[2] = false,
		[3] = false,
	}
	local u = CreateUnitByName("gemtd_castle", Entities:FindByName(nil,"path7"):GetAbsOrigin() ,false,nil,nil, DOTA_TEAM_GOODGUYS) 
	u.ftd = 2009
	u:AddAbility("no_hp_bar")
	u:FindAbilityByName("no_hp_bar"):SetLevel(1)
	u:RemoveModifierByName("modifier_invulnerable")
	u:SetHullRadius(1)
	u:SetForwardVector(Vector(-1,0,0))
	GameRules:GetGameModeEntity().gem_castle = u

	if GetMapName()=="gemtd_race" then
		GameRules:GetGameModeEntity().gem_castle_race[0] = u

		local u = CreateUnitByName("gemtd_castle", Entities:FindByName(nil,"path17"):GetAbsOrigin() ,false,nil,nil, DOTA_TEAM_GOODGUYS) 
		u.ftd = 2009
		u:AddAbility("no_hp_bar")
		u:FindAbilityByName("no_hp_bar"):SetLevel(1)
		u:RemoveModifierByName("modifier_invulnerable")
		u:SetHullRadius(1)
		u:SetForwardVector(Vector(-1,0,0))
		GameRules:GetGameModeEntity().gem_castle_race[1] = u

		local u = CreateUnitByName("gemtd_castle", Entities:FindByName(nil,"path27"):GetAbsOrigin() ,false,nil,nil, DOTA_TEAM_GOODGUYS) 
		u.ftd = 2009
		u:AddAbility("no_hp_bar")
		u:FindAbilityByName("no_hp_bar"):SetLevel(1)
		u:RemoveModifierByName("modifier_invulnerable")
		u:SetHullRadius(1)
		u:SetForwardVector(Vector(-1,0,0))
		GameRules:GetGameModeEntity().gem_castle_race[2] = u

		local u = CreateUnitByName("gemtd_castle", Entities:FindByName(nil,"path37"):GetAbsOrigin() ,false,nil,nil, DOTA_TEAM_GOODGUYS) 
		u.ftd = 2009
		u:AddAbility("no_hp_bar")
		u:FindAbilityByName("no_hp_bar"):SetLevel(1)
		u:RemoveModifierByName("modifier_invulnerable")
		u:SetHullRadius(1)
		u:SetForwardVector(Vector(-1,0,0))
		GameRules:GetGameModeEntity().gem_castle_race[3] = u
	end

	GameRules:GetGameModeEntity().maze_race0 = {
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	}
	GameRules:GetGameModeEntity().maze_race1 = {
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0},
		{0,0,0,0,0,1,1,1,1,1,0,1,0,0,1,0,0},
		{0,0,0,0,1,0,0,0,0,0,0,1,0,1,0,0,0},
		{0,0,0,1,0,0,1,1,1,1,1,1,0,1,0,0,0},
		{0,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,0},
		{0,0,1,1,0,0,0,1,1,1,0,1,0,1,0,0,0},
		{1,1,0,1,1,1,1,1,1,1,0,1,0,1,0,0,0},
		{0,0,0,1,0,0,0,1,1,1,0,1,0,1,0,0,0},
		{0,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,0},
		{0,0,0,1,0,0,1,1,1,1,1,0,0,1,0,0,0},
		{0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,1,1,1,0,0,1,1,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0},
	}
	GameRules:GetGameModeEntity().maze_race2 = {
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0},
		{0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0},
		{0,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,0},
		{0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0},
		{0,1,0,1,0,1,1,1,1,1,1,1,0,1,0,0,0},
		{0,1,0,1,0,1,0,0,0,0,0,1,0,1,0,0,0},
		{0,1,0,1,0,0,0,1,1,1,0,1,0,1,0,0,0},
		{0,1,0,1,1,1,1,1,1,1,0,1,0,1,0,0,0},
		{0,1,0,1,0,0,0,1,1,1,0,1,0,1,0,0,0},
		{0,1,0,1,0,1,0,0,0,0,0,1,0,1,0,0,0},
		{0,1,0,1,0,1,1,1,1,1,1,1,0,1,0,0,0},
		{0,1,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0},
		{0,1,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0},
		{0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0},
		{0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	}
	GameRules:GetGameModeEntity().maze_race3 = {
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0},
		{0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0},
		{0,0,0,1,1,1,1,1,1,1,0,1,0,1,1,1,0},
		{0,0,0,1,0,0,0,0,0,0,0,1,0,1,0,0,0},
		{0,0,0,1,0,1,1,1,1,1,1,1,0,1,0,0,0},
		{0,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,0},
		{1,1,1,1,0,0,0,1,1,1,0,1,0,1,0,0,0},
		{0,0,0,1,1,1,1,1,1,1,0,1,0,1,0,0,0},
		{0,0,0,1,0,0,0,1,1,1,0,1,0,1,0,0,0},
		{0,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,0},
		{0,0,0,1,0,1,1,1,1,1,1,1,0,1,0,0,0},
		{0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0},
		{0,0,0,1,1,1,1,1,0,1,1,1,1,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0},
	}

	GameRules:GetGameModeEntity().maze_coop0 = {
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	}
	GameRules:GetGameModeEntity().maze_coop1 = {
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,1,1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,1,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0},
		{1,1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,1,1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	}
	-- GameRules:GetGameModeEntity().maze_coop1 = {
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- 	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	-- }
	GameRules:GetGameModeEntity().maze_coop2 = {
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,0,0,1,0,0,1,1,1,0,0,1,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,1,0,1,0,1,0,0,0,1,0,1,0,0,0,0,0,0,1,0,0,0},
		{0,0,0,0,1,0,0,0,0,0,1,0,1,0,1,0,0,0,1,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,1,0,0},
		{1,1,1,1,0,1,1,1,1,1,1,0,1,0,0,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,1,1,1,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,1,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	}
	GameRules:GetGameModeEntity().maze_coop3 = {
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,0,1,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,1,1,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,1,1,1,1,1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,1,0,0,0,0,0,1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,1,1,1,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,1,1,1,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{1,1,1,1,0,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,1,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,1,1,1,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,1,0,0,0,0,0,1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,1,1,1,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,1,1,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	}
	GameRules:GetGameModeEntity().maze_coop4 = {
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,1,1,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,1,1,1,0,0,1,0,1,0,0,0,0,0,0,0,0,1,0,0,0},
		{0,0,0,0,1,1,0,0,0,0,0,0,1,0,0,0,1,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0},
		{0,0,0,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0},
		{0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,1,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,1,0,0,0,0,0,0,1,0,1,0,0,1,1,1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,1,1,1,1,1,1},
		{0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,1,1,1,1,1,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	}
	GameRules:GetGameModeEntity().maze_coop5 = {
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,0,0,1,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,1,1,1,1,1,1,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,1,0,1,0,0,1,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,1,1,1,1,1,1,0,0,1,0,1,0,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,1,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,1,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,1,1,1,1,1,1,1,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,1,1,1,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,1,1,1,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0},
		{1,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1,1,1,1,1,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,1,1,1,1,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,1,1,1,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,1,1,1,1,1,1,1,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,1,0,1,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,1,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	}
	GameRules:GetGameModeEntity().maze_coop6 = {
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1,1,1,1,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,1,1,1,1,1,1,1,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,1,1,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,1,1,1,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,1,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,1,1,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,1,1,1,1,1,1,1,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	}
	GameRules:GetGameModeEntity().maze_coop7 = {
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,1,1,1,1,1,1,1,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0},
		{0,0,0,0,0,0,1,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,1,0,0,0,0,0},
		{0,0,0,0,0,0,1,0,1,0,1,0,0,1,0,0,1,1,1,1,1,0,0,1,0,0,1,0,0,1,0,1,0,0,0,0,0},
		{0,0,0,0,0,0,1,0,1,0,1,0,1,0,0,1,0,0,0,0,0,1,0,0,1,0,0,1,0,1,0,1,0,0,0,0,0},
		{0,0,0,0,0,0,1,0,1,0,1,0,0,0,1,0,0,1,1,1,0,0,1,0,0,1,0,1,0,1,0,1,0,0,0,0,0},
		{0,0,0,0,1,1,1,0,1,0,1,1,1,1,0,0,1,1,1,1,1,0,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0},
		{0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,1,1,1,1,1,1,1,0,1,0,1,0,1,0,1,0,1,1,1,1,1,1},
		{0,0,0,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0},
		{0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,1,1,1,1,1,1,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0},
		{0,0,0,0,0,0,1,1,1,1,0,1,0,1,0,0,1,1,1,1,1,0,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0},
		{0,0,0,0,0,1,0,0,0,1,0,1,0,0,1,0,0,1,1,1,0,0,1,0,0,1,0,1,0,1,0,1,0,0,0,0,0},
		{0,0,0,0,0,1,0,1,0,1,0,0,1,0,0,1,0,0,0,0,0,1,0,0,1,0,0,1,0,1,0,1,0,0,0,0,0},
		{0,0,0,0,0,1,0,1,0,0,1,0,0,1,0,0,1,1,1,1,1,0,0,1,0,0,1,0,0,1,0,1,0,0,0,0,0},
		{0,0,0,0,0,1,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,1,0,0,0,0,0},
		{0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,1,1,1,1,1,1,1,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	}
	GameRules:GetGameModeEntity().maze_coop8 = {
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0},
		{0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,1,0,0,0,0,0},
		{0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0},
		{0,0,0,0,0,0,1,0,0,1,1,1,0,0,1,0,0,0,0,0,0,0,1,0,0,1,1,1,0,0,1,0,0,0,0,0,0},
		{0,0,0,0,0,0,1,0,1,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,1,0,1,0,0,0,0,0,0},
		{0,0,0,0,0,0,1,0,1,0,1,0,0,1,0,0,1,0,0,0,1,0,0,1,0,0,1,0,1,0,1,0,0,0,0,0,0},
		{0,0,0,0,0,0,1,0,1,0,0,1,0,0,1,0,0,1,0,1,0,0,1,0,0,1,0,0,1,0,1,0,0,0,0,0,0},
		{0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,1,0,1,0,1,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0},
		{0,0,0,0,0,1,0,0,1,0,0,1,0,0,1,0,0,0,1,0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0},
		{1,1,1,1,1,0,1,0,0,1,0,0,1,0,0,1,1,1,1,1,1,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,1,1,1,1,1,1,1,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,1,0,0,1,0,1,0,1,1,1,1,1,1,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,1,1,1,1,1,1,1,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,1,1,1,1,1,1,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,1,0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,1,0,1,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,1,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,1,0,1,0,0,1,0,0,1,0,1,0,0,1,0,0,1,0,1,0,1,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,1,0,0,0,1,0,0,1,0,0,0,1,0,1,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,1,1,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,1,0,0,1,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,1,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,1,0,0,0,1,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1,1,1,0,0,1,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	}
end
--初始化2
function GemTD:InitGameMode()
	AMHCInit();

  	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 4)
  	if GetMapName() == "gemtd_1p" then
  		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 1)
  	end
	InitVaribles()
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
	
	CustomGameEventManager:RegisterListener("gather_steam_ids", Dynamic_Wrap(GemTD, "OnReceiveSteamIDs") )
	CustomGameEventManager:RegisterListener("player_share_map", Dynamic_Wrap(GemTD, "OnReceiveShareMap") )
	CustomGameEventManager:RegisterListener("gemtd_hero", Dynamic_Wrap(GemTD, "OnReceiveHeroInfo") )
	CustomGameEventManager:RegisterListener("gemtd_repick_hero", Dynamic_Wrap(GemTD, "OnRepickHero") )
	CustomGameEventManager:RegisterListener("lobster2", Dynamic_Wrap(GemTD, "OnLobster2") )
	CustomGameEventManager:RegisterListener("click_ggsimida", Dynamic_Wrap(GemTD, "OnGGsimida") )
	CustomGameEventManager:RegisterListener("catch_crab", Dynamic_Wrap(GemTD, "OnCatchCrab") )
	CustomGameEventManager:RegisterListener("preview_effect", Dynamic_Wrap(GemTD, "OnPreviewEffect") )
	CustomGameEventManager:RegisterListener("click_maze_guide_panel_coop", Dynamic_Wrap(GemTD, "OnClickMazeGuidePanelCOOP") )
	CustomGameEventManager:RegisterListener("click_maze_guide_panel_race", Dynamic_Wrap(GemTD, "OnClickMazeGuidePanelRACE") )
	CustomGameEventManager:RegisterListener("save_maze", Dynamic_Wrap(GemTD, "OnSaveMaze") )
    
end

--玩家连入游戏/重连
function GemTD:OnPlayerConnectFull (keys)
	if GameRules:GetGameModeEntity().zaotui_table[keys.PlayerID] == 1 then
		GameRules:GetGameModeEntity().zaotui_table[keys.PlayerID] = 0
	end
	-- GameRules:SendCustomMessage(concat_table_str(GameRules:GetGameModeEntity().zaotui_table),0,0)
	CustomNetTables:SetTableValue( "game_state", "player_connect", { id = keys.PlayerID, hehe = RandomInt(1,10000) } );
	if PlayerResource:GetSelectedHeroName(0) ~= nil then
		CustomNetTables:SetTableValue( "game_state", "select_hero1", { p1 = PlayerResource:GetSelectedHeroName(0), p2 = PlayerResource:GetSelectedHeroName(1), p3 = PlayerResource:GetSelectedHeroName(2), p4 = PlayerResource:GetSelectedHeroName(3) } );
	end
	userid2player[keys.userid] = keys.index+1

	--重连
	if GameRules:GetGameModeEntity().is_debug == true then
		-- GameRules:SendCustomMessage("PlayerID="..keys.PlayerID.." 的玩家加入了游戏。", 0, 0)
	end

	if isConnected[keys.index + 1] == true then
		local hero = PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero()
		-- GameRules:SendCustomMessage("PlayerID="..keys.PlayerID.." 的玩家加入了游戏。", 0, 0)
		hero:RemoveAbility("silence_self")
		hero:RemoveModifierByName("modifier_tower_chenmo")

		if GameRules:GetGameModeEntity().game_state == 1 and hero:FindAbilityByName("gemtd_build_stone"):IsActivated() == false and hero.build_level ~= GameRules:GetGameModeEntity().level then
			GameRules:GetGameModeEntity().is_build_ready[keys.PlayerID]=false

			hero:FindAbilityByName("gemtd_build_stone"):SetActivated(true)
			hero:FindAbilityByName("gemtd_remove"):SetActivated(true)

			hero.build_level = GameRules:GetGameModeEntity().level

			hero:SetMana(5.0)
		end
		
		if GameRules:GetGameModeEntity().is_debug == true then
			-- GameRules:SendCustomMessage("PlayerID="..keys.PlayerID.." 的玩家是断线重连的。", 0, 0)
		end

		--同步玩家金钱
		sync_player_gold(caster)
		
		--重连
		CustomNetTables:SetTableValue( "game_state", "reconnect", { hehe = RandomInt(1,10000) })
		show_maze_guide(keys.PlayerID,GameRules:GetGameModeEntity().usermaze[keys.PlayerID])
	end

	isConnected[keys.index+1] = true

	GameRules:GetGameModeEntity().online_player_count = GameRules:GetGameModeEntity().online_player_count + 1
	if GameRules:GetGameModeEntity().is_debug == true then
		GameRules:SendCustomMessage("当前玩家总数: "..GameRules:GetGameModeEntity().online_player_count, 0, 0)
	end
end
function concat_table_str(table)
	local str = ''
	for i,v in pairs(table) do
		str = str..'key->'..i..' val->'..v..','
	end
	return str
end
--玩家断开连接
function GemTD:OnPlayerDisconnect (keys)
	CustomNetTables:SetTableValue( "game_state", "player_disconnect", { id = keys.PlayerID, user_name = keys.name, hehe = RandomInt(1,10000) } );

	GameRules:GetGameModeEntity().online_player_count = GameRules:GetGameModeEntity().online_player_count - 1
	if GameRules:GetGameModeEntity().is_debug == true then
		GameRules:SendCustomMessage("当前玩家总数: "..GameRules:GetGameModeEntity().online_player_count, 0, 0)
	end
	local hero = PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero()
	hero:AddAbility("silence_self")
	hero:FindAbilityByName("silence_self"):SetLevel(1)
	if GameRules:GetGameModeEntity().gem_castle_hp_race[keys.PlayerID] > 0 then
		GameRules:GetGameModeEntity().zaotui_table[keys.PlayerID] = 1
	end
	-- GameRules:SendCustomMessage(concat_table_str(GameRules:GetGameModeEntity().zaotui_table),0,0)
		
	if GameRules:GetGameModeEntity().dumiao_id ~= nil and keys.PlayerID == GameRules:GetGameModeEntity().dumiao_id and GetMapName() == 'gemtd_race' then
		GemTD:OnGGsimida( {
			player_id = GameRules:GetGameModeEntity().dumiao_id
		})
	end
end
--游戏流程1——玩家选择英雄
function GemTD:OnPlayerPickHero(keys)
	local player = EntIndexToHScript(keys.player)
    local hero = EntIndexToHScript(keys.heroindex) --player:GetAssignedHero()
    hero.ftd = 2009
    SetHeroLevelShow(hero)

    if GameRules:GetGameModeEntity().replced[id] == true then
    	return
    end

    --清空占位技能
	for i=0,23 do
		if hero:GetAbilityByIndex(i) ~= nil then
			hero:RemoveAbility(hero:GetAbilityByIndex(i):GetAbilityName())
		end
	end

    --将所有玩家的英雄存到一个数组
	local heroindex = keys.heroindex
    GameRules:GetGameModeEntity().hero[heroindex] = hero
    if hero:GetUnitName() == "npc_dota_hero_riki" then
	    local pp = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
	    hero.pp = pp
	end

	-- 技能测试
	-- hero:AddAbility("let_aojiao")
	-- hero:FindAbilityByName("let_aojiao"):SetLevel(1)
	-- DeepPrintTable(hero:FindAbilityByName("riki_smoke_screen"):GetAbilityKeyValues())

	-- hero:AddAbility("new_youbu2")
	-- hero:FindAbilityByName("new_youbu2"):SetLevel(4)
	-- hero:AddAbility("new_youbu3")
	-- hero:FindAbilityByName("new_youbu3"):SetLevel(4)
	-- hero:AddAbility("new_konghe")
	-- hero:FindAbilityByName("new_konghe"):SetLevel(4)
	-- hero:AddAbility("new_xuwu")
	-- hero:FindAbilityByName("new_xuwu"):SetLevel(4)
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
    	Timers:CreateTimer(1,function()
    		CustomNetTables:SetTableValue( "game_state", "startgame",{ map_name = GetMapName(),hehe=RandomInt(1,10000)} )
    	end)
    end	
end
--游戏流程2——收集steamid
function GemTD:OnReceiveSteamIDs(keys)
	GameRules:GetGameModeEntity().player_ids = keys.steam_ids
	GameRules:GetGameModeEntity().steam_ids_only = keys.steam_ids_only
	GameRules:GetGameModeEntity().start_time = keys.start_time

	if keys.is_black == 1 then
		GameRules:SendCustomMessage("#text_black", 0, 0)
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	end

	--请求英雄数据
	GameRules:GetGameModeEntity().steam_ids = keys.steam_ids
	local pcount = PlayerResource:GetPlayerCount()..'p'
	if GetMapName() =='gemtd_race' then
		pcount ='race'
	end

	GameRules:SendCustomMessage('Connecting server...',0,0)

	local url = "http://101.200.189.65:430/gemtd/201803/heros/get/@"..keys.steam_ids.."?ver=v1&compen_shell=2&pcount="..pcount

	local req = CreateHTTPRequestScriptVM("GET", url)
	req:SetHTTPRequestAbsoluteTimeoutMS(20000)
	req:Send(function (result)
		local t = json.decode(result["Body"])

		if t['err'] == nil or t['err'] ~= 0 then
			GameRules:SendCustomMessage('Connect Server ERROR: '..t['err'],0,0)
			GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		end
		GameRules:SendCustomMessage('Connecting server OK',0,0)
		GemTD:OnLobster2({
			data = t["data"]
		})
		GameRules:GetGameModeEntity().kuangbao_time = PlayerResource:GetPlayerCount()*120 + 60
		GameRules:GetGameModeEntity().win_streak_time = GameRules:GetGameModeEntity().kuangbao_time/2


	end)

	GameRules:GetGameModeEntity().is_lobster_ok = false;
	Timers:CreateTimer(20,function ()
		if GameRules:GetGameModeEntity().is_lobster_ok == false then
			GameRules:SendCustomMessage('Connect Server Failed.',0,0)
			GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		end
	end)
end
--游戏流程3——游戏开始前的准备
function GemTD:OnLobster2(t)
	GameRules:GetGameModeEntity().is_lobster_ok = true
	local is_test_game_but_cannot_test = false
	GameRules:SendCustomMessage('Make up player heros...',0,0)
	for u,v in pairs(t["data"]) do
		if u == "76561198101849234" or u == "76561198090931971" or u == "76561198132023205" or u == "76561198079679584" then
			GameRules:GetGameModeEntity().myself = true
		end

		--随机任务
		if v.quest.quest ~= nil and v.quest.quest_expire == -2 then
			GameRules:GetGameModeEntity().quest[v.quest.quest] = GameRules:GetGameModeEntity().quest_status[v.quest.quest]
		end

		show_quest()

		GemTD:OnReceiveHeroInfo({
			heroindex = tonumber(v["hero_index"]),
			is_test_user = v["is_test_user"],
			steam_id = u,
			hero_sea = v["hero_sea"],
			onduty_hero = v["onduty_hero"],
			is_black = v["is_black"],
			pet = v["pet"],
			my_maze = v["my_maze"],
		})

		-- if GameRules:GetGameModeEntity().myself ~= true and (v["is_test_user"] == nil or v["is_test_user"] ~= true) then
		-- 	--测试模式不允许外人参与
		-- 	GameRules:SendCustomMessage('对不起，您没有参与测试模式的资格！游戏将在60秒后结束。',0,0)
		-- 	Timers:CreateTimer(60,function()
		-- 		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		-- 	end)
		-- 	is_test_game_but_cannot_test = true
		-- end
		if v["is_black"] == 1 then
			GameRules:SendCustomMessage("#text_black", 0, 0)
			GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
			return
		end
	end

	t["data"]["hehe"] = RandomInt(1,10000)

	CustomNetTables:SetTableValue( "game_state", "crab", t["data"])

	CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = GameRules:GetGameModeEntity().level, enemy_show = "gemtd_stone" } );

	if GetMapName() == 'gemtd_race' and PlayerResource:GetPlayerCount()>1 then
		CustomNetTables:SetTableValue( "game_state", "disable_all_repick", { hehe = RandomInt(1,10000) } );
	end

	Timers:CreateTimer(10,function()
		local is_all_precache_finished = true
		for i=0,PlayerResource:GetPlayerCount()-1 do
			if GameRules:GetGameModeEntity().is_precache_finished[i] == false then
				is_all_precache_finished = false
			end
		end
		if is_all_precache_finished == true then
			GameRules:SendCustomMessage('GAME START',0,0)
			if is_test_game_but_cannot_test == true then
				return
			end
			-- GameRules:SendCustomMessage("#text_game_start", 0, 0)
			GameRules:GetGameModeEntity().game_time = GameRules:GetGameTime()
			GameRules:GetGameModeEntity().game_status = 1
			start_build()
			return
		end
		return 1
	end)
end
--游戏流程4——装扮玩家英雄
function GemTD:OnReceiveHeroInfo(keys)
	local heroindex = tonumber(keys.heroindex)
	local steam_id = keys.steam_id
	local is_test_user = keys.is_test_user
	local onduty_hero = keys.onduty_hero.hero_id;
	local onduty_hero_info = keys.onduty_hero;
	local pet = keys.pet
	local my_maze = keys.my_maze

	if my_maze~=nil then
		my_maze = json.decode(my_maze)
	end
	local heroindex_old = heroindex

	local hero = EntIndexToHScript(heroindex)

	local id = hero:GetPlayerID()
	GameRules:GetGameModeEntity().usermaze[id] = my_maze
	--迷宫指南
	show_maze_guide(id,my_maze)

	local is_can_build = false
	if hero:FindAbilityByName("gemtd_build_stone") ~= nil then
		is_can_build = hero:FindAbilityByName("gemtd_build_stone"):IsActivated()
	end

	local change_pet = nil
	local change_pet_name = nil
	if hero.pet ~= nil then
		change_pet = hero.pet
	end
	if hero.pet_name ~= nil then
		change_pet_name = hero.pet_name
	end
	PrecacheUnitByNameAsync(GameRules:GetGameModeEntity().hero_sea[onduty_hero], function()
		local pppp = hero:GetAbsOrigin()
		hero:SetAbsOrigin(Vector(0,0,0))
		if hero.ppp ~= nil then
			ParticleManager:DestroyParticle(hero.ppp,true)
		end
		if hero.pp ~= nil then
			ParticleManager:DestroyParticle(hero.pp,true)
		end
		local hero_new = PlayerResource:ReplaceHeroWith(id,GameRules:GetGameModeEntity().hero_sea[onduty_hero],PlayerResource:GetGold(id),0)
		hero_new:RemoveAbility("techies_suicide")
		hero_new:RemoveAbility("techies_focused_detonate")
		hero_new:RemoveAbility("techies_land_mines")
		hero_new:RemoveAbility("techies_remote_mines")
		hero_new:RemoveAbility("techies_remote_mines_self_detonate")
		hero_new:RemoveAbility("techies_stasis_trap") 	
		hero_new:RemoveAbility("techies_minefield_sign") 	

		hero_new:SetAbsOrigin(Entities:FindByName(nil,"center"..id):GetAbsOrigin())
		FindClearSpaceForUnit(hero_new,Entities:FindByName(nil,"center"..id):GetAbsOrigin(),false)

		GameRules:GetGameModeEntity().playerid2hero[hero_new:GetPlayerID()] = hero_new

		heroindex = hero_new:GetEntityIndex()

		--存在一个table里
		GameRules:GetGameModeEntity().playerInfoReceived[heroindex] = {
			["heroindex"] = heroindex,
			["steam_id"] = steam_id,
			["onduty_hero"] = onduty_hero,
		};

		--加技能
		hero_new:RemoveAbility("gemtd_build_stone")
		hero_new:RemoveAbility("gemtd_remove")
		hero_new.build_level = GameRules:GetGameModeEntity().level

		hero_new:AddAbility("gemtd_build_stone")
		hero_new:FindAbilityByName("gemtd_build_stone"):SetLevel(1)
		hero_new:AddAbility("gemtd_remove")
		hero_new:FindAbilityByName("gemtd_remove"):SetLevel(1)

		hero_new:FindAbilityByName("gemtd_build_stone"):SetActivated(is_can_build)
		hero_new:FindAbilityByName("gemtd_remove"):SetActivated(is_can_build)
		log('玩家'..id..'添加建造技能')


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
				if GameRules:GetGameModeEntity().ability_sea[a]~=nil then
					-- print(">>>>"..GameRules:GetGameModeEntity().ability_sea[a]);
					hero_new:AddAbility(GameRules:GetGameModeEntity().ability_sea[a])
					hero_new:FindAbilityByName(GameRules:GetGameModeEntity().ability_sea[a]):SetLevel(va)
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
		if GetMapName() == 'gemtd_race' then
			hero_new:AddItemByName('item_hummer')
		end

		for iii=0,20 do
			if hero_new:GetAbilityByIndex(iii) ~= nil then
				print("ability"..iii..": "..hero_new:GetAbilityByIndex(iii):GetAbilityName())
			end
		end

		--调整技能顺序
		local temp_a = {}
		for iii,abi in pairs(hero_new.ability) do
			table.insert(temp_a,iii)
		end
		for iii,abi in pairs(temp_a) do
			if hero_new:GetAbilityByIndex(iii+1):GetAbilityName()~= GameRules:GetGameModeEntity().ability_sea[abi] then
				hero_new:SwapAbilities(GameRules:GetGameModeEntity().ability_sea[abi],hero_new:GetAbilityByIndex(iii+1):GetAbilityName(),true,true)
			end
		end

		for iii=0,20 do
			if hero_new:GetAbilityByIndex(iii) ~= nil then
				print("ability"..iii..": "..hero_new:GetAbilityByIndex(iii):GetAbilityName())
			end
		end

		-- hero_new:AddAbility('no_hp_bar')
		-- hero_new:FindAbilityByName('no_hp_bar'):SetLevel(1)
		
		play_particle("particles/radiant_fx/radiant_tower002_destruction_a2.vpcf",PATTACH_ABSORIGIN_FOLLOW,hero_new,2)

		GameRules:GetGameModeEntity().hero[heroindex_old] = nil
		GameRules:GetGameModeEntity().hero[hero_new:GetEntityIndex()] = hero_new

		CustomNetTables:SetTableValue( "game_state", "repick_hero", { old_index = heroindex_old, new_index = hero_new:GetEntityIndex() } );

		CustomNetTables:SetTableValue( "game_state", "select_hero1", { p1 = PlayerResource:GetSelectedHeroName(0), p2 = PlayerResource:GetSelectedHeroName(1), p3 = PlayerResource:GetSelectedHeroName(2), p4 = PlayerResource:GetSelectedHeroName(3) } );


		SetHeroLevelShow(hero_new)

		Timers:CreateTimer(1,function()

			--添加玩家颜色底盘
			local particle = ParticleManager:CreateParticle("particles/gem/team_"..(id+1)..".vpcf", PATTACH_ABSORIGIN_FOLLOW, hero_new) 
			hero_new.ppp = particle
			CustomNetTables:SetTableValue( "game_state", "hide_curtain", {} )

			if change_pet ~= nil then
				change_pet:Destroy()
			end
			--生成宠物
			if change_pet_name ~= nil then
				pet = change_pet_name
			end
			if pet ~= nil and GameRules:GetGameModeEntity().pet_list[pet] ~= nil then
				local my_pet = CreateUnitByName("gemtd_pet", Entities:FindByName(nil,"center"..id):GetAbsOrigin() ,false,nil,nil, DOTA_TEAM_GOODGUYS) 
				my_pet.ftd = 2009
				my_pet:SetOwner(hero_new:GetOwner())
				my_pet:SetOriginalModel(GameRules:GetGameModeEntity().pet_list[pet])
				my_pet:SetModel(GameRules:GetGameModeEntity().pet_list[pet])
				hero_new.pet = my_pet
				hero_new.pet_name = pet
				my_pet.owner = hero_new

				Timers:CreateTimer(1,function()
					if my_pet == nil or my_pet.owner == nil or my_pet:IsNull() == true or my_pet:IsAlive() == false then
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
			GameRules:GetGameModeEntity().is_precache_finished[id] = true
			GameRules:SendCustomMessage('Player '..id..' READY',0,0)
		end
		)
	end, id)
end
function show_maze_guide(id,custom_maze)
	if GetMapName() == 'gemtd_race' then
		--竞速模式
		GameRules:GetGameModeEntity().maze_guide[id] = {
			[0] = GameRules:GetGameModeEntity().maze_race0,
			[1] = GameRules:GetGameModeEntity().maze_race1,
			[2] = GameRules:GetGameModeEntity().maze_race2,
			[3] = GameRules:GetGameModeEntity().maze_race3,
		}
		if custom_maze ~= nil then
			GameRules:GetGameModeEntity().maze_guide[id][0] = custom_maze
		end
		local r = RandomFloat(0,1)

		Timers:CreateTimer(r,function()
			CustomNetTables:SetTableValue( "game_maze", "show_maze_guide", 
			{
				t = GameRules:GetGameModeEntity().maze_guide[id][0],
				map='gemtd_race',
				maze_index = 0,
				player = id,
				hehe=RandomInt(1,100000),
			})
			local t=1
			Timers:CreateTimer(0.2,function()
				if t > table.maxn(GameRules:GetGameModeEntity().maze_guide[id]) then 
					return
				end
				CustomNetTables:SetTableValue( "game_maze", "show_maze_guide", 
				{
					t = GameRules:GetGameModeEntity().maze_guide[id][t],
					map='gemtd_race',
					maze_index = t,
					hehe=RandomInt(1,100000),
				} )
				t = t + 1
				return 0.2
			end)
		end)
	else
		--合作模式
		GameRules:GetGameModeEntity().maze_guide[id] = {
			[0] = GameRules:GetGameModeEntity().maze_coop0,
			[1] = GameRules:GetGameModeEntity().maze_coop1,
			[2] = GameRules:GetGameModeEntity().maze_coop2,
			[3] = GameRules:GetGameModeEntity().maze_coop4,
		}
		if PlayerResource:GetPlayerCount() == 2 then
			GameRules:GetGameModeEntity().maze_guide[id] = {
				[0] = GameRules:GetGameModeEntity().maze_coop0,
				[1] = GameRules:GetGameModeEntity().maze_coop3,
				[2] = GameRules:GetGameModeEntity().maze_coop2,
				[3] = GameRules:GetGameModeEntity().maze_coop6,
			}
		end
		if PlayerResource:GetPlayerCount() == 3 then
			GameRules:GetGameModeEntity().maze_guide[id] = {
				[0] = GameRules:GetGameModeEntity().maze_coop0,
				[1] = GameRules:GetGameModeEntity().maze_coop5,
				[2] = GameRules:GetGameModeEntity().maze_coop6,
				[3] = GameRules:GetGameModeEntity().maze_coop8,
			}
		end
		if PlayerResource:GetPlayerCount() == 4 then
			GameRules:GetGameModeEntity().maze_guide[id] = {
				[0] = GameRules:GetGameModeEntity().maze_coop0,
				[1] = GameRules:GetGameModeEntity().maze_coop5,
				[2] = GameRules:GetGameModeEntity().maze_coop7,
				[3] = GameRules:GetGameModeEntity().maze_coop8,
			}
		end
		if custom_maze ~= nil then
			GameRules:GetGameModeEntity().maze_guide[id][0] = custom_maze
		end
		local r = RandomFloat(0,1)

		Timers:CreateTimer(r,function()
			CustomNetTables:SetTableValue( "game_maze", "show_maze_guide", 
			{
				t = GameRules:GetGameModeEntity().maze_guide[id][0],
				map='gemtd_coop',
				player = id,
				maze_index = 0,
				hehe=RandomInt(1,100000),
			} )
			local t=1
			Timers:CreateTimer(0.2,function()
				if t > table.maxn(GameRules:GetGameModeEntity().maze_guide[id]) then 
					return
				end
				CustomNetTables:SetTableValue( "game_maze", "show_maze_guide", 
				{
					t = GameRules:GetGameModeEntity().maze_guide[id][t],
					map='gemtd_coop',
					maze_index = t,
					hehe=RandomInt(1,100000),
				} )
				t = t + 1
				return 0.2
			end)
		end)
	end
end
function GemTD:OnClickMazeGuidePanelCOOP(keys)
	local player_id = keys.player_id
	local maze_index = keys.maze_index

	click_maze_guide_coop(
		GameRules:GetGameModeEntity().maze_guide[player_id][maze_index],
		player_id
	)
end
function GemTD:OnClickMazeGuidePanelRACE(keys)
	local player_id = keys.player_id
	local maze_index = keys.maze_index

	click_maze_guide_race(
		GameRules:GetGameModeEntity().maze_guide[player_id][maze_index],
		player_id
	)
end
function click_maze_guide_race(table,player_id)
	local keytable = {}
	local keycount = 1
	for i,v in pairs(table) do
		for ii,vv in pairs (v) do
			if vv == 1 then
				local xxx = (ii-19)*128
				local yyy = (18-i-19)*128
				if player_id ~= nil then
					xxx = (ii-19+GameRules:GetGameModeEntity().offset_maze[player_id].x)*128
					yyy = (18-i-19+GameRules:GetGameModeEntity().offset_maze[player_id].y)*128
				end
				local p = Vector(xxx,yyy,128)
				keytable[keycount] = p
				keycount = keycount + 1
			end
		end
	end
	CustomNetTables:SetTableValue( "game_state", "vectors_race", {t = keytable, player = player_id, hehe = RandomInt(1,100000)} );
end
function click_maze_guide_coop(t,player_id)
	if GameRules:GetGameModeEntity().is_maze_guide_show == true then
		CustomNetTables:SetTableValue( "game_state", "vectors_coop_hide", {hehe = RandomInt(1,100000)} )
		GameRules:GetGameModeEntity().is_maze_guide_show = false
		return
	end
	local keytable = {
	}
	local keycount = 1
	local keytablecount = 1
	for i,v in pairs(t) do
		for ii,vv in pairs (v) do
			if vv == 1 then
				local xxx = (ii-19)*128
				local yyy = (18-i-19)*128
				if player_id ~= nil then
					xxx = (ii-19)*128
					yyy = (38-i-19)*128
				end
				local p = Vector(xxx,yyy,128)
				if keytable[i%5] == nil then
					keytable[i%5] = {}
				end
				table.insert(keytable[i%5],p)
				keycount = keycount + 1
			end
		end
	end

	GameRules:GetGameModeEntity().is_maze_guide_show = true
	local loop = 0
	Timers:CreateTimer(function()
		CustomNetTables:SetTableValue( "game_state", "vectors_coop", {loop = loop, t = keytable[loop], hehe = RandomInt(1,100000)} )
		loop = loop + 1
		if loop > 4 then
			return
		end
		return 0.01
	end)
	
	
end
function GemTD:OnSaveMaze(keys)
	local player_id = keys.player_id
	local steam_id = keys.steam_id
	local maze_str = {}
	local game_mode = ''
	if GetMapName() == 'gemtd_race' then
		game_mode = 'race'
		local race_range = {
			[0] = { x1=1,x2=17,y1=37,y2=21 },
			[1] = { x1=21,x2=37,y1=37,y2=21 },
			[2] = { x1=1,x2=17,y1=17,y2=1 },
			[3] = { x1=21,x2=37,y1=17,y2=1 },
		}
		for i=race_range[player_id].y1,race_range[player_id].y2,-1 do
			local row = {}
			for j=race_range[player_id].x1,race_range[player_id].x2,1 do
				row[j-race_range[player_id].x1+1] = GameRules:GetGameModeEntity().gem_map[i][j]
			end
			maze_str[race_range[player_id].y1-i+1] = row
		end	
	else
		for i=37,1,-1 do
			local row = {}
			for j=1,37,1 do
				row[j] = GameRules:GetGameModeEntity().gem_map[i][j]
			end
			maze_str[38-i] = row
		end
		game_mode = ''..PlayerResource:GetPlayerCount()..'p'
	end
	--打印
	for u=1,table.maxn(maze_str) do
		local str = ""
		for v=1,table.maxn(maze_str[u]) do
			str = str..maze_str[u][v]
		end
	end

	maze_str = json.encode(maze_str)

	--发送服务器
	local r = RandomFloat(0,1)
	local url = "http://101.200.189.65:430/gemtd/maze/save/@"..steam_id..'@'..game_mode..'@'..maze_str..'?hehe='..RandomInt(1,100000)

	Timers:CreateTimer(r,function()
		local req = CreateHTTPRequestScriptVM("GET", url)
		req:SetHTTPRequestAbsoluteTimeoutMS(20000)
		req:Send(function (result)
			print(result["Body"])
			CustomNetTables:SetTableValue( "game_state", "save_maze_cb", { crab = result["Body"], player = player_id, hehe = RandomInt(1,100000)})	

			CustomNetTables:SetTableValue( "game_maze", "show_maze_guide", 
			{
				t = json.decode(maze_str),
				map='gemtd_'..game_mode,
				maze_index = 0,
				player = player_id,
				hehe=RandomInt(1,100000),
			} )
		end)
    end)
end

--游戏流程5——全局定时器事件（游戏计时、刷怪、撞击城堡）
function OnThink()
    time_tick = time_tick +1
    for i=0,3 do
    	if PlayerResource:GetPlayer(i) ~= nil and PlayerResource:GetPlayer(i):GetAssignedHero() ~= nil then
    		FindClearSpaceForUnit(PlayerResource:GetPlayer(i):GetAssignedHero(),PlayerResource:GetPlayer(i):GetAssignedHero():GetAbsOrigin(),false)
    	end
    end
    
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

		--超时加狂暴
		local time_this_level = 0
		if GameRules:GetGameModeEntity().stop_watch == nil then
			time_this_level = 0
		else
			time_this_level = math.floor(GameRules:GetGameTime() - GameRules:GetGameModeEntity().stop_watch)
		end

		if GameRules:GetGameModeEntity().stop_watch ~= nil then

			GameRules:GetGameModeEntity().kuangbao_time = PlayerResource:GetPlayerCount()*120 + 60
			GameRules:GetGameModeEntity().win_streak_time = GameRules:GetGameModeEntity().kuangbao_time/2

			--触发狂暴
			if time_this_level > GameRules:GetGameModeEntity().kuangbao_time and not GameRules:GetGameModeEntity().is_crazy == true then
				GameRules:GetGameModeEntity().is_crazy = true
				GameRules:SendCustomMessage("#text_enemy_crazy", 0, 0)
				EmitGlobalSound("diretide_eventstart_Stinger")

				GameRules:GetGameModeEntity().gem_castle:AddAbility("enemy_crazy")
				GameRules:GetGameModeEntity().gem_castle:FindAbilityByName("enemy_crazy"):SetLevel(1)
			end

			
		end

		local game_mode = '1P'
		local is_race = false
		if GetMapName() == 'gemtd_race' then
			game_mode = 'RACE'
			is_race = true
		end
		if GetMapName() == 'gemtd_coop' then
			game_mode = 'COOP'
		end

		--发送当前游戏时间给客户端
		if GameRules:GetGameModeEntity().game_time ~= nil then
			CustomGameEventManager:Send_ServerToAllClients("show_time",{
				total_time = math.floor(GameRules:GetGameTime() - GameRules:GetGameModeEntity().game_time),
				wave_time = time_this_level,
				win_streak = GameRules:GetGameModeEntity().win_streak, 
				kuangbao_time = GameRules:GetGameModeEntity().kuangbao_time,
				win_streak_time = GameRules:GetGameModeEntity().win_streak_time,
				is_race = is_race,
				game_mode = game_mode,
			})
		end

		if GetMapName() == 'gemtd_1p' or GetMapName() == 'gemtd_coop' then
			--刷怪
			if ( GameRules:GetGameModeEntity().gem_is_shuaguaiing==true and not GameRules:IsGamePaused()) then
				local ShuaGuai_entity = Entities:FindByName(nil,"path1")
				local position = ShuaGuai_entity:GetAbsOrigin() 
				position.z = 150

				GameRules:GetGameModeEntity().is_passed = false
				if GameRules:GetGameModeEntity().level > 50 then
					GameRules:GetGameModeEntity().is_passed = true
					GameRules:GetGameModeEntity().guai_level = GameRules:GetGameModeEntity().level - 50
				else
					GameRules:GetGameModeEntity().guai_level = GameRules:GetGameModeEntity().level
				end

				local u = nil

				local guai_name  = GameRules:GetGameModeEntity().guai[GameRules:GetGameModeEntity().guai_level]

				--有些关卡有特殊刷怪逻辑
				if (GameRules:GetGameModeEntity().guai_level ==35 and RandomInt(1,100)>50 ) then
					guai_name = guai_name.."1"
				end
				if (GameRules:GetGameModeEntity().guai_level ==36 and RandomInt(1,100)>50 ) then
					guai_name = guai_name.."1"
				end
				if (GameRules:GetGameModeEntity().guai_level ==38 and RandomInt(1,100)>50 ) then
					guai_name = guai_name.."1"
				end

			    u = CreateUnitByName(guai_name, position,true,nil,nil,DOTA_TEAM_BADGUYS) 
			    u.ftd = 2009
			    
			    if GameRules:GetGameModeEntity().is_debug == true then
			    	GameRules:SendCustomMessage("PlayerResource里的玩家数: "..PlayerResource:GetPlayerCount(), 0, 0)
			    end

			    if GameRules:GetGameModeEntity().gem_nandu <= PlayerResource:GetPlayerCount() then
			    	GameRules:GetGameModeEntity().gem_nandu = PlayerResource:GetPlayerCount()
			    end

			    if GameRules:GetGameModeEntity().is_debug == true then
				    GameRules:SendCustomMessage("难度等级： "..GameRules:GetGameModeEntity().gem_nandu, 0, 0)
				    GameRules:SendCustomMessage("难度系数： "..GameRules:GetGameModeEntity().gem_difficulty[GameRules:GetGameModeEntity().gem_nandu], 0, 0)
				end

			    if GameRules:GetGameModeEntity().gem_difficulty[GameRules:GetGameModeEntity().gem_nandu] == nil then
			    	GameRules:SendCustomMessage("BUG le", 0, 0)
			    end

			    --添加技能
			    for ab,abab in pairs(GameRules:GetGameModeEntity().guai_ability[GameRules:GetGameModeEntity().guai_level]) do
			    	u:AddAbility(abab)
					u:FindAbilityByName(abab):SetLevel(GameRules:GetGameModeEntity().gem_nandu)
			    end

			    local random_hit = 1
			    if (not string.find(guai_name, "boss")) and (not string.find(guai_name, "tester")) then
				    if RandomInt(1,400) <= (1) then
				    	GameRules:SendCustomMessage("#text_a_elite_enemy_is_coming", 0, 0)
				    	EmitGlobalSound("DOTA_Item.ClarityPotion.Activate")
				    	random_hit = elite_hp()
				    	u:SetModelScale(u:GetModelScale()*2.0)
				    	u.is_jingying = true
				    end
				end

			    local maxhealth = u:GetBaseMaxHealth() * GameRules:GetGameModeEntity().gem_difficulty[GameRules:GetGameModeEntity().gem_nandu] * random_hit

			    local speed_t = 1.0
			    if GameRules:GetGameModeEntity().is_passed == true then --50关以后
			    	if string.find(guai_name, "fly") then
						maxhealth = maxhealth * 0.4
					end

			    	u:SetModelScale(u:GetModelScale()*2)

			    	--随机给2个技能
			    	for iiii =1,2 do
				    	-- u:AddAbility("tidehunter_kraken_shell")
				    	-- u:FindAbilityByName("tidehunter_kraken_shell"):SetLevel(GameRules:GetGameModeEntity().gem_nandu)
				    	
				    	local random_a = RandomInt(1,table.maxn(GameRules:GetGameModeEntity().guai_50_ability))
				    	local aaaaa = GameRules:GetGameModeEntity().guai_50_ability[random_a]
				    	if aaaaa == "enemy_momian" then
				    		maxhealth = maxhealth / 3
				    	end
				    	if aaaaa == "enemy_wumian" then
				    		maxhealth = maxhealth / 2
				    	end
				    	if u:FindAbilityByName(aaaaa) == nil then
				    		u:AddAbility(aaaaa)
							u:FindAbilityByName(aaaaa):SetLevel(GameRules:GetGameModeEntity().gem_nandu)
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
				u:SetBaseMoveSpeed(u:GetBaseMoveSpeed()*GameRules:GetGameModeEntity().gem_difficulty_speed[GameRules:GetGameModeEntity().gem_nandu]*speed_t)


			    u:SetHullRadius(1)

			    u:AddAbility("no_pengzhuang")
				u:FindAbilityByName("no_pengzhuang"):SetLevel(1)

				u:SetContextNum("step",1,0)
				u.damage = 1+RandomInt(0,2)
				if GameRules:GetGameModeEntity().level >10 and GameRules:GetGameModeEntity().level <20 then
					u.damage = 1+RandomInt(0,6)
				elseif GameRules:GetGameModeEntity().level >20 and GameRules:GetGameModeEntity().level <30 then
					u.damage = 1+RandomInt(0,10)
				elseif GameRules:GetGameModeEntity().level >30 and GameRules:GetGameModeEntity().level <40 then
					u.damage = 1+RandomInt(0,14)
				elseif GameRules:GetGameModeEntity().level >40 and GameRules:GetGameModeEntity().level <50 then
					u.damage = 1+RandomInt(0,18)
				elseif GameRules:GetGameModeEntity().level >50 and GameRules:GetGameModeEntity().level <60 then
					u.damage = 1+RandomInt(0,26)
				elseif GameRules:GetGameModeEntity().level >60 and GameRules:GetGameModeEntity().level <70 then
					u.damage = 1+RandomInt(0,34)
				elseif GameRules:GetGameModeEntity().level >70 and GameRules:GetGameModeEntity().level <80 then
					u.damage = 1+RandomInt(0,42)
				elseif GameRules:GetGameModeEntity().level >80 and GameRules:GetGameModeEntity().level <90 then
					u.damage = 1+RandomInt(0,50)
				elseif GameRules:GetGameModeEntity().level >90 and GameRules:GetGameModeEntity().level <100 then
					u.damage = 1+RandomInt(0,58)
				end

				if GameRules:GetGameModeEntity().level ==10 then
					u.damage = 80
				end
				if GameRules:GetGameModeEntity().level ==20 then
					u.damage = 80
				end
				if GameRules:GetGameModeEntity().level ==30 then
					u.damage = 80
				end
				if GameRules:GetGameModeEntity().level ==40 then
					u.damage = 80
				end
				if GameRules:GetGameModeEntity().level ==50 then
					u.damage = 80
				end
				if GameRules:GetGameModeEntity().level ==60 then
					u.damage = 80
				end
				if GameRules:GetGameModeEntity().level ==70 then
					u.damage = 80
				end
				if GameRules:GetGameModeEntity().level ==80 then
					u.damage = 80
				end
				if GameRules:GetGameModeEntity().level ==90 then
					u.damage = 80
				end
				if GameRules:GetGameModeEntity().level ==100 then
					u.damage = 80
				end


				u:SetBaseDamageMin(u.damage)
				u:SetBaseDamageMax(u.damage)

				u.position = u:GetAbsOrigin() 

				GameRules:GetGameModeEntity().guai_count = GameRules:GetGameModeEntity().guai_count -1
				GameRules:GetGameModeEntity().guai_live_count = GameRules:GetGameModeEntity().guai_live_count + 1



				if string.find(guai_name, "boss") then
					--PrecacheResource( "soundfile",  zr[i], context)
					GameRules:GetGameModeEntity().guai_count = GameRules:GetGameModeEntity().guai_count -100

					-- u:AddAbility("e_snow")
					-- u:FindAbilityByName("e_snow"):SetLevel(1)
				end

				if string.find(guai_name, "tester") then		
					--PrecacheResource( "soundfile",  zr[i], context)		
					GameRules:GetGameModeEntity().guai_count = GameRules:GetGameModeEntity().guai_count -100		
				end

				--u是刚刷的怪
				--目标点数组：GameRules:GetGameModeEntity().gem_path_all

				--命令移动
				Timers:CreateTimer(0.1, function()
					if (u:IsNull()) or (not u:IsAlive()) then
						--GameRules:SendCustomMessage(u:GetUnitName().."死亡了", 0, 0)
						return nil
					end

					if (u.target == nil) then  --无目标点
						u.target = 1
						u:MoveToPosition(GameRules:GetGameModeEntity().gem_path_all[u.target]+Vector(RandomInt(-5,5),RandomInt(-5,5),0))
						return 0.1
					else  --有目标点
						if GameRules:GetGameModeEntity().gem_path_all[u.target] ~= nil and ( u:GetAbsOrigin() - GameRules:GetGameModeEntity().gem_path_all[u.target] ):Length2D() <32 then
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
								local shanshuo_steps = math.ceil(table.maxn(GameRules:GetGameModeEntity().gem_path_all) / 25)
								u.target = u.target + shanshuo_steps
								if u.target > table.maxn(GameRules:GetGameModeEntity().gem_path_all) then
									u.target = table.maxn(GameRules:GetGameModeEntity().gem_path_all)
								end
								local newOrder = {
							 		UnitIndex = u:entindex(), 
							 		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
							 		TargetIndex = nil, --Optional.  Only used when targeting units
							 		AbilityIndex = u:FindAbilityByName('antimage_blink_new'):entindex(), --Optional.  Only used when casting abilities
							 		Position = GameRules:GetGameModeEntity().gem_path_all[u.target]+Vector(RandomInt(-5,5),RandomInt(-5,5),0), --Optional.  Only used when targeting the ground
							 		Queue = 0 --Optional.  Used for queueing up abilities
							 	}
								ExecuteOrderFromTable(newOrder)

								return 0.5
							elseif u.target > 1 and u:FindAbilityByName('runrunrun') ~= nil and u:FindModifierByName('modifier_runrunrun') == nil and RandomInt(1,100)<=20 then
								local newOrder = {
							 		UnitIndex = u:entindex(), 
							 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
							 		TargetIndex = nil, --Optional.  Only used when targeting units
							 		AbilityIndex = u:FindAbilityByName('runrunrun'):entindex(), --Optional.  Only used when casting abilities
							 		Position = nil, --Optional.  Only used when targeting the ground
							 		Queue = 0 --Optional.  Used for queueing up abilities
							 	}
								ExecuteOrderFromTable(newOrder)
								return 0.1
							else
								--继续走
								u.target = u.target + 1
								if u.target > table.maxn(GameRules:GetGameModeEntity().gem_path_all) then
									u.target = table.maxn(GameRules:GetGameModeEntity().gem_path_all)
								end
								if GameRules:GetGameModeEntity().gem_path_all[u.target] ~= nil then
									u:MoveToPosition(GameRules:GetGameModeEntity().gem_path_all[u.target]+Vector(RandomInt(-5,5),RandomInt(-5,5),0))
								end
								return 0.1
							end
						else
							if u:IsNull() == true or u:IsAlive() == false then
								return
							end
							if GameRules:GetGameModeEntity().gem_path_all[u.target] ~= nil then
								u:MoveToPosition(GameRules:GetGameModeEntity().gem_path_all[u.target]+Vector(RandomInt(-5,5),RandomInt(-5,5),0))
							end
							return 0.1
						end
					end
				end)


				if GameRules:GetGameModeEntity().guai_count<=0 then
					GameRules:GetGameModeEntity().gem_is_shuaguaiing=false
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

	        		GameRules:GetGameModeEntity().gem_boss_damage_all = GameRules:GetGameModeEntity().gem_boss_damage_all + boss_damage
	        		GameRules:GetGameModeEntity().is_boss_entered = true
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

				end

				GameRules:GetGameModeEntity().gem_castle:SetHealth(GameRules:GetGameModeEntity().gem_castle_hp)

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

				--城堡被摧毁则游戏结束
				if GameRules:GetGameModeEntity().gem_castle_hp <=0 then
					GameRules:GetGameModeEntity().game_status = 3
					-- ShowCenterMessage("failed", 5)
					Timers:CreateTimer(20, function()
						if GameRules:GetGameModeEntity().level > 50 then
							GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
						else
							GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
						end
					end)
					
					send_ranking ()
					return
				end

				unit.is_entered = true
				local u_index = unit:entindex()
			   	GemTD:OnEntityKilled( {
			   		entindex_killed = u_index,
			   		entindex_attacker = u_index,
			   	})
				unit:Destroy()
			end
		end

	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end
function spawn_one_enemy(playerid,guai_name)
	-- not GameRules:IsGamePaused()
	-- 	GameRules:GetGameModeEntity().guai_count = GameRules:GetGameModeEntity().guai_count -1
	-- GameRules:GetGameModeEntity().guai_live_count = GameRules:GetGameModeEntity().guai_live_count + 1
	local ShuaGuai_entity = nil
	if playerid ~= nil then
		ShuaGuai_entity = Entities:FindByName(nil,"path"..(playerid*10+1))
	else
		ShuaGuai_entity = Entities:FindByName(nil,"path1")
	end
	
	local position = ShuaGuai_entity:GetAbsOrigin() 
	position.z = 150
	local u = CreateUnitByName(guai_name, position,true,nil,nil,DOTA_TEAM_BADGUYS) 
    u.ftd = 2009
    

    if GameRules:GetGameModeEntity().gem_nandu <= PlayerResource:GetPlayerCount() then
    	GameRules:GetGameModeEntity().gem_nandu = PlayerResource:GetPlayerCount()
    end

    --添加技能
    for ab,abab in pairs(GameRules:GetGameModeEntity().guai_ability[GameRules:GetGameModeEntity().guai_level]) do
    	if playerid ~= nil and abab == "enemy_shanshuo" then
    		abab = "runrunrun"
    	end
    	u:AddAbility(abab)
		u:FindAbilityByName(abab):SetLevel(1) --竞速模式怪技能等级都是1
    end

    --精英怪
    local random_hit = 1
    if (not string.find(guai_name, "boss")) and (not string.find(guai_name, "tester")) then
    	if PlayerResource:GetPlayer(playerid) ~= nil then
	    	if PlayerResource:GetPlayer(playerid):GetAssignedHero().jingying_zuzhou ~= nil and PlayerResource:GetPlayer(playerid):GetAssignedHero().jingying_zuzhou > 0 then
	    		if playerid == nil then
			    	GameRules:SendCustomMessage("#text_a_elite_enemy_is_coming", 0, 0)
			    	EmitGlobalSound("DOTA_Item.ClarityPotion.Activate")
			    end
		    	random_hit = elite_hp()
		    	u:SetModelScale(u:GetModelScale()*2.0)
		    	u.is_jingying = true
		    	PlayerResource:GetPlayer(playerid):GetAssignedHero().jingying_zuzhou = PlayerResource:GetPlayer(playerid):GetAssignedHero().jingying_zuzhou - 1
	    	elseif RandomInt(1,400) <= (1) then
		    	if playerid == nil then
			    	GameRules:SendCustomMessage("#text_a_elite_enemy_is_coming", 0, 0)
			    	EmitGlobalSound("DOTA_Item.ClarityPotion.Activate")
			    end
		    	random_hit = elite_hp()
		    	u:SetModelScale(u:GetModelScale()*2.0)
		    	u.is_jingying = true
		    end
		end
	end

	--堕落天使之翼变的飞行怪
	if (not string.find(guai_name, "boss")) and (not string.find(guai_name, "tester")) then
    	if PlayerResource:GetPlayer(playerid) ~= nil then
	    	if PlayerResource:GetPlayer(playerid):GetAssignedHero().fly_zuzhou ~= nil and PlayerResource:GetPlayer(playerid):GetAssignedHero().fly_zuzhou > 0 then
		    	--变成飞行模型
		    	local m = u:GetModelName()
		    	if not string.find(m, "flying") then
		    		u.is_flying = true
		    		PlayerResource:GetPlayer(playerid):GetAssignedHero().fly_zuzhou = PlayerResource:GetPlayer(playerid):GetAssignedHero().fly_zuzhou - 1

		    		local new_m = string.sub(m,1,string.len(m)-5)..'_flying.vmdl'
		    		if m == "models/courier/mighty_boar/mighty_boar.vmdl" then
		    			new_m = "models/courier/mighty_boar/mighty_boar_wings.vmdl"
		    		end
		    		if m == "models/courier/yak/yak.vmdl" then
		    			new_m = "models/courier/yak/yak_wings.vmdl"
		    		end
		    			
		    		u:SetOriginalModel(new_m)
					u:SetModel(new_m)
					u:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
					u:SetModelScale(u:GetModelScale()*1.25)
		    	end
	    	end
	    end
	end


    local maxhealth = u:GetBaseMaxHealth() * GameRules:GetGameModeEntity().gem_difficulty_race * random_hit

    local speed_t = 1.0
    if GameRules:GetGameModeEntity().is_passed == true then --50关以后
    	if string.find(guai_name, "fly") then
			maxhealth = maxhealth * 0.4
		end

    	u:SetModelScale(u:GetModelScale()*2)

    	--随机给2个技能
    	for iiii =1,2 do
	    	-- u:AddAbility("tidehunter_kraken_shell")
	    	-- u:FindAbilityByName("tidehunter_kraken_shell"):SetLevel(GameRules:GetGameModeEntity().gem_nandu)
	    	
	    	local random_a = RandomInt(1,table.maxn(GameRules:GetGameModeEntity().guai_50_ability))
	    	local aaaaa = GameRules:GetGameModeEntity().guai_50_ability[random_a]
	    	if aaaaa == "enemy_momian" then
	    		maxhealth = maxhealth / 3
	    	end
	    	if aaaaa == "enemy_wumian" then
	    		maxhealth = maxhealth / 2
	    	end
	    	if u:FindAbilityByName(aaaaa) == nil then
	    		u:AddAbility(aaaaa)
				u:FindAbilityByName(aaaaa):SetLevel(GameRules:GetGameModeEntity().gem_nandu)
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
	u:SetBaseMoveSpeed(u:GetBaseMoveSpeed()*GameRules:GetGameModeEntity().gem_difficulty_speed_race*speed_t)


    u:SetHullRadius(1)

    u:AddAbility("no_pengzhuang")
	u:FindAbilityByName("no_pengzhuang"):SetLevel(1)

	u:SetContextNum("step",1,0)
	u.damage = 1+RandomInt(0,2)
	if GameRules:GetGameModeEntity().level >10 and GameRules:GetGameModeEntity().level <20 then
		u.damage = 1+RandomInt(0,6)
	elseif GameRules:GetGameModeEntity().level >20 and GameRules:GetGameModeEntity().level <30 then
		u.damage = 1+RandomInt(0,10)
	elseif GameRules:GetGameModeEntity().level >30 and GameRules:GetGameModeEntity().level <40 then
		u.damage = 1+RandomInt(0,14)
	elseif GameRules:GetGameModeEntity().level >40 and GameRules:GetGameModeEntity().level <50 then
		u.damage = 1+RandomInt(0,18)
	elseif GameRules:GetGameModeEntity().level >50 and GameRules:GetGameModeEntity().level <60 then
		u.damage = 1+RandomInt(0,26)
	elseif GameRules:GetGameModeEntity().level >60 and GameRules:GetGameModeEntity().level <70 then
		u.damage = 1+RandomInt(0,34)
	elseif GameRules:GetGameModeEntity().level >70 and GameRules:GetGameModeEntity().level <80 then
		u.damage = 1+RandomInt(0,42)
	elseif GameRules:GetGameModeEntity().level >80 and GameRules:GetGameModeEntity().level <90 then
		u.damage = 1+RandomInt(0,50)
	elseif GameRules:GetGameModeEntity().level >90 and GameRules:GetGameModeEntity().level <100 then
		u.damage = 1+RandomInt(0,58)
	end

	if GameRules:GetGameModeEntity().level ==10 then
		u.damage = 80
	end
	if GameRules:GetGameModeEntity().level ==20 then
		u.damage = 80
	end
	if GameRules:GetGameModeEntity().level ==30 then
		u.damage = 80
	end
	if GameRules:GetGameModeEntity().level ==40 then
		u.damage = 80
	end
	if GameRules:GetGameModeEntity().level ==50 then
		u.damage = 80
	end
	if GameRules:GetGameModeEntity().level ==60 then
		u.damage = 80
	end
	if GameRules:GetGameModeEntity().level ==70 then
		u.damage = 80
	end
	if GameRules:GetGameModeEntity().level ==80 then
		u.damage = 80
	end
	if GameRules:GetGameModeEntity().level ==90 then
		u.damage = 80
	end
	if GameRules:GetGameModeEntity().level ==100 then
		u.damage = 80
	end


	u:SetBaseDamageMin(u.damage)
	u:SetBaseDamageMax(u.damage)

	u.position = u:GetAbsOrigin() 


	if playerid ~= nil then
		u.player = playerid
	end

	if playerid ~= nil then
		u.target_path = playerid*10+2
	else
		u.target_path = 2
	end
	if GameRules:GetGameModeEntity().guangzhudaobiao_race[playerid] ~= nil and u.candypassed == nil then
		u.target_path = 'gemtd_guangzhudaobiao'
		u.candypassed = true
		u.path_position = GameRules:GetGameModeEntity().guangzhudaobiao_race[playerid]:GetAbsOrigin()
	end

	--命令移动
	Timers:CreateTimer(0.1, function()
		if u==nil or (u:IsNull()) or (not u:IsAlive()) then
			return nil
		end

		local bite = bite_castle(u)
		if bite == true then
			return
		end

		if (u.target == nil) then  --无目标点
			enemy_go(u)
			return 0.1
		else  --有目标点
			if u.target ~= nil and (u:GetAbsOrigin() - u.target):Length2D() < 32 then
				--走到了，决定下一个动作
				if u == nil or u:IsNull() == true or u:IsAlive() == false then
					return
				end
				--主动技能
				if u:FindAbilityByName('enemy_zheguang') ~= nil and u:FindModifierByName('modifier_damage_absorb') == nil and RandomInt(1,100)<=2 then

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
				elseif u:FindAbilityByName('runrunrun') ~= nil and u:FindModifierByName('modifier_runrunrun') == nil and RandomInt(1,100)<=2 then
					local newOrder = {
				 		UnitIndex = u:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				 		TargetIndex = nil, --Optional.  Only used when targeting units
				 		AbilityIndex = u:FindAbilityByName('runrunrun'):entindex(), --Optional.  Only used when casting abilities
				 		Position = nil, --Optional.  Only used when targeting the ground
				 		Queue = 0 --Optional.  Used for queueing up abilities
				 	}
					ExecuteOrderFromTable(newOrder)
					return 0.1
				else
					--走到path了
					if u.target_path == "gemtd_guangzhudaobiao" and (u.target - u.path_position):Length2D() < 48 then
						if playerid ~= nil then
							u.target_path = playerid*10+2
						else
							u.target_path = 2
						end
					elseif u.target_path ~= nil and u.target_path ~= "gemtd_guangzhudaobiao" and (u.target - Entities:FindByName(nil,"path"..u.target_path):GetAbsOrigin()):Length2D() < 48 then
						u.target_path = u.target_path + 1
					end
					if Entities:FindByName(nil,"path"..u.target_path) ~= nil then
						--GO!
						enemy_go(u)
						return 0.1
					elseif u.target_path == "gemtd_guangzhudaobiao" then
						enemy_go(u)
						return 0.1
					else
						return
					end
				end	
			else
				--还没走到target
				if u == nil or u:IsNull() == ture or u:IsAlive() == false then
					return
				end
				if u.target ~= nil then
					if (rasterize_vector(u:GetAbsOrigin())-u.start):Length2D() > 150 then
						enemy_go(u)
					end
				end
				return 0.1
			end
		end
	end)
end

function enemy_go(u)
	--GO!
	if u.target_path == 'gemtd_guangzhudaobiao' then
		if string.find(u:GetUnitName(), "fly") or u.is_flying == true then
			u.target = u.path_position
			u.start = rasterize_vector(u:GetAbsOrigin())
			u:MoveToPosition(u.path_position)
		else
			u.target = find_path_one(u:GetAbsOrigin(),u.path_position)+Vector(RandomInt(-1,1),RandomInt(-1,1),0)
			u.start = rasterize_vector(u:GetAbsOrigin())
			u:MoveToPosition(u.target)
			print(u.target)
		end
	else
		if string.find(u:GetUnitName(), "fly") or u.is_flying == true then
			u.target = Entities:FindByName(nil,"path"..u.target_path):GetAbsOrigin()
			u.start = rasterize_vector(u:GetAbsOrigin())
			u:MoveToPosition(Entities:FindByName(nil,"path"..u.target_path):GetAbsOrigin())
		else
			u.target = find_path_one(u:GetAbsOrigin(),Entities:FindByName(nil,"path"..u.target_path):GetAbsOrigin())+Vector(RandomInt(-1,1),RandomInt(-1,1),0)
			u.start = rasterize_vector(u:GetAbsOrigin())
			u:MoveToPosition(u.target)
		end
	end
end
function bite_castle(u)
	if u == nil or u.player == nil then
		return false
	end
	--判断怪是否到达城堡
	local c = GameRules:GetGameModeEntity().gem_castle_race[u.player]
	if c == nil then
		return false
	end

	local u_player = u.player
	local u_index = u:entindex()

	if (u:GetAbsOrigin()-c:GetAbsOrigin()):Length2D() < 96 then
		--撞上了！
		local damage = u.damage
		if string.find(u:GetUnitName(), "boss") then
			--BOSS, 根据血量百分比计算伤害
			local boss_damage = u:GetMaxHealth() - u:GetHealth()
    		local boss_damage_per = math.floor(boss_damage / u:GetMaxHealth() * 100)

    		if damage >0 then 
        		damage = math.floor(damage * (100-boss_damage_per)/100) + 10
        	else
        		damage = 0
        	end
        end
        
        GemTD:OnEntityKilled( {
	   		entindex_killed = u_index,
	   		entindex_attacker = u_index,
	   	})
	   	u:Destroy()

        -- 判断闪避
    	if GameRules:GetGameModeEntity().gem_castle_race[u_player].shanbi ~= nil then
    		if RandomInt(0,100) < tonumber(GameRules:GetGameModeEntity().gem_castle_race[u_player].shanbi) then
    			EmitGlobalSound("n_creep_ghost.Death")
    			damage = 0
				local particle = ParticleManager:CreateParticle("particles/gem/immunity_sphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, GameRules:GetGameModeEntity().gem_castle_race[u_player]) 

				Timers:CreateTimer(2, function()
					ParticleManager:DestroyParticle(particle,true)
				end)
    		end
    	end
    	-- 判断格挡
    	if GameRules:GetGameModeEntity().gem_castle_race[u_player].shouhu ~= nil then
			EmitGlobalSound("Item.LotusOrb.Destroy")
			damage = damage - tonumber(GameRules:GetGameModeEntity().gem_castle_race[u_player].shouhu)
			if damage < 0 then
				damage = 0
			end
    	end

        GameRules:GetGameModeEntity().gem_castle_hp_race[u_player] = GameRules:GetGameModeEntity().gem_castle_hp_race[u_player] - damage

        CustomNetTables:SetTableValue( "game_state", "gem_life_race", { player = u_player, gem_life = GameRules:GetGameModeEntity().gem_castle_hp_race[u_player] } ); 

        c:SetHealth(GameRules:GetGameModeEntity().gem_castle_hp_race[u_player])
        PlayerResource:IncrementDeaths(u_player , 1)

        --显示伤害
        if damage > 0 then
			EmitSoundOn("DOTA_Item.Maim",c)
			play_particle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_sphere_final_explosion_smoke_ti5.vpcf",PATTACH_OVERHEAD_FOLLOW,c,2)
			AMHC:CreateNumberEffect(GameRules:GetGameModeEntity().playerid2hero[u_player],damage,5,AMHC.MSG_DAMAGE,"red",3)
		end
        --城堡被摧毁
		if GameRules:GetGameModeEntity().gem_castle_hp_race[u_player] <=0 then
			if GameRules:GetGameModeEntity().playerid2hero[u_player]:IsAlive() == true then
				race_player_fail(u_player)
			end
		end

		if PlayerResource:GetPlayer(u_player):GetAssignedHero():IsAlive() == true then
			PlayerResource:GetPlayer(u_player):GetAssignedHero():SetHealth(GameRules:GetGameModeEntity().gem_castle_hp_race[u_player])
		end
		
		return true
	else
		return false
	end
end

function race_player_fail(player_id)
	local hero_index = GameRules:GetGameModeEntity().playerid2hero[player_id]:GetEntityIndex()
	local steam_id = GameRules:GetGameModeEntity().playerInfoReceived[hero_index].steam_id

	if not string.find(GameRules:GetGameModeEntity().death_stack, steam_id) then
		GameRules:GetGameModeEntity().death_stack = steam_id..','..GameRules:GetGameModeEntity().death_stack
	end

	-- GameRules:SendCustomMessage('death_stack:'..GameRules:GetGameModeEntity().death_stack,0,0)
	GameRules:GetGameModeEntity().playerid2hero[player_id]:ForceKill(false)

	--添加死亡玩家的统计数据
	GameRules:GetGameModeEntity().race_stat[player_id]['steam_id'] = steam_id
	GameRules:GetGameModeEntity().race_stat[player_id]['hero'] = GameRules:GetGameModeEntity().playerid2hero[player_id]:GetUnitName()
	GameRules:GetGameModeEntity().race_stat[player_id]['wave'] = GameRules:GetGameModeEntity().level
	GameRules:GetGameModeEntity().race_stat[player_id]['kills'] = PlayerResource:GetKills(player_id)
	GameRules:GetGameModeEntity().race_stat[player_id]['miss'] = PlayerResource:GetDeaths(player_id)
	GameRules:GetGameModeEntity().race_stat[player_id]['game_time'] = math.floor(GameRules:GetGameTime() - GameRules:GetGameModeEntity().game_time)

	--是不是所有人都挂了？ 游戏结束？
	local is_all_dead = true
	local live_player_count = 0
	local last_live_player_id = nil
	for i=1,PlayerResource:GetPlayerCount() do
		if GameRules:GetGameModeEntity().gem_castle_hp_race[i-1]>0 then
			is_all_dead = false
			live_player_count = live_player_count + 1
			last_live_player_id = i-1
		end
	end

	if live_player_count == 1 then
		GameRules:GetGameModeEntity().dumiao_id = last_live_player_id
		CustomNetTables:SetTableValue( "game_state", "show_ggsimida_race", { player = last_live_player_id, hehe=RandomInt(1,10000)} )
	end

	local game_duration = math.floor(GameRules:GetGameTime() - GameRules:GetGameModeEntity().game_time)

	if is_all_dead == true then
		--全部挂了，是时候结束游戏了
		if PlayerResource:GetPlayerCount()> 1 and game_duration> 180 then
			--玩家人数大于1，就提交mmr成绩
			if GameRules:GetGameModeEntity().is_posted_game == true then
				GameRules:SendCustomMessage('成绩已经提交过了，不再重复提交。',0,0)
				return
			end
			GameRules:GetGameModeEntity().is_posted_game = true
			local url = "http://101.200.189.65:430/gemtd/race/ranking/save/@"..GameRules:GetGameModeEntity().death_stack.."?hehe="..RandomInt(1,100000)
			local bad_string = nil
			for q,vq in pairs(GameRules:GetGameModeEntity().zaotui_table) do
				if vq == 1 then
					if bad_string == nil then
						bad_string = GameRules:GetGameModeEntity().playerInfoReceived[GameRules:GetGameModeEntity().playerid2hero[q]:GetEntityIndex()].steam_id
					else
						bad_string = bad_string ..','..GameRules:GetGameModeEntity().playerInfoReceived[GameRules:GetGameModeEntity().playerid2hero[q]:GetEntityIndex()].steam_id
					end
				end
			end
			if bad_string ~= nil then
				url = url..'&badplayers='..bad_string
			end
			local req = CreateHTTPRequestScriptVM("GET", url)
			req:SetHTTPRequestAbsoluteTimeoutMS(20000)
			req:Send(function (result)
				local t = json.decode(result["Body"])

				if t['err'] == nil or t['err'] ~= 0 then
					GameRules:SendCustomMessage('Connect Server ERROR: '..t['err'],0,0)
					-- GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
				end
				
				local re = t['mmr_info']
				for i,j in pairs(re) do
					-- GameRules:SendCustomMessage(i..'-->'..j.mmr,0,0)

					for u,v in pairs(GameRules:GetGameModeEntity().race_stat) do
						if v.steam_id == i then
							GameRules:GetGameModeEntity().race_stat[u]['mmr'] = j.mmr
							GameRules:GetGameModeEntity().race_stat[u]['mmr_level'] = j.race_level
						end
					end
				end

				--把战绩表发给pui展示
				CustomNetTables:SetTableValue( "game_state", "race_gameover_show", { stat = GameRules:GetGameModeEntity().race_stat, hehe = RandomInt(1,10000) } );

			end)
		else
			--单人，也把战绩表发给pui展示
			CustomNetTables:SetTableValue( "game_state", "race_gameover_show", { stat = GameRules:GetGameModeEntity().race_stat, hehe = RandomInt(1,10000) } );
		end

		Timers:CreateTimer(30,function()
			GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
		end)
	end
end



function spawn_one_wave()
	GameRules:GetGameModeEntity().is_passed = false
	if GameRules:GetGameModeEntity().level > 50 then
		GameRules:GetGameModeEntity().is_passed = true
		GameRules:GetGameModeEntity().guai_level = GameRules:GetGameModeEntity().level - 50
	else
		GameRules:GetGameModeEntity().guai_level = GameRules:GetGameModeEntity().level
	end

	local guai_name  = GameRules:GetGameModeEntity().guai[GameRules:GetGameModeEntity().guai_level]

	ShowCenterMessage(GameRules:GetGameModeEntity().guai[GameRules:GetGameModeEntity().guai_level], 5,GameRules:GetGameModeEntity().level,10)

	CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = GameRules:GetGameModeEntity().level, enemy_show = GameRules:GetGameModeEntity().guai[GameRules:GetGameModeEntity().level] } );

	GameRules:GetGameModeEntity().enemy_spawned_wave = GameRules:GetGameModeEntity().level

	for i=1,PlayerResource:GetPlayerCount() do
		if GameRules:GetGameModeEntity().gem_castle_hp_race[i-1] > 0 then
			if string.find(guai_name, "boss") then
				GameRules:GetGameModeEntity().enemy_live_count[i-1] = GameRules:GetGameModeEntity().enemy_live_count[i-1] + 1

				for j=1,1 do
					Timers:CreateTimer(j+1,function()
						spawn_one_enemy(i-1,guai_name)
						return
					end)
				end
			else
				GameRules:GetGameModeEntity().enemy_live_count[i-1] = GameRules:GetGameModeEntity().enemy_live_count[i-1] + 10

				for j=1,10 do
					Timers:CreateTimer(j+1,function()
						guai_name  = GameRules:GetGameModeEntity().guai[GameRules:GetGameModeEntity().guai_level]
						--有些关卡有特殊刷怪逻辑
						if (GameRules:GetGameModeEntity().guai_level ==35 and RandomInt(1,100)>50 ) then
							guai_name = guai_name.."1"
						end
						if (GameRules:GetGameModeEntity().guai_level ==36 and RandomInt(1,100)>50 ) then
							guai_name = guai_name.."1"
						end
						if (GameRules:GetGameModeEntity().guai_level ==38 and RandomInt(1,100)>50 ) then
							guai_name = guai_name.."1"
						end
						spawn_one_enemy(i-1,guai_name)
						return
					end)
				end
			end
		end
	end
end
--游戏流程6——结束游戏，发送成绩
function send_ranking ()
	-- if GameRules:GetGameModeEntity().myself == false then 
	-- 	--不让外人提交测试榜单
	-- 	GameRules:SendCustomMessage('游戏结束，测试版本暂时不可以提交合作模式的成绩。',0,0)
	-- 	return
	-- end

	if GameRules:GetGameModeEntity().is_cheat == true then
		GameRules:SendCustomMessage("#text_no_upload_because_cheat", 0, 0)
	else
		if GameRules:GetGameModeEntity().is_posted_game == true then
			GameRules:SendCustomMessage('成绩已经提交过了，不再重复提交。',0,0)
			return
		end
		GameRules:GetGameModeEntity().is_posted_game = true
		local t = {}

		local g_time = GameRules:GetGameTime() - GameRules:GetGameModeEntity().game_time

		GameRules:GetGameModeEntity().player_count = 0
		for nPlayerID = 0, 9 do
			if ( PlayerResource:IsValidPlayer( nPlayerID ) ) then
				table.insert(t, PlayerResource:GetPlayerName(nPlayerID))
				GameRules:GetGameModeEntity().player_count = GameRules:GetGameModeEntity().player_count + 1
			end
		end

		--统计任务完成情况
		if g_time/60 <= 60 then
			GameRules:GetGameModeEntity().quest_status["q105"] = true
			show_quest()
		end
		if g_time/60 <= 50 then
			GameRules:GetGameModeEntity().quest_status["q209"] = true
			show_quest()
		end
		if g_time/60 <= 40 then
			GameRules:GetGameModeEntity().quest_status["q302"] = true
			show_quest()
		end

		if GameRules:GetGameModeEntity().gem_castle_hp >=100 then
			GameRules:GetGameModeEntity().quest_status["q107"] = true
			show_quest()
		else
			GameRules:GetGameModeEntity().quest_status["q107"] = false
			show_quest()
		end
		

		local no_color_count = 0
		if GameRules:GetGameModeEntity().quest_status["q201"] == true then
			no_color_count = no_color_count + 1
		end
		if GameRules:GetGameModeEntity().quest_status["q202"] == true then
			no_color_count = no_color_count + 1
		end
		if GameRules:GetGameModeEntity().quest_status["q203"] == true then
			no_color_count = no_color_count + 1
		end
		if GameRules:GetGameModeEntity().quest_status["q204"] == true then
			no_color_count = no_color_count + 1
		end
		if GameRules:GetGameModeEntity().quest_status["q205"] == true then
			no_color_count = no_color_count + 1
		end
		if GameRules:GetGameModeEntity().quest_status["q206"] == true then
			no_color_count = no_color_count + 1
		end
		if GameRules:GetGameModeEntity().quest_status["q207"] == true then
			no_color_count = no_color_count + 1
		end
		if GameRules:GetGameModeEntity().quest_status["q208"] == true then
			no_color_count = no_color_count + 1
		end

		local finishd_quest = "";
		if GameRules:GetGameModeEntity().level > 50 then
			GameRules:SendCustomMessage("FINISH QUEST: ", 0, 0)

			for m,n in pairs(GameRules:GetGameModeEntity().quest) do
				if GameRules:GetGameModeEntity().quest_status[m] == true then 
					finishd_quest = finishd_quest .. m .. ","
					GameRules:SendCustomMessage("#"..m, 0, 0)
				end
			end
			GameRules:SendCustomMessage("FAILED QUEST: ", 0, 0)
			for m,n in pairs(GameRules:GetGameModeEntity().quest) do
				if GameRules:GetGameModeEntity().quest_status[m] == false then 
					GameRules:SendCustomMessage("#"..m, 0, 0)
				end
			end
		end

		--统计towers
		local towers = {}
		for u,v in pairs(GameRules:GetGameModeEntity().gemtd_pool) do
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

		towers_str = towers_str..'|'..GameRules:GetGameModeEntity().level..'|'..g_time

		--发送给pui来发请求
		CustomNetTables:SetTableValue( "game_state", "send_ranking", { 
			level = GameRules:GetGameModeEntity().level, 
			kills = GameRules:GetGameModeEntity().kills, 
			player_ids = GameRules:GetGameModeEntity().steam_ids_only,
			player_count = GameRules:GetGameModeEntity().player_count,
			seed = GameRules:GetGameModeEntity().navi,
			start_time = GameRules:GetGameModeEntity().start_time,
			time_cost = g_time,
			finishd_quest = finishd_quest,
			towers = towers_str,
		} );
	end
end

--游戏循环1——开始建造（加建造技能）
function start_build()

	GameRules:GetGameModeEntity().game_status = 1

	GameRules:GetGameModeEntity().gem_castle:RemoveAbility("enemy_crazy")
	GameRules:GetGameModeEntity().gem_castle:RemoveModifierByName("modifier_enemy_crazy")

	GameRules:GetGameModeEntity().is_crazy = false
	GameRules:GetGameModeEntity().is_boss_entered = false

	if GetMapName() ~= "gemtd_race" then
		if GameRules:GetGameModeEntity().guangzhudaobiao ~= nil then
			GameRules:GetGameModeEntity().guangzhudaobiao:ForceKill(false)
			GameRules:GetGameModeEntity().guangzhudaobiao:Destroy()
			GameRules:GetGameModeEntity().guangzhudaobiao = nil
		end
	else
		for i,vi in pairs (GameRules:GetGameModeEntity().guangzhudaobiao_race) do
			if vi ~= nil then
				if vi:IsNull() == false then
					vi:ForceKill(false)
					vi:Destroy()
				end
				GameRules:GetGameModeEntity().guangzhudaobiao_race[i] = nil
			end
		end
	end

	if GameRules:GetGameModeEntity().level > table.maxn(GameRules:GetGameModeEntity().guai)+1 then
		return
	end

	if GameRules:GetGameModeEntity().level > 50 then
		--50关以后没有建造阶段了
		GameRules:GetGameModeEntity().game_status = 2
		if GetMapName() == 'gemtd_race' then
			GameRules:SetTimeOfDay(0.3)
			GameRules:GetGameModeEntity().stop_watch = GameRules:GetGameTime()
			EmitGlobalSound("GameStart.RadiantAncient")
			spawn_one_wave()
		else
			start_shuaguai()
		end
		return
	end
	-- Timers:CreateTimer(1,function()
		GameRules:GetGameModeEntity().stop_watch = nil
	-- end)

	if GameRules:GetGameModeEntity().is_debug == true then
		GameRules:SendCustomMessage(PlayerResource:GetSelectedHeroName(0), 0, 0)
		GameRules:SendCustomMessage(PlayerResource:GetSelectedHeroName(1), 0, 0)
		GameRules:SendCustomMessage(PlayerResource:GetSelectedHeroName(2), 0, 0)
		GameRules:SendCustomMessage(PlayerResource:GetSelectedHeroName(3), 0, 0)
	end

	if PlayerResource:GetSelectedHeroName(0) ~= nil then
		CustomNetTables:SetTableValue( "game_state", "select_hero1", { p1 = PlayerResource:GetSelectedHeroName(0), p2 = PlayerResource:GetSelectedHeroName(1), p3 = PlayerResource:GetSelectedHeroName(2), p4 = PlayerResource:GetSelectedHeroName(3) } );
	end
	
	--第一关，创建初始的石头
	if GameRules:GetGameModeEntity().level == 1 and GameRules:GetGameModeEntity().is_default_builded == false then

		GameRules:GetGameModeEntity().gem_map ={}
		for i=1,37 do
		    GameRules:GetGameModeEntity().gem_map[i] = {}   
		    for j=1,37 do
		       GameRules:GetGameModeEntity().gem_map[i][j] = 0
		    end
		end
		GameRules:GetGameModeEntity().gem_item ={}
		for i=1,37 do
		    GameRules:GetGameModeEntity().gem_item[i] = {}   
		    for j=1,37 do
		       GameRules:GetGameModeEntity().gem_item[i][j] = 0
		    end
		end
		local defult = GameRules:GetGameModeEntity().default_stone[PlayerResource:GetPlayerCount()]
		if GetMapName() =="gemtd_race" then
			defult = GameRules:GetGameModeEntity().default_stone_race

			for x=1,37 do
				GameRules:GetGameModeEntity().gem_map[19][x] = 1
				GameRules:GetGameModeEntity().gem_map[18][x] = 1
				GameRules:GetGameModeEntity().gem_map[20][x] = 1
			end
			for y=1,37 do
				GameRules:GetGameModeEntity().gem_map[y][18] = 1
				GameRules:GetGameModeEntity().gem_map[y][19] = 1
				GameRules:GetGameModeEntity().gem_map[y][20] = 1
			end
		end
		
		for i = 1,table.maxn(defult) do
			--网格化坐标
			local x = defult[i].x
			local y = defult[i].y
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
				u2:SetHullRadius(1)
			end
		end

		GameRules:GetGameModeEntity().is_default_builded = true
	end

	find_all_path()

	GameRules:SetTimeOfDay(0.8)

	EmitGlobalSound("Loot_Drop_Stinger_Legendary")
	
	--给所有英雄建造和拆除的技能
	local ii = 0
	for ii = 0, 20 do
		if ( PlayerResource:IsValidPlayer( ii ) ) then
			local player = PlayerResource:GetPlayer(ii)
			if player ~= nil then
				local h = player:GetAssignedHero()
				if h~= nil and GameRules:GetGameModeEntity().is_build_ready[ii] == true then

					log('0-20玩家'..ii..'激活建造技能')

					GameRules:GetGameModeEntity().is_build_ready[ii]=false
					h.build_level = GameRules:GetGameModeEntity().level

					h:FindAbilityByName("gemtd_build_stone"):SetActivated(true)
					h:FindAbilityByName("gemtd_remove"):SetActivated(true)
					h:SetMana(5.0)

					--只有建造阶段能用的技能
					SetAbilityActiveStatus(h,true)

					set_build_hummer(ii, GameRules:GetGameModeEntity().level-GameRules:GetGameModeEntity().build_ready_wave[ii])
				end
			end
		end
	end

	for i=0,3 do
		if GameRules:GetGameModeEntity().gem_hero[i] ~= nil and GameRules:GetGameModeEntity().is_build_ready[i] == true then
			local h = GameRules:GetGameModeEntity().gem_hero[i]
			
			GameRules:GetGameModeEntity().is_build_ready[i]=false

			log('0-3玩家'..i..'激活建造技能')

			h.build_level = GameRules:GetGameModeEntity().level
			h:FindAbilityByName("gemtd_build_stone"):SetActivated(true)
			h:FindAbilityByName("gemtd_remove"):SetActivated(true)

			h:SetMana(5.0)


			SetAbilityActiveStatus(h,true)
		end
	end
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
--游戏循环2——建造石头（建完5个就判断能否一回合合成）
function gemtd_build_stone(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local p = keys.target_points[1]

	local hero_level = caster:GetLevel()
	
	CustomNetTables:SetTableValue( "game_state", "disable_repick", { heroindex = caster:GetEntityIndex(), hehe = RandomInt(1,10000) } );

	--网格化坐标
	local xxx = math.floor((p.x+64)/128)+19
	local yyy = math.floor((p.y+64)/128)+19
	p.x = math.floor((p.x+64)/128)*128
	p.y = math.floor((p.y+64)/128)*128

	if GetMapName()=='gemtd_1p' or GetMapName()=='gemtd_coop' then
		if xxx>=29 and yyy<=9 then
			EmitGlobalSound("ui.crafting_gem_drop")
			return
		end
		if xxx<=9 and yyy>=29 then
			EmitGlobalSound("ui.crafting_gem_drop")
			return
		end
	end

	--竞速模式，不能在别人的区域建造
	if GetMapName() == 'gemtd_race' then
		if check_area(player_id,p) == false then	
			EmitGlobalSound("ui.crafting_gem_drop")
			return false
		end
	end

	--附近有怪，不能造
	local uu = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              p,
                              nil,
                              64,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
	if table.getn(uu) > 0 then
		EmitGlobalSound("ui.crafting_gem_drop")
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
	if GetMapName() ~= "gemtd_race" then
		for i=1,7 do
			local p1 = Entities:FindByName(nil,"path"..i):GetAbsOrigin()
			local xxx1 = math.floor((p1.x+64)/128)+19
			local yyy1 = math.floor((p1.y+64)/128)+19
			if xxx==xxx1 and yyy==yyy1 then
				EmitGlobalSound("ui.crafting_gem_drop")
				return
			end
		end
	end
	if GetMapName() == "gemtd_race" then
		for j=0,3 do
			for i=1,7 do
				local p1 = Entities:FindByName(nil,"path"..((10*j)+i)):GetAbsOrigin()
				local xxx1 = math.floor((p1.x+64)/128)+19
				local yyy1 = math.floor((p1.y+64)/128)+19
				if xxx==xxx1 and yyy==yyy1 then
					EmitGlobalSound("ui.crafting_gem_drop")
					return
				end
			end
		end
	end
	

	--地图范围外，不能造
	if xxx<1 or xxx>37 or yyy<1 or yyy>37 then
		EmitGlobalSound("ui.crafting_gem_drop")
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

	if GetMapName() == 'gemtd_1p' or GetMapName() == 'gemtd_coop' then
		--合作模式判断堵路
		find_all_path()
		--路完全堵死了，不能造
		for i=1,6 do
			if table.maxn(GameRules:GetGameModeEntity().gem_path[i])<1 then
				EmitGlobalSound("ui.crafting_gem_drop")
				--回退地图，重新寻路
				GameRules:GetGameModeEntity().gem_map[yyy][xxx]=0

				find_all_path()
				return
			end
		end
	else
		--竞速模式判断堵路
		find_all_path_race(player_id)
		--路完全堵死了，不能造
		for i=1,6 do
			if table.maxn(GameRules:GetGameModeEntity().gem_path_race[player_id][i])<1 then
				EmitGlobalSound("ui.crafting_gem_drop")
				--回退地图，重新寻路
				GameRules:GetGameModeEntity().gem_map[yyy][xxx]=0
				find_all_path_race(player_id)
				return
			end
		end
		
		--判断是否所有我的怪都能走到他的target_path
		local pathok = true
		local vv = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              p,
                              nil,
                              9999,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
		for k,vk in pairs(vv) do
			if vk.player == player_id then
				if string.find(vk:GetUnitName(), "fly") == nil then
					local targetp = nil
					if vk.target_path ~= nil and vk.target_path == 'gemtd_guangzhudaobiao' then
						targetp = GameRules:GetGameModeEntity().guangzhudaobiao_race[player_id]:GetAbsOrigin()
					elseif vk.target_path ~= nil then
						targetp = Entities:FindByName(nil,"path"..vk.target_path):GetAbsOrigin()
					end
					local check_result = check_path_race(vk:GetAbsOrigin(),targetp)
					if check_result == false then
						pathok = false
						break
					end
				end
			end
		end
		if pathok == false then
			EmitGlobalSound("ui.crafting_gem_drop")
			--回退地图，重新寻路
			GameRules:GetGameModeEntity().gem_map[yyy][xxx]=0
			find_all_path_race(player_id)
			return
		end
	end
	

	---------------------------------------------------------------------
	--至此验证ok了，可以正式开始建造石头了
	--------------------------------------------------------------------
	
	local ran = RandomInt(1,100)
	local stone_level = "1"
	local curr_per = 0
	if GameRules:GetGameModeEntity().gem_gailv[hero_level] ~= nil then
		for per,lv in pairs(GameRules:GetGameModeEntity().gem_gailv[hero_level]) do
			if ran>per and curr_per<=per then
				curr_per = per
				stone_level = lv
			end
		end
	end
	if caster.pray_level ~= nil and GetMapName() ~= "gemtd_race" and GameRules:GetGameModeEntity().perfected ~= true then
		if RandomInt(1,100) < tonumber(caster.pray_l) then
			stone_level = tonumber(caster.pray_level)
			GameRules:GetGameModeEntity().perfected = true
		end
	end
	if caster.pray_level ~= nil and GetMapName() == "gemtd_race" and caster.perfected ~= true then
		if RandomInt(1,100) < tonumber(caster.pray_l) then
			stone_level = tonumber(caster.pray_level)
			caster.perfected = true
		end
	end
	caster.pray_level = nil
	caster.pray_l = nil

	--随机决定石头种类
	local ran = RandomInt(1,table.maxn(GameRules:GetGameModeEntity().gem_tower_basic))
	if caster.pray ~= nil then
		if RandomInt(1,100) < tonumber(caster.pray) then
			ran = tonumber(caster.pray_color)
		end
	end
	caster.pray_color = nil
	caster.pray = nil
	
	local create_stone_name = GameRules:GetGameModeEntity().gem_tower_basic[ran]..stone_level

	if GameRules:GetGameModeEntity().crab ~= nil then
		create_stone_name = "gemtd_"..GameRules:GetGameModeEntity().crab
		GameRules:GetGameModeEntity().crab = nil
	end

	--创建石头
	u = CreateUnitByName(create_stone_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS)
	u.ftd = 2009
	u:SetOwner(caster)
	u:SetControllableByPlayer(player_id, true)
	u:SetForwardVector(Vector(0,-1,0))
	u:AddAbility("no_hp_bar")
	u:FindAbilityByName("no_hp_bar"):SetLevel(1)
	u:AddAbility("gemtd_tower_new")
	u:FindAbilityByName("gemtd_tower_new"):SetLevel(1)

	EmitGlobalSound("Item.DropWorld")

	--添加玩家颜色底盘
	local particle = ParticleManager:CreateParticle("particles/gem/team_"..(player_id+1)..".vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
	u.ppp = particle


	u:RemoveModifierByName("modifier_invulnerable")
	u:SetHullRadius(1)

	GameRules:GetGameModeEntity().build_curr[player_id][GameRules:GetGameModeEntity().build_index[player_id]] = u
	GameRules:GetGameModeEntity().build_index[player_id] = GameRules:GetGameModeEntity().build_index[player_id] +1
	send_merge_board(player_id)

	caster:SetMana(5 - GameRules:GetGameModeEntity().build_index[player_id])
	--已经建完5个了
	if GameRules:GetGameModeEntity().build_index[player_id]>=5 then
		GameRules:GetGameModeEntity().build_index[player_id] = 0

		caster:FindAbilityByName("gemtd_build_stone"):SetActivated(false)
		caster:FindAbilityByName("gemtd_remove"):SetActivated(false)

		SetAbilityActiveStatus(caster,false)

		--判断能不能合并成+1 +2级的
		for i=0,4 do
			local curr_name = GameRules:GetGameModeEntity().build_curr[player_id][i]:GetUnitName()
			local repeat_count = 0
			for j=0,4 do
				local curr_name2 = GameRules:GetGameModeEntity().build_curr[player_id][j]:GetUnitName()
				if curr_name == curr_name2 then
					repeat_count = repeat_count + 1
				end
			end


			local unit_name = GameRules:GetGameModeEntity().build_curr[player_id][i]:GetUnitName()
			local string_length = string.len(unit_name)
			local count_1  = 0
			for i=1,string_length do
				local index = string_length+1-i
				if string.sub(unit_name,index,index) == "1" then
					count_1 = count_1 + 1
				end
			end
			if count_1 >=2 then
				GameRules:GetGameModeEntity().build_curr[player_id][i]:AddAbility("gemtd_downgrade_stone")
				GameRules:GetGameModeEntity().build_curr[player_id][i]:FindAbilityByName("gemtd_downgrade_stone"):SetLevel(1)
				--风暴之锤
				if caster:FindAbilityByName("gemtd_hero_fengbaozhichui") ~= nil then
					local fengbaozhichui_level = caster:FindAbilityByName("gemtd_hero_fengbaozhichui"):GetLevel()
					GameRules:GetGameModeEntity().build_curr[player_id][i]:AddAbility("gemtd_downgrade_stone_fengbaozhichui")
					GameRules:GetGameModeEntity().build_curr[player_id][i]:FindAbilityByName("gemtd_downgrade_stone_fengbaozhichui"):SetLevel(fengbaozhichui_level)
				end
			end

			GameRules:GetGameModeEntity().build_curr[player_id][i]:AddAbility("gemtd_choose_stone")
			GameRules:GetGameModeEntity().build_curr[player_id][i]:FindAbilityByName("gemtd_choose_stone"):SetLevel(1)

			if repeat_count>=4 then
				GameRules:GetGameModeEntity().build_curr[player_id][i]:AddAbility("gemtd_choose_update_stone")
				GameRules:GetGameModeEntity().build_curr[player_id][i]:FindAbilityByName("gemtd_choose_update_stone"):SetLevel(1)
				GameRules:GetGameModeEntity().build_curr[player_id][i]:AddAbility("gemtd_choose_update_update_stone")
				GameRules:GetGameModeEntity().build_curr[player_id][i]:FindAbilityByName("gemtd_choose_update_update_stone"):SetLevel(1)

				if caster.effect ~= nil and caster.effect ~= "" then
					GameRules:GetGameModeEntity().build_curr[player_id][i]:AddAbility(caster.effect)
					GameRules:GetGameModeEntity().build_curr[player_id][i]:FindAbilityByName(caster.effect):SetLevel(1)	
					GameRules:GetGameModeEntity().build_curr[player_id][i].effect = caster.effect
				end

			elseif repeat_count>=2 then
				GameRules:GetGameModeEntity().build_curr[player_id][i]:AddAbility("gemtd_choose_update_stone")
				GameRules:GetGameModeEntity().build_curr[player_id][i]:FindAbilityByName("gemtd_choose_update_stone"):SetLevel(1)

			end
		end

		--检查能否一回合合成高级塔
		for h,h_merge in pairs(GameRules:GetGameModeEntity().gemtd_merge) do
			local can_merge = true
			local merge_pool = {}

			for k,k_unitname in pairs(h_merge) do
				local have_merge = false
				for c,c_unit in pairs(GameRules:GetGameModeEntity().build_curr[player_id]) do
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
				GameRules:GetGameModeEntity().gemtd_pool_can_merge_1[h] = {}

				for a,a_unit in pairs(merge_pool) do
					a_unit:AddAbility(h.."1")
					a_unit:FindAbilityByName(h.."1"):SetLevel(1)
					--GameRules:SendCustomMessage("可以合成"..h, 0, 0)

					if caster.effect ~= nil and caster.effect ~= "" then
						a_unit:AddAbility(caster.effect)
						a_unit:FindAbilityByName(caster.effect):SetLevel(1)	
						a_unit.effect = caster.effect
					end

					table.insert (GameRules:GetGameModeEntity().gemtd_pool_can_merge_1[player_id], a_unit) 
				end
			end
		end

		--检查能否一回合合成隐藏塔
		for h,h_merge in pairs(GameRules:GetGameModeEntity().gemtd_merge_secret) do
			local can_merge = true
			local merge_pool = {}

			for k,k_unitname in pairs(h_merge) do
				local have_merge = false
				for c,c_unit in pairs(GameRules:GetGameModeEntity().build_curr[player_id]) do
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
				GameRules:GetGameModeEntity().gemtd_pool_can_merge_1[h] = {}

				for a,a_unit in pairs(merge_pool) do
					a_unit:AddAbility(h.."1")
					a_unit:FindAbilityByName(h.."1"):SetLevel(1)
					--GameRules:SendCustomMessage("可以合成"..h, 0, 0)

					if caster.effect ~= nil and caster.effect ~= "" then
						a_unit:AddAbility(caster.effect)
						a_unit:FindAbilityByName(caster.effect):SetLevel(1)	
						a_unit.effect = caster.effect
					end

					table.insert (GameRules:GetGameModeEntity().gemtd_pool_can_merge_1[player_id], a_unit) 
				end
			end
		end

		--检查能否一回合合成石板
		for h,h_merge in pairs(GameRules:GetGameModeEntity().gemtd_merge_shiban) do
			local can_merge = true
			local merge_pool = {}

			for k,k_unitname in pairs(h_merge) do
				local have_merge = false
				for c,c_unit in pairs(GameRules:GetGameModeEntity().build_curr[player_id]) do
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
				GameRules:GetGameModeEntity().gemtd_pool_can_merge_shiban[h] = {}

				for a,a_unit in pairs(merge_pool) do
					a_unit:AddAbility(h.."_sb")
					a_unit:FindAbilityByName(h.."_sb"):SetLevel(1)
					--GameRules:SendCustomMessage("可以合成"..h, 0, 0)

					if caster.effect ~= nil and caster.effect ~= "" then
						a_unit:AddAbility(caster.effect)
						a_unit:FindAbilityByName(caster.effect):SetLevel(1)	
						a_unit.effect = caster.effect
					end

					table.insert (GameRules:GetGameModeEntity().gemtd_pool_can_merge_shiban[player_id], a_unit) 
				end
			end
		end
	end
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

	if GetMapName() ~= "gemtd_race" then
		--path1和path7附近 不能造
		if xxx>=29 and yyy<=9 then
			EmitGlobalSound("ui.crafting_gem_drop")
			return
		end

		if xxx<=9 and yyy>=29 then
			EmitGlobalSound("ui.crafting_gem_drop")
			return
		end
	end
	if GetMapName() == "gemtd_race" and check_area(player_id,p) == false then
		EmitGlobalSound("ui.crafting_gem_drop")
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
		-- GameRules:SendCustomMessage('附近有怪不能造',0,0)
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
		return
	end
	--路径点，不能造
	if GetMapName() ~= "gemtd_race" then
		for i=1,7 do
			local p1 = Entities:FindByName(nil,"path"..i):GetAbsOrigin()
			local xxx1 = math.floor((p1.x+64)/128)+19
			local yyy1 = math.floor((p1.y+64)/128)+19
			if xxx==xxx1 and yyy==yyy1 then
				EmitGlobalSound("ui.crafting_gem_drop")
				return
			end
		end
	end
	if GetMapName() == "gemtd_race" then
		for j=0,3 do
			for i=1,7 do
				local p1 = Entities:FindByName(nil,"path"..((10*j)+i)):GetAbsOrigin()
				local xxx1 = math.floor((p1.x+64)/128)+19
				local yyy1 = math.floor((p1.y+64)/128)+19
				if xxx==xxx1 and yyy==yyy1 then
					EmitGlobalSound("ui.crafting_gem_drop")
					return
				end
			end
		end
	end
	--地图范围外，不能造
	if xxx<1 or xxx>37 or yyy<1 or yyy>37 then
		EmitGlobalSound("ui.crafting_gem_drop")
		return
	end
	--建造石板
	local u = CreateUnitByName(shiban_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
	u.ftd = 2009

	--发弹幕
	CustomNetTables:SetTableValue( "game_state", "bullet", {player_id = player_id, text = shiban_name, hehe = RandomInt(1,100000)})

	GameRules:GetGameModeEntity().shiban_index[xxx..'_'..yyy] = u
	u:SetOwner(owner)
	u:SetControllableByPlayer(player_id, true)

	u:AddAbility("no_hp_bar")
	u:FindAbilityByName("no_hp_bar"):SetLevel(1)
	u:RemoveModifierByName("modifier_invulnerable")
	u:SetHullRadius(1)
	table.insert(GameRules:GetGameModeEntity().gemtd_pool, u)
	table.insert(GameRules:GetGameModeEntity().gemtd_pool_race[player_id], u)

	u:SetForwardVector(Vector(1,0,0))
	u.is_merged = true
	u.kill_count = 0

	play_merge_particle(u)
	EmitGlobalSound("Loot_Drop_Stinger_Rare")
	start_shiban_timer(u,shiban_ability,shiban_cd)

	for i=0,4 do
		local p = GameRules:GetGameModeEntity().build_curr[player_id][i]:GetAbsOrigin()
		--删除玩家颜色底盘
		if GameRules:GetGameModeEntity().build_curr[player_id][i].ppp then
			ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().build_curr[player_id][i].ppp,true)
		end
		GameRules:GetGameModeEntity().build_curr[player_id][i]:Destroy()
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
		u:SetHullRadius(1)
	end
	GameRules:GetGameModeEntity().build_curr[player_id] = {}
	GameRules:GetGameModeEntity().is_build_ready[player_id] = true
	

	finish_build(player_id)
	--检测能否合成高级石板
	Timers:CreateTimer(1,function()
		merge_shiban_update(xxx,yyy)
	end)

	send_merge_board(player_id)

	
end
--竞速模式检查是否在自己的合法建造区域
function check_area(player_id,p)
	local xxx = math.floor((p.x+64)/128)+19
	local yyy = math.floor((p.y+64)/128)+19
	if player_id == 0 and (xxx > 17 or yyy < 20) then
		return false
	end
	if player_id == 1 and (xxx < 20 or yyy < 20) then
		return false
	end
	if player_id == 2 and (xxx > 17 or yyy > 17) then
		return false
	end
	if player_id == 3 and (xxx < 20 or yyy > 17) then
		return false
	end
	if Entities:FindByName(nil,"path1") ~= nil and (Entities:FindByName(nil,"path1"):GetAbsOrigin() - p):Length2D() < 128*1.5 then
		return false
	end
	if Entities:FindByName(nil,"path11") ~= nil and (Entities:FindByName(nil,"path11"):GetAbsOrigin() - p):Length2D() < 128*1.5 then
		return false
	end
	if Entities:FindByName(nil,"path21") ~= nil and (Entities:FindByName(nil,"path21"):GetAbsOrigin() - p):Length2D() < 128*1.5 then
		return false
	end
	if Entities:FindByName(nil,"path31") ~= nil and  (Entities:FindByName(nil,"path31"):GetAbsOrigin() - p):Length2D() < 128*1.5 then
		return false
	end
	if Entities:FindByName(nil,"path7") ~= nil and (Entities:FindByName(nil,"path7"):GetAbsOrigin() - p):Length2D() < 128*1.5 then
		return false
	end
	if Entities:FindByName(nil,"path17") ~= nil and (Entities:FindByName(nil,"path17"):GetAbsOrigin() - p):Length2D() < 128*1.5 then
		return false
	end
	if Entities:FindByName(nil,"path27") ~= nil and (Entities:FindByName(nil,"path27"):GetAbsOrigin() - p):Length2D() < 128*1.5 then
		return false
	end
	if Entities:FindByName(nil,"path37") ~= nil and (Entities:FindByName(nil,"path37"):GetAbsOrigin() - p):Length2D() < 128*1.5 then
		return false
	end
	return true
end
--移除石头
function gemtd_remove(keys)
	local caster = keys.caster
	local target = keys.target
	local owner =  caster:GetOwner()

	if target:GetUnitName() ~= "gemtd_stone" then
		return
	end
	if check_area(caster:GetPlayerID(),target:GetAbsOrigin()) == false and GetMapName() == "gemtd_race" then
		EmitGlobalSound("ui.crafting_gem_drop")
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
--游戏循环3——选择留下石头5种情况
function choose_stone(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()

	caster:RemoveAbility("gemtd_choose_stone")
	caster:RemoveAbility("gemtd_choose_update_stone")
	caster:RemoveAbility("gemtd_choose_update_update_stone")

	for i=0,4 do
		if GameRules:GetGameModeEntity().build_curr[player_id][i]~=caster then
			--移除其他的石头
			local p = GameRules:GetGameModeEntity().build_curr[player_id][i]:GetAbsOrigin()
			--删除玩家颜色底盘
			if GameRules:GetGameModeEntity().build_curr[player_id][i].ppp then
				ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().build_curr[player_id][i].ppp,true)
			end
			GameRules:GetGameModeEntity().build_curr[player_id][i]:Destroy()
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
			u:SetHullRadius(1)
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
	u:SetHullRadius(1)

	table.insert (GameRules:GetGameModeEntity().gemtd_pool, u)
	table.insert (GameRules:GetGameModeEntity().gemtd_pool_race[player_id], u)

	GameRules:GetGameModeEntity().build_curr[player_id] = {}
	GameRules:GetGameModeEntity().is_build_ready[player_id] = true

	finish_build(player_id)

	send_merge_board(player_id)

	
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
		if GameRules:GetGameModeEntity().build_curr[player_id][i]~=caster then
			--移除其他的石头
			local p = GameRules:GetGameModeEntity().build_curr[player_id][i]:GetAbsOrigin()
			--删除玩家颜色底盘
			if GameRules:GetGameModeEntity().build_curr[player_id][i].ppp then
				ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().build_curr[player_id][i].ppp,true)
			end
			GameRules:GetGameModeEntity().build_curr[player_id][i]:Destroy()
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
			u:SetHullRadius(1)
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

	u:SetHullRadius(1)

	table.insert (GameRules:GetGameModeEntity().gemtd_pool, u)
	table.insert (GameRules:GetGameModeEntity().gemtd_pool_race[player_id], u)

	--AMHC:CreateNumberEffect(u,1,2,AMHC.MSG_DAMAGE,"yellow",0)


	GameRules:GetGameModeEntity().build_curr[player_id] = {}
	GameRules:GetGameModeEntity().is_build_ready[player_id] = true

	send_merge_board(player_id)

	finish_build(player_id)
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
		if GameRules:GetGameModeEntity().build_curr[player_id][i]~=caster then
			--移除其他的石头
			local p = GameRules:GetGameModeEntity().build_curr[player_id][i]:GetAbsOrigin()
			--删除玩家颜色底盘
			if GameRules:GetGameModeEntity().build_curr[player_id][i].ppp then
				ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().build_curr[player_id][i].ppp,true)
			end
			GameRules:GetGameModeEntity().build_curr[player_id][i]:Destroy()
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
			u:SetHullRadius(1)
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

	--发弹幕
	CustomNetTables:SetTableValue( "game_state", "bullet", {player_id = player_id, text = unit_name, hehe = RandomInt(1,100000)})

	u:SetOwner(owner)
	u:SetControllableByPlayer(player_id, true)
	u:SetForwardVector(Vector(0,-1,0))

	u:AddAbility("no_hp_bar")
	u:FindAbilityByName("no_hp_bar"):SetLevel(1)
	play_merge_particle(u)
	
	--添加玩家颜色底盘
	local particle = ParticleManager:CreateParticle("particles/gem/team_0.vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
	u.ppp = particle
	
	u:RemoveModifierByName("modifier_invulnerable")
	u:SetHullRadius(1)

	table.insert (GameRules:GetGameModeEntity().gemtd_pool, u)
	table.insert (GameRules:GetGameModeEntity().gemtd_pool_race[player_id], u)

	--AMHC:CreateNumberEffect(u,1,2,AMHC.MSG_DAMAGE,"yellow",0)


	GameRules:GetGameModeEntity().build_curr[player_id] = {}
	GameRules:GetGameModeEntity().is_build_ready[player_id] = true

	send_merge_board(player_id)

	finish_build(player_id)
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
		if GameRules:GetGameModeEntity().build_curr[player_id][i]~=caster then
			--移除其他的石头
			local p = GameRules:GetGameModeEntity().build_curr[player_id][i]:GetAbsOrigin()
			--删除玩家颜色底盘
			if GameRules:GetGameModeEntity().build_curr[player_id][i].ppp then
				ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().build_curr[player_id][i].ppp,true)
			end
			GameRules:GetGameModeEntity().build_curr[player_id][i]:Destroy()
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
			u:SetHullRadius(1)
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
	sync_player_gold(caster)

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
	u:SetHullRadius(1)

	table.insert (GameRules:GetGameModeEntity().gemtd_pool, u)
	table.insert (GameRules:GetGameModeEntity().gemtd_pool_race[player_id], u)

	GameRules:GetGameModeEntity().build_curr[player_id] = {}
	GameRules:GetGameModeEntity().is_build_ready[player_id] = true

	send_merge_board(player_id)

	finish_build(player_id)
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
		if GameRules:GetGameModeEntity().build_curr[player_id][i]~=caster then
			--移除其他的石头
			local p = GameRules:GetGameModeEntity().build_curr[player_id][i]:GetAbsOrigin()
			--删除玩家颜色底盘
			if GameRules:GetGameModeEntity().build_curr[player_id][i].ppp then
				ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().build_curr[player_id][i].ppp,true)
			end
			GameRules:GetGameModeEntity().build_curr[player_id][i]:Destroy()
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
			u:SetHullRadius(1)
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
	sync_player_gold(caster)


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
	u:SetHullRadius(1)

	table.insert (GameRules:GetGameModeEntity().gemtd_pool, u)
	table.insert (GameRules:GetGameModeEntity().gemtd_pool_race[player_id], u)

	GameRules:GetGameModeEntity().build_curr[player_id] = {}
	GameRules:GetGameModeEntity().is_build_ready[player_id] = true

	send_merge_board(player_id)

	finish_build(player_id)
end
--游戏循环4——完成建造，调用开始刷怪
function finish_build(player_id)

	GameRules:GetGameModeEntity().build_ready_wave[player_id] = GameRules:GetGameModeEntity().build_ready_wave[player_id] + 1

	--合作模式: 所有玩家都建造就绪了，开始刷怪
	if GameRules:GetGameModeEntity().is_build_ready[0]==true and GameRules:GetGameModeEntity().is_build_ready[1]==true and GameRules:GetGameModeEntity().is_build_ready[2]==true and GameRules:GetGameModeEntity().is_build_ready[3]==true and GetMapName() ~= "gemtd_race" then
		GameRules:GetGameModeEntity().game_status = 2
		start_shuaguai()

		--在GameRules:GetGameModeEntity().gemtd_pool中检查能否合成高级塔
		for h,h_merge in pairs(GameRules:GetGameModeEntity().gemtd_merge) do
			local can_merge = true
			local merge_pool = {}

			for k,k_unitname in pairs(h_merge) do
				local have_merge = false
				for c,c_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool) do
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
				GameRules:GetGameModeEntity().gemtd_pool_can_merge[h] = {}

				for a,a_unit in pairs(merge_pool) do
					a_unit:RemoveAbility(h)
					a_unit:AddAbility(h)
					a_unit:FindAbilityByName(h):SetLevel(1)
					play_particle("effect/merge/ui/plus/ui_hero_level_4_icon_ambient.vpcf",PATTACH_OVERHEAD_FOLLOW,a_unit,10)

					table.insert (GameRules:GetGameModeEntity().gemtd_pool_can_merge[h], a_unit) 

					table.insert (GameRules:GetGameModeEntity().gemtd_pool_can_merge_all, h ) 
				end
			end
		end
	end

	--竞速模式: 最快的玩家本回合建造就绪了，开始刷怪
	if GetMapName() == "gemtd_race" then
		PlayerResource:GetPlayer(player_id):GetAssignedHero().perfected = false
		--在GameRules:GetGameModeEntity().gemtd_pool_race[player_id]中检查能否合成高级塔
		for h,h_merge in pairs(GameRules:GetGameModeEntity().gemtd_merge) do
			local can_merge = true
			local merge_pool = {}

			for k,k_unitname in pairs(h_merge) do
				local have_merge = false
				for c,c_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool_race[player_id]) do
					if c_unit:IsNull() == false and c_unit:GetUnitName()==k_unitname then
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
				GameRules:GetGameModeEntity().gemtd_pool_can_merge_race[player_id][h] = {}

				for a,a_unit in pairs(merge_pool) do
					a_unit:RemoveAbility(h)
					a_unit:AddAbility(h)
					a_unit:FindAbilityByName(h):SetLevel(1)
					play_particle("effect/merge/ui/plus/ui_hero_level_4_icon_ambient.vpcf",PATTACH_OVERHEAD_FOLLOW,a_unit,10)

					table.insert (GameRules:GetGameModeEntity().gemtd_pool_can_merge_race[player_id][h], a_unit) 

					table.insert (GameRules:GetGameModeEntity().gemtd_pool_can_merge_all_race[player_id], h ) 
				end
			end
		end

		-- log('player'..player_id..' build_ready_wave:'..GameRules:GetGameModeEntity().build_ready_wave[player_id]..',level:'..GameRules:GetGameModeEntity().level)

		if GameRules:GetGameModeEntity().build_ready_wave[player_id] == GameRules:GetGameModeEntity().level then
			--建完是当前关，出怪
			set_build_hummer(player_id, 0)

			if GameRules:GetGameModeEntity().enemy_spawned_wave < GameRules:GetGameModeEntity().level then
				GameRules:SendCustomMessage('敌人即将来袭，wave '..GameRules:GetGameModeEntity().level,0,0)

				GameRules:SetTimeOfDay(0.3)
				GameRules:GetGameModeEntity().stop_watch = GameRules:GetGameTime()

				EmitGlobalSound("GameStart.RadiantAncient")
				spawn_one_wave()
			end
		else
			--建完的不是当前关的，再给建造机会
			set_build_hummer(player_id, GameRules:GetGameModeEntity().level-GameRules:GetGameModeEntity().build_ready_wave[player_id])

			local h = PlayerResource:GetPlayer(player_id):GetAssignedHero()

			SetAbilityActiveStatus(h,true)
			GameRules:GetGameModeEntity().is_build_ready[player_id]=false
			h.build_level = GameRules:GetGameModeEntity().level

			h:FindAbilityByName("gemtd_build_stone"):SetActivated(true)
			h:FindAbilityByName("gemtd_remove"):SetActivated(true)
			h:SetMana(5.0)

		end
	end
end
function set_build_hummer(player_id, count)
	local h = PlayerResource:GetPlayer(player_id):GetAssignedHero()
	for i=0,5 do
		if h:GetItemInSlot(i) then
			h:GetItemInSlot(i):SetCurrentCharges(count)
		end
	end
end
--游戏循环5——开始刷怪
function start_shuaguai()
	if GameRules:GetGameModeEntity().level == 51 then
		CustomNetTables:SetTableValue( "game_state", "show_ggsimida", {hehe=RandomInt(1,10000)} )
	end

	CustomNetTables:SetTableValue( "game_state", "disable_all_repick", { hehe = RandomInt(1,10000) } );


	GameRules:SetTimeOfDay(0.3)
	GameRules:GetGameModeEntity().stop_watch = GameRules:GetGameTime()
	EmitGlobalSound("GameStart.RadiantAncient")

	--如果本关有备选怪，就随机
	if GameRules:GetGameModeEntity().guai[GameRules:GetGameModeEntity().level+100] ~= nil then
		if RandomInt(1,2) == 1 then
			GameRules:GetGameModeEntity().guai[GameRules:GetGameModeEntity().level] = GameRules:GetGameModeEntity().guai[GameRules:GetGameModeEntity().level+100]
		end
	end

	if (GameRules:GetGameModeEntity().level ==20 and RandomInt(1,100)>90 ) then
		GameRules:GetGameModeEntity().guai[GameRules:GetGameModeEntity().level] =  "gemtd_yuediyang_boss"
	end
	if (GameRules:GetGameModeEntity().level ==30 and RandomInt(1,100)>90 ) then
		GameRules:GetGameModeEntity().guai[GameRules:GetGameModeEntity().level] = "gemtd_zard_boss_fly"
	end
	if (GameRules:GetGameModeEntity().level ==40 and RandomInt(1,100)>90 ) then
		GameRules:GetGameModeEntity().guai[GameRules:GetGameModeEntity().level] =  "gemtd_gugubiao_boss_fly"
	end
	if (GameRules:GetGameModeEntity().level ==50 and RandomInt(1,100)>80 ) then
		GameRules:GetGameModeEntity().guai[GameRules:GetGameModeEntity().level] =  "gemtd_roushan_boss_fly_jin"
	end
	if (GameRules:GetGameModeEntity().level ==50 and RandomInt(1,100)>90 ) then
		GameRules:GetGameModeEntity().guai[GameRules:GetGameModeEntity().level] =  "gemtd_roushan_boss_fly_bojin"
	end

	if GameRules:GetGameModeEntity().level > 50 then
		GameRules:GetGameModeEntity().guai_level = GameRules:GetGameModeEntity().level - 50
	else
		GameRules:GetGameModeEntity().guai_level = GameRules:GetGameModeEntity().level
	end

	if GameRules:GetGameModeEntity().level > 100 then
		GameRules:GetGameModeEntity().game_status = 3
		send_ranking ()
		Timers:CreateTimer(20, function()
			GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		end)
	end

	ShowCenterMessage(GameRules:GetGameModeEntity().guai[GameRules:GetGameModeEntity().guai_level], 5,GameRules:GetGameModeEntity().level,GameRules:GetGameModeEntity().wave_enemy_count)

	CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = GameRules:GetGameModeEntity().level, enemy_show = GameRules:GetGameModeEntity().guai[GameRules:GetGameModeEntity().level] } );


	GameRules:GetGameModeEntity().gem_is_shuaguaiing=true
	GameRules:GetGameModeEntity().guai_live_count = 0
	GameRules:GetGameModeEntity().guai_count = GameRules:GetGameModeEntity().wave_enemy_count

	local guai_name  = GameRules:GetGameModeEntity().guai[GameRules:GetGameModeEntity().guai_level]
	find_all_path()
	if string.find(guai_name, "fly") then
		find_all_path_fly()
	end
	if string.find(guai_name, "boss") then
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
	GameRules:GetGameModeEntity().perfected = false
end
--游戏循环6——怪物死亡、加钱、判断过关
function GemTD:OnEntityKilled( keys )
	if keys ~= nil then
		local killed_unit = EntIndexToHScript(keys.entindex_killed)
		--不算击杀的死亡
		if killed_unit:GetUnitName() == "gemtd_feicuimoxiang_yinxing" or killed_unit:GetUnitName() == "gemtd_guangzhudaobiao" or killed_unit:GetUnitName() == "gemtd_pet" then
			return
		end
		if killed_unit:IsHero() == true then
			return
		end
		if GetMapName() == 'gemtd_1p' or GetMapName() == 'gemtd_coop' then
			if GameRules:GetGameModeEntity().is_debug == true then
				prt('entindex_killed'..keys.entindex_killed)
				prt('entindex_attacker'..keys.entindex_attacker)
			end
			if keys.entindex_killed ~= keys.entindex_attacker then
				--单人模式和合作模式
				if (string.find(killed_unit:GetUnitName(), "boss") or string.find(killed_unit:GetUnitName(), "tester") ) and GameRules:GetGameModeEntity().is_boss_entered == false then

					GameRules:GetGameModeEntity().kills = GameRules:GetGameModeEntity().kills + 10
					for k=1,10 do
						PlayerResource:IncrementKills(0,1)
						PlayerResource:IncrementKills(1,1)
						PlayerResource:IncrementKills(2,1)
						PlayerResource:IncrementKills(3,1)
					end

					if killed_unit:GetUnitName() == "gemtd_zard_boss_fly" or killed_unit:GetUnitName() == "gemtd_kongxinnanguaren_boss" or killed_unit:GetUnitName() == "gemtd_yuediyang_boss" or killed_unit:GetUnitName() == "gemtd_gugubiao_boss_fly" then
						GameRules:GetGameModeEntity().kills = GameRules:GetGameModeEntity().kills + 5
						for k=1,5 do
							PlayerResource:IncrementKills(0,1)
							PlayerResource:IncrementKills(1,1)
							PlayerResource:IncrementKills(2,1)
							PlayerResource:IncrementKills(3,1)
						end
					end

					if killed_unit:GetUnitName() == "gemtd_roushan_boss_fly_jin" or killed_unit:GetUnitName() == "gemtd_roushan_boss_fly_bojin" then
						GameRules:GetGameModeEntity().kills = GameRules:GetGameModeEntity().kills + 10
						for k=1,10 do
							PlayerResource:IncrementKills(0,1)
							PlayerResource:IncrementKills(1,1)
							PlayerResource:IncrementKills(2,1)
							PlayerResource:IncrementKills(3,1)
						end
					end

					log("kills: "..GameRules:GetGameModeEntity().kills)
					GameRules:SendCustomMessage("#text_you_killed_the_boss", 0, 0)
					GameRules:GetGameModeEntity().is_boss_entered = true

					if killed_unit:GetUnitName() == "gemtd_zard_boss_fly" then
						GameRules:GetGameModeEntity().quest_status["q104"] = true
						show_quest()
					end
					if killed_unit:GetUnitName() == "gemtd_roushan_boss_fly_jin" then
						GameRules:GetGameModeEntity().quest_status["q303"] = true
						show_quest()
					end
				end
				if killed_unit.is_jingying == true then
					GameRules:GetGameModeEntity().kills = GameRules:GetGameModeEntity().kills + 4
					for k=1,4 do
						PlayerResource:IncrementKills(0,1)
						PlayerResource:IncrementKills(1,1)
						PlayerResource:IncrementKills(2,1)
						PlayerResource:IncrementKills(3,1)
					end
					if GameRules:GetGameModeEntity().is_debug == true then
						GameRules:SendCustomMessage("kills: "..GameRules:GetGameModeEntity().kills, 0, 0)
					end
				end
				if (not (string.find(killed_unit:GetUnitName(), "boss")) and (not killed_unit.is_jingying == true)) then
					GameRules:GetGameModeEntity().kills = GameRules:GetGameModeEntity().kills + 1
					for k=1,1 do
						PlayerResource:IncrementKills(0,1)
						PlayerResource:IncrementKills(1,1)
						PlayerResource:IncrementKills(2,1)
						PlayerResource:IncrementKills(3,1)
					end
					if GameRules:GetGameModeEntity().is_debug == true then
						GameRules:SendCustomMessage("kills: "..GameRules:GetGameModeEntity().kills, 0, 0)
					end
				end
				if keys.entindex_attacker ~= nil then
					local killer_unit = EntIndexToHScript(keys.entindex_attacker)
					local killer_owner = killer_unit:GetOwner()
				end
				if killed_unit~= nil and not killed_unit.is_entered == true then
					--给玩家经验
					local exp_count = 5
					if GameRules:GetGameModeEntity().level ==10 then
						exp_count = 300
					end
					if GameRules:GetGameModeEntity().level ==20 then
						exp_count = 300
					end
					if GameRules:GetGameModeEntity().level ==30 then
						exp_count = 300
					end
					if GameRules:GetGameModeEntity().level ==40 then
						exp_count = 300
					end
					if GameRules:GetGameModeEntity().level ==50 then
						exp_count = 300
					end
					if GameRules:GetGameModeEntity().level >=11 and GameRules:GetGameModeEntity().level <=19 then
						exp_count = 10
					end
					if GameRules:GetGameModeEntity().level >=21 and GameRules:GetGameModeEntity().level <=29 then
						exp_count = 15
					end
					if GameRules:GetGameModeEntity().level >=31 and GameRules:GetGameModeEntity().level <=39 then
						exp_count = 20
					end
					if GameRules:GetGameModeEntity().level >=41 and GameRules:GetGameModeEntity().level <=49 then
						exp_count = 25
					end
					local exp_percent = 1

					exp_count = exp_count * exp_percent
					if (killed_unit~= nil and killed_unit.is_jingying == true) then
						exp_count = exp_count * 10
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
						if killer_unit ~= nil then
							PlayerResource:SetGold(0, PlayerResource:GetGold(0)+exp_count, true)
							--同步玩家金钱
							sync_player_gold()
						end
					end
					AMHC:CreateNumberEffect(killed_unit,exp_count,5,AMHC.MSG_GOLD,"yellow",0)
					GameRules:GetGameModeEntity().team_gold = GameRules:GetGameModeEntity().team_gold + exp_count

					if exp_count >= 100 then
						EmitGlobalSound("General.CoinsBig")
					else
						EmitGlobalSound("General.Coins")
					end
				end
			end
			GameRules:GetGameModeEntity().guai_live_count = GameRules:GetGameModeEntity().guai_live_count - 1
			--判断是不是怪死光了
			if GameRules:GetGameModeEntity().game_status == 2 then
				--过关了
				if GameRules:GetGameModeEntity().guai_live_count<=0 and GameRules:GetGameModeEntity().gem_is_shuaguaiing == false then
					GameRules:GetGameModeEntity().game_status = 1

					Timers:CreateTimer(1, function()
						--统计过关时间，计算怪数量的增加
						local time_this_level = math.floor(GameRules:GetGameTime() - GameRules:GetGameModeEntity().stop_watch)
						if time_this_level < GameRules:GetGameModeEntity().win_streak_time and GameRules:GetGameModeEntity().perfect_this_level then
							GameRules:GetGameModeEntity().win_streak = GameRules:GetGameModeEntity().win_streak + 1
							if GameRules:GetGameModeEntity().win_streak >= 3 then
								GameRules:SendCustomMessage('#text_win_streak_3',0,0)
								EmitGlobalSound("ui.courier_in_use")
								
								GameRules:GetGameModeEntity().win_streak = 0
								GameRules:GetGameModeEntity().wave_enemy_count = GameRules:GetGameModeEntity().wave_enemy_count + 1

							end
						else
							GameRules:GetGameModeEntity().win_streak = 0
						end
						if GameRules:GetGameModeEntity().level <= 50 then
							--统计本关mvp
							local mvp_tower_id = 0
							local mvp_tower_damage = 0
							for mvp_i,mvp_v in pairs(GameRules:GetGameModeEntity().damage) do
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

									CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = GameRules:GetGameModeEntity().level, enemy_show = mvp_tower:GetUnitName() } )

									level_up(mvp_tower,1)
									-- Timers:CreateTimer(2,function()
									-- 	createHintBubble(mvp_tower,"#text_i_level_up")
									-- end)
									
								end
							end
						end
						CustomNetTables:SetTableValue( "game_state", "damage_stat", { level = GameRules:GetGameModeEntity().level, damage_table = GameRules:GetGameModeEntity().damage , time_this_level = time_this_level, hehe = RandomInt(1,100000) } )
						
						GameRules:GetGameModeEntity().damage = {}
						GameRules:GetGameModeEntity().perfect_this_level = true
						
						if GameRules:GetGameModeEntity().level == 50 then
							GameRules:SendCustomMessage("#text_enemy_is_stonger2", 0, 0)
							ShowCenterMessage("youwin", 5)
							EmitGlobalSound("crowd.lv_03")

							Timers:CreateTimer(5, function()
								GameRules:SendCustomMessage("#text_enemy_is_stonger3", 0, 0)
								EmitGlobalSound("diretide_eventstart_Stinger")

								Timers:CreateTimer(5, function()
									GameRules:GetGameModeEntity().level = GameRules:GetGameModeEntity().level +1
									PlayerResource:IncrementAssists(0 , 1)
									PlayerResource:IncrementAssists(1 , 1)
									PlayerResource:IncrementAssists(2 , 1)
									PlayerResource:IncrementAssists(3 , 1)
									GameRules:GetGameModeEntity().guai_count = 10
									GameRules:GetGameModeEntity().game_status = 1
									start_build()
									return nil
								end)
							end)
						else
							if GameRules:GetGameModeEntity().level%10 == 0 then
								GameRules:SendCustomMessage("#text_enemy_is_stonger", 0, 0)
							end
							Timers:CreateTimer(0.1, function()
								GameRules:GetGameModeEntity().level = GameRules:GetGameModeEntity().level +1
								PlayerResource:IncrementAssists(0 , 1)
								PlayerResource:IncrementAssists(1 , 1)
								PlayerResource:IncrementAssists(2 , 1)
								PlayerResource:IncrementAssists(3 , 1)
								GameRules:GetGameModeEntity().guai_count = 10
								GameRules:GetGameModeEntity().game_status = 1
								start_build()
								return nil
							end)
						end
					end)
				end
			end
		elseif GetMapName() == 'gemtd_race' then
			--竞速模式
			local player_id = killed_unit.player

			if keys.entindex_killed ~= keys.entindex_attacker then
				--先算好应该给多少击杀数、钱、经验
				local kills_add = 1
				local money_add = 5

				if GameRules:GetGameModeEntity().level >=11 and GameRules:GetGameModeEntity().level <=19 then
					money_add = 10
				end
				if GameRules:GetGameModeEntity().level >=21 and GameRules:GetGameModeEntity().level <=29 then
					money_add = 15
				end
				if GameRules:GetGameModeEntity().level >=31 and GameRules:GetGameModeEntity().level <=39 then
					money_add = 20
				end
				if GameRules:GetGameModeEntity().level >=41 and GameRules:GetGameModeEntity().level <=49 then
					money_add = 25
				end
				if string.find(killed_unit:GetUnitName(), "boss") then
					money_add = 300
					kills_add = 10
					if killed_unit:GetUnitName() == "gemtd_zard_boss_fly" or killed_unit:GetUnitName() == "gemtd_kongxinnanguaren_boss" or killed_unit:GetUnitName() == "gemtd_yuediyang_boss" or killed_unit:GetUnitName() == "gemtd_gugubiao_boss_fly" then
						kills_add = 15
					end
					if killed_unit:GetUnitName() == "gemtd_roushan_boss_fly_jin" or killed_unit:GetUnitName() == "gemtd_roushan_boss_fly_bojin" then
						kills_add = 20
					end
				end
				if killed_unit.is_jingying == true then
					kills_add = 4
					money_add = money_add * 10
				end
				--增加击杀数
				for k=1,kills_add do
					PlayerResource:IncrementKills(player_id,1)
				end
				--增加经验
				if PlayerResource:GetPlayer(player_id) ~= nil then
					PlayerResource:GetPlayer(player_id):GetAssignedHero():AddExperience(money_add,0,false,false)

					--增加金钱
					if money_add >= 100 then
						money_add = money_add/2
					end
					if keys.entindex_attacker ~= nil then
						local killer_unit = EntIndexToHScript(keys.entindex_attacker)
						local killer_owner = killer_unit:GetOwner()

						if killer_unit ~= nil and killer_unit:FindModifierByName("modifier_tower_tanlan") ~= nil and RandomInt(1,100)<=5 then
							money_add = money_add * 10
						end
					end
					AMHC:CreateNumberEffect(killed_unit,money_add,5,AMHC.MSG_GOLD,"yellow",0)
					if money_add >= 100 then
						EmitSoundOn("General.CoinsBig",killed_unit)
					else
						EmitSoundOn("General.Coins",killed_unit)
					end
					PlayerResource:SetGold(player_id, PlayerResource:GetGold(player_id)+money_add, true)

					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id),"show_money",{
						money = PlayerResource:GetGold(player_id),
					})
				end
			end
			
			--存活怪数-1
			GameRules:GetGameModeEntity().enemy_live_count[player_id] = GameRules:GetGameModeEntity().enemy_live_count[player_id] - 1

			--有玩家杀完了
			if GameRules:GetGameModeEntity().enemy_live_count[player_id] <= 0 then
				--过关啦！！！
				if GameRules:GetGameModeEntity().enemy_spawned_wave == GameRules:GetGameModeEntity().level then
					--只有第一个过关的玩家会触发
					if (killed_unit ~= nil and string.find(killed_unit:GetUnitName(), "boss"))then
						GameRules:SendCustomMessage("#text_enemy_is_stonger", 0, 0)
					end

					GameRules:GetGameModeEntity().top_runner = player_id
					CustomNetTables:SetTableValue( "game_state", "gem_top_runner", { player = player_id, hehe = RandomInt(1,10000) } ); 
					
					--统计本关mvp
					if GameRules:GetGameModeEntity().level <= 50 then
						stat_mvp_race()
					end
					GameRules:GetGameModeEntity().level = GameRules:GetGameModeEntity().level +1

					for p=0,PlayerResource:GetPlayerCount()-1 do
						if GameRules:GetGameModeEntity().gem_castle_hp_race[p] > 0 then
							PlayerResource:IncrementAssists(p , 1)
						end
					end
					--检查是否还有活着的玩家！没有就不开始建造了...
					local is_all_dead = true
					for i=1,PlayerResource:GetPlayerCount() do
						if GameRules:GetGameModeEntity().gem_castle_hp_race[i-1]>0 then
							is_all_dead = false
						end
					end
					if is_all_dead == false then
						--开始建造！！！	
						start_build()
					end
				end
			end
			dropItem( killed_unit:GetAbsOrigin() )
		end
	end
end

--掉宝
function dropItem( p )
	--掉率
	if RandomInt(1,100) > GameRules:GetGameModeEntity().DROP_PER then 
		return
	end		
	--找到一个空位置
	local pp = find_empty_grid(p)
	if pp == nil then
		return
	end
		
	local ITEM_LIST = {
		[1] = "item_jingying",
		[2] = "item_huichun",
		[3] = "item_fog",
		[4] = "item_fly",
		[5] = "item_aojiao",
	}
	local ITEM_SCALE = {
		item_jingying = 1.3,
		item_fly = 1.3,
		item_aojiao = 1.4,
	}
	local item = ITEM_LIST[RandomInt(1,table.maxn(ITEM_LIST))]
	local newItem = CreateItem( item, nil, nil )
	local drop = CreateItemOnPositionForLaunch( p, newItem )
	
	newItem:LaunchLootInitialHeight( false, 0, RandomInt(200,700), 1, pp )
	newItem:GetContainer():SetModelScale(ITEM_SCALE[item] or 1.5)
	Timers:CreateTimer(300,function()
		if newItem ~= nil and newItem:IsNull() == false then
			newItem:GetContainer():Destroy()
		end
	end)
end
function find_empty_grid(p)
	local pp = p + RandomVector( 400 )
	local is_empty = false
	local times = 0
	local xxx = math.floor((pp.x+64)/128)+19
	local yyy = math.floor((pp.y+64)/128)+19
	while is_empty == false and times < 50 do
		if GameRules:GetGameModeEntity().gem_map[yyy][xxx] == 0 and is_path_grid(xxx,yyy) == false then
			is_empty = true
		else
			pp = p + RandomVector( 400 )
			xxx = math.floor((pp.x+64)/128)+19
			yyy = math.floor((pp.y+64)/128)+19
			times = times + 1
		end
	end
	if is_empty == false then
		return nil
	end
	pp.x = math.floor((pp.x+64)/128)*128
	pp.y = math.floor((pp.y+64)/128)*128
	return pp
end
function is_path_grid(xxx,yyy)
	for j=0,3 do
		for i=1,7 do
			local p1 = Entities:FindByName(nil,"path"..((10*j)+i)):GetAbsOrigin()
			local xxx1 = math.floor((p1.x+64)/128)+19
			local yyy1 = math.floor((p1.y+64)/128)+19
			if xxx==xxx1 and yyy==yyy1 then
				return true
			end
		end
	end
	return false
end
function stat_mvp_race()
	--统计本关mvp
	for i=0,PlayerResource:GetPlayerCount()-1 do
		local mvp_tower_id = 0
		local mvp_tower_damage = 0
		if GameRules:GetGameModeEntity().damage_race[i] ~= nil then
			for mvp_i,mvp_v in pairs(GameRules:GetGameModeEntity().damage_race[i]) do
				local u = EntIndexToHScript(mvp_i)
				if u ~= nil and not u:IsNull() and u:GetTeam()~=3 then
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
				GameRules:GetGameModeEntity().last_mvp[i] = mvp_tower_id
				local mvp_tower = EntIndexToHScript(mvp_tower_id)
				if mvp_tower ~= nil and not mvp_tower:IsNull() then

					play_particle("particles/events/ti6_teams/teleport_start_ti6_lvl3_mvp_phoenix.vpcf",PATTACH_ABSORIGIN_FOLLOW,mvp_tower,5)

					EmitSoundOn("crowd.lv_01",mvp_tower)

					CustomNetTables:SetTableValue( "game_state", "victory_condition_race", { kills_to_win = GameRules:GetGameModeEntity().level, enemy_show = mvp_tower:GetUnitName(), player = i } )

					level_up(mvp_tower,1)
				end
			end
			GameRules:GetGameModeEntity().damage_race[i] = {}
		end
	end
end

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
end

--寻路算法
--寻找所有路径
function find_all_path()
	if GetMapName()== 'gemtd_race' then
		return
	end
	GameRules:GetGameModeEntity().gem_maze_length = 0

	if GameRules:GetGameModeEntity().guangzhudaobiao == nil then
		GameRules:GetGameModeEntity().gem_path = {
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

		CustomNetTables:SetTableValue( "game_state", "gem_maze_length", { length = math.modf(GameRules:GetGameModeEntity().gem_maze_length),hehe=RandomInt(1,10000) } );

		GameRules:GetGameModeEntity().gem_path_all = {}
		for i = 1,6 do
			for j = 1,table.maxn(GameRules:GetGameModeEntity().gem_path[i])-1 do
				table.insert (GameRules:GetGameModeEntity().gem_path_all, GameRules:GetGameModeEntity().gem_path[i][j])
			end
		end
		table.insert (GameRules:GetGameModeEntity().gem_path_all, p7)
	else
		GameRules:GetGameModeEntity().gem_path = {
			{},{},{},{},{},{},{}
		}
		local p1 = Entities:FindByName(nil,"path1"):GetAbsOrigin()
		local p0 = GameRules:GetGameModeEntity().guangzhudaobiao:GetAbsOrigin()
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

		CustomNetTables:SetTableValue( "game_state", "gem_maze_length", { length = math.modf(GameRules:GetGameModeEntity().gem_maze_length),hehe=RandomInt(1,10000) } );

		GameRules:GetGameModeEntity().gem_path_all = {}
		for i = 1,7 do
			for j = 1,table.maxn(GameRules:GetGameModeEntity().gem_path[i])-1 do
				table.insert (GameRules:GetGameModeEntity().gem_path_all, GameRules:GetGameModeEntity().gem_path[i][j])
			end
		end
		table.insert (GameRules:GetGameModeEntity().gem_path_all, p7)
	end
end
function find_all_path_race(player_id)
	GameRules:GetGameModeEntity().gem_maze_length_race[player_id] = 0
	if GameRules:GetGameModeEntity().guangzhudaobiao_race[player_id] ~= nil then
		GameRules:GetGameModeEntity().gem_path_race[player_id] = {
			{},{},{},{},{},{},{},{}
		}
		local p1 = Entities:FindByName(nil,"path"..(player_id*10+1)..""):GetAbsOrigin()
		local p0 = GameRules:GetGameModeEntity().guangzhudaobiao_race[player_id]:GetAbsOrigin()
		find_path_race(p1,p0,1,player_id)
		local p2 = Entities:FindByName(nil,"path"..(player_id*10+2)..""):GetAbsOrigin()
		find_path_race(p0,p2,2,player_id)
		local p3 = Entities:FindByName(nil,"path"..(player_id*10+3)..""):GetAbsOrigin()
		find_path_race(p2,p3,3,player_id)
		local p4 = Entities:FindByName(nil,"path"..(player_id*10+4)..""):GetAbsOrigin()
		find_path_race(p3,p4,4,player_id)
		local p5 = Entities:FindByName(nil,"path"..(player_id*10+5)..""):GetAbsOrigin()
		find_path_race(p4,p5,5,player_id)
		local p6 = Entities:FindByName(nil,"path"..(player_id*10+6)..""):GetAbsOrigin()
		find_path_race(p5,p6,6,player_id)
		local p7 = Entities:FindByName(nil,"path"..(player_id*10+7)..""):GetAbsOrigin()
		find_path_race(p6,p7,7,player_id)

		CustomNetTables:SetTableValue( "game_state", "gem_maze_length_race", { player = player_id, length = math.modf(GameRules:GetGameModeEntity().gem_maze_length_race[player_id]),hehe=RandomInt(1,10000) } );

		GameRules:GetGameModeEntity().race_stat[player_id]['maze_length'] = math.modf(GameRules:GetGameModeEntity().gem_maze_length_race[player_id])

		GameRules:GetGameModeEntity().gem_path_all_race[player_id] = {}
		for i = 1,7 do
			for j = 1,table.maxn(GameRules:GetGameModeEntity().gem_path_race[player_id][i])-1 do
				table.insert (GameRules:GetGameModeEntity().gem_path_all_race[player_id], GameRules:GetGameModeEntity().gem_path_race[player_id][i][j])
			end
		end
		table.insert (GameRules:GetGameModeEntity().gem_path_all_race[player_id], p7)
		
	else
		GameRules:GetGameModeEntity().gem_path_race[player_id] = {
			{},{},{},{},{},{},{}
		}
		local p1 = Entities:FindByName(nil,"path"..(player_id*10+1)..""):GetAbsOrigin()
		local p2 = Entities:FindByName(nil,"path"..(player_id*10+2)..""):GetAbsOrigin()
		find_path_race(p1,p2,1,player_id)
		local p3 = Entities:FindByName(nil,"path"..(player_id*10+3)..""):GetAbsOrigin()
		find_path_race(p2,p3,2,player_id)
		local p4 = Entities:FindByName(nil,"path"..(player_id*10+4)..""):GetAbsOrigin()
		find_path_race(p3,p4,3,player_id)
		local p5 = Entities:FindByName(nil,"path"..(player_id*10+5)..""):GetAbsOrigin()
		find_path_race(p4,p5,4,player_id)
		local p6 = Entities:FindByName(nil,"path"..(player_id*10+6)..""):GetAbsOrigin()
		find_path_race(p5,p6,5,player_id)
		local p7 = Entities:FindByName(nil,"path"..(player_id*10+7)..""):GetAbsOrigin()
		find_path_race(p6,p7,6,player_id)

		CustomNetTables:SetTableValue( "game_state", "gem_maze_length_race", { player = player_id, length = math.modf(GameRules:GetGameModeEntity().gem_maze_length_race[player_id]),hehe=RandomInt(1,10000) } );

		GameRules:GetGameModeEntity().race_stat[player_id]['maze_length'] = math.modf(GameRules:GetGameModeEntity().gem_maze_length_race[player_id])

		GameRules:GetGameModeEntity().gem_path_all_race[player_id] = {}
		for i = 1,6 do
			for j = 1,table.maxn(GameRules:GetGameModeEntity().gem_path_race[player_id][i])-1 do
				table.insert (GameRules:GetGameModeEntity().gem_path_all_race[player_id], GameRules:GetGameModeEntity().gem_path_race[player_id][i][j])
			end
		end
		table.insert (GameRules:GetGameModeEntity().gem_path_all_race[player_id], p7)
	end
end
--寻找所有路径
function find_all_path_fly()
	if GameRules:GetGameModeEntity().guangzhudaobiao == nil then
		local p1 = Entities:FindByName(nil,"path1"):GetAbsOrigin()
		local p2 = Entities:FindByName(nil,"path2"):GetAbsOrigin()
		local p3 = Entities:FindByName(nil,"path3"):GetAbsOrigin()
		local p4 = Entities:FindByName(nil,"path4"):GetAbsOrigin()
		local p5 = Entities:FindByName(nil,"path5"):GetAbsOrigin()
		local p6 = Entities:FindByName(nil,"path6"):GetAbsOrigin()
		local p7 = Entities:FindByName(nil,"path7"):GetAbsOrigin()

		GameRules:GetGameModeEntity().gem_path = {
			{p1,p2},{p2,p3},{p3,p4},{p4,p5},{p5,p6},{p6,p7}
		}

		GameRules:GetGameModeEntity().gem_path_all = {}
		for i = 1,6 do
			for j = 1,table.maxn(GameRules:GetGameModeEntity().gem_path[i])-1 do
				table.insert (GameRules:GetGameModeEntity().gem_path_all, GameRules:GetGameModeEntity().gem_path[i][j])
			end
		end
		table.insert (GameRules:GetGameModeEntity().gem_path_all, p7)
	else
		local p0 = GameRules:GetGameModeEntity().guangzhudaobiao:GetAbsOrigin()
		local p1 = Entities:FindByName(nil,"path1"):GetAbsOrigin()
		local p2 = Entities:FindByName(nil,"path2"):GetAbsOrigin()
		local p3 = Entities:FindByName(nil,"path3"):GetAbsOrigin()
		local p4 = Entities:FindByName(nil,"path4"):GetAbsOrigin()
		local p5 = Entities:FindByName(nil,"path5"):GetAbsOrigin()
		local p6 = Entities:FindByName(nil,"path6"):GetAbsOrigin()
		local p7 = Entities:FindByName(nil,"path7"):GetAbsOrigin()

		GameRules:GetGameModeEntity().gem_path = {
			{p1,p0},{p0,p2},{p2,p3},{p3,p4},{p4,p5},{p5,p6},{p6,p7}
		}

		GameRules:GetGameModeEntity().gem_path_all = {}
		for i = 1,7 do
			for j = 1,table.maxn(GameRules:GetGameModeEntity().gem_path[i])-1 do
				table.insert (GameRules:GetGameModeEntity().gem_path_all, GameRules:GetGameModeEntity().gem_path[i][j])
			end
		end
		table.insert (GameRules:GetGameModeEntity().gem_path_all, p7)
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
		GameRules:GetGameModeEntity().gem_maze_length = GameRules:GetGameModeEntity().gem_maze_length + length
		
		for node, count in path:iter() do
			

				dx = node.x-lastx
				dy = node.y-lasty

				if dy==0 then
					d = 999
				else
					d = dx/dy
				end

				--print(('Step%d - %d,%d'):format(count, node.x, node.y))

				local lastindex = table.maxn (GameRules:GetGameModeEntity().gem_path[step])

				if d~=lastd or lastindex<=1 then
					local xxx = (node.x-19)*128
					local yyy = (node.y-19)*128
					local p = Vector(xxx,yyy,137)
					table.insert (GameRules:GetGameModeEntity().gem_path[step], p)
				else
					local xxx = (node.x-19)*128
					local yyy = (node.y-19)*128
					local p = Vector(xxx,yyy,137)
					
					GameRules:GetGameModeEntity().gem_path[step][lastindex] = p
				end
				lastdx = dx
				lastdy = dy
				lastx = node.x
				lasty = node.y
				lastd = d

		end
	else
		GameRules:GetGameModeEntity().gem_path[step] = {}
	end
end
function check_path_race(p1,p2)

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
		return true
	else
		return false
	end
end
function find_path_race(p1,p2,step,playerid)

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
		GameRules:GetGameModeEntity().gem_maze_length_race[playerid] = GameRules:GetGameModeEntity().gem_maze_length_race[playerid] + length
		
		for node, count in path:iter() do
			

				dx = node.x-lastx
				dy = node.y-lasty

				if dy==0 then
					d = 999
				else
					d = dx/dy
				end

				--print(('Step%d - %d,%d'):format(count, node.x, node.y))

				local lastindex = table.maxn (GameRules:GetGameModeEntity().gem_path_race[playerid][step])

				if d~=lastd or lastindex<=1 then
					local xxx = (node.x-19)*128
					local yyy = (node.y-19)*128
					local p = Vector(xxx,yyy,137)
					table.insert (GameRules:GetGameModeEntity().gem_path_race[playerid][step], p)
				else
					local xxx = (node.x-19)*128
					local yyy = (node.y-19)*128
					local p = Vector(xxx,yyy,137)
					
					GameRules:GetGameModeEntity().gem_path_race[playerid][step][lastindex] = p
				end
				lastdx = dx
				lastdy = dy
				lastx = node.x
				lasty = node.y
				lastd = d

		end
	else
		GameRules:GetGameModeEntity().gem_path_race[playerid][step] = {}
	end
end
function find_path_one(p1,p2)
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

		GameRules:GetGameModeEntity().gem_maze_length = GameRules:GetGameModeEntity().gem_maze_length + length
		
		for node, count in path:iter() do
			local xxx = (node.x-19)*128
			local yyy = (node.y-19)*128
			local p = Vector(xxx,yyy,137)
			if (p - p2):Length2D() < 32 or (p - p1):Length2D() >= 100 then
				return p
			end
		end
		return nil
	else
		return nil
	end
end

--英雄操作1——手动换英雄
function GemTD:OnRepickHero(keys)
	local heroindex = keys.heroindex
	local steam_id = keys.steam_id
	local repick_hero = tonumber(keys.repick_hero)
	local repipck_hero_level = tonumber(keys.repipck_hero_level)

	local hero = GameRules:GetGameModeEntity().hero[heroindex]
	local id = hero:GetPlayerID()

	play_particle("particles/items2_fx/refresher.vpcf",PATTACH_ABSORIGIN_FOLLOW,hero,2)

	PrecacheUnitByNameAsync( GameRules:GetGameModeEntity().hero_sea[repick_hero], function()

		if hero.ppp ~= nil then
			ParticleManager:DestroyParticle(hero.ppp,true)
		end

		local hero_new = PlayerResource:ReplaceHeroWith(id,GameRules:GetGameModeEntity().hero_sea[repick_hero],PlayerResource:GetGold(id),0)
		GameRules:GetGameModeEntity().replced[id] = true

		GameRules:GetGameModeEntity().hero[heroindex] = nil
		GameRules:GetGameModeEntity().hero[hero_new:GetEntityIndex()] = hero_new

		CustomNetTables:SetTableValue( "game_state", "repick_hero", { old_index = heroindex, new_index = hero_new:GetEntityIndex() } );

		CustomNetTables:SetTableValue( "game_state", "select_hero1", { p1 = PlayerResource:GetSelectedHeroName(0), p2 = PlayerResource:GetSelectedHeroName(1), p3 = PlayerResource:GetSelectedHeroName(2), p4 = PlayerResource:GetSelectedHeroName(3) } );

		hero_new:RemoveAbility("gemtd_build_stone")
		hero_new:RemoveAbility("gemtd_remove")

		
		hero_new:AddAbility("gemtd_build_stone")
		hero_new.build_level = GameRules:GetGameModeEntity().level
		hero_new:FindAbilityByName("gemtd_build_stone"):SetLevel(1)
		hero_new:AddAbility("gemtd_remove")
		hero_new:FindAbilityByName("gemtd_remove"):SetLevel(1)

		local a = GameRules:GetGameModeEntity().ability_sea[repick_hero]
		hero_new:AddAbility(a)
		hero_new:FindAbilityByName(a):SetLevel(repipck_hero_level)
		hero_new.ability = a;
		hero_new.ability_level = repipck_hero_level;

		--添加玩家颜色底盘
		local particle = ParticleManager:CreateParticle("particles/gem/team_"..(id+1)..".vpcf", PATTACH_ABSORIGIN_FOLLOW, hero_new) 
		hero_new.ppp = particle

		SetHeroLevelShow(hero_new)

	end, id)
end
--英雄操作2——英雄升级
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
end
--英雄操作3——显示英雄头上的建造几率图标
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
--英雄操作4——同步金钱
function sync_player_gold(caster)
	local player_id = 0
	if caster ~= nil then
		player_id = caster:GetOwner():GetPlayerID()
	end
	--同步玩家金钱
	if GetMapName() == 'gemtd_1p' or GetMapName() == 'gemtd_coop' then
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
		GameRules:GetGameModeEntity().team_gold = gold_count
		CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );
	else
		for player_id=0, PlayerResource:GetPlayerCount()-1 do
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id),"show_money",{ money = PlayerResource:GetGold(player_id),})
		end
	end
end

--界面操作1——共享地图
function GemTD:OnReceiveShareMap(keys)
	GameRules:GetGameModeEntity().map = keys.map

	if GameRules:GetGameModeEntity().map ~= nil then
		GameRules:SendCustomMessage("#show_maze_pic", 0, 0)
		CustomNetTables:SetTableValue( "game_state", "show_maze_map", {map = GameRules:GetGameModeEntity().map} );
	end
end
--界面操作2——玩家主动结束游戏
function GemTD:OnGGsimida( keys )
	if GetMapName() == 'gemtd_1p' or GetMapName() == 'gemtd_coop' then
		GameRules:GetGameModeEntity().game_status = 3
		send_ranking ()
		Timers:CreateTimer(20, function()
			GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		end)
	else
		--竞速模式
		GameRules:GetGameModeEntity().gem_castle_hp_race[keys.player_id] = 0
		race_player_fail(keys.player_id)
	end
end
--界面操作3——玩家说话
function GemTD:OnPlayerSay( keys )
	local player = userid2player[keys.userid]
	local hero = EntIndexToHScript(player):GetAssignedHero()
	local heroindex = hero:GetEntityIndex()
	local steam_id = GameRules:GetGameModeEntity().playerInfoReceived[heroindex].steam_id

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
		if GetMapName() == 'gemtd_race' then
			GemTD:OnGGsimida( {
				player_id = hero:GetPlayerID()
			} )
		else
			zuobi()
			GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		end

	elseif tokens[1] == "-ggsimida" then
		GemTD:OnGGsimida( {
			player_id = hero:GetPlayerID()
		} )
	elseif tokens[1] == "-showggsimida" then
		CustomNetTables:SetTableValue( "game_state", "show_ggsimida_race", { player = hero:GetPlayerID(), hehe=RandomInt(1,10000)} )
	elseif tokens[1] == "-money" and GameRules:GetGameModeEntity().myself == true then
		PlayerResource:SetGold(hero:GetPlayerID(),9999,true)
		EmitGlobalSound("General.CoinsBig")
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerID()),"show_money",{
			money = PlayerResource:GetGold(hero:GetPlayerID()),
		})
	elseif tokens[1] == "-crab" and GameRules:GetGameModeEntity().myself == true then
		GameRules:GetGameModeEntity().crab = tokens[2]
	elseif tokens[1] == "-spawn" and GameRules:GetGameModeEntity().myself == true then
		GameRules:GetGameModeEntity().stop_watch = GameRules:GetGameTime()
		spawn_one_wave()
	elseif tokens[1] == "-choose" and GameRules:GetGameModeEntity().myself == true then
		GameRules:GetGameModeEntity().level = tonumber(tokens[2])
		-- GameRules:GetGameModeEntity().build_ready_wave[hero:GetPlayerID()] = tonumber(tokens[2])
	elseif tokens[1] == "-debug" and GameRules:GetGameModeEntity().myself == true then
		GameRules:GetGameModeEntity().is_debug = true
		GameRules:SendCustomMessage("开启调试信息", 0, 0)
	elseif tokens[1] == "-undebug" and GameRules:GetGameModeEntity().myself == true then
		GameRules:GetGameModeEntity().is_debug = false
		GameRules:SendCustomMessage("关闭调试信息", 0, 0)
	elseif tokens[1] == "-testdrop" and GameRules:GetGameModeEntity().myself == true then
		GameRules:GetGameModeEntity().DROP_PER = 50
		GameRules:SendCustomMessage("开启50%掉宝测试", 0, 0)
	end
		
	CustomNetTables:SetTableValue( "game_state", "say_bubble", {text = keys.text, unit = heroindex, hehe = RandomInt(1,10000)} )

	if string.find(keys.text,"^%w%w%w%w%w%p%w%w%w%w%w%p%w%w%w%w%w$") ~= nil then
		local key = string.upper(keys.text)
		--GameRules:SendCustomMessage("玩家heroindex="..hero:entindex().."激活码: "..key, 0, 0)
		CustomNetTables:SetTableValue( "game_state", "cdkey", {user = hero:entindex(), steam_id = steam_id ,text = key,hehe = RandomInt(1,10000)})
		return
	end

	--特效测试
	if string.find(keys.text,"^e%w%w%w$") ~= nil and GameRules:GetGameModeEntity().myself == true then
		GameRules:SendCustomMessage("特效:"..keys.text, 0, 0)
		if hero.effect ~= nil then
			hero:RemoveAbility(hero.effect)
			hero:RemoveModifierByName('modifier_texiao_star')
		end
		hero:AddAbility(keys.text)
		hero:FindAbilityByName(keys.text):SetLevel(1)
		hero.effect = keys.text
	end
end
--界面操作4——特效预览
function GemTD:OnPreviewEffect(keys)
	local h = EntIndexToHScript(keys.hero_index)
	local e = keys.effect

	DeepPrintTable(keys)

	if h.effect ~= nil then
		h:RemoveAbility(h.effect)
		h:RemoveModifierByName('modifier_texiao_star')
	end
	h:AddAbility(e)
	h:FindAbilityByName(e):SetLevel(1)

	Timers:CreateTimer(5,function()
		h:RemoveAbility(e)
		h:RemoveModifierByName('modifier_texiao_star')
		if h.effect ~= nil then
			h:AddAbility(h.effect)
			h:FindAbilityByName(h.effect):SetLevel(1)
		end
	end)
end
--界面操作5——显示任务完成状态
function show_quest()
	if GetMapName() == 'gemtd_race' then
		return
	end
	local quest_status_send = {}
	for m,n in pairs(GameRules:GetGameModeEntity().quest) do
		if GameRules:GetGameModeEntity().quest_status[m] == true then 
			quest_status_send[m] = true
		else
			quest_status_send[m] = false
		end
	end

	CustomNetTables:SetTableValue( "game_state", "show_quest", quest_status_send)
end

--辅助功能——防止作弊
function GemTD:OnNPCSpawned( keys )
	local spawned_unit = EntIndexToHScript(keys.entindex)

	local spawned_unit_name = spawned_unit:GetUnitName()

	--英雄出生
	if spawned_unit:IsHero() then
		spawned_unit.ftd = 2009

		local owner = spawned_unit:GetOwner()
		local player_id = owner:GetPlayerID()

		spawned_unit:SetHullRadius(1)

		GameRules:GetGameModeEntity().gem_hero[player_id] = spawned_unit

		GameRules:SetTimeOfDay(0.3)
	end

	Timers:CreateTimer(0.5, function()
			if (spawned_unit:IsNull()) or (not spawned_unit:IsAlive()) then
				return nil
			end

			if (spawned_unit.ftd ~= 2009 and spawned_unit:GetUnitName() ~= "npc_dota_thinker" and spawned_unit:GetUnitName() ~= "npc_dota_companion" and spawned_unit:GetUnitName() ~= nil and string.len(spawned_unit:GetUnitName())>0 and (not string.find(spawned_unit:GetUnitName(),'_dota_phantomassassin_gravestone'))) then

				if spawned_unit:GetAttackDamage()>2 or spawned_unit:GetHullRadius()>10 then
					zuobi()
					GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
					GameRules:SendCustomMessage("非法单位: "..spawned_unit:GetUnitName(), 0, 0)
					-- end
				end
				return nil
			end
		end
	)
end
function DetectCheatsThinker ()
	if (Convars:GetBool("sv_cheats")) then
		zuobi()
		return nil
	end
	return GameRules:GetGameModeEntity().check_cheat_interval
end
--辅助功能——作弊提示
function zuobi()
	GameRules:SendCustomMessage("#text_cheat_detected", 0, 0)
	--GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	GameRules:GetGameModeEntity().is_cheat = true
end
--辅助功能——播放特效
function play_particle(p, pos, u, d)
	local pp = ParticleManager:CreateParticle(p, pos, u)
	Timers:CreateTimer(d,function()
		ParticleManager:DestroyParticle(pp,true)
	end)
end
--辅助功能——不留石头的任务状态改变
function stone_quest(s)
	if s == "gemtd_d1" or s == "gemtd_d11" or s == "gemtd_d111" or s == "gemtd_d1111" or s == "gemtd_d11111"  or s == "gemtd_d111111" then
		GameRules:GetGameModeEntity().quest_status["q202"] = false
		show_quest()
	end
	if s == "gemtd_b1" or s == "gemtd_b11" or s == "gemtd_b111" or s == "gemtd_b1111" or s == "gemtd_b11111"  or s == "gemtd_b111111" then
		GameRules:GetGameModeEntity().quest_status["q203"] = false
		show_quest()
	end
	if s == "gemtd_r1" or s == "gemtd_r11" or s == "gemtd_r111" or s == "gemtd_r1111" or s == "gemtd_r11111"  or s == "gemtd_r111111" then
		GameRules:GetGameModeEntity().quest_status["q204"] = false
		show_quest()
	end
	if s == "gemtd_y1" or s == "gemtd_y11" or s == "gemtd_y111" or s == "gemtd_y1111" or s == "gemtd_y11111"  or s == "gemtd_y111111" then
		GameRules:GetGameModeEntity().quest_status["q205"] = false
		show_quest()
	end
	if s == "gemtd_p1" or s == "gemtd_p11" or s == "gemtd_p111" or s == "gemtd_p1111" or s == "gemtd_p11111"  or s == "gemtd_p111111" then
		GameRules:GetGameModeEntity().quest_status["q206"] = false
		show_quest()
	end
	if s == "gemtd_q1" or s == "gemtd_q11" or s == "gemtd_q111" or s == "gemtd_q1111" or s == "gemtd_q11111"  or s == "gemtd_q111111" then
		GameRules:GetGameModeEntity().quest_status["q207"] = false
		show_quest()
	end
	if s == "gemtd_g1" or s == "gemtd_g11" or s == "gemtd_g111" or s == "gemtd_g1111" or s == "gemtd_g11111"  or s == "gemtd_g111111" then
		GameRules:GetGameModeEntity().quest_status["q208"] = false
		show_quest()
	end
end
--辅助功能——创建隐藏单位施法
function InvisibleUnitCast(keys)
	local shiban = keys.caster
	local shiban_ability = keys.ability
	local ability_level = keys.level
	local unluckydog = keys.unluckydog
	local position = keys.position

	local uu = CreateUnitByName("gemtd_feicuimoxiang_yinxing", shiban:GetAbsOrigin() ,false,nil,nil, DOTA_TEAM_GOODGUYS) 
	uu.ftd = 2009
	uu:SetOwner(shiban)

	uu:AddAbility(shiban_ability)
	uu:FindAbilityByName(shiban_ability):SetLevel(ability_level)
	Timers:CreateTimer(0.05,function()
		if uu:FindAbilityByName(shiban_ability):GetBehavior() == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
			local newOrder = {
		 		UnitIndex = uu:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		 		TargetIndex = unluckydog:entindex(), --Optional.  Only used when targeting units
		 		AbilityIndex = uu:FindAbilityByName(shiban_ability):entindex(), --Optional.  Only used when casting abilities
		 		Position = nil, --Optional.  Only used when targeting the ground
		 		Queue = 0 --Optional.  Used for queueing up abilities
		 	}
			ExecuteOrderFromTable(newOrder)
		elseif uu:FindAbilityByName(shiban_ability):GetBehavior() == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
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
		Timers:CreateTimer(10,function()
			uu:ForceKill(false)
			uu:Destroy()
		end)
	end)
end
function InvisibleEnemyCastFog(keys)
	local player_id = keys.player_id
	local p = Entities:FindByName(nil,'center'..player_id):GetAbsOrigin() + Vector(RandomInt(-400,400),RandomInt(-400,400),0)

	local uu = CreateUnitByName("gemtd_feicuimoxiang_yinxing", p ,false,nil,nil, DOTA_TEAM_BADGUYS) 
	uu.ftd = 2009

	uu:AddAbility("riki_smoke_screen")
	uu:FindAbilityByName("riki_smoke_screen"):SetLevel(4)
	Timers:CreateTimer(0.05,function()
		local newOrder = {
	 		UnitIndex = uu:entindex(), 
	 		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
	 		TargetIndex = nil, --Optional.  Only used when targeting units
	 		AbilityIndex = uu:FindAbilityByName("riki_smoke_screen"):entindex(), --Optional.  Only used when casting abilities
	 		Position = p, --Optional.  Only used when targeting the ground
	 		Queue = 0 --Optional.  Used for queueing up abilities
	 	}
		ExecuteOrderFromTable(newOrder)

		Timers:CreateTimer(5,function()
			uu:ForceKill(false)
			uu:Destroy()
		end)
	end)
end
--辅助功能——在屏幕中央上方显示大字
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
	elseif msg == "youwin_race" then
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
--辅助功能——伤害显示
function show_damage( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	if attacker == nil or attacker:IsHero() then
		return
	end
	local player_id = attacker:GetOwner():GetPlayerID()

	
	local owner = attacker:GetOwner()
	if owner == nil then
		return
	end
	local damage = math.floor(keys.DamageTaken)
	if damage<=0 then
		damage = 0
	end
	
	-- if damage >= (GameRules:GetGameModeEntity().level*2) then
	-- 	AMHC:CreateNumberEffect(caster,damage,2,AMHC.MSG_DAMAGE,"red",3)
	-- end

	--伤害统计
	local attacker_id = attacker:GetEntityIndex()
	if attacker.father ~= nil then
		attacker_id = attacker.father:GetEntityIndex()
	end

	if GetMapName() == 'gemtd_1p' or GetMapName() == 'gemtd_coop' then
		local curr_damage = GameRules:GetGameModeEntity().damage[attacker_id]
		if curr_damage == nil then
			curr_damage = 0
		end
		curr_damage = curr_damage + damage
		GameRules:GetGameModeEntity().damage[attacker_id] = curr_damage

		local g_time = GameRules:GetGameTime() - GameRules:GetGameModeEntity().game_time
		if GameRules:GetGameModeEntity().last_g_time == nil then
			GameRules:GetGameModeEntity().last_g_time = 0
		end
		local time_this_level = math.floor(GameRules:GetGameTime() - GameRules:GetGameModeEntity().stop_watch)
		if g_time - GameRules:GetGameModeEntity().last_g_time > 1 then
			GameRules:GetGameModeEntity().last_g_time = g_time
			CustomNetTables:SetTableValue( "game_state", "damage_stat", { level = GameRules:GetGameModeEntity().level, damage_table = GameRules:GetGameModeEntity().damage , time_this_level = time_this_level, hehe = RandomInt(1,100000) } )
		end
	elseif GetMapName() == 'gemtd_race' then
		local curr_damage = GameRules:GetGameModeEntity().damage_race[player_id][attacker_id]
		if curr_damage == nil then
			curr_damage = 0
		end
		curr_damage = curr_damage + damage
		GameRules:GetGameModeEntity().damage_race[player_id][attacker_id] = curr_damage

		local g_time = GameRules:GetGameTime() - GameRules:GetGameModeEntity().game_time
		if GameRules:GetGameModeEntity()['last_g_time'..player_id] == nil then
			GameRules:GetGameModeEntity()['last_g_time'..player_id] = 0
		end
		local time_this_level = math.floor(GameRules:GetGameTime() - GameRules:GetGameModeEntity().stop_watch)
		if g_time - GameRules:GetGameModeEntity()['last_g_time'..player_id] > 1 then
			GameRules:GetGameModeEntity()['last_g_time'..player_id] = g_time
			CustomNetTables:SetTableValue( "game_state", "damage_stat_race", { level = GameRules:GetGameModeEntity().level, damage_table = GameRules:GetGameModeEntity().damage_race , time_this_level = time_this_level, hehe = RandomInt(1,100000) } )
		end

	end
end
--辅助功能——咩子的维修工具
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
--辅助功能——捕捉一只螃蟹，发回pui
function GemTD:OnCatchCrab(keys)
	local url = keys.url
	local cb = keys.cb
	if url == null or cb == null then
		return
	end
	local user = keys.user

	url = string.gsub(url,"gemtd/ranking/add/","gemtd/201806/ranking/add/")
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
--栅格化坐标
function rasterize_vector(pp)
	local xxx = math.floor((pp.x+64)/128)+19
	local yyy = math.floor((pp.y+64)/128)+19
	pp.x = math.floor((pp.x+64)/128)*128
	pp.y = math.floor((pp.y+64)/128)*128
	return pp
end
--把现有的塔发送到pui的合成面板显示
function send_merge_board(player_id)
	if GetMapName() == 'gemtd_1p' or GetMapName() == 'gemtd_coop' then
		--合作模式
		local send_pool = {}
		for c,c_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool) do
			if c_unit ~= nil then
				if c_unit ~= nil and c_unit:IsNull() == false then
					table.insert (send_pool, c_unit:GetUnitName())
				end
			end
		end
		CustomNetTables:SetTableValue( "game_state", "gem_merge_board", send_pool )

		--发送merge_board_curr
		local send_pool = {}

		for c,c_unit in pairs(GameRules:GetGameModeEntity().build_curr[0]) do
			table.insert (send_pool, c_unit:GetUnitName())
		end
		for c,c_unit in pairs(GameRules:GetGameModeEntity().build_curr[1]) do
			table.insert (send_pool, c_unit:GetUnitName())
		end
		for c,c_unit in pairs(GameRules:GetGameModeEntity().build_curr[2]) do
			table.insert (send_pool, c_unit:GetUnitName())
		end
		for c,c_unit in pairs(GameRules:GetGameModeEntity().build_curr[3]) do
			table.insert (send_pool, c_unit:GetUnitName())
		end
		CustomNetTables:SetTableValue( "game_state", "gem_merge_board_curr", send_pool )
	elseif GetMapName() == 'gemtd_race' then
		--竞速模式
		local send_pool = {}
		for c,c_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool_race[player_id]) do
			if c_unit ~= nil and c_unit:IsNull() == false then
				table.insert (send_pool, c_unit:GetUnitName())
			end
		end
		CustomNetTables:SetTableValue( "game_state", "gem_merge_board_race", {pool = send_pool,player = player_id, hehe = RandomInt(1,100000)} )

		local send_pool = {}
		for c,c_unit in pairs(GameRules:GetGameModeEntity().build_curr[player_id]) do
			table.insert (send_pool, c_unit:GetUnitName())
		end
		CustomNetTables:SetTableValue( "game_state", "gem_merge_board_curr_race", {pool = send_pool,player = player_id, hehe = RandomInt(1,100000)} )
	end
end

--玩家技能
--小鹿-回春
function gemtd_jidihuixue(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_huichun"):GetLevel()

	local huixue_max = {
		[1] = 10,
		[2] = 13,
		[3] = 15,
		[4] = 16,
	}

	local hp_count = RandomInt(1,huixue_max[level])
	EmitGlobalSound("DOTAMusic_Stinger.004")
	--同步玩家金钱
	sync_player_gold(caster)
	if GetMapName() ~= "gemtd_race" then
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
	else
		GameRules:GetGameModeEntity().gem_castle_hp_race[player_id] = GameRules:GetGameModeEntity().gem_castle_hp_race[player_id] + hp_count
	    if GameRules:GetGameModeEntity().gem_castle_hp_race[player_id] > 100 then
	        GameRules:GetGameModeEntity().gem_castle_hp_race[player_id] = 100
	    end
	    GameRules:GetGameModeEntity().gem_castle_race[player_id]:SetHealth(GameRules:GetGameModeEntity().gem_castle_hp_race[player_id])
	    CustomNetTables:SetTableValue( "game_state", "gem_life_race", { player = player_id, gem_life = GameRules:GetGameModeEntity().gem_castle_hp_race[player_id] } ); 
	    AMHC:CreateNumberEffect(caster,hp_count,5,AMHC.MSG_MISS,"green",0)

	    caster:SetHealth(GameRules:GetGameModeEntity().gem_castle_hp_race[player_id])
	end
end
--帕克-闪避
function gemtd_hero_shanbi(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_shanbi"):GetLevel()
	--同步玩家金钱
	sync_player_gold(caster)
	if GetMapName() ~= "gemtd_race" then
		--为宝石基地增加闪避buff
		GameRules:GetGameModeEntity().gem_castle.shanbi = level*5 + 5

		EmitGlobalSound("n_creep_ghost.Death")

		if GameRules:GetGameModeEntity().gem_castle.shanbi_particle ~= nil then
			ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().gem_castle.shanbi_particle,true)
		end
		local particle = ParticleManager:CreateParticle("particles/gem/immunity_sphere_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, GameRules:GetGameModeEntity().gem_castle) 
		GameRules:GetGameModeEntity().gem_castle.shanbi_particle = particle

		Timers:CreateTimer(60,function()
			GameRules:GetGameModeEntity().gem_castle.shanbi = 0
			ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().gem_castle.shanbi_particle,true)
		end)
	else
		--为宝石基地增加闪避buff
		GameRules:GetGameModeEntity().gem_castle_race[player_id].shanbi = level*5 + 5

		EmitGlobalSound("n_creep_ghost.Death")

		if GameRules:GetGameModeEntity().gem_castle_race[player_id].shanbi_particle ~= nil then
			ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().gem_castle_race[player_id].shanbi_particle,true)
		end
		local particle = ParticleManager:CreateParticle("particles/gem/immunity_sphere_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, GameRules:GetGameModeEntity().gem_castle_race[player_id]) 
		GameRules:GetGameModeEntity().gem_castle_race[player_id].shanbi_particle = particle

		Timers:CreateTimer(60,function()
			GameRules:GetGameModeEntity().gem_castle_race[player_id].shanbi = 0
			ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().gem_castle_race[player_id].shanbi_particle,true)
		end)
	end
end
--全能-守护
function gemtd_hero_shouhu(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_shouhu"):GetLevel()

	--同步玩家金钱
	sync_player_gold(caster)
	if GetMapName() ~= "gemtd_race" then
		--为宝石基地增加守护buff
		GameRules:GetGameModeEntity().gem_castle.shouhu = level

		EmitGlobalSound("Item.CrimsonGuard.Cast")

		if GameRules:GetGameModeEntity().gem_castle.shouhu_particle ~= nil then
			ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().gem_castle.shouhu_particle,true)
		end
		local particle = ParticleManager:CreateParticle("effect/omniwings/omni.vpcf", PATTACH_ABSORIGIN_FOLLOW, GameRules:GetGameModeEntity().gem_castle) 
		GameRules:GetGameModeEntity().gem_castle.shouhu_particle = particle

		Timers:CreateTimer(60,function()
			GameRules:GetGameModeEntity().gem_castle.shouhu = 0
			ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().gem_castle.shouhu_particle,true)
		end)
	else
		--为宝石基地增加守护buff
		GameRules:GetGameModeEntity().gem_castle_race[player_id].shouhu = level

		EmitGlobalSound("Item.CrimsonGuard.Cast")

		if GameRules:GetGameModeEntity().gem_castle_race[player_id].shouhu_particle ~= nil then
			ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().gem_castle_race[player_id].shouhu_particle,true)
		end
		local particle = ParticleManager:CreateParticle("effect/omniwings/omni.vpcf", PATTACH_ABSORIGIN_FOLLOW, GameRules:GetGameModeEntity().gem_castle_race[player_id]) 
		GameRules:GetGameModeEntity().gem_castle_race[player_id].shouhu_particle = particle

		Timers:CreateTimer(60,function()
			GameRules:GetGameModeEntity().gem_castle_race[player_id].shouhu = 0
			ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().gem_castle_race[player_id].shouhu_particle,true)
		end)
	end
end
--回到过去
function gemtd_hero_huidaoguoqu(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_huidaoguoqu"):GetLevel()

	if GameRules:GetGameModeEntity().game_status ~= 1 then
		EmitGlobalSound("General.CastFail_NoMana")
		return
	end

	if GameRules:GetGameModeEntity().is_build_ready[player_id] == true then
		EmitGlobalSound("General.CastFail_NoMana")
		return
	end

	--同步玩家金钱
	sync_player_gold(caster)

	--开始回到过去
	for m,vm in pairs(GameRules:GetGameModeEntity().build_curr[player_id]) do
		local xxx = math.floor((vm:GetAbsOrigin().x+64)/128)+19
		local yyy = math.floor((vm:GetAbsOrigin().y+64)/128)+19

		GameRules:GetGameModeEntity().gem_map[yyy][xxx]=0

		if vm.ppp then
			ParticleManager:DestroyParticle(vm.ppp,true)
		end
		vm:Destroy()
	end
	find_all_path()

	GameRules:GetGameModeEntity().build_curr[player_id] = {}

	GameRules:GetGameModeEntity().build_index[player_id] = 0
	send_merge_board(player_id)


	caster:FindAbilityByName("gemtd_build_stone"):SetActivated(true)
	caster:FindAbilityByName("gemtd_remove"):SetActivated(true)
	--只有建造阶段能用的技能
	SetAbilityActiveStatus(caster,true)
	caster.build_level = GameRules:GetGameModeEntity().level
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
	sync_player_gold(caster)

	EmitGlobalSound("Item.DropGemShop")
	play_particle("particles/gem/blue_pray.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,5)

	--增加几率
	caster.pray_color = 1
	caster.pray = GameRules:GetGameModeEntity().pray_gailv[level]
end
function gemtd_hero_danbai(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_danbai"):GetLevel()

	--同步玩家金钱
	sync_player_gold(caster)

	EmitGlobalSound("Item.DropGemShop")
	play_particle("particles/gem/opal_pray.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,5)

	--增加几率
	caster.pray_color = 4
	caster.pray = GameRules:GetGameModeEntity().pray_gailv[level]
end
function gemtd_hero_baise(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_baise"):GetLevel()

	--同步玩家金钱
	sync_player_gold(caster)

	EmitGlobalSound("Item.DropGemShop")
	play_particle("particles/gem/white_pray.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,5)

	--增加几率
	caster.pray_color = 2
	caster.pray = GameRules:GetGameModeEntity().pray_gailv[level]
end
function gemtd_hero_hongse(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_hongse"):GetLevel()

	--同步玩家金钱
	sync_player_gold(caster)

	EmitGlobalSound("Item.DropGemShop")
	play_particle("particles/gem/red_pray.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,5)

	--增加几率
	caster.pray_color = 7
	caster.pray = GameRules:GetGameModeEntity().pray_gailv[level]
end
function gemtd_hero_zise(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_zise"):GetLevel()

	--同步玩家金钱
	sync_player_gold(caster)

	EmitGlobalSound("Item.DropGemShop")
	play_particle("particles/gem/purple_pray.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,5)

	--增加几率
	caster.pray_color = 8
	caster.pray = GameRules:GetGameModeEntity().pray_gailv[level]
end
function gemtd_hero_lvse(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_lvse"):GetLevel()

	--同步玩家金钱
	sync_player_gold(caster)

	EmitGlobalSound("Item.DropGemShop")
	play_particle("particles/gem/green_pray.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,5)

	--增加几率
	caster.pray_color = 5
	caster.pray = GameRules:GetGameModeEntity().pray_gailv[level]
end
function gemtd_hero_fense(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_fense"):GetLevel()

	--同步玩家金钱
	sync_player_gold(caster)

	EmitGlobalSound("Item.DropGemShop")
	play_particle("particles/gem/sea_pray.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,5)

	--增加几率
	caster.pray_color = 3
	caster.pray = GameRules:GetGameModeEntity().pray_gailv[level]
end
function gemtd_hero_huangse(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_huangse"):GetLevel()

	--同步玩家金钱
	sync_player_gold(caster)

	EmitGlobalSound("Item.DropGemShop")
	play_particle("particles/gem/yellow_pray.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,5)

	--增加几率
	caster.pray_color = 6
	caster.pray = GameRules:GetGameModeEntity().pray_gailv[level]
end
function gemtd_hero_putong(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_putong"):GetLevel()

	--同步玩家金钱
	sync_player_gold(caster)

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
	sync_player_gold(caster)

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
	sync_player_gold(caster)

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
	sync_player_gold(caster)
end
--幻刺-暴击
function gemtd_hero_baoji(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_baoji"):GetLevel()

	--同步玩家金钱
	sync_player_gold(caster)
end
--火枪-瞄准
function gemtd_hero_miaozhun(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local level = caster:FindAbilityByName("gemtd_hero_miaozhun"):GetLevel()

	--同步玩家金钱
	sync_player_gold(caster)
end
--致命链接
function GemTD:OnPlayerUseAbility(keys)
	local player_id = keys.PlayerID
	if keys.abilityname == "gemtd_hero_lianjie" then
		--同步玩家金钱
		sync_player_gold(caster)
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
	sync_player_gold(caster)

	if target:GetUnitName() == "gemtd_castle" then
		EmitGlobalSound("General.InvalidTarget_Invulnerable")
		GameRules:SendCustomMessage("#cannot_swap_gem_castle",0,0)
		return
	end

	if GetMapName() == "gemtd_race" and target:GetOwner():GetPlayerID() ~= caster:GetPlayerID() then
		EmitGlobalSound("General.InvalidTarget_Invulnerable")
		return
	end
	--go!
	if GameRules:GetGameModeEntity().gem_swap[player_id] == nil or GameRules:GetGameModeEntity().gem_swap[player_id]:IsNull() == true then
		--存
		GameRules:GetGameModeEntity().gem_swap[player_id] = target
		EmitGlobalSound("DOTA_Item.Daedelus.Crit")
	else
		--换
		play_particle("particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf",PATTACH_OVERHEAD_FOLLOW,target,2)
		EmitGlobalSound("DOTA_Item.Daedelus.Crit")
		local u1 = GameRules:GetGameModeEntity().gem_swap[player_id]
		local u2 = target
		local p1 = u1:GetAbsOrigin()
		local p2 = u2:GetAbsOrigin()
		u1:SetAbsOrigin(Vector(5000,5000,0))
		u2:SetAbsOrigin(p1)
		u1:SetAbsOrigin(p2)

		GameRules:GetGameModeEntity().gem_swap[player_id] = nil
	end
end
--小挪移
function gemtd_hero_qingyi(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	local target = keys.target

	if GetMapName() == 'gemtd_race' and player_id ~= target:GetOwner():GetPlayerID() then
		--不允许换别人的
		return
	end

	--同步玩家金钱
	sync_player_gold(caster)

	if target:GetUnitName() == "gemtd_castle" then
		EmitGlobalSound("General.InvalidTarget_Invulnerable")
		GameRules:SendCustomMessage("#cannot_swap_gem_castle",0,0)
		return
	end

	local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                              target:GetAbsOrigin(),
                              nil,
                              192,
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
--巨石阵
function gemtd_hero_shitou(keys)
	local caster = keys.caster
	local level = caster:FindAbilityByName("gemtd_hero_shitou"):GetLevel()

	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	--同步玩家金钱
	sync_player_gold(caster)


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

	--网格化坐标
	p.x = math.floor((p.x+64)/128)*128
	p.y = math.floor((p.y+64)/128)*128

	if GetMapName()=='gemtd_1p' or GetMapName()=='gemtd_coop' then
		if xxx>=29 and yyy<=9 then
			EmitGlobalSound("ui.crafting_gem_drop")
			return
		end
		if xxx<=9 and yyy>=29 then
			EmitGlobalSound("ui.crafting_gem_drop")
			return
		end
	end

	--附近有怪，不能造
	local uu = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              p,
                              nil,
                              96,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
	if table.getn(uu) > 0 then
		EmitGlobalSound("ui.crafting_gem_drop")
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
	if GetMapName() ~= "gemtd_race" then
		for i=1,7 do
			local p1 = Entities:FindByName(nil,"path"..i):GetAbsOrigin()
			local xxx1 = math.floor((p1.x+64)/128)+19
			local yyy1 = math.floor((p1.y+64)/128)+19
			if xxx==xxx1 and yyy==yyy1 then
				EmitGlobalSound("ui.crafting_gem_drop")
				return
			end
		end
	end
	if GetMapName() == "gemtd_race" then
		for j=0,3 do
			for i=1,7 do
				local p1 = Entities:FindByName(nil,"path"..((10*j)+i)):GetAbsOrigin()
				local xxx1 = math.floor((p1.x+64)/128)+19
				local yyy1 = math.floor((p1.y+64)/128)+19
				if xxx==xxx1 and yyy==yyy1 then
					EmitGlobalSound("ui.crafting_gem_drop")
					return
				end
			end
		end
	end
	

	--地图范围外，不能造
	if xxx<1 or xxx>37 or yyy<1 or yyy>37 then
		EmitGlobalSound("ui.crafting_gem_drop")
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

	--竞速模式，不能在别人的区域建造
	if GetMapName() == 'gemtd_race' then
		if check_area(player_id,p) == false then	
			EmitGlobalSound("ui.crafting_gem_drop")
			return false
		end
	end


	GameRules:GetGameModeEntity().gem_map[yyy][xxx]=1

	if GetMapName() == 'gemtd_1p' or GetMapName() == 'gemtd_coop' then
		--合作模式判断堵路
		find_all_path()
		--路完全堵死了，不能造
		for i=1,6 do
			if table.maxn(GameRules:GetGameModeEntity().gem_path[i])<1 then
				EmitGlobalSound("ui.crafting_gem_drop")
				--回退地图，重新寻路
				GameRules:GetGameModeEntity().gem_map[yyy][xxx]=0

				find_all_path()
				return
			end
		end
	else
		--竞速模式判断堵路
		find_all_path_race(player_id)
		--路完全堵死了，不能造
		for i=1,6 do
			if table.maxn(GameRules:GetGameModeEntity().gem_path_race[player_id][i])<1 then
				EmitGlobalSound("ui.crafting_gem_drop")
				--回退地图，重新寻路
				GameRules:GetGameModeEntity().gem_map[yyy][xxx]=0
				find_all_path_race(player_id)
				return
			end
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
	u:SetHullRadius(1)
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
	sync_player_gold(caster)

	--新版旋风方案
	--网格化坐标
	local x = math.floor((p.x+64)/128)+19
	local y = math.floor((p.y+64)/128)+19
	p.x = math.floor((p.x+64)/128)*128
	p.y = math.floor((p.y+64)/128)*128

	local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                              p,
                              nil,
                              192,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
	
	if table.getn(uuu) > 0 then
		local xuanfeng_index = {}
		for i,v in pairs(uuu) do
			if v:GetUnitName() ~= "gemtd_castle" and v:GetUnitName() ~= "gemtd_pet" and v:IsHero() == false and (not string.find(v:GetUnitName(), "shiban")) then

				if GetMapName() == 'gemtd_race' and player_id ~= v:GetOwner():GetPlayerID() then
					--不允许换别人的
					return
				end

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

			else
				Timers:CreateTimer(0.3,function()
					uu:SetAbsOrigin(xuanfeng_positions[1])
				end)
			end
		end)

	end
end
function SwapUnitPosition(u1,u2)
	local p1 = u1:GetAbsOrigin()
	local p2 = u2:GetAbsOrigin()
	u1:SetAbsOrigin(Vector(5000,5000,0))
	u2:SetAbsOrigin(p1)
	u1:SetAbsOrigin(p2)
end
--背水一战
function  gemtd_hero_beishuiyizhan( keys )
	local caster = keys.caster
	local target = keys.target
	local level = caster:FindAbilityByName("gemtd_hero_beishuiyizhan"):GetLevel()
	local beishui_level = (100-GameRules:GetGameModeEntity().gem_castle_hp)/20+1
	if GetMapName() == 'gemtd_race' then
		beishui_level = (100-GameRules:GetGameModeEntity().gem_castle_hp_race[caster:GetPlayerID()])/20+1
	end

	sync_player_gold(caster)

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
--光柱道标
function guangzhudaobiao(keys)
	local caster = keys.caster
	local level = caster:FindAbilityByName("gemtd_hero_guangzhudaobiao"):GetLevel()
	local p = keys.target_points[1]

	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()
	--同步玩家金钱
	sync_player_gold(caster)

	--网格化坐标
	local xxx = math.floor((p.x+64)/128)+19
	local yyy = math.floor((p.y+64)/128)+19
	p.x = math.floor((p.x+64)/128)*128
	p.y = math.floor((p.y+64)/128)*128

	--path1和path7附近 不能造
	if GetMapName() ~= "gemtd_race" then
		--path1和path7附近 不能造
		if xxx>=29 and yyy<=9 then
			EmitGlobalSound("ui.crafting_gem_drop")
			return
		end

		if xxx<=9 and yyy>=29 then
			EmitGlobalSound("ui.crafting_gem_drop")
			return
		end
	end
	if GetMapName() == "gemtd_race" and check_area(player_id,p) == false then
		EmitGlobalSound("ui.crafting_gem_drop")
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
		return
	end

	
	--路径点，不能造
	if GetMapName() ~= "gemtd_race" then
		for i=1,7 do
			local p1 = Entities:FindByName(nil,"path"..i):GetAbsOrigin()
			local xxx1 = math.floor((p1.x+64)/128)+19
			local yyy1 = math.floor((p1.y+64)/128)+19
			if xxx==xxx1 and yyy==yyy1 then
				EmitGlobalSound("ui.crafting_gem_drop")
				return
			end
		end
	end
	if GetMapName() == "gemtd_race" then
		for j=0,3 do
			for i=1,7 do
				local p1 = Entities:FindByName(nil,"path"..((10*j)+i)):GetAbsOrigin()
				local xxx1 = math.floor((p1.x+64)/128)+19
				local yyy1 = math.floor((p1.y+64)/128)+19
				if xxx==xxx1 and yyy==yyy1 then
					EmitGlobalSound("ui.crafting_gem_drop")
					return
				end
			end
		end
	end
		

	--地图范围外，不能造
	if xxx<1 or xxx>37 or yyy<1 or yyy>37 then
		EmitGlobalSound("ui.crafting_gem_drop")
		return
	end
	if GetMapName() ~= "gemtd_race" then
		if GameRules:GetGameModeEntity().guangzhudaobiao ~= nil then
			GameRules:GetGameModeEntity().guangzhudaobiao:ForceKill(false)
			GameRules:GetGameModeEntity().guangzhudaobiao:Destroy()
			GameRules:GetGameModeEntity().guangzhudaobiao = nil
		end
	else
		if GameRules:GetGameModeEntity().guangzhudaobiao_race[player_id] ~= nil then
			if GameRules:GetGameModeEntity().guangzhudaobiao_race[player_id]:IsNull() ~= false then
				GameRules:GetGameModeEntity().guangzhudaobiao_race[player_id]:ForceKill(false)
				GameRules:GetGameModeEntity().guangzhudaobiao_race[player_id]:Destroy()
			end
			GameRules:GetGameModeEntity().guangzhudaobiao_race[player_id] = nil
		end
	end

	--创建道标
	u = CreateUnitByName("gemtd_guangzhudaobiao", p,false,nil,nil,DOTA_TEAM_GOODGUYS)
	u.ftd = 2009
    --u = AMHC:CreateUnit( create_stone_name,p,270,caster,caster:GetTeamNumber())
	u:SetOwner(caster)
	--u:SetParent(caster,caster:GetUnitName())
	u:SetControllableByPlayer(player_id, true)
	u:SetForwardVector(Vector(0,-1,0))
	if GetMapName() ~= "gemtd_race" then
		GameRules:GetGameModeEntity().guangzhudaobiao = u
		--尝试寻找路径
		find_all_path()
		--路完全堵死了，不能造
		for i=1,7 do
			if table.maxn(GameRules:GetGameModeEntity().gem_path[i])<1 then
				EmitGlobalSound("ui.crafting_gem_drop")
				
				--回退地图，重新寻路
				GameRules:GetGameModeEntity().guangzhudaobiao:ForceKill(false)
				GameRules:GetGameModeEntity().guangzhudaobiao:Destroy()
				GameRules:GetGameModeEntity().guangzhudaobiao = nil

				find_all_path()
				return
			end
		end
	else
		GameRules:GetGameModeEntity().guangzhudaobiao_race[player_id] = u
		--尝试寻找路径
		find_all_path_race(player_id)
		--路完全堵死了，不能造
		for i=1,7 do
			if table.maxn(GameRules:GetGameModeEntity().gem_path_race[player_id][i])<1 then
				EmitGlobalSound("ui.crafting_gem_drop")
				--回退地图，重新寻路
				GameRules:GetGameModeEntity().guangzhudaobiao_race[player_id]:ForceKill(false)
				GameRules:GetGameModeEntity().guangzhudaobiao_race[player_id]:Destroy()
				GameRules:GetGameModeEntity().guangzhudaobiao_race[player_id] = nil

				find_all_path_race(player_id)
				return
			end
		end
	end
end

--合成塔
function merge_tower( tower_name, caster )
	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()


	if GetMapName() == 'gemtd_1p' or GetMapName() == 'gemtd_coop' then
		--合作模式
		if GameRules:GetGameModeEntity().game_status ~= 2 then
			return
		end

		--辅助table，用来缩小can merge的范围
		local merge_helper = {};
		local total_level = 0

		--优先标记caster
		caster.merge_mark = 1
		merge_helper[caster:GetUnitName()] = 1

		--遍历第一遍，标记要合并的石头
		for i,i_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool_can_merge[tower_name]) do
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
		for i,i_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool_can_merge[tower_name]) do
			if i_unit ~= caster and i_unit.merge_mark == 1 then
				local p = i_unit:GetAbsOrigin()

				--从宝石池删除
				local delete_index = nil
				for j,j_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool) do
					if j_unit:entindex() == i_unit:entindex() then
						table.remove(GameRules:GetGameModeEntity().gemtd_pool, j)
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
				u:SetHullRadius(1)
			end
		end

		--替换caster
		local p = caster:GetAbsOrigin()

		for j,j_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool) do
			if j_unit:entindex() == caster:entindex() then
				table.remove(GameRules:GetGameModeEntity().gemtd_pool, j)
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

		--发弹幕
		CustomNetTables:SetTableValue( "game_state", "bullet", {player_id = player_id, text = tower_name, hehe = RandomInt(1,100000)})

		if tower_name == "gemtd_huguoshenyishi" then
			local random_attack = RandomInt(30,1024)
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

		play_merge_particle(u)

		--天然祖母绿，获取技能
		if tower_name == "gemtd_tianranzumulv" then
			local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
		                              u:GetAbsOrigin(),
		                              nil,
		                              220,
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
					for uuuu,vvvv in pairs(GameRules:GetGameModeEntity().stealable_ability_pool) do
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

		--合并等级！
		if total_level > 0 then 
			level_up(u,total_level)
		end
		
		u:RemoveModifierByName("modifier_invulnerable")
		u:SetHullRadius(1)

		table.insert(GameRules:GetGameModeEntity().gemtd_pool, u)
		table.insert(GameRules:GetGameModeEntity().gemtd_pool_race[player_id], u)

		GameRules:GetGameModeEntity().gemtd_pool_can_merge[tower_name] = {}
		send_merge_board(player_id)

		--先清空合成技能
		for i,j in pairs(GameRules:GetGameModeEntity().gemtd_pool_can_merge_all) do
			for k,i_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool_can_merge[j]) do
				if ( not i_unit:IsNull()) and ( i_unit:IsAlive()) then
					i_unit:RemoveAbility(j)
				end
				
			end
		end
		GameRules:GetGameModeEntity().gemtd_pool_can_merge_all = {}

		--检查能否合成高级塔
		for h,h_merge in pairs(GameRules:GetGameModeEntity().gemtd_merge) do
			local can_merge = true
			local merge_pool = {}

			for k,k_unitname in pairs(h_merge) do
				local have_merge = false
				for c,c_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool) do
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
				GameRules:GetGameModeEntity().gemtd_pool_can_merge[h] = {}

				for a,a_unit in pairs(merge_pool) do
					a_unit:RemoveAbility(h)
					a_unit:AddAbility(h)
					a_unit:FindAbilityByName(h):SetLevel(1)
					play_particle("effect/merge/ui/plus/ui_hero_level_4_icon_ambient.vpcf",PATTACH_OVERHEAD_FOLLOW,a_unit,10)

					table.insert (GameRules:GetGameModeEntity().gemtd_pool_can_merge[h], a_unit) 

					table.insert (GameRules:GetGameModeEntity().gemtd_pool_can_merge_all, h ) 
				end
			end
		end
	elseif GetMapName() == 'gemtd_race' then
		--竞速模式
		--辅助table，用来缩小can merge的范围
		local merge_helper = {};
		local total_level = 0

		--优先标记caster
		caster.merge_mark = 1
		merge_helper[caster:GetUnitName()] = 1

		--遍历第一遍，标记要合并的石头
		for i,i_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool_can_merge_race[player_id][tower_name]) do
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
		for i,i_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool_can_merge_race[player_id][tower_name]) do
			if i_unit ~= caster and i_unit.merge_mark == 1 then
				local p = i_unit:GetAbsOrigin()

				--从宝石池删除
				local delete_index = nil
				for j,j_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool_race[player_id]) do
					if j_unit:entindex() == i_unit:entindex() then
						table.remove(GameRules:GetGameModeEntity().gemtd_pool_race[player_id], j)
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
				u:SetHullRadius(1)
			end
		end

		--替换caster
		local p = caster:GetAbsOrigin()

		for j,j_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool_race[player_id]) do
			if j_unit:entindex() == caster:entindex() then
				table.remove(GameRules:GetGameModeEntity().gemtd_pool_race[player_id], j)
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

		--发弹幕
		CustomNetTables:SetTableValue( "game_state", "bullet", {player_id = player_id, text = tower_name, hehe = RandomInt(1,100000)})

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

		play_merge_particle(u)

		--天然祖母绿，获取技能
		if tower_name == "gemtd_tianranzumulv" then
			local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
		                              u:GetAbsOrigin(),
		                              nil,
		                              220,
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
					for uuuu,vvvv in pairs(GameRules:GetGameModeEntity().stealable_ability_pool) do
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

		--合并等级！
		if total_level > 0 then 
			level_up(u,total_level)
		end
		
		u:RemoveModifierByName("modifier_invulnerable")
		u:SetHullRadius(1)

		table.insert(GameRules:GetGameModeEntity().gemtd_pool, u)
		table.insert(GameRules:GetGameModeEntity().gemtd_pool_race[player_id], u)

		GameRules:GetGameModeEntity().gemtd_pool_can_merge_race[player_id][tower_name] = {}
		send_merge_board(player_id)

		--先清空合成技能
		for i,j in pairs(GameRules:GetGameModeEntity().gemtd_pool_can_merge_all_race[player_id]) do
			for k,i_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool_can_merge_race[player_id][j]) do
				if ( not i_unit:IsNull()) and ( i_unit:IsAlive()) then
					i_unit:RemoveAbility(j)
				end
				
			end
		end
		GameRules:GetGameModeEntity().gemtd_pool_can_merge_all_race[player_id] = {}

		--检查能否合成高级塔
		for h,h_merge in pairs(GameRules:GetGameModeEntity().gemtd_merge) do
			----GameRules:SendCustomMessage(h, 0, 0)
			local can_merge = true
			local merge_pool = {}

			for k,k_unitname in pairs(h_merge) do
				local have_merge = false
				for c,c_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool_race[player_id]) do
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
				GameRules:GetGameModeEntity().gemtd_pool_can_merge_race[player_id][h] = {}

				for a,a_unit in pairs(merge_pool) do
					a_unit:RemoveAbility(h)
					a_unit:AddAbility(h)
					a_unit:FindAbilityByName(h):SetLevel(1)
					play_particle("effect/merge/ui/plus/ui_hero_level_4_icon_ambient.vpcf",PATTACH_OVERHEAD_FOLLOW,a_unit,10)
					--GameRules:SendCustomMessage("可以合成"..h, 0, 0)

					table.insert (GameRules:GetGameModeEntity().gemtd_pool_can_merge_race[player_id][h], a_unit) 

					table.insert (GameRules:GetGameModeEntity().gemtd_pool_can_merge_all_race[player_id], h ) 
				end
			end
		end
	end
end
function merge_tower1( tower_name, caster )

	local owner =  caster:GetOwner()
	local player_id = owner:GetPlayerID()

	--GameRules:SendCustomMessage("选择了石头", 0, 0)
	caster:RemoveAbility(tower_name.."1")

	for i=0,4 do
		if GameRules:GetGameModeEntity().build_curr[player_id][i]~=caster then
			--移除其他的石头
			local p = GameRules:GetGameModeEntity().build_curr[player_id][i]:GetAbsOrigin()
			--删除玩家颜色底盘
			if GameRules:GetGameModeEntity().build_curr[player_id][i].ppp then
				ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().build_curr[player_id][i].ppp,true)
			end
			GameRules:GetGameModeEntity().build_curr[player_id][i]:Destroy()
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
			u:SetHullRadius(1)
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

	--发弹幕
	CustomNetTables:SetTableValue( "game_state", "bullet", {player_id = player_id, text = unit_name, hehe = RandomInt(1,100000)})

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
	play_merge_particle(u)
	EmitGlobalSound("Loot_Drop_Stinger_Mythical")
	
	--添加玩家颜色底盘
	local particle = ParticleManager:CreateParticle("particles/gem/team_0.vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
	u.ppp = particle
	
	u:RemoveModifierByName("modifier_invulnerable")
	u:SetHullRadius(1)

	table.insert (GameRules:GetGameModeEntity().gemtd_pool, u)
	table.insert (GameRules:GetGameModeEntity().gemtd_pool_race[player_id], u)
	--AMHC:CreateNumberEffect(u,1,2,AMHC.MSG_DAMAGE,"yellow",0)


	GameRules:GetGameModeEntity().build_curr[player_id] = {}
	GameRules:GetGameModeEntity().is_build_ready[player_id] = true
	send_merge_board(player_id)

	finish_build(player_id)	
end
function gemtd_baiyin( keys )
	local caster = keys.caster
	merge_tower( "gemtd_baiyin", caster )

	GameRules:GetGameModeEntity().quest_status["q101"] = false
	show_quest()
end
function gemtd_baiyinqishi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_baiyinqishi", caster )
end
function gemtd_kongqueshi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_kongqueshi", caster )

	GameRules:GetGameModeEntity().quest_status["q102"] = false
	show_quest()
end
function gemtd_xianyandekongqueshi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_xianyandekongqueshi", caster )
end
function gemtd_xingcaihongbaoshi( keys )
	local caster = keys.caster
	merge_tower( "gemtd_xingcaihongbaoshi", caster )

	GameRules:GetGameModeEntity().quest_status["q103"] = false
	show_quest()
end
function gemtd_xuehonghuoshan( keys )
	local caster = keys.caster
	merge_tower( "gemtd_xuehonghuoshan", caster )
end
function gemtd_yu( keys )
	local caster = keys.caster
	merge_tower( "gemtd_yu", caster )

	GameRules:GetGameModeEntity().quest_status["q201"] = false
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

	GameRules:GetGameModeEntity().quest_status["q301"] = false
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

function gemtd_baiyin1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_baiyin", caster )

	GameRules:GetGameModeEntity().quest_status["q101"] = false
	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_baiyinqishi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_baiyinqishi", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_kongqueshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_kongqueshi", caster )

	GameRules:GetGameModeEntity().quest_status["q102"] = false
	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_xianyandekongqueshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_xianyandekongqueshi", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_xingcaihongbaoshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_xingcaihongbaoshi", caster )

	GameRules:GetGameModeEntity().quest_status["q103"] = false
	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_xuehonghuoshan1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_xuehonghuoshan", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_yu1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_yu", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	GameRules:GetGameModeEntity().quest_status["q201"] = false
	show_quest()
end
function gemtd_jixiangdezhongguoyu1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_jixiangdezhongguoyu", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_furongshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_furongshi", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_mirendeqingjinshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_mirendeqingjinshi", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_heianfeicui1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_heianfeicui", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_feicuimoxiang1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_feicuimoxiang", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_huangcailanbaoshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_huangcailanbaoshi", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_palayibabixi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_palayibabixi", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_heisemaoyanshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_heisemaoyanshi", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_hongshanhu1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_hongshanhu", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_jin1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_jin", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_aijijin1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_aijijin", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_shenhaizhenzhu1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_shenhaizhenzhu", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	GameRules:GetGameModeEntity().quest_status["q301"] = false
	show_quest()
end
function gemtd_haiyangqingyu1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_haiyangqingyu", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_fenhongzuanshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_fenhongzuanshi", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_jixueshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_jixueshi", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_gudaidejixueshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_gudaidejixueshi", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_you2381( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_you238", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_you2351( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_you235", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_juxingfenhongzuanshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_juxingfenhongzuanshi", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_jingxindiaozhuodepalayibabixi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_jingxindiaozhuodepalayibabixi", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_huaguoshanxiandan1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_huaguoshanxiandan", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_tianranzumulv1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_tianranzumulv", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_keyinuoerguangmingzhishan1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_keyinuoerguangmingzhishan", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_shuaibiankaipayou1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_shuaibiankaipayou", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_heiwangzihuangguanhongbaoshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_heiwangzihuangguanhongbaoshi", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	show_quest()
end
function gemtd_xingguanglanbaoshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_xingguanglanbaoshi", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
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

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	GameRules:GetGameModeEntity().quest_status["q108"] = true
	show_quest()
end
function gemtd_huguoshenyishi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_huguoshenyishi", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	GameRules:GetGameModeEntity().quest_status["q108"] = true
	show_quest()
end
function gemtd_jingangshikulinan1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_jingangshikulinan", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	GameRules:GetGameModeEntity().quest_status["q108"] = true
	show_quest()
end
function gemtd_sililankazhixing1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_sililankazhixing", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	GameRules:GetGameModeEntity().quest_status["q108"] = true
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

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	GameRules:GetGameModeEntity().quest_status["q108"] = true
	show_quest()
end
function gemtd_heiyaoshi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_heiyaoshi", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	GameRules:GetGameModeEntity().quest_status["q108"] = true
	show_quest()
end
function gemtd_manao1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_manao", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	GameRules:GetGameModeEntity().quest_status["q108"] = true
	show_quest()
end
function gemtd_ranshaozhishi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_ranshaozhishi", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	GameRules:GetGameModeEntity().quest_status["q108"] = true
	show_quest()
end
function gemtd_xiameishi1( keys )
	local caster = keys.caster
	merge_tower1( "gemtd_xiameishi", caster )

	GameRules:GetGameModeEntity().quest_status["q106"] = false
	GameRules:GetGameModeEntity().quest_status["q108"] = true
	show_quest()
end
--石板
function gemtd_youbushiban_sb( keys )
	local caster = keys.caster
	merge_shiban( "gemtd_youbushiban", GameRules:GetGameModeEntity().shiban_ability_list["gemtd_youbushiban"], 10, caster )
end
function gemtd_zhangqishiban_sb( keys )
	local caster = keys.caster
	merge_shiban( "gemtd_zhangqishiban", GameRules:GetGameModeEntity().shiban_ability_list["gemtd_zhangqishiban"], 10, caster )
end
function gemtd_hongliushiban_sb( keys )
	local caster = keys.caster
	merge_shiban( "gemtd_hongliushiban", GameRules:GetGameModeEntity().shiban_ability_list["gemtd_hongliushiban"], 10, caster )
end
function gemtd_haojiaoshiban_sb( keys )
	local caster = keys.caster
	merge_shiban( "gemtd_haojiaoshiban", GameRules:GetGameModeEntity().shiban_ability_list["gemtd_haojiaoshiban"], 10, caster )
end
function gemtd_suanwushiban_sb( keys )
	local caster = keys.caster
	merge_shiban( "gemtd_suanwushiban", GameRules:GetGameModeEntity().shiban_ability_list["gemtd_suanwushiban"], 10, caster )
end
function gemtd_mabishiban_sb( keys )
	local caster = keys.caster
	merge_shiban( "gemtd_mabishiban", GameRules:GetGameModeEntity().shiban_ability_list["gemtd_mabishiban"], 10, caster )
end
function gemtd_kongheshiban_sb( keys )
	local caster = keys.caster
	merge_shiban( "gemtd_kongheshiban", GameRules:GetGameModeEntity().shiban_ability_list["gemtd_kongheshiban"], 10, caster )
end
function gemtd_xuwushiban_sb( keys )
	local caster = keys.caster
	merge_shiban( "gemtd_xuwushiban", GameRules:GetGameModeEntity().shiban_ability_list["gemtd_xuwushiban"], 10, caster )
end
function Youbu2(keys)
	local target = keys.target
	local caster = keys.caster
	local target_count = 4
	if (target==nil or target:IsNull()==true or target:IsAlive()==false) then
		return
	end
	local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
			target:GetAbsOrigin(),
			nil,
			512,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_ANY_ORDER,
			false)
	if table.maxn(uuu) > 0 then
		local unluckydog_count = table.maxn(uuu)
		if unluckydog_count > target_count then unluckydog_count = target_count end
		for i=1,unluckydog_count do
			local unluckydog = uuu[i]
			--对unluckydog施暴
			Timers:CreateTimer(RandomInt(1,50)/100,function()
				InvisibleUnitCast({
					caster = caster,
					ability = 'naga_siren_ensnare',
					level = caster:FindAbilityByName('new_youbu2'):GetLevel(),
					unluckydog = unluckydog,
					position = unluckydog:GetAbsOrigin(),
				})
			end)
			
		end
	end
end
function Youbu3(keys)
	local target = keys.target
	local caster = keys.caster
	local target_count = 20
	if (target==nil or target:IsNull()==true or target:IsAlive()==false) then
		return
	end
	local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
			target:GetAbsOrigin(),
			nil,
			1024,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_ANY_ORDER,
			false)
	if table.maxn(uuu) > 0 then
		local unluckydog_count = table.maxn(uuu)
		if unluckydog_count > target_count then unluckydog_count = target_count end
		for i=1,unluckydog_count do
			local unluckydog = uuu[i]
			--对unluckydog施暴
			Timers:CreateTimer(RandomInt(1,50)/100,function()
				InvisibleUnitCast({
					caster = caster,
					ability = 'naga_siren_ensnare',
					level = caster:FindAbilityByName('new_youbu3'):GetLevel(),
					unluckydog = unluckydog,
					position = unluckydog:GetAbsOrigin(),
				})
			end)
			
		end
	end
end
function Cask2(keys)
	local target = keys.target
	local caster = keys.caster
	local target_count = 3
	if (target==nil or target:IsNull()==true or target:IsAlive()==false) then
		return
	end
	local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
			target:GetAbsOrigin(),
			nil,
			512,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_ANY_ORDER,
			false)
	if table.maxn(uuu) > 0 then
		local unluckydog_count = table.maxn(uuu)
		if unluckydog_count > target_count then unluckydog_count = target_count end
		for i=1,unluckydog_count do
			local unluckydog = uuu[i]
			--对unluckydog施暴
			Timers:CreateTimer(RandomInt(1,50)/100,function()
				InvisibleUnitCast({
					caster = caster,
					ability = 'new_cask_sub2',
					level = caster:FindAbilityByName('new_cask2'):GetLevel(),
					unluckydog = unluckydog,
					position = unluckydog:GetAbsOrigin(),
				})
			end)
			
		end
	end
end
function Cask3(keys)
	local target = keys.target
	local caster = keys.caster
	local target_count = 9
	if (target==nil or target:IsNull()==true or target:IsAlive()==false) then
		return
	end
	local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
			target:GetAbsOrigin(),
			nil,
			1024,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_ANY_ORDER,
			false)
	if table.maxn(uuu) > 0 then
		local unluckydog_count = table.maxn(uuu)
		if unluckydog_count > target_count then unluckydog_count = target_count end
		for i=1,unluckydog_count do
			local unluckydog = uuu[i]
			--对unluckydog施暴
			Timers:CreateTimer(RandomInt(1,50)/100,function()
				InvisibleUnitCast({
					caster = caster,
					ability = 'new_cask_sub3',
					level = caster:FindAbilityByName('new_cask3'):GetLevel(),
					unluckydog = unluckydog,
					position = unluckydog:GetAbsOrigin(),
				})
			end)
			
		end
	end
end
--开启石板的计时器
function start_shiban_timer(shiban,shiban_ability,shiban_cd)

	Timers:CreateTimer(0.1,function()

		if (shiban==nil or shiban:IsNull()==true or shiban:IsAlive()==false) then
			return
		end
		
		local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
				shiban:GetAbsOrigin(),
				nil,
				128,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				FIND_ANY_ORDER,
				false)
		if table.maxn(uuu) > 0 then
			local unluckydog = uuu[1]
			--对unluckydog施暴

			local a_level = 5-PlayerResource:GetPlayerCount()
			if GetMapName() == 'gemtd_race' then
				a_level = 4
			end

			InvisibleUnitCast({
				caster = shiban,
				ability = shiban_ability,
				level = a_level,
				unluckydog = unluckydog,
				position = unluckydog:GetAbsOrigin(),
			})

			TriggerShiban(unluckydog)

			return shiban_cd
		else
			return 0.1
		end
	end)
end
--石板自动合成
function merge_shiban_update(xxx,yyy)
	local x1 = xxx-1
	local x2 = xxx+1
	local y1 = yyy-1
	local y2 = yyy+1
	if x1 < 1 then x1 = 1 end
	if y1 < 1 then y1 = 1 end
	if x2 > 37 then x2 = 37 end
	if y2 > 37 then y2 = 37 end

	for i=x1,x2 do
		for j=y1,y2 do
			local curr_shiban = GameRules:GetGameModeEntity().shiban_index[i..'_'..j]
			if curr_shiban ~= nil then
				shiban_update_one(curr_shiban,i,j)
			end
		end
	end
end
function shiban_update_one(shiban,i,j)
	local loop_table = {
		[1] = { x = 1, y = 1},
		[2] = { x = 1, y = 0},
		[3] = { x = 0, y = 1},
		[4] = { x = -1, y = 1},
	}
	local shiban_name = shiban:GetUnitName()
	local p = shiban:GetAbsOrigin()
	local owner = shiban:GetOwner()
	local player_id = shiban:GetOwner():GetPlayerID()

	for u,v in pairs(loop_table) do
		local u1 = GameRules:GetGameModeEntity().shiban_index[(i+v.x)..'_'..(j+v.y)]
		local u2 = GameRules:GetGameModeEntity().shiban_index[(i-v.x)..'_'..(j-v.y)]
		if u1~=nil and u2~=nil and u1:GetUnitName() ==shiban_name and u2:GetUnitName() ==shiban_name then
			--合成
			local shengji_shiban = GameRules:GetGameModeEntity().gemtd_merge_shiban_update[shiban_name]
			if shengji_shiban ~= nil then
				--移除三个石板
				GameRules:GetGameModeEntity().shiban_index[(i+v.x)..'_'..(j+v.y)] = nil
				GameRules:GetGameModeEntity().shiban_index[(i-v.x)..'_'..(j-v.y)] = nil
				if GetMapName() ~= "gemtd_race" then
					for jj,j_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool) do
						if j_unit:entindex() == shiban:entindex() then
							table.remove(GameRules:GetGameModeEntity().gemtd_pool, jj)
						end
					end
					for jj,j_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool) do
						if j_unit:entindex() == u1:entindex() then
							table.remove(GameRules:GetGameModeEntity().gemtd_pool, jj)
						end
					end
					for jj,j_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool) do
						if j_unit:entindex() == u2:entindex() then
							table.remove(GameRules:GetGameModeEntity().gemtd_pool, jj)
						end
					end
				else
					for jj,j_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool_race[player_id]) do
						if j_unit:entindex() == shiban:entindex() then
							table.remove(GameRules:GetGameModeEntity().gemtd_pool_race[player_id], jj)
						end
					end
					for jj,j_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool_race[player_id]) do
						if j_unit:entindex() == u1:entindex() then
							table.remove(GameRules:GetGameModeEntity().gemtd_pool_race[player_id], jj)
						end
					end
					for jj,j_unit in pairs(GameRules:GetGameModeEntity().gemtd_pool_race[player_id]) do
						if j_unit:entindex() == u2:entindex() then
							table.remove(GameRules:GetGameModeEntity().gemtd_pool_race[player_id], jj)
						end
					end
				end
				
				shiban:Destroy()
				u1:Destroy()
				u2:Destroy()

				--造高级石板
				local u = CreateUnitByName(shengji_shiban, p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
				u.ftd = 2009
				GameRules:GetGameModeEntity().shiban_index[i..'_'..j] = u

				--发弹幕
				CustomNetTables:SetTableValue( "game_state", "bullet", {player_id = player_id, text = shengji_shiban, hehe = RandomInt(1,100000)})

				u:SetOwner(owner)
				u:SetControllableByPlayer(player_id, true)

				u:AddAbility("no_hp_bar")
				u:FindAbilityByName("no_hp_bar"):SetLevel(1)
				u:RemoveModifierByName("modifier_invulnerable")
				u:SetHullRadius(1)

				table.insert(GameRules:GetGameModeEntity().gemtd_pool, u)
				table.insert(GameRules:GetGameModeEntity().gemtd_pool_race[player_id], u)

				u:SetForwardVector(Vector(1,0,0))

				u.is_merged = true
				u.kill_count = 0

				play_merge_particle(u)
				EmitGlobalSound("Loot_Drop_Stinger_Rare")

				--检测能否合成高级石板
				Timers:CreateTimer(1,function()
					merge_shiban_update(i,j)
				end)

				--开高级石板的计时器
				start_shiban_timer(u,GameRules:GetGameModeEntity().shiban_ability_list[shengji_shiban],10)
			end
		end
	end
end
function TriggerShiban(dog)
	if RandomInt(1,100) >= 25 then
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
--塔的技能
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

--搞破坏
function ItemJingYing(keys)
	local caster = keys.caster
	local player_id = caster:GetPlayerID()
	local p = keys.target_entities[1]:GetAbsOrigin()
	--发弹幕
	CustomNetTables:SetTableValue( "game_state", "bullet", {player_id = player_id, text = 'item_jingying', hehe = RandomInt(1,100000)})

	--随机一个还活着的unluckydog玩家
	local unluckydog = nil
	local try_times = 0
	while unluckydog == nil and try_times < 50 do
		local r = RandomInt(0,PlayerResource:GetPlayerCount()-1)
		if GameRules:GetGameModeEntity().gem_castle_hp_race[r] > 0 and r ~= player_id then
			unluckydog = r
			break
		end
		try_times = try_times + 1
	end

	if unluckydog ~= nil then
		local hero = PlayerResource:GetPlayer(unluckydog):GetAssignedHero()
		
		local info =
	    {
	        Target = hero,
	        Source = caster,
	        Ability = nil,
	        EffectName = "particles/econ/items/necrolyte/necrophos_sullen/necro_sullen_pulse_enemy.vpcf",
	        bDodgeable = false,
	        iMoveSpeed = 1000,
	        bProvidesVision = false,
	        iVisionRadius = 0,
	        iVisionTeamNumber = caster:GetTeamNumber(),
	        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	    }
	    projectile = ProjectileManager:CreateTrackingProjectile(info)

	    local delay_time = (hero:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() / 1000
		Timers:CreateTimer(delay_time,function()
			if hero.jingying_zuzhou == nil then
				hero.jingying_zuzhou = 1
			else
				hero.jingying_zuzhou = hero.jingying_zuzhou + 1
			end
		end)
	end
end

function ItemHuichun(keys)
	local caster = keys.caster
	local player_id = caster:GetPlayerID()
	local p = keys.target_entities[1]:GetAbsOrigin()
	--发弹幕
	CustomNetTables:SetTableValue( "game_state", "bullet", {player_id = player_id, text = 'item_huichun', hehe = RandomInt(1,100000)})

	for r=0,PlayerResource:GetPlayerCount()-1 do
		if GameRules:GetGameModeEntity().gem_castle_hp_race[r] > 0 then
			local hero = PlayerResource:GetPlayer(r):GetAssignedHero()
			local hp_count = RandomInt(-4,10)
			EmitSoundOn("DOTAMusic_Stinger.004",hero)

			if hp_count<=0 then
				hp_count = hp_count - 1
			end

			GameRules:GetGameModeEntity().gem_castle_hp_race[r] = GameRules:GetGameModeEntity().gem_castle_hp_race[r] + hp_count
		    if GameRules:GetGameModeEntity().gem_castle_hp_race[r] > 100 then
		        GameRules:GetGameModeEntity().gem_castle_hp_race[r] = 100
		    end
		    if GameRules:GetGameModeEntity().gem_castle_hp_race[r] < 1 then
		        GameRules:GetGameModeEntity().gem_castle_hp_race[r] = 1
		    end
		    GameRules:GetGameModeEntity().gem_castle_race[r]:SetHealth(GameRules:GetGameModeEntity().gem_castle_hp_race[r])
		    Timers:CreateTimer(RandomFloat(0,2),function()
		    	CustomNetTables:SetTableValue( "game_state", "gem_life_race", { player = r, gem_life = GameRules:GetGameModeEntity().gem_castle_hp_race[r],hehe = RandomInt(1,10000) } )
		    end)

		    if hp_count<=0 then
				AMHC:CreateNumberEffect(hero,-hp_count,5,AMHC.MSG_DAMAGE,"red",3)
			else
				AMHC:CreateNumberEffect(hero,hp_count,5,AMHC.MSG_MISS,"green",0)
			end

		    hero:SetHealth(GameRules:GetGameModeEntity().gem_castle_hp_race[r])
		end
	end
end
function ItemFog(keys)
	local caster = keys.caster
	local player_id = caster:GetPlayerID()
	--发弹幕
	CustomNetTables:SetTableValue( "game_state", "bullet", {player_id = player_id, text = 'item_fog', hehe = RandomInt(1,100000)})

	if GameRules:GetGameModeEntity().top_runner ~= nil then
		InvisibleEnemyCastFog({player_id = GameRules:GetGameModeEntity().top_runner})
		for i=1,9 do
			Timers:CreateTimer(RandomInt(1,25),function()
				InvisibleEnemyCastFog({player_id = GameRules:GetGameModeEntity().top_runner})
			end)
		end
	end
end
function ItemAoJiao(keys)
	local caster = keys.caster
	local player_id = caster:GetPlayerID()
	--发弹幕
	CustomNetTables:SetTableValue( "game_state", "bullet", {player_id = player_id, text = 'item_aojiao', hehe = RandomInt(1,100000)})
	for i=0,PlayerResource:GetPlayerCount()-1 do
		if i ~= player_id then
			if GameRules:GetGameModeEntity().last_mvp[i] ~= nil then
				local unluckydog = EntIndexToHScript(GameRules:GetGameModeEntity().last_mvp[i])
				local info =
			    {
			        Target = unluckydog,
			        Source = caster,
			        Ability = nil,
			        EffectName = "effect/bottle/1_concoction_projectile.vpcf",
			        bDodgeable = false,
			        iMoveSpeed = 800,
			        bProvidesVision = false,
			        iVisionRadius = 0,
			        iVisionTeamNumber = caster:GetTeamNumber(),
			        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
			    }
			    projectile = ProjectileManager:CreateTrackingProjectile(info)

			    if unluckydog:FindAbilityByName('tower_aojiao') == nil then
			    	local delay_time = (unluckydog:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() / 800
					Timers:CreateTimer(delay_time,function()
						unluckydog:AddAbility('tower_aojiao')
				    	unluckydog:FindAbilityByName('tower_aojiao'):SetLevel(1)
				    	Timers:CreateTimer(120,function()
				    		unluckydog:RemoveAbility('tower_aojiao')
				    		unluckydog:RemoveModifierByName('modifier_tower_buaojiao')
				    	end)
					end)
				end
			end
		end
	end
end
function ItemFly(keys)
	local caster = keys.caster
	local player_id = caster:GetPlayerID()
	local p = keys.target_entities[1]:GetAbsOrigin()
	--发弹幕
	CustomNetTables:SetTableValue( "game_state", "bullet", {player_id = player_id, text = 'item_fly', hehe = RandomInt(1,100000)})

	if GameRules:GetGameModeEntity().top_runner ~= nil then
		local unluckydog = GameRules:GetGameModeEntity().top_runner

		local hero = PlayerResource:GetPlayer(unluckydog):GetAssignedHero()
		
		local info =
	    {
	        Target = hero,
	        Source = caster,
	        Ability = nil,
	        EffectName = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt.vpcf",
	        bDodgeable = false,
	        iMoveSpeed = 1000,
	        bProvidesVision = false,
	        iVisionRadius = 0,
	        iVisionTeamNumber = caster:GetTeamNumber(),
	        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	    }
	    projectile = ProjectileManager:CreateTrackingProjectile(info)

	    local delay_time = (hero:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() / 1000
	    Timers:CreateTimer(delay_time,function()
	    	if hero.fly_zuzhou == nil then
				hero.fly_zuzhou = 1
			else
				hero.fly_zuzhou = hero.fly_zuzhou + 1
			end
	    end)

	end
end

function play_merge_particle(u)
	local pp = ParticleManager:CreateParticle("particles/units/unit_greevil/loot_greevil_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, u)
	ParticleManager:SetParticleControl(pp, 0, u:GetAbsOrigin())
	ParticleManager:SetParticleControl(pp, 1, u:GetAbsOrigin())
	ParticleManager:SetParticleControl(pp, 3, u:GetAbsOrigin())
	Timers:CreateTimer(5,function()
		ParticleManager:DestroyParticle(pp,true)
	end)
end

function elite_hp()
	local beishu = GameRules:GetGameModeEntity().level
	if beishu > 50 then
		beishu = 50
	end

	return (51-beishu)/50*6 +2
end

function log(t)
	if GameRules:GetGameModeEntity().is_debug == true then
		GameRules:SendCustomMessage(t,0,0)
	end
end
function prt(t)
	GameRules:SendCustomMessage(t,0,0)
end