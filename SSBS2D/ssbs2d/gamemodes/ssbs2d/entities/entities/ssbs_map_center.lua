AddCSLuaFile()

-- Defines the Entity's type, base, printable name, and author for shared access (both server and client)
ENT.Type = "anim" 
ENT.Base = "base_gmodentity" 
ENT.PrintName = "Map Center Pointer" 
ENT.Author = "poopcorn" 
ENT.Purpose = "Entity that points to the center of the map (i.e. the stage). Used by the camera to prevent excessive zooming." 
ENT.Spawnable = false 

function ENT:Initialize()
    print("Map center pointer is here!")

    self:SetModel("models/hunter/plates/plate1x1.mdl") 
    self:SetNoDraw(true) --makes the entity invisible 

    self:SetSolid(SOLID_NONE) --do not collide with anything
    self:SetMoveType(MOVETYPE_NONE) --makes the entity immobile

    print(self:GetPos())
end