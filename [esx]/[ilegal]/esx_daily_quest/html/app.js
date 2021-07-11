var level = 0;
var currentXP = 0;
var npcName = "";
var npcSurname = "";
var isOnQuest = false;
var currentQuestIsCompleted = false;
var lvlNeedXP = [];
var rangeNames = [];
var currentQuestInfo = [];
var storeItems = [];
var selectedItem = 0;
var playerMoney = 0;
var playerCapacity = 0;
var playerCurrentWeight = 0;
var wantedItem = [];
var npcWantedItemCount = 0;
var vehicleOwned = false;
var questItemCount = 0;

window.addEventListener("message", function (event) {
    if (event.data.action == "open") {
        level = event.data.level;
        currentXP = event.data.currentXP;
        isOnQuest = event.data.isOnQuest;
        currentQuestIsCompleted = event.data.currentQuestIsCompleted;
        lvlNeedXP = event.data.lvlNeedXP;
        rangeNames = event.data.rangeNames;
        currentQuestInfo = event.data.currentQuestInfo;
        canStartQuest = event.data.canStartQuest;
        npcName = event.data.name;
        npcSurname = event.data.surname;
        storeItems = event.data.storeItems;
        playerMoney = event.data.playerMoney;
        playerCapacity = event.data.playerCapacity;
        playerCurrentWeight = event.data.playerCurrentWeight;
        wantedItem = event.data.wantedItem;
        npcWantedItemCount = event.data.npcWantedItemCount;
        vehicleOwned = event.data.vehicleOwned;
        questItemCount = event.data.questItemCount;

        setupBasicInfo(event.data.name, event.data.surname);

        setupQuestInfo(isOnQuest, currentQuestInfo, canStartQuest, currentQuestIsCompleted);

        setupStoreInfo(storeItems);

        setupWantedItemInfo(wantedItem);

        $("#mainContainer").css("display", "block");
        $("#npcImage").css("background-image", "url(img/" + npcName + ".png)");
        $("body, html").css("display", "flex");
        $("body, html").css("background-color", "rgba(17, 5, 17, 0.3)");             
    }else if (event.data.action == "showNotification"){
        $("#mainContainer").css("display", "none");
        $("body, html").css("background-color", "transparent");
        $("body, html").css("display", "flex"); 
        showWarning(event.data.message);
        setTimeout(function(){
            $("body, html").css("display", "none");
        }, 3500);
    }
})

$(document).ready(function () {
    $("#close").click(function() {
        $("body, html").css("display", "none");
        $.post("http://esx_daily_quest/exit", JSON.stringify({
            level: level,
            currentXP: currentXP,
            isOnQuest: isOnQuest,
            currentQuestIsCompleted: currentQuestIsCompleted,
            currentQuestInfo: currentQuestInfo,
            canStartQuest: canStartQuest,
            npcName: npcName,
            storeItems: storeItems
        }));
    });

    $("#wantedItemsGive").click(function() {
        if(npcWantedItemCount > 0){
            giveItemToNpc()
        }
    });

    $("#npcItemsBuy").click(function() {
        var itemCount;
        if (selectedItem.type != "item"){
            itemCount = 1;
        }else{
            itemCount = parseInt($("#npcItemsInput").val(), 10);
        }

        if(selectedItem.levelNeed <= level && itemCount <= selectedItem.stockAmount && selectedItem.stockAmount > 0 && itemCount > 0 && itemCount <= 100){        
            if (playerMoney >= selectedItem.price * itemCount){
                //$("#wantedItemDataContainer").html("type: " + selectedItem.type + ", peso objeto: " + selectedItem.weight + ", pesoMaxJugador: " + playerCapacity + ", pesoActual: " + playerCurrentWeight);
                if (selectedItem.type == "item" && playerCurrentWeight + selectedItem.weight * itemCount <= playerCapacity || selectedItem.type != "item"){
                    for(var i = 0; i < storeItems.length; i++){
                        if(storeItems[i].name == selectedItem.name){
                            storeItems[i].stockAmount -= itemCount;
                        }
                    }
                    playerCurrentWeight += selectedItem.weight * itemCount
                    playerMoney -= selectedItem.price * itemCount;
                    if (selectedItem.type == "vehicle"){
                        vehicleOwned = true;
                    }
                    $.post("http://esx_daily_quest/buyItem", JSON.stringify({
                        level: level,
                        currentXP: currentXP,
                        isOnQuest: isOnQuest,
                        currentQuestIsCompleted: currentQuestIsCompleted,
                        currentQuestInfo: currentQuestInfo,
                        canStartQuest: canStartQuest,
                        npcName: npcName,
                        storeItems: storeItems,
                        vehicleOwned: vehicleOwned,
                        item: selectedItem,
                        count: itemCount
                    }));
                    setupStoreInfo(storeItems);
                }
            }
        }
    });
});

