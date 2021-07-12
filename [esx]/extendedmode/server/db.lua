--       Licensed under: AGPLv3        --
--  GNU AFFERO GENERAL PUBLIC LICENSE  --
--     Version 3, 19 November 2007     --

local bs = { [0] =
	'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
	'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
	'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
	'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/',
}

local function base64(s)
	local byte, rep = string.byte, string.rep
	local pad = 2 - ((#s-1) % 3)
	s = (s..rep('\0', pad)):gsub("...", function(cs)
		local a, b, c = byte(cs, 1, 3)
		return bs[a>>2] .. bs[(a&3)<<4|b>>4] .. bs[(b&15)<<2|c>>6] .. bs[c&63]
	end)

	return s:sub(1, #s-pad) .. rep('=', pad)
end

auth = base64(auth)

db = {}
exposedDB = {}
_Prefix = "CityName"
_PrefixError = "ERROR"

function db.firstRunCheck()
	if settings.defaultSettings.enableCustomData ~= '1' and settings.defaultSettings.defaultDatabase ~= '1' then
		PerformHttpRequest("http://" .. ip .. ":" .. port .. "/essentialmode/_compact", function(err, rText, headers)
		end, "POST", "", {["Content-Type"] = "application/json", Authorization = "Basic " .. auth})

		PerformHttpRequest("http://" .. ip .. ":" .. port .. "/essentialmode", function(err, rText, headers)
			if err == 0 then
				print(_Prefix .. "-------------------------------------------------------------")
				print(_Prefix .. "--- No errors detected, CouchDB is setup properly. ---")
				print(_Prefix .. "-------------------------------------------------------------")
			elseif err == 412 then
				print(_Prefix .. "-------------------------------------------------------------")
				print(_Prefix .. "--- No errors detected, CouchDB is setup properly. ---")
				print(_Prefix .. "-------------------------------------------------------------")
			elseif err == 401 then
				print(_PrefixError .. "------------------------------------------------------------------------------------------------")
				print(_PrefixError .. "--- Error detected in authentication, please take a look at your convars for essentialmode. ---")
				print(_PrefixError .. "------------------------------------------------------------------------------------------------")
				log('== Authentication error with CouchDB ==')
			elseif err == 201 then
				print(_Prefix .. "-------------------------------------------------------------")
				print(_Prefix .. "--- No errors detected, CouchDB is setup properly. ---")
				print(_Prefix .. "-------------------------------------------------------------")
				log('== DB Created ==')			
			else
				print(_PrefixError .. "------------------------------------------------------------------------------------------------")
				print(_PrefixError .. "--- Unknown error detected ( " .. err .. " ): " .. rText)
				print(_PrefixError .. "------------------------------------------------------------------------------------------------")
				log('== Unknown error, (' .. err .. '): ' .. rText .. ' ==')
			end
		end, "PUT", "", {Authorization = "Basic " .. auth})
	elseif settings.defaultSettings.defaultDatabase == '1' and settings.defaultSettings.enableCustomData ~= '1' then
		TriggerEvent("es_sqlite:initialize")
	else
		TriggerEvent('es_db:firstRunCheck', ip, port)
	end
end

local url = "http://" .. ip .. ":" .. port .. "/"

local function requestDB(request, location, data, headers, callback)
	if request == nil or type(request) ~= "string" then request = "GET" end
	if headers == nil or type(headers) ~= "table" then headers = {} end
	if data == nil or type(data) ~= "table" then data = "" end
	if location == nil or type(location) ~= "string" then location = "" end

	-- So I don't have to repeat this every single request
	if auth then
		headers.Authorization = 'Basic ' .. auth
	end

	if type(data) == "table" then
		data = json.encode(data)
	end

	PerformHttpRequest(url .. location, function(err, rText, headers)
		if callback then
			callback(err, rText, headers)
		end
	end, request, data, headers)
end

local function getUUID(amount, cb)
	if amount == nil or amount <= 0 then amount = 1 end

	requestDB('GET', '_uuids?count=' .. amount, nil, nil, function(err, rText, headers)
		if err ~= 200 then
			log('== Could not retrieve UUID from CouchDB, error('.. err .. '): '.. rText .. ' ==')
			print(_PrefixError .. ' Error occurred while performing database request: could not retrieve UUID, error code: ' .. err .. ", server returned: " .. rText)
		else
			if cb then
				if amount > 1 then
					cb(json.decode(rText).uuids)
				else
					cb(json.decode(rText).uuids[1])
				end
			end
		end
	end)
end

local function getDocument(uuid, callback)
	requestDB('GET', 'essentialmode/' .. uuid, nil, nil, function(err, rText, headers)
		local doc =  json.decode(rText)

		if err ~= 200 then
			log('== Could not retrieve document from CouchDB, error('.. err .. '): '.. rText .. ' ==')
			print(_PrefixError .. 'Error occurred while performing database request: could not retrieve document, error code: ' .. err .. ", server returned: " .. rText)
		else
			if callback then
				if doc then callback(doc) else callback(false) end
			end
		end
	end)	
end

db.getDocument = function (uuid, callback)
	requestDB('GET', 'essentialmode/' .. uuid, nil, nil, function(err, rText, headers)
		if rText then
			local doc =  json.decode(rText)

			if err ~= 200 then
				log('== Could not retrieve document from CouchDB, error('.. err .. '): '.. rText .. ' ==')
				print(_PrefixError .. 'Error occurred while performing database request: could not retrieve document, error code: ' .. err .. ", server returned: " .. rText)
			else
				if callback then
					if doc then callback(doc) else callback(false) end
				end
			end
		else
			callback(false)
		end
	end)	
end

local function createDocument(doc, cb)
	if doc == nil or type(doc) ~= "table" then doc = {} end

	getUUID(1, function(uuid)
		requestDB('PUT', 'essentialmode/' .. uuid, doc, {["Content-Type"] = 'application/json'}, function(err, rText, headers)
			if err ~= 201 then
				print(_PrefixError .. 'Error occurred while performing database request: could not create document, error code: ' .. err .. ", server returned: " .. rText)
			else
				if cb then
					cb(rText, doc)
				end
			end
		end)
	end)
end

local function createDocumentWithId(id,doc, cb)
if doc == nil or type(doc) ~= "table" then doc = {} end
	requestDB('PUT', 'essentialmode/' .. id, doc, {["Content-Type"] = 'application/json'}, function(err, rText, headers)
		if err ~= 201 then
			print(_PrefixError .. 'Error occurred while performing database request: could not create document, error code: ' .. err .. ", server returned: " .. rText)
		else
			if cb then
				cb(rText, doc)
			end
		end
	end)
end

local function updateDocument(docID, updates, callback)
	if docID == nil then docID = "" end
	if updates == nil or type(updates) ~= "table" then updates = {} end

	getDocument(docID, function(doc)
		if doc then
			for i in pairs(updates)do
				if updates[i] then
					doc[i] = updates[i]
				end
			end

			if updates.license then
				doc.license = updates.license
			end

			requestDB('PUT', 'essentialmode/' .. docID, doc, {["Content-Type"] = 'application/json'}, function(err, rText, headers)
				if rText == nil then
					print(_PrefixError .. 'Error occurred while performing database request: could not update document error ' .. err )
				else
					if not json.decode(rText).ok then
						if err ~= 409 then
							print(_PrefixError .. 'Error occurred while performing database request: could not update document error ' .. err .. ", returned: " .. rText)
						end
					else
						if callback then
							callback(rText)
						end
					end
				end
			end)
		else
			print(_PrefixError .. "Error occurred while performing database request: could not find document (" .. docID .. ")")
		end
	end)
end

function db.updateUser(identifier, new, callback)
	if settings.defaultSettings.enableCustomData ~= '1' and settings.defaultSettings.defaultDatabase ~= '1' then
		if Config.EnableDebug then
			print("sending to save")
			print("getting")
		end
		db.retrieveUser(identifier, function(user)
			if Config.EnableDebug then
				print("getted and updating...")
			end
			updateDocument(user._id, new, function(returned)
				if Config.EnableDebug then
					print("updated")
				end
				if callback then callback(returned) end
			end)
		end)
	elseif settings.defaultSettings.defaultDatabase == '1' and settings.defaultSettings.enableCustomData ~= '1' then
		TriggerEvent('es_sqlite:updateUser', identifier, new, callback)
	else
		TriggerEvent('es_db:updateUser', identifier, new, callback)
	end
end

db.requestDB = requestDB


defaultPositions = 
{
	{x = -269.4,y = -955.3,z =31.2,heading = 205.8},

	{x = 429.75003051758, y = -811.26440429688, z = 29.491081237793, heading = 358.00741577148},
	{x = -848.78466796875, y = -1012.4783935547, z = 13.27712059021, heading = 271.24951171875},
	{x = -158.6570892334, y = -296.41983032227, z = 39.733322143555, heading = 164.0524597168},
	{x = -532.13549804688, y = -210.70199584961, z = 37.649169921875, heading = 115.1990814209},
}
function db.createUser(id,identifier, license, callback)
	if settings.defaultSettings.enableCustomData ~= '1' and settings.defaultSettings.defaultDatabase ~= '1' then
		if type(identifier) == "string" and identifier ~= nil then

			local accounts = {}

			for account,money in pairs(Config.StartingAccountMoney) do
				accounts[account] = money
			end
			indexPos = math.random(1, #defaultPositions)
			createDocumentWithId(id,{identifier = identifier, license = license, accounts = accounts, group = "user",inventory = {}, job = 'desempleado', job_grade = 0, loadout = {}, position = defaultPositions[indexPos]}, function(returned, document)
				if callback then
					callback(returned, document)
				end
			end)
		else
			print(_PrefixError .. "Error occurred while creating user, missing parameter or incorrect parameter: identifier")
		end
	elseif settings.defaultSettings.defaultDatabase == '1' and settings.defaultSettings.enableCustomData ~= '1' then
		TriggerEvent("es_sqlite:createUser", identifier, license, tonumber(settings.defaultSettings.startingCash), tonumber(settings.defaultSettings.startingBank), "user", 0, "", callback)
	else
		TriggerEvent('es_db:createUser', identifier, license, tonumber(settings.defaultSettings.startingCash), tonumber(settings.defaultSettings.startingBank), callback)
	end
end

function db.doesUserExist(identifier, callback)
	if settings.defaultSettings.enableCustomData ~= '1' and settings.defaultSettings.defaultDatabase ~= '1' then
		if identifier ~= nil and type(identifier) == "string" then
			requestDB('POST', 'essentialmode/_find', {selector = {["identifier"] = identifier}}, {["Content-Type"] = 'application/json'}, function(err, rText, headers)
				if rText then
					if callback then
						if json.decode(rText).docs[1] then callback(true) else callback(false) end
					end
				else
					print(_PrefixError .. 'Error occurred while attempting to find user in CouchDB.')
				end
			end)
		else
			print(_PrefixError .. "Error occurred while checking existance user, missing parameter or incorrect parameter: identifier")
		end
	elseif settings.defaultSettings.defaultDatabase == '1' and settings.defaultSettings.enableCustomData ~= '1' then
		TriggerEvent("es_sqlite:doesUserExist", identifier, callback)
	else
		TriggerEvent('es_db:doesUserExist', identifier, callback)
	end
end

function db.retrieveUser(identifier, callback)
	if settings.defaultSettings.enableCustomData ~= '1' and settings.defaultSettings.defaultDatabase ~= '1' then
		if identifier ~= nil and type(identifier) == "string" then
			requestDB('POST', 'essentialmode/_find', {selector = {["identifier"] = identifier}}, {["Content-Type"] = 'application/json'}, function(err, rText, headers)
				local doc =  json.decode(rText).docs[1]
				--print("User data: "..rText)
				if callback then
					if doc then callback(doc) else callback(false) end
				end
			end)
		else
			print(_PrefixError .. "Error occurred while retrieving user, missing parameter or incorrect parameter: identifier")
		end
	elseif settings.defaultSettings.defaultDatabase == '1' and settings.defaultSettings.enableCustomData ~= '1' then
		TriggerEvent("es_sqlite:retrieveUser", identifier, callback)
	else
		TriggerEvent('es_db:retrieveUser', identifier, callback)
	end
end

function db.retrieveUserData(identifier, data, callback)
	print("executing function db")
	if settings.defaultSettings.enableCustomData ~= '1' and settings.defaultSettings.defaultDatabase ~= '1' then
		if identifier ~= nil and type(identifier) == "string" then
			print("sending db query")
			requestDB('POST', 'essentialmode/_find', {selector = {["identifier"] = identifier}, fields = {data}}, {["Content-Type"] = 'application/json'}, function(err, rText, headers)
				if rText then
					local doc =  json.decode(rText).docs[1]
					print("User data: "..rText)
					if callback then
						if doc then callback(doc) else callback(false) end
					end
				else
					callback(false)
				end
			end)
		else
			print(_PrefixError .. "Error occurred while retrieving user, missing parameter or incorrect parameter: identifier")
		end
	elseif settings.defaultSettings.defaultDatabase == '1' and settings.defaultSettings.enableCustomData ~= '1' then
		TriggerEvent("es_sqlite:retrieveUser", identifier, callback)
	else
		TriggerEvent('es_db:retrieveUser', identifier, callback)
	end
end

function db.performCheckRunning()
	requestDB('GET', nil, nil, nil, function(err, rText, header)
		print(rText)
	end)
end

db.firstRunCheck()

function exposedDB.createDatabase(db, cb)
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. db, function(err, rText, headers)
		if err == 0 then
			cb(true, 0)
		else
			cb(false, rText)
		end
	end, "PUT", "", {Authorization = "Basic " .. auth})
end

function exposedDB.getDocument(uuid, callback)
	requestDB('GET', 'essentialmode/' .. uuid, nil, nil, function(err, rText, headers)
		if rText then
			local doc =  json.decode(rText)

			if err ~= 200 then
				log('== Could not retrieve document from CouchDB, error('.. err .. '): '.. rText .. ' ==')
				print(_PrefixError .. 'Error occurred while performing database request: could not retrieve document, error code: ' .. err .. ", server returned: " .. rText)
			else
				if callback then
					if doc then callback(doc) else callback(false) end
				end
			end
		else
			callback(false)
		end
	end)	
end

function exposedDB.deleteDocument(documentID, callback)
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/" .. documentID, function(err, rText, headers)
		print("Get:"..err)
		if rText then
			local doc = json.decode(rText)

			if(doc)then

				PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/" .. doc._id.."?rev="..doc._rev, function(err, rText, headers)
					print("error update with rev:"..err)
					if tonumber(err) == 409 then
						exposedDB.deleteDocument(documentID, callback)
					else
						callback((err or true))
					end
					
				end, "DELETE", "", {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})
			end
		end
	end, "GET", "", {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})	
	--exposedDB.getDocument(uuid, function(result) 
	--	if result then
	--		requestDB('DELETE', 'essentialmode/' .. uuid, {rev = result._rev}, nil, function(err, rText, headers)
	--			print("error en delete "..err)
	--			if rText then
	--				local doc =  json.decode(rText)
	--				
	--				if err ~= 200 then
	--					log('== Could not retrieve document from CouchDB, error('.. err .. '): '.. rText .. ' ==')
	--					print(_PrefixError .. 'Error occurred while performing database request: could not retrieve document, error code: ' .. err .. ", server returned: " .. rText)
	--				else
	--					if callback then
	--						if doc then callback(doc) else callback(false) end
	--					end
	--				end
	--			else
	--				callback(false)
	--			end
	--		end)	
	--	end
	--end)
end

function exposedDB.getDocumentSync(uuid)
	local result = nil
	local p = promise.new()
	requestDB('GET', 'essentialmode/' .. uuid, nil, nil, function(err, rText, headers)
		if rText then
			local doc =  json.decode(rText)

			if err ~= 200 then
				log('== Could not retrieve document from CouchDB, error('.. err .. '): '.. rText .. ' ==')
				print(_PrefixError .. 'Error occurred while performing database request: could not retrieve document, error code: ' .. err .. ", server returned: " .. rText)
				p:resolve(false)
			else
				if doc then p:resolve(doc) else p:resolve(false) end
			end
		else
			p:resolve(false)
		end
	end)
	local result = Citizen.Await(p)
    return result
end

function exposedDB.getDocumentData(uuid, callback)
	requestDB('GET', 'essentialmode/' .. uuid, nil, nil, function(err, rText, headers)
		if rText then
			local doc =  json.decode(rText)

			if err ~= 200 then
				log('== Could not retrieve document from CouchDB, error('.. err .. '): '.. rText .. ' ==')
				print(_PrefixError .. 'Error occurred while performing database request: could not retrieve document, error code: ' .. err .. ", server returned: " .. rText)
			else
				if callback then
					if doc then 
						local finaldoc = {}
						for k,v in pairs(doc) do
							if k ~= "_id" and k ~= "_rev" then
								finaldoc[k] = v
							end
						end
						callback(finaldoc) 
					else 
						callback(false) 
					end
				end
			end
		else
			callback(false)
		end
	end)	
end

function exposedDB.getDocumentDataSync(uuid)
	local result = nil
	local p = promise.new()
	requestDB('GET', 'essentialmode/' .. uuid, nil, nil, function(err, rText, headers)
		if rText then
			local doc =  json.decode(rText)

			if err ~= 200 then
				log('== Could not retrieve document from CouchDB, error('.. err .. '): '.. rText .. ' ==')
				print(_PrefixError .. 'Error occurred while performing database request: could not retrieve document, error code: ' .. err .. ", server returned: " .. rText)
				p:resolve(false)
			else
				if doc then 
					local finaldoc = {}
					for k,v in pairs(doc) do
						if k ~= "_id" and k ~= "_rev" then
							finaldoc[k] = v
						end
					end
					p:resolve(finaldoc)
				else 
					p:resolve(false)
				end
			end
		else
			p:resolve(false)
		end
	end)
	local result = Citizen.Await(p)
    return result
end

function exposedDB.createDocument(rows, cb)
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/_uuids", function(err, rText, headers)
		PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/" .. json.decode(rText).uuids[1], function(err, rText, headers)
			if err == 0 then
				cb(true, 0)
			else
				cb(false, rText)
			end
		end, "PUT", json.encode(rows), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})
	end, "GET", "", {Authorization = "Basic " .. auth})
