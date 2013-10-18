Mapped = LibStub("AceAddon-3.0"):NewAddon("Mapped", "AceConsole-3.0", "AceEvent-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local currentZone = GetZoneText();
local currentSubZone = GetSubZoneText();
local devDebug = false;

function Mapped:OnInitialize()
    -- Called when the addon is loaded
end

function Mapped:OnEnable()
    self:Print("Version 0.0.0.1 loaded.")
	if (devDebug == true) then
	self:Print("Debug Enabled.")
	end
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
local VerTxt = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
VerTxt:SetPoint("BOTTOM", 230, 5)
VerTxt:SetText(GetZoneText())
VerTxt:SetFont(DEFAULT, 20, "OUTLINE, MONOCHROME")
VerTxt:SetText("0.0.0.1a")

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