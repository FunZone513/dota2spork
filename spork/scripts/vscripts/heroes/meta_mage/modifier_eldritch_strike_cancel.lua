modifier_eldritch_strike_cancel = class({})

function modifier_eldritch_strike_cancel:IsHidden()
	return true
end

function modifier_eldritch_strike_cancel:IsPurgable()
	return false
end

function modifier_eldritch_strike_cancel:IsPermanent()
	return true
end

function modifier_eldritch_strike_cancel:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_eldritch_strike_cancel:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("percent") * self:GetStackCount()
end