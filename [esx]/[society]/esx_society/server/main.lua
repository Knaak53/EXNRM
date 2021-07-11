ESX = nil
local Jobs = nil
local RegisteredSocieties = {}

function tableIsEmpty(table)
	local an = true
	for k,v in pairs(table) do
		an = false
	end	
	if an then
		print("vacio")
	else
		print("no vacio")
	end
	return an
end

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
	--Wait(5000)
	--if ESX ~= nil and not tableIsEmpty(ESX.Jobs) then 
	--	Jobs = ESX.Jobs
	--	print(json.encode(ESX.Jobs))
	--	print("^2 Societies initialized correctly")
	--else
	--	while tableIsEmpty(ESX.Jobs) do
	--		Wait(5000)
	--		print(json.encode(ESX.Jobs))
	--		ESX = exports.extendedmode:getSharedObject()
	--		if not tableIsEmpty(ESX.Jobs)then
	--			Jobs = ESX.Jobs
	--			print(Jobs)
	--			print("^2 Societies initialized correctly^7")
	--		end
	--	end
	--end
end)
--Pasar los jobs automaticamente saltandose la función que hay mas abajo

--Comprobar que la base de datos correspondiente esta creada si no lo está la creamos
AddEventHandler("onResourceStart", function(resource)
	if GetCurrentResourceName() == resource then
		ESX.exposedDB.getDocument(GetHashKey("society_moneywash"),function(cb)
			if cb then 
				print("^2Society-MoneyWash database OK^7")
			else
				--print(tostring(GetHashKey("society_moneywash"))) 
				ESX.exposedDB.createDocumentWithId(tostring(GetHashKey("society_moneywash")),{societies = {}},function(cb)
					if cb then 
						print("^2Database Society-MoneyWash created succesfully^7")
					else
						print("^1Error creating database Society-MoneyWash^7")
					end
				end)
			end
		end)
	end
end)


--Funciones relacionadas con coger la society y registrar societys
function GetSociety(name)
	return RegisteredSocieties[name]
end

--Registrar society por indice de nombre para tener un acceso automatico a ella en vez de buscar iterando
AddEventHandler('esx_society:registerSociety', function(name, label, account, datastore, inventory, data)
	local society = {
		name      = name,
		label     = label,
		account   = account,
		datastore = datastore,
		inventory = inventory,
		data      = data,
		employees = nil
	}

	if RegisteredSocieties[name] ~= nil then 
		RegisteredSocieties[name] = society
	else
		RegisteredSocieties[name] = society
	end

	--TriggerEvent("s2v_taxes:registerTaxe", name, label, 21)
end)

--No necesita cambio realiza su función correctamente
AddEventHandler('esx_society:getSocieties', function(cb)
	cb(RegisteredSocieties)
end)
--No necesita cambio realiza su función correctamente
AddEventHandler('esx_society:getSociety', function(name, cb)
	cb(GetSociety(name))
end)

--No necesita cambio realiza su función correctamente
RegisterServerEvent('esx_society:withdrawMoney')
AddEventHandler('esx_society:withdrawMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.getJob().name == society.name then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			if amount > 0 and account.getMoney() >= amount then
				account.removeMoney(amount)
				xPlayer.addMoney(amount)

				xPlayer.showNotification(_U('have_withdrawn', ESX.Math.GroupDigits(amount)))
			else
				xPlayer.showNotification(_U('invalid_amount'))
			end
		end)
	else
		print(('esx_society: %s attempted to call withdrawMoney!'):format(xPlayer.identifier))
	end
