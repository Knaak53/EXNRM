var scrapItems = [];
var selectedItem = [];
var npcShortName = "";
var npcName = "";

window.addEventListener("message", function (event) {
    if (event.data.action == "open") {
    	selectedItem = [];
    	scrapItems = event.data.scrapItems;
        npcShortName = event.data.npcShortName;
        npcName = event.data.npcName;
    	setupItems(scrapItems);

        $("#itemHeader").html("oferta de " + npcShortName);
        $("#storeHeader").html(npcName);
        $("#npcImage").css("background-image", "url(img/" + npcShortName + ".png)");
        $("body, html").css("display", "flex");    
    } 
})

$(document).ready(function () {
    $("#close").click(function() {
        $("body, html").css("display", "none");
        $.post("http://esx_chatarra/exit", JSON.stringify({}));
    });

    $("#sellButton").click(function() {
        $.post("http://esx_chatarra/sellItems", JSON.stringify({
            name: selectedItem.name,
            price: selectedItem.price * selectedItem.count,
            label: selectedItem.label,
            count: selectedItem.count
        }));
        for (var i = 0; i < scrapItems.length; i++){
            if (selectedItem.name == scrapItems[i].name) {
                scrapItems[i].count = 0;
                break;
            }
        }
        $("#itemInfo").css("display", "none");
        setupItems(scrapItems);
        
    });
});

function setupItems(items){
	$("#itemsContainer").html("");

	for (i = 0; i < items.length; i++){
		$("#itemsContainer").append('<div class="item" id="item-' + i + '" style = "background-image: url(img/items/' + items[i].name + '.png);"><div class="item-name">' + items[i].label + '<br><hr>' + items[i].count + '</div></div>');
        $('#item-' + i).data('item', items[i]);  
        if(items[i].count > 0){
        	$('#item-' + i).css("opacity", 1);
        }else{
			$('#item-' + i).css("opacity", 0.4);
        }
    }

    $(".item").click(function() {
        for (i = 0; i < scrapItems.length; i++){
            $('#item-' + i).css("border-color", "lightgrey");    
        }
        selectedItem = $(this).data("item");
        if (selectedItem.count > 0){
        	$(this).css("border-color", "green");
            $("#itemName").html(selectedItem.label);
            $("#itemImg").css("background-image", "url(img/items/" + selectedItem.name + ".png)");
            $("#unitPrice").html("Precio unidad: " + selectedItem.price + "€");
            $("#count").html("cantidad: " + selectedItem.count);
            $("#totalPrice").html(selectedItem.price * selectedItem.count + "€");
        	$("#itemInfo").css("display", "block");
        }else{
        	$("#itemInfo").css("display", "none");
        }    
    });
}