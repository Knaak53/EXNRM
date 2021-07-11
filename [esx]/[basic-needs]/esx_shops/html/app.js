window.addEventListener("message", function (event) {
    if (event.data.action == "shelf") {
        $("#storeMenu").css("display", "flex");
        $("#container").css("display", "block");
        $("#controls").css("display", "block");
        $("body, html").css("display", "flex");
        
        inventorySetup(event.data.items)

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
    } else if (event.data.action == "cashier") {
        $("#storeMenu").css("display", "flex");
        $("body, html").css("display", "flex");
        $("#cashier").css("display", "block");
        pintarFactura(event.data.items, event.data.total)
    } else if(event.data.action == "pay"){
        $("#storeMenu").css("display", "flex");
        $("body, html").css("display", "flex");
        $("#pay").css("display", "block");
    } else if(event.data.action == "startRobbery"){
        $("#robberyUi").css("display", "flex");
        $("#startRobberyDialog").css("display", "block");
        $("body, html").css("display", "flex");
    } else if (event.data.action == "npcLimitBar"){
        $("#robberyUi").css("display", "flex");
        $("#controls").css("display", "none");
        $("#npcLimitHeader").html(event.data.title);
        $("#npcLimitBarContainer").css("display", "block");
        $("body, html").css("display", "flex");
    } else if (event.data.action == "updateLimitBar"){
        updateLimitBar(event.data.current, event.data.max)
    }else if (event.data.action == "hideNpcLimitBar"){
        $("#npcLimitBarProcess").css("width", "100%");
        setTimeout(function(){ 
            closeAll(); 
            $("#npcLimitBarProcess").css("width", "0%"); 
        }, 1000);
        
    }

})

function updateLimitBar(currentStatus, max){
    $("#npcLimitBarProcess").css("width", (currentStatus / max * 100) + "%");
}

$(document).ready(function () {
    $('#carrito').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            $.post("http://esx_shops/addProduct", JSON.stringify({
                item: itemData
            }));
        }
    });

    $("#exit").click(function() {
        $("#container").css("display", "none");
        $("#controls").css("display", "none");
        $("#cashier").css("display", "none");
        $("#pay").css("display", "none");
        $("body, html").css("display", "none");
        $("#storeMenu").css("display", "none");
        $("#robberyUi").css("display", "none");
        $("#startRobberyDialog").css("display", "none");
        $("#npcLimitBarContainer").css("display", "none");
        $.post("http://esx_shops/exit", JSON.stringify({
        }));
    });

    $("#confirm").click(function() {
        closeAll()
        $.post("http://esx_shops/confirm", JSON.stringify({}));
    });

    $("#cash").click(function() {
        closeAll()
        $.post("http://esx_shops/pay", JSON.stringify({method: "money"}));
    });

    $("#card").click(function() {
        closeAll()
        $.post("http://esx_shops/pay", JSON.stringify({method: "bank"}));
    });

    $(".cancel").click(function() {
        $("#exit").click();
    });

    $("#no").click(function() {
        $("#exit").click();
    });

    $("#yes").click(function() {
        closeAll()
        $.post("http://esx_shops/startRobbery", JSON.stringify({}));
    });
});

function closeAll(){
    $("#container").css("display", "none");
    $("#controls").css("display", "none");
    $("#cashier").css("display", "none");
    $("#pay").css("display", "none");
    $("body, html").css("display", "none");
    $("#storeMenu").css("display", "none");
    $("#robberyUi").css("display", "none");
    $("#startRobberyDialog").css("display", "none");
    $("#npcLimitBarContainer").css("display", "none");
}

function pintarFactura(items, total){
    $("#tablecontainer").html("");
    $("#tablecontainer").append('<div id="rowcabecera"><div class="label">Producto</div><div class="amount">Cantidad</div><div class="priceLabel">Precio</div></div>');
    $.each(items, function (index, item) {
        $("#tablecontainer").append('<div class="rowFactura"><div class="label">' + item.label + '</div><div class="amount">' + item.amount + '</div><div class="price">' + item.price * item.amount + '€</div></div>');
    });
    $("#tablecontainer").append('<div id="rowtotal"><div class="totalspace"></div><div class="total">Total: <span style="color: green;"> ' + total + ' €</span></div></div>');

}

function inventorySetup(items) {
    $("#rowUp").html("");
    $("#rowDown").html("");
    $.each(items, function (index, item) {
        if(index < 3){
            $("#rowUp").append('<div class="product"><div id="item-' + index + '" class="item" style = "background-image: url(\'img/' + item.item + '.png\')">' +
            '<div class="item-name">' + item.realLabel + '</div><div class="itemprice">' + item.price + '€</div> </div></div>');
            $('#item-' + index).data('item', item);
        }else{
            $("#rowDown").append('<div class="product"><div id="item-' + index + '" class="item" style = "background-image: url(\'img/' + item.item + '.png\')">' +
            '<div class="item-name">' + item.realLabel + '</div> <div class="itemprice">' + item.price + '€</div></div></div>');
            $('#item-' + index).data('item', item);
        }     
    });
}















