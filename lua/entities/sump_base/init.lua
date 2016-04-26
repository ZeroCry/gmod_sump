
-- Code writen by ttyk (http://ttyk.ru/ ;  admin@ttyk.ru ; Skype: ttyk.v)
-- Project name: gm_sump ( Freeware )
-- TPID: 00Fx004
-- file modified: 10/22/2015

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	
	self:SetNWBool( "printer_status", false )
	self:SetNWBool( "addon_cooler", false )
	self:SetNWBool( "addon_storage", false ) 
	self:SetNWInt( "printer_storage", 0 )
	self:SetNWInt( "CurrentLevel", 0 )	
	
	self:SetModel( SUMP.BaseModel )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	
	local phys = self:GetPhysicsObject()

	phys:Wake()	
	
	SUMP:UpgradePrinter( true, self )
	
	self:CreateMoneybag()
	
	self:CoolDown()
	
end

function ENT:Use( Activator )

	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local Ply = Activator
	
	local tr = util.GetPlayerTrace( Ply, ang )
	local tr = util.TraceLine(tr)
	
	local t = {}
		t.start = Ply:GetShootPos()
		t.endpos = Ply:GetAimVector() * 128 + t.start
		t.filter = Ply
		
	local tr = util.TraceLine(t)
	
	local pos = self.Entity:WorldToLocal(tr.HitPos)
	
	if tr.Entity == self and pos.x > -14 and pos.x < -9 then -- Turn on and off
		
		if self:GetNWBool( "printer_status" ) then
		
			self:SetNWBool( "printer_status", false ) 
			
			DarkRP.notify( Ply, 2, 4, "Printer turned off." )		
			
		else
		
			self:SetNWBool( "printer_status", true )
			
			DarkRP.notify( Ply, 2, 4, "Printer turned on." ) 
			
		end

	elseif tr.Entity == self and pos.x > 2 and pos.x < 6 then -- Upgrade button

		SUMP:UpgradePrinter( Ply, self )
		
	end
	
	local amount = self:GetNWInt( "printer_storage" )
	
	if self:GetNWInt( "printer_storage" ) > 0 then
	
		DarkRP.notify( Ply, 0, 4, "You have collected " .. tostring( self:GetNWInt( "printer_storage" ) ) .. "$ from a printer." )
		
		Ply:addMoney(amount)
		
		self:SetNWInt( "printer_storage", 0 )
		
	end
	
end

function ENT:PhysicsCollide( ColData, Collider )

	if IsEntity( ColData.HitEntity ) then
	
		if ColData.HitEntity:GetClass() == "sump_cooler"  then 
		
			ColData.HitEntity:Remove()
			
			self:SetNWBool( "addon_cooler", true ) 
			
		elseif ColData.HitEntity:GetClass() == "sump_storage"  then
		
			ColData.HitEntity:Remove()
			
			self:SetNWBool( "addon_storage", true ) 
			
		end
		
	end	
	
end

function ENT:OnTakeDamage( Dmg )

	self:SetNWInt( "Health", 
		
		self:GetNWInt( "Health" ) - Dmg:GetDamage() 
	
	)
	
	if self:GetNWInt( "Health" ) < 0 then
	
		self:Destruct()
		
	end

end

function ENT:CoolDown( )

	if !IsValid( self ) then return end

	local HeatLevel = self:GetNetworkedInt( "printer_heatlevel" )
	
	if HeatLevel >= 1 then
	
		local calc = HeatLevel - 1
		
		self:SetNWInt( "printer_heatlevel", calc )
		
	end
	
	local boost = 1
	
	if self:GetNetworkedBool( "addon_cooler" ) then
	
		boost = 1.3
		
	end
	
	local CoolerSpeed = self:GetNetworkedInt( "CoolMultiply" ) / boost
	
	if not self:GetNWBool( "printer_status" ) then
	
		CoolerSpeed = CoolerSpeed / 2
		
	end
	
	timer.Simple( CoolerSpeed, function() if self:IsValid( ) then self:CoolDown( ) end end)

end 

function ENT:BurstIntoFlames()

	DarkRP.notify( self:Getowning_ent(), 0, 4, "Your printer is overheated!" )
	
	self.burningup = true
	
	local burntime = math.random( 8, 18 )
	
	self:Ignite( burntime, 0 )
	
	timer.Simple( burntime, function() if self:IsValid() then self:Destruct() end end ) 
	
end

function ENT:Destruct()

	local HeatLevel = self:GetNWInt( "printer_heatlevel" )
	
	if HeatLevel >= 99 or self:GetNWInt( "Health" ) < 0 then
	
		local vPoint = self:GetPos()
		
		local effectdata = EffectData()
		
			effectdata:SetStart( vPoint )
			
			effectdata:SetOrigin( vPoint ) 
			
			effectdata:SetScale( 1 )
		
		util.Effect( "Explosion", effectdata )
		
		DarkRP.notify( self:Getowning_ent(), 1, 4, "Your printer has been destroyed!" )
		
		self:Remove()
		
	end
	
end

function ENT:CreateMoneybag()
	
	local Pos = self:GetPos()
	
	local Ang = self:GetAngles()

	local PrintTime = self:GetNetworkedInt( "PrintTime" ) --/ 10 --TEST
	
	if SUMP.UseRandom then
	
		PrintTime = math.random( PrintTime * .8, PrintTime )
	
	end
	
	local PrintAmount = self:GetNetworkedInt( "PrintAmount" )

	if self:GetNWBool( "printer_status" ) then
	
		local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetMagnitude(1)
			effectdata:SetScale(1)
			effectdata:SetRadius(2)
			util.Effect("Sparks", effectdata)
		
		if self:GetNWBool( "addon_storage" ) then
		
			self:SetNWInt( "printer_storage", self:GetNWInt( "printer_storage" ) + PrintAmount )
		
		else
		
			Ang:RotateAroundAxis(Ang:Up(), 90)
			
			Ang:RotateAroundAxis(Ang:Forward(), 90)
		
			DarkRP.createMoneyBag( Pos + Ang:Up() * 25, PrintAmount )
			
		end
		
		local HeatSpeed = self:GetNetworkedInt( "HeatMultiply" )
		
		local HeatLevel = self:GetNetworkedInt( "printer_heatlevel" )
		
		local calc = HeatLevel+HeatSpeed

		self:SetNWInt( "printer_heatlevel", calc )
		
		if calc >= 90 then
		
			self:BurstIntoFlames()
			
		end	
		
	end
	
	timer.Simple( PrintTime, function() if self:IsValid() then self:CreateMoneybag() end end )
	
end

