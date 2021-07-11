var selectedItem = undefined;
var selectedComponent = undefined;
var weaponList = [];
var playerMoney = 0;

window.addEventListener("message", function (event) {
    if (event.data.action == "open") {
        $("body, html").css("display", "flex");   
        $("#mainContainer").css("display", "none"); 
        $("#menu").css("display", "block"); 
        weaponList = event.data.weapons;
        playerMoney = event.data.money;
    }
})


$(document).ready(function () {

    $("#almacen").click(function() {
        $("body, html").css("display", "none");
        $.post("http://esx_policejob/almacen", JSON.stringify({}));
    });

    $("#tienda").click(function() {
        $("#menu").css("display", "none");
        $("#mainContainer").css("display", "block"); 
        setupStore(weaponList);
    });

    $("#close").click(function() {
        $("body, html").css("display", "none");
        $.post("http://esx_policejob/exit", JSON.stringify({}));
    });

    $("#buy").click(function() {
        if(selectedItem != undefined){
            if (selectedItem.hasWeapon){
                if (selectedComponent != undefined && !selectedComponent.hasComponent){
                        $.post("http://esx_policejob/buyComponent", JSON.stringify({
                        weaponName: selectedItem.name,
                        component: selectedComponent
                    }));
                    if(playerMoney > selectedComponent.price){
                        selectedComponent.hasComponent = true;
                        setupStore(weaponList)
                    } 
                }                  
            }else{
               $.post("http://esx_policejob/buyWeapon", JSON.stringify({
                    weapon: selectedItem
                }));
               if(playerMoney > selectedItem.price){              
                    selectedItem.hasWeapon = true;
                    setupStore(weaponList)
               }   
            }    
        }              
    });
});

function setupStore(weapons){
    $("#weaponsPanel").html("");
    $("#componentsPanel").html("");
    if(weapons != undefined){
        for (i = 0; i < weapons.length; i++){
            $("#weaponsPanel").append('<div class="item" id="item-' + i + '" style = "background-image: url(img/items/' + weapons[i].name + '.png);"><div class="item-name">' + weapons[i].label + '<br><hr><span style="color: green;">' + weapons[i].price + '€</span></div></div>');
            $('#item-' + i).data('item', weapons[i]);   
            if (weapons[i].hasWeapon){
                $('#item-' + i).css("background-color", "rgba(0, 150, 0, 0.2)");
            } 
        }
    }   
    
    $(".item").click(function() {
        for (i = 0; i < weapons.length; i++){
            $('#item-' + i).css("border-color", "lightgrey");    
        }
        $(this).css("border-color", "green");
        selectedItem = $(this).data("item");
        if (!selectedItem.hasWeapon){
            $('#buy').css("background-color", "rgba(0, 120, 0, 0.4)");
        }else{
            $('#buy').css("background-color", "rgba(60, 60, 60, 0.4)");
        }
        $("#componentsPanel").html("");

        if (selectedItem.hasWeapon && selectedItem.components.length > 0) {
            var components = selectedItem.components;
            for (i = 0; i < components.length; i++){
                $("#componentsPanel").append('<div class="component" id="component-' + i + '" style = "background-image: url(img/items/' + components[i].name + '.png);"><div class="item-name">' + components[i].label + '<br><hr><span style="color: green;">' + components[i].price + '€</span></div></div>');
                $('#component-' + i).data('component', components[i]);   
                if (components[i].hasComponent){
                    $('#component-' + i).css("background-color", "rgba(0, 150, 0, 0.2)");
                } 
            }
        }else{
            $("#componentsPanel").html("")
        }
        $(".component").click(function() {
            for (i = 0; i < selectedItem.components.length; i++){
                $('#component-' + i).css("border-color", "lightgrey");    
            }
            $(this).css("border-color", "green");
            selectedComponent = $(this).data("component");
            if (!selectedComponent.hasComponent){
                $('#buy').css("background-color", "rgba(0, 120, 0, 0.4)");
            }else{
                $('#buy').css("background-color", "rgba(60, 60, 60, 0.4)");
            }
        });
    });
}