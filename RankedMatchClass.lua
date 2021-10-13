
--// The ranked match instance
--// Tom_#6754 // BIoodSpectre
--// class:New()

--//USE OF METATABLES

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
	
	wait(2) -- // wait for respawn
	
	self.Player1.Character.Humanoid.Health=self.Player1.Character.Humanoid.MaxHealth
	self.Player2.Character.Humanoid.Health=self.Player2.Character.Humanoid.MaxHealth
	
	--//* TELEPORT PLAYERS *//
end

function giveStats(self)
	--//* AWARD WINS / LOSSES *//
end

function endMatch(self)
	wait(3) -- // Await character respawn
	pcall(function()
		self.Player1.Character.Humanoid.Health=0
		self.Player2.Character.Humanoid.Health=0
		--// Reset Arena
	end)
end

function class:Initiate()
	
	--//SETUP DEATH HANDLERS
	
	self.MatchOngoing = true;
	
	print("INITIATING MATCH: "..self.MatchID)
	
	wait(3) -- // wait for char spawning
	
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
					print("PLAYER 1 DIED, INCREASING PLAYER 2 SCORE")
					self.Player2Score = self.Player2Score + 1
					resetMatch(self)
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
				print("PLAYER 2 DIED, INCREASING PLAYER 1 SCORE")
				self.Player1Score = self.Player1Score + 1
				resetMatch(self)
			end)
		end
	end)
	
	-- // ASYNC Score checker
	
	scorechecker = coroutine.create(function()
		while wait(1) do
			--print("RUNNING SCORE CHECK")
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
		end
	end)
	
	coroutine.resume(scorechecker) -- //start the async checker
	
	--///////////////////////
	
end

function class:Stop(awardWinner)
	print("STOPPING MATCH "..tostring(self.MatchID))
	self.MatchOngoing = false
	if awardWinner == true then
		giveStats(self)
	end
	coroutine.yield(scorechecker)
	endMatch(self)
	spawn(function()
		wait(5)
		print("MATCH DELETED: "..self.MatchID)
		self = nil
	end)
end


return class
