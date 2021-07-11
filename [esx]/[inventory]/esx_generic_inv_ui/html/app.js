var currentStatus = 'trunk';
var currentCarTrunk = [];
var amount = 0;
var currentInventory = [];
var currentPlayerWeight = 0;
var playerMaxWeight = 0;
var trunkMaxWeight = 0;
var trunkCurrentWeight = 0;
var containerType = "";
var containerName = "";
var currentContainerImg = "";
var currentContainerName = "";
var onlyTake = false;
var usingContainer = false;


window.addEventListener("message", function (event) {
    if(event.data.action == "update") {
        currentCarTrunk = event.data.container
        if (currentStatus == "trunk") {
            trunkSetup(currentCarTrunk)
        }
    }
    if (event.data.action == "open") {
        currentStatus = 'trunk'
        amount = 0;
        currentCarTrunk = event.data.container;
        currentInventory = event.data.inventory;
        currentPlayerWeight = Math.round(event.data.playerCurrentWeight * 10) / 10;
        playerMaxWeight = event.data.playerCapacity;
        trunkMaxWeight = event.data.containerCapacity;
        trunkCurrentWeight = getTrunkCurrentWeight(currentCarTrunk.items);
        containerType = event.data.type;
        containerName = event.data.name;
        currentContainerName = event.data.label;
        onlyTake = event.data.onlyTake;

        if(containerType == "society"){
            if(containerName == "police"){
                currentContainerImg = "url(img/weaponary.png)";
            }else if (containerName == "ambulance"){
                currentContainerImg = "url(img/medicbag.png)";
            }else if (containerName == "mechanic"){
                currentContainerImg = "url(img/mechstore.png)";
            }else if (containerName == "cardealer"){
                currentContainerImg = "url(img/cardealers.png)";
            }
            else{
                currentContainerImg = "url(img/storage.png)";
            }
        }else if(containerType == "trunk"){
            currentContainerImg = "url(img/trunk.png)";
        }else if(containerType == "house"){
            currentContainerImg = "url(img/storage.png)";
        }else if (containerType == "trash"){
            currentContainerImg = "url(img/trash.png)";
        }

        $("body, html").css("display", "flex");
        $("#count").html('Todo');
        $("#bagtrunk").css("background-image", "url(img/mochila.png)");
        $("#items-container").css("background-image", currentContainerImg);
        $("#items-container").html("");

        trunkSetup(currentCarTrunk);       
    } 
})

function getTrunkCurrentWeight(trunkItems){
    var currentWeight = 0;
    for(i = 0; i < trunkItems.length; i++){
        currentWeight = Math.round((currentWeight + trunkItems[i].weight * trunkItems[i].count) * 10) / 10;

    }
    return currentWeight;
}

function updateLocalInventory(item, finalAmount){
    if(item.type == "account"){
        for(i = 0; i < currentInventory.accounts.length; i++){
            if (currentInventory.accounts[i].name == item.name){
                currentInventory.accounts[i].money -= finalAmount;
                break;
            }
        }
    }else if (item.type == "item"){
        for(i = 0; i < currentInventory.items.length; i++){
            if (currentInventory.items[i].name == item.name){
                currentInventory.items[i].count -= finalAmount;
                break;
            }
        } 
        currentPlayerWeight = Math.round((currentPlayerWeight - item.weight * finalAmount) * 10) / 10;
    }else{
        for(i = 0; i < currentInventory.weapons.length; i++){
            if (currentInventory.weapons[i].name == item.name){
                currentInventory.weapons.splice(i, 1);
                break;
            }
        }
    }
}

