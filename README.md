## License
Do whatever you want with this. No attribution required.

# CharTracker
A World of Warcraft 3.3.5a (WotLK) addon that shows main character names for alts and highlights banned players in chat and unit frames.

## What It Does

- **Chat Messages**: Adds `[MainName]` before messages from known chars (alts)
- **Banned Players**: Marks banned players with `[Reason]` in red
- **Unit Frames**: Shows main names in party, (not raid frames), and target frames
- **HealBot Support**: CURRENTLY DOESNT WORK Works with HealBot unit frames

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
/chars -	Show help
/chars list -	Display all main/alt relationships
/chars bans -	Display ban list
/chars reload -	Reload configuration after editing Data.lua
/chars test -	Test if data loaded correctly
Files

    CharTracker.toc - Addon metadata

    Core.lua - Main addon code

    Data.lua - Your configuration (edit this file)

Requirements

    World of Warcraft 3.3.5a (Wrath of the Lich King)

Notes

    Edit Data.lua while WoW is closed, or use /chars reload after editing

    Character names are case-insensitive
<img width="828" height="44" alt="image" src="https://github.com/user-attachments/assets/aaf4e9ef-244d-41b2-b648-625ace71a9dd" />
<img width="1186" height="84" alt="image" src="https://github.com/user-attachments/assets/da41d775-2154-49a5-8ac4-63847ed5e8cf" />




Credits

Created with assistance from DeepSeek AI.
