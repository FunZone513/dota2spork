LinkLuaModifier( "modifier_dazzling_cloud_sleep", "heroes/crimson_shambler/modifier_dazzling_cloud_sleep.lua", LUA_MODIFIER_MOTION_NONE )

modifier_dazzling_cloud_delay = class({})

function modifier_dazzling_cloud_delay:IsHidden()
	return true
end

function modifier_dazzling_cloud_delay:IsDebuff()
	return true
end

function modifier_dazzling_cloud_delay:IsPurgable()
	return true
end

function modifier_dazzling_cloud_delay:OnDestroy()
	if self:GetParent():HasModifier("modifier_dazzling_cloud_aura") then 
		self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_dazzling_cloud_sleep", {} )
	end
end