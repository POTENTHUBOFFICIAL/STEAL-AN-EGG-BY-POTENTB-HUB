-- POTENT HUB - Loader
if game.PlaceId ~= 107778070777162 then
	return
end

local GIST_URL = "https://gist.githubusercontent.com/POTENTHUBOFFICIAL/2999d7c603d625f2482048bb78430b72/raw/1f3e02da1c23060fe778ecc801af9b786e8d6a5a/potent_hub.lua"

local ok, code = pcall(function()
	return game:HttpGet(GIST_URL)
end)

if not ok or not code or code == "" then
	return
end

local chunk = loadstring(code)
if chunk then
	pcall(chunk)
end
