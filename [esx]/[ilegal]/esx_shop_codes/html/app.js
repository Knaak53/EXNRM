var playerMoney = 0;
var price = 0;

var textLength = 0;
var requiredText = 'Escriba /ayuda para ver la lista de comandos\n\nC:>';
var currentLine = "";

var onPasswordMenu = false;

var currentCode = "";

var itemsList = [
    "Agua",
    "Coca Cola",
    "Fanta",
    "7up",
    "Aquarius",
    "Monster",
    "Pan",
    "Snickers",
    "Cheesebows",
    "Lays",
    "Oreo",
    "Hamburguesa",
    "Pizza",
    "Taco mexicano",
    "Kebab",
    "Lasaña",
    "Vodka",
    "Whisky",
    "Heineken",
    "Tequila",
    "Ron",
    "Vodka Bathory",
    "Donut Blanco",
    "Donut Choco",
    "Donut",
    "Berlina Crema",
    "Berlina Choco",
    "Manzana",
    "Platano",
    "Mango",
    "Naranja",
    "Melocoton"
];

itemPrices = [
      5,
      7,
      8,
      9,
      10,
      12,
      4,
      5,
      7,
      9,
      11,
      8,
      10,
      11,
      13,
      15,
      21,
      24,
      11,
      18,
      23,
      26,
      6,
      6,
      5,
      8,
      8,
      5,
      4,
      8,
      5,
      6
];

window.addEventListener("message", function (event) {
    if (event.data.action == "openStore") {
        playerMoney = event.data.playerMoney;
        price = event.data.price;
        
        $("#sellContainer").css("display", "block");
        $("body, html").css("display", "flex");            
    }
    if (event.data.action == "lookCode"){
        $("#lookCode").html(event.data.playerCode);
        $("#lookContainer").css("display", "flex");
        $("body, html").css("display", "flex");  

    }

    if (event.data.action == "computer"){
        currentCode = event.data.currentCode;
        $('#console').val("Escriba /ayuda para ver la lista de comandos\n\nC:>");
        textLength = $('#console').val().length;
        $("#computerContainer").css("display", "block");
        $("body, html").css("display", "flex");
        $("#console").focus();
    }
});

jQuery.fn.lockCursor = function() {
    return this.each(function() { //return the function for each object
        if (this.setSelectionRange) { //check if function is available
            var len = $(this).val().length * 2; //avoid problems with carriage returns in text
            this.setSelectionRange(len, len);
        } else {
            $(this).val($(this).val()); //replace content with itself
       }
    });
};

function help(line){
    var helpText = "\n\nComandos disponibles:\n\n/inventario_tienda\n/registro_facturacion\n/pedidos_recientes\n/control_caja_fuerte\n/salir\n";
    requiredText += line + helpText + "\nC:>";
    $("#console").val(requiredText)
}

function inventory(line){
    var finalInfo = ""
    for(var i = 0; i < itemsList.length; i++){
        finalInfo += "\n|--------------------------------------------------|\n|" + itemsList[i];
        for(var j = 0; j < 35 - itemsList[i].length; j++){
            finalInfo += " ";
        } 
        var randomItemCount = Math.floor(Math.random() * 70) + 40;
        finalInfo += "|" + randomItemCount;
        for (var k = 0; k < 14 - randomItemCount.toString().length; k++){
            finalInfo += " ";
        }
        finalInfo += "|\n|--------------------------------------------------|";
    }
    requiredText += line + finalInfo + "\nC:>";
    $("#console").val(requiredText);
}

function facturation(line){
    var finalInfo = ""
    for(var i = 0; i < itemsList.length; i++){
        finalInfo += "\n|--------------------------------------------------|\n|art:" + itemsList[i];
        for(var j = 0; j < 20 - itemsList[i].length; j++){
            finalInfo += " ";
        } 
        var price = "|precio:" + itemPrices[i];
        finalInfo += price;
        for (var v = 0; v < 12 - price.length; v++){
            finalInfo += " ";
        }        
        var randomItemCount = Math.floor(Math.random() * 85) + 30;
        var count = "|cant:" + randomItemCount;
        finalInfo += count
        for (var k = 0; k < 14 - count.length; k++){
            finalInfo += " ";
        }
        finalInfo += "|\n|--------------------------------------------------|";
    }
    requiredText += line + finalInfo + "\nC:>";
    $("#console").val(requiredText);
}

