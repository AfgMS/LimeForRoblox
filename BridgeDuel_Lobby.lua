local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/LimeForRoblox/refs/heads/main/Library.lua"))()
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

local Main = Library:CreateMain()
local CombatTab = Main:CreateTab("Combat", 138185990548352, Color3.fromRGB(255, 85, 127))
local ExploitTab = Main:CreateTab("Exploit", 71954798465945, Color3.fromRGB(0, 255, 187))
local MoveTab = Main:CreateTab("Move", 91366694317593, Color3.fromRGB(82, 246, 255))
local PlayerTab = Main:CreateTab("Player", 103157697311305, Color3.fromRGB(255, 255, 127))
local VisualTab = Main:CreateTab("Visual", 118420030502964, Color3.fromRGB(170, 85, 255))
local WorldTab = Main:CreateTab("World", 76313147188124, Color3.fromRGB(255, 170, 0))

--[[ Under Development
game:GetService("ReplicatedStorage").__comm__.RP.gamemode:FireServer()
game:GetService("ReplicatedStorage").Remotes.Jumpscare:FireServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.CombatService.RE.OnKill:FireServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.VoidService.RE.OnFell:FireServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.ModerationService.RF.Ban:InvokeServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.ModerationService.RF.Unban:InvokeServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.NetworkService.RF.SendReport:InvokeServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.GuildService.RF.KickPlayer:InvokeServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.CombatService.RE.KnockBackApplied:FireServer()
workspace.Parent:GetService("Workspace").Map.RedBase:GetChildren()[119]
--]]

function IsAlive(v)
	return v and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0
end

