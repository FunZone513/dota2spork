LinkLuaModifier( "thinker_voracious_spores", "heroes/crimson_shambler/thinker_voracious_spores.lua", LUA_MODIFIER_MOTION_NONE )

voracious_spores = class ({})

function voracious_spores:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function voracious_spores:OnSpellStart()

    local point = self:GetCursorPosition()
	local caster = self:GetCaster()

	CreateModifierThinker(
		caster,
		self,
		"thinker_voracious_spores",
		{},
		point,
		caster:GetTeamNumber(),
		false
	)

	-- Particle or something to show that its been cast?

end