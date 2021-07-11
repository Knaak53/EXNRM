var shopItems = [];
var selectedItem = undefined;

window.addEventListener("message", function (event) {
    if (event.data.action == "open") {
        shopItems = event.data.shopItems;
        bikesSetup(shopItems);
        $("body, html").css("display", "flex");   
    } 
});

$(document).ready(function () {

    $("#close").click(function() {
        $("body, html").css("display", "none");
        $.post("http://esx_bike_rental/exit", JSON.stringify({}));
    });

    $("#rent").click(function() {
        if(selectedItem != undefined){
            $("body, html").css("display", "none");
            $.post("http://esx_bike_rental/rentBike", JSON.stringify({
                bike: selectedItem
            }));
        }              
    });
});

function bikesSetup(items){
    $("#bikes").html("");
    for (i = 0; i < items.length; i++){
        $("#bikes").append('<div class="item" id="item-' + i + '" style = "background-image: url(img/' + items[i].name + '.png);"><div class="item-name">' + items[i].label + '<br><hr><span style="color: green;">' + items[i].price + '€</span></div></div>');
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