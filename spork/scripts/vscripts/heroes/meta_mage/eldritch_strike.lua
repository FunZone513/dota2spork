LinkLuaModifier( "modifier_eldritch_strike", "heroes/meta_mage/modifier_eldritch_strike.lua", LUA_MODIFIER_MOTION_NONE )

eldritch_strike = class({})

function eldritch_strike:OnSpellStart()

	-- Made the variables a little nicer
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local targets

	-- Projectile creation and management
	local projectile_name = "particles/units/heroes/hero_chaos_knight/chaos_knight_chaos_bolt.vpcf"
	local projectile_speed = 1600
	local info = {
		Target = target,
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetOrigin(),

		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
	}
	ProjectileManager:CreateTrackingProjectile(info)

	StartSoundEvent( "Hero_ChaosKnight.ChaosBolt.Cast", caster )
end

function eldritch_strike:OnProjectileHit( hTarget, vLocation )
	local target = hTarget

	-- Checking extraneous cases / fails
	if target == nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if target:TriggerSpellAbsorb( self ) then return end

	-- Applying damage to the target
	local base_damage = self:GetSpecialValueFor("damage") 											-- Defined in KV

	-- Check if the caster has the talent before adding the extra stuff to it
	local talent = self:GetCaster():FindAbilityByName("meta_mage_talent_q")
	if talent and talent:GetLevel() > 0 then
		base_damage = base_damage + talent:GetSpecialValueFor("value")
	end

	local bonus_damage = self:GetSpecialValueFor("bonus_damage") * self:GetCaster():GetStrength() 	-- Just getting the bonus from stats
	local amp_damage = (base_damage * self:GetCaster():GetSpellAmplification(false)) + base_damage 	-- accounting for the hero's spell amp

	local damageTable = {
        victim = target,
        attacker = self:GetCaster(),
        damage = amp_damage + bonus_damage, -- bonus damage from stats won't be amplified for simplicity (for player)
        damage_type = DAMAGE_TYPE_MAGICAL
   	}
	ApplyDamage(damageTable)


	-- Adding the debuff
	target:AddNewModifier( self:GetCaster(), self, "modifier_eldritch_strike", { duration = self:GetSpecialValueFor("duration") } )

	StartSoundEvent( "Hero_ChaosKnight.ChaosBolt.Impact", target )
end