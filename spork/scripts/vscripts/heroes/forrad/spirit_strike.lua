LinkLuaModifier( "spirit_strike_think", "heroes/forrad/spirit_strike_think.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spirit_strike_attack", "heroes/forrad/modifier_spirit_strike_attack.lua", LUA_MODIFIER_MOTION_NONE )

spirit_strike = class({})

function spirit_strike:GetIntrinsicModifierName()
	return "spirit_strike_think"
end

function spirit_strike:OnSpellStart()
	local damage = self:GetCaster():GetAttackDamage()
	local target = self:GetCursorTarget()
	local calc = ( target:GetMaxHealth() - target:GetHealth() ) * ( self:GetSpecialValueFor("percent")/100 )

	local ampMod = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_spirit_strike_attack", {})
	self:GetCaster():PerformAttack( target, false, true, true, false, false, false, true ) 
	ampMod:Destroy()

	local current = target:GetHealth() -- Get the health for kill check after attack hit
	
	local damageTable = {
        victim = target,
        attacker = self:GetCaster(),
        damage = calc,
        damage_type = DAMAGE_TYPE_PURE
    }
	ApplyDamage(damageTable)

	self:PlayEffects( target )

	if calc >= current then
		self:EndCooldown()
	end
end

function spirit_strike:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_jinda_slow_tgt.vpcf"

	local effect = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect,
		0,
		target,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		false -- unknown, true
	)

	StartSoundEvent( "Hero_PhantomAssassin.CoupDeGrace", target )
end