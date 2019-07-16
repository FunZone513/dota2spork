LinkLuaModifier( "modifier_wrath_of_the_betrayed_debuff", "heroes/forrad/modifier_wrath_of_the_betrayed_debuff.lua", LUA_MODIFIER_MOTION_NONE )

wrath_of_the_betrayed = class({})

function wrath_of_the_betrayed:GetBehavior()
    if self:GetCaster():HasScepter() then
        return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
    else
        return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
    end
end

function wrath_of_the_betrayed:GetAOERadius()
	return self:GetSpecialValueFor("aghs_radius")
end

function wrath_of_the_betrayed:OnSpellStart()

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local targets

	local projectile_name = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf"
	local projectile_speed = 1200

	local info = {
		Target = target,
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetOrigin(),

		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
	}
	ProjectileManager:CreateTrackingProjectile(info)

	if caster:HasModifier("modifier_item_ultimate_scepter") or caster:HasModifier("modifier_item_ultimate_scepter_consumed") then
		targets = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self:GetSpecialValueFor("aghs_radius"),	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		for i=1, #targets do
			info.Target = targets[i]
			ProjectileManager:CreateTrackingProjectile(info)
		end
	end

	StartSoundEvent( "Hero_Abaddon.DeathCoil.Cast", caster )
end

function wrath_of_the_betrayed:OnProjectileHit( hTarget, vLocation )
	local target = hTarget
	if target == nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if target:TriggerSpellAbsorb( self ) then return end

	hTarget:AddNewModifier( self:GetCaster(), self,	"modifier_wrath_of_the_betrayed_debuff", { duration = 10 } )

	StartSoundEvent( "Hero_Abaddon.DeathCoil.Target", target )
end