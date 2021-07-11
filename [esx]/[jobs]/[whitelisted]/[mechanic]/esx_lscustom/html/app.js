var piecesPrice = 0;
var handPrice = 0;
var benefits = 0;

window.addEventListener("message", function (event) {
    if (event.data.action == "open") {
        piecesPrice = 0;
        handPrice = 0;
        benefits = 0;
        $("#piecesRow").html("Coste piezas: " + piecesPrice + "€"); 
        $("#handRow").html("Mano de obra: " + handPrice + "€"); 
        $("#profitRow").html("Beneficio: " + benefits + "€");
         $("#totalRow").html("Total a facturar: " + (piecesPrice + benefits + handPrice) + "€");

        $("body, html").css("display", "block");         
    }else if (event.data.action == "addMod"){
        piecesPrice += event.data.piecesPrice;
        handPrice = Math.round(piecesPrice * 0.15);
        benefits = Math.round(piecesPrice * 0.20);
        $("#piecesRow").html("Coste piezas: " + piecesPrice + "€"); 
        $("#handRow").html("Mano de obra: " + handPrice + "€"); 
        $("#profitRow").html("Beneficio: " + benefits + "€"); 
        $("#totalRow").html("Total a facturar: " + (piecesPrice + benefits + handPrice) + "€");
    }else{
        piecesPrice = 0;
        handPrice = 0;
        benefits = 0;
        $("body, html").css("display", "none");  
    }
})