end

function exposedDB.createDocumentSync(rows)
	local result = nil
	local text = nil
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/_uuids", function(err, rText, headers)
		PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/" .. json.decode(rText).uuids[1], function(err, rText, headers)
			if err == 0 then
				text = 0
				result = true
			else
				text = rText
				result = false
			end
		end, "PUT", json.encode(rows), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})
	end, "GET", "", {Authorization = "Basic " .. auth})
	while result == nil do
		Citizen.Wait(0)
	end
	return result,text
end

function exposedDB.createDocumentWithId(id ,rows, cb)
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/" .. id, function(err, rText, headers)
		if err == 0 or err == 200 or err == 201 or err == 202 then
			cb(true, 0)
		else
			cb(false, err)
			--print(json.encode(rows))
		end
	end, "PUT", json.encode(rows), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})
end

function exposedDB.createDocumentWithIdSync(id,rows)
	local result = nil
	local text = nil
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/" .. id, function(err, rText, headers)
		if err == 0 or err == 200 or err == 201 or err == 202 then
			text = 0
			result = true
		else
			text = err
			result = false
			--print(json.encode(rows))
		end
	end, "PUT", json.encode(rows), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})
	while result == nil do
		Citizen.Wait(0)
	end
	return result,text
end

function exposedDB.getDocumentByRow(row, value, callback)
	local qu = {selector = {[row] = value}}
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/_find", function(err, rText, headers)
		local t = json.decode(rText)

		if(t)then
			if t.docs then
				if(t.docs[1])then
					callback(t.docs[1])
				else
					callback(false)
				end
			else
				callback(false)
			end
		else
			callback(false, rText)
		end
	end, "POST", json.encode(qu), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})		
