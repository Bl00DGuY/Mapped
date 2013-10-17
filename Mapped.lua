Mapped = LibStub("AceAddon-3.0"):NewAddon("Mapped", "AceConsole-3.0", "AceEvent-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local currentZone = GetZoneText();
local currentSubZone = GetSubZoneText();

function Mapped:OnInitialize()
    -- Called when the addon is loaded
end

function Mapped:OnEnable()
    self:Print("Version 0.0.0.1 loaded.")
	self:RegisterEvent("ZONE_CHANGED")
end

function Mapped:ZONE_CHANGED()
	self:Print(GetZoneText())
end

local mainFrame = AceGUI:Create("Frame")
mainFrame:SetTitle("Mapped")
mainFrame:SetStatusText("Mapped 0.0.0.1")

local labelCurZone = AceGUI:Create("Label")
labelCurZone:SetFont("Font\\homespun.ttf", 12, "OUTLINE")
labelCurZone:SetText(currentZone)
mainFrame:AddChild(labelCurZone)

local labelCurSubZone = AceGUI:Create("Label")
labelCurSubZone:SetText(currentSubZone)
mainFrame:AddChild(labelCurSubZone)