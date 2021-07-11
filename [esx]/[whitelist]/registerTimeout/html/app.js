window.addEventListener("message", function (event) {
    if (event.data.action == "display") {
        
        $("#container").css("display", "block")
        $("#days").html(event.data.historyTimeout)
	}
});