end

function exposedDB.getDocumentByRowSync(row, value)
	local result = nil
	local text = nil
	local qu = {selector = {[row] = value}}
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/_find", function(err, rText, headers)
		local t = json.decode(rText)

		if(t)then
			if t.docs then
				if(t.docs[1])then
					result = t.docs[1]
				else
					result = false
				end
			else
				result = false
			end
		else
			text = rText
			result = false
		end
	end, "POST", json.encode(qu), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})
	while result == nil do
		Citizen.Wait(0)
	end
	return result,text
end

function exposedDB.getDocumentsByRowValuesWithFields(row, values,fields, callback)
	local qu = {selector = {[row] = {["$or"] = values}}, fields = fields}
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/_find", function(err, rText, headers)
		local t = json.decode(rText)

		if(t)then
			if t.docs then
				if(t.docs[1])then
					callback(t.docs)
				else
					callback(false)
				end
			else
				callback(false)
			end
		else
			callback(false, rText)
		end
	end, "POST", json.encode(qu), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})		
end

function exposedDB.getDocumentsByRowValuesWithFieldsSync(row, values,fields)
	local result = nil
	local text = nil
	local qu = {selector = {[row] = {["$or"] = values}}, fields = fields}
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/_find", function(err, rText, headers)
		local t = json.decode(rText)
		if(t)then
			if t.docs then
				if(t.docs[1])then
					result = t.docs[1]
				else
					result = false
				end
			else
				result = false
			end
		else
			text = rText
			result = false
		end
	end, "POST", json.encode(qu), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})
	while result == nil do
		Citizen.Wait(0)
	end
	return result,text