function pedidos(line){
    var finalInfo = ""
    for(var i = 0; i < itemsList.length; i++){
        finalInfo += "\n|--------------------------------------------------|\n|prod:" + itemsList[i];
        for(var j = 0; j < 20 - itemsList[i].length; j++){
            finalInfo += " ";
        } 
        var price = "|precio ud:" + Math.round(itemPrices[i] * 0.7);
        finalInfo += price;
        for (var v = 0; v < 14 - price.length; v++){
            finalInfo += " ";
        }        
        var randomItemCount = Math.floor(Math.random() * 85) + 30;
        var count = "|cant:" + randomItemCount;
        finalInfo += count
        for (var k = 0; k < 11 - count.length; k++){
            finalInfo += " ";
        }
        finalInfo += "|\n|--------------------------------------------------|"
    }
    requiredText += line + finalInfo + "\nC:>";
    $("#console").val(requiredText);
}

function cajaFuerte(line){
    onPasswordMenu = true;
    requiredText += line + "\n\nIntroduce clave de seguridad:\n\nC:>";
    $("#console").val(requiredText);
}

function checkForCommands(line){
    if (line != ""){
        if(line == "/ayuda"){
            help(line);
        }else if (line == "/inventario_tienda"){
            inventory(line);
        }else if (line == "/registro_facturacion"){
            facturation(line)
        }else if (line == "/pedidos_recientes"){
            pedidos(line)
        }else if (line == "/control_caja_fuerte"){
            cajaFuerte(line)
        }else if(line == "/salir"){
            $("#exit").click();
        }else{
            requiredText += line + "\n\nComando no reconocido por el sistema, escriba /ayuda para ver la lista de comandos\n\nC:>";
            $("#console").val(requiredText);
        }
    }else{
        requiredText += line + "\nC:>";
        $("#console").val(requiredText);
    } 
}

function checkForPassword(line){
    if(line == currentCode){
        requiredText += line + "\n\nClave de seguridad correcta, abriendo caja fuerte...";
        $("#console").val(requiredText);
        setTimeout(function(){ 
            $.post("http://esx_shop_codes/stealComputer", JSON.stringify({}));
            $("#exit").click();
        }, 3000);
        
    }else if(line == "/volver"){
        onPasswordMenu = false;
        requiredText += line + "\n\nSaliendo del software de control de la caja fuerte... Volviendo al menu principal\n\nEscriba /ayuda para ver la lista de comandos\n\nC:>";
        $("#console").val(requiredText);
    }else{
        requiredText += line + "\n\nClave de Seguridad incorrecta, introduce una nueva clave de seguridad o teclea /volver para volver al menu principal\n\nC:>";
        $("#console").val(requiredText);
    }
}

$(document).ready(function () {
    
    $('#console').on('input',function() {
        if (String($(this).val()).indexOf(requiredText) == -1) {
            $(this).val(requiredText);
        }
    });

    $('#console').keypress(function(event){       
        if ( event.which == 13 ) {
            event.preventDefault();
            if(onPasswordMenu){
                checkForPassword($(this).val().substring(requiredText.length, $(this).val().length));
                $('#console').scrollTop($('#console').get(0).scrollHeight); 
            }else{
                checkForCommands($(this).val().substring(requiredText.length, $(this).val().length));
                $('#console').scrollTop($('#console').get(0).scrollHeight); 
            }        
        }
        $(this).lockCursor();
    });

    $("#exit").click(function() {
        requiredText = 'Escriba /ayuda para ver la lista de comandos\n\nC:>';
        onPasswordMenu = false;
        $("body, html").css("display", "none");
        $("#sellContainer").css("display", "none");
        $("#lookContainer").css("display", "none");
        $("#computerContainer").css("display", "none");
        $.post("http://esx_shop_codes/exit", JSON.stringify({}));
    });

     $("#closeLook").click(function() {
        $("#exit").click();
    });

    $("#buy").click(function() {
        if (playerMoney >= price){
            $.post("http://esx_shop_codes/buy", JSON.stringify({price: price}));
            $("#exit").click();
        }else{
            $.post("http://esx_shop_codes/noMoney", JSON.stringify({}));
        }
    });
})