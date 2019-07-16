LinkLuaModifier( "modifier_spellcraft", "heroes/meta_mage/modifier_spellcraft.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "spellcraft_think", "heroes/meta_mage/spellcraft_think.lua", LUA_MODIFIER_MOTION_NONE )

spellcraft = class({})

function spellcraft:GetIntrinsicModifierName()
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "spellcraft_think", {} )
end

function spellcraft:OnUpgrade()
	self:GetCaster():FindAbilityByName("spell_destruction"):SetLevel( self:GetLevel() )
end

function spellcraft:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- Illusion Check
	if target:IsHero() and not target:IsRealHero() then
		self:EndCooldown()
		return
	end

	-- Refresh abilities
	for i=0, 4 do
		local ability = target:GetAbilityByIndex(i)

		-- Ultimate double check & if its on cd anyway
		if ability:GetAbilityType() ~= 1 and ability:GetCooldownTimeRemaining() > 0 then 
		   	ability:EndCooldown()
		end
	end

	-- Add the modifier to the target
	if self:GetLevel() > 1 then
		local stacks = self:GetSpecialValueFor("bonus_cast")
		local duration = self:GetSpecialValueFor("duration")

		-- Give the modifier our values we want it to know
		target:AddNewModifier( caster, self, "modifier_spellcraft", { duration = duration, stacks = stacks } )
	end

	self:PlayEffects( target )

end

function spellcraft:PlayEffects( unit )
	local particle_name = "particles/units/heroes/hero_invoker/invoker_invoke.vpcf"

	local effect = ParticleManager:CreateParticle( particle_name, PATTACH_ABSORIGIN_FOLLOW, unit )
	ParticleManager:SetParticleControlEnt(
		effect,
		0,
		unit,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		unit:GetOrigin(), -- unknown
		false -- unknown, true
	)

	StartSoundEvent( "Hero_FacelessVoid.TimeDilation.Target", unit )
end