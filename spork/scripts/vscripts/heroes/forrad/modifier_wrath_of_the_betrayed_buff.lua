modifier_wrath_of_the_betrayed_buff = class({})

function modifier_wrath_of_the_betrayed_buff:IsHidden()
	return true
end

function modifier_wrath_of_the_betrayed_buff:IsBuff()
	return true
end

function modifier_wrath_of_the_betrayed_buff:IsPurgable()
	return true
end

function modifier_wrath_of_the_betrayed_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_wrath_of_the_betrayed_buff:OnRemoved()
	if IsServer() then
		local control = self:GetParent():FindModifierByName("modifier_wrath_of_the_betrayed_control")
		control:SetStackCount( control:GetStackCount() - self:GetAbility():GetSpecialValueFor("steal") )

		if control:GetStackCount() <= 0 then
			control:Destroy()
		end
	end
end