function setupBasicInfo(name, surname) {
    var indexByLevel = level - 1;
    $("#dataTitle").html(name + " " + surname);
    $("#level").html("Nivel: " + level);
    $("#range").html("Rango: " + rangeNames[indexByLevel]);
    $("#progresNum").html(currentXP + "/" + lvlNeedXP[indexByLevel]);
    $("#progress").css("width", (currentXP * 100 / lvlNeedXP[indexByLevel]) + "%");
}

function setupQuestInfo(isOnQuest, currentQuestInfo, canStartQuest, currentQuestIsCompleted) {
    var itemsWeight = 0;
    if(isOnQuest){
        $("#controlsHeader").html("Mision en curso - " + currentQuestInfo.name);
        $("#controlsHeader").css("color", "lightgrey");
        $("#questButton").html("Completar");
        $("#itemsRegard").html("");
        $("#moneyRegard").css("display", "flex");
        $("#moneyRegard").html((currentQuestInfo.money * (1 + (level / 10) * 2)) + "€");       
        for(var i = 0; i < currentQuestInfo.possibleItems.length; i++){
            $("#itemsRegard").append('<div class="regardItem" style="background-image: url(img/items/' + currentQuestInfo.possibleItems[i].name + '.png);"></div>');
            itemsWeight += currentQuestInfo.possibleItems[i].amount * currentQuestInfo.possibleItems[i].weight;
        }
        console.log(itemsWeight);
        if(currentQuestIsCompleted){
            if (playerCurrentWeight + itemsWeight <= playerCapacity){
                if (currentQuestInfo.questType == "pickup"){
                    if (questItemCount > 0){
                        $("#questImg").css("background-image", "url(img/check.png)");
                        $("#questStatus").html("Entrega la mision a " + npcName + " para completarla.");         
                        $("#questButton").css("background-color", "rgba(0, 90, 0, 0.4)");
                    }else{
                        $("#questImg").css("background-image", "url(img/cross.png)");
                        $("#questStatus").html("No puedes entregar la mision, no tienes el objeto necesario, vuelve al punto de recogida para obtener otro.");         
                        $("#questButton").css("background-color", "rgba(90, 90, 90, 0.4)");
                    }
                }else{
                    $("#questImg").css("background-image", "url(img/check.png)");
                    $("#questStatus").html("Entrega la mision a " + npcName + " para completarla.");         
                    $("#questButton").css("background-color", "rgba(0, 90, 0, 0.4)");
                }    
            }else{
                $("#questImg").css("background-image", "url(img/check.png)");
                $("#questStatus").html("No puedes entregar la mision, no tienes espacio en el inventario para recibir las recompensas.");         
                $("#questButton").css("background-color", "rgba(90, 90, 90, 0.4)");
            }     
        }else{
            $("#questStatus").html(currentQuestInfo.description);
            $("#questImg").css("background-image", "url(img/current.png)");
            $("#questButton").css("background-color", "rgba(90, 90, 90, 0.4)");
            if (currentQuestInfo.questType == "delivery" && questItemCount == 0){
                $.post("http://esx_daily_quest/giveItem", JSON.stringify({
                        item: currentQuestInfo.questItem
                }));
                questItemCount++;
                playerCurrentWeight++;
            }
        }
    }else{
        if(canStartQuest && currentQuestInfo != null && currentQuestInfo != undefined){
            if(playerCurrentWeight + 1 <= playerCapacity){
                $("#controlsHeader").html("Mision disponible - " + currentQuestInfo.name);
                $("#controlsHeader").css("color", "yellow");
                $("#questImg").css("background-image", "url(img/new_quest.png)");
                $("#questStatus").html(currentQuestInfo.description);
                $("#questButton").html("Iniciar mision");
                $("#questButton").css("background-color", "rgba(120, 85, 0, 0.7)");
                $("#itemsRegard").html("");
                $("#moneyRegard").css("display", "flex");
                $("#moneyRegard").html((Math.round(currentQuestInfo.money * (1 + (level / 10) * 2))) + "€");
            }else{
                $("#controlsHeader").html("Mision disponible - " + currentQuestInfo.name);
                $("#controlsHeader").css("color", "red");
                $("#questImg").css("background-image", "url(img/new_quest.png)");
                $("#questStatus").html("No puedes  iniciar la mision, no tienes suficiente espacio en el inventario para transportar el objeto.");
                $("#questButton").html("Iniciar mision");
                $("#questButton").css("background-color", "rgba(90, 90, 90, 0.4)");
                $("#itemsRegard").html("");
                $("#moneyRegard").css("display", "flex");
                $("#moneyRegard").html((Math.round(currentQuestInfo.money * (1 + (level / 10) * 2))) + "€");
            }
            for(var i = 0; i < currentQuestInfo.possibleItems.length; i++){
                $("#itemsRegard").append('<div class="regardItem" style="background-image: url(img/items/' + currentQuestInfo.possibleItems[i].name + '.png);"></div>');
            }    
        }else{
            $("#controlsHeader").html("Misiones no disponibles");
            $("#controlsHeader").css("color", "red");
            $("#questImg").css("background-image", "url(img/timer.png)");
            $("#questStatus").html("Vuelve mas tarde para obtener mas misiones con " + npcName + ".");
            $("#questButton").html("Iniciar mision");
            $("#questButton").css("background-color", "rgba(90, 90, 90, 0.4)");
            $("#itemsRegard").html("");
            $("#moneyRegard").css("display", "none");
        }      
    }   

    bindQuestButton(itemsWeight)
}

