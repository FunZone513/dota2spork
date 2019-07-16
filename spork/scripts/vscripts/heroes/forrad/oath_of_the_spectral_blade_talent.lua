LinkLuaModifier( "modifier_oath_of_the_spectral_blade_talent", "heroes/forrad/modifier_oath_of_the_spectral_blade_talent.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_oath_of_the_spectral_blade_passive", "heroes/forrad/modifier_oath_of_the_spectral_blade_passive.lua", LUA_MODIFIER_MOTION_NONE )

oath_of_the_spectral_blade_talent = class({})

function oath_of_the_spectral_blade_talent:GetIntrinsicModifierName()
	return "modifier_oath_of_the_spectral_blade_passive"
end

function oath_of_the_spectral_blade_talent:OnSpellStart()
	local caster = self:GetCaster()

	caster:AddNewModifier( self:GetCaster(), self, "modifier_oath_of_the_spectral_blade_talent", { duration = self:GetSpecialValueFor("duration") })
end