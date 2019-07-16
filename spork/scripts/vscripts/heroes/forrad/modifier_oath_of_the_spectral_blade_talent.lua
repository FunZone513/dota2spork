modifier_oath_of_the_spectral_blade_talent = class({})

function modifier_oath_of_the_spectral_blade_talent:IsHidden()
	return false
end

function modifier_oath_of_the_spectral_blade_talent:IsPurgable()
	return false
end

function modifier_oath_of_the_spectral_blade_talent:IsBuff()
	return true
end

function modifier_oath_of_the_spectral_blade_talent:GetStatusEffectName()
	return "particles/status_fx/status_effect_wraithking_ghosts.vpcf"
end

function modifier_oath_of_the_spectral_blade_talent:GetEffectName()
	return "particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf"
end

if IsServer() then
	function modifier_oath_of_the_spectral_blade_talent:OnRemoved()
		local ability = self:GetAbility()
		ability:StartCooldown( ability:GetCooldown( ability:GetLevel()-1 ) )
	end
end

function modifier_oath_of_the_spectral_blade_talent:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true
    }
    return state
end

function modifier_oath_of_the_spectral_blade_talent:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_HERO_KILLED,
		MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs
end

function modifier_oath_of_the_spectral_blade_talent:OnTooltip()
	return math.ceil( self:GetRemainingTime() )
end

function modifier_oath_of_the_spectral_blade_talent:GetMinHealth()
	return 1
end

function modifier_oath_of_the_spectral_blade_talent:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("ghost_movespeed")
end

function modifier_oath_of_the_spectral_blade_talent:GetModifierTotalDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("reduction")
end

function modifier_oath_of_the_spectral_blade_talent:OnHeroKilled( keys )
	if keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		local increase
		if keys.attacker == self:GetParent() then
			increase = 2
		elseif keys.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then
			if keys.attacker:GetPlayerOwner() ~= nil then
				increase = 1
			end
		end
		self:SetDuration( self:GetDuration() + increase, true )
	end
end