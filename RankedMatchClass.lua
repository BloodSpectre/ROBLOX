
--// The ranked match instance
--// Tom_#6754 // BIoodSpectre
--// class:New()

--//USE OF METATABLES

--[[
	
	// STILL TO DO:
	
	// - HANDLE PLAYER LEAVING
	// - USER INTERFACES
	// - SPECIAL EXCEPTIONS
	
	// - MAIN MATCHMAKING SERVICE REWORK

]]

--//Predefines
local teams = game:GetService("Teams")
local lobby = game.Teams.Lobby
local competitors = game.Teams.Competitors

local class = {}

class.__index = class

--// DEFAULT PARAMS
class.RoundWin = 3
class.Player1 = nil
class.Player2 = nil
class.Player1Score = 0
class.Player2Score = 0
class.MatchOngoing = false
class.Winner = "UNDECIDED"
class.Round = 0
class.MatchID = 0

class.Player1Spawn = game.Workspace.Arena.Player1Spawn.CFrame
class.Player2Spawn = game.Workspace.Arena.Player2Spawn.CFrame

function class:getAttributes()
	print(string.format("MATCH: %s", self.MatchID))
	print(string.format("Player1: %s", self.Player1.Name))
	print(string.format("Player2: %s", self.Player2.Name))
	print(string.format("Ongoing: %s", tostring(self.MatchOngoing)))
	
	if self.Winner == "UNDECIDED" then
		print(string.format("Winner: %s", self.Winner))
	else
		print(string.format("Winner: %s", self.Winner.Name))
	end
end

--// CONSTRUCTOR: Passes self
function class:New()
	self.MatchID = "1v1x"..tostring(math.random(1,100000))
	local tbl = setmetatable({}, self)
	tbl.__index = tbl
	return tbl
end

--//////////////////////////////////////

function resetMatch(self)
	
	wait(1) -- // wait for respawn
	
	self.Player1.Character.Humanoid.Health=self.Player1.Character.Humanoid.MaxHealth
	self.Player2.Character.Humanoid.Health=self.Player2.Character.Humanoid.MaxHealth
	
	self.Player1.Character.HumanoidRootPart.CFrame = self.Player1Spawn
	self.Player2.Character.HumanoidRootPart.CFrame = self.Player2Spawn
	
end

function giveStats(self)
	if self.Winner == self.Player1 then
		game.ServerStorage[".Ranked"][self.Player1.Name].RankedWins.Value += 1
	elseif self.Winner == self.Player2 then
		game.ServerStorage[".Ranked"][self.Player2.Name].RankedWins.Value += 1
	end
	print("Awarded Stats")
end

function endMatch(self)
	wait(3.5) -- // Await character respawn
	local success,errormsg = pcall(function()
		self.Player1.Character.Humanoid.Health=0
		self.Player2.Character.Humanoid.Health=0
		--// Reset Arena
	end)
	if not success then
		warn(errormsg)
	end
end

function class:Initiate()
	
	--//SETUP DEATH HANDLERS
	
	self.MatchOngoing = true;
	
	print("INITIATING MATCH: "..self.MatchID)
	
	wait(3) -- // wait for char spawning
	
	resetMatch(self)
	
	self.Player1.Character.Humanoid.Died:Connect(function()
		if self.MatchOngoing == true then
			print("PLAYER 1 DIED, INCREASING PLAYER 2 SCORE")
			self.Player2Score = self.Player2Score + 1
			resetMatch(self)
		end
	end)
	self.Player1.CharacterAdded:Connect(function()
		if self.MatchOngoing == true then
			self.Player1.Character.Humanoid.Died:Connect(function()
				if self.MatchOngoing == true then
					print("PLAYER 1 DIED, INCREASING PLAYER 2 SCORE")
					self.Player2Score = self.Player2Score + 1
					resetMatch(self)
				end
			end)
		end
	end)
	
	self.Player2.Character.Humanoid.Died:Connect(function()
		if self.MatchOngoing == true then
			print("PLAYER 2 DIED, INCREASING PLAYER 1 SCORE")
			self.Player1Score = self.Player1Score + 1
			resetMatch(self)
		end
	end)
	self.Player2.CharacterAdded:Connect(function()
		if self.MatchOngoing == true then
			self.Player2.Character.Humanoid.Died:Connect(function()
				if self.MatchOngoing == true then
					print("PLAYER 2 DIED, INCREASING PLAYER 1 SCORE")
					self.Player1Score = self.Player1Score + 1
					resetMatch(self)
				end
			end)
		end
	end)
	
	-- // ASYNC Score checker
	
	local scorechecker = coroutine.create(function()
		while wait(1) do
			--print("RUNNING SCORE CHECK")
			if self.MatchOngoing == true then
				if self.Player1Score == self.RoundWin then
					print(self.Player1.Name.." has won the match!")
					self.Winner = self.Player1
					self:Stop(true)
				end
				if self.Player2Score == self.RoundWin then
					print(self.Player2.Name.." has won the match!")
					self.Winner = self.Player2
					self:Stop(true)
				end
			else
				coroutine.yield()
			end
		end
	end)
	
	coroutine.resume(scorechecker) -- //start the async checker
	
	--///////////////////////
	
end

function class:Stop(awardWinner)
	print("STOPPING MATCH "..tostring(self.MatchID))
	self.MatchOngoing = false
	endMatch(self)
	if awardWinner == true then
		giveStats(self)
	end
	wait(3)
	print("MATCH DELETED: "..self.MatchID)
	self = nil
end


return class
