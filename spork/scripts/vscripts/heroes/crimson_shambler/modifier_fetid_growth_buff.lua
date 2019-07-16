modifier_fetid_growth_buff = class({})

function modifier_fetid_growth_buff:IsHidden()
	return false
end

function modifier_fetid_growth_buff:IsPurgable()
	return false
end

function modifier_fetid_growth_buff:IsBuff()
	return true
end

function modifier_fetid_growth_buff:GetEffectName()
	return "particles/units/heroes/hero_nevermore/nevermore_shadowraze_debuff.vpcf"
end

function modifier_fetid_growth_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS
	}
	return funcs
end

function modifier_fetid_growth_buff:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("health")
end