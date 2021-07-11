var shopItems = [];
var selectedItem = undefined;
var active = false;
var planInfo = [];
var playerMoney = 0;
var playerCurrentWeight = 0;
var playerMaxWeight = 0;
var planSelected = 0;

var noMoneyMessage = "~r~NO TIENES SUFICIENTE DINERO!";

window.addEventListener("message", function (event) {
    if (event.data.action == "openGym") {
        shopItems = event.data.storeItems;
       	active = event.data.active;
       	planInfo = event.data.planInfo;
       	playerMoney = event.data.playerMoney;
       	playerCurrentWeight = event.data.playerCurrentWeight;
       	playerMaxWeight = event.data.playerMaxWeight;
       	plan = event.data.plan;
       	setupMembership(active, planInfo);
        storeSetup(shopItems);    
        $("body, html").css("display", "flex");   
    } 
});

$(document).ready(function () {

    $("#closeButton").click(function() {
        $("body, html").css("display", "none");
        $.post("http://esx_gym/exit", JSON.stringify({}));
    });

    $("#arrowr").click(function() {
    	if (!active) {
    		planSelected++;
	        if (planSelected > 2) {planSelected = 0;}
	        setupMembership(active, planInfo);
    	}
    });

    $("#arrowl").click(function() {
    	if (!active){
			planSelected--;
	        if (planSelected < 0) {planSelected = 2;}
	        setupMembership(active, planInfo);
    	}  
    });

    $("#payMember").click(function() {
        if (!active) {
        	if (playerMoney >= planInfo[planSelected].price){
        		$.post("http://esx_gym/buyMember", JSON.stringify({
	                plan: planInfo[planSelected]
	            }));
	            active = true;
	            setupMembership(active, planInfo);
	            storeSetup(shopItems); 
        	}else{
        		$.post("http://esx_gym/errorMessage", JSON.stringify({
	                message: noMoneyMessage
	            }));
        	}
        }
    });

    $("#buyButton").click(function() {
        if (active) {
        	if (playerMoney >= planInfo[planSelected].price ){
        		if (parseInt($("#itemsInput").val()) != undefined && parseInt($("#itemsInput").val()) > 0){	
        			if (playerCurrentWeight + (selectedItem.weight * parseInt($("#itemsInput").val())) <= playerMaxWeight){
        				$.post("http://esx_gym/buyItem", JSON.stringify({
			                item: {name: selectedItem.name, 
			                label: selectedItem.label, 
			                price: Math.round(selectedItem.price * parseInt($("#itemsInput").val())), 
			                count: parseInt($("#itemsInput").val())}
			            }));
			            playerCurrentWeight += selectedItem.weight * parseInt($("#itemsInput").val());
			            playerMoney -= Math.round(selectedItem.price * parseInt($("#itemsInput").val()));
        			}else{
        				$.post("http://esx_gym/errorMessage", JSON.stringify({
			                message: "~r~NO PUEDES LLEVAR TANTO PESO!"
			            }));
        			}
        		}else{
        			$.post("http://esx_gym/errorMessage", JSON.stringify({
		                message: "~r~DEBES SELECCIONAR UNA CANTIDAD!"
		            }));
        		}
        	}else{
        		$.post("http://esx_gym/errorMessage", JSON.stringify({
	                message: noMoneyMessage
	            }));
        	}
        }
    });
});

function setupMembership(active, planInfo){
	$("#card").css("background-image", "url(img/" + planSelected + ".png)");
	$("#duration").html(planInfo[planSelected].durationInDays + " Dias");
	$("#price").html(planInfo[planSelected].price + "€");
	if (active) {
		$("#subscriptionText").html("Activa");
		$("#subscriptionDescription").html("Actualmente tienes una suscripcion activa, puedes usar el gimnasio y la tienda libremente.");
		$("#subscriptionText").css("color", "green");	
		$("#payMember").css("background-color", "rgba(90, 90, 90, 0.4)");
		$("#subscriptionImage").css("background-image", "url(img/check.png)");
		$("#memberCardContainer").css("opacity", 0.3);
		$("#memberButtonContainer").css("opacity", 0.3);
        $("#card").css("background-image", "url(img/" + planSelected + ".png)");
	}else{
		$("#subscriptionText").html("inactiva");
		$("#subscriptionDescription").html("Actualmente no tienes una suscripcion activa o tu suscripcion ha caducado.");
		$("#subscriptionText").css("color", "red");
		$("#payMember").css("background-color", "rgba(0, 90, 0, 0.4)");
		$("#subscriptionImage").css("background-image", "url(img/cross.png)");
		$("#memberCardContainer").css("opacity", 1);
		$("#memberButtonContainer").css("opacity", 1);
        $("#card").css("background-image", "url(img/" + planSelected + ".png)");
	}
}

function storeSetup(items){
    $("#itemsContainer").html("");
    for (i = 0; i < items.length; i++){
        $("#itemsContainer").append('<div class="item" id="item-' + i + '" style = "background-image: url(img/' + items[i].name + '.png);"><div class="item-name">' + items[i].label + '<br><hr><span style="color: green;">' + items[i].price + '€</span></div></div>');
        $('#item-' + i).data('item', items[i]);   
    }

    if (active) {
    	$("#storeContainer").css("opacity", 1);
    	$("#buyButton").css("background-color", "rgba(0, 90, 0, 0.4)");
    }else{
    	$("#storeContainer").css("opacity", 0.3);
    	$("#buyButton").css("background-color", "rgba(90, 90, 90, 0.4)");
    }

    $(".item").click(function() {
    	if (active){
    		for (i = 0; i < items.length; i++){
	            $('#item-' + i).css("border-color", "lightgrey");    
	        }
	        $(this).css("border-color", "green");
	        selectedItem = $(this).data("item");
    	}      
    });
}