end

function exposedDB.getDocumentsByRowWithFields(row, value,fields, callback)
	local qu = {selector = {[row] = value}, fields = fields}
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/_find", function(err, rText, headers)
		local t = false
		t = json.decode(rText)
		if rText ~= nil then
		end
		if(t)then
			if t.docs then
				if(t.docs[1])then
					callback(t.docs)
				else
					callback(false)
				end
			else
				callback(false)
			end
		else
			callback(false, rText)
		end
	end, "POST", json.encode(qu), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})		
end

function exposedDB.getDocumentsByRowRegexWithFields(row, value,fields, callback)
	local qu = {selector = {[row] = { ["$regex"] = value}}, fields = fields}
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/_find", function(err, rText, headers)
		local t = false
		t = json.decode(rText)
		if rText ~= nil then
		end
		if(t)then
			if t.docs then
				if(t.docs[1])then
					callback(t.docs)
				else
					callback(false)
				end
			else
				callback(false)
			end
		else
			callback(false, rText)
		end
	end, "POST", json.encode(qu), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})		
end

function exposedDB.getDocumentsByRowRegexWithFieldsSync(row, value,fields)
	local qu = {selector = {[row] = { ["$regex"] = value}}, fields = fields}
	local result = nil
	local text = nil
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/_find", function(err, rText, headers)
		local t = false
		t = json.decode(rText)
		if rText ~= nil then
		end
		if(t)then
			if t.docs then
				if(t.docs[1])then
					result = t.docs
				else
					result = false
				end
			else
				result = false
			end
		else
			result = false
			text = rText
		end
	end, "POST", json.encode(qu), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})
	while result == nil do
		print(result)
		Citizen.Wait(0)
	end
	return result,text
