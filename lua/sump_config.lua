
-- Code writen by ttyk (http://ttyk.ru/ ;  admin@ttyk.ru ; Skype: ttyk.v)
-- Project name: gm_sump ( Freeware )
-- TPID: 00Fx004
-- file modified: 10/22/2015 


-- ==========================SETTINGS==========================

SUMP.AllowGroups = { "superadmin", "admin" } -- Allow theese groups to buy any upgrades

SUMP.UseRandom = true --Use "random()" functions for printamount, heatmultiply and etc. 

SUMP.InternalStorageSize = 20000 --How much money printer can store inside itself with storage upgrade

SUMP.BaseModel = "models/props_c17/consolebox01a.mdl" 
SUMP.CoolerModel =  "models/props_lab/tpplugholder_single.mdl"
SUMP.StorageModel = "models/props_lab/partsbin01.mdl"


-- ==========================UPGRADES==========================

SUMP.Upgrades = {} -- Clear upgrades before adding new. ( In case if this file gets refreshed multiple times )

-- Level 1
SUMP:AddNewUpgrade( { -- First upgrade is going to be a base for a printer

	["Cost"] = 0, --Cost for upgrade 
	
	["PrintTime"] = 90, --How much time need for cycle
	
	["PrintAmount"] = 250, --How much printer would print per cycle
	
	["HeatMultiply"] = 25, --How much would printer heat up per cycle
	
	["CoolMultiply"] = 10, --How much seconds would need printer to cool down in ON state
	
	["Health"] = 100, --How much health printer has
	
	["Allowed"] = { "*" } --Allow groups to upgrade
	
} ) 

-- Level 2
SUMP:AddNewUpgrade( { 

	["Cost"] = 2000,
	
	["PrintTime"] = 85, 
	
	["PrintAmount"] = 500, 
	
	["HeatMultiply"] = 19, 
	
	["CoolMultiply"] = 9,
	
	["Health"] = 105,
	
	["Allowed"] = { "*" } 
	
} ) 

-- Level 3
SUMP:AddNewUpgrade( { 

	["Cost"] = 3500,
	
	["PrintTime"] = 80, 
	
	["PrintAmount"] = 750, 
	
	["HeatMultiply"] = 17, 
	
	["CoolMultiply"] = 9,
	
	["Health"] = 125,
	
	["Allowed"] = { "*" } 
	
} ) 

-- Level 4
SUMP:AddNewUpgrade( { 

	["Cost"] = 5500,
	
	["PrintTime"] = 75, 
	
	["PrintAmount"] = 950, 
	
	["HeatMultiply"] = 16, 
	
	["CoolMultiply"] = 8,
	
	["Health"] = 155,
	
	["Allowed"] = { "*" } 
	
} ) 

-- Level 5
SUMP:AddNewUpgrade( { 

	["Cost"] = 8000,
	
	["PrintTime"] = 70, 
	
	["PrintAmount"] = 1300, 
	
	["HeatMultiply"] = 16, 
	
	["CoolMultiply"] = 7,
	
	["Health"] = 200,
	
	["Allowed"] = { "*" } 
	
} ) 

-- Level 6
SUMP:AddNewUpgrade( { 

	["Cost"] = 15000,
	
	["PrintTime"] = 60, 
	
	["PrintAmount"] = 950, 
	
	["HeatMultiply"] = 15, 
	
	["CoolMultiply"] = 7,
	
	["Health"] = 220,
	
	["Allowed"] = { "premium", "vip" } --(* Example *) Allow to the premium and vip players only ##Require ULX to work
	
} ) 
