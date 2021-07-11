
ESX = exports.extendedmode:getSharedObject()

RegisterNetEvent("Mx :: GetDiagnosis")
AddEventHandler("Mx :: GetDiagnosis", function(patient)
    local idJ = source
    local xPlayer = ESX.GetPlayerFromId(idJ)
    TriggerEvent("esx_service:isPlayerInService", function(inService) 
        if inService then
            TriggerClientEvent("Mx :: PassDiagnosis", patient, idJ)
        else
            xPlayer.showNotification('No estás en servicio')
        end
    end, "ambulance", xPlayer.source)
end)

RegisterNetEvent("Mx :: PassDiagnosis")
AddEventHandler("Mx :: PassDiagnosis", function(doctor, m_body, m_body_model, m_punch, m_shots, m_cuts, m_bruises, m_cause_death)
    TriggerClientEvent("Mx :: OpenBodyDamage", doctor, m_body, m_body_model, m_punch, m_shots, m_cuts, m_bruises, m_cause_death)
end)