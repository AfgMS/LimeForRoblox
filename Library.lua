local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local MainFolder, ConfigFolder = "Lime", "Lime/configs"
local LibrarySettings = {ToggleButton = {MiniToggle = {}, Sliders = {}, Dropdown = {}}}
local AutoSave, MainFile = false, nil

local function LoadSettings(path)
	return isfile(path) and HttpService:JSONDecode(readfile(path)) or nil
end
local function SaveSettings(path, settings)
	writefile(path, HttpService:JSONEncode(settings))
end

if isfolder(MainFolder) and isfolder(ConfigFolder) then
	if game.PlaceId == 11630038968 then
		if LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool").Name:match("Apple") or LocalPlayer.Character:FindFirstChildWhichIsA("Tool").Name:match("Apple") then
			MainFile = ConfigFolder .. "/" .. "BridgeDuelGame.lua"
		else
			MainFile = ConfigFolder .. "/" .. "BridgeDuelLobby.lua"
		end
	elseif game.PlaceId == 6872265039 then
		MainFile = ConfigFolder .. "/" .. "Bedwars.lua"
	elseif game.PlaceId == 8542259458 then
		MainFile = ConfigFolder .. "/" .. "Skywars.lua"
	else
		MainFile = ConfigFolder .. "/" .. game.PlaceId .. ".lua"
	end
	
	local LoadedSettings = LoadSettings(MainFile)
	if isfile(MainFile) and HttpService:JSONDecode(readfile(MainFile)) or nil then
		LibrarySettings = LoadedSettings 
	end

	AutoSave = true
	spawn(function()
		while AutoSave do
			wait(5)
			writefile(MainFile, HttpService:JSONEncode(LibrarySettings))
		end
	end)
end

function MakeDraggable(object)
	local dragging, dragInput, dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	object.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	object.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

function Spoof(length)
	local Letter = {}
	for i = 1, length do
		local RandomLetter = string.char(math.random(97, 122))
		table.insert(Letter, RandomLetter)
	end
	return table.concat(Letter)
end

local Library = {
	LimeTitle = "Lime"
}

