--回春
function huichun( keys )
    local caster = keys.caster
    GameRules:GetGameModeEntity().gem_castle_hp = GameRules:GetGameModeEntity().gem_castle_hp +1
    if GameRules:GetGameModeEntity().gem_castle_hp > 100 then
        GameRules:GetGameModeEntity().gem_castle_hp = 100
    end
    GameRules:GetGameModeEntity().gem_castle:SetHealth(GameRules:GetGameModeEntity().gem_castle_hp)

    CustomNetTables:SetTableValue( "game_state", "gem_life", { gem_life = GameRules:GetGameModeEntity().gem_castle_hp } );
    AMHC:CreateNumberEffect(caster,1,5,AMHC.MSG_MISS,"green",0)

    EmitGlobalSound("DOTAMusic_Stinger.004")

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
end


--贪婪
function tanlan( keys )
    local caster = keys.caster

    local exp_count = math.floor(RandomInt(1,50) /100 * GameRules.guai_live_count * GameRules.guai_live_count)

    local time_this_level = math.floor(GameRules:GetGameTime() - GameRules.stop_watch)
    if time_this_level>=300 then 
    	exp_count = math.floor(exp_count/10)
    end

	--给玩家团队金钱
	AMHC:CreateNumberEffect(caster,exp_count,5,AMHC.MSG_GOLD,"yellow",0)
	GameRules.team_gold = GameRules.team_gold + exp_count

	if exp_count >= 80 then
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