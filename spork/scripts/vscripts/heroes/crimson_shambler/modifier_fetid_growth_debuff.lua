modifier_fetid_growth_debuff = class({})

function modifier_fetid_growth_debuff:IsHidden()
	return false
end

function modifier_fetid_growth_debuff:IsPurgable()
	return true
end

function modifier_fetid_growth_debuff:IsDebuff()
	return true
end

function modifier_fetid_growth_debuff:GetEffectName()
	return "particles/units/heroes/hero_treant/treant_overgrowth_vine_bushes.vpcf"
end

function modifier_fetid_growth_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_fetid_growth_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end