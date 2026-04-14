local addonName = "AltTracker"
local frame = CreateFrame("Frame")

-- Store reverse lookup (alt -> main)
local altToMain = {}
local banList = {}

-- Build reverse lookup table
local function BuildLookupTable()
    wipe(altToMain)
    wipe(banList)
    
    if AltTracker_Data then
        for mainName, alts in pairs(AltTracker_Data) do
            for _, alt in ipairs(alts) do
                if alt and alt ~= "" then
                    altToMain[strupper(alt)] = mainName
                    altToMain[strupper(alt.."-")] = mainName
                end
            end
        end
    end
    
    if BanList_Data then
        for reason, chars in pairs(BanList_Data) do
            for _, char in ipairs(chars) do
                if char and char ~= "" then
                    banList[strupper(char)] = reason
                    banList[strupper(char.."-")] = reason
                end
            end
        end
    end
end

-- Get main name for an alt
local function GetMainName(altName)
    if not altName or altName == "" then return nil end
    
    local cleanName = altName
    local dashPos = string.find(altName, "-")
    if dashPos then
        cleanName = string.sub(altName, 1, dashPos - 1)
    end
    
    return altToMain[strupper(cleanName)]
end

-- Get ban reason for a character
local function GetBanReason(charName)
    if not charName or charName == "" then return nil end
    
    local cleanName = charName
    local dashPos = string.find(charName, "-")
    if dashPos then
        cleanName = string.sub(charName, 1, dashPos - 1)
    end
    
    return banList[strupper(cleanName)]
end

-- Rename a character name for display
local function RenameName(originalName)
    if not originalName or originalName == "" then return originalName end
    
    local cleanName = originalName
    local realmPart = ""
    local dashPos = string.find(originalName, "-")
    if dashPos then
        cleanName = string.sub(originalName, 1, dashPos - 1)
        realmPart = string.sub(originalName, dashPos)
    end
    
    local banReason = banList[strupper(cleanName)]
    local main = altToMain[strupper(cleanName)]
    
    if banReason then
        return "|cffff0000" .. cleanName .. " [" .. banReason .. "]|r" .. realmPart
    elseif main then
        return cleanName .. " (" .. main .. ")" .. realmPart
    end
    return originalName
end

-- HOOK THE MESSAGE HANDLER - Prepends main name or ban reason to message
local originalChatFrame_MessageEventHandler = ChatFrame_MessageEventHandler
if originalChatFrame_MessageEventHandler then
    ChatFrame_MessageEventHandler = function(chatFrame, event, ...)
        local args = {...}
        
        -- args[2] is the sender name for most events
        if args[2] and type(args[2]) == "string" then
            local banReason = GetBanReason(args[2])
            local main = GetMainName(args[2])
            
            if banReason then
                -- Prepend [Reason] to the message (args[1])
                args[1] = "|cffff0000[" .. banReason .. "]|r " .. (args[1] or "")
            elseif main then
                -- Prepend [Main] to the message (args[1])
                args[1] = "|cffffaa00[" .. main .. "]|r " .. (args[1] or "")
            end
        end
        
        return originalChatFrame_MessageEventHandler(chatFrame, event, unpack(args))
    end
end

-- UPDATE DEFAULT PARTY FRAMES
local function UpdatePartyFrames()
    for i = 1, 4 do
        local partyFrame = _G["PartyMemberFrame" .. i]
        if partyFrame and partyFrame.name then
            local name = UnitName("party" .. i)
            if name then
                local newName = RenameName(name)
                if newName ~= name then
                    partyFrame.name:SetText(newName)
                end
            end
        end
    end
end

-- UPDATE DEFAULT RAID FRAMES
local function UpdateRaidFrames()
    --if not IsInRaid() then return end
    
    for i = 1, 40 do
        local raidFrame = _G["RaidFrame" .. i]
        if raidFrame and raidFrame.name then
            local unit = "raid" .. i
            local name = UnitName(unit)
            if name then
                local newName = RenameName(name)
                if newName ~= name then
                    raidFrame.name:SetText(newName)
                end
            end
        end
    end
end

-- HEALBOT SUPPORT
local function UpdateHealBot()
    if not HealBot then return end
    
    for i = 1, 40 do
        local bar = _G["HealBot_Bar" .. i]
        if bar and bar.unit then
            local name = UnitName(bar.unit)
            if name then
                local newName = RenameName(name)
                if newName ~= name then
                    if bar.Text then
                        bar.Text:SetText(newName)
                    end
                end
            end
        end
    end
end

