LinkLuaModifier( "modifier_voracious_spores_root", "heroes/crimson_shambler/modifier_voracious_spores_root.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_voracious_spores_damage", "heroes/crimson_shambler/modifier_voracious_spores_damage.lua", LUA_MODIFIER_MOTION_NONE )

thinker_voracious_spores = class({})

function thinker_voracious_spores:IsPurgable()
	return false
end

if IsServer() then
	function thinker_voracious_spores:OnCreated()
		self:StartIntervalThink( 0.2 )
	end

	function thinker_voracious_spores:OnIntervalThink()
		local ability = self:GetAbility()
		local radius = ability:GetSpecialValueFor("radius")

		self:PlayEffects( radius )

		local units = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(),	-- int, your team number
			self:GetParent():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		for i=1, #units do
			if not units[i]:IsMagicImmune() then
				units[i]:AddNewModifier( self:GetCaster(), ability, "modifier_voracious_spores_root", { duration = ability:GetSpecialValueFor("root_duration") } )
				units[i]:AddNewModifier( self:GetCaster(), ability, "modifier_voracious_spores_damage", { duration = ability:GetSpecialValueFor("damage_duration") } )
			end
		end

		self:Destroy()
	end

	function thinker_voracious_spores:OnDestroy()
		UTIL_Remove(self:GetParent())
	end
end

function thinker_voracious_spores:PlayEffects( radius )
	local particle_name = "particles/crimson_shambler/voracious_spores_ring.vpcf"
	local attach_type = PATTACH_WORLDORIGIN

	local effect = ParticleManager:CreateParticle( particle_name, attach_type, nil )
	ParticleManager:SetParticleControl( effect, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect, 1, Vector(radius, 0, 0) )

	StartSoundEventFromPosition( "Hero_Venomancer.VenomousGaleImpact", self:GetParent():GetOrigin() )
end