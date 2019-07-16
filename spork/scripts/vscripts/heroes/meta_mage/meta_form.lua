LinkLuaModifier( "modifier_meta_form", "heroes/meta_mage/modifier_meta_form.lua", LUA_MODIFIER_MOTION_NONE )

meta_form = class({})

function meta_form:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function meta_form:OnSpellStart()
	local caster = self:GetCaster()

	-- Check if the caster has the talent
	local duration = self:GetSpecialValueFor("duration")
	local talent = caster:FindAbilityByName("meta_mage_talent_w")
	if talent and talent:GetLevel() > 0 then
		duration = duration + talent:GetSpecialValueFor("value")
	end

	-- Find all the nearby allied hero units
	local units = FindUnitsInRadius(
		caster:GetTeamNumber(),					-- int, your team number
		caster:GetAbsOrigin(),					-- point, center point
		nil,									-- handle, cacheUnit. (not known)
		self:GetSpecialValueFor("radius"),		-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,			-- enum, team filter
		DOTA_UNIT_TARGET_HERO,					-- enum, type filter
		DOTA_UNIT_TARGET_FLAG_NONE,				-- enum, flag filter
		FIND_CLOSEST,							-- enum, order filter
		false									-- bool, can grow cache
	)

	-- Only save the real, non-illusion heroes
	local heroes = {}
	for i=1, #units do
		if units[i]:IsRealHero() then
			table.insert(heroes, units[i])
		end
	end

	-- Apply the modifier to the caster and to the nearest allied hero (if there is one)
	-- Lua tables start at 1 not 0, and the caster is always unit 1
	caster:AddNewModifier( caster, self, "modifier_meta_form", { duration = duration } )
	if heroes[2] ~= nil then
		heroes[2]:AddNewModifier( caster, self, "modifier_meta_form", { duration = duration } )
	end
end

