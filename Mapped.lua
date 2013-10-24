Mapped = LibStub("AceAddon-3.0"):NewAddon("Mapped", "AceConsole-3.0", "AceEvent-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local tourist = LibStub("LibTourist-3.0");
local currentZone = GetZoneText();
local currentSubZone = GetSubZoneText();


function Mapped:OnInitialize()
    -- Called when the addon is loaded
end

function Mapped:OnEnable()
    self:Print("Version 1.0.0.0 loaded.")
end

-- Main Frame
Mapped.Main = CreateFrame("Frame", Mapped.Main, UIParent)
Mapped.Main:SetPoint("BOTTOM", "UIParent", "TOP")
Mapped.Main:SetFrameStrata("LOW")
Mapped.Main:SetHeight(50)
Mapped.Main:SetBackdrop({
	bgFile = "Interface/Tooltips/ChatBubble-Background",
	edgeFile = "Interface/Tooltips/ChatBubble-BackDrop",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 32, right = 32, top = 32, bottom = 32 }
})
Mapped.Main:SetBackdropColor(0,0,0, 1)
Mapped.Main:SetMovable(true)
Mapped.Main:EnableMouse(true)
Mapped.Main:SetClampedToScreen(true)
Mapped.Main.RealShow = Swatter.Error.Show
Mapped.Main.RealHide = Swatter.Error.Hide
Mapped.Main:SetScript("OnMouseDown", function() Mapped.Main:StartMoving() end)
Mapped.Main:SetScript("OnMouseUp", function() Mapped.Main:StopMovingOrSizing() end)
	-- Instance Frame
Mapped.Main.Prof = CreateFrame("Frame", Mapped.Main.Instance, Mapped.Main)
Mapped.Main.Prof:SetPoint("BOTTOM", Mapped.Main, "BOTTOM", 0, -90)
Mapped.Main.Prof:SetFrameStrata("LOW")
Mapped.Main.Prof:SetHeight(80)
Mapped.Main.Prof:SetBackdrop({
	bgFile = "Interface/Tooltips/ChatBubble-Background",
	edgeFile = "Interface/Tooltips/ChatBubble-BackDrop",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 32, right = 32, top = 32, bottom = 32 }
})
Mapped.Main.Prof:SetBackdropColor(0,0,0, 1)
Mapped.Main.Prof:SetMovable(true)
Mapped.Main.Prof:EnableMouse(true)
Mapped.Main.Prof:SetClampedToScreen(true)
Mapped.Main.Prof:Hide()
	-- Hide Button
Mapped.Main.Done = CreateFrame("Button", "", Mapped.Main, "OptionsButtonTemplate")
Mapped.Main.Done:SetText("Close")
Mapped.Main.Done:SetPoint("BOTTOMLEFT", Mapped.Main, "BOTTOMLEFT", 10, 5)
Mapped.Main.Done:SetScript("OnClick", function() Mapped.Main:Hide() end)
Mapped.Main.Done:Hide()
	-- Config Button
Mapped.Main.Config = CreateFrame("Button", "", Mapped.Main, "OptionsButtonTemplate")
Mapped.Main.Config:SetText("Professions")
Mapped.Main.Config:SetPoint("BOTTOMRIGHT", Mapped.Main, "BOTTOMRIGHT", -10, 5)
Mapped.Main.Config:SetScript("OnClick", function() InstanceFrameControl() end)
Mapped.Main.Config:Hide()
	-- Main Version Text
Mapped.Main.Version = Mapped.Main:CreateFontString(nil, "LOW")
Mapped.Main.Version:Point("TOPRIGHT", 0, -5)
Mapped.Main.Version:SetFont("Fonts\\MORPHEUS.ttf", 10, "OUTLINE")
Mapped.Main.Version:SetText("Mapped 1.0.0.0")
	-- Main Frame Text
Mapped.Main.Text = Mapped.Main:CreateFontString(nil, "LOW")
Mapped.Main.Text:Point("BOTTOM", 0, 0)
Mapped.Main.Text:SetFont("Interface\\Addons\\Mapped\\Font\\homespun.ttf", 20, "THICKOUTLINE")
Mapped.Main:SetScript("OnLeave", function() GameTooltip:Hide() end)
	-- Main Level Text
Mapped.Main.LevelText = Mapped.Main:CreateFontString(nil, "LOW")
Mapped.Main.LevelText:Point("TOP", 0, 0)
Mapped.Main.LevelText:SetFont("Interface\\Addons\\Mapped\\Font\\homespun.ttf", 20, "OUTLINE")
	-- Main Coord Text
Mapped.Main.CoordText = Mapped.Main:CreateFontString(nil, "LOW")
Mapped.Main.CoordText:Point("TOPLEFT", 10, -10)
Mapped.Main.CoordText:SetFont("Interface\\Addons\\Mapped\\Font\\homespun.ttf", 18, "OUTLINE")
	-- Prof Fishing Text