function GetNearestPlayer(MaxDist, Sort, Team)
	local Entity, MinDist, Distance

	for i,v in pairs(Players:GetPlayers()) do
		if v ~= LocalPlayer and IsAlive(v) then
			if v.Character:FindFirstChild("HumanoidRootPart") then
				if not Team or v.Team ~= LocalPlayer.Team then
					Distance = (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

					if Sort == "Distance" then
						if Distance <= MaxDist and (not MinDist or Distance < MinDist) then
							MinDist = Distance
							Entity = v
						end
					elseif Sort == "Furthest" then
						if Distance <= MaxDist and (not MinDist or Distance > MinDist) then
							MinDist = Distance
							Entity = v
						end
					elseif Sort == "Health" then
						local Humanoid = v.Character:FindFirstChildOfClass("Humanoid")
						if Humanoid and Distance <= MaxDist and (not MinDist or Humanoid.Health < MinDist) then
							MinDist = Humanoid.Health
							Entity = v
						end
					elseif Sort == "Threat" then
						local Humanoid = v.Character:FindFirstChildOfClass("Humanoid")
						if Humanoid and Distance <= MaxDist and (not MinDist or Humanoid.Health > MinDist) then
							MinDist = Humanoid.Health
							Entity = v
						end
					end
				end
			end
		end
	end

	return Entity
end

function GetTool(name)
	local TooResults
	for _,tool in pairs(LocalPlayer.Backpack:GetChildren()) do
		if tool:IsA("Tool") and tool.Name:match(name) then
			TooResults = tool
		end
	end
	return TooResults
end

function CheckTool(name)
	local TooResults
	for _,tool in pairs(LocalPlayer.Character:GetChildren()) do
		if tool:IsA("Tool") and tool.Name:match(name) then
			TooResults = tool
		end
	end
	return TooResults
end

function PlaySound(id)
	local Sound = Instance.new("Sound")
	Sound.SoundId = "rbxassetid://" .. id
	Sound.Parent = game.Workspace
	Sound:Play()
	Sound.Ended:Connect(function()
		Sound:Destroy()
	end)
end

local HitCritical = false
spawn(function()
	local Criticals = CombatTab:CreateToggle({
		Name = "Criticals",
		Callback = function(callback)
			if callback then
				HitCritical = true
			else
				HitCritical = false
			end
		end
	})
end)

local KillAuraSortMode, KillAuraTeamCheck, KillAuraBlock, IsKillAuraEnabled = nil, nil, nil, false
spawn(function()
	local Loop, Range, Swing = nil, nil, false
	local Sword = nil

	local KillAura = CombatTab:CreateToggle({
		Name = "Kill Aura",
		Callback = function(callback)
			IsKillAuraEnabled = callback
			if callback then
				Loop = RunService.RenderStepped:Connect(function()
					if IsAlive(LocalPlayer) then
						local Target = GetNearestPlayer(Range, KillAuraSortMode, KillAuraTeamCheck)
						if Target then
							Sword = CheckTool("Sword")
							if Sword then
								if KillAuraBlock == "Packet" then
									local args = {
										[1] = true,
										[2] = Sword.Name
									}
									game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
								elseif KillAuraBlock == "None" then
									local args = {
										[1] = false,
										[2] = Sword.Name
									}
									game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
								end
								if Swing and KillAuraBlock == "None" then
									Sword:Activate()
								end
								local args = {
									[1] = Target.Character,
									[2] = HitCritical,
									[3] = Sword.Name
								}
								game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("AttackPlayerWithSword"):InvokeServer(unpack(args))
							else
								if KillAuraBlock == "Packet" then
									local args = {
										[1] = false,
										[2] = Sword.Name
									}
									game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
								end
							end
						else
							if KillAuraBlock == "Packet" then
								local args = {
									[1] = false,
									[2] = Sword.Name
								}
								game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
							end
						end
					else
						repeat
							task.wait()
						until IsAlive(LocalPlayer)
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
			end
		end
	})
	local KillAuraSort = KillAura:CreateDropdown({
		Name = "Sort Mode",
		List = {"Distance", "Furthest", "Health", "Threat"},
		Default = "Distance",
		Callback = function(callback)
			if callback then
				KillAuraSortMode = callback
			end
		end
	})
	local KillAuraAutoBlock = KillAura:CreateDropdown({
		Name = "Auto Block",
		List = {"Packet", "None"},
		Default = "None",
		Callback = function(callback)
			if callback then
				KillAuraBlock = callback
			end
		end
	})
	local KillAuraRange = KillAura:CreateSlider({
		Name = "Range",
		Min = 0,
		Max = 20,
		Default = 20,
		Callback = function(callback)
			if callback then
				Range = callback
			end
		end
	})
	local KillAuraSwing = KillAura:CreateMiniToggle({
		Name = "Swing",
		Callback = function(callback)
			if callback then
				Swing = true
			else
				Swing = false
			end
		end
	})
	local KillAuraTeam = KillAura:CreateMiniToggle({
		Name = "Team",
		Callback = function(callback)
			if callback then
				KillAuraTeamCheck = true
			else
				KillAuraTeamCheck = false
			end
		end
	})
end)

spawn(function()
	local HumanoidRootPart = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	local Loop, TPRange, OldCameraType, OldCameraSubject = nil, nil, game.Workspace.CurrentCamera.CameraType, game.Workspace.CurrentCamera.CameraSubject 
	local Sword = nil
	local TeleportAura = CombatTab:CreateToggle({
		Name = "Teleport Aura",
		Callback = function(callback)
			if callback then
				Loop = RunService.Heartbeat:Connect(function()
					if IsKillAuraEnabled then
						if IsAlive(LocalPlayer) then
							local Target = GetNearestPlayer(TPRange, KillAuraSortMode, KillAuraTeamCheck)
							if Target and Target.Character:FindFirstChild("HumanoidRootPart") and Target.Character.HumanoidRootPart.Position.Y < -16 then
								Sword = CheckTool("Sword")
								if Sword then
									game.Workspace.CurrentCamera.CameraSubject = Target.Character:FindFirstChildOfClass("Humanoid")
									game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Watch
									if KillAuraBlock == "None" then
										Sword:Activate()
									end
									local TargetPosition = Target.Character:FindFirstChild("HumanoidRootPart")
									if TargetPosition then
										local InfiniteTween = TweenService:Create(HumanoidRootPart, TweenInfo.new(0.08), {CFrame = CFrame.new(TargetPosition.Position.X, TargetPosition.Position.Y - 6, TargetPosition.Position.Z)})
										InfiniteTween:Play()
									end
								else
									game.Workspace.CurrentCamera.CameraSubject = OldCameraSubject
									game.Workspace.CurrentCamera.CameraType = OldCameraType
								end
							else
								game.Workspace.CurrentCamera.CameraSubject = OldCameraSubject
								game.Workspace.CurrentCamera.CameraType = OldCameraType
								repeat
									task.wait()
								until IsAlive(LocalPlayer)
							end
						end
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				game.Workspace.CurrentCamera.CameraSubject = OldCameraSubject
				game.Workspace.CurrentCamera.CameraType = OldCameraType
			end
		end
	})
	local TeleportAuraRange = TeleportAura:CreateSlider({
		Name = "Range",
		Min = 0,
		Max = 40,
		Default = 40,
		Callback = function(callback)
			if callback then
				TPRange = callback
			end
		end
	})
end)

spawn(function()
	local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local Remote
	local Velocity = CombatTab:CreateToggle({
		Name = "Velocity",
		Callback = function(callback)
			if callback then
				Remote = game:GetService("ReplicatedStorage").Packages.Knit.Services.CombatService.RE.KnockBackApplied
				if Remote then
					Remote.OnClientEvent:Connect(function()
						spawn(function()
							
						end)
					end)
				end
			else
				Remote = nil
			end
		end
	})
end)

--[[
spawn(function()
	local HumanoidRootPart, OldHipHeight = LocalPlayer.Character:WaitForChild("HumanoidRootPart"), Humanoid.HipHeight
	local AnimationDisabler, FlagReducer = false, false
	local Loop

	local Disabler = ExploitTab:CreateToggle({
		Name = "Disabler",
		Callback = function(callback)
			if callback then
				Loop = RunService.Heartbeat:Connect(function()
					if AnimationDisabler then
						for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
							track:Stop()
						end
					end
					if FlagReducer then
						if not isnetworkowner(HumanoidRootPart) then
							Humanoid.HipHeight = Humanoid.HipHeight + 12
						else
							Humanoid.HipHeight = OldHipHeight
						end
					end
				end)
			else
				if Loop then
					Loop:Disconnect()
				end
				for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
					track:Play()
				end
				Humanoid.HipHeight = OldHipHeight
			end
		end
	})

	local DisablerAnimations = Disabler:CreateMiniToggle({
		Name = "Animations",
		Callback = function(callback)
			if callback then
				AnimationDisabler = true
			else
				AnimationDisabler = false
			end
		end
	})
	local DisablerFlag = Disabler:CreateMiniToggle({
		Name = "Flag",
		Callback = function(callback)
			if callback then
				FlagReducer = true
			else
				FlagReducer = false
			end
		end
	})
end)
--]]

spawn(function()
	local HumanoidRootPartY = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
	local Loop, Speed, YPos = nil, nil, 0
	--local Phase = false
	local OldGravity = game.Workspace.Gravity
	
	UserInputService.JumpRequest:Connect(function()
		YPos = YPos + 6
	end)
	UserInputService.InputBegan:Connect(function(Input, IsTyping)
		if IsTyping then return end
		if Input.KeyCode == Enum.KeyCode.LeftShift then
			YPos = YPos - 6
		end
	end)
	
	local Flight = MoveTab:CreateToggle({
		Name = "Flight",
		Callback = function(callback)
			if callback then
				YPos = 0
				HumanoidRootPartY = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
				Humanoid.Health = Humanoid.Health - 1
				PlaySound(9120444275)
				Loop = RunService.Heartbeat:Connect(function()
					if IsAlive(LocalPlayer) then
											--[[
					if Phase then
						for i,v in pairs(LocalPlayer.Character:GetChildren()) do
							if v:IsA("MeshPart") then
								v.CanCollide = false
							end
						end
						for i,v in pairs(LocalPlayer.Character:GetChildren()) do
							if v:IsA("Part") then
								v.CanCollide = false
							end
						end
					else
						for i,v in pairs(LocalPlayer.Character:GetChildren()) do
							if v:IsA("MeshPart") then
								v.CanCollide = true
							end
						end
						for i,v in pairs(LocalPlayer.Character:GetChildren()) do
							if v:IsA("Part") then
								v.CanCollide = true
							end
						end
					end
					--]]
						game.Workspace.Gravity = 0
						local Velocity = LocalPlayer.Character.Humanoid.MoveDirection * Speed
						LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, Velocity.Z)
						LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.X, HumanoidRootPartY + YPos, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Z) * LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.Rotation
					else
						repeat
							task.wait()
						until IsAlive(LocalPlayer)
					end
				end)
			else
				--[[
				for i,v in pairs(LocalPlayer.Character:GetChildren()) do
					if v:IsA("MeshPart") then
						v.CanCollide = true
					end
				end
				for i,v in pairs(LocalPlayer.Character:GetChildren()) do
					if v:IsA("BasePart") then
						v.CanCollide = true
					end
				end
				--]]
				if Loop ~= nil then
					Loop:Disconnect()
				end
				game.Workspace.Gravity = OldGravity
				HumanoidRootPartY =  LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
				LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
			end
		end
	})
	--[[
	local FlightPhase = Flight:CreateMiniToggle({
		Name = "Phase",
		Callback = function(callback)
			if callback then
				Phase = true
			else
				Phase = false
			end
		end
	})
	--]]
	local FlightSpeed = Flight:CreateSlider({
		Name = "Speed",
		Min = 0,
		Max = 32,
		Default = 32,
		Callback = function(callback)
			if callback then
				Speed = callback
			end
		end
	})
end)

spawn(function()
	local OldWalkSpeed = Humanoid.WalkSpeed
	local Loop = nil
	local NoSlow = MoveTab:CreateToggle({
		Name = "No Slow",
		Callback = function(callback)
			if callback then
				Loop = Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
					if IsAlive(LocalPlayer) then
						if Humanoid.WalkSpeed ~= OldWalkSpeed then
							Humanoid.WalkSpeed = OldWalkSpeed
						end
					else
						repeat
							task.wait()
						until IsAlive(LocalPlayer)
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				Humanoid.WalkSpeed = OldWalkSpeed
			end
		end
	})
end)

spawn(function()
	local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local Loop, SpeedVal, AutoJump = nil, nil, false
	
	local Speed = MoveTab:CreateToggle({
		Name = "Speed",
		Callback = function(callback)
			if callback then
				Loop = RunService.Heartbeat:Connect(function()
					if IsAlive(LocalPlayer) then
						local Velocity = LocalPlayer.Character.Humanoid.MoveDirection * SpeedVal
						HumanoidRootPart.Velocity = Vector3.new(Velocity.X, HumanoidRootPart.Velocity.Y, Velocity.Z)
						if AutoJump then
							spawn(function()
								Humanoid.Jump = true
							end)
						end
					else
						repeat
							task.wait()
						until IsAlive(LocalPlayer)
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, HumanoidRootPart.Velocity.Y, HumanoidRootPart.Velocity.Z)
			end
		end
	})
	local SpeedSpeedValue = Speed:CreateSlider({
		Name = "Speed",
		Min = 0,
		Max = 32, 
		Default = 28,
		Callback = function(callback)
			if callback then
				SpeedVal = callback
			end
		end
	})
	local SpeedAutoJump = Speed:CreateMiniToggle({
		Name = "Auto Jump",
		Callback = function(callback)
			if callback then
				AutoJump = true
			else
				AutoJump = false
			end
		end
	})
end)

spawn(function()
	local Loop, AutoClickerMode, CPS = false, false, nil
	local Tool = nil

	local FastPlace = PlayerTab:CreateToggle({
		Name = "Fast Place",
		Callback = function(callback)
			Loop = callback
			if callback then
				if IsAlive(LocalPlayer) then
					repeat
						wait(1 / CPS)
						Tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
						if Tool then
							if Tool.Name:match("Blocks") then
								if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
									Tool:Activate()
								end
							elseif AutoClickerMode then
								if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
									Tool:Activate()
								end
							end
						end
					until not Loop
				else
					repeat
						task.wait()
					until IsAlive(LocalPlayer)
				end
			end
		end
	})
	local FastPlaceAutoClicker = FastPlace:CreateMiniToggle({
		Name = "Auto Clicker",
		Callback = function(callback)
			if callback then
				AutoClickerMode = true
			else
				AutoClickerMode = false
			end
		end
	})
	local FastPlaceCPS = FastPlace:CreateSlider({
		Name = "CPS",
		Min = 0,
		Max = 100,
		Default = 20,
		Callback = function(callback)
			CPS = callback
		end
	})
end)

spawn(function()
	local HumanoidRootPart = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	local LastPosition = HumanoidRootPart.Position
	local Loop, Mode, ShowLastPos, AlwaysTrack = nil, nil, false, false

	local PositionHighlight = Instance.new("Part")
	PositionHighlight.Size = Vector3.new(3, 0.4, 3)
	PositionHighlight.Anchored = true
	PositionHighlight.CanCollide = false
	PositionHighlight.Material = Enum.Material.Neon
	PositionHighlight.CastShadow = false
	PositionHighlight.Color = Color3.new(0.815686, 0.0745098, 1)
	PositionHighlight.Transparency = 1
	PositionHighlight.Parent = game.Workspace

	local AntiVoid = PlayerTab:CreateToggle({
		Name = "Anti Void",
		Callback = function(callback)
			if callback then
				Loop = RunService.Heartbeat:Connect(function()
					if IsAlive(LocalPlayer) then
						if ShowLastPos then
							PositionHighlight.Transparency = 0.75
						else
							PositionHighlight.Transparency = 1
						end
						if AlwaysTrack then
							if Humanoid.FloorMaterial ~= Enum.Material.Air then
								LastPosition = HumanoidRootPart.Position
								PositionHighlight.Position = LastPosition - Vector3.new(0, 2.8, 0)
							end
						else
							Humanoid:GetPropertyChangedSignal("FloorMaterial"):Connect(function()
								if Humanoid.FloorMaterial ~= Enum.Material.Air then
									LastPosition = HumanoidRootPart.Position
									PositionHighlight.Position = LastPosition - Vector3.new(0, 2.8, 0)
								end
							end)
						end
						if HumanoidRootPart.Position.Y < -132 then
							if Mode == "TP" then
								HumanoidRootPart.CFrame = CFrame.new(LastPosition + Vector3.new(0, 15, 0))
							elseif Mode == "Tween" then
								local TweenY = TweenService:Create(HumanoidRootPart, TweenInfo.new(0.1), {CFrame = CFrame.new(HumanoidRootPart.Position.X, LastPosition.Y + 9, HumanoidRootPart.Position.Z)})
								TweenY:Play()
								TweenY.Completed:Wait(1)
								local TweenX = TweenService:Create(HumanoidRootPart, TweenInfo.new(0.1), {CFrame = CFrame.new(LastPosition.X, LastPosition.Y + 9, LastPosition.Z)})
								TweenX:Play()
							end
						end
					else
						repeat
							task.wait()
						until IsAlive(LocalPlayer)
					end
				end)
			else
				PositionHighlight.Transparency = 1
				if Loop ~= nil then
					Loop:Disconnect()
				end
			end
		end
	})
	local AntiVoidVisual = AntiVoid:CreateMiniToggle({
		Name = "Visualize",
		Callback = function(callback)
			if callback then
				ShowLastPos = true
			else
				ShowLastPos = false
			end
		end
	})
	local AntiVoidTrack = AntiVoid:CreateMiniToggle({
		Name = "Always Track",
		Callback = function(callback)
			if callback then
				AlwaysTrack = true
			else
				AlwaysTrack = false
			end
		end
	})
	local AntiVoidMode = AntiVoid:CreateDropdown({
		Name = "AntiVoid Mode",
		List = {"TP", "Tween"},
		Default = "TP",
		Callback = function(callback)
			if callback then
				Mode = callback
			end
		end
	})
end)

spawn(function()
	local function GetPlace(pos)
		local NewPos = Vector3.new(math.floor((pos.X / 3) + 0.5) * 3, math.floor((pos.Y / 3) + 0.5) * 3, math.floor((pos.Z / 3) + 0.5) * 3)
		return NewPos
	end
	
	local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local DefaultPos = Vector3.new(0, 0, 0)
	local Loop, Expand = nil, 1
	local Scaffold = WorldTab:CreateToggle({
		Name = "Scaffold",
		Callback = function(callback)
			if callback then
				Loop = RunService.RenderStepped:Connect(function()
					if IsAlive(LocalPlayer) then
						for i = 1, Expand do
							local PlacePos = GetPlace(HumanoidRootPart.Position + Humanoid.MoveDirection * (i * 3.5) - Vector3.yAxis * ((HumanoidRootPart.Size.Y / 2) + Humanoid.HipHeight + 1.5))
							DefaultPos = PlacePos
							local args = {
								[1] = PlacePos
							}

							game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("PlaceBlock"):InvokeServer(unpack(args))
						end
					else
						repeat
							task.wait()
						until IsAlive(LocalPlayer)
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				DefaultPos = Vector3.new(0, 0, 0)
			end
		end
	})
end)

spawn(function()
	local OldTime, NewTime = game:GetService("Lighting").ClockTime, nil
	local Loop
	local TimeChanger = WorldTab:CreateToggle({
		Name = "Time Changer",
		Callback = function(callback)
			if callback then
				Loop = RunService.Heartbeat:Connect(function()
					game:GetService("Lighting").ClockTime = NewTime
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				game:GetService("Lighting").ClockTime = OldTime
			end
		end
	})
	local TimeChangerClock = TimeChanger:CreateSlider({
		Name = "Time",
		Min = 0,
		Max = 24,
		Default = OldTime,
		Callback = function(callback)
			if callback then
				NewTime = callback
			end
		end
	})
end)
