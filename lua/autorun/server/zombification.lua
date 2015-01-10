CreateConVar("zombification_on", "1", {FCVAR_GAMEDLL})
CreateConVar("zombification_chance", "80", {FCVAR_GAMEDLL})
CreateConVar("zombification_nhi", "1", {FCVAR_GAMEDLL})
CreateConVar("zombification_nhi_chance", "10", {FCVAR_GAMEDLL})

local whitelist = {
	"npc_zombie",
	"npc_poisonzombie",
	"npc_fastzombie",
	"npc_zombie_torso",
	"npc_headcrab_fast",
	"npc_headcrab",
	"npc_headcrab_black",
}

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

local headcrabs = {
	"npc_headcrab_fast",
	"npc_headcrab",
	"npc_headcrab_black"
}

local canChageTo = {
	"npc_zombie",
	"npc_fastzombie"
}

resource.AddFile("materials/effects/deadlyzombies/zombie_effect.vmt")
resource.AddFile("materials/effects/deadlyzombies/zombie_effect_dx80.vmt")
resource.AddFile("materials/effects/deadlyzombies/zombie_effect_normal.vtf")
resource.AddFile("materials/effects/deadlyzombies/zombie_effect_overlay.vtf")
resource.AddFile("sound/deadlyzombies/stage2_sound.mp3")

function HandleZombieHit(target, dmginfo)
	if GetConVar("zombification_on"):GetInt() == 1 then
		if target:IsPlayer() or table.HasValue(humans, target:GetClass()) then
			local attacker = dmginfo:GetAttacker()

			if table.HasValue(whitelist, attacker:GetClass()) and !target.infected then
				local chance = GetConVar("zombification_chance"):GetInt()
				local randomnum = math.random(100)

				if randomnum <= chance then
					local infection = ents.Create("zombification_entity")
						infection:SetPos(target:GetPos())
						infection:SetVar("Infected", target)
					infection:Spawn()
					infection:Activate()

					target.infected = true


					if table.HasValue(headcrabs, attacker:GetClass()) then
						attacker:Remove()
					end
				end
			end
		end
	end
end

hook.Add("EntityTakeDamage", "ZombificationOnHit", HandleZombieHit)