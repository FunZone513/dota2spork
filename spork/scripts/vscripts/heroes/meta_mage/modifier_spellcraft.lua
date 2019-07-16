modifier_spellcraft = class({})

function modifier_spellcraft:IsHidden()
	return false
end

function modifier_spellcraft:IsPurgable()
	return false
end

function modifier_spellcraft:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
	return funcs
end

if IsServer() then

	function modifier_spellcraft:OnCreated( keys )
		self:SetStackCount( keys.stacks )

		-- I gotta copy this same fucking loop into here because I can't pass a table into a modifier >:(
		self.list = {}
		local count = 1
		for i=0, 4 do
			local ability = self:GetParent():GetAbilityByIndex(i)
			-- Not a toggle or ultimate
			if ability:GetBehavior() ~= 512 and ability:GetAbilityType() ~= 1 and ability:GetCooldown( ability:GetLevel() ) > 1 then
			   	self.list[count] = ability:GetName() -- Retrieve string name not ability handle
			   	count = count +1
			end
		end
	end

	function modifier_spellcraft:OnAbilityFullyCast( keys )
		if keys.unit == self:GetParent() then

			-- Check if the ability that was cast was one that we removed the cost of
			local check = false
			for i=1, #self.list do
				if self.list[i] == keys.ability:GetName() then
					check = true
					break
				end
			end
			if check == false then return end

			-- Find the ability handle from the name
			-- I'm doing it this way around because abilities that have been swapped do not have the same handle, but they have the same name
				-- ( its to fix a bug where with level 3 ult a second cast of E doesn't consume a charge )
			local ability = keys.unit:FindAbilityByName( keys.ability:GetName() )
			ability:EndCooldown()
			ability:RefundManaCost()

			self:DecrementStackCount()
			if self:GetStackCount() == 0 then self:Destroy() end
		end
	end

end