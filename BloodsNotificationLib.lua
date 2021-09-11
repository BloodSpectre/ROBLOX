
--BIoodSpectre//Tom_#6754
--Call from client only
--Don't mismatch arguements

--[[
	USAGE:
	
	-------------------------------------------------------------------
	REQUEST A TOAST NOTIFICATION: Module.ToastNotification(String TitleText, Int Duration, Table SettingsTable or nil)
	
	AVAILABLE SETTINGS:
	BackgroundColor3,
	BackgroundTransparency,
	BorderColor3,
	Size,
	Position,
	Font,
	TextColor3,
	TextStrokeColor3,
	TextStrokeTransparency
	
	Any missing settings will be set to default.
	-------------------------------------------------------------------
]]

local library = {}

local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

local notificationsDirectory

if player.PlayerGui:FindFirstChild("Notifications") then
	notificationsDirectory = player.PlayerGui["Notifications"]
else
	local dir = Instance.new("ScreenGui")
	dir.Name = "Notifications"
	dir.Parent = player.PlayerGui
	notificationsDirectory = player.PlayerGui["Notifications"]
end

local defaultToastSettings = {
	BackgroundColor3 = Color3.fromRGB(255,255,255),
	BackgroundTransparency = 1,
	BorderColor3 = Color3.fromRGB(0,0,0),
	Size = UDim2.new(0.48, 0, 0.085, 0),
	Position = UDim2.new(0.26,0, 0.275, 0),
	Font = Enum.Font.PermanentMarker,
	TextColor3 = Color3.fromRGB(191,175,0),
	TextStrokeColor3 = Color3.fromRGB(0,0,0),
	TextStrokeTransparency = 0.5,
}

library.ToastNotification = function(Text, Duration, Settings)
	
	local vText
	local vDuration
	local vSettings
	
	if not Text then warn("ERROR: No Text Arguement For Toast Creation") return else vText = Text end
	if not Duration then vDuration = 1.5 else vDuration = Duration end
	
	if not typeof(Settings) == table and Settings ~= "Default" then
		warn("WARNING: INVALID SETTINGS TABLE, REVERTING TO DEFAULT")
		vSettings = defaultToastSettings
	else
		--print("GOT CUSTOM TOAST SETTINGS")
		vSettings = Settings
	end
	
	if not Settings then vSettings = defaultToastSettings end
	
	local directory = player.PlayerGui:FindFirstChild("Notifications")
	if not directory then
		local dir2 = Instance.new("ScreenGui")
		dir2.Name = "Notifications"
		dir2.Parent = player.PlayerGui
		directory = dir2
	end
	
	local Toast = Instance.new("TextLabel")
	Toast.Name = "ToastNotification"
	
	if vSettings.BackgroundColor3 then
		Toast.BackgroundColor3 = vSettings.BackgroundColor3
	else
		Toast.BackgroundColor3 = defaultToastSettings.BackgroundColor3
	end
	
	if vSettings.BackgroundTransparency then
		Toast.BackgroundTransparency = vSettings.BackgroundTransparency
	else
		Toast.BackgroundTransparency = defaultToastSettings.BackgroundTransparency
	end
	
	if vSettings.BorderColor3 then
		Toast.BorderColor3 = vSettings.BorderColor3
	else
		Toast.BorderColor3 = defaultToastSettings.BorderColor3
	end
	
	if vSettings.Size then
		Toast.Size = vSettings.Size
	else
		Toast.Size = defaultToastSettings.Size
	end
	
	if vSettings.Position then
		Toast.Position = vSettings.Position
	else
		Toast.Position = defaultToastSettings.Position
	end
	
	if vSettings.Font then
		Toast.Font = vSettings.Font
	else
		Toast.Font = defaultToastSettings.Font
	end
	
	if vSettings.TextColor3 then
		Toast.TextColor3 = vSettings.TextColor3
	else
		Toast.TextColor3 = defaultToastSettings.TextColor3
	end
	
	if vSettings.TextStrokeColor3 then
		Toast.TextStrokeColor3 = vSettings.TextStrokeColor3
	else
		Toast.TextStrokeColor3 = defaultToastSettings.TextStrokeColor3
	end
	
	if vSettings.TextStrokeTransparency then
		Toast.TextStrokeTransparency = vSettings.TextStrokeTransparency
	else
		Toast.TextStrokeTransparency = defaultToastSettings.TextStrokeTransparency
	end
	
	Toast.TextTransparency = 1
	Toast.TextScaled = true
	Toast.TextWrapped = true
	Toast.Active = true
	Toast.SizeConstraint = "RelativeXY"
	Toast.Text = vText
	Toast.Parent = directory
	
	for i = 1,0,-0.1 do
		Toast.TextTransparency = i
		wait(0.1)
	end
	
	wait(vDuration)
	
	local GOAL_POSITION = UDim2.new(Toast.Position.X,0,0,-100)
	
	local val
	if vSettings.Position then
		val = vSettings.Position.X.Scale
	else
		val = defaultToastSettings.Position.X.Scale
	end
	
	wait(.1)
	local tween = Toast:TweenPosition(UDim2.new(val,0,-0.25,0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 2.5)
	
	wait(2.5)
	
	Toast:Remove()

	
end


return library
