LinkLuaModifier( "modifier_mycosis_passive", "heroes/crimson_shambler/modifier_mycosis_passive.lua", LUA_MODIFIER_MOTION_NONE )

mycosis = class({})

function mycosis:GetIntrinsicModifierName()
	return "modifier_mycosis_passive"
end