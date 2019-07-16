modifier_mycosis_debuff = class({})

function modifier_mycosis_debuff:IsHidden()
	return false
end

function modifier_mycosis_debuff:IsPurgable()
	return true
end

function modifier_mycosis_debuff:IsDebuff()
	return true
end

function modifier_mycosis_debuff:GetEffectName()
	return "particles/econ/items/broodmother/bm_lycosidaes/bm_lycosidaes_spiderlings_debuff.vpcf"
end

function modifier_mycosis_debuff:OnCreated()
	self:StartIntervalThink(0.5)
end

function modifier_mycosis_debuff:OnIntervalThink()
	if not IsServer() then return end

	local base = self:GetAbility():GetSpecialValueFor("degen")
	local amp = self:GetCaster():GetSpellAmplification(false)
	local damage = self:GetParent():GetMaxHealth() * ( ((base*amp)+base) / 100 )
	
	local damageTable = {
        victim = self:GetParent(),
       	attacker = self:GetCaster(),
       	damage = damage,
       	damage_type = DAMAGE_TYPE_MAGICAL
    }
	ApplyDamage(damageTable)
end

function modifier_mycosis_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_mycosis_debuff:GetModifierHPRegenAmplify_Percentage()
	return -1 * self:GetAbility():GetSpecialValueFor("heal_reduction")
end

function modifier_mycosis_debuff:OnDeath( keys )
	
	if keys.unit == self:GetParent() then

		local ability = self:GetAbility()
		local sporeling = CreateUnitByName( 
			"npc_dota_crimson_shambler_sporeling", 	-- Unit Name
			keys.unit:GetOrigin(),					-- Where
			true, 									-- Find clear space?
			self:GetCaster(), 						-- caster?
			self:GetCaster():GetOwner(), 			-- owner?
			self:GetCaster():GetTeamNumber() 		-- Team 
		)
		sporeling:SetControllableByPlayer( self:GetCaster():GetPlayerOwnerID(), false) -- Give the player control
		sporeling:SetOwner( self:GetCaster() )

		-- Make it a summon with a time limit
   		sporeling:AddNewModifier( 
   			self:GetCaster(), 
   			ability, 
   			"modifier_kill", 
   			{ duration = ability:GetSpecialValueFor("sporeling_duration") } 
   		)

   		-- Make it phased. ie; it has no unit collision
   		sporeling:AddNewModifier( 
   			self:GetCaster(), 
   			ability, 
   			"modifier_phased", 
   			{} 
   		)

		sporeling:SetBaseAttackTime( ability:GetSpecialValueFor( "sporeling_bat") ) -- Base Attack Time

		local talent = self:GetCaster():FindAbilityByName("crimson_shambler_talent_e") -- Damage Talent
		local bonus = 0
    	if talent and talent:GetLevel() > 0 then
    		bonus = talent:GetSpecialValueFor("value")
    	end
		sporeling:SetBaseDamageMax( ( ability:GetSpecialValueFor("sporeling_damage") + bonus ) * 1.1 ) -- Damage is an average
		sporeling:SetBaseDamageMin( ( ability:GetSpecialValueFor("sporeling_damage") + bonus ) * 0.9 )

		sporeling:SetMaxHealth( ability:GetSpecialValueFor( "sporeling_health") ) -- Set the max health, then "heal" the unit
		sporeling:SetHealth( ability:GetSpecialValueFor( "sporeling_health") )

		sporeling:SetBaseMoveSpeed( ability:GetSpecialValueFor( "sporeling_speed") ) -- Movespeed (Doesn't update on the HUD?)
   	end
end