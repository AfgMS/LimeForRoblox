spawn(function()
	if shared.Lime then
		if shared.Lime.Uninject then
			shared.Lime.Uninject = false
		end
	end
end)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local MainFolder, ConfigFolder = "Lime", "Lime/configs"

if not isfolder(MainFolder) then makefolder(MainFolder) end
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

if isfolder(MainFolder) and isfolder(ConfigFolder) then
	if game.PlaceId == 11630038968 then
		if LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool").Name:match("Apple") or LocalPlayer.Character:FindFirstChildWhichIsA("Tool").Name:match("Apple") then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/LimeForRoblox/refs/heads/main/BridgeDuel_Game.lua"))()
			
		else
			loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/LimeForRoblox/refs/heads/main/BridgeDuel_Lobby.lua"))()
		end
	else
		loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/LimeForRoblox/refs/heads/main/Universal.lua"))()
	end
end
