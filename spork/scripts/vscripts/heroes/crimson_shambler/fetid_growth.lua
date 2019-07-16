LinkLuaModifier("modifier_fetid_growth_buff", "heroes/crimson_shambler/modifier_fetid_growth_buff.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mycosis_passive", "heroes/crimson_shambler/modifier_mycosis_passive.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fetid_growth_debuff", "heroes/crimson_shambler/modifier_fetid_growth_debuff.lua", LUA_MODIFIER_MOTION_NONE)

fetid_growth = class({})

function fetid_growth:OnSpellStart()

	local units = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetCaster():GetAbsOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self:GetSpecialValueFor("radius"),	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local heroes = 0
	for i=1, #units do
		if units[i]:GetTeam() == self:GetCaster():GetTeam() and units[i]:IsHero() then -- Allied heroes
			units[i]:AddNewModifier( self:GetCaster(), self, "modifier_fetid_growth_buff", { duration = self:GetSpecialValueFor("duration") } )

			local talent = self:GetCaster():FindAbilityByName("crimson_shambler_talent_r")
    		if talent and talent:GetLevel() > 0 then
    			local source = self:GetCaster():FindAbilityByName("mycosis")
    			if source == nil or units[i]:HasModifier("modifier_mycosis_passive") then return end

				units[i]:AddNewModifier( self:GetCaster(), source, "modifier_mycosis_passive", { duration = source:GetSpecialValueFor("duration") } )
    		end

		elseif units[i]:GetTeam() ~= self:GetCaster():GetTeam() and not units[i]:IsMagicImmune() then -- Enemy units
			units[i]:AddNewModifier( self:GetCaster(), self, "modifier_fetid_growth_debuff", { duration = self:GetSpecialValueFor("duration") } )

		end
	end

	self:PlayEffects()
end

function fetid_growth:PlayEffects()
	local particle_name = "particles/units/heroes/hero_treant/treant_overgrowth_cast.vpcf"
	local particle_name2 = "particles/crimson_shambler/fetid_growth_ring.vpcf"
	local attach_type = PATTACH_ABSORIGIN

	ParticleManager:CreateParticle( particle_name, attach_type, self:GetCaster() ) -- Overgrowth

	local effect = ParticleManager:CreateParticle( particle_name2, PATTACH_WORLDORIGIN, nil ) -- Ring
	ParticleManager:SetParticleControl( effect, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect, 1, Vector( self:GetSpecialValueFor("radius"), 0, 0 ) )

	StartSoundEvent( "Hero_Treant.Eyes.Cast", self:GetCaster() )
end