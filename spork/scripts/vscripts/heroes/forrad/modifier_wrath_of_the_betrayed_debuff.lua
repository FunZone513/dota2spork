LinkLuaModifier( "modifier_wrath_of_the_betrayed_control", "heroes/forrad/modifier_wrath_of_the_betrayed_control.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_wrath_of_the_betrayed_buff", "heroes/forrad/modifier_wrath_of_the_betrayed_buff.lua", LUA_MODIFIER_MOTION_NONE )

modifier_wrath_of_the_betrayed_debuff = class({})

function modifier_wrath_of_the_betrayed_debuff:IsHidden()
	return false
end

function modifier_wrath_of_the_betrayed_debuff:IsDebuff()
	return true
end

function modifier_wrath_of_the_betrayed_debuff:IsPurgable()
	return true
end

function modifier_wrath_of_the_betrayed_debuff:GetEffectName()
	return "particles/units/heroes/hero_spectre/spectre_desolate_debuff.vpcf"
end

function modifier_wrath_of_the_betrayed_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_wrath_of_the_betrayed_debuff:GetModifierAttackSpeedBonus_Constant()
	return -1 * ( self:GetAbility():GetSpecialValueFor("steal") * self:GetStackCount() )
end

function modifier_wrath_of_the_betrayed_debuff:OnAttackLanded( keys )
	if keys.target == self:GetParent() and keys.attacker:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		local atk = keys.attacker

		-- Give the attacker the control modifier
		if atk:HasModifier("modifier_wrath_of_the_betrayed_control") ~= true then
			atk:AddNewModifier( atk, self:GetAbility(), "modifier_wrath_of_the_betrayed_control", { duration = 5 } )
		end
		atk:FindModifierByName("modifier_wrath_of_the_betrayed_control"):SetStackCount( self:GetStackCount() + self:GetAbility():GetSpecialValueFor("steal") )
		atk:FindModifierByName("modifier_wrath_of_the_betrayed_control"):SetDuration(5, true)

		-- Give the attacker an instance to keep track, and remove the attack speed from the parent
		atk:AddNewModifier( atk, self:GetAbility(), "modifier_wrath_of_the_betrayed_buff", { duration = 5 } )
		self:SetStackCount( self:GetStackCount() + self:GetAbility():GetSpecialValueFor("steal") )

		-- Talent changes the heal / damage
		local health_steal = self:GetAbility():GetSpecialValueFor("health")

		local talent = atk:FindAbilityByName("forrad_talent_e")
    	if talent and talent:GetLevel() > 0 and IsServer() then
        	local temp = ( talent:GetSpecialValueFor("value") / 100 ) * self:GetParent():GetHealth()

        	if temp > health_steal then
        		health_steal = temp
        	end
    	end

		-- Heal the attacker
		atk:Heal( health_steal, self:GetAbility() )

		-- Damage the Parent
		local damageTable = {
        	victim = self:GetParent(),
        	attacker = atk,
        	damage = health_steal,
        	damage_type = DAMAGE_TYPE_PURE
    	}
		ApplyDamage(damageTable)

	end
end
