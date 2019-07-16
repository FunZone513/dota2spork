LinkLuaModifier( "modifier_power_void_buff", "heroes/meta_mage/modifier_power_void_buff.lua", LUA_MODIFIER_MOTION_NONE )

power_gift = class({})

function power_gift:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- Check a bunch of shit
	if target == nil then return end
	if target:IsHero() and not target:IsRealHero() then return end

	StartSoundEvent( "Hero_Bane.BrainSap.Target", caster )
	if IsServer() then

		-- We only want to give them the most recent buff
		local modifiers = caster:FindAllModifiersByName("modifier_power_void_buff")
		self.modifier = modifiers[1]
		for i=1, #modifiers do
			if modifiers[i]:GetCreationTime() > self.modifier:GetCreationTime() then
				self.modifier = modifiers[i]
			end
		end

		-- Set up the important info for the gifted modifier
		self.stacks = self.modifier:GetStackCount()
		self.stat = self.modifier.stat
		self.duration = self.modifier:GetRemainingTime()
		self.cooldown = self.modifier.cooldown
		self.age = self.modifier:GetCreationTime()

		-- Projectile creation and management
		local projectile_name = "particles/units/heroes/hero_lich/lich_dark_ritual.vpcf"
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
	end

end

if IsServer() then
	function power_gift:OnProjectileHit( hTarget, vLocation )

		-- Add the modifier to the ally and remove the one off the caster
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_power_void_buff", { duration = self.duration, stat = self.stat, stacks = self.stacks, cooldown = self.cooldown, age = self.age } )
		self.modifier:Destroy()

		StartSoundEvent( "Hero_Bane.BrainSap", hTarget )
	end
end