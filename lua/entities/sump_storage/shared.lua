
-- Code writen by ttyk (http://ttyk.ru/ ;  admin@ttyk.ru ; Skype: ttyk.v)
-- Project name: gm_sump ( Freeware )
-- TPID: 00Fx004
-- file modified: 10/22/2015

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "S.U.M.P. Storage upgrade"
ENT.Author = "ttyk"
ENT.Spawnable =true
ENT.Category = "Other"
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"price")
	self:NetworkVar("Entity",1,"owning_ent")
end
