ESX = nil

ESX = exports.extendedmode:getSharedObject()

----------------------------   BEBIDA  -----------------------------------


ESX.RegisterUsableItem('water', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('water', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem("water").prop)
	xPlayer.showNotification(_U('used_water'))
end)

ESX.RegisterUsableItem('cocacola', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('cocacola', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 310000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem("cocacola").prop)
	xPlayer.showNotification(_U('used_cocacola'))
end)

ESX.RegisterUsableItem('pepsi', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('pepsi', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 310000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem("pepsi").prop)
	xPlayer.showNotification(_U('used_pepsi'))
end)

ESX.RegisterUsableItem('fanta', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('fanta', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 360000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem("fanta").prop)
	xPlayer.showNotification(_U('used_fanta'))
end)

ESX.RegisterUsableItem('sprite', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('sprite', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 410000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem("sprite").prop)
	xPlayer.showNotification(_U('used_sprite'))
end)

ESX.RegisterUsableItem('nestea', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('nestea', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 410000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem("nestea").prop)
	xPlayer.showNotification("Te has bebido un ~g~Nestea")
end)

ESX.RegisterUsableItem('aquarius', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('aquarius', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 480000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem("aquarius").prop)
	xPlayer.showNotification(_U('used_aquarius'))
end)

ESX.RegisterUsableItem('monster', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('monster', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 650000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem("monster").prop)
	xPlayer.showNotification(_U('used_monster'))
end)

ESX.RegisterUsableItem('used_water', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('used_water', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 160000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem("used_water").prop)
	xPlayer.showNotification(_U('used_used_water'))
end)

ESX.RegisterUsableItem('solo', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('solo', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 140000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem("solo").prop)
	xPlayer.showNotification("Te has tomado un ~g~Cafe Solo")
end)

ESX.RegisterUsableItem('cortado', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('cortado', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 160000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem("cortado").prop)
	xPlayer.showNotification("Te has tomado un ~g~Cortado")
end)

ESX.RegisterUsableItem('cafeleche', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('cafeleche', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem("cafeleche").prop)
	xPlayer.showNotification("Te has tomado un ~g~Cafe con leche")
end)

ESX.RegisterUsableItem('capuccino', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('capuccino', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem("capuccino").prop)
	xPlayer.showNotification("Te has tomado un ~g~Capuccino")
end)

ESX.RegisterUsableItem('americano', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('americano', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem("americano").prop)
	xPlayer.showNotification("Te has tomado un ~g~Americano")
end)

ESX.RegisterUsableItem('chocolate', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('chocolate', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem("chocolate").prop)
	xPlayer.showNotification("Te has tomado un ~g~Chocolate")
end)

ESX.RegisterUsableItem('chocoleche', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('chocoleche', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem("chocoleche").prop)
	xPlayer.showNotification("Te has tomado un ~g~Chocolate Con Leche")
end)

ESX.RegisterUsableItem('smoothie_o', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('smoothie_o', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 410000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem('smoothie_o').prop)
	xPlayer.showNotification("Te has tomado un ~g~" .. xPlayer.getInventoryItem('smoothie_o').label)
end)

ESX.RegisterUsableItem('smoothie_r', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('smoothie_r', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 410000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem('smoothie_o').prop)
	xPlayer.showNotification("Te has tomado un ~g~" .. xPlayer.getInventoryItem('smoothie_o').label)
end)

ESX.RegisterUsableItem('smoothie_g', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('smoothie_g', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 410000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem('smoothie_o').prop)
	xPlayer.showNotification("Te has tomado un ~g~" .. xPlayer.getInventoryItem('smoothie_o').label)
end)

ESX.RegisterUsableItem('smoothie_y', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('smoothie_y', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 410000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem('smoothie_o').prop)
	xPlayer.showNotification("Te has tomado un ~g~" .. xPlayer.getInventoryItem('smoothie_o').label)
end)

ESX.RegisterUsableItem('smoothie_b', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('smoothie_b', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 410000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem('smoothie_o').prop)
	xPlayer.showNotification("Te has tomado un ~g~" .. xPlayer.getInventoryItem('smoothie_o').label)
end)

ESX.RegisterUsableItem('powerade', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('powerade', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 820000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem("powerade").prop)
	xPlayer.showNotification("Te has tomado un ~g~Powerade")
end)

ESX.RegisterUsableItem('shake_r', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getInventoryItem("shake_vase").count > 0 then
		xPlayer.removeInventoryItem('shake_vase', 1)
		xPlayer.removeInventoryItem('shake_r', 1)
		xPlayer.addInventoryItem('protein_shaker', 1)
	else
		xPlayer.showNotification("Necesitas un ~g~Vaso mezclador~w~ para eso!")
	end
end)

