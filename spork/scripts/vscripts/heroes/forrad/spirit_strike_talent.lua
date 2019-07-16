LinkLuaModifier( "modifier_spirit_strike_attack", "heroes/forrad/modifier_spirit_strike_attack.lua", LUA_MODIFIER_MOTION_NONE )

spirit_strike_talent = class({})

function spirit_strike_talent:OnSpellStart()
	local caster = self:GetCaster()
	local damage = caster:GetAttackDamage()
	local target = self:GetCursorTarget()
	local calc = ( target:GetMaxHealth() - target:GetHealth() ) * ( self:GetSpecialValueFor("percent")/100 )

	local blinkDistance = 75
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

	-- Blink
	local oldPosition = caster:GetOrigin()
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )

	local ampMod = caster:AddNewModifier( caster, self, "modifier_spirit_strike_attack", {})
	caster:PerformAttack( target, false, true, true, false, false, false, true ) 
	ampMod:Destroy()

	local current = target:GetHealth()
	
	local damageTable = {
        victim = target,
        attacker = caster,
        damage = calc,
        damage_type = DAMAGE_TYPE_PURE
    }
	ApplyDamage(damageTable)

	self:PlayEffects( target, oldPosition, caster )

	if calc >= current then
		self:EndCooldown()
	end
end

function spirit_strike_talent:PlayEffects( target, point, caster )
	local particle_name = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_jinda_slow_tgt.vpcf"
	local particle_name2 = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_start_sparkles.vpcf"
	local particle_name3 = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_end_glow.vpcf"

	local effect = ParticleManager:CreateParticle( particle_name, PATTACH_ABSORIGIN_FOLLOW, target ) -- Crit Effect
	ParticleManager:SetParticleControlEnt(
		effect,
		0,
		target,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		false -- unknown, true
	)

	local effect2 = ParticleManager:CreateParticle( particle_name2, PATTACH_WORLDORIGIN, target ) -- Origin Blink Effect
	ParticleManager:SetParticleControl( effect2, 0, point )

	local effect3 = ParticleManager:CreateParticle( particle_name3, PATTACH_ABSORIGIN_FOLLOW, caster ) -- Arrived Blink Effect
	ParticleManager:SetParticleControlEnt(
		effect3,
		0,
		caster,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		caster:GetOrigin(), -- unknown
		false -- unknown, true
	)

	StartSoundEvent( "Hero_Riki.Blink_Strike", caster )
	StartSoundEvent( "Hero_PhantomAssassin.CoupDeGrace", target )
end