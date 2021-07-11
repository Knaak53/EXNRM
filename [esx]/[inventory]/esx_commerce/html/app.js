var playerMoney = 0;
var playerInventory = [];
var targetMaxWeight = 0;
var targetCurrentWeight = 0;
var playerMaxWeight = 0;
var playerCurrentWeight = 0;
var targetName = "";
var playerMoney = 0;
var playerName = "";
var playerOffer = [];
var targetOffer = [];
var targetSrc = 0;
var targetConfirmed = false;
var playerAcepted = false;

window.addEventListener("message", function (event) {
    if (event.data.action == "get_invited") {
        $("body, html").css("display", "flex");   
        $("#invitationDialog").css("display", "block");
        $("#invitationDialogContent").html(event.data.sender_name + " te ha invitado a comerciar.");
        $("#yes").click(function() {
            $("body, html").css("display", "none");   
            $("#invitationDialog").css("display", "none");
            $.post("http://esx_commerce/accept_invite", JSON.stringify({
                sender_src: event.data.sender_src
            }));
        });
        $("#no").click(function() {
            $("body, html").css("display", "none");   
            $("#invitationDialog").css("display", "none");
            $.post("http://esx_commerce/decline_invite", JSON.stringify({
                sender_src: event.data.sender_src
            }));
        });
    }else if (event.data.action == "startCommerce"){
        playerMoney = event.data.playerMoney;
        playerInventory = event.data.inventory;
        targetMaxWeight = event.data.targetMaxWeight;
        targetCurrentWeight = event.data.targetCurrentWeight;
        playerMaxWeight = event.data.playerMaxWeight;
        playerCurrentWeight = event.data.playerCurrentWeight;
        targetName = event.data.targetName;
        playerName = event.data.playerName;
        playerOffer = [];          
        targetOffer = []; 
        targetWeaponCount = event.data.targetWeaponCount;
        targetSrc = event.data.targetSrc;
        setupInitialState(targetName, playerName);
        setupPlayerInventory(playerInventory);

        $("#commerceContainer").css("display", "flex");
        $("body, html").css("display", "flex");
    }else if (event.data.action == "updateTargetOffer"){
        targetOffer = event.data.targetOffer;
        updateTargetOffer()
    }else if (event.data.action == "cancelCommerce"){
        $("body, html").css("display", "none");
        $("#commerceContainer").css("display", "none");
        $.post("http://esx_commerce/exit", JSON.stringify({}));
    }else if (event.data.action == "targetAccept"){
        targetConfirmed = true;
        $("#thirdReady").css("background-image", "url(img/check.png)");
        $("#thirdReady").css("background-color", "rgba(0, 90, 0, 0.4)");
    }else if (event.data.action == "targetDecline"){
        targetConfirmed = false;
        $("#thirdReady").css("background-image", "url(img/cross.png)");
        $("#thirdReady").css("background-color", "rgba(40, 0, 0, 0.4)");
    }
});

function setupInitialState(){
    $("#thirdReady").css("background-image", "url(img/cross.png)");
    $("#playerReady").css("background-image", "url(img/cross.png)");
    $("#thirdReady").css("background-color", "rgba(40, 0, 0, 0.4)");
    $("#playerReady").css("background-color", "rgba(40, 0, 0, 0.4)");
}

function updateTargetOffer(){
    $("#thirdItems").html("");
    for(i = 0; i < targetOffer.length; i++){
        var count = 0;
        if (targetOffer[i].type == "account"){
            count = targetOffer[i].money;
        } 
        else if (targetOffer[i].type == "item"){ 
            count = targetOffer[i].count;
        }
        else{
            count = targetOffer[i].ammo;
        } 
        $("#thirdItems").append('<div class="item-little" id="targetOffer-' + i + '" style = "background-image: url(img/items/' + targetOffer[i].name + '.png);"><div class="item-name-little">' + targetOffer[i].label + '<br><hr>x' + count + '</div></div>');
    }
}

