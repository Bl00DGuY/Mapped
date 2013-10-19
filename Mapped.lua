Mapped = LibStub("AceAddon-3.0"):NewAddon("Mapped", "AceConsole-3.0", "AceEvent-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local currentZone = GetZoneText();
local currentSubZone = GetSubZoneText();

function Mapped:OnInitialize()
    -- Called when the addon is loaded
end

function Mapped:OnEnable()
    self:Print("Version 0.0.0.1a loaded.")
end

-- Main Frame
local f = CreateFrame("Frame","MappedPanel",UIParent)
f:SetFrameStrata("BACKGROUND")
f:SetWidth(512) -- Set these to whatever height/width is needed 
f:SetHeight(256) -- for your Texture

local t = f:CreateTexture(nil,"BACKGROUND")
t:SetTexture("Interface\\Addons\\Mapped\\Texture\\Mainframe.blp")
t:SetAllPoints(f)
f.texture = t

f:SetPoint("CENTER",0,0)
f:Show()

	-- Button (Main Frame)
	local button = CreateFrame("Button", nil, f)
	button:SetPoint("Bottom", f, "Bottom", 0, 0)
	button:SetWidth(80)
	button:SetHeight(32)
	
	button:SetText("Close")
	button:SetNormalFontObject("GameFontNormal")
	
	local ntex = button:CreateTexture()
	ntex:SetTexture("Interface\\Addons\\Mapped\\Texture\\ButtonHide_UP.blp")
	ntex:SetTexCoord(0, 0.625, 0, 0.6875)
	ntex:SetAllPoints()	
	button:SetNormalTexture(ntex)
	
	local htex = button:CreateTexture()
	htex:SetTexture("Interface\\Addons\\Mapped\\Texture\\ButtonHide_HIGH.blp")
	htex:SetTexCoord(0, 0.625, 0, 0.6875)
	htex:SetAllPoints()
	button:SetHighlightTexture(htex)
	
	local ptex = button:CreateTexture()
	ptex:SetTexture("Interface\\Addons\\Mapped\\Texture\\ButtonHide_DOWN.blp")
	ptex:SetTexCoord(0, 0.625, 0, 0.6875)
	ptex:SetAllPoints()
	button:SetPushedTexture(ptex)
	
	button:SetScript("OnClick", function(self, arg1)
    f:Hide()
	end)
	button:Click(f:Hide())

-- Frame Movement 
f:EnableMouse(true)
f:SetMovable(true)
f:SetScript("OnMouseDown", function(self, button)
  if button == "LeftButton" and not self.isMoving then
   self:StartMoving();
   self.isMoving = true;
  end
end)
f:SetScript("OnMouseUp", function(self, button)
  if button == "LeftButton" and self.isMoving then
   self:StopMovingOrSizing();
   self.isMoving = false;
  end
end)
f.Text = MappedPanel:CreateFontString(nil, "LOW")
f.Text:Point("CENTER", 0, 0)
f:SetAlpha(.75);

-- Version Text
--local VerTxt = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--VerTxt:SetPoint("BOTTOM", 230, 5)
--VerTxt:SetText(GetZoneText())
--VerTxt:SetFont(DEFAULT, 20, "OUTLINE, MONOCHROME")
--VerTxt:SetText("0.0.0.1a")

-- Current Location Text
local CurrentLocationTxt = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
CurrentLocationTxt:SetPoint("TOP", 80, -20)
CurrentLocationTxt:SetText(GetZoneText())
CurrentLocationTxt:SetFont("Interface\\Addons\\Mapped\\Font\\homespun.ttf", 20, "OUTLINE, MONOCHROME")

-- Current Sub_Location Text
local CurrentSubLocationTxt = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
CurrentSubLocationTxt:SetPoint("TOP", 80, -40)
CurrentSubLocationTxt:SetText(GetSubZoneText())
CurrentSubLocationTxt:SetFont("Interface\\Addons\\Mapped\\Font\\homespun.ttf", 16, "OUTLINE, MONOCHROME")

f:RegisterEvent("ZONE_CHANGED")
local function eventHandler(self, ZONE_CHANGED, ...)
 if (GetSubZoneText() == "") then
			CurrentLocationTxt:SetText(GetZoneText())
			CurrentSubLocationTxt:SetText(nil)
		else
			CurrentLocationTxt:SetText(GetZoneText())
			CurrentSubLocationTxt:SetText(GetSubZoneText())
		end	
end
f:SetScript("OnEvent", eventHandler);
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
local function eventHandler(self, ZONE_CHANGED_NEW_AREA, ...)
 if (GetSubZoneText() == "") then
			CurrentLocationTxt:SetText(GetZoneText())
			CurrentSubLocationTxt:SetText(nil)
		else
			CurrentLocationTxt:SetText(GetZoneText())
			CurrentSubLocationTxt:SetText(GetSubZoneText())
		end	
end
f:SetScript("OnEvent", eventHandler);
f:RegisterEvent("ZONE_CHANGED_INDOORS")
local function eventHandler(self, ZONE_CHANGED_INDOORS, ...)
 if (GetSubZoneText() == "") then
			CurrentLocationTxt:SetText(GetZoneText())
			CurrentSubLocationTxt:SetText(nil)
		else
			CurrentLocationTxt:SetText(GetZoneText())
			CurrentSubLocationTxt:SetText(GetSubZoneText())
		end	
end
f:SetScript("OnEvent", eventHandler);

-- Minimap Button

local db; -- File-global handle to the Database
local defaults = {
	profile = {
		LDBIconStorage = {}, -- LibDBIcon storage
	},
};

local ldbObject = {
	type = "launcher",
	icon = "Interface\\ICONS\\spell_nature_bloodlust",
--This is the icon used. Any .blp or .tga file is a valid icon.
--This path is ALWAYS relative to the World of Warcraft
--root (ie, "C:\Program Files\World of Warcraft" for
--Windows and "/Applications/World of Warcraft" for Mac)
	label = "AddonName",
	OnClick = function(self, button)
		f:Show()
	end,
	OnTooltipShow = function(tooltip)
		tooltip:AddLine("Mapped");
--Add text here. The first line is ALWAYS a "header" type.
--It will appear slightly larger than subsequent lines of text
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


----- DEBUG ---------------------------------------------------------------------------
if (devDebug == true) then

	-- Print Current Zone--------------------------------------
	function Mapped:ZONE_CHANGED()
		if (GetSubZoneText() == "") then
			self:Print("[Debug]",GetZoneText())
			CurrentLocationTxt:SetText(GetZoneText())
			CurrentSubLocationTxt:SetText(GetSubZoneText())
		else
			self:Print("[Debug]",GetZoneText()," (",GetSubZoneText(),")")
			CurrentLocationTxt:SetText(GetZoneText())
			CurrentSubLocationTxt:SetText(GetSubZoneText())
		end	
	end
	-----------------------------------------------------------
	
end