
-- Code writen by ttyk (http://ttyk.ru/ ;  admin@ttyk.ru ; Skype: ttyk.v)
-- Project name: gm_sump ( Freeware )
-- TPID: 00Fx004
-- file modified: 10/22/2015

resource.AddFile( "materials/vgui/entities/sump.vtf" )

SUMP = {}

SUMP.Version = "0.1d"

function SUMP.New()

	local object = {};
	
	setmetatable(object,{__index = SUMP});
	
	return object;
	
end 

if SERVER then

	function SUMP:ConfigError()
		
		print( "Error in config file of SUMP ( Simple Upgradeable Money Printer )" )
		
		return 0
	
	end

	SUMP.Upgrades = {}

	function SUMP:AddNewUpgrade( DATA )
		
		SUMP.Upgrades[ #SUMP.Upgrades + 1 ] = {
			
			["Cost"] = DATA.Cost or SUMP:ConfigError(),
			
			["PrintAmount"] = DATA.PrintAmount or SUMP:ConfigError(),
			
			["PrintTime"] = DATA.PrintTime or SUMP:ConfigError(),
			
			["HeatMultiply"] = DATA.HeatMultiply or SUMP:ConfigError(),
			
			["CoolMultiply"] = DATA.CoolMultiply or SUMP:ConfigError(),
			
			["Health"] = DATA.Health or SUMP:ConfigError(),
			
			["Allowed"] = DATA.Allowed or { "*" },
			
		}
		
	end
	
	function SUMP:UpgradePrinter( Ply, Printer )
	
		local NextUpgrade = {}
		
		if Ply == true then -- If first upgrade
		
			NextUpgrade = SUMP.Upgrades[ 1 ]
						
			Printer:SetNWInt( "MaxLevel", #SUMP.Upgrades )
		
		elseif IsValid( Ply ) then
		
			if #SUMP.Upgrades == Printer:GetNWInt( "CurrentLevel" ) then return end
		
			NextUpgrade = SUMP.Upgrades[ Printer:GetNWInt( "CurrentLevel" ) + 1 ]
						
			if 	not table.HasValue( NextUpgrade.Allowed, "*" ) 
					and 
				not table.HasValue( NextUpgrade.Allowed, Ply:GetUserGroup() ) 
					and 
				not table.HasValue( SUMP.AllowGroups, Ply:GetUserGroup() ) 
					and 
				not Ply:IsAdmin() 
					and 
				not Ply:IsSuperAdmin() then  --Lol that statement 
			
					DarkRP.notify( Ply, 1, 4, "You dont have permission for upgrade!" )
				
					return
			
			end
			
			if not Ply:canAfford( NextUpgrade.Cost ) then 
				
				DarkRP.notify( Ply, 1, 4, "You have not enought money!" )
				
				return
				
			end
			
			
			Ply:addMoney( -NextUpgrade.Cost  )
			
			DarkRP.notify( Ply, 0, 4, "Printer was succsessfully upgraded to the level: "..tostring( Printer:GetNWInt( "CurrentLevel" ) + 1 ) )
			
		end

		if NextUpgrade == nil then print("sump upgrade error") return end
				
		Printer:SetNWInt( "PrintAmount", NextUpgrade.PrintAmount )
		Printer:SetNWInt( "PrintTime", NextUpgrade.PrintTime )
		Printer:SetNWInt( "HeatMultiply", NextUpgrade.HeatMultiply )
		Printer:SetNWInt( "CoolMultiply", NextUpgrade.CoolMultiply )
		Printer:SetNWInt( "Health", NextUpgrade.Health )	
		
		Printer:SetNWInt( "CurrentLevel", Printer:GetNWInt( "CurrentLevel" ) + 1 )
		Printer:SetNWInt( "NextCost", (SUMP.Upgrades[ Printer:GetNWInt( "CurrentLevel" ) + 1 ] or {}).Cost )		
		
	end

	include( "sump_config.lua" ) 
	
end