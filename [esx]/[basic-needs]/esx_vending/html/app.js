var shopItems = [];
var selectedItem = undefined;

window.addEventListener("message", function (event) {
    if (event.data.action == "open") {
        shopItems = event.data.shopItems;
       
        $("#machineImg").css("background-image", "url(img/" + event.data.imgName + ".png)");
        machineSetup(shopItems);    
        $("body, html").css("display", "flex");   
    } 
});

$(document).ready(function () {

    $("#close").click(function() {
        $("body, html").css("display", "none");
        $.post("http://esx_vending/exit", JSON.stringify({}));
    });

    $("#buy").click(function() {
        if(selectedItem != undefined){
            $("body, html").css("display", "none");
            $.post("http://esx_vending/buyProduct", JSON.stringify({
                product: selectedItem
            }));
        }              
    });
});

function machineSetup(items){
    $("#productsContainer").html("");
    for (i = 0; i < items.length; i++){
        $("#productsContainer").append('<div class="item" id="item-' + i + '" style = "background-image: url(img/items/' + items[i].name + '.png);"><div class="item-name">' + items[i].label + '<br><hr><span style="color: green;">' + items[i].price + '€</span></div></div>');
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