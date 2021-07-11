var canStartFarm = false;
var haveCard = false;
var currentProcess = 0;
var secondsToProcess = 0;
var blocksTitle = "Procesado de Marihuana - "

window.addEventListener("message", function (event) {
    if (event.data.action == "openMenu") {
        canStartFarm = event.data.canTakeWeed;
        haveCard = event.data.haveCard;
        
        setupMenu();
        $("body, html").css("display", "flex");    
        $("#mainContainer").css("display", "block");          
    }

    if (event.data.action == "openProgressBar") {
        currentProcess = event.data.currentProcess;
        secondsToProcess = event.data.secondsToProcess;  
        $("#progress").css("width", "0%"); 
        $("#progressContainer").css("display", "block"); 
         $("body, html").css("display", "flex");
    }

    if (event.data.action == "updateProgress") {
        secondsToProcess = event.data.secondsToProcess; 
        currentProcess = event.data.currentProcess; 
        if(currentProcess == 0){
            $("#progress").css("width", (secondsToProcess / 600 * 100) + "%"); 
        }else{
            $("#progress").css("width", ((currentProcess * 30 + secondsToProcess) / 600 * 100) + "%");        
        }
        $("#progressHeader").html(blocksTitle + "fardos: " + currentProcess + "/20");
    }

    if (event.data.action == "closeProgressBar") {
        $("#close").click();
    }
});

function setupMenu(){
    if (haveCard){
        $("#costImg").css("border-color", "green"); 
        $("#costCount").css("color", "white"); 
    }else{
        $("#costImg").css("border-color", "red"); 
        $("#costCount").css("color", "red"); 
    }

    if (canStartFarm){
        $("#statusName").html("Plantacion lista"); 
        $("#description").html("Que pasa tronco, ha llegado al hora de cortar!<br><br> Algunas de las plantas ya estan preparadas para cosecharlas, asi que traeme esas jugosas ramitas y mi gente te preparara tu parte.<br><br>Espero que traigas la tarjeta que te dio john..."); 
        $("#statusName").css("color", "green"); 
        $("#statusImage").css("background-image", "url(img/check.png)"); 
        $("#statusImage").css("border-color", "green");
    }else{
        $("#statusName").html("Plantacion En Proceso"); 
        $("#description").html("Tio, hace poco vino otra persona y se llevo la ultima tanda que estaba lista, tendras que esperar a que la cosecha vuelva a estar disponible.<br><br>Vuelve mas tarde!"); 
        $("#statusName").css("color", "red"); 
        $("#statusImage").css("background-image", "url(img/timer.png)"); 
        $("#statusImage").css("border-color", "red");
    }    
}

$(document).ready(function () {   
    $("#init").click(function() {
        if(canStartFarm){
            if(haveCard){
                $("body, html").css("display", "none"); 
                $("#mainContainer").css("display", "none"); 
                $("#progressContainer").css("display", "none");
                $.post("http://esx_weed/startLabFarm", JSON.stringify({}));
            }else{
                $.post("http://esx_weed/errorMessage", JSON.stringify({message: "Debes tener una ~g~TARJETA DE MARIHUANA~w~ para eso, pueden obtenerse hablando con john..."}));
            }    
        }else{
            $.post("http://esx_weed/errorMessage", JSON.stringify({message: "Debes esperar a que la ~r~COSECHA~w~ vuelva a estar lista!"}));
        } 
    });

    $("#close").click(function() {
        $("body, html").css("display", "none"); 
        $("#mainContainer").css("display", "none"); 
        $("#progressContainer").css("display", "none");
        $.post("http://esx_weed/exit", JSON.stringify({}));
    });
});