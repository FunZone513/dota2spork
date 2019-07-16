spirit_strike_think = class({})

function spirit_strike_think:IsHidden()
	return true
end

function spirit_strike_think:IsPurgable()
	return false
end

function spirit_strike_think:IsPermanent()
	return true
end

if IsServer() then
	function spirit_strike_think:OnCreated()
		self:StartIntervalThink(0.1)
	end

	function spirit_strike_think:OnIntervalThink()
	
		local talent = self:GetParent():FindAbilityByName("forrad_talent_q")
		if talent and talent:GetLevel() > 0 then
			_G.AbilitySwap( self:GetParent(), "spirit_strike", "spirit_strike_talent" )
			self:Destroy()
		end
	end
end