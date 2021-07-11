var weedCount = 0;
var cokeCount = 0;
var methCount = 0;

window.addEventListener("message", function (event) {
    if (event.data.action == "openMenu") {
        weedCount = event.data.weedCount;
        cokeCount = event.data.cokeCount;
        methCount = event.data.methCount;
        setupMenu();
        $("body, html").css("display", "block");    
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
    if(weedCount == 0){
        $("#weedContainer").css("opacity", 0.2);
    }else{
        $("#weedContainer").css("opacity", 1);
    }
    if(cokeCount == 0){
        $("#cokeContainer").css("opacity", 0.2);
    }else{
        $("#cokeContainer").css("opacity", 1);
    }
    if(methCount == 0){
        $("#methContainer").css("opacity", 0.2);
    }else{
        $("#methContainer").css("opacity", 1);
    }
}

$(document).ready(function () {   
    $("#weedContainer").click(function() {
        if(weedCount > 0){           
            $.post("http://esx_sell_drugs/sellDrug", JSON.stringify({drug: "weed"}));
            $("#closeButton").click();
        } 
    });

    $("#cokeContainer").click(function() {
        if(cokeCount > 0){           
            $.post("http://esx_sell_drugs/sellDrug", JSON.stringify({drug: "coke"}));
            $("#closeButton").click();
        } 
    });

    $("#methContainer").click(function() {
        if(methCount > 0){           
            $.post("http://esx_sell_drugs/sellDrug", JSON.stringify({drug: "meth"}));
            $("#closeButton").click();
        } 
    });

    $("#closeButton").click(function() {
        $("body, html").css("display", "none"); 
        $("#mainContainer").css("display", "none"); 
        $("#progressContainer").css("display", "none");
        $.post("http://esx_sell_drugs/exit", JSON.stringify({}));
    });
});