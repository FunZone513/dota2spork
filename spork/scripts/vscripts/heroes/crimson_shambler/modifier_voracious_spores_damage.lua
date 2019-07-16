modifier_voracious_spores_damage = class({})

function modifier_voracious_spores_damage:IsHidden()
	return false
end

function modifier_voracious_spores_damage:IsDebuff()
	return true
end

function modifier_voracious_spores_damage:IsPurgable()
	return true
end

function modifier_voracious_spores_damage:GetEffectName()
	return "particles/units/heroes/hero_venomancer/venomancer_gale_poison_debuff.vpcf"
end

function modifier_voracious_spores_damage:OnCreated()
	self:StartIntervalThink( self:GetAbility():GetSpecialValueFor("tick_rate") )
end

function modifier_voracious_spores_damage:OnIntervalThink()
	if not IsServer() then return end
	
	local base = self:GetAbility():GetSpecialValueFor("damage_per_tick")
	local damageTable = {
        victim = self:GetParent(),
       	attacker = self:GetCaster(),
       	damage = ( base * self:GetCaster():GetSpellAmplification(false) ) + base,
       	damage_type = DAMAGE_TYPE_MAGICAL
    }
	ApplyDamage(damageTable)
end