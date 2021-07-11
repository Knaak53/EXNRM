
$(document).ready(function(){
    window.addEventListener('message', function(event) {
    	if(event.data.action == "showRadar"){
    		$("#mainContainer").css("left", "13.25%");
    		$('#mainContainer').css('transform', 'scale(0.7)');
            $("#mapshadow").animate({opacity: 1}, 300);
    	}else if (event.data.action == "hideRadar"){
    		$("#mainContainer").css("left", "1%");
    		$('#mainContainer').css('transform', 'scale(1.0)');
            $("#mapshadow").animate({opacity: 0}, 300);
    	}
        else{
			var data = event.data;
	        $("#hunger").css("width", data.hunger + "%");
	        $("#thirst").css("width", data.thirst + "%");
            $("#hp").css("width", data.hp + "%");
            $("#armour").css("width", data.armour + "%");
            $("#stress").css("width", data.stress + "%");
    	}   
    });
});