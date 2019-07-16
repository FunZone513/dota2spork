LinkLuaModifier( "modifier_power_void_debuff", "heroes/meta_mage/modifier_power_void_debuff.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_power_void_buff", "heroes/meta_mage/modifier_power_void_buff.lua", LUA_MODIFIER_MOTION_NONE )

power_void = class({})

function power_void:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- Check a bunch of shit
	if target == nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if target:TriggerSpellAbsorb( self ) then return end
	-- insta-kill illusions
	if target:IsHero() and not target:IsRealHero() then 
		target:Kill(self, caster)
		return
	end

	-- Figure out what the enemy's primary stat is
	local primary = target:GetPrimaryAttribute()
	if primary == nil then return end -- ??? shouldn't ever happen but safety first

	local stats = { "Strength", "Agility", "Intelligence" } -- this bit is purely for readability
	primary = stats[ primary+1 ]

	-- How much is going to be stolen
	local bonus = math.floor( (self:GetCaster():GetIntellect() / self:GetSpecialValueFor("bonus_steal")) + 0.2 ) -- have a little rounding up
	local steal = self:GetSpecialValueFor("steal") + bonus

	-- Check if the caster has the talent
	local talent = self:GetCaster():FindAbilityByName("meta_mage_talent_e")
	if talent and talent:GetLevel() > 0 then
		print("found")
		steal = steal + talent:GetSpecialValueFor("value")
	end

	-- Add the modifier to the enemy
	target:AddNewModifier( caster, self, "modifier_power_void_debuff", { duration = self:GetSpecialValueFor("duration"), stat = primary, stacks = steal } )

	StartSoundEvent( "Hero_Bane.BrainSap.Target", target )
	if IsServer() then
		-- Set the stuff we'll need
		self.stacks = steal
		self.stat = primary
		self.duration = self:GetSpecialValueFor("duration")
		self.cooldown = self:GetCooldown( self:GetLevel() )

		-- Projectile creation and management
		local projectile_name = "particles/units/heroes/hero_lich/lich_dark_ritual.vpcf"
		local projectile_speed = 1600
		local info = {
			Target = caster,
			Source = target,
			Ability = self,
			vSpawnOrigin = target:GetOrigin(),

			EffectName = projectile_name,
			iMoveSpeed = projectile_speed,
		}
		ProjectileManager:CreateTrackingProjectile(info)
	end

end

if IsServer() then
	function power_void:OnProjectileHit( hTarget, vLocation )

		-- Add the modifier to the caster
		hTarget:AddNewModifier( hTarget, self, "modifier_power_void_buff", { duration = self.duration, stat = self.stat, stacks = self.stacks, cooldown = self.cooldown, age = GameRules:GetGameTime() } )

		StartSoundEvent( "Hero_Bane.BrainSap", hTarget )
	end
end