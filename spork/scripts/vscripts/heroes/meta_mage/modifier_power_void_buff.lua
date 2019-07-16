modifier_power_void_buff = class({})

function modifier_power_void_buff:IsBuff()
	return true
end

function modifier_power_void_buff:IsPurgable()
	return false
end

function modifier_power_void_buff:RemoveOnDeath()
	return false
end

function modifier_power_void_buff:GetTexture()
	return "power_gift"
end

function modifier_power_void_buff:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile_energy.vpcf"
end

function modifier_power_void_buff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_power_void_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_power_void_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
	return funcs
end

if IsServer() then
	function modifier_power_void_buff:OnCreated( keys )
		local ability = self:GetParent():FindAbilityByName("power_void")
		if ability then
			_G.AbilitySwap( self:GetParent(), "power_void", "power_gift" )
		end
		self.stat = keys.stat
		self:SetStackCount( keys.stacks )
		self.cooldown = keys.cooldown
		self.age = keys.age
	end

	function modifier_power_void_buff:OnDestroy()
		local ability = self:GetParent():FindAbilityByName("power_gift")
		if ability then

			--Checking if its just a decay or an actual gift
			local modifiers = self:GetParent():FindAllModifiersByName( self:GetName() )
			for i=1, #modifiers do
				if modifiers[i].age > self.age then
					return
				end
			end

			-- If its a gift swap the ability and set its remaining time if it wouldn't have elapsed already
			_G.AbilitySwap( self:GetParent(), "power_gift", "power_void" )

			local remaining_cooldown = self.cooldown - ( self:GetDuration() - self:GetRemainingTime() )
			if remaining_cooldown > 0 and not self:GetParent():HasModifier("modifier_spellcraft") then
				self:GetParent():FindAbilityByName("power_void"):StartCooldown( remaining_cooldown )
			end
		end
	end
end



function modifier_power_void_buff:GetModifierBonusStats_Strength()
	local check = 0
	if IsServer() then
		if self.stat == "Strength" then	check = 1 end
	end
	return check * self:GetStackCount()
end

function modifier_power_void_buff:GetModifierBonusStats_Agility()
	local check = 0
	if IsServer() then
		if self.stat == "Agility" then	check = 1 end
	end
	return check * self:GetStackCount()
end

function modifier_power_void_buff:GetModifierBonusStats_Intellect()
	local check = 0
	if IsServer() then
		if self.stat == "Intelligence" then	check = 1 end
	end
	return check * self:GetStackCount()
end
