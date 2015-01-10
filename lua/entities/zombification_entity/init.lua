include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

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

local canChageTo = {
	"npc_zombie",
	"npc_fastzombie"
}

function ENT:Initialize()
	self:SetModel("models/props_interiors/pot01a.mdl")
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:DrawShadow(false)

	self:SetNWEntity("Infected", self:GetVar("Infected"))
	self.infected = self:GetVar("Infected")

	self.Progress = 0
	self:SetNWBool("2stage", false)
	self.infected.stage = 1

	if self.infected:IsPlayer() then
		self.maxWalkSpeed = self.infected:GetWalkSpeed()
		self.maxRunSpeed = self.infected:GetRunSpeed()
		self.maxJumpPower = self.infected:GetJumpPower()
	end

	self.nhiOn = GetConVar("zombification_nhi"):GetInt()
	self.nhiChance = GetConVar("zombification_nhi_chance"):GetInt()

	self.nhiInterval = 0
	self.nhiTriedToInfect = {}
end

function ENT:Think()
	if !self:IsValid() then return end
	if !self.infected:IsValid() then
		self:Remove()
	end
	if self.infected:IsPlayer() then
		if !self.infected:Alive() then
			self:Remove()
		end
	end
	if !self.infected.infected then
		self:Remove()
	end

	self.Progress = self.Progress + 1

	if self.Progress >= 300 then
		if self.infected:IsPlayer() then
			self.infected:SetWalkSpeed(self.maxWalkSpeed - self.maxWalkSpeed/(1200 / self.Progress))
			self.infected:SetRunSpeed(self.maxRunSpeed - self.maxRunSpeed/(1200 / self.Progress))
			self.infected:SetJumpPower(self.maxJumpPower - self.maxJumpPower/(1200 / self.Progress))

			if !self:GetNWBool("2stage") then
				self:SetNWBool("2stage", true)
				self.infected.stage = 2
			end
		end
	end
	if self.Progress >= 1200 then
		local zombietobecome = canChageTo[math.random(#canChageTo)]
		local zombie = ents.Create(zombietobecome)
			zombie:SetPos(self.infected:GetPos())
			zombie:SetAngles(self.infected:GetAngles())

		zombie:Spawn()
		zombie:SetBodygroup(1, 0)

		if self.infected:IsPlayer() then
			self.infected:KillSilent()

			self.infected:Spectate(OBS_MODE_CHASE)
			self.infected:SpectateEntity(zombie)
		else
			self.infected:Remove()
		end

		self:Remove()
	end

	if self.nhiOn == 1 and self.nhiInterval <= CurTime() and self.infected:IsValid() then
		local entities = ents.FindInSphere(self.infected:GetPos(), 60)
		for k, v in pairs (entities) do
			if (v:IsPlayer() or table.HasValue(humans, v:GetClass())) and !v.infected then
				if !table.HasValue(self.nhiTriedToInfect, v) then
					local randomnum = math.random(100)
					if randomnum <= self.nhiChance then
						local inf = ents.Create( self:GetClass() )
							inf:SetPos(v:GetPos())
							inf:SetVar("Infected", v)
						inf:Spawn()
						inf:Activate()
						inf:SetHealth(200)

						v.infected = true
					end
					table.insert(self.nhiTriedToInfect, v)
				end
			end
		end
		self.nhiInterval = CurTime() + 1
	end

	self:NextThink(CurTime()+0.1)
end

function ENT:OnRemove()
	if self.infected:IsValid() then
		if self.infected:IsPlayer() then
			self.infected:SetWalkSpeed(self.maxWalkSpeed)
			self.infected:SetRunSpeed(self.maxRunSpeed)
			self.infected:SetJumpPower(self.maxJumpPower)
		end

		self.infected.infected = false
	end
end