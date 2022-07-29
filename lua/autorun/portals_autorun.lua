if SERVER then
	resource.AddWorkshop("2841352626")
end

if CLIENT then
	CreateClientConVar("portals_lights_enabled", 1, true, false, "Whether portals should emit light.", 0, 1)
	CreateClientConVar("portals_lights_range", 1024, true, false, "The range at which portals emit light.", 0)
end
