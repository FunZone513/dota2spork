LinkLuaModifier( "modifier_oath_of_the_spectral_blade_passive", "heroes/forrad/modifier_oath_of_the_spectral_blade_passive.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "oath_of_the_spectral_blade_think", "heroes/forrad/oath_of_the_spectral_blade_think.lua", LUA_MODIFIER_MOTION_NONE )

oath_of_the_spectral_blade = class({})

function oath_of_the_spectral_blade:OnUpgrade()
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "oath_of_the_spectral_blade_think", {})
end

function oath_of_the_spectral_blade:GetIntrinsicModifierName()
	return "modifier_oath_of_the_spectral_blade_passive"
end