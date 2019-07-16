modifier_honour_of_the_dead_debuff = class({})

function modifier_honour_of_the_dead_debuff:IsHidden()
	return false
end

function modifier_honour_of_the_dead_debuff:IsPurgable()
	return true
end

function modifier_honour_of_the_dead_debuff:IsDebuff()
	return true
end

function modifier_honour_of_the_dead_debuff:RemoveOnDeath()
	return true
end

function modifier_honour_of_the_dead_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_honour_of_the_dead_debuff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armour")
end

function modifier_honour_of_the_dead_debuff:GetModifierMoveSpeedBonus_Percentage()
	local slow = 0
	if IsServer() then
		local talent = self:GetCaster():FindAbilityByName("forrad_talent_r")
    	if talent and talent:GetLevel() > 0 then
    		slow = talent:GetSpecialValueFor("value")
    	end
    end
    return slow
end