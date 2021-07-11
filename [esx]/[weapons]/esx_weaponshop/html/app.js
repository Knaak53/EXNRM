window.addEventListener("message", function (event) {
    if (event.data.action == "show") {

        var weaponIndex = 0;
        var weaponList = [
            { name: 'WEAPON_PISTOL', label: "Pistola 9mm", text: "Pistola de corredera clasica, perfecta para defensa personal, dispara municion estandar de 9mm.", price: 800},
            { name: 'WEAPON_MACHETE', label: "Machete Jungle King", text: "El machete jungle king es la herramienta perfecta para abrirse paso en la espesura, se vende como arma para defensa personal.", price: 400},
            { name: 'WEAPON_KNIFE', label: "Cuchillo de supervivencia", text: "Un cuchillo de supervivencia con doble filo, antes incluia material de supervivencia en el mango, pero esa version se retiro del mercado.", price: 250},
            { name: 'WEAPON_BAT', label: "Bate de Baseball", text: "Debido a los recientes incidentes entre bandas callejeras, el gobierno de Caronte ha decidido considerar los bates como armas blancas.", price: 175}
        ]; 
        
        $("#weaponTitle").html(weaponList[weaponIndex].label);
        $("#weaponText").html(weaponList[weaponIndex].text);
        $("#price").html(weaponList[weaponIndex].price + "€");
        $("#weaponImage").css("background-image", "url(img/" + weaponList[weaponIndex].name + ".png)");

        $( "#arrowl" ).click(function() {
            //$("#audio")[0].pause();

            weaponIndex--;
            if(weaponIndex < 0){
                weaponIndex = 3;
            }

            $("#weaponTitle").html(weaponList[weaponIndex].label);
            $("#weaponText").html(weaponList[weaponIndex].text);
            $("#price").html(weaponList[weaponIndex].price + "€");
            $("#weaponImage").css("background-image", "url(img/" + weaponList[weaponIndex].name + ".png)");

            $("#audio").attr("src", "audio/" + weaponList[weaponIndex].name + ".mp3"); 
            $("#audio")[0].play();
        });

        $( "#arrowr" ).click(function() {
            $("#audio")[0].pause();

            weaponIndex++;
            if(weaponIndex > 3){
                weaponIndex = 0;
            }

            $("#weaponTitle").html(weaponList[weaponIndex].label);
            $("#weaponText").html(weaponList[weaponIndex].text);
            $("#price").html(weaponList[weaponIndex].price + "€");
            $("#weaponImage").css("background-image", "url(img/" + weaponList[weaponIndex].name + ".png)");

            $("#audio").attr("src", "audio/" + weaponList[weaponIndex].name + ".mp3"); 
            $("#audio")[0].play();
        });    

        $( "#cancel" ).click(function() {
            $("#audio")[0].pause();
            $.post("http://esx_weaponshop/close", JSON.stringify({
            }));
            
        });   

        $( "#submit" ).click(function() {
            $("#audio")[0].pause();
            $.post("http://esx_weaponshop/buy", JSON.stringify({
                weapon: weaponList[weaponIndex].name,
                price: weaponList[weaponIndex].price
            }));
        });    

        $("body, html").css("display", "flex");
        $("body, html").animate({opacity: 1}, 800);

        setTimeout(function () {
            $("#audio").prop("volume", 0.3);
            $("#audio").attr("src", "audio/WEAPON_PISTOL.mp3"); 
            $("#audio")[0].play();
        }, 800);

	} else {
		$("body, html").animate({opacity: 0}, 800);
        setTimeout(function(){
            $("body, html").css("display", "none");
        }, 1700);
        
	}
});