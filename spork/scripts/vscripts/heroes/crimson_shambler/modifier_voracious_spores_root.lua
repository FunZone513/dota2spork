modifier_voracious_spores_root = class({})

function modifier_voracious_spores_root:IsHidden()
	return false
end

function modifier_voracious_spores_root:IsDebuff()
	return true
end

function modifier_voracious_spores_root:IsPurgable()
	return true
end

function modifier_voracious_spores_root:GetEffectName()
	return "particles/units/heroes/heroes_underlord/abyssal_underlord_pitofmalice_stun.vpcf"
end

function modifier_voracious_spores_root:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true
	}
	return state
end