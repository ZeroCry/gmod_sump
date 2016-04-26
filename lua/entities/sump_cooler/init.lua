
-- Code writen by ttyk (http://ttyk.ru/ ;  admin@ttyk.ru ; Skype: ttyk.v)
-- Project name: gm_sump ( Freeware )
-- TPID: 00Fx004
-- file modified: 10/22/2015
 

AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel( SUMP.CoolerModel ) 
	self:SetMaterial("phoenix_storms/metalset_1-2")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	    
	self:SetUseType(SIMPLE_USE)
	phys:Wake()	
end
