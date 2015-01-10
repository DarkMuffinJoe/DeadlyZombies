include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:Initialize()
	self:SetModel( "models/weapons/w_grenade.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox

	self.ExplodeTime = CurTime() + 5
 
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Think()
	if CurTime() >= self.ExplodeTime then
		local fx = ents.Create("curegranate_entity")
			fx:SetPos(self:GetPos())
		fx:Spawn()
		fx:Activate()
		self:Remove()
	end
end