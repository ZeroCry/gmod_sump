
-- Code writen by ttyk (http://ttyk.ru/ ;  admin@ttyk.ru ; Skype: ttyk.v)
-- Project name: gm_sump ( Freeware )
-- TPID: 00Fx004
-- file modified: 10/22/2015

AddCSLuaFile()
include("shared.lua")

surface.CreateFont( "SUMP_h1", {
	font = "Tahoma",
	size = 15,
	weight = 500,
	antialias = true
} )

surface.CreateFont( "SUMP_h2", {
	font = "Tahoma",
	size = 20,
	weight = 1000,
	antialias = true,
	shadow = true, 
} )

function ENT:Draw()
	
	self:DrawModel()

	if LocalPlayer():EyePos( ):Distance(self.Entity:GetPos()) > 1000 then return end 
	
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local player = LocalPlayer()
	
	local tr = util.GetPlayerTrace(player, Pos)
	local tr = util.TraceLine(tr)

	local hclr = Color(0,0,0,200)
	local oclr = Color(0,0,0,100)
	local aclr = Color(255,191, 0, 255)
	
	--DynVariables
	local PrintTime = self:GetNWInt( "PrintTime" )
	local PrintAmount = self:GetNWInt( "PrintAmount" )
	local isPowered = self:GetNWInt( "powered" )
	local UpgradeCost = self:GetNWInt( "NextCost" )
	local AddonCooler = self:GetNWBool( "addon_cooler" )
	local AddonStorage = self:GetNWBool("addon_storage")
	local PrinterStorage = tostring(self:GetNWInt("printer_storage")).."$"
		
	--Heatbar
	local WHeatBar = 250
	local HeatLevel = self:GetNWInt( "printer_heatlevel" )  / 100
	local CWHeatBar = WHeatBar*HeatLevel
	if HeatLevel == 0.0 then
		HeatColor = Color(0,0,0,0)
	elseif HeatLevel <= 0.3 then
		HeatColor = Color(50,255,50,200)
	elseif HeatLevel <= 0.7 then
		HeatColor = Color(255,255,50,200)
	elseif HeatLevel <= 1 then
		HeatColor = Color(255,50,50,200)
	end
	
	--Status
	local BText1
	
	local PStatus
	
	if self:GetNWBool( "printer_status" ) then
		
		PSColor = Color(50,255,50,200)
		
		BText1 = "Turn off"
		
		PStatus = "On"
	
	else 
	
		PSColor = Color(255,50,50,200)
		
		BText1 = "Turn on"
		
		PStatus = "Off"
		
	end

	--print(PrintTime,PrintAmount,isPowered,UpgradeCost, PStatus, HeatLevel )
		
	local PLevel = self:GetNWInt( "CurrentLevel" )
	local PMLevel = self:GetNWInt("MaxLevel")
	
	local owner = self:Getowning_ent() 
	local POwner = (IsValid(owner) and owner:Nick()) or "ttyk"

	--Texts
	local Text1 = "Status: "..PStatus
	local Text2 = "Heated "..tostring(HeatLevel*100).."%"
	local Text3 = "Level "..tostring(PLevel).."/"..tostring(PMLevel)
	local Text4 = string.format("%i$/%i Seconds", PrintAmount,  PrintTime)
	local Text5 = "Modules are not installed."
	local Text6 = "(You can buy them ingame shop)"
	local Text7 = "Cooler installed."
	local Text8 = "Storage:"
	
	local PHint = "Press E, for actions"
	--local PCopy = "OldRP Улучшаемый принтер"
	
	local BText2 = "Upgrade for "..UpgradeCost.."$"
	
	surface.SetFont("HUDNumber5")
	local TextWidth1 = surface.GetTextSize(Text1)
	local TextWidth2 = surface.GetTextSize(Text2)
	local TextWidth3 = surface.GetTextSize(Text3)
	local TextWidth4 = surface.GetTextSize(Text4)
	local POwnerWidth = surface.GetTextSize(POwner)
	local StorageWidth = surface.GetTextSize(PrinterStorage)
	
	local BTextWidth1 = surface.GetTextSize(BText1)
	local BTextWidth2 = surface.GetTextSize(BText2)
	
	surface.SetFont("SUMP_h1")
	local PHintWidth = surface.GetTextSize(PHint)
	--local PCopyWidth = surface.GetTextSize(PCopy)
	local TextWidth6 = surface.GetTextSize(Text6)
	
	surface.SetFont("SUMP_h2")
	local TextWidth5 = surface.GetTextSize(Text5)
	local TextWidth7 = surface.GetTextSize(Text7)
	local TextWidth8 = surface.GetTextSize(Text8)
	
	
	local t = {}
	t.start = player:GetShootPos()
	t.endpos = player:GetAimVector() * 128 + t.start
	t.filter = player
	local tr = util.TraceLine(t)
	local pos = self.Entity:WorldToLocal(tr.HitPos)
	
	Ang:RotateAroundAxis(Ang:Up(), 90)
	
	cam.Start3D2D(Pos + Ang:Up() * 11.5, Ang, 0.11)
		
		--Device title
		--draw.WordBox(2, -130,-145, PCopy, "SUMP_h1", oclr, Color(0, 0, 255, 255))
		
		--status
		if (tr.Entity == self) and pos.x>-14 and pos.x<-9 then 
			clr1=hclr 
			tclr1=aclr
			txt1=BText1 
			txtw1=BTextWidth1
		else 
			clr1=oclr
			tclr1=PSColor
			txt1=Text1 
			txtw1=TextWidth1	
		end
		
		draw.WordBox(2, -txtw1*0.5, -118, txt1, "HUDNumber5", clr1, tclr1)
		
		--heatbar		
		draw.RoundedBox(0,-WHeatBar*0.5, -70, WHeatBar, 40,  oclr )
		draw.RoundedBox(5, -(CWHeatBar-20)*0.5, -60, CWHeatBar-20, 25, HeatColor)
		draw.WordBox(2, -TextWidth2*0.5, -65, Text2, "HUDNumber5", Color(0, 0, 0, 0), Color(0, 0, 255, 255))
	
		--money
		draw.WordBox(2, -TextWidth4*0.5, -25, Text4, "HUDNumber5", oclr, Color(0, 0, 255, 255))
		
		--level
		if (tr.Entity == self) and pos.x>2 and pos.x<6 and PMLevel != PLevel then
			clr2=hclr 
			tclr2=aclr
			txt2=BText2 
			txtw2=BTextWidth2
		else 
			clr2=oclr
			tclr2=Color(0, 0, 255, 255)
			txt2=Text3 
			txtw2=TextWidth3	
		end
		draw.WordBox(2, -txtw2*0.5, 15, txt2, "HUDNumber5", clr2, tclr2)
		
		--hint	
		if (tr.Entity == self) then
			draw.WordBox(2, -PHintWidth*0.5, 55, PHint, "SUMP_h1", oclr, Color(0, 0, 255, 255))
		end
		--owner
		draw.WordBox(2, -POwnerWidth*0.5, 95, POwner, "HUDNumber5", oclr, Color(255,191, 0, 255))
	cam.End3D2D()
	
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	
	cam.Start3D2D(Pos + Ang:Up() * 17, Ang, 0.11)
		draw.RoundedBox(0,-WHeatBar*0.5, -90, WHeatBar, 80,  hclr )
		
		if !AddonCooler and !AddonStorage then
			draw.WordBox(2, -TextWidth5*0.5, -65, Text5, "SUMP_h2", Color(0, 0, 0, 0), Color(255, 0, 0, 255))
			draw.WordBox(2, -TextWidth6*0.5, -35, Text6, "SUMP_h1", Color(0, 0, 0, 0), Color(255, 0, 0, 255))
		end
	
		if AddonCooler then
			draw.WordBox(2, -TextWidth7*0.8, -95, Text7, "SUMP_h2", Color(0, 0, 0, 0), Color(100, 100, 255, 255))
		end
		
		if AddonStorage then
			draw.WordBox(2, -TextWidth8*0.5, -70, Text8, "SUMP_h2", Color(0, 0, 0, 0), Color(100, 100, 255, 255))
			draw.WordBox(2, -StorageWidth*0.5, -50, PrinterStorage, "HUDNumber5", Color(0, 0, 0, 0), Color(255,191, 0, 255))
		end
	
	cam.End3D2D()
	-- Drawing money bank

end