function Library:CreateMain()
	local Main = {}

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Name = Spoof(math.random(8, 12))
	if RunService:IsStudio() then
		ScreenGui.Parent = PlayerGui
	elseif game.PlaceId == 11630038968 then
		ScreenGui.Parent = PlayerGui:FindFirstChild("MainGui")
	else
		ScreenGui.Parent = CoreGui
	end

	local MainFrame = Instance.new("Frame")
	MainFrame.Parent = ScreenGui
	MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MainFrame.BackgroundTransparency = 1.000
	MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MainFrame.Size = UDim2.new(1, 0, 1, 0)
	MainFrame.Visible = false

	spawn(function()
		local Spaces = 18
		local OldX = 0

		for _, child in ipairs(MainFrame:GetChildren()) do
			if child:IsA("GuiObject") then
				child.Position = UDim2.new(0, OldX, 0, 0)
				OldX = OldX + child.Size.X.Offset + Spaces
			end
		end
	end)

	local UIPadding = Instance.new("UIPadding")
	UIPadding.Parent = MainFrame
	UIPadding.PaddingLeft = UDim.new(0, 20)
	UIPadding.PaddingTop = UDim.new(0, 22)

	local HudFrame = Instance.new("Frame")
	HudFrame.Parent = ScreenGui
	HudFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HudFrame.BackgroundTransparency = 1.000
	HudFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HudFrame.BorderSizePixel = 0
	HudFrame.Size = UDim2.new(1, 0, 1, 0)

	local LibraryTitle = Instance.new("TextLabel")
	LibraryTitle.Parent = HudFrame
	LibraryTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LibraryTitle.BackgroundTransparency = 1.000
	LibraryTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LibraryTitle.BorderSizePixel = 0
	LibraryTitle.Position = UDim2.new(0, 20, 0, 18)
	LibraryTitle.Size = UDim2.new(0, 345, 0, 30)
	LibraryTitle.Text = Library.LimeTitle
	LibraryTitle.Font = Enum.Font.SourceSans
	LibraryTitle.TextColor3 = Color3.fromRGB(255, 0, 127)
	LibraryTitle.TextScaled = true
	LibraryTitle.TextSize = 14.000
	LibraryTitle.TextWrapped = true
	LibraryTitle.TextXAlignment = Enum.TextXAlignment.Left
	LibraryTitle.ZIndex = -1

	local TitleGradient = Instance.new("UIGradient")
	TitleGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(138, 230, 255))}
	TitleGradient.Parent = LibraryTitle

	local ArrayTable = {}
	local ArrayFrame = Instance.new("Frame")
	ArrayFrame.Parent = HudFrame
	ArrayFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ArrayFrame.BackgroundTransparency = 1.000
	ArrayFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ArrayFrame.BorderSizePixel = 0
	ArrayFrame.Position = UDim2.new(0.819999993, 0, 0.0399999991, 0)
	ArrayFrame.Size = UDim2.new(0.162, 0, 0.930000007, 0)

	local UIListLayout_4 = Instance.new("UIListLayout")
	UIListLayout_4.Parent = ArrayFrame
	UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_4.HorizontalAlignment = Enum.HorizontalAlignment.Right

	local function AddArray(name)
		local TextLabel = Instance.new("TextLabel")
		TextLabel.Parent = ArrayFrame
		TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.TextTransparency = 1
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Font = Enum.Font.SourceSans
		TextLabel.Text = name
		TextLabel.TextColor3 = Color3.fromRGB(255, 0, 127)
		TextLabel.TextScaled = true
		TextLabel.TextSize = 18.000
		TextLabel.TextWrapped = true
		TextLabel.TextXAlignment = Enum.TextXAlignment.Right
		TweenService:Create(TextLabel, TweenInfo.new(1.8), {TextTransparency = 0, BackgroundTransparency = 0.750}):Play()

		local TextGradient = Instance.new("UIGradient")
		TextGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(138, 230, 255))}
		TextGradient.Parent = TextLabel

		local NewWidth = game.TextService:GetTextSize(name, 18, Enum.Font.SourceSans, Vector2.new(0, 0)).X
		local NewSize = UDim2.new(0.01, game.TextService:GetTextSize(name , 18, Enum.Font.SourceSans, Vector2.new(0,0)).X, 0,20)
		if name == "" then
			NewSize = UDim2.fromScale(0,0)
		end

		TextLabel.Position = UDim2.new(1, -NewWidth, 0, 0)
		TextLabel.Size = NewSize
		table.insert(ArrayTable,TextLabel)
		table.sort(ArrayTable,function(a,b) return game.TextService:GetTextSize(a.Text .. "  ", 18, Enum.Font.SourceSans, Vector2.new(0,20)).X > game.TextService:GetTextSize(b.Text .. "  ", 18, Enum.Font.SourceSans,Vector2.new(0,20)).X end)
		for i,v in ipairs(ArrayTable) do
			v.LayoutOrder = i
		end
	end

	local function RemoveArray(name)
		table.sort(ArrayTable,function(a,b) return game.TextService:GetTextSize(a.Text.."  ",18,Enum.Font.SourceSans,Vector2.new(0,20)).X > game.TextService:GetTextSize(b.Text.."  ",18,Enum.Font.SourceSans,Vector2.new(0,20)).X end)
		local c = 0
		for i,v in ipairs(ArrayTable) do
			c += 1
			if (v.Text == name) then
				TweenService:Create(v, TweenInfo.new(0.2), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
				v:Destroy()
				table.remove(ArrayTable,c)
			else
				v.LayoutOrder = i
			end
		end
	end

	--[[
	local MainOpen = Instance.new("TextButton")
	MainOpen.Parent = ScreenGui
	MainOpen.AnchorPoint = Vector2.new(0.5, 0.5)
	MainOpen.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	MainOpen.BackgroundTransparency = 0.550
	MainOpen.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MainOpen.BorderSizePixel = 0
	MainOpen.Position = UDim2.new(0.984627843, 0, 0.976650417, 0)
	MainOpen.Size = UDim2.new(0, 25, 0, 25)
	MainOpen.ZIndex = 5
	MainOpen.Font = Enum.Font.SourceSans
	MainOpen.Text = Library.CustomTitle
	MainOpen.TextColor3 = Color3.fromRGB(255, 255, 255)
	MainOpen.TextScaled = true
	MainOpen.TextSize = 14.000
	MainOpen.TextWrapped = true
	
	local UICorner_2 = Instance.new("UICorner")
	UICorner_2.CornerRadius = UDim.new(0, 4)
	UICorner_2.Parent = MainOpen
	
	MainOpen.MouseButton1Click:Connect(function()
		MainFrame.Visible = not MainFrame.Visible
	end)
	--]]

	UserInputService.InputBegan:Connect(function(Input, isTyping)
		if Input.KeyCode == Enum.KeyCode.RightShift and not isTyping then
			MainFrame.Visible = not MainFrame.Visible
		end
	end)

	function Main:CreateTab(name, icon, iconcolor)
		local Tabs = {}

		local TabHolder = Instance.new("Frame")
		TabHolder.ZIndex = 2
		TabHolder.Parent = MainFrame
		TabHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		TabHolder.BackgroundTransparency = 0.030
		TabHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabHolder.BorderSizePixel = 0
		TabHolder.Size = UDim2.new(0, 185, 0, 25)
		MakeDraggable(TabHolder)

		local TabName = Instance.new("TextLabel")
		TabName.ZIndex = 2
		TabName.Parent = TabHolder
		TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabName.BackgroundTransparency = 1.000
		TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabName.BorderSizePixel = 0
		TabName.Position = UDim2.new(0, 5, 0, 0)
		TabName.Size = UDim2.new(0, 145, 1, 0)
		TabName.Font = Enum.Font.Nunito
		TabName.Text = name
		TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabName.TextSize = 18.000
		TabName.TextWrapped = true
		TabName.TextXAlignment = Enum.TextXAlignment.Left

		local ImageLabel = Instance.new("ImageLabel")
		ImageLabel.ZIndex = 2
		ImageLabel.Parent = TabHolder
		ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BackgroundTransparency = 1.000
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Position = UDim2.new(0, 172, 0.5, 0)
		ImageLabel.Size = UDim2.new(0, 18, 0, 18)
		ImageLabel.Image = "http://www.roblox.com/asset/?id=" .. icon
		ImageLabel.ImageColor3 = iconcolor

		local TogglesList = Instance.new("Frame")
		TogglesList.ZIndex = 2
		TogglesList.Parent = TabHolder
		TogglesList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TogglesList.BackgroundTransparency = 1.000
		TogglesList.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TogglesList.BorderSizePixel = 0
		TogglesList.Position = UDim2.new(0, 0, 1, 0)
		TogglesList.Size = UDim2.new(1, 0, 0, 0)

		local UIListLayout = Instance.new("UIListLayout")
		UIListLayout.Parent = TogglesList
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

		function Tabs:CreateToggle(ToggleButton)
			ToggleButton = {
				Name = ToggleButton.Name,
				Keybind = ToggleButton.Keybind or "Home",
				Enabled = ToggleButton.Enabled or false,
				AutoDisable = ToggleButton.AutoDisable or false,
				Callback = ToggleButton.Callback or function() end
			}
			if not LibrarySettings.ToggleButton[ToggleButton.Name] then
				LibrarySettings.ToggleButton[ToggleButton.Name] = {
					Enabled = ToggleButton.Enabled,
					Keybind = ToggleButton.Keybind,
				}
			else
				ToggleButton.Enabled = LibrarySettings.ToggleButton[ToggleButton.Name].Enabled
				ToggleButton.Keybind = LibrarySettings.ToggleButton[ToggleButton.Name].Keybind
			end

			local ToggleButtonHolder = Instance.new("TextButton")
			ToggleButtonHolder.Parent = TogglesList
			ToggleButtonHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			ToggleButtonHolder.BackgroundTransparency = 0.230
			ToggleButtonHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleButtonHolder.BorderSizePixel = 0
			ToggleButtonHolder.Size = UDim2.new(1, 0, 0, 25)
			ToggleButtonHolder.AutoButtonColor = false
			ToggleButtonHolder.Font = Enum.Font.SourceSans
			ToggleButtonHolder.Text = ""
			ToggleButtonHolder.TextColor3 = Color3.fromRGB(0, 0, 0)
			ToggleButtonHolder.TextSize = 14.000

			local ToggleName = Instance.new("TextLabel")
			ToggleName.Parent = ToggleButtonHolder
			ToggleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleName.BackgroundTransparency = 1.000
			ToggleName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleName.BorderSizePixel = 0
			ToggleName.Position = UDim2.new(0, 5, 0, 0)
			ToggleName.Size = UDim2.new(0, 145, 1, 0)
			ToggleName.Font = Enum.Font.SourceSans
			ToggleName.Text = ToggleButton.Name
			ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
			ToggleName.TextSize = 16.000
			ToggleName.TextWrapped = true
			ToggleName.TextXAlignment = Enum.TextXAlignment.Left

			local OpenMenu = Instance.new("TextLabel")
			OpenMenu.Parent = ToggleButtonHolder
			OpenMenu.AnchorPoint = Vector2.new(0.5, 0.5)
			OpenMenu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			OpenMenu.BackgroundTransparency = 1.000
			OpenMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
			OpenMenu.BorderSizePixel = 0
			OpenMenu.Position = UDim2.new(0, 173, 0.5, 0)
			OpenMenu.Size = UDim2.new(0, 20, 0, 20)
			OpenMenu.Font = Enum.Font.SourceSans
			OpenMenu.Text = ">"
			OpenMenu.TextColor3 = Color3.fromRGB(255, 255, 255)
			OpenMenu.TextScaled = true
			OpenMenu.TextSize = 14.000
			OpenMenu.TextWrapped = true

			local UIGradient = Instance.new("UIGradient")
			UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(138, 230, 255))}
			UIGradient.Parent = ToggleButtonHolder
			UIGradient.Enabled = false

			local ToggleMenuOpened = false
			local ToggleMenuOld = UDim2.new(1, 0, 0, 0)
			local ToggleMenuNew = UDim2.new(1, 0, 0, 125)
			local ToggleMenu = Instance.new("Frame")
			ToggleMenu.Parent = TogglesList
			ToggleMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			ToggleMenu.BackgroundTransparency = 0.150
			ToggleMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleMenu.BorderSizePixel = 0
			ToggleMenu.Position = UDim2.new(0, 0, 25, 0)
			ToggleMenu.Size = UDim2.new(1, 0, 0, 125)
			ToggleMenu.Visible = false

			local Keybinds = Instance.new("TextBox")
			Keybinds.Parent = ToggleMenu
			Keybinds.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Keybinds.BackgroundTransparency = 1.000
			Keybinds.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Keybinds.BorderSizePixel = 0
			Keybinds.LayoutOrder = -1
			Keybinds.Size = UDim2.new(1, 0, 0, 25)
			Keybinds.Font = Enum.Font.SourceSans
			Keybinds.PlaceholderColor3 = Color3.fromRGB(220, 220, 220)
			Keybinds.PlaceholderText = "None"
			Keybinds.Text = ""
			Keybinds.TextColor3 = Color3.fromRGB(255, 255, 255)
			Keybinds.TextSize = 14.000
			UserInputService.InputBegan:Connect(function(Input, isTyping)
				if Input.UserInputType == Enum.UserInputType.Keyboard then
					if Keybinds:IsFocused() then
						ToggleButton.Keybind = Input.KeyCode.Name
						Keybinds.Text = Input.KeyCode.Name
						Keybinds.PlaceholderText = Input.KeyCode.Name
						Keybinds:ReleaseFocus()
						LibrarySettings.ToggleButton[ToggleButton.Name].Keybind = ToggleButton.Keybind
					elseif ToggleButton.Keybind == "Backspace" then
						ToggleButton.Keybind = "Home"
						Keybinds.Text = ""
						Keybinds.PlaceholderText = "None"
						LibrarySettings.ToggleButton[ToggleButton.Name].Keybind = ToggleButton.Keybind
					end
				end
			end)

			spawn(function()
				while true do
					wait()
					if ToggleMenuOpened then
						Keybinds.Visible = true
					else
						Keybinds.Visible = false
					end
				end
			end)

			local UIListLayout_2 = Instance.new("UIListLayout")
			UIListLayout_2.Parent = ToggleMenu
			UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

			local function ToggleButtonClicked()
				if ToggleButton.Enabled then
					LibrarySettings.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
					TweenService:Create(ToggleButtonHolder, TweenInfo.new(0.4), {Transparency = 0,BackgroundColor3 = Color3.fromRGB(255, 0, 127)}):Play()
					TweenService:Create(UIGradient, TweenInfo.new(0.4), {Enabled = true}):Play()
					AddArray(ToggleButton.Name)
					--[[
					ToggleButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
					ToggleButtonHolder.Transparency = 0
					UIGradient.Enabled = true
					--]]
				else
					LibrarySettings.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
					TweenService:Create(ToggleButtonHolder, TweenInfo.new(0.4), {Transparency = 0.230,BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
					TweenService:Create(UIGradient, TweenInfo.new(0.4), {Enabled = false}):Play()
					RemoveArray(ToggleButton.Name)
					--[[
					ToggleButtonHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
					ToggleButtonHolder.Transparency = 0.230
					UIGradient.Enabled = false
					--]]
				end
			end

			ToggleButtonHolder.MouseButton1Click:Connect(function()
				ToggleButton.Enabled = not ToggleButton.Enabled
				ToggleButtonClicked()

				if ToggleButton.Callback then
					ToggleButton.Callback(ToggleButton.Enabled)
				end
			end)

			ToggleButtonHolder.MouseButton2Click:Connect(function()
				ToggleMenuOpened = not ToggleMenuOpened
				if ToggleMenuOpened then
					ToggleMenu.AutomaticSize = Enum.AutomaticSize.Y
					TweenService:Create(OpenMenu, TweenInfo.new(0.4), {Rotation = 90}):Play()
					TweenService:Create(ToggleMenu, TweenInfo.new(0.6), {Size = ToggleMenuNew}):Play()
					ToggleMenu.Visible = true
				else
					ToggleMenu.AutomaticSize = Enum.AutomaticSize.None
					ToggleMenu.Visible = false
					TweenService:Create(OpenMenu, TweenInfo.new(0.4), {Rotation = 0}):Play()
					TweenService:Create(ToggleMenu, TweenInfo.new(0.6), {Size = ToggleMenuOld}):Play()
				end
			end)

			if ToggleButton.Keybind then
				UserInputService.InputBegan:Connect(function(Input, isTyping)
					if Input.KeyCode == Enum.KeyCode[ToggleButton.Keybind] and not isTyping then
						ToggleButton.Enabled = not ToggleButton.Enabled
						ToggleButtonClicked()

						if ToggleButton.Callback then
							ToggleButton.Callback(ToggleButton.Enabled)
						end
					end
				end)
			end

			function ToggleButton:CreateMiniToggle(MiniToggle)
				MiniToggle = {
					Name = MiniToggle.Name,
					Enabled = MiniToggle.Enabled or false,
					Callback = MiniToggle.Callback or function() end
				}
				if not LibrarySettings.ToggleButton.MiniToggle[MiniToggle.Name] then
					LibrarySettings.ToggleButton.MiniToggle[MiniToggle.Name] = {
						Enabled = MiniToggle.Enabled
					}
				else
					MiniToggle.Enabled = LibrarySettings.ToggleButton.MiniToggle[MiniToggle.Name].Enabled
				end

				local MiniToggleHolder = Instance.new("Frame")
				MiniToggleHolder.Parent = ToggleMenu
				MiniToggleHolder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				MiniToggleHolder.BackgroundTransparency = 1.000
				MiniToggleHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleHolder.BorderSizePixel = 0
				MiniToggleHolder.Size = UDim2.new(1, 0, 0, 25)
				spawn(function()
					while true do
						wait()
						if ToggleMenuOpened then
							MiniToggleHolder.Visible = true
						else
							MiniToggleHolder.Visible = false
						end
					end
				end)

				local MiniToggleHolderName = Instance.new("TextLabel")
				MiniToggleHolderName.Parent = MiniToggleHolder
				MiniToggleHolderName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleHolderName.BackgroundTransparency = 1.000
				MiniToggleHolderName.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleHolderName.BorderSizePixel = 0
				MiniToggleHolderName.Position = UDim2.new(0, 5, 0, 0)
				MiniToggleHolderName.Size = UDim2.new(0, 175, 1, 0)
				MiniToggleHolderName.Font = Enum.Font.SourceSans
				MiniToggleHolderName.Text = MiniToggle.Name
				MiniToggleHolderName.TextColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleHolderName.TextSize = 16.000
				MiniToggleHolderName.TextWrapped = true
				MiniToggleHolderName.TextXAlignment = Enum.TextXAlignment.Left

				local MiniToggleHolderTrigger = Instance.new("TextButton")
				MiniToggleHolderTrigger.Parent = MiniToggleHolder
				MiniToggleHolderTrigger.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				MiniToggleHolderTrigger.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleHolderTrigger.BorderSizePixel = 0
				MiniToggleHolderTrigger.Position = UDim2.new(0, 165, 0, 5)
				MiniToggleHolderTrigger.Size = UDim2.new(0, 15, 0, 15)
				MiniToggleHolderTrigger.AutoButtonColor = false
				MiniToggleHolderTrigger.Font = Enum.Font.SourceSans
				MiniToggleHolderTrigger.Text = "x"
				MiniToggleHolderTrigger.TextTransparency = 1
				MiniToggleHolderTrigger.TextColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleHolderTrigger.TextSize = 18.000
				MiniToggleHolderTrigger.TextWrapped = true
				MiniToggleHolderTrigger.TextYAlignment = Enum.TextYAlignment.Bottom

				local UICorner = Instance.new("UICorner")
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = MiniToggleHolderTrigger

				local function MiniToggleClick()
					if MiniToggle.Enabled then
						LibrarySettings.ToggleButton.MiniToggle[MiniToggle.Name].Enabled = MiniToggle.Enabled
						TweenService:Create(MiniToggleHolderTrigger, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
					else
						LibrarySettings.ToggleButton.MiniToggle[MiniToggle.Name].Enabled = MiniToggle.Enabled
						TweenService:Create(MiniToggleHolderTrigger, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
					end
				end

				MiniToggleHolderTrigger.MouseButton1Click:Connect(function()
					MiniToggle.Enabled = not MiniToggle.Enabled
					MiniToggleClick()

					if MiniToggle.Callback then
						MiniToggle.Callback(MiniToggle.Enabled)
					end
				end)
				return MiniToggle
			end

			function ToggleButton:CreateSlider(Slider)
				Slider = {
					Name = Slider.Name,
					Min = Slider.Min or 0,
					Max = Slider.Max or 100,
					Default = Slider.Default,
					Callback = Slider.Callback or function() end
				}
				if not LibrarySettings.ToggleButton.Sliders[Slider.Name] then
					LibrarySettings.ToggleButton.Sliders[Slider.Name] = {
						Default = Slider.Default
					}
				else
					Slider.Default = LibrarySettings.ToggleButton.Sliders[Slider.Name].Default
				end

				local Value
				local Dragged = false
				local SliderHolder = Instance.new("Frame")
				SliderHolder.Parent = ToggleMenu
				SliderHolder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				SliderHolder.BackgroundTransparency = 1.000
				SliderHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolder.BorderSizePixel = 0
				SliderHolder.Size = UDim2.new(1, 0, 0, 28)
				spawn(function()
					while true do
						wait()
						if ToggleMenuOpened then
							SliderHolder.Visible = true
						else
							SliderHolder.Visible = false
						end
					end
				end)

				local SliderHolderName = Instance.new("TextLabel")
				SliderHolderName.Parent = SliderHolder
				SliderHolderName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderHolderName.BackgroundTransparency = 1.000
				SliderHolderName.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderName.BorderSizePixel = 0
				SliderHolderName.Position = UDim2.new(0, 5, 0, 0)
				SliderHolderName.Size = UDim2.new(1, 0, 0, 15)
				SliderHolderName.Font = Enum.Font.SourceSans
				SliderHolderName.Text = Slider.Name
				SliderHolderName.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderHolderName.TextScaled = true
				SliderHolderName.TextSize = 16.000
				SliderHolderName.TextWrapped = true
				SliderHolderName.TextXAlignment = Enum.TextXAlignment.Left

				local SliderHolderValue = Instance.new("TextLabel")
				SliderHolderValue.Parent = SliderHolder
				SliderHolderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderHolderValue.BackgroundTransparency = 1.000
				SliderHolderValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderValue.BorderSizePixel = 0
				SliderHolderValue.Size = UDim2.new(0, 180, 0, 15)
				SliderHolderValue.Font = Enum.Font.SourceSans
				SliderHolderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderHolderValue.TextScaled = true
				SliderHolderValue.TextSize = 16.000
				SliderHolderValue.TextWrapped = true
				SliderHolderValue.TextXAlignment = Enum.TextXAlignment.Right

				local SliderHolderBack = Instance.new("Frame")
				SliderHolderBack.Parent = SliderHolder
				SliderHolderBack.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
				SliderHolderBack.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderBack.BorderSizePixel = 0
				SliderHolderBack.Position = UDim2.new(0, 5, 0, 18)
				SliderHolderBack.Size = UDim2.new(0, 172, 0, 8)

				local SliderHolderFront = Instance.new("Frame")
				SliderHolderFront.Parent = SliderHolderBack
				SliderHolderFront.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
				SliderHolderFront.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderFront.BorderSizePixel = 0
				SliderHolderFront.Size = UDim2.new(0, 50, 1, 0)

				local SliderHolderGradient = Instance.new("UIGradient")
				SliderHolderGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(138, 230, 255))}
				SliderHolderGradient.Parent = SliderHolderFront

				local SliderHolderMain = Instance.new("TextButton")
				SliderHolderMain.Parent = SliderHolderFront
				SliderHolderMain.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				SliderHolderMain.BackgroundTransparency = 0.150
				SliderHolderMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderMain.BorderSizePixel = 0
				SliderHolderMain.Position = UDim2.new(1, 0, 0, -2)
				SliderHolderMain.Size = UDim2.new(0, 8, 0, 12)
				SliderHolderMain.Font = Enum.Font.SourceSans
				SliderHolderMain.Text = ""
				SliderHolderMain.TextColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderMain.TextSize = 14.000

				local function SliderDragged(input)
					local InputPos = input.Position
					Value = math.clamp((InputPos.X - SliderHolderBack.AbsolutePosition.X) / SliderHolderBack.AbsoluteSize.X, 0, 1)
					local SliderValue = math.round(Value * (Slider.Max - Slider.Min)) + Slider.Min
					SliderHolderFront.Size = UDim2.fromScale(Value, 1)
					SliderHolderValue.Text = SliderValue
					Slider.Callback(SliderValue)
					LibrarySettings.ToggleButton.Sliders[Slider.Name].Default = SliderValue
				end

				SliderHolderMain.MouseButton1Down:Connect(function()
					Dragged = true
				end)

				UserInputService.InputChanged:Connect(function(input)
					if Dragged and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						SliderDragged(input)
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						Dragged = false
					end
				end)

				if Slider.Default then
					SliderHolderValue.Text = Slider.Default
					Slider.Callback(Slider.Default)
				end
				return Slider
			end

			function ToggleButton:CreateDropdown(Dropdown)
				Dropdown = {
					Name = Dropdown.Name,
					List = Dropdown.List or {},
					Default = Dropdown.Default,
					Callback = Dropdown.Callback or function() end
				}
				if not LibrarySettings.ToggleButton.Dropdown[Dropdown.Name] then
					LibrarySettings.ToggleButton.Dropdown[Dropdown.Name] = {
						Default = Dropdown.Default
					}
				else
					Dropdown.Default = LibrarySettings.ToggleButton.Dropdown[Dropdown.Name].Default
				end

				local Selected
				local DropdownHolder = Instance.new("TextButton")
				DropdownHolder.Parent = ToggleMenu
				DropdownHolder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				DropdownHolder.BackgroundTransparency = 1.000
				DropdownHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownHolder.BorderSizePixel = 0
				DropdownHolder.Size = UDim2.new(1, 0, 0, 25)
				DropdownHolder.AutoButtonColor = false
				DropdownHolder.Font = Enum.Font.SourceSans
				DropdownHolder.Text = ""
				DropdownHolder.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownHolder.TextSize = 16.000
				DropdownHolder.TextWrapped = true
				DropdownHolder.TextXAlignment = Enum.TextXAlignment.Left

				local DropdownSelected = Instance.new("TextLabel")
				DropdownSelected.Parent = DropdownHolder
				DropdownSelected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownSelected.BackgroundTransparency = 1.000
				DropdownSelected.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownSelected.BorderSizePixel = 0
				DropdownSelected.Size = UDim2.new(0, 180, 1, 0)
				DropdownSelected.Font = Enum.Font.SourceSans
				DropdownSelected.Text = Dropdown.Default or "None"
				DropdownSelected.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownSelected.TextSize = 16.000
				DropdownSelected.TextWrapped = true
				DropdownSelected.TextXAlignment = Enum.TextXAlignment.Right

				local DropdownMode = Instance.new("TextLabel")
				DropdownMode.Parent = DropdownHolder
				DropdownMode.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownMode.BackgroundTransparency = 1.000
				DropdownMode.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownMode.BorderSizePixel = 0
				DropdownMode.Position = UDim2.new(0, 5, 0, 0)
				DropdownMode.Size = UDim2.new(0, 45, 1, 0)
				DropdownMode.Font = Enum.Font.SourceSans
				DropdownMode.Text = "Mode"
				DropdownMode.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownMode.TextSize = 16.000
				DropdownMode.TextWrapped = true
				DropdownMode.TextXAlignment = Enum.TextXAlignment.Left

				local CurrentDropdown = 1
				DropdownHolder.MouseButton1Click:Connect(function()
					DropdownSelected.Text = Dropdown.List[CurrentDropdown]
					Dropdown.Callback(Dropdown.List[CurrentDropdown])
					Selected = Dropdown.List[CurrentDropdown]
					CurrentDropdown = CurrentDropdown % #Dropdown.List + 1
					LibrarySettings.ToggleButton.Dropdown[Dropdown.Name].Default = Selected
				end)

				if Dropdown.Default then
					Dropdown.Callback(Dropdown.Default)
				end

				return Dropdown
			end

			return ToggleButton
		end

		return Tabs
	end

	return Main
end

return Library