function bindQuestButton(itemsWeight){
    $("#questButton").click(function() {
        console.log(playerCurrentWeight + itemsWeight)
        if(isOnQuest){
            if(currentQuestIsCompleted){
                if (playerCurrentWeight + itemsWeight <= playerCapacity){
                    if ((currentQuestInfo.questType == "pickup" && questItemCount > 0) || currentQuestInfo.questType == "delivery"){
                        completeQuest()
                    }                  
                }      
            }
        }else{
            if (canStartQuest){
                if(playerCurrentWeight + 1 <= playerCapacity){
                    startQuest()
                }      
            }      
        }   
    });
}

function startQuest(){
    isOnQuest = true;
    currentQuestIsCompleted = false;
    canStartQuest = false;
    playerCurrentWeight += 1;
    questItemCount++;
    setupQuestInfo(isOnQuest, currentQuestInfo, canStartQuest, currentQuestIsCompleted)
    $.post("http://esx_daily_quest/startQuest", JSON.stringify({
        level: level,
        currentXP: currentXP,
        isOnQuest: isOnQuest,
        currentQuestIsCompleted: currentQuestIsCompleted,
        currentQuestInfo: currentQuestInfo,
        canStartQuest: canStartQuest,
        npcName: npcName,
        storeItems: storeItems,
        vehicleOwned: vehicleOwned
    }));
    showWarning("mision iniciada");
}

function completeQuest(){
    isOnQuest = false;
    currentQuestIsCompleted = false;
    canStartQuest = false;
    if (level < 5){
        randomXP = Math.floor(Math.random() * 150) + 131;
        if (currentXP + randomXP >= lvlNeedXP[level - 1]){
            currentXP = lvlNeedXP[level - 1] - currentXP + randomXP;
            level++;
            if(level == 5){
                currentXP = 0;
            }     
        }else{
            currentXP += randomXP;
        }
    }   
    playerMoney += currentQuestInfo.money * (1 + (level / 10) * 2);
    for(var i = 0; i < currentQuestInfo.possibleItems.length; i++){
        playerCurrentWeight += currentQuestInfo.possibleItems[i].weight * currentQuestInfo.possibleItems[i].amount;
    }
    setupBasicInfo(npcName, npcSurname);
    setupQuestInfo(isOnQuest, currentQuestInfo, canStartQuest, currentQuestIsCompleted)
    setupStoreInfo(storeItems);
    showWarning("mision completada");   
    $.post("http://esx_daily_quest/completeQuest", JSON.stringify({
        level: level,
        currentXP: currentXP,
        isOnQuest: isOnQuest,
        currentQuestIsCompleted: currentQuestIsCompleted,
        currentQuestInfo: currentQuestInfo,
        canStartQuest: canStartQuest,
        npcName: npcName,
        storeItems: storeItems,
        vehicleOwned: vehicleOwned
    }));
    currentQuestInfo.currentQuest = 0;
}

