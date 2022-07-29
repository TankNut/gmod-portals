AddCSLuaFile()

ENT.Base = "portals_base"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.PrintName = "Portal (Exit)"
ENT.Category = "Portals"

ENT.Spawnable = true
ENT.Editable = true

ENT.BaseColor = Color(100, 200, 0)

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Group", {
		KeyName = "group",
		Edit = {
			order = 0,
			type = "Generic"
		}
	})

	self:NetworkVar("Vector", 0, "PortalColor", {
		KeyName = "portalcolor",
		Edit = {
			order = 1,
			type = "VectorColor"
		}
	})

	self:SetPortalColor(self.BaseColor:ToVector())
end

if CLIENT then
	local allow = GetConVar("portals_allow_custom_colors")

	function ENT:GetCustomColor()
		return allow:GetBool() and self:GetPortalColor():ToColor() or self.BaseColor
	end
end
