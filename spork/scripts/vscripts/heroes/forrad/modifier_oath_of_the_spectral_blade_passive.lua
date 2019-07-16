LinkLuaModifier( "modifier_oath_of_the_spectral_blade", "heroes/forrad/modifier_oath_of_the_spectral_blade.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_oath_of_the_spectral_blade_speed", "heroes/forrad/modifier_oath_of_the_spectral_blade_speed.lua", LUA_MODIFIER_MOTION_NONE )

modifier_oath_of_the_spectral_blade_passive = class({})

function modifier_oath_of_the_spectral_blade_passive:IsHidden()
	return true
end

function modifier_oath_of_the_spectral_blade_passive:IsPurgable()
	return false
end

function modifier_oath_of_the_spectral_blade_passive:IsPermanent()
	return true
end

function modifier_oath_of_the_spectral_blade_passive:OnCreated()
	if IsServer() then 
		self.credit = 0
	end
	self:StartIntervalThink(0.1)
end

function modifier_oath_of_the_spectral_blade_passive:OnIntervalThink()
	if IsServer() then
		if self:GetParent():IsAlive() and self:GetStackCount() < 100 then
			self:IncrementStackCount()
		elseif self:GetStackCount() == 100 and self.credit ~= 0 then
			self.credit = 0
		end

		if self:GetParent():GetHealth() == 1 then 

			self:GetParent():EmitSound( "Hero_Oracle.FalsePromise.Healed" )

			self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_oath_of_the_spectral_blade", { duration = self:GetAbility():GetSpecialValueFor("duration") } )
			if self.credit:GetPlayerOwnerID() ~= nil then
				self:GetParent():FindModifierByName("modifier_oath_of_the_spectral_blade"):SetStackCount( self.credit:GetPlayerOwnerID() )
			end
		end
	end
end

function modifier_oath_of_the_spectral_blade_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_oath_of_the_spectral_blade_passive:GetMinHealth()
	if self:GetAbility():IsCooldownReady() then
		return 1
	else
		return 0
	end
end

function modifier_oath_of_the_spectral_blade_passive:OnAttackLanded( keys )
	if keys.attacker == self:GetParent() then
		self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_oath_of_the_spectral_blade_speed", { duration = 1.5 } )
	end
end

function modifier_oath_of_the_spectral_blade_passive:OnTakeDamage( keys )
	if keys.unit == self:GetParent() and IsServer() and self:GetAbility():IsCooldownReady() then
		if keys.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			self.credit = keys.attacker
			self:SetStackCount(0)
		end
	end
end