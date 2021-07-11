var shopItems = [];
var selectedItem = undefined;
var playerMoney = 0;

window.addEventListener("message", function (event) {
    if (event.data.action == "open") {
        shopItems = event.data.items;
        playerMoney = event.data.playerMoney;
        $("#headerText").html(event.data.title);
        shopSetup(shopItems);  
        $("body, html").css("display", "flex"); 
        $("#amount").val("1");  
    } 

    if (event.data.action == "updateMoney") {
        playerMoney -= event.data.playerMoney;
        shopSetup(shopItems);  
    } 
});

$(document).ready(function () {
    $("#headerCross").click(function() {
        $("body, html").css("display", "none");
        $.post("http://generic_shop_creator/exit", JSON.stringify({}));
    });

    $("#buy").click(function() {
        if(selectedItem != undefined){
            $.post("http://generic_shop_creator/buyProduct", JSON.stringify({
                product: selectedItem,
                amount: parseInt($("#amount").val(), 10)
            }));
        }              
    });
});

function shopSetup(items){
    $("#money").html('Dinero: <span style="color: green;">' + playerMoney + '€</span>' );
    $("#itemsContainer").html("");
    for (i = 0; i < items.length; i++){
        $("#itemsContainer").append('<div class="item" id="item-' + i + '" style = "background-image: url(img/items/' + items[i].name + '.png);"><div class="item-name">' + items[i].label + '<br><hr><span style="color: green;">' + items[i].price + '€</span></div></div>');
        $('#item-' + i).data('item', items[i]);   
    }

    $(".item").click(function() {
        for (i = 0; i < items.length; i++){
            $('#item-' + i).css("border-color", "lightgrey");    
        }
        $(this).css("border-color", "green");
        selectedItem = $(this).data("item");
    });
}