end)
--No necesita cambio realiza su función correctamente
RegisterServerEvent('esx_society:depositMoney')
AddEventHandler('esx_society:depositMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = ESX.Math.Round(tonumber(amount))
	print(json.encode(society))

	if xPlayer.getJob().name == society.name then
		if amount > 0 and xPlayer.getMoney() >= amount then
			TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
				xPlayer.removeMoney(amount)
				--print(json.encode(account))
				--print(account.getMoney())
				account.addMoney(amount)
			end)

			xPlayer.showNotification(_U('have_deposited', ESX.Math.GroupDigits(amount)))
		else
			xPlayer.showNotification(_U('invalid_amount'))
		end
	else
		print(('esx_society: %s attempted to call depositMoney!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('pruebaLatent')
AddEventHandler('pruebaLatent',function(args)
	print(args)
end)

RegisterServerEvent('esx_society:washMoney')
AddEventHandler('esx_society:washMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local account = xPlayer.getAccount('black_money')
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.getJob().name == society then
		if amount and amount > 0 and account.money >= amount then
			xPlayer.removeAccountMoney('black_money', amount)
			ESX.exposedDB.getDocument(GetHashKey("society_moneywash"),function(cb)
				if cb then 
					local data = {
						identifier = xPlayer.identifier,
						society = society,
						amount = amount
					}
					if cb.societies[society] == nil then 
						cb.societies[society] = {}
					end
					table.insert(cb.societies[society],data)
					ESX.exposedDB.updateDocument(GetHashKey("society_moneywash"),cb,function(response)
						if response then 
							print("Update ok")
						else
							print("Update failed")
						end
					end)
				else
					print("Error whashing money")
				end
			end)
		else
			xPlayer.showNotification(_U('invalid_amount'))
		end
	else
		print(('esx_society: %s attempted to call washMoney!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_society:putVehicleInGarage')
AddEventHandler('esx_society:putVehicleInGarage', function(societyName, vehicle)
	local society = GetSociety(societyName)

	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}

		table.insert(garage, vehicle)
		store.set('garage', garage)
	end)
end)

RegisterServerEvent('esx_society:removeVehicleFromGarage')
AddEventHandler('esx_society:removeVehicleFromGarage', function(societyName, vehicle)
	local society = GetSociety(societyName)

	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}

		for i=1, #garage, 1 do
			if garage[i].plate == vehicle.plate then
				table.remove(garage, i)
				break
			end
		end

		store.set('garage', garage)
	end)
end)

ESX.RegisterServerCallback('esx_society:getSocietyMoney', function(source, cb, societyName)
	local society = GetSociety(societyName)

	if society then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			cb(account.getMoney())
		end)
	else
		cb(0)
	end
end)

function getSocietyAccount(societyName, cb)
	local society = GetSociety(societyName)
	TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
		cb(account)
	end)
end

--TODO hay que hacer el evento de cuando se cambia de trabajo si esta en una de las sociedades meterlo ahi si no esta sacarlod e la que estuviera
--Suponemos que tenemos el identity siempre activo entonces quito codigo basura que no nos sir
ESX.RegisterServerCallback('esx_society:getEmployees', function(source, cb, society)
	--if Config.EnableESXIdentity then
	Jobs = ESX.getJobs()
	if RegisteredSocieties[society].employees then
		cb(RegisteredSocieties[society].employees)
	else
		ESX.exposedDB.getDocumentsByRowWithFields("job",society,{
			"variables",
			"identifier",
			"job",
			"job_grade"
		},function(callback)
			local employees = {}
			if callback then
				--En vez de hacer table insert insertamos por identifier para poder hacer una recogida directa y hacer las cosas mas rapidas en el restod e sitios
				for k,v in pairs(callback) do
					if employees[v.identifier] == nil then 
						employees[v.identifier] = {}
					end
					--print(json.encode(callback))
					--print(json.encode(Jobs[v.job].grades))
					--print(json.encode(v) .. " ??")
					--print(json.encode(Jobs[v.job]))
					--print("index del grado: "..tonumber(v.job_grade) + 1)
					employees[v.identifier] = {
						name       = v.variables.identity.real.firstname .. ' ' .. v.variables.identity.real.secondname,
						identifier = v.identifier,
						job = {
							name        = v.job,
							label       = Jobs[v.job].label,
							grade       = v.job_grade,
							grade_name  = Jobs[v.job].grades[""..v.job_grade].name,
							grade_label = Jobs[v.job].grades[""..v.job_grade].label
						}
					}
				end
			end
			RegisteredSocieties[society].employees = employees
			cb(RegisteredSocieties[society].employees)
		end)
	end
end)

