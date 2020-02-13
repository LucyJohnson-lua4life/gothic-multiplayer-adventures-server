require "serverscripts/utils/script_functions"
local directory_scan = {}

local ALLOWED_VDF_IN_DATA = {}

ALLOWED_VDF_IN_DATA["Anims.vdf"] = true
ALLOWED_VDF_IN_DATA["Anims_Addon.vdf"] = true
ALLOWED_VDF_IN_DATA["Meshes.vdf"] = true
ALLOWED_VDF_IN_DATA["Meshes_Addon.vdf"] = true
ALLOWED_VDF_IN_DATA["Sounds.vdf"] = true
ALLOWED_VDF_IN_DATA["Sounds_Addon.vdf"] = true
ALLOWED_VDF_IN_DATA["Sounds_Bird_01.vdf"] = true
ALLOWED_VDF_IN_DATA["Sounds_bird_01.vdf"] = true
ALLOWED_VDF_IN_DATA["Speech_Addon.vdf"] = true
ALLOWED_VDF_IN_DATA["Speech_Addon_Patch.vdf"] = true
ALLOWED_VDF_IN_DATA["Speech_Wegelagerer_Deutsch.vdf"] = true
ALLOWED_VDF_IN_DATA["Speech1.vdf"] = true
ALLOWED_VDF_IN_DATA["Speech2.vdf"] = true
ALLOWED_VDF_IN_DATA["Textures.vdf"] = true
ALLOWED_VDF_IN_DATA["Textures_Addon.vdf"] = true
ALLOWED_VDF_IN_DATA["Worlds.vdf"] = true
ALLOWED_VDF_IN_DATA["Worlds_Addon.vdf"] = true
ALLOWED_VDF_IN_DATA["Spine.vdf"] = true
ALLOWED_VDF_IN_DATA["SystemPack.vdf"] = true
ALLOWED_VDF_IN_DATA["Textures_Fonts_Apostroph.vdf"] = true
ALLOWED_VDF_IN_DATA["GMA.vdf"] = true

local ALLOWED_MOD_IN_DATA = {}
ALLOWED_MOD_IN_DATA["GMA.mod"] = true

local ALLOWED_VDF_IN_MODVDF = {}

local ALLOWED_MOD_IN_MODVDF = {}
ALLOWED_MOD_IN_MODVDF["GothicGame.mod"] = true

local mod_hash = nil
local data_path = "data\\";
local modvdf_path = "data\\modvdf"
local mod_file_ending = ".mod"
local vdf_file_ending = ".vdf"


function directory_scan.OnPlayerConnect(playerid)
 
    if IsNPC(playerid) == 0 then
       GetFileList(playerid, data_path, vdf_file_ending)
       GetFileList(playerid, data_path, mod_file_ending)
       GetFileList(playerid, modvdf_path, vdf_file_ending)
       GetFileList(playerid, modvdf_path, mod_file_ending)
       -- We would check the hash code of the .mod file here...If you know the hash and want to check it, uncomment this line.
       --GetMD5File(playerid,data_path.."\\GMA.mod");
    end

end

local function getNonEmptyStringTable(input)
    if table.getn(input) == 1 and input[1] == "" then
        return {}
    end
    return input
end

local function hasUnallowedFiles(playerid, fileList, allowedFiles)
    local files = getNonEmptyStringTable(fileList:split(";"))
    for k, v in pairs(files) do
        if allowedFiles[v] == nil then
            SendPlayerMessage(playerid,255, 255, 0, "'".. tostring(v) .. "' scheint zu den nicht erlaubten Files zu gehoeren.")
            return true
        end
    end
    return false
end

local function kickPlayerWithUnallowedFiles(playerid, pathFile, fileEnding, fileList, allowedFiles)
    if hasUnallowedFiles(playerid, fileList, allowedFiles) == true then
        SendPlayerMessage(playerid,255,255,0,"Du hast unerlaubte ".. tostring(fileEnding).. "'s in deinem ".. tostring(pathFile).." Ordner.")
        SendPlayerMessage(playerid,255, 255, 0, "Bitte entferne sie oder installiere eine saubere Version von Gothic 2.")
        Kick(playerid)
    end
end

function directory_scan.OnPlayerFileList(playerid, pathFile,fileEnding, fileCounter, fileList)
    if fileList ~= "INVALID_DIRECTORY" then
        if pathFile == data_path and fileEnding == vdf_file_ending then
            kickPlayerWithUnallowedFiles(playerid, pathFile, fileEnding, fileList, ALLOWED_VDF_IN_DATA)
        elseif pathFile == data_path and fileEnding == mod_file_ending then 
            kickPlayerWithUnallowedFiles(playerid, pathFile, fileEnding, fileList, ALLOWED_MOD_IN_DATA)
        elseif pathFile == modvdf_path and fileEnding == vdf_file_ending then 
            kickPlayerWithUnallowedFiles(playerid, pathFile, fileEnding, fileList, ALLOWED_VDF_IN_MODVDF)
        elseif pathFile == modvdf_path and fileEnding == mod_file_ending then 
            kickPlayerWithUnallowedFiles(playerid, pathFile, fileEnding, fileList, ALLOWED_MOD_IN_MODVDF)
        end

    end
end
 
function directory_scan.OnPlayerMD5File(playerid, pathFile, hash)
    if pathFile == data_path.."\\GMA.mod" then   
        if hash ~= mod_hash then 
            SendPlayerMessage(playerid,255,255,0,"Du hast eine inkorrekte Version der GMA.mod.")
            SendPlayerMessage(playerid,255,255,0,"Bitte update Gothic Multiplayer Adventures auf Spine.")
            Kick(playerid)
        end
    end
end

return directory_scan