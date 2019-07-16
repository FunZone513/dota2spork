modifier_power_void_debuff = class({})

function modifier_power_void_debuff:IsDebuff()
	return true
end

function modifier_power_void_debuff:IsPurgable()
	return false
end

function modifier_power_void_debuff:RemoveOnDeath()
	return false
end

function modifier_power_void_debuff:GetTexture()
	return "power_void"
end

function modifier_power_void_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_power_void_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
	return funcs
end

if IsServer() then
	function modifier_power_void_debuff:OnCreated( keys )
		self.stat = keys.stat
		self:SetStackCount( keys.stacks )
	end
end

function modifier_power_void_debuff:GetModifierBonusStats_Strength()
	local check = 0
	if IsServer() then
		if self.stat == "Strength" then	check = -1 end
	end
	return check * self:GetStackCount()
end

function modifier_power_void_debuff:GetModifierBonusStats_Agility()
	local check = 0
	if IsServer() then
		if self.stat == "Agility" then check = -1 end
	end
	return check * self:GetStackCount()
end

function modifier_power_void_debuff:GetModifierBonusStats_Intellect()
	local check = 0
	if IsServer() then
		if self.stat == "Intelligence" then	check = -1 end
	end
	return check * self:GetStackCount()
end