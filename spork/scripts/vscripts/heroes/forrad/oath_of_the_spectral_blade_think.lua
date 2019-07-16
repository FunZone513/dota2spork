oath_of_the_spectral_blade_think = class({})

function oath_of_the_spectral_blade_think:IsHidden()
	return true
end

function oath_of_the_spectral_blade_think:IsPurgable()
	return false
end

function oath_of_the_spectral_blade_think:IsPermanent()
	return true
end

if IsServer() then
	function oath_of_the_spectral_blade_think:OnCreated()
		self:StartIntervalThink(0.1)
	end

	function oath_of_the_spectral_blade_think:OnIntervalThink()

		local talent = self:GetParent():FindAbilityByName("forrad_talent_w")
		if talent and talent:GetLevel() > 0 then
			_G.AbilitySwap( self:GetParent(), "oath_of_the_spectral_blade", "oath_of_the_spectral_blade_talent" )
			self:Destroy()
		end
	end
end