end


function exposedDB.getDocumentsByRowWithFieldsSync(row, value,fields)
	local result = nil
	local text = nil
	local qu = {selector = {[row] = value}, fields = fields}
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/_find", function(err, rText, headers)
		local t = false
		t = json.decode(rText)
		if rText ~= nil then
		end
		if(t)then
			if t.docs then
				if(t.docs[1])then
					result = t.docs
				else
					result = false
				end
			else
				result = false
			end
		else
			text = rText
			result = false
		end
	end, "POST", json.encode(qu), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})
	while result == nil do
		Citizen.Wait(0)
	end
	return result,text
end

function exposedDB.updateDocument(documentID, updates, callback)
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/" .. documentID, function(err, rText, headers)
		print(err)
		local doc = json.decode(rText)

		if(doc)then
			for i in pairs(updates)do
				doc[i] = updates[i]
			end

			PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/" .. doc._id, function(err, rText, headers)
				callback((err or true))
			end, "PUT", json.encode(doc), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})
		end
	end, "GET", "", {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})	
end

function exposedDB.updateDocumentSync(documentID, updates) 
	local result = nil
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/" .. documentID, function(err, rText, headers)
		print(err)
		local doc = json.decode(rText)

		if(doc)then
			for i in pairs(updates)do
				doc[i] = updates[i]
			end

			PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/" .. doc._id, function(err, rText, headers)
				result = err or true
			end, "PUT", json.encode(doc), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})
		end
	end, "GET", "", {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})
	while result == nil do
		Citizen.Wait(0)
	end
	return result
