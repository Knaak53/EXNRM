window.addEventListener("message", function (event) {
    if (event.data.action == "open") {
        $("body, html").css("display", "block");   
        console.log(event.data.value);
        $("#extraFare").html(event.data.value + ".0");
    }else{
        $("body, html").css("display", "none");
    }
})