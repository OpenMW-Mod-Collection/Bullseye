local core = require("openmw.core")

require("scripts.Bullseye.utils.utils")

local voicelines = {
    ["dark elf"] = {
        male = {
            { file = "Srv_DM030" },
            { file = "bAtk_DM004" },
            { file = "Atk_DM004" },
            { file = "Hlo_DM065" },
        },
        female = {
            { file = "Hlo_DF029" },
            { file = "Hlo_DF021" },
            { file = "Hlo_DF027" },
            { file = "Hlo_DF065" },
            { file = "Atk_DF004" },
        },
    },
    ["high elf"] = {
        male = {
            { file = "Srv_HM009" },
            { file = "Srv_HM006" },
            { file = "Hlo_HM012" },
            { file = "Hlo_HM009" },
        },
        female = {
            { file = "Hlo_HF059" },
            { file = "Hlo_HF028" },
            { file = "Hlo_HF009" },
        },
    },
    ["wood elf"] = {
        male = {
            { file = "Hlo_WM138" },
            { file = "Hlo_WM024" },
            { file = "Hlo_WM026" },
            { file = "Atk_WM008" },
            { file = "Atk_WM006" },
        },
        female = {
            { file = "Hlo_WF021" },
            { file = "Hlo_WF001" },
            { file = "Hlo_WF000d" },
            { file = "Thf_WF002" },
            { file = "Atk_WF008" },
        },
    },
    breton = {
        male = {
            { file = "Hlo_BM027" },
            { file = "Hlo_BM023" },
            { file = "Thf_BM004" },
            { file = "Thf_BM001" },
            { file = "Atk_BM015" },
        },
        female = {
            { file = "Hlo_BF027" },
            { file = "Hlo_BF000e" },
            { file = "Thf_BF001" },
            { file = "Atk_BF015" },
        },
    },
    imperial = {
        male = {
            { file = "Hlo_IM015" },
            { file = "Hlo_IM000d" },
            { file = "bAtk_IM007" },
        },
        female = {
            { file = "" },
        },
    },
}

-- populate the voiceline list
for _, record in pairs(core.dialogue.voice.records) do
    for _, info in ipairs(record.infos) do
        local race = info.filterActorRace
        local gender = info.filterActorGender
        local filteredVoicelines = voicelines[race][gender]

        if filteredVoicelines then
            local pathToSound = info.sound
            local fileName = ExtractFileName(pathToSound)
            local text = info.text

            for _, voiceline in ipairs(filteredVoicelines) do
                if voiceline.file == fileName then
                    voiceline.file = pathToSound
                    voiceline.text = text
                    break
                end
            end
        end
    end
end
