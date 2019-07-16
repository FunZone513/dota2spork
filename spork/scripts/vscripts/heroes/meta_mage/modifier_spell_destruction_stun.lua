modifier_spell_destruction_stun = class({})

function modifier_spell_destruction_stun:IsHidden()
	return false
end

function modifier_spell_destruction_stun:IsDebuff()
	return true
end

function modifier_spell_destruction_stun:IsPurgable()
	return true
end

function modifier_spell_destruction_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_spell_destruction_stun:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

function modifier_spell_destruction_stun:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

function modifier_spell_destruction_stun:GetOverrideAnimation()
    return ACT_DOTA_DISABLED
end