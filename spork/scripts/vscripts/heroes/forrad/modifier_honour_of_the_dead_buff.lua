modifier_honour_of_the_dead_buff = class({})

function modifier_honour_of_the_dead_buff:IsHidden()
	return false
end

function modifier_honour_of_the_dead_buff:IsPurgable()
	return true
end

function modifier_honour_of_the_dead_buff:RemoveOnDeath()
	return true
end

function modifier_honour_of_the_dead_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}
	return funcs
end

function modifier_honour_of_the_dead_buff:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("agility") + ( self:GetStackCount() * self:GetAbility():GetSpecialValueFor("agility_bonus") )
end