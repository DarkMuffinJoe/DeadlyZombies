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

local zombies = {
	"npc_zombie",
	"npc_fastzombie",
	"npc_fastzombie_torso",
	"npc_zombie_torso",
	"npc_poisonzombie"
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
				if v.infected then
					if v.stage != 2 then
						v.infected = false
					else
						v:TakeDamage(20, self,self)
						/*if v:IsPlayer() then
							if math.random(1,4) == 4 then
								v:SendLua("surface.PlaySound(\"npc/zombie_poison/pz_pain\"..math.random(1,3)..\".wav\")")
							end
						end*/
					end
				end
			elseif table.HasValue(zombies, v:GetClass()) then
				v:TakeDamage(20, self,self)
			end
		end

		local part = EffectData()
			part:SetStart( self:GetPos() + Vector(0,0,70) )
			part:SetOrigin( self:GetPos() + Vector(0,0,70) )
			part:SetEntity( self )
			part:SetScale( 1 )
		util.Effect( "curegas", part)

		self.CheckTime = CurTime() + 1
	end

	if CurTime() >= self.DeleteTime then
		self:Remove()
	end
end