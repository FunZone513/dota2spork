LinkLuaModifier( "thinker_dazzling_cloud", "heroes/crimson_shambler/thinker_dazzling_cloud.lua", LUA_MODIFIER_MOTION_NONE )

dazzling_cloud = class({})

function dazzling_cloud:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function dazzling_cloud:OnSpellStart()

    local point = self:GetCursorPosition()
	local caster = self:GetCaster()

	local duration = self:GetSpecialValueFor("cloud_duration")
	local talent = self:GetCaster():FindAbilityByName("crimson_shambler_talent_w")
	if talent and talent:GetLevel() > 0 then
		duration = duration + talent:GetSpecialValueFor("value")
	end

	CreateModifierThinker(
		caster,
		self,
		"thinker_dazzling_cloud",
		{ duration = duration },
		point,
		caster:GetTeamNumber(),
		false
	)

	-- Particle or something to show that its been cast?

end