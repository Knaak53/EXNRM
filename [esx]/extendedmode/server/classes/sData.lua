function CreateExtendedData(vars)
	local self = {}
	local functions = {}

    self.variables = vars
    self.savingstate = false


	functions.getServerVariables = function()
		return self.variables
	end


	functions.setServerVariables = function(vars)
		self.variables = vars
	end

	functions.set = function(k, v)
		self.variables[k] = v
	end

	functions.get = function(k)
		return self.variables[k]
    end

    functions.save = function()
        if not self.savingstate then
            self.savingstate = true
            Citizen.CreateThread(function()
                Wait(20000)
                ESX.exposedDB.updateOrCreateDocument(GetHashKey("serverData"), {sData = self.variables}, function(result) 
                    if result then
                        print("^2Server data saved sucessfully^7")
                        self.savingstate = false
                    else
                        print("^1ERROR saving server data^7")
                        self.savingstate = false
                    end
                end)
            end)
        end
    end

    RegisterCommand("forceSaveServerData", function() 
        self.savingstate = true
        for k,v in pairs(ESX.Vehicles) do
            v.forceFullVehicleSave()
        end
        ESX.exposedDB.updateOrCreateDocument(GetHashKey("serverData"), {sData = self.variables}, function(result) 
            if result then
                print("^2Server data saved sucessfully^7")
                self.savingstate = false
            else
                print("^1ERROR saving server data^7")
                self.savingstate = false
            end
        end)
    end, true)
    
	return functions
end