function showWarning(message){
    $("#audioQuest").prop("volume", 0.2);
    $("#audioQuest")[0].play();
    $("#warning").css("opacity", 1);
    $("#warning").html(message);
    $("#warning").css("display", "flex");
    $("#warning").animate({opacity: 0}, 3501);
    setTimeout(function(){
        $("#warning").css("display", "none");
    }, 3500);   
}

function setupStoreInfo(storeItems) {
    $("#npcItemsContainer").html("");
    for(var i = 0; i < storeItems.length; i++){
        if (storeItems[i].type == "vehicle" && !vehicleOwned || storeItems[i].type != "vehicle"){
            $("#npcItemsContainer").append('<div class="item" id="item-' + i + '" style = "background-image: url(img/items/' + storeItems[i].name + '.png);"><div class="item-name">x' + storeItems[i].stockAmount + " - " + storeItems[i].label + '<br><hr><span style="color: red; font-size: 11pt; font-weight: bold;">' + storeItems[i].price + '€</span></div></div>');
            $('#item-' + i).data('item', storeItems[i]);   
            if (storeItems[i].levelNeed > level){
                $('#item-' + i).css("opacity", 0.4);
            } 
        }           
    }
    $(".item").click(function() {
        for (i = 0; i < storeItems.length; i++){
            $('#item-' + i).css("border-color", "lightgrey");    
        }
        selectedItem = $(this).data("item");
        if (selectedItem.levelNeed <= level && selectedItem.price < playerMoney && selectedItem.stockAmount > 0){
            $(this).css("border-color", "green");
            $("#npcItemsBuy").css("background-color", "rgba(0, 90, 0, 0.4)");
        }else{
            $(this).css("border-color", "red");
            $("#npcItemsBuy").css("background-color", "rgba(90, 90, 90, 0.5)");
        }     
    });
}

function setupWantedItemInfo(wantedItem){
    $("#wantedItemImg").css("background-image", 'url(img/items/' + wantedItem.name + '.png)');
    $("#wantedItemName").html(wantedItem.label);
    $("#wantedItemDescription").html(wantedItem.description);
    $("#wantedDescription").html("Encuentra objetos de interes para " + npcName + " y recibirás dinero y puntos de reputacion")
    if(npcWantedItemCount > 0){
        $("#wantedItemsGive").css("background-color", "rgba(0, 90, 0, 0.4)");
    }else{
        $("#wantedItemsGive").css("background-color", "rgba(90, 90, 90, 0.5)");
    }
}

function giveItemToNpc(){
    npcWantedItemCount--;
    itemXP = wantedItem.givenXP;
    if (level < 5){
        if (currentXP + itemXP >= lvlNeedXP[level - 1]){
            currentXP = -(lvlNeedXP[level - 1] - (currentXP + itemXP));
            level++;
            if(level == 5){
                currentXP = 0;
            }   
        }else{
            currentXP += itemXP;
        }
    }
    $.post("http://esx_daily_quest/giveWantedItem", JSON.stringify({
        level: level,
        currentXP: currentXP,
        isOnQuest: isOnQuest,
        currentQuestIsCompleted: currentQuestIsCompleted,
        currentQuestInfo: currentQuestInfo,
        canStartQuest: canStartQuest,
        npcName: npcName,
        storeItems: storeItems,
        vehicleOwned: vehicleOwned,
        wantedItemInfo: wantedItem
    }));  
    setupBasicInfo(npcName, npcSurname);
    setupWantedItemInfo(wantedItem)
}