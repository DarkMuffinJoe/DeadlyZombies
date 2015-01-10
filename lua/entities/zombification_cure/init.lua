include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_lab/jar01b.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
		phys:Wake()

	self:SetUseType(SIMPLE_USE)
end

function ENT:Use(activator)
	if activator:IsValid() and activator:IsPlayer() then
		if activator.infected then
			if activator.stage != 2 then
				activator.infected = false
			end
		end
		self:Remove()
	end
end
