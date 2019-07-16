LinkLuaModifier( "modifier_mycosis_debuff", "heroes/crimson_shambler/modifier_mycosis_debuff.lua", LUA_MODIFIER_MOTION_NONE )

modifier_mycosis_passive = class({})

function modifier_mycosis_passive:IsHidden()
	return true
end

function modifier_mycosis_passive:IsPurgable()
	return false
end

function modifier_mycosis_passive:IsPermanent()
	return true
end

function modifier_mycosis_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH
	}	
	return funcs
end

function modifier_mycosis_passive:OnAttackLanded( keys )

	if keys.attacker ~= self:GetParent() then return end
	if keys.target:IsMagicImmune() or keys.target:IsBuilding() then return end
	if keys.target:GetTeam() == self:GetParent():GetTeam() then return end

	keys.target:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_mycosis_debuff", { duration = self:GetAbility():GetSpecialValueFor("duration") } )

	StartSoundEvent( "Hero_Necrolyte.ProjectileImpact", keys.target )
end

function modifier_mycosis_passive:OnDeath( keys )
	if keys.unit:GetUnitName() == "npc_dota_crimson_shambler_sporeling" and keys.unit:GetOwner() == self:GetCaster() then
		if self:GetCaster():HasScepter() then
	   		local units = FindUnitsInRadius(
				keys.unit:GetTeamNumber(),	-- int, your team number
				keys.unit:GetAbsOrigin(),	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				self:GetAbility():GetSpecialValueFor("aghs_radius"),	-- float, radius. or use FIND_UNITS_EVERYWHERE
				DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
				DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
				0,	-- int, order filter
				false	-- bool, can grow cache
			)

	   		if #units > 0 then
				for i=1, #units do
					if not units[i]:IsMagicImmune() then
						units[i]:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_mycosis_debuff", { duration = self:GetAbility():GetSpecialValueFor("duration") } )
	   				
						StartSoundEvent( "Hero_Broodmother.SpawnSpiderlings", keys.unit )
	   				end
	   			end
	   		end
		end
	end

end