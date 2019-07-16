modifier_dazzling_cloud_sleep = class({})

function modifier_dazzling_cloud_sleep:IsHidden()
	return false
end

function modifier_dazzling_cloud_sleep:IsDebuff()
	return true
end

function modifier_dazzling_cloud_sleep:IsPurgable()
	return true
end

function modifier_dazzling_cloud_sleep:GetEffectName()
	return "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo_debuff.vpcf"
end

function modifier_dazzling_cloud_sleep:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_dazzling_cloud_sleep:OnIntervalThink()
	if not self:GetParent():HasModifier("modifier_dazzling_cloud_aura") then
		self:Destroy()
	end
end

function modifier_dazzling_cloud_sleep:CheckState()
	local state = {
		[MODIFIER_STATE_NIGHTMARED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_DISARMED] = true
	}
	return state
end

function modifier_dazzling_cloud_sleep:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

function modifier_dazzling_cloud_sleep:GetOverrideAnimation()
    return ACT_DOTA_DISABLED
end