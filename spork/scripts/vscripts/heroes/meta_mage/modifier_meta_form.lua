modifier_meta_form = class({})

function modifier_meta_form:IsHidden()
	return false
end

function modifier_meta_form:IsBuff()
	return true
end

function modifier_meta_form:IsPurgable()
	return false
end

function modifier_meta_form:GetEffectName()
	return "particles/units/heroes/hero_morphling/morphling_morph_agi.vpcf"
end

function modifier_meta_form:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_meta_form:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("reduction") * -1
end

function modifier_meta_form:GetModifierConstantHealthRegen()
	local base_regen = self:GetAbility():GetSpecialValueFor("regen")
	local bonus_regen = self:GetAbility():GetSpecialValueFor("bonus_regen") * self:GetCaster():GetAgility()

	return base_regen + bonus_regen
end

function modifier_meta_form:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end