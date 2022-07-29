if SERVER then
	resource.AddWorkshop("2841352626")
end

CreateConVar("portals_allow_custom_colors", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether players should be able to change portal colors.", 0, 1)

if CLIENT then
	CreateClientConVar("portals_lights_enabled", 1, true, false, "Whether portals should emit light.", 0, 1)
	CreateClientConVar("portals_lights_range", 1024, true, false, "The range at which portals emit light.", 0)
end
