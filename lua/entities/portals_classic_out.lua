AddCSLuaFile()

ENT.Base = "portals_out"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.PrintName = "Classic Portal (Exit)"
ENT.Category = "Portals"

ENT.Spawnable = true
ENT.Editable = true

ENT.BaseColor = Color(100, 200, 0)

local defaultSound = GetConVar("portals_default_sound")

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Group", {
		KeyName = "group",
		Edit = {
			order = 0,
			type = "Generic"
		}
	})

	self:NetworkVar("String", 1, "TeleportSound", {
		KeyName = "sound",
		Edit = {
			title = "Teleport Sound",
			order = 1,
			type = "Generic"
		}
	})

	self:SetTeleportSound(defaultSound:GetString())
end

function ENT:GetCustomColor()
	return self.BaseColor
end

if CLIENT then
	local developer = GetConVar("developer")
	local sprite = Material("sprites/portals/classic_out")

	function ENT:DrawTranslucent()
		if developer:GetBool() then
			local mins = self.Mins - Vector(0.1, 0.1, 0.1)
			local maxs = self.Maxs + Vector(0.1, 0.1, 0.1)

			local color = ColorAlpha(self:GetCustomColor(), 50)

			render.SetColorMaterial()
			render.DrawBox(self:GetPos(), self:GetNetworkAngles(), mins, maxs, color, true)
			render.DrawWireframeBox(self:GetPos(), self:GetNetworkAngles(), mins, maxs, color, true)

			render.DrawLine(self:GetPos(), self:GetPos() + self:GetForward() * 50, self:GetCustomColor(), true)
		end

		render.OverrideBlend(true, BLEND_ONE, BLEND_ONE_MINUS_SRC_COLOR, BLENDFUNC_ADD)
		render.SetMaterial(sprite)
		render.DrawSprite(self:GetPos(), 50, 50)
		render.OverrideBlend(false)

		local ang = (EyePos() - self:GetPos()):Angle()

		self:SetRenderAngles(ang)
		self:SetupBones()
	end
end