Mapped.Main.Prof.PetText = Mapped.Main.Prof:CreateFontString(nil, "LOW")
Mapped.Main.Prof.PetText:Point("TOPLEFT", 10, -10)
Mapped.Main.Prof.PetText:SetFont("Interface\\Addons\\Mapped\\Font\\homespun.ttf", 18, "OUTLINE")
	-- Prof Fishing Text
Mapped.Main.Prof.FishText = Mapped.Main.Prof:CreateFontString(nil, "LOW")
Mapped.Main.Prof.FishText:Point("TOPLEFT", 10, -30)
Mapped.Main.Prof.FishText:SetFont("Interface\\Addons\\Mapped\\Font\\homespun.ttf", 18, "OUTLINE")
	-- Main Frame OnUpdate Script

local function CurrentDungCoords(zone)
	local z, x, y = "", 0, 0;
	local dcoords
	
	if tourist:IsInstance(zone) then
		z, x, y = tourist:GetEntrancePortalLocation(zone);
	end
	
	if z == nil then
		dcoords = ""
	else
		x = tonumber(roundNum(x, 0))
		y = tonumber(roundNum(y, 0))		
		dcoords = string.format(" (%d:%d)", x, y)
	end

	return dcoords
end
	
local function CurrentDungZones(zone)

	local low, high = tourist:GetLevel(zone)
	local r, g, b = tourist:GetLevelColor(zone)
	local groupSize = tourist:GetInstanceGroupSize(zone)
	local altGroupSize = tourist:GetInstanceAltGroupSize(zone)
	local groupSizeStyle = (groupSize > 0 and string.format("|cFFFFFF00|r (%d", groupSize) or "")
	local altGroupSizeStyle = (altGroupSize > 0 and string.format("|cFFFFFF00|r/%d", altGroupSize) or "")
	
	GameTooltip:AddLine(string.format("|cff%02x%02x%02x %s", r*255, g*255, b*255, zone) .. " " .. string.format("|cff%02x%02x%02x (%d-%d) |r", r*255, g*255, b*255, low, high)
	..groupSize .. "M"
	..CurrentDungCoords(zone)
	)

end

local function CurrentRecZones(zone)

	local low, high = tourist:GetLevel(zone)
	local r, g, b = tourist:GetLevelColor(zone)
	local zContinent = tourist:GetContinent(zone)
	
	GameTooltip:AddDoubleLine(zone .. " " .. string.format("|cff%02xff00%s|r", continent == zContinent and 0 or 255, zContinent) ..(" |cff%02x%02x%02x%s|r"):format(r *255, g *255, b *255,(low == high and low or ("(%d-%d)"):format(low, high))));

end
	
Mapped.Main:SetScript("OnUpdate", function(self,event,...)
	local subZoneText = GetMinimapZoneText() or ""
	local zoneText = GetRealZoneText() or UNKNOWN;
	local zoneText = GetRealZoneText()
	local low, high = tourist:GetLevel(zoneText)
	local r, g, b = tourist:GetLevelColor(zoneText)
	local x, y = GetPlayerMapPosition("player")
	local curPos = (zoneText.." ") or "";
	local low,high = tourist:GetBattlePetLevel(zoneText)
	local minFish = tourist:GetFishingLevel(zoneText)
	
	-- GameToolTip Logic
	if MouseIsOver(self) then
	    GameTooltip:ClearLines()
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM") 
		GameTooltip:AddDoubleLine(HOME.." :", GetBindLocation(), 1, 1, 1, selectioncolor)
		
		if low ~= nil or high ~= nil then
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine("Battle Pet level".. " :", low == high and low or string.format("%d-%d", low, high), 1, 1, 1, selectioncolor)
		end
		
		GameTooltip:AddDoubleLine("Fishing" .. " : ", minFish, 1, 1, 1, selectioncolor)
		
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("Recommended Zones :", 1, 1, 1, selectioncolor)
	
		for zone in tourist:IterateRecommendedZones() do
			CurrentRecZones(zone);
		end	
		
		if tourist:DoesZoneHaveInstances(zoneText) then 
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("Instance(s): ", 1, 1, 1, selectioncolor)	
		
			for zone in tourist:IterateZoneInstances(zoneText) do
				CurrentDungZones(zone)
			end
		end		
		
		GameTooltip:Show()
	end
	
		-- Ensure the Main/Prof frame is never under 300 in width
	if (self.Text:GetStringWidth() + 18) < 300 then
		Mapped.Main:SetWidth(300)
		Mapped.Main.Prof:SetWidth(300)
		else
		Mapped.Main:SetWidth(self.Text:GetStringWidth() + 18)
		Mapped.Main.Prof:SetWidth(self.Text:GetStringWidth() + 18)
	end
	
	-- Update Coord
	local roundedX = roundNum((x * 100), 0)
	local roundedY = roundNum((y * 100), 0)
	Mapped.Main.CoordText:SetText(roundedX .. ":" .. roundedY)
	
	-- Update Zone Name
	if (subZoneText ~= "") and (subZoneText ~= zoneText) then
				Mapped.Main.Text:SetText(zoneText .. ": " .. subZoneText)
			else
				Mapped.Main.Text:SetText(subZoneText)
	end
	
	-- Update Level Text
	if low > 0 and high > 0 then
	local r, g, b = tourist:GetLevelColor(zoneText)
	if low ~= high then
	Mapped.Main.LevelText:SetText(string.format("|cff%02x%02x%02x (%d-%d) |r", r*255, g*255, b*255, low, high))
	else
	Mapped.Main.LevelText:SetText(string.format("|cff%02x%02x%02x (%d) |r", r*255, g*255, b*255, high))
	end
	end
	
	local low,high = tourist:GetBattlePetLevel(zoneText)
		if low ~= nil or high ~= nil then
			Mapped.Main.Prof.PetText:SetText("Pet Battle: " .. string.format("%d-%d", low, high), 1, 1, 1, selectioncolor)
		end
		
	local minFish = tourist:GetFishingLevel(zoneText)
		if minFish then
			Mapped.Main.Prof.FishText:SetText(PROFESSIONS_FISHING .. ": " .. minFish, 1, 1, 1, selectioncolor)
		end
	
end)

