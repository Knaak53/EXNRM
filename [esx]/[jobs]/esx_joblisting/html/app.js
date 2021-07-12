window.addEventListener("message", function (event) {
    if (event.data.action == "show") {

        var jobIndex = -1;
        var jobList = [
            { 
                name: 'garbage', 
                label: "Servicio de basuras de CityName", 
                text: "Acaba de llegarnos una vacante para el servicio de recogida de basuras de la ciudad. El puesto no cubre las zonas de Sandy Shore ni Paleto Bay", 
                requeriments: []
            },
            { 
                name: 'delivery', 
                label: "Proveedor de tiendas locales", 
                text: "La empresa que provee de alimentos a las tiendas locales necesita un nuevo repartidor, cubrirás la zona mas cercana al centro de la ciudad.",
                requeriments: [          
                    "faggio3"
                ],
                optionals: [
                    "mule2",
                    "rumpo3"
                ]
            },
            { 
                name: 'bus', 
                label: "Servicio de transportes de CityName", 
                text: "La ciudad necesita conductores profesionales de autobuses para las lineas de: Ciudad de CityName, Sandy Shores y Paleto Bay.",
                requeriments: [
                    "truck"
                ]
            },
            { 
                name: 'works', 
                label: "Mantenimiento de la ciudad", 
                text: "El Ayuntamiento de la ciudad necesita técnicos de mantenimiento para trabajos de electricidad, alumbrado público y mobiliario urbano.",
                requeriments: [
                    "workstool"
                ]
            },
            { 
                name: 'woodcutter', 
                label: "Industria maderera de CityName", 
                text: "Con la invención de los superfertilizantes, los leñadores del vivero de CityName no dan a basto para recoger madera, hay varias plazas disponibles para este empleo.",
                requeriments: []
            },
            { 
                name: 'miner', 
                label: "CityName Mining S.A", 
                text: "Un nuevo complejo minero ha abierto en el norte y se requieren oficiales especialistas en mineria, draga, fundición y forja del metal.",
                requeriments: [
                    "pickaxe",
                    "rumpo3"
                ]
            },
            { 
                name: 'gopostal', 
                label: "Servicio de correos de CityName", 
                text: "El servicio postal municipal necesita repartidores debido al auge de las compras online para hacer llegar los paquetes a tiempo a los ciudadanos.",
                requeriments: [],
                optionals: [
                    "boxville2"
                ]
            }
        ];
        
        $("#jobTitle").html("Oficina de empleo de CityName");
        $("#jobText").html("Sea bienvenido a la oficina de empleo de la ciudad de CityName. Utilice nuestra app para navegar por los puestos vacantes ofrecidos en la ciudad.");
        $("#jobImage").css("background-image", "url(img/welcome.png)");

        $( "#arrowl" ).click(function() {
            //$("#audio")[0].pause();

            jobIndex--;
            if(jobIndex < 0){
                jobIndex = 6;
            }

            $("#jobTitle").html(jobList[jobIndex].label);
            $("#jobImage").css("background-image", "url(img/" + jobList[jobIndex].name + ".png)");
            $("#reqCont").html("");
            for(var i = 0; i < jobList[jobIndex].requeriments.length; i++){           
                $("#reqCont").append('<div class="requerimentImg" style="background-image: url(img/requeriments/' + jobList[jobIndex].requeriments[i] + '.png)"></div>');
            }
            $("#optCont").html("");
            if (jobList[jobIndex].optionals != null && jobList[jobIndex].optionals != undefined && jobList[jobIndex].optionals.length > 0){
                for(var i = 0; i < jobList[jobIndex].optionals.length; i++){
                    $("#optCont").append('<div class="requerimentImg" style="background-image: url(img/requeriments/' + jobList[jobIndex].optionals[i] + '.png)"></div>');
                }
            }

            $("#audio").attr("src", "audio/" + jobList[jobIndex].name + ".mp3"); 
            $("#audio")[0].play();
        });

        $( "#arrowr" ).click(function() {
            //$("#audio")[0].pause();

            jobIndex++;
            if(jobIndex > 6){
                jobIndex = 0;
            }

            $("#jobTitle").html(jobList[jobIndex].label);
            $("#jobText").html(jobList[jobIndex].text);
            $("#jobImage").css("background-image", "url(img/" + jobList[jobIndex].name + ".png)");
            $("#reqCont").html("");
            for(var i = 0; i < jobList[jobIndex].requeriments.length; i++){           
                $("#reqCont").append('<div class="requerimentImg" style="background-image: url(img/requeriments/' + jobList[jobIndex].requeriments[i] + '.png)"></div>');
            }
            $("#optCont").html("");
            if (jobList[jobIndex].optionals != null && jobList[jobIndex].optionals != undefined && jobList[jobIndex].optionals.length > 0){
                for(var i = 0; i < jobList[jobIndex].optionals.length; i++){
                    $("#optCont").append('<div class="requerimentImg" style="background-image: url(img/requeriments/' + jobList[jobIndex].optionals[i] + '.png)"></div>');
                }
            }

            $("#audio").attr("src", "audio/" + jobList[jobIndex].name + ".mp3"); 
            $("#audio")[0].play();
        });    

        $( "#cancel" ).click(function() {
            $("#background")[0].pause();
            $("#audio")[0].pause();
            $.post("http://esx_joblisting/CloseAll", JSON.stringify({
            }));
            $("#reqCont").html("");
            $("#optCont").html("");
        });   

        $( "#submit" ).click(function() {
            $("#background")[0].pause();
            $("#audio")[0].pause();
            $.post("http://esx_joblisting/sendCV", JSON.stringify({
                job: jobList[jobIndex].name
            }));
            $("#reqCont").html("");
            $("#optCont").html("");
        });    

        $("body, html").css("display", "flex");
        $("body, html").animate({opacity: 1}, 1700);

        $("#background").attr("src", "audio/background.mp3");
        $("#background").prop("volume", 0.3);
        $("#background")[0].play();
        setTimeout(function () {
            $("#audio").prop("volume", 0.4);
            $("#audio").attr("src", "audio/welcome.mp3"); 
            $("#audio")[0].play();
        }, 1500);
    


	} else {
		$("body, html").animate({opacity: 0}, 1700);
        setTimeout(function(){
            $("body, html").css("display", "none");
        }, 1700);
        
	}
});