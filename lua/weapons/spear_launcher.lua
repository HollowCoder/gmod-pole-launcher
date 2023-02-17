SWEP.PrintName = "Spear Launcher"
SWEP.Author	= "NinjaLuigi"
SWEP.Instructions = "A spear launcher using the crossbow model" 

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = 1 
SWEP.Primary.DefaultClip = 5 
SWEP.Primary.Automatic = false 
SWEP.Primary.Ammo = "weapon_crossbow ammo"

SWEP.Secondary.ClipSize	= -1 
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo	= "none"

SWEP.Weight	= 5 
SWEP.AutoSwitchTo = false 
SWEP.AutoSwitchFrom	= false
SWEP.UseHands = true

SWEP.Slot = 4
SWEP.SlotPos = 3
SWEP.DrawAmmo = true 
SWEP.DrawCrosshair = true

SWEP.ViewModel	= "models/weapons/c_crossbow.mdl"
SWEP.WorldModel	= "models/weapons/w_crossbow.mdl"

local ScopeLevel = 0
local power = 5000000
local ShootSound = Sound( "weapons/crossbow/fire1.wav" )


function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
	self:Shoot(power)
end

function SWEP:SecondaryAttack()
    self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)
	if(ScopeLevel == 0) then //zoom level 1.

 
		if(SERVER) then
			self.Owner:SetFOV( 45, 0 )
		end	
 
		ScopeLevel = 1
 
	else if(ScopeLevel == 1) then //zoom level 2.

 
		if(SERVER) then
			self.Owner:SetFOV( 25, 0 )
		end	
 
		ScopeLevel = 2
 
	else //no zoom.

		if(SERVER) then
			self.Owner:SetFOV( 0, 0 )
			//FOV reset
		end		
 
		ScopeLevel = 0
 
	end
	end
 
end


function SWEP:Shoot(power)
	self:EmitSound( ShootSound )  
	if ( CLIENT ) then return end
	
	local ent = ents.Create( "prop_physics" )

	if ( !IsValid( ent ) ) then return end

	ent:SetModel("models/props_c17/signpole001.mdl") 

	ent:SetPos( self.Owner:EyePos() + ( self.Owner:GetAimVector() * 5 ))
    eyeAngles = self.Owner:EyeAngles()
    eyeAngles:Add(Angle(90, 0, 0))
	ent:SetAngles(eyeAngles)
	ent:Spawn()


	local phys = ent:GetPhysicsObject()
	if ( !IsValid( phys ) ) then ent:Remove() return end


	local velocity = self.Owner:GetAimVector()
	velocity = velocity * power
	--velocity = velocity + ( VectorRand() * 1000 )
	phys:ApplyForceCenter( velocity )

	cleanup.Add( self.Owner, "props", ent )

	undo.Create( "Spear" ) 
	undo.AddEntity( ent )
	undo.SetPlayer( self.Owner )
	undo.Finish()
end

list.Add("Weapons", "spear_launcher",{
    Name = "Spear Launcher",
    Class = "spear_launcher",
    Category = "other"
})