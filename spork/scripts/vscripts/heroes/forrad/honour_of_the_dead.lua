LinkLuaModifier("modifier_honour_of_the_dead_movement", "heroes/forrad/modifier_honour_of_the_dead_movement.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_honour_of_the_dead_buff", "heroes/forrad/modifier_honour_of_the_dead_buff.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_honour_of_the_dead_debuff", "heroes/forrad/modifier_honour_of_the_dead_debuff.lua", LUA_MODIFIER_MOTION_NONE)

honour_of_the_dead = class({})

function honour_of_the_dead:OnSpellStart()

	local units = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetCaster():GetAbsOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self:GetSpecialValueFor("radius"),	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local baseDamage = self:GetSpecialValueFor("damage")
	local heroes = 0
	for i=1, #units do

		local damageTable = {
        	victim = units[i],
        	attacker = self:GetCaster(),
        	damage = ( baseDamage * self:GetCaster():GetSpellAmplification(false) ) + baseDamage,
        	damage_type = DAMAGE_TYPE_MAGICAL
   		}
		ApplyDamage(damageTable)

		units[i]:AddNewModifier( self:GetCaster(), self, "modifier_honour_of_the_dead_movement", { duration = 0.69 } )
		units[i]:AddNewModifier( self:GetCaster(), self, "modifier_honour_of_the_dead_debuff", { duration = 15} )

		if units[i]:IsRealHero() then
			heroes = heroes + 1
		end
	end

	self:PlayEffects()

	if IsServer() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_honour_of_the_dead_buff", { duration = 15 } )
		self:GetCaster():FindModifierByName("modifier_honour_of_the_dead_buff"):SetStackCount( heroes )
	end

end

function honour_of_the_dead:PlayEffects()
	local particle_name = "particles/units/heroes/hero_dark_seer/dark_seer_vacuum.vpcf"
	local attach_type = PATTACH_WORLDORIGIN

	local effect = ParticleManager:CreateParticle( particle_name, attach_type, nil ) -- Ring
	ParticleManager:SetParticleControl( effect, 0, self:GetCaster():GetOrigin() )

	StartSoundEvent( "Hero_Dark_Seer.Vacuum", self:GetCaster() )
end