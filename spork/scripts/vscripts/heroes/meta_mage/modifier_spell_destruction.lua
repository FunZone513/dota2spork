LinkLuaModifier( "modifier_spell_destruction_stun", "heroes/meta_mage/modifier_spell_destruction_stun.lua", LUA_MODIFIER_MOTION_NONE )

modifier_spell_destruction = class({})

function modifier_spell_destruction:IsHidden()
	return false
end

function modifier_spell_destruction:IsDebuff()
	return true
end

function modifier_spell_destruction:IsPurgable()
	return false
end

function modifier_spell_destruction:GetEffectName()
	return "particles/units/heroes/hero_faceless_void/faceless_void_dialatedebuf.vpcf"
end

if IsServer() then
	function modifier_spell_destruction:OnCreated( keys )
		self:SetStackCount( keys.stacks )
	end
end

function modifier_spell_destruction:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_START
	}
	return funcs
end

function modifier_spell_destruction:OnAbilityStart( keys )
	if keys.unit == self:GetParent() then
		if keys.ability:IsItem() or keys.ability:IsToggle() then return end

		self:GetParent():Interrupt()
		StartSoundEvent( "Hero_Enigma.Malefice", self:GetParent() )

		-- Apply the Stun
		self:GetParent():AddNewModifier( 
			self:GetCaster(), 
			self:GetAbility(), 
			"modifier_spell_destruction_stun", 
			{ duration = self:GetAbility():GetSpecialValueFor("stun_duration") } 
		)

		-- Calculate the damage with spell amp
		local base = self:GetAbility():GetSpecialValueFor("damage")
		local amp = self:GetCaster():GetSpellAmplification(false)
		local total = ((base*amp)+base)

		-- Apply the damage
		local info = {
        	victim = self:GetParent(),
       		attacker = self:GetCaster(),
       		damage = total,
       		damage_type = DAMAGE_TYPE_MAGICAL
    	}
		ApplyDamage(info)

		-- Decrease stack count
		if not self:GetParent():IsAlive() then return end
		self:DecrementStackCount()
		if self:GetStackCount() == 0 then self:Destroy() end
	end
end