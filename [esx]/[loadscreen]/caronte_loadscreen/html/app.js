var playingSound = true;

var tips = [
	"Hay que mostrar total respeto hacia los NPCs que nos entregan trabajos, recordemos que estamos realizando actos ilegales y la discreción debe ser maxima",
	"Para interactuar con el mundo, manten pulsado \"B\" y selecciona cualquier persona, vehiculo u objeto del entorno pulsando click derecho",
	"Para usar los badulakes, interactua con las estanterias de la tienda para añadir productos al carrito y habla con el dependiente para pagar"
];

$(document).ready(function() { 

	setupLoadingDots(1);
	setupRandomTips(Math.floor(Math.random() * (tips.length) - 1), 1);

	$( "#songMute" ).click(function() {
		if(playingSound){
			playingSound = false;
			$("#bgSong").prop("volume", 0.0);
			$("#songMute").removeClass("muteGlow");
			$("#songMute").css("color", "rgba(120, 120, 120, 0.3)");
		}else{
			playingSound = true;
			$("#bgSong").prop("volume", 0.1);
			$("#songMute").addClass("muteGlow");
			$("#songMute").css("color", "white");
		}
	});
});

$(document).keydown(function( event ) {
  if ( event.which == 32 ) {
    event.preventDefault();
    if(playingSound){
		playingSound = false;
		$("#bgSong").prop("volume", 0.0);
		$("#songMute").removeClass("muteGlow");
		$("#songMute").css("color", "rgba(120, 120, 120, 0.3)");
	}else{
		playingSound = true;
		$("#bgSong").prop("volume", 0.1);
		$("#songMute").addClass("muteGlow");
		$("#songMute").css("color", "white");
	}
  }
});

function setupRandomTips(tipIndex, prevoiusIndex){
	while(tipIndex == prevoiusIndex) {tipIndex = Math.floor(Math.random() * (tips.length));}
	$("#tipSpan").html(tips[tipIndex])
	$("#tipSpan").animate({opacity: "1"}, 750);
	setTimeout(function(){
		setTimeout(function(){
			$("#tipSpan").animate({opacity: "0"}, 750);
			setTimeout(function(){
				setupRandomTips(Math.floor(Math.random() * (tips.length)), tipIndex);
			}, 750);
		}, 5000);
	}, 750);
}

function setupLoadingDots(dotsCount){
	setTimeout(function(){
		var dotsString = "";
		for(var i = 0; i < dotsCount; i++){
			dotsString += ". ";
		}
		$( "#loading" ).html("Cargando " + dotsString);
		if (dotsCount == 3){
			dotsCount = 1
		}else{
			dotsCount++;
		}
		setupLoadingDots(dotsCount);
	}, 500);
}
