## License
Do whatever you want with this. No attribution requir

# AltTracker
A World of Warcraft 3.3.5a (WotLK) addon that shows main character names for alts and highlights banned players in chat and unit frames.

## What It Does

- **Chat Messages**: Adds `[MainName]` before messages from known alts
- **Banned Players**: Marks banned players with `[BANNED: Reason]` in red
- **Unit Frames**: Shows main names in party, raid, and target frames
- **HealBot Support**: Works with HealBot unit frames

## Installation

1. Download the addon
2. Extract to `../World of Warcraft/Interface/AddOns/AltTracker/`
3. Restart WoW or reload UI (`/reload`)

## Configuration

Edit `Data.lua` to add your own data:

AltTracker_Data = {
    ["YourMain"] = {"YourAlt1", "YourAlt2"},
    ["OtherMain"] = {"TheirAlt1", "TheirAlt2"},
}

BanList_Data = {
    ["NinjaPuller"] = {"BadPlayer1"},
    ["Toxic"] = {"BadPlayer2", "BadPlayer3"},
    ["Leaver"] = {"Quitter1"},
}

Commands
/alts -	Show help
/alts list -	Display all main/alt relationships
/alts bans -	Display ban list
/alts reload -	Reload configuration after editing Data.lua
/alts test -	Test if data loaded correctly
Files

    AltTracker.toc - Addon metadata

    Core.lua - Main addon code

    Data.lua - Your configuration (edit this file)

Requirements

    World of Warcraft 3.3.5a (Wrath of the Lich King)

Notes

    Edit Data.lua while WoW is closed, or use /alts reload after editing

    Character names are case-insensitive

Credits

Created with assistance from DeepSeek AI.
