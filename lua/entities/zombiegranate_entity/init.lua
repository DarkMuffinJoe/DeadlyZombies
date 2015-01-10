include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

local humans = {
	"npc_alyx",
	"npc_barney",
	"npc_citizen",
	"npc_magnusson",
	"npc_kleiner",
	"npc_mossman",
	"npc_gman",
	"npc_odessa",
	"npc_breen",
	"npc_monk"
}

function ENT:Initialize()
	self:SetModel( "models/weapons/w_grenade.mdl" )
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:DrawShadow(false)

	self.DeleteTime = CurTime() + 60
	self.CheckTime = CurTime()

	self:EmitSound("weapons/explode"..math.random(3,5)..".wav", 130, 100)
end

function ENT:Think()
	if CurTime() >= self.CheckTime then
		local entities = ents.FindInSphere(self:GetPos(), 125)
		for k,v in pairs(entities) do
			if table.HasValue(humans, v:GetClass()) or v:IsPlayer() then
				if !v.infected then
					local infection = ents.Create("zombification_entity")
						infection:SetPos(v:GetPos())
						infection:SetVar("Infected", v)
					infection:Spawn()
					infection:Activate()

					v.infected = true
				end
			end
		end

		local part = EffectData()
			part:SetStart( self:GetPos() + Vector(0,0,70) )
			part:SetOrigin( self:GetPos() + Vector(0,0,70) )
			part:SetEntity( self )
			part:SetScale( 1 )
		util.Effect( "zombiegas", part)

		self.CheckTime = CurTime() + 1
	end

	if CurTime() >= self.DeleteTime then
		self:Remove()
	end
end