modifier_honour_of_the_dead_movement = class({})

function modifier_honour_of_the_dead_movement:IsHidden()
	return false
end

function modifier_honour_of_the_dead_movement:IsDebuff()
	return true
end

function modifier_honour_of_the_dead_movement:IsPurgable()
	return false
end

function modifier_honour_of_the_dead_movement:IsStunDebuff()
	return true
end

function modifier_honour_of_the_dead_movement:GetPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end

function modifier_honour_of_the_dead_movement:GetEffectName()
	return "particles/units/heroes/hero_bane/bane_slime_trail.vpcf"
end

--------------------------------------------------------------------------------

function modifier_honour_of_the_dead_movement:CheckState()
  	local state = {
    	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  	}
	return state
end

function modifier_honour_of_the_dead_movement:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
	return funcs
end

function modifier_honour_of_the_dead_movement:GetOverrideAnimation()
  return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

if IsServer() then
	function modifier_honour_of_the_dead_movement:OnCreated( event )
		-- Movement parameters
		math.randomseed( string.sub( GetSystemTime(), string.len(GetSystemTime()) - 1, string.len(GetSystemTime()) ) )
		local parent = self:GetParent()
		self.direction = ( self:GetCaster():GetAbsOrigin() -  parent:GetAbsOrigin() ):Normalized()
		self.distance = ( self:GetCaster():GetAbsOrigin() - parent:GetAbsOrigin() ):Length2D() * math.random(0.4, 0.7)
		self.speed = 1000 -- redo this
		self.tree_radius = 200

		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end
	end

--------------------------------------------------------------------------------

	function modifier_honour_of_the_dead_movement:OnDestroy()
		local parent = self:GetParent()

		parent:FadeGesture( ACT_DOTA_RUN )
		parent:RemoveHorizontalMotionController( self )
		ResolveNPCPositions( parent:GetAbsOrigin(), 128 )
	end

--------------------------------------------------------------------------------

	function modifier_honour_of_the_dead_movement:UpdateHorizontalMotion( parent, deltaTime )
		local parentOrigin = parent:GetAbsOrigin()

		local tickSpeed = self.speed * deltaTime
		tickSpeed = math.min( tickSpeed, self.distance )
		local tickOrigin = parentOrigin + ( tickSpeed * self.direction )

		parent:SetAbsOrigin( tickOrigin )

		self.distance = self.distance - tickSpeed

		GridNav:DestroyTreesAroundPoint( tickOrigin, self.tree_radius, false )
	end

--------------------------------------------------------------------------------

	function modifier_honour_of_the_dead_movement:OnHorizontalMotionInterrupted()
		self:Destroy()
	end
end