local function MappedMain_OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -4)
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("BOTTOM", Mapped.Main, "BOTTOM", 0, 0)
	GameTooltip:SetText("Je Test")
	GameTooltip:Show()
	UpdateToolTipMain()
end
	
-- Minimap Button
local db;
local defaults = {
	profile = {
		LDBIconStorage = {},
	},
};
local ldbObject = {
	type = "launcher",
	icon = "Interface\\ICONS\\spell_nature_bloodlust",
	label = "AddonName",
	OnClick = function(self, button)
		Mapped.Main:Show()
	end,
	OnTooltipShow = function(tooltip)
		tooltip:AddLine("Mapped");
	end,
};
function updateDB(self, event, database)
	db = database.profile;
	LibStub("LibDBIcon-1.0"):Refresh("AddonLDBObjectName", db.LDBIconStorage);
end
local vars = LibStub("AceDB-3.0"):New("AddonSavedVarStorage", defaults);
vars:RegisterCallback("OnProfileChanged", updateDB);
vars:RegisterCallback("OnProfileCopied", updateDB);
vars:RegisterCallback("OnProfileReset", updateDB);
db = vars.profile;

LibStub("LibDataBroker-1.1"):NewDataObject("AddonLDBObjectName", ldbObject);
LibStub("LibDBIcon-1.0"):Register("AddonLDBObjectName", ldbObject, db.LDBIconStorage);

----- Function ---------------------------------------------------------------------------
		----- InstanceFrameUpdate --------------------------------------------------------
		function ProfFrameUpdate()
		
		end
		----- InstanceFrameControl -------------------------------------------------------
		function InstanceFrameControl()
			if Mapped.Main.Prof:IsVisible() then 
				Mapped.Main.Prof:Hide() 
			else 
				Mapped.Main.Prof:Show()
			end
		end
		----- UpdateZoneLevel ------------------------------------------------------------
		local function LocLevelRange(zoneText)
			local low, high = tourist:GetLevel(zoneText)
			if low >= 1 and high >= 1 then
				local r, g, b = tourist:GetLevelColor(zoneText)
				return string.format("|cff%02x%02x%02x %d-%d|r", r*255, g*255, b*255, low, high) or ""
			end
	
			return ""
		end
		----- MappedConfig ---------------------------------------------------------------
		local function MappedConfig()
			local textStore

			local frame = AceGUI:Create("Frame")
			frame:SetTitle("Example Frame")
			frame:SetStatusText("AceGUI-3.0 Example Container Frame")
			frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
			frame:SetLayout("Flow")

			local editbox = AceGUI:Create("EditBox")
			editbox:SetLabel("Insert text:")
			editbox:SetWidth(200)
			editbox:SetCallback("OnEnterPressed", function(widget, event, text) textStore = text end)
			frame:AddChild(editbox)

			local button = AceGUI:Create("Button")
			button:SetText("Click Me!")
			button:SetWidth(200)
			button:SetCallback("OnClick", function() print(textStore) end)
			frame:AddChild(button)
		end
		----- Math ------------------------------------------------------------------------
		function roundNum(val, decimal)
			if (decimal) then
				return math.floor(((val * 10^decimal) + 0.5) / (10^decimal))
			else
				return math.floor(val+0.5)
			end
		end