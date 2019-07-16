modifier_spirit_strike_attack = class({})

function modifier_spirit_strike_attack:IsHidden()
	return true
end

function modifier_spirit_strike_attack:IsPurgable()
	return false
end

function modifier_spirit_strike_attack:IsPermanent()
	return true
end

function modifier_spirit_strike_attack:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

function modifier_spirit_strike_attack:GetModifierBaseDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("damage") - 100
end