ESX.RegisterUsableItem('shake_c', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getInventoryItem("shake_vase").count > 0 then
		xPlayer.removeInventoryItem('shake_vase', 1)
		xPlayer.removeInventoryItem('shake_c', 1)
		xPlayer.addInventoryItem('protein_shakec', 1)
	else
		xPlayer.showNotification("Necesitas un ~g~Vaso mezclador~w~ para eso!")
	end
end)

ESX.RegisterUsableItem('shake_b', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getInventoryItem("shake_vase").count > 0 then
		xPlayer.removeInventoryItem('shake_vase', 1)
		xPlayer.removeInventoryItem('shake_b', 1)
		xPlayer.addInventoryItem('protein_shakeb', 1)
	else
		xPlayer.showNotification("Necesitas un ~g~Vaso mezclador~w~ para eso!")
	end
end)

ESX.RegisterUsableItem('protein_shaker', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('protein_shaker', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 350000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem("protein_shaker").prop)
	xPlayer.showNotification("Te has tomado un ~g~Batido de Fresa")
end)

ESX.RegisterUsableItem('protein_shakec', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('protein_shakec', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 350000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem("protein_shakec").prop)
	xPlayer.showNotification("Te has tomado un ~g~Batido de Choco")
end)

ESX.RegisterUsableItem('protein_shakeb', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('protein_shakeb', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 350000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, xPlayer.getInventoryItem("protein_shakeb").prop)
	xPlayer.showNotification("Te has tomado un ~g~Batido de Platano")
end)

--------------------- BEBIDAS ALCOHOLICAS -----------------------------------

ESX.RegisterUsableItem('vodka', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('vodka', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 150000)
	TriggerClientEvent('esx_basicneeds:drinkAlcohol', source, 1, xPlayer.getInventoryItem("vodka").prop)
	xPlayer.showNotification(_U('used_vodka'))
end)

ESX.RegisterUsableItem('whisky', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('whisky', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 170000)
	TriggerClientEvent('esx_basicneeds:drinkAlcohol', source, 1, xPlayer.getInventoryItem("whisky").prop)
	xPlayer.showNotification(_U('used_whisky'))
end)

ESX.RegisterUsableItem('heineken', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('heineken', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 225000)
	TriggerClientEvent('esx_basicneeds:drinkAlcohol', source, 0, xPlayer.getInventoryItem("heineken").prop)
	xPlayer.showNotification(_U('used_heineken'))
end)

ESX.RegisterUsableItem('tequila', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('tequila', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 175000)
	TriggerClientEvent('esx_basicneeds:drinkAlcohol', source, 2, xPlayer.getInventoryItem("tequila").prop)
	xPlayer.showNotification(_U('used_tequila'))
end)

ESX.RegisterUsableItem('rum', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('rum', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 185000)
	TriggerClientEvent('esx_basicneeds:drinkAlcohol', source, 2, xPlayer.getInventoryItem("rum").prop)
	xPlayer.showNotification(_U('used_rum'))
end)

ESX.RegisterUsableItem('vodka_bathory', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('vodka_bathory', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 245000)
	TriggerClientEvent('esx_basicneeds:drinkAlcohol', source, 2, xPlayer.getInventoryItem("vodka_bathory").prop)
	xPlayer.showNotification(_U('used_vodka_bathory'))
end)

----------------------------   COMIDA  -----------------------------------

ESX.RegisterUsableItem('bread', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bread', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 210000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("bread").prop)
	xPlayer.showNotification(_U('used_bread'))
end)

ESX.RegisterUsableItem('snickers', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('snickers', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 275000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("snickers").prop)
	xPlayer.showNotification(_U('used_snickers'))
end)

ESX.RegisterUsableItem('energy_bar', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('energy_bar', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 365000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("energy_bar").prop)
	xPlayer.showNotification(_U('used_snickers'))
end)

ESX.RegisterUsableItem('twix', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('twix', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 300000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("twix").prop)
	xPlayer.showNotification("Te has comido un ~g~Twix")
end)

ESX.RegisterUsableItem('kitkat', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('kitkat', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 325000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("kitkat").prop)
	xPlayer.showNotification("Te has comido un ~g~Kitkat")
end)

ESX.RegisterUsableItem('potatostick', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('potatostick', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 335000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("potatostick").prop)
	xPlayer.showNotification("Te has comido unas ~g~Patatas fritas")
end)

ESX.RegisterUsableItem('haribo', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('haribo', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 290000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("haribo").prop)
	xPlayer.showNotification("Te has comido unos ~g~Ositos Haribo")
end)

