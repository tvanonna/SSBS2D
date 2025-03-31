include( "player_class.lua" )

GM.Name = "Super Smash Bros. Source"
GM.Author = "poopcorn"

function GM:Initialize()
	
   self.BaseClass.Initialize(self)

   if (SERVER) then
      game.ConsoleCommand("sv_gravity 500\n") --sets the gravity to 900
      game.ConsoleCommand("sv_friction 8\n") --sets the friction to 8 (default value) if it isn't already 
      game.ConsoleCommand("sv_airaccelerate 7\n")
   end 
	
end