function updateInventoryChanges(item, finalAmount, action){
    var currentInventoryChanges = [];
    currentInventoryChanges.adds = [];
    currentInventoryChanges.removes = [];
    if (action == "remove"){      
        if (item.type == "weapon"){
            currentInventoryChanges.removes.push({type: item.type, name: item.name, amount: finalAmount, components: item.components, serial: item.serial});
        }else{
            currentInventoryChanges.removes.push({type: item.type, name: item.name, amount: finalAmount});
        } 
    }else{
        if (item.type == "weapon"){
            currentInventoryChanges.adds.push({type: item.type, name: item.name, amount: finalAmount, components: item.components, serial: item.serial});
        }else{
            currentInventoryChanges.adds.push({type: item.type, name: item.name, amount: finalAmount});
        } 
    }  
    console.log(JSON.stringify(currentInventoryChanges))
    $.post("http://esx_generic_inv_ui/confirm", JSON.stringify({
        inventoryAdds: currentInventoryChanges.adds,
        inventoryRemoves: currentInventoryChanges.removes,
        currentData: currentCarTrunk,
        type: containerType,
        name: containerName
    }));
    usingContainer = true;
    setTimeout(function(){ usingContainer = false; }, 1250);
}

function addTrunkItem(item){
    var finalAmount = getFinalAmount(item);
    if(item.type == "account"){
        var found = false
        for(i = 0; i < currentCarTrunk.accounts.length; i++){
            if (currentCarTrunk.accounts[i].name == item.name){
                found = true;
                currentCarTrunk.accounts[i].money += finalAmount;
                break;
            }
        }
        if(!found){        
            currentCarTrunk.accounts.push({name: item.name, label: item.label, money: finalAmount, type: 'account'}) 
        }
        updateLocalInventory(item, finalAmount)
        setTimeout(function(){ updateInventoryChanges(item, finalAmount, 'remove'); }, Math.floor(Math.random() * 500) + 50);
        
    }else if (item.type == "item"){
        var found = false;
        for(i = 0; i < currentCarTrunk.items.length; i++){
            if (currentCarTrunk.items[i].name == item.name){
                found = true;
                currentCarTrunk.items[i].count += finalAmount;
                break;
            }
        }
        if (!found){
           currentCarTrunk.items.push({name: item.name, label: item.label, count: finalAmount, weight: item.weight, type: 'item'}); 
        }
        trunkCurrentWeight = Math.round((trunkCurrentWeight + item.weight * finalAmount) * 10) / 10;
        updateLocalInventory(item, finalAmount)
        setTimeout(function(){ updateInventoryChanges(item, finalAmount, 'remove'); }, Math.floor(Math.random() * 500) + 50);
             
    }else if (item.type == "weapon"){
        updateLocalInventory(item)
        currentCarTrunk.weapons.push({name: item.name, label: item.label, ammo: item.ammo, type: 'weapon', components: item.components, serial: item.serial})
        setTimeout(function(){ updateInventoryChanges(item, finalAmount, 'remove'); }, Math.floor(Math.random() * 500) + 50);
    }
    trunkSetup(currentInventory);
}

function updateLocalTrunk(item, finalAmount){
    if(item.type == "account"){
        for(i = 0; i < currentCarTrunk.accounts.length; i++){
            if (currentCarTrunk.accounts[i].name == item.name){
                currentCarTrunk.accounts[i].money -= finalAmount;
                break;
            }
        }
    }else if (item.type == "item"){
        for(i = 0; i < currentCarTrunk.items.length; i++){
            if (currentCarTrunk.items[i].name == item.name){
                currentCarTrunk.items[i].count -= finalAmount;
                break;
            }
        } 
        trunkCurrentWeight = Math.round((trunkCurrentWeight - item.weight * finalAmount) * 10) / 10;
    }else{
        for(i = 0; i < currentCarTrunk.weapons.length; i++){
            if (currentCarTrunk.weapons[i].name == item.name){
                currentCarTrunk.weapons.splice(i, 1);
                break;
            }
        }
    }
}

