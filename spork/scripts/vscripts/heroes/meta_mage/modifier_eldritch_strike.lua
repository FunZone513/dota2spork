LinkLuaModifier( "modifier_eldritch_strike_cancel", "heroes/meta_mage/modifier_eldritch_strike_cancel.lua", LUA_MODIFIER_MOTION_NONE )

modifier_eldritch_strike = class({})

function modifier_eldritch_strike:IsHidden()
	return false
end

function modifier_eldritch_strike:IsDebuff()
	return true
end

function modifier_eldritch_strike:IsPurgable()
	return true
end

function modifier_eldritch_strike:OnRefresh()
	self:IncrementStackCount()
end

function modifier_eldritch_strike:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

--[[
	Since it's x% of damage taken as true damage, and not x% of damage as bonus true damage, we need to
	reduce the amount of normal damage they take, then turn the extra damage into true damage and
	re-apply it. 
	ie;
	Take 100 damage w/ 20% of it as pure
	> Reduce incoming damage by 20%
	> Find 20% of 100 damage
	> Unit takes 80% of the original damage
	> The other 20% is applied as true damage
]]

function modifier_eldritch_strike:GetModifierIncomingDamage_Percentage()
	local reduction = self:GetAbility():GetSpecialValueFor("percent")

	-- Account for modifier stacking
	local stacks = self:GetStackCount() + 1

	return -1*(reduction * stacks)
end

function modifier_eldritch_strike:OnTakeDamage( keys )
	if keys.unit == self:GetParent() then -- Only trigger on the afflicted unit
		if keys.damage_type == DAMAGE_TYPE_PURE then return end -- No point in checking pure damage (also prevents infinite loops)

		-- Account for modifier stacking
		local stacks = self:GetStackCount() + 1
		local percent = ( self:GetAbility():GetSpecialValueFor("percent") * stacks ) / 100

		-- Damage calc
		local base_damage = keys.original_damage -- This gives us how much damage the target would take, ignoring any changes
		local pure_damage = base_damage * percent -- Get our x% pure damage

		-- Cancel out the damage reduction because Dota is a shit game
		local temp_mod = keys.unit:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_eldritch_strike_cancel", {} )
		if temp_mod then temp_mod:SetStackCount( stacks ) end -- Adding a check in case ability damage kills the unit

		-- Re-apply the damage as pure
		local damageTable = {
        	victim = keys.unit,
        	attacker = keys.attacker,
        	damage = pure_damage,
       		damage_type = DAMAGE_TYPE_PURE
   		}
		ApplyDamage(damageTable)
		if temp_mod then temp_mod:Destroy() end
	end
end