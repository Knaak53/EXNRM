Config = {}

Config.UpdateFrequency = 800 -- seconds interval between removing values 

Config.Notifications = true -- notification when skill is added

Config.Skills = {
    ["Resistencia"] = {
        ["Current"] = 0, -- Default value 
        ["RemoveAmount"] = -0.7, -- % to remove when updating,
        ["Stat"] = "MP0_STAMINA" -- GTA stat hashname
    },

    ["Fuerza"] = {
        ["Current"] = 0,
        ["RemoveAmount"] = -0.4,
        ["Stat"] = "MP0_STRENGTH"
    },

    ["Capacidad Pulmonar"] = {
        ["Current"] = 0,
        ["RemoveAmount"] = -0.3,
        ["Stat"] = "MP0_LUNG_CAPACITY"
    },

    ["Tiro"] = {
        ["Current"] = 0,
        ["RemoveAmount"] = -0.1,
        ["Stat"] = "MP0_SHOOTING_ABILITY"
    },

    ["Conduccion"] = {
        ["Current"] = 0,
        ["RemoveAmount"] = -1,
        ["Stat"] = "MP0_DRIVING_ABILITY"
    },

    ["Manejo"] = {
        ["Current"] = 0,
        ["RemoveAmount"] = -0.5,
        ["Stat"] = "MP0_WHEELIE_ABILITY"
    },

    ["Guitarra"] = {
        ["Current"] = 0,
        ["RemoveAmount"] = -0.5,
        ["Stat"] = false
    },
    ["Puenteado (WIP)"] = {
        ["Current"] = 0,
        ["RemoveAmount"] = -0.5,
        ["Stat"] = false
    },
    ["Agilidad (WIP)"] = {
        ["Current"] = 0,
        ["RemoveAmount"] = -0.5,
        ["Stat"] = false
    },
    ["Baile (WIP)"] = {
        ["Current"] = 0,
        ["RemoveAmount"] = -0.5,
        ["Stat"] = false
    },
}
