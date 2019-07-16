LinkLuaModifier( "modifier_dazzling_cloud_delay", "heroes/crimson_shambler/modifier_dazzling_cloud_delay.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dazzling_cloud_aura", "heroes/crimson_shambler/modifier_dazzling_cloud_aura.lua", LUA_MODIFIER_MOTION_NONE )

thinker_dazzling_cloud = class({})

function thinker_dazzling_cloud:IsHidden()
	return false
end

function thinker_dazzling_cloud:IsDebuff()
	return true
end

function thinker_dazzling_cloud:IsPurgable()
	return false
end

if IsServer() then
	function thinker_dazzling_cloud:OnCreated()
		self:StartIntervalThink( 0.1 )
		StartSoundEventFromPosition( "Hero_Enchantress.EnchantHero", self:GetParent():GetOrigin() )
	end

	function thinker_dazzling_cloud:OnIntervalThink()
		local ability = self:GetAbility()

		self:PlayEffects( self:GetAbility():GetSpecialValueFor("radius") )

		local units = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(),	-- int, your team number
			self:GetParent():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			ability:GetSpecialValueFor("radius"),	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		for i=1, #units do
			units[i]:AddNewModifier( self:GetCaster(), ability, "modifier_dazzling_cloud_aura", { duration = 0.15 } )
			if not units[i]:IsMagicImmune() and not units[i]:HasModifier("modifier_dazzling_cloud_delay") then
				units[i]:AddNewModifier( self:GetCaster(), ability, "modifier_dazzling_cloud_delay", { duration = ability:GetSpecialValueFor("sleep_delay") } )
			end
		end
	end

	function thinker_dazzling_cloud:OnDestroy()
		UTIL_Remove(self:GetParent())
	end
end

function thinker_dazzling_cloud:PlayEffects( radius )
	local particle_name = "particles/crimson_shambler/dazzling_cloud_temp.vpcf"
	local particle_name2 = "particles/crimson_shambler/dazzling_cloud_smoke.vpcf"
	local attach_type = PATTACH_WORLDORIGIN

	local effect = ParticleManager:CreateParticle( particle_name, attach_type, nil )
	ParticleManager:SetParticleControl( effect, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect, 1, Vector(radius, 0, 0) )

	local effect2 = ParticleManager:CreateParticle( particle_name2, attach_type, nil )
	ParticleManager:SetParticleControl( effect2, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect2, 1, Vector(radius, 0, 0) )
end