AddCSLuaFile()

ENT.Base = "portals_base"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.PrintName = "Portal (Exit)"
ENT.Category = "Portals"

ENT.Spawnable = true
ENT.Editable = true

ENT.Color = Color(100, 200, 0)

ENT.LightParams = {
	r = 100,
	g = 200,
	b = 0
}

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Group", {
		KeyName = "group",
		Edit = {
			type = "Generic"
		}
	})
end
