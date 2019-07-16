modifier_oath_of_the_spectral_blade_speed = class({})

function modifier_oath_of_the_spectral_blade_speed:IsHidden()
	return false
end

function modifier_oath_of_the_spectral_blade_speed:IsPurgable()
	return true
end

function modifier_oath_of_the_spectral_blade_speed:GetTexture()
	return "item_phase_boots"
end

function modifier_oath_of_the_spectral_blade_speed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_oath_of_the_spectral_blade_speed:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end