ESX.RegisterUsableItem('chetos', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('chetos', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 350000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("chetos").prop)
	xPlayer.showNotification("Te has comido unos ~g~Chetos")
end)

ESX.RegisterUsableItem('caramelos', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('caramelos', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 275000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("caramelos").prop)
	xPlayer.showNotification("Te has comido unos Caramelos")
end)

ESX.RegisterUsableItem('cheesebows', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('cheesebows', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 295000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("cheesebows").prop)
	xPlayer.showNotification(_U('used_cheesebows'))
end)

ESX.RegisterUsableItem('chips', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('chips', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 325000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("chips").prop)
	xPlayer.showNotification(_U('used_chips'))
end)

ESX.RegisterUsableItem('oreo', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('oreo', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 420000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("oreo").prop)
	xPlayer.showNotification(_U('used_oreo'))
end)

ESX.RegisterUsableItem('burger', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('burger', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 325000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("burger").prop)
	xPlayer.showNotification(_U('used_burger'))
end)

ESX.RegisterUsableItem('pizza', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('pizza', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 365000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("pizza").prop)
	xPlayer.showNotification(_U('used_pizza'))
end)

ESX.RegisterUsableItem('taco', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('taco', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 430000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("taco").prop)
	xPlayer.showNotification(_U('used_taco'))
end)

ESX.RegisterUsableItem('kebab', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('kebab', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 550000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("kebab").prop)
	xPlayer.showNotification(_U('used_kebab'))
end)

ESX.RegisterUsableItem('lasagna', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('lasagna', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 655000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("lasagna").prop)
	xPlayer.showNotification(_U('used_lasagna'))
end)

ESX.RegisterUsableItem('donut_w', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('donut_w', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 275000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("donut_w").prop)
	xPlayer.showNotification(_U('used_donut'))
end)

ESX.RegisterUsableItem('donut_b', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('donut_b', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 275000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("donut_b").prop)
	xPlayer.showNotification(_U('used_donut'))
end)

ESX.RegisterUsableItem('donut', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('donut', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 225000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("donut").prop)
	xPlayer.showNotification(_U('used_donut'))
end)

ESX.RegisterUsableItem('berlina_c', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('berlina_c', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 315000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("berlina_c").prop)
	xPlayer.showNotification(_U('used_berlina'))
end)

ESX.RegisterUsableItem('berlina_b', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('berlina_b', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 315000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("berlina_b").prop)
	xPlayer.showNotification(_U('used_berlina'))
end)

ESX.RegisterUsableItem('apple', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('apple', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 185000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("apple").prop)
	xPlayer.showNotification(_U('used_apple'))
end)

ESX.RegisterUsableItem('banana', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('banana', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 215000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("banana").prop)
	xPlayer.showNotification(_U('used_banana'))
end)

ESX.RegisterUsableItem('mango', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('mango', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 255000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("mango").prop)
	xPlayer.showNotification(_U('used_mango'))
end)

ESX.RegisterUsableItem('orange', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('orange', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 255000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("orange").prop)
	xPlayer.showNotification(_U('used_orange'))
end)

ESX.RegisterUsableItem('peach', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('peach', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 255000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("peach").prop)
	xPlayer.showNotification(_U('used_peach'))
end)

ESX.RegisterUsableItem('verdura_pocha', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('verdura_pocha', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 175000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("verdura_pocha").prop)
	xPlayer.showNotification(_U('used_verdura_pocha'))
end)

ESX.RegisterUsableItem('rotten_apple', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('rotten_apple', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 145000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("rotten_apple").prop)
	xPlayer.showNotification(_U('used_rotten_apple'))
end)

ESX.RegisterUsableItem('yogur', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('yogur', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 195000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("yogur").prop)
	xPlayer.showNotification(_U('used_yogur'))
end)

ESX.RegisterUsableItem('spoil_meat', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('spoil_meat', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 215000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("spoil_meat").prop)
	xPlayer.showNotification(_U('used_spoil_meat'))
end)

ESX.RegisterUsableItem('potato', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('potato', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 165000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("potato").prop)
	xPlayer.showNotification(_U('used_potato'))
end)

ESX.RegisterUsableItem('rotten_bread', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('rotten_bread', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 155000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("rotten_bread").prop)
	xPlayer.showNotification(_U('used_rotten_bread'))
end)

ESX.RegisterUsableItem('bombon', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bombon', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 105000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("bombon").prop)
	xPlayer.showNotification(_U('used_bombon'))
end)

ESX.RegisterUsableItem('bitten_donut', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bitten_donut', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 175000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("bitten_donut").prop)
	xPlayer.showNotification(_U('used_bitten_donut'))
end)