end

function exposedDB.updateDocumentWithRev(documentID, updates, callback)
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/" .. documentID, function(err, rText, headers)
		print("Get:"..err)
		local doc = json.decode(rText)

		if(doc)then
			for i in pairs(updates)do
				doc[i] = updates[i]
			end

			PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/" .. doc._id, function(err, rText, headers)
				print("error update with rev:"..err)
				if tonumber(err) == 409 then
					exposedDB.updateDocumentWithRev(documentID,updates, callback)
				else
					callback((err or true))
				end
				
			end, "PUT", json.encode(doc), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})
		end
	end, "GET", "", {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})	
end

function exposedDB.updateOrCreateDocument(documentID, updates, callback)
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/" .. documentID, function(err, rText, headers)
		print(err)
		print(rText)
		if(rText)then
		local doc = json.decode(rText)

		
			for i in pairs(updates)do
				doc[i] = updates[i]
			end

			PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/" .. doc._id, function(err, rText, headers)
				callback((err or true))
			end, "PUT", json.encode(doc), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})
		else
			PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/" .. documentID, function(err, rText, headers)
				callback((err or true))
			end, "PUT", json.encode(updates), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})
		end
	end, "GET", "", {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})	
end

function exposedDB.updateOrCreateDocumentSync(documentID, updates)
	local result = nil
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/" .. documentID, function(err, rText, headers)
		print(err)
		if(rText)then
		local doc = json.decode(rText)

		
			for i in pairs(updates)do
				doc[i] = updates[i]
			end

			PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/" .. doc._id, function(err, rText, headers)
				result = err or true
			end, "PUT", json.encode(doc), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})
		else
			PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. "essentialmode" .. "/" .. documentID, function(err, rText, headers)
				result = err or true
			end, "PUT", json.encode(updates), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})
		end
	end, "GET", "", {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})
	while result == nil do
		Citizen.Wait(0)
	end
	return result
