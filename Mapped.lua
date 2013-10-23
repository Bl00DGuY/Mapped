Mapped = LibStub("AceAddon-3.0"):NewAddon("Mapped", "AceConsole-3.0", "AceEvent-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local tourist = LibStub("LibTourist-3.0");
local currentZone = GetZoneText();
local currentSubZone = GetSubZoneText();


function Mapped:OnInitialize()
    -- Called when the addon is loaded
end

function Mapped:OnEnable()
    self:Print("Version 0.0.0.1a loaded.")
end

-- Main Frame
Mapped.Main = CreateFrame("Frame", Mapped.Main, UIParent)
Mapped.Main:SetPoint("BOTTOM", "UIParent", "TOP")
Mapped.Main:SetFrameStrata("LOW")
Mapped.Main:SetHeight(80)
Mapped.Main:SetBackdrop({
	bgFile = "Interface/Tooltips/ChatBubble-Background",
	edgeFile = "Interface/Tooltips/ChatBubble-BackDrop",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 32, right = 32, top = 32, bottom = 32 }
})
Mapped.Main:SetBackdropColor(0,0,0, 1)
Mapped.Main:SetScript("OnShow", Swatter.ErrorShow)
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
Mapped.Main.Prof:SetScript("OnShow", Swatter.ErrorShow)
Mapped.Main.Prof:SetMovable(true)
Mapped.Main.Prof:EnableMouse(true)
Mapped.Main.Prof:SetClampedToScreen(true)
	-- Hide Button
Mapped.Main.Done = CreateFrame("Button", "", Mapped.Main, "OptionsButtonTemplate")
Mapped.Main.Done:SetText("Close")
Mapped.Main.Done:SetPoint("BOTTOMLEFT", Mapped.Main, "BOTTOMLEFT", 10, 5)
Mapped.Main.Done:SetScript("OnClick", function() Mapped.Main:Hide() end)
	-- Config Button
Mapped.Main.Config = CreateFrame("Button", "", Mapped.Main, "OptionsButtonTemplate")
Mapped.Main.Config:SetText("Professions")
Mapped.Main.Config:SetPoint("BOTTOMRIGHT", Mapped.Main, "BOTTOMRIGHT", -10, 5)
Mapped.Main.Config:SetScript("OnClick", function() InstanceFrameControl() end)
	-- Main Frame Text
Mapped.Main.Text = Mapped.Main:CreateFontString(nil, "LOW")
Mapped.Main.Text:Point("CENTER", 0, 0)
Mapped.Main.Text:SetFont("Interface\\Addons\\Mapped\\Font\\homespun.ttf", 20, "OUTLINE, MONOCHROME")
	-- Main Level Text
	-- Main Frame Text
Mapped.Main.LevelText = Mapped.Main:CreateFontString(nil, "LOW")
Mapped.Main.LevelText:Point("TOP", 0, 0)
Mapped.Main.LevelText:SetFont("Interface\\Addons\\Mapped\\Font\\homespun.ttf", 20, "OUTLINE, MONOCHROME")
	-- Main Frame OnUpdate Script
Mapped.Main:SetScript("OnUpdate", function(self,event,...)
	local subZoneText = GetMinimapZoneText() or ""
	local zoneText = GetRealZoneText() or UNKNOWN;
	local zoneText = GetRealZoneText()
	local low, high = tourist:GetLevel(zoneText)
	local r, g, b = tourist:GetLevelColor(zoneText)
	
	if (subZoneText ~= "") and (subZoneText ~= zoneText) then
				Mapped.Main.Text:SetText(zoneText .. ": " .. subZoneText)
			else
				Mapped.Main.Text:SetText(subZoneText)
			end
	Mapped.Main:SetWidth(self.Text:GetStringWidth() + 18)
	Mapped.Main.Prof:SetWidth(self.Text:GetStringWidth() + 18)
	if low > 0 and high > 0 then
	local r, g, b = tourist:GetLevelColor(zoneText)
	if low ~= high then
	Mapped.Main.LevelText:SetText(string.format("|cff%02x%02x%02x (%d-%d) |r", r*255, g*255, b*255, low, high))
	else
	Mapped.Main.LevelText:SetText(string.format("|cff%02x%02x%02x (%d) |r", r*255, g*255, b*255, high))
	end
	end
	ProfFrameUpdate()
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
		----- UpdateToolTip --------------------------------------------------------------
		function UpdateToolTipMain()
			local mapID = GetCurrentMapAreaID()
			local zoneText = GetMapNameByID(mapID) or UNKNOWN;
			local curPos = (zoneText.." ") or "";
			
			GameTooltip:ClearLines()
	
			-- Zone
			GameTooltip:AddDoubleLine(L["Zone : "], zoneText, 1, 1, 1, selectioncolor)
	
			-- Continent
			GameTooltip:AddDoubleLine(CONTINENT.." : ", tourist:GetContinent(zoneText), 1, 1, 1, selectioncolor)
	
			-- Home
			GameTooltip:AddDoubleLine(HOME.." :", GetBindLocation(), 1, 1, 1, selectioncolor)
			
			GameTooltip:Show()
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