function setupPlayerInventory(items){
 var itemIndex = 0;
    var amountOfLastItemType = 0;
    $("#inventoryItems").html("");
    if(items.accounts != undefined){
        for (i = 0; i < items.accounts.length; i++){
            if(items.accounts[i].money > 0){
                $("#inventoryItems").append('<div class="item" id="item-' + itemIndex + '" style = "background-image: url(img/items/' + items.accounts[i].name + '.png);"><div class="item-name">' + items.accounts[i].label + '<br><hr>' + items.accounts[i].money + '€</div></div>');
                $('#item-' + itemIndex).data('item', items.accounts[i]);  
                itemIndex++;
            }   
        }
    }   
    if (itemIndex > 0){
       $("#inventoryItems").append('<div class="separator"></div>');
        amountOfLastItemType = itemIndex
    }
    if(items.items != undefined){
        for (i = 0; i < items.items.length; i++){
            if(items.items[i].count > 0 && items.items[i].canRemove){
                $("#inventoryItems").append('<div class="item" id="item-' + itemIndex + '" style = "background-image: url(img/items/' + items.items[i].name + '.png);"><div class="item-name">' + items.items[i].label + '<br><hr>x' + items.items[i].count + '</div></div>');
                $('#item-' + itemIndex).data('item', items.items[i]);  
                itemIndex++;
            }
        }
    }
    if (itemIndex > amountOfLastItemType && items.weapons.length > 0) {
        $("#inventoryItems").append('<div class="separator"></div>');
    }
    if(items.weapons != undefined){
        for (i = 0; i < items.weapons.length; i++){
            $("#inventoryItems").append('<div class="item" id="item-' + itemIndex + '" style = "background-image: url(img/items/' + items.weapons[i].name + '.png);"><div class="item-name">' + items.weapons[i].label + '<br><hr>mun:' + items.weapons[i].ammo + '</div></div>');
            $('#item-' + itemIndex).data('item', items.weapons[i]);  
            itemIndex++;
        }
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

function removePlayerOfferItem(itemData){
    var found = false;
    for(var i = 0; i < playerOffer.length; i++){
        if(playerOffer[i].name == itemData.name){
            if (itemData.type == "account"){
                if(playerOffer[i].money - parseInt($("#playerItemsInput").val()) > 0){
                    playerOffer[i].money -= parseInt($("#playerItemsInput").val());
                }else{
                    playerOffer.splice(i, 1)
                }           
            }else if (itemData.type == "item"){
                if(playerOffer[i].count - parseInt($("#playerItemsInput").val()) > 0){
                    playerOffer[i].count -= parseInt($("#playerItemsInput").val());
                }else{
                    playerOffer.splice(i, 1)
                }   
            }else{
                playerOffer.splice(i, 1)
            }
            found = true;
            break;
        }
    } 
    refreshPlayerInventoryItemMore(itemData);
    refreshPlayerOffer();
}

function refreshPlayerInventoryItemMore(itemData){
    if(itemData.type == "account"){
        for(var i = 0 ; i < playerInventory.accounts.length; i++){
            if (playerInventory.accounts[i].name == itemData.name){
                playerInventory.accounts[i].money += parseInt($("#playerItemsInput").val());
            }
        }
    }
    else if (itemData.type == "item"){
        for(var i = 0 ; i < playerInventory.items.length; i++){
            if (playerInventory.items[i].name == itemData.name){
                playerInventory.items[i].count += parseInt($("#playerItemsInput").val());
            }
        }
    }else{
        playerInventory.weapons.push({name: itemData.name, ammo: itemData.ammo, label: itemData.label, weight: itemData.weight, type: itemData.type, components: itemData.components});
    }
    setupPlayerInventory(playerInventory);
}

function addPlayerOfferItem(itemData){
    var found = false;
    for(var i = 0; i < playerOffer.length; i++){
        if(playerOffer[i].name == itemData.name){
            if (itemData.type == "account"){
                playerOffer[i].money += parseInt($("#playerItemsInput").val());         
            }else if (itemData.type == "item"){
                playerOffer[i].count += parseInt($("#playerItemsInput").val());
            }
            found = true;
            break;
        }
    }
    if(!found){
        if (itemData.type == "account"){
            playerOffer.push({name: itemData.name, money: parseInt($("#playerItemsInput").val()), label: itemData.label, weight: itemData.weight, type: itemData.type, offer: true});        
        }else if (itemData.type == "item"){
            playerOffer.push({name: itemData.name, count: parseInt($("#playerItemsInput").val()), label: itemData.label, weight: itemData.weight, type: itemData.type, offer: true});
        }else{
            playerOffer.push({name: itemData.name, ammo: itemData.ammo, label: itemData.label, weight: itemData.weight, type: itemData.type, components: itemData.components, offer: true});
        }      
    }   
    refreshPlayerInventoryItemLess(itemData);
    refreshPlayerOffer();
}

function refreshPlayerInventoryItemLess(itemData){
    if(itemData.type == "account"){
        for(var i = 0 ; i < playerInventory.accounts.length; i++){
            if (playerInventory.accounts[i].name == itemData.name){
                playerInventory.accounts[i].money -= parseInt($("#playerItemsInput").val());
            }
        }
    }
    else if (itemData.type == "item"){
        for(var i = 0 ; i < playerInventory.items.length; i++){
            if (playerInventory.items[i].name == itemData.name){
                playerInventory.items[i].count -= parseInt($("#playerItemsInput").val());
            }
        }
    }else{
        for(var i = 0 ; i < playerInventory.weapons.length; i++){
            if (playerInventory.weapons[i].name == itemData.name){
                playerInventory.weapons.splice(i, 1);
            }
        }
    }
    setupPlayerInventory(playerInventory);
}

function refreshPlayerOffer(){
    $("#playerItems").html("");
    for(i = 0; i < playerOffer.length; i++){
        var count = 0;
        if (playerOffer[i].type == "account"){
            count = playerOffer[i].money;
        } 
        else if (playerOffer[i].type == "item"){ 
            count = playerOffer[i].count;
        }
        else{
            count = playerOffer[i].ammo;  
        } 
        $("#playerItems").append('<div class="item-little" id="playerOffer-' + i + '" style = "background-image: url(img/items/' + playerOffer[i].name + '.png);"><div class="item-name-little">' + playerOffer[i].label + '<br><hr>x' + count + '</div></div>');
        $('#playerOffer-' + i).data('item', playerOffer[i]);
    }
    $.post("http://esx_commerce/refreshPlayerOffer", JSON.stringify({
        targetSrc: targetSrc,
        playerOffer: playerOffer
    }));

    $('.item-little').draggable({
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

function correctInputVal(itemData){
    if(itemData.type == "item"){
        return parseInt($("#playerItemsInput").val()) > 0 && parseInt($("#playerItemsInput").val()) <= itemData.count;
    }else if (itemData.type == "account"){
        return parseInt($("#playerItemsInput").val()) > 0 && parseInt($("#playerItemsInput").val()) <= itemData.money;
    }
    return true;
}

function canOfferItem(itemData){
    if(itemData.type == "item"){
        return ((targetCurrentWeight - getTargetOfferWeight()) + (itemData.weight * parseInt($("#playerItemsInput").val()))) <= targetMaxWeight;

    }else if (itemData.type == "weapon"){
        return targetWeaponCount < 3;
    }
    return true;  
}

function getTargetOfferWeight(){
    var weight = 0;
    for(var i = 0; i < targetOffer.length; i++){
        if(targetOffer[i].type == "item"){
           weight += targetOffer[i].weight * targetOffer[i].count; 
        }   
    }
    return weight;
}

$(document).ready(function () {
    $('#playerItems').droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            if(itemData.offer == undefined){
                if (canOfferItem(itemData) && correctInputVal(itemData)){
                    addPlayerOfferItem(itemData); 
                }
            }  
        }
    });

    $('#inventoryItems').droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");   
            if(itemData.offer != undefined){
                if (correctInputVal(itemData)){
                    removePlayerOfferItem(itemData);
                }      
            }  
        }
    });

    $("#decline").click(function() {
        $("body, html").css("display", "none");
        $("#commerceContainer").css("display", "none");
        $.post("http://esx_commerce/cancelCommerce", JSON.stringify({
            targetSrc: targetSrc
        }));
    });

    $("#accept").click(function() {
        playerAcepted = !playerAcepted;
        if (playerAcepted){
            $("#playerReady").css("background-color", "rgba(0, 90, 0, 0.4)");
            $("#playerReady").css("background-image", "url(img/check.png)");
            $.post("http://esx_commerce/playeraccept", JSON.stringify({
                targetSrc: targetSrc
            }));
        }else{
            $("#playerReady").css("background-color", "rgba(40, 0, 0, 0.4)");
            $("#playerReady").css("background-image", "url(img/cross.png)");
            $.post("http://esx_commerce/playerdecline", JSON.stringify({
                targetSrc: targetSrc
            }));
        }
    });
});

