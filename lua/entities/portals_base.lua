AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.Model = Model("models/effects/intro_vortshield.mdl")
ENT.Color = color_white

ENT.Mins = Vector(-25, -25, -25)
ENT.Maxs = Vector(25, 25, 25)

ENT.LightParams = {
	brightness = 2,
	Decay = 1000,
	Size = 128
}

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetColor(self.Color)

	self:DrawShadow(false)

	if SERVER then
		self:PhysicsInitBox(self.Mins, self.Maxs)
		self:SetMoveType(MOVETYPE_NONE)

		self:SetTrigger(true)
	end

	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
end

if CLIENT then
	local lightsEnabled = GetConVar("portals_lights_enabled")
	local lightsRange = GetConVar("portals_lights_range")

	function ENT:ShouldDoLight() -- Convar
		if not lightsEnabled:GetBool() then
			return false
		end

		local range = lightsRange:GetFloat() * lightsRange:GetFloat()

		return not self:IsDormant() and EyePos():DistToSqr(self:GetPos()) < range
	end

	function ENT:Think()
		if self:ShouldDoLight() then
			local light = DynamicLight(self:EntIndex())

			if light then
				light.pos = self:GetPos()
				light.DieTime = CurTime() + 1

				for k, v in pairs(self.LightParams) do
					if istable(v) then
						continue
					end

					light[k] = v
				end
			end
		end

		self:RemoveAllDecals()
	end

	local developer = GetConVar("developer")
	local sprite = Material("sprites/light_glow02_add")

	function ENT:DrawTranslucent()
		if developer:GetBool() then
			local mins = self.Mins - Vector(0.1, 0.1, 0.1)
			local maxs = self.Maxs + Vector(0.1, 0.1, 0.1)

			local color = ColorAlpha(self.Color, 50)

			render.SetColorMaterial()
			render.DrawBox(self:GetPos(), self:GetNetworkAngles(), mins, maxs, color, true)
			render.DrawWireframeBox(self:GetPos(), self:GetNetworkAngles(), mins, maxs, color, true)

			render.DrawLine(self:GetPos(), self:GetPos() + self:GetForward() * 50, self.Color, true)
		end

		local size = 150

		render.OverrideBlend(true, BLEND_ZERO, BLEND_ONE_MINUS_SRC_COLOR, BLENDFUNC_ADD)
		render.SetMaterial(sprite)
		render.DrawSprite(self:GetPos(), size, size)
		render.OverrideBlend(false)

		local ang = (EyePos() - self:GetPos()):Angle()

		self:SetRenderAngles(ang)
		self:SetupBones()
		self:DrawModel()
		self:DrawModel()
	end
else
	function ENT:TeleportEffect(ent)
		if not ent then
			ent = self
		end

		ent:EmitSound("beams/beamstart5.wav", 75, 100, 0.5)
	end

	function ENT:IsValidEntity(ent)
		if ent:IsPlayer() then
			return ent:GetMoveType() != MOVETYPE_NOCLIP
		end

		if ent:IsNPC() or ent:IsVehicle() then
			return false
		end

		local phys = ent:GetPhysicsObject()

		if IsValid(phys) and not phys:IsMotionEnabled() then
			return false
		end

		local class = ent:GetClass()

		if string.find(class, "prop_dynamic") then return false end
		if string.find(class, "prop_door") then return false end
		if class == "func_physbox" and ent:HasSpawnFlags(SF_PHYSBOX_MOTIONDISABLED) then return false end
		if string.find(class, "prop_") and (ent:HasSpawnFlags(SF_PHYSPROP_MOTIONDISABLED) or ent:HasSpawnFlags(SF_PHYSPROP_PREVENT_PICKUP)) then return false end
		if class != "func_physbox" and string.find(class, "func_") then return false end

		return true
	end
end