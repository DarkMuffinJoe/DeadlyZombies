include("shared.lua")

function ENT:Draw()
end

function ENT:Initialize()
	local emitter = ParticleEmitter( self:GetPos() )
	local particle = emitter:Add( "effects/freeze_unfreeze", self:GetPos() )
end