function addInventoryItem(item){
    var finalAmount = getFinalAmount(item)
    if(item.type == "account"){
        var found = false
        for(i = 0; i < currentInventory.accounts.length; i++){
            if (currentInventory.accounts[i].name == item.name){
                found = true;
                currentInventory.accounts[i].money += finalAmount;
                break;
            }
        }
        if(!found){        
            currentInventory.accounts.push({name: item.name, label: item.label, money: finalAmount, type: 'account'}) 
        }
        updateLocalTrunk(item, finalAmount)
        setTimeout(function(){ updateInventoryChanges(item, finalAmount, 'add'); }, Math.floor(Math.random() * 500) + 50);  
    }else if (item.type == "item"){
        var found = false;
        for(i = 0; i < currentInventory.items.length; i++){
            if (currentInventory.items[i].name == item.name){
                found = true;
                currentInventory.items[i].count += finalAmount;
                break;
            }
        }
        if (!found){
           currentInventory.items.push({name: item.name, label: item.label, count: finalAmount, weight: item.weight, type: 'item'}); 
        }
        currentPlayerWeight = Math.round((currentPlayerWeight + item.weight * finalAmount) * 10) / 10;
        updateLocalTrunk(item, finalAmount)
        setTimeout(function(){ updateInventoryChanges(item, finalAmount, 'add'); }, Math.floor(Math.random() * 500) + 50);   
    }else{
        updateLocalTrunk(item)
        currentInventory.weapons.push({name: item.name, label: item.label, ammo: item.ammo, type: 'weapon', components: item.components})
        setTimeout(function(){ updateInventoryChanges(item, finalAmount, 'add'); }, Math.floor(Math.random() * 500) + 50);
    }
    trunkSetup(currentCarTrunk);
}

function getFinalAmount(item){
    var finalAmount = 0;
    if (amount == 0){
        if(item.type == "account"){
            finalAmount = item.money;
        }else if (item.type == "item"){
            finalAmount = item.count;
        }else{
            finalAmount = item.ammo;
        }
    }else{
        if (item.type == "weapon"){
            finalAmount = item.ammo;
        }else{
            finalAmount = amount;
        }      
    }
    return finalAmount;
}

function checkIfCanMoveItem(item){
    var finalAmount = getFinalAmount(item)
    if(item.type == "account"){
        if (item.money < finalAmount){
            return false;
        }
    }else if (item.type == "item"){
        if (item.count < finalAmount){
            return false;
        }    
    }
    return true;
}

function checkWeight(item){
    var finalAmount = getFinalAmount(item)
    if (item.type == 'item') {
        if (currentStatus == 'bag') {
            if (finalAmount * item.weight + trunkCurrentWeight > trunkMaxWeight){
                return false;
            }
        }else{
            if (finalAmount * item.weight + currentPlayerWeight > playerMaxWeight){
                return false;
            }        
        }
    }else if (item.type == 'weapon'){
        if (currentStatus != 'bag') {
            if(currentInventory.weapons.length >= 3){
                return false;
            }
            for(var i = 0; i < currentInventory.weapons.length; i++){
                if(currentInventory.weapons[i].name == item.name){
                    return false;
                }
            }
        }
    }
    return true;
}

$(document).ready(function () {
    $('#bagtrunk').droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            if (checkIfCanMoveItem(itemData) && !usingContainer){
                if (currentStatus == 'bag') {
                    if (checkWeight(itemData)){
                       addTrunkItem(itemData); 
                    }else{
                        $("#weight").css("color", "white");
                    }  
                }else{
                    if (checkWeight(itemData)){
                        addInventoryItem(itemData)
                    }else{
                        $("#weight").css("color", "white");
                    }      
                }
            }else{
                ui.draggable.css("color", "white");
                ui.draggable.css("background-color", "rgba(17, 5, 17, 0.4)");
                $("#weight").css("color", "white");
            }
        }
    });

    $('#bagtrunk').droppable({
        over: function( event, ui ) {
            itemData = ui.draggable.data("item");
            if (!checkIfCanMoveItem(itemData) || usingContainer){
                ui.draggable.css("color", "red");
                ui.draggable.css("background-color", "rgba(180, 0, 0, 0.5)");
                ui.helper.css("background-color", "rgba(180, 0, 0, 0.5)");
                ui.helper.css("color", "red");
            }
            if (!checkWeight(itemData)){
                $("#weight").css("color", "red");
            }
        }
    });

    $('#bagtrunk').droppable({
        out: function( event, ui ) {
            itemData = ui.draggable.data("item");
            ui.draggable.css("color", "white");
            ui.draggable.css("background-color", "rgba(17, 5, 17, 0.4)");
            ui.helper.css("background-color", "rgba(17, 5, 17, 0.4)");
            ui.helper.css("color", "white");
            $("#weight").css("color", "white");
        }
    });

    $("#bagtrunk").click(function() {
        if (!onlyTake) {
            if (currentStatus == 'trunk') {
                currentStatus = 'bag';           
                $("#bagtrunk").css("background-image", currentContainerImg);
                $("#items-container").css("background-image", "url(img/mochila.png)");
                trunkSetup(currentInventory);
            } else {
                currentStatus = 'trunk';           
                $("#bagtrunk").css("background-image", "url(img/mochila.png)");
                $("#items-container").css("background-image", currentContainerImg);
                trunkSetup(currentCarTrunk)
            }
        }   
    });

    $("#more").click(function() {
        if (amount < 100) {amount++;}
        $("#count").html(amount);
    });

    $("#less").click(function() {
        if (amount > 0) {amount--;}
        if (amount == 0){
            $("#count").html("Todo");
        }else{
            $("#count").html(amount);
        }        
    });

    $("#exit").click(function() {
        $("body, html").css("display", "none");
        $.post("http://esx_generic_inv_ui/exit", JSON.stringify({
            type: containerType,
            name: containerName
        }));
    });

    /*$("#confirm").click(function() {
        $("body, html").css("display", "none");
        $.post("http://esx_generic_inv_ui/confirm", JSON.stringify({
            inventoryAdds: currentInventoryChanges.adds,
            inventoryRemoves: currentInventoryChanges.removes,
            currentData: currentCarTrunk,
            type: containerType,
            name: containerName
        }));
    });*/
});