AddEventHandler('esx:setJob',function(source,job,lastjob)
	--Comprobamos si es de alguna society para ahorrarnos la busqueda
	local xPlayer = ESX.GetPlayerFromId(source)
	if RegisteredSocieties[lastjob] then --Entonces es que esta dentro de la society
		--Comprobamos si el nuevo trabajo es en una society que tenemos en cache
		if RegisteredSocieties[job] then --Si si pasamos la info de la anterior a la nueva
			if RegisteredSocieties[job].employees[xPlayer.identifier] == nil then 
				RegisteredSocieties[job].employees[xPlayer.identifier] = {}
			end
			RegisteredSocieties[job].employees[xPlayer.identifier] = RegisteredSocieties[lastjob].employees[xPlayer.identifier]
			RegisteredSocieties[lastjob].employees[xPlayer.identifier] = nil --Ponemos a nulo su sitio
		end --Si no estaba pues solo lo borramos
		RegisteredSocieties[lastjob].employees[xPlayer.identifier] = nil
	end
end)
local count = 0
--Hay que mirarlo para mejorar rendimiento pero de momento nos sirve y funciona
ESX.RegisterServerCallback('esx_society:getJob', function(source, cb, society)
	Jobs = ESX.getJobs()
	count = count + 1
	local job    = Jobs[society]
	--print(json.encode(job))
	---print(ESX.Jobs[society].job_grades["boss"].salary)
	local grades = {}
	--print(society)
	print(count)
	print(json.encode(Jobs[society]))
	for k,v in pairs(job.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	job.grades = grades

	cb(job)
end)

ESX.RegisterServerCallback('esx_society:setJob', function(source, cb, identifier, job, grade, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = xPlayer.getJob().grade_name == 'boss'

	if isBoss then
		local xTarget = ESX.GetPlayerFromIdentifier(identifier)

		if xTarget then
			xTarget.setJob(job, grade)

			if type == 'hire' then
				xTarget.showNotification(_U('you_have_been_hired', job))
			elseif type == 'promote' then
				xTarget.showNotification(_U('you_have_been_promoted'))
			elseif type == 'fire' then
				xTarget.showNotification(_U('you_have_been_fired', xTarget.getJob().label))
			end

			cb()
		else
			ESX.exposedDB.SavePlayerExtraDataUsingRows(xPlayer.source,{
				job = job,
				job_grade = grade
			},function(done)print(done)end)
		end
	else
		print(('esx_society: %s attempted to setJob'):format(xPlayer.identifier))
		cb()
	end
end)

RegisterCommand("Jobsalary",function()
	print(Jobs["desempleado"].grades["0"].salary)
	Jobs["desempleado"].grades["0"].salary = 20
	print(Jobs["desempleado"].grades["0"].salary)
	Jobs["desempleado"].grades["0"].salary = 50
end,false)


--TODO CAMBIAR
--Parece feo y aparatoso pero da eficiencia haciendo while y parando cuando encuentra mas que recorrer todos los elementos este encontrado o no
ESX.RegisterServerCallback('esx_society:setJobSalary', function(source, cb, job, grade, salary)
	local xPlayer = ESX.GetPlayerFromId(source)
	Jobs = ESX.getJobs()
	--print(json.encode(ESX.getJobs()["police"]))
	--print(json.encode(Jobs["police"]))
	GetHashKey("jobs")
	local _job = job
	local _grade = tostring(grade)
	local checker = false
	--print("GRADOOO"..grade)
	if xPlayer.getJob().name == job and xPlayer.getJob().grade_name == 'boss' then
		if salary <= Config.MaxSalary then
			--print( "JOBS ANTES ningun document: "..json.encode(Jobs["police"].grades))
			ESX.exposedDB.getDocument(GetHashKey("jobs"),function(result)
				--print( "JOBS DESPUES GET document: "..json.encode(Jobs["police"].grades))
				if result then
					local i = 1
					local found = false
					local j = 1
					
					--while result.jobs[i] and not found do
					--	if result.jobs[i].name == job then 
					--		while result.jobs[i].job_grades[j] and not found do
					--			if result.jobs[i].job_grades[j].grade == grade then 
					--				result.jobs[i].job_grades[j].salary = salary
					--				found = true
					--			end
					--			j = j+1
					--		end
					--		found = true
					--	end
					--	i = i+1
					--end
					print( "JOBS ANTES ASIGNAR NADA: "..json.encode(Jobs["police"].grades))
					result.jobs[_job].job_grades[_grade].salary = salary
					ESX.exposedDB.updateDocument(GetHashKey("jobs"),result,function(ok)
						if ok then 
							checker = true
							--print("grade= "..grade)
							--print("job= "..job)
							--print(Jobs[job].grades[tostring(grade)])
						end
					end)
				else
					print("Error updating job salary")
				end
			end)
			Citizen.CreateThread(function() 
				while not checker do
					Wait(400)
				end
			
				if checker then
					print( "JOBS ANTES: "..json.encode(Jobs["police"].grades))
					Jobs[_job].job_grades[_grade].salary = salary
					--print( "JOBS ANTES: "..json.encode(Jobs["police"].grades))
					ESX.setJobs(Jobs)
					--print("JOBS DESPUES: "..json.encode(ESX.getJobs()["police"].grades))
					--ESX.Jobs[_job].job_grades[_grade].salary = salary
					local xPlayers = ESX.GetPlayers()

					for i=1, #xPlayers, 1 do
						local xTarget = ESX.GetPlayerFromId(xPlayers[i])

						if xTarget.getJob().name == _job and xTarget.getJob().grade == _grade then
							xTarget.setJob(_job, _grade)
						end
					end
				end
				cb()
			end)
		else
			--print(('esx_society: %s attempted to setJobSalary over config limit!'):format(xPlayer.identifier))
			cb()
		end
		
	else
		--print(('esx_society: %s attempted to setJobSalary'):format(xPlayer.identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_society:getOnlinePlayers', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players  = {}
	local identity 

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		local identity = xPlayer.get("identity")
		if identity then
			table.insert(players, {
				source     = xPlayer.source,
				identifier = xPlayer.getIdentifier(),
				name       = identity.real.name .." ".. identity.real.firstname,
				job        = xPlayer.getJob()
			})
		else
			print("Player "..xPlayer.getIdentifier().. " Identity error")
		end
	end

	cb(players)
end)

ESX.RegisterServerCallback('esx_society:getVehiclesInGarage', function(source, cb, societyName)
	local society = GetSociety(societyName)
	
	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}
		cb(garage)
	end)
end)

ESX.RegisterServerCallback('esx_society:isBoss', function(source, cb, job)
	cb(isPlayerBoss(source, job))
end)

function isPlayerBoss(playerId, job)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer.getJob().name == job and xPlayer.getJob().grade_name == 'boss' then
		return true
	else
		print(('esx_society: %s attempted open a society boss menu!'):format(xPlayer.identifier))
		return false
	end
end

function WashMoneyCRON(d, h, m)
	ESX.exposedDB.getDocument(GetHashKey("society_moneywash"),function(cb)
		if cb then
			for k,v in pairs(cb.societies) do
				local society = GetSociety(k)
				local xPlayer = ESX.GetPlayerFromIdentifier(v.identifier)
				TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
					account.addMoney(v.amount)
				end)
				if xPlayer then
					xPlayer.showNotification(_U('you_have_laundered', ESX.Math.GroupDigits(v.amount)))
				end
			end
			cb.societies = {}
			ESX.exposedDB.updateDocument(GetHashKey("society_moneywash"),cb,function(response)
				if response then 
					print("Update ok")
				else
					print("Update failed")
				end
			end)
		else
			print("Error whashing money")
		end
	end)
end

TriggerEvent('cron:runAt', 3, 0, WashMoneyCRON)