ESX.RegisterUsableItem('bitten_cookie', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bitten_cookie', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 135000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("bitten_cookie").prop)
	xPlayer.showNotification(_U('used_bitten_cookie'))
end)

ESX.RegisterUsableItem('gum_r', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('gum_r', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 95000)
	TriggerClientEvent("stress:remove", source, 175000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("gum_r").prop)
	xPlayer.showNotification("Te has comido un ~Chicle~")
end)

ESX.RegisterUsableItem('gum_g', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('gum_g', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 95000)
	TriggerClientEvent("stress:remove", source, 175000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("gum_g").prop)
	xPlayer.showNotification("Te has comido un ~Chicle~")
end)

ESX.RegisterUsableItem('gum_b', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('gum_b', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 95000)
	TriggerClientEvent("stress:remove", source, 175000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("gum_b").prop)
	xPlayer.showNotification("Te has comido un ~Chicle~")
end)

ESX.RegisterUsableItem('gum_o', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('gum_o', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 95000)
	TriggerClientEvent("stress:remove", source, 175000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("gum_o").prop)
	xPlayer.showNotification("Te has comido un ~Chicle~")
end)

ESX.RegisterUsableItem('gum_y', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('gum_y', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 95000)
	TriggerClientEvent("stress:remove", source, 175000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("gum_y").prop)
	xPlayer.showNotification("Te has comido un ~Chicle~")
end)

ESX.RegisterUsableItem('gum_p', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('gum_p', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 95000)
	TriggerClientEvent("stress:remove", source, 175000)
	TriggerClientEvent('esx_basicneeds:onEat', source, xPlayer.getInventoryItem("gum_p").prop)
	xPlayer.showNotification("Te has comido un ~Chicle~")
end)

----------------------------   DROGAS  -----------------------------------

--morfina
ESX.RegisterUsableItem('morphine', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('morphine', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', -50000)
	TriggerClientEvent('esx_status:add', source, 'hunger', -50000)
	TriggerClientEvent('OurStoryMorphine:inject', source)
end)

--adrenalina
ESX.RegisterUsableItem('adrenaline_shot', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('adrenaline_shot', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', -50000)
	TriggerClientEvent('esx_status:add', source, 'hunger', -50000)
	TriggerClientEvent('esx_optionalneeds:onAdrenaline', source)
end)

----------------------------   UTILIDADES  -----------------------------------

-- Binoculars
ESX.RegisterUsableItem('binoculars', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:binoculars', source)
end)

--chaleco antibalas
ESX.RegisterUsableItem('bulletproof', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_extraitems:bulletproof', source)
	xPlayer.removeInventoryItem('bulletproof', 1)
	xPlayer.showNotification("Has usado el chaleco antibalas")
end)

------------------------------- COMBINACIONES ----------------------------------------

local piecesNeeded = {
	{name = "hdd", count = 1},
	{name = "ram", count = 2},
	{name = "psu", count = 1},
	{name = "motherboard", count = 1},
	{name = "wires", count = 3},
	{name = "gpu", count = 1},
	{name = "audio_card", count = 1},
	{name = "computer_case", count = 1},
	{name = "mouse", count = 1},
	{name = "keyboard", count = 1}
}

function tryCraftPc(xPlayer)
	for i = 1, #piecesNeeded do
		if xPlayer.getInventoryItem(piecesNeeded[i].name).count < piecesNeeded[i].count then
			xPlayer.showNotification("~r~No tienes suficientes piezas para montar un PC")
			return
		end
	end
	craftPc(xPlayer)
end

function craftPc(xPlayer)
	for i = 1, #piecesNeeded do
		xPlayer.removeInventoryItem(piecesNeeded[i].name, piecesNeeded[i].count)
	end
	xPlayer.addInventoryItem('computer', 1)
	xPlayer.showNotification("~g~Has montado un PC")
end

--PIEZAS PC
ESX.RegisterUsableItem('hdd', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	tryCraftPc(xPlayer)
end)
ESX.RegisterUsableItem('ram', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	tryCraftPc(xPlayer)
end)
ESX.RegisterUsableItem('psu', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	tryCraftPc(xPlayer)
end)
ESX.RegisterUsableItem('motherboard', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	tryCraftPc(xPlayer)
end)
ESX.RegisterUsableItem('wires', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	tryCraftPc(xPlayer)
end)
ESX.RegisterUsableItem('gpu', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	tryCraftPc(xPlayer)
end)
ESX.RegisterUsableItem('audio_card', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	tryCraftPc(xPlayer)
end)
ESX.RegisterUsableItem('computer_case', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	tryCraftPc(xPlayer)
end)