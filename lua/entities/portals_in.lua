AddCSLuaFile()
DEFINE_BASECLASS("portals_base")

ENT.Base = "portals_base"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.PrintName = "Portal (Entrance)"
ENT.Category = "Portals"

ENT.Spawnable = true
ENT.Editable = true

ENT.Color = Color(255, 136, 0)

ENT.ExitType = "portals_out"

ENT.LightParams = {
	r = 255,
	g = 136,
	b = 0
}

function ENT:Initialize()
	BaseClass.Initialize(self)

	self.Filter = {}
end

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Group", {
		KeyName = "group",
		Edit = {
			type = "Generic"
		}
	})
end

if SERVER then
	function ENT:StartTouch(ent)
		if self.Filter[ent] or self:GetPhysicsObject():HasGameFlag(FVPHYSICS_PLAYER_HELD) or not self:IsValidEntity(ent) then
			return
		end

		local exits = {}

		for _, v in ipairs(ents.FindByClass(self.ExitType)) do
			if v != self and v:GetGroup() == self:GetGroup() then
				table.insert(exits, v)
			end
		end

		local exit = exits[math.random(1, #exits)]

		if not IsValid(exit) then
			return
		end

		ent:ForcePlayerDrop()

		if ent:IsPlayer() then
			local ang = exit:LocalToWorldAngles(self:WorldToLocalAngles(ent:EyeAngles()))

			ang.p = math.Clamp(math.NormalizeAngle(ang.p), -89, 89)
			ang.r = 0

			ent:SetPos(exit:WorldSpaceCenter())
			ent:SetAngles(ang)
			ent:SetEyeAngles(ang)

			ent:SetVelocity(-ent:GetVelocity())

			ent:ScreenFade(SCREENFADE.IN, self.Color, 0.5, 0)
		else
			local ang = exit:LocalToWorldAngles(self:WorldToLocalAngles(ent:GetAngles()))
			local rot = exit:LocalToWorldAngles(-self:GetAngles())

			local vel = ent:GetVelocity()

			vel:Rotate(rot)

			ent:SetPos(exit:WorldSpaceCenter())
			ent:SetAngles(ang)

			local phys = ent:GetPhysicsObject()

			if IsValid(phys) then
				phys:SetVelocity(vel)
			end
		end

		self:TeleportEffect()
		exit:TeleportEffect(ent)

		if exit.Filter then
			exit.Filter[ent] = true
		end
	end

	function ENT:EndTouch(ent)
		self.Filter[ent] = nil
	end
end
