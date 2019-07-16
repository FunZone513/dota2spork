modifier_wrath_of_the_betrayed_control = class({})

function modifier_wrath_of_the_betrayed_control:IsHidden()
	return false
end

function modifier_wrath_of_the_betrayed_control:IsBuff()
	return true
end

function modifier_wrath_of_the_betrayed_control:IsPurgable()
	return true
end

function modifier_wrath_of_the_betrayed_control:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_wrath_of_the_betrayed_control:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("steal") * ( self:GetStackCount() )
end