if SERVER then
    AddCSLuaFile ("shared.lua")
 
    SWEP.Weight = 5
 
    SWEP.AutoSwitchTo = false
    SWEP.AutoSwitchFrom = false
 
elseif CLIENT then
    SWEP.PrintName = "Cure Gas Granade"
    SWEP.Slot = 4
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
    SWEP.UseHands = true
end
 
SWEP.Author = "DarkMuffinJoe"
SWEP.Contact = "Your Email Address"
SWEP.Purpose = "A granade filled with cure gas."
SWEP.Instructions = "Press LMB or RMB to throw."
SWEP.Category = "Deadly Zombies"
 
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
 
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
SWEP.HoldType = "grenade"
 
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
 
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.AnimOne = 0
//SWEP.AnimTwo = 0
SWEP.IsThrowing = false
//SWEP.IsResting = false
SWEP.CanThrow = false
SWEP.DeleteTime = 0
SWEP.Delete = false

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end
 
function SWEP:Deploy()
    self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
    self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
    self:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
    self.CanThrow = true
end

function SWEP:Think()
    if self.IsThrowing and CurTime() >= self.AnimOne then
        self.Weapon:SendWeaponAnim(ACT_VM_THROW)

        self.IsThrowing = false
        //self.IsResting = true
        self.AnimOne = 0
        //self.AnimTwo = CurTime() + self.Owner:GetViewModel():SequenceDuration()
        self.Delete = true
        self.DeleteTime = CurTime() + self.Owner:GetViewModel():SequenceDuration()

        self:throw_attack()
    end

    /*if self.IsResting and CurTime() >= self.AnimTwo then
        self.Weapon:SendWeaponAnim(ACT_VM_DRAW)

        self.IsThrowing = false
        self.IsResting = false
        self.AnimOne = 0
        self.AnimTwo = 0
        self.CanThrow = true

        self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
        self:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
    end*/

    if self.Delete and CurTime() >= self.DeleteTime then
        self:Remove()
    end
end

function SWEP:throw_attack()
    local tr = self.Owner:GetEyeTrace()
 
    if (!SERVER) then return end
 
    local ent = ents.Create("curegranate")
    ent:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 16))
    ent:SetAngles(self.Owner:EyeAngles())
    ent:Spawn()
 
    local phys = ent:GetPhysicsObject()
 
    if !(phys && IsValid(phys)) then ent:Remove() return end

    phys:ApplyForceCenter(self.Owner:GetAimVector():GetNormalized() *  1000)
end
 
 
function SWEP:PrimaryAttack()
    if !self.CanThrow then return end

    self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    self.IsThrowing = true
    self.IsResting = false
    self.AnimOne = CurTime() + self.Owner:GetViewModel():SequenceDuration()
    self.AnimTwo = 0

    self.CanThrow = false
end
 
function SWEP:SecondaryAttack()
    if !self.CanThrow then return end

    self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    self.IsThrowing = true
    self.IsResting = false
    self.AnimOne = CurTime() + self.Owner:GetViewModel():SequenceDuration()
    self.AnimTwo = 0

    self.CanThrow = false
end
 