-- UPDATE TARGET FRAME
local function UpdateTargetFrame()
    local targetName = UnitName("target")
    if targetName then
        local newName = RenameName(targetName)
        if newName ~= targetName then
            local targetFrame = _G["TargetFrame"]
            if targetFrame and targetFrame.name then
                targetFrame.name:SetText(newName)
            end
        end
    end
end

-- PERIODIC UPDATE
local updateTimer = 0
frame:SetScript("OnUpdate", function(self, elapsed)
    updateTimer = updateTimer + elapsed
    if updateTimer >= 0.5 then
        updateTimer = 0
        UpdatePartyFrames()
        UpdateRaidFrames()
        UpdateTargetFrame()
        UpdateHealBot()
    end
end)

-- EVENT HANDLERS
local function OnEvent(self, event, ...)
    if event == "ADDON_LOADED" and ... == addonName then
        BuildLookupTable()
        UpdatePartyFrames()
        UpdateRaidFrames()
        UpdateTargetFrame()
        print("|cff00ff00AltTracker loaded!|r")
        print("|cffffaa00[Main] will appear at the start of messages|r")
        print("|cffff0000[Reason] will appear for banned players|r")
        print("|cff88aaffExample: [Elbu] Holytext: Hello|r")
    elseif event == "PARTY_MEMBERS_CHANGED" then
        UpdatePartyFrames()
        UpdateHealBot()
    elseif event == "RAID_ROSTER_UPDATE" then
        UpdateRaidFrames()
        UpdateHealBot()
    elseif event == "GROUP_ROSTER_UPDATE" then
        UpdatePartyFrames()
        UpdateRaidFrames()
        UpdateHealBot()
    elseif event == "PLAYER_TARGET_CHANGED" then
        UpdateTargetFrame()
    end
end

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PARTY_MEMBERS_CHANGED")
frame:RegisterEvent("RAID_ROSTER_UPDATE")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:SetScript("OnEvent", OnEvent)

-- SLASH COMMANDS
function AltTracker_ShowHelp()
    print("|cff00ff00AltTracker Commands:|r")
    print("  |cffffaa00/alts|r - Show this help")
    print("  |cffffaa00/alts list|r - Show all configured mains/alts")
    print("  |cffffaa00/alts bans|r - Show ban list")
    print("  |cffffaa00/alts reload|r - Reload configuration")
    print("  |cffffaa00/alts test|r - Test function")
end

function AltTracker_List()
    if not AltTracker_Data or next(AltTracker_Data) == nil then
        print("|cffff0000No aliases configured!|r")
        return
    end
    
    print("|cff00ff00=== AltTracker Configuration ===|r")
    for mainName, alts in pairs(AltTracker_Data) do
        if alts and #alts > 0 then
            local altList = table.concat(alts, ", ")
            print(string.format("|cffffaa00%s|r -> {|cff88aaff%s|r}", mainName, altList))
        end
    end
end

function AltTracker_BanList()
    if not BanList_Data or next(BanList_Data) == nil then
        print("|cffff0000No banned players configured!|r")
        return
    end
    
    print("|cff00ff00=== Ban List ===|r")
    for reason, chars in pairs(BanList_Data) do
        if chars and #chars > 0 then
            local charList = table.concat(chars, ", ")
            print(string.format("|cffff0000%s|r -> {|cffff6666%s|r}", reason, charList))
        end
    end
end

function AltTracker_Reload()
    BuildLookupTable()
    UpdatePartyFrames()
    UpdateRaidFrames()
    UpdateTargetFrame()
    UpdateHealBot()
    print("|cff00ff00AltTracker: Reloaded!|r")
end

function AltTracker_Test()
    print("|cff00ff00AltTracker Test:|r")
    print("  Holytext main: " .. tostring(GetMainName("Holytext")))
    print("  Dawil main: " .. tostring(GetMainName("Dawil")))
    print("  Nalthal main: " .. tostring(GetMainName("Nalthal")))
    print("  Sherycoke ban: " .. tostring(GetBanReason("Sherycoke")))
    print("  Mellissaa ban: " .. tostring(GetBanReason("Mellissaa")))
end

SLASH_ALTTRACKER1 = "/alts"
SLASH_ALTTRACKER2 = "/altracker"
SlashCmdList["ALTTRACKER"] = function(msg)
    if not msg or msg == "" then
        AltTracker_ShowHelp()
    elseif msg == "list" then
        AltTracker_List()
    elseif msg == "bans" then
        AltTracker_BanList()
    elseif msg == "reload" then
        AltTracker_Reload()
    elseif msg == "test" then
        AltTracker_Test()
    else
        AltTracker_ShowHelp()
    end
end