function trunkSetup(items) {
    var itemIndex = 0;
    var amountOfLastItemType = 0;
    $("#items-container").html("");
    if(items.accounts != undefined){
        console.log("inciiando cuentas")
        for (i = 0; i < items.accounts.length; i++){
            console.log("inciiando cuentas "+ i)
            if(items.accounts[i].money > 0){
                console.log("inciiando cuentas hecho"+ i)
                $("#items-container").append('<div class="item" id="item-' + itemIndex + '" style = "background-image: url(img/items/' + items.accounts[i].name + '.png);"><div class="item-name">' + items.accounts[i].label + '<br><hr>' + items.accounts[i].money + '€</div></div>');
                $('#item-' + itemIndex).data('item', items.accounts[i]);  
                itemIndex++;
            }   
        }
    }   

    if (itemIndex > 0){
       $("#items-container").append('<div class="separator"></div>');
        amountOfLastItemType = itemIndex
    }
    if(items.items != undefined){
        for (i = 0; i < items.items.length; i++){
            if(items.items[i].count > 0){
                $("#items-container").append('<div class="item" id="item-' + itemIndex + '" style = "background-image: url(img/items/' + items.items[i].name + '.png);"><div class="item-name">' + items.items[i].label + '<br><hr>x' + items.items[i].count + '</div></div>');
                $('#item-' + itemIndex).data('item', items.items[i]);  
                itemIndex++;
            }  
        }
    }

    if (itemIndex > amountOfLastItemType && items.weapons.length > 0) {
        $("#items-container").append('<div class="separator"></div>');
    }
    if(items.weapons != undefined){
        for (i = 0; i < items.weapons.length; i++){
            console.log(items.weapons)
            $("#items-container").append('<div class="item" id="item-' + itemIndex + '" style = "background-image: url(img/items/' + items.weapons[i].name + '.png);"><div class="item-name">' + items.weapons[i].label + '<br><hr>mun:' + items.weapons[i].ammo + '</div></div>');
            $('#item-' + itemIndex).data('item', items.weapons[i]);  
            itemIndex++;
        }
    }     

    if (currentStatus == 'trunk'){
        $("#title").html(currentContainerName + ' - ' + trunkCurrentWeight + "kg/" + trunkMaxWeight + "kg");
        $("#weight").html(currentPlayerWeight + "kg/" + playerMaxWeight + "kg");
    }else{
        $("#title").html("Mochila - " + currentPlayerWeight + "kg/" + playerMaxWeight + "kg");
        $("#weight").html(trunkCurrentWeight + "kg/" + trunkMaxWeight + "kg");
    }

    $('.item').draggable({
        helper: 'clone',
        zIndex: 99999,
        revert: 'invalid',
        start: function (event, ui) {
            itemData = $(this).data("item");
        },
        stop: function () {
            itemData = $(this).data("item");
        }
    });
}