spellcraft_think = class({})

function spellcraft_think:IsHidden()
	return true
end

function spellcraft_think:IsPurgable()
	return false
end

function spellcraft_think:IsPermanent()
	return true
end

if IsServer() then
	function spellcraft_think:OnCreated()
		self:StartIntervalThink(0.1)
	end

	function spellcraft_think:OnIntervalThink()
		local parent = self:GetParent()
		local ability = parent:FindAbilityByName("spell_destruction")
		
		if parent:HasScepter() and ability:IsHidden() then
			ability:SetHidden(false)
		elseif not parent:HasScepter() and not ability:IsHidden() then
			ability:SetHidden(true)
		end
	end
end