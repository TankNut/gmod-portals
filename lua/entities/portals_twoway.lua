AddCSLuaFile()
DEFINE_BASECLASS("portals_in")

ENT.Base = "portals_in"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.PrintName = "Portal (Two-way)"
ENT.Category = "Portals"

ENT.Spawnable = true

ENT.Color = Color(127, 255, 255)

ENT.ExitType = "portals_twoway"

ENT.LightParams = {
	r = 127,
	g = 255,
	b = 255
}