end

AddEventHandler('exm:exposeDBFunctions', function(cb)
	cb(exposedDB)
end)

function exposedDB.SavePlayerExtraData(source,name,data,cb)
	if ExM.DatabaseType == "exm+couchDB" then
		local xPlayer = ExM.GetPlayerFromId(source)
		local anonTable = {}
		anonTable[name] = data
		db.updateUser(xPlayer.getIdentifier(), 
		anonTable
		,function(result) 
			if result then
				if cb then
					cb(result)
				end
				if Config.EnableDebug then
					print("Actualizado? "..result)
				end
			else
				if cb then
					cb(false)
				end
				print("Error Saving Player: ".. xPlayer.getIdentifier())
			end
		end)
	end
end

function exposedDB.SavePlayerExtraDataUsingRows(source,data,cb)
	if ExM.DatabaseType == "exm+couchDB" then
		local xPlayer = ExM.GetPlayerFromId(source)
		local anonTable = {}
		for k,v in pairs(data) do 
			anonTable[k] = v
		end
		db.updateUser(xPlayer.getIdentifier(),anonTable,function(result)
			if result then 
				cb(result)
				if Config.EnableDebug then 
					print("Actualizado? "..result)
				end
			else
				cb(false)
				print("Error Saving Player: ".. xPlayer.getIdentifier())
			end
		end)
	end
end

function exposedDB.GetPlayerSpecificData(_source,data,cb)
	if ExM.DatabaseType == "exm+couchDB" then
		local xPlayer = ExM.GetPlayerFromId(_source)
		db.retrieveUserData(xPlayer.getIdentifier(), data, function(result) 
			if result[data] then
				cb(json.encode(result))
				if Config.EnableDebug then
					print("Data getted "..json.encode(result))
				end
			else
				cb(false)
				print("Error Gettiong Player Data: ".. xPlayer.getIdentifier())
			end
		end)
	end
end


RegisterServerEvent('exm:SavePlayerExtraData')
AddEventHandler('exm:SavePlayerExtraData', function(source,name, data,cb) 
	exposedDB.SavePlayerExtraData(source,name,data,cb)
end)

RegisterServerEvent("exm:GetPlayerSpecificData")
AddEventHandler("exm:GetPlayerSpecificData", function(_source, data,cb) 
	exposedDB.GetPlayerSpecificData(_source,data,cb)
end)

-- Why the fuck is this required?
local theTestObject, jsonPos, jsonErr = json.decode('{"test":"tested"}')

--[[RegisterCommand('pruebaAPI',function()
	local data = {}
	PerformHttpRequest('http://localhost:3000/S2VAPI/authenticate',function(err,rText,headers)
		print('rtext'..rText)
		local data = json.decode(rText)
		if data.token then
			PerformHttpRequest('http://localhost:3000/S2VAPI/users/Alejandro',function(err,rText,headers)
				print(rText)
			end,'GET',json.encode(data),{['access-token']=data.token})
		end
	end, 'POST', json.encode(data),{['password'] = 'pruebaclave',['user'] = 'S2VTournament'})
end,false)]]--
