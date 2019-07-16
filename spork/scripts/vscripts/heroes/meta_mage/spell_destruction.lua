LinkLuaModifier( "modifier_spell_destruction", "heroes/meta_mage/modifier_spell_destruction.lua", LUA_MODIFIER_MOTION_NONE )

spell_destruction = class({})

function spell_destruction:OnSpellStart()
	local target = self:GetCursorTarget()

	-- Check a bunch of shit
	if target == nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if target:TriggerSpellAbsorb( self ) then return end

	-- insta-kill illusions
	if target:IsHero() and not target:IsRealHero() then 
		target:Kill(self, self:GetCaster())
		return
	end

	local duration = self:GetSpecialValueFor("duration")
	local stacks = self:GetSpecialValueFor("abilities")
	target:AddNewModifier( self:GetCaster(), self, "modifier_spell_destruction", { duration = duration, stacks = stacks } )

	self:PlayEffects( target )
end

function spell_destruction:PlayEffects( unit )
	local particle_name = "particles/units/heroes/hero_keeper_of_the_light/keeper_mana_leak.vpcf"
	local attach_type = PATTACH_WORLDORIGIN

	local effect = ParticleManager:CreateParticle( particle_name, attach_type, nil )
	ParticleManager:SetParticleControl( effect, 0, unit:GetOrigin() )

	StartSoundEvent( "Hero_KeeperOfTheLight.ManaLeak.Cast", unit )
end