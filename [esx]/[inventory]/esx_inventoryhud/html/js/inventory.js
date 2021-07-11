var type = "normal";
var disabled = false;
var disabledFunction = null;
var showLicesne = 0;
var hasDni = false;
var hasDrive = false;
var hasWeap = false;
var noDni = 'No tienes DNI! <br><br> Debes ir a comisaria para obtener tu DNI';
var noCar = 'No tienes Carnet! <br><br> Debes ir a la autoescuela para obtener tu carnet de conducir';
var noWeapon = 'No tienes Licencia de armas! <br><br> Debes ir a comisaria para obtener tu licencia de armas';
var characterInfo = [];
var menuIndex = 0;
var bills = [];
var selectedBill = undefined;
var questInfo = [];
var skills = [];

window.addEventListener("message", function (event) {
    if (event.data.action == "setWeight") {
        $("#weight").html("<div class=\"weight\"><p>" + (Math.round(event.data.weight * 10) / 10) + " Kg / " + (Math.round(event.data.maxWeight * 10) / 10) + " Kg</p></div>");
    }
    if (event.data.action == "display") {
        type = event.data.type
        disabled = false;   
        menuIndex = 0;              
    } else if (event.data.action == "billingInfo") {
        bills = event.data.bills;
        selectedBill = undefined;
    } else if (event.data.action == "characterInfo") {
        characterInfo = event.data.characterInfo;       
        playerMoney = event.data.characterInfo.money;
        showLicesne = 0; 
        setupBasicInfo(characterInfo);
        $(".ui").fadeIn(200);
    } else if (event.data.action == "npcInfo") {
        questInfo = event.data.questsInfo;
    } else if (event.data.action == "stats") {
        skills = event.data.stats;
    }else if (event.data.action == "deleteBill") {
        for(var i = 0; i < bills.length; i++){
            if (event.data.id == bills[i].id){
                bills.splice(i, 1);
            }
        }
        setupBillingInfo(bills);
    }else if (event.data.action == "hide") {
        $("#dialog").dialog("close");
        $(".ui").fadeOut(500);
        $("#dni").html('');
        $(".item").remove();
    } else if (event.data.action == "setItems") {
        inventorySetup(event.data.itemList);

        $('.item').draggable({
            helper: 'clone',
            appendTo: 'body',
            zIndex: 99999,
            revert: 'invalid',
            start: function (event, ui) {
                if (disabled) {
                    return false;
                }

                $(this).css('background-image', 'none');
                itemData = $(this).data("item");
                itemInventory = $(this).data("inventory");

                if (itemInventory == "second" || !itemData.canRemove) {
                    $("#drop").addClass("disabled");
                    $("#give").addClass("disabled");
                }

                if (itemInventory == "second" || !itemData.usable) {
                    $("#use").addClass("disabled");
                }
            },
            stop: function () {
                itemData = $(this).data("item");

                if (itemData !== undefined && itemData.name !== undefined) {
                    $(this).css('background-image', 'url(\'img/items/' + itemData.name + '.png\'');
                    $("#drop").removeClass("disabled");
                    $("#use").removeClass("disabled");
                    $("#give").removeClass("disabled");
                }
            }
        });
    } else if (event.data.action == "setInfoText") {
        $(".info-div").html(event.data.text);
    } else if (event.data.action == "nearPlayers") {
        $("#nearPlayers").html("");

        $.each(event.data.players, function (index, player) {
            $("#nearPlayers").append('<button class="nearbyPlayerButton" data-player="' + player.player + '">' + player.label + ' (' + player.player + ')</button>');
        });

        $("#dialog").dialog("open");

        $(".nearbyPlayerButton").click(function () {
            $("#dialog").dialog("close");
            player = $(this).data("player");
            if (event.data.item.name == "cash"){
                characterInfo.money -= parseInt($("#count").val());
                $("#dinero").html(characterInfo.money + "€");
            }
            $.post("http://esx_inventoryhud/GiveItem", JSON.stringify({
                player: player,
                item: event.data.item,
                number: parseInt($("#count").val())
            }));
        });
    }
});

function setupStats(skills){
    $('#billingInfo').css('display', 'none');
    $('#otherInventory').css('display', 'none');
    $('#questInfo').css('display', 'none');
    $('#statsInfo').css('display', 'block');
    selectedBill = undefined;
    
    $("#statsContainer").html("");
    for(var i = 0; i < skills.length; i++){
        $("#statsContainer").append('<div class="statCont"><div class="statLabel">' + skills[i].name + '</div><div class="statBar"><div class="statProgress" style="width: ' + skills[i].current + '%;"></div></div></div>');
    }
}

function setupQuestInfo(questInfo){
    $('#billingInfo').css('display', 'none');
    $('#otherInventory').css('display', 'none');
    $('#questInfo').css('display', 'block');
    $('#statsInfo').css('display', 'none');
    selectedBill = undefined;
    
    $('#questContainer').css('background-image', 'url(img/quest.png)');
    $("#questContainer").html("");

    for (var i = 0; i < questInfo.length; i++){
        var questStatus = "";
        var questStatusColor = "";
        if(questInfo[i].currentQuestIsCompleted){
            questStatus = " Completado";
            questStatusColor = "green";
        }else{
            questStatus = " En curso";
            questStatusColor = "lightgrey";
        }
        $("#questContainer").append('<div id="quest"><div id="questImg" style="background-image: url(img/' + questInfo[i].name + '.png)"></div><div id="questTitle">' + questInfo[i].questName + '</div><div id="questContent"><div id="questStatus">Estado:<span style="color:' + questStatusColor + '">&nbsp;' + questStatus + '</span></div><div id="questDescriptionLabel">Descripcion:</div><div id="questDescription">' + questInfo[i].description + '</div></div></div>');
    }   
}

function setupBillingInfo(bills){
    $('#billingInfo').css('display', 'block');
    $('#otherInventory').css('display', 'none');
    $('#questInfo').css('display', 'none');
    $('#statsInfo').css('display', 'none');
    selectedBill = undefined;

    $('#billingInfo').css('background-image', 'url(img/billing.png)');
    $('#billsContainer').html("");
    $('#factContainer').html("");
    for(var i = 0; i < bills.length; i++){
        if (bills[i].label.startsWith("Fine: ")){
            $('#billsContainer').append('<div class="bill"  id="bill-' + i + '"><div class="billAmount red">' + bills[i].amount + '€</div><div class="billLabel">' + bills[i].label.replace("Fine: ", "") + '</div></div></div>');
            $('#bill-' + i).data('bill', bills[i]);
        }else{
            $('#factContainer').append('<div class="bill" id="bill-' + i + '"><div class="billAmount green">' + bills[i].amount + '€</div><div class="billLabel">' + bills[i].label + '</div></div></div>');
            $('#bill-' + i).data('bill', bills[i]);
        }
    }

    $(".bill").click(function () {
        for(var i = 0; i < bills.length; i++){
            $('#bill-' + i).css("border-color", "lightgrey");
        }
        selectedBill = $(this).data("bill");
        if (selectedBill.label.startsWith("Fine: ")){
            $(this).css("border-color", "red");
        }else{
            $(this).css("border-color", "green");
        }           
    });

    $("#paymentButton").click(function () {
        if(selectedBill != undefined){
            if (playerMoney >= selectedBill.amount){
                playerMoney = playerMoney - selectedBill.amount;
                var billType = ""
                if (selectedBill.label.startsWith("Fine: ")){
                    billType = "Multa";
                }else{
                    billType = "Factura";
                }              
                $.post("http://esx_inventoryhud/payBill", JSON.stringify({
                    billId: selectedBill.id,
                    billType: billType,
                    amount: selectedBill.amount
                }));
            }
        }
    });

    //$('#billsContainer').html(JSON.stringify({bills: bills}));
}

function setupBasicInfo(characterInfo){
    $('#billingInfo').css('display', 'none');
    $('#otherInventory').css('display', 'block');
    $('#questInfo').css('display', 'none');
    $('#statsInfo').css('display', 'none');
    selectedBill = undefined;

    $("#identificador").html("ID: " + characterInfo.id);
    $("#nombre").html("Nombre: " + characterInfo.name);
    $("#dinero").html(characterInfo.money + "€");
    $("#banco").html(characterInfo.bank + "€");
    $("#negro").html(characterInfo.blackMoney + "€");
    $("#empleo").html("empleo: " + characterInfo.trabajo);
    $("#fecha").html("Fecha Nacimiento: " + characterInfo.dateofbirth);
    $("#altura").html("Altura: " + characterInfo.height);
    $("#grado").html("Puesto: " + characterInfo.grado);
    $("#nivelEmp").html("Nivel del puesto: " + characterInfo.jobLvl);
    $("#phone").html("Telefono: " + characterInfo.phone_number);
    $('#playerInventory').css('background-image', 'url(\'img/mochila.png\'');   

    if (characterInfo.grade_name == "boss"){
        $("#cuentaEmpresa").html("Cuenta empresa: " + characterInfo.bossAccount + "€");
    }else{
        $("#cuentaEmpresa").html("");
    }

    for (let value of characterInfo.license){
        if (value == 'dni'){
            hasDni = true;
        }
        if (value.includes("drive")){
            hasDrive = true;
        }
        if (value == 'weapon'){
            hasWeap = true;
        }
    }

    if (characterInfo.sex == 'm'){
        $("#otherInventory").css('background-image', 'url(\'img/siluetaH.png\'');
        $("#sexo").html("Sexo: hombre");
     }else{
        $("#otherInventory").css('background-image', 'url(\'img/siluetaM.png\'');
        $("#sexo").html("Sexo: mujer");
     }

    if (hasDni){
        $("#dni").css('background-image', 'url(\'img/dni.png\'');
        $("#dni").html('');
    }else{
        $("#dni").html(noDni);
        $("#dni").css('background-image', 'none');
    }
    showLicesne = 0;
    $( ".arrowl" ).click(function() {
        showLicesne--;
        if(showLicesne < 0){
            showLicesne = 2;
        }
        if (showLicesne == 0){
            if (hasDni){
                $("#dni").css('background-image', 'url(\'img/dni.png\'');
                $("#dni").html('');
            }else{
                $("#dni").html(noDni);
                $("#dni").css('background-image', 'none');
            }
        }else if (showLicesne == 1){
            if (hasDrive){
                $("#dni").css('background-image', 'url(\'img/carnet.png\'');
                $("#dni").html('');
            }else{
                $("#dni").html(noCar);
                $("#dni").css('background-image', 'none');
            }    
        }else if (showLicesne == 2){
            if (hasWeap){
                $("#dni").css('background-image', 'url(\'img/armas.png\'');
                $("#dni").html('');
            }else{
                $("#dni").html(noWeapon);
                $("#dni").css('background-image', 'none');
            }           
        }
    });

    $( ".arrowr" ).click(function() {
        showLicesne++;
        if(showLicesne > 2){
            showLicesne = 0;
        }
        if (showLicesne == 0){
            if (hasDni){
                $("#dni").css('background-image', 'url(\'img/dni.png\'');
                $("#dni").html('');
            }else{
                $("#dni").html(noDni);
                $("#dni").css('background-image', 'none');
            }
        }else if (showLicesne == 1){
            if (hasDrive){
                $("#dni").css('background-image', 'url(\'img/carnet.png\'');
                $("#dni").html('');
            }else{
                $("#dni").html(noCar);
                $("#dni").css('background-image', 'none');
            }    
        }else if (showLicesne == 2){
            if (hasWeap){
                $("#dni").css('background-image', 'url(\'img/armas.png\'');
                $("#dni").html('');
            }else{
                $("#dni").html(noWeapon);
                $("#dni").css('background-image', 'none');
            }           
        }
    });

    $( "#ver" ).click(function() {
        $.post("http://esx_inventoryhud/showCard", JSON.stringify({
            card: showLicesne,
            self: true
        }));
    });

    $( "#mostrar" ).click(function() {
        $.post("http://esx_inventoryhud/showCard", JSON.stringify({
            card: showLicesne,
            self: false
        }));
    });
}

function closeInventory() {
    $.post("http://esx_inventoryhud/NUIFocusOff", JSON.stringify({}));
}

function inventorySetup(items) {
    $("#playerInventory").html("");
    $.each(items, function (index, item) {
        count = setCount(item);

        $("#playerInventory").append('<div class="slot"><div id="item-' + index + '" class="item" style = "background-image: url(\'img/items/' + item.name + '.png\')">' +
            '<div class="item-count">' + count + '</div> <div class="item-name">' + item.label + '</div> </div ><div class="item-name-bg"></div></div>');
        $('#item-' + index).data('item', item);
        $('#item-' + index).data('inventory', "main");
    });
}

function Interval(time) {
    var timer = false;
    this.start = function () {
        if (this.isRunning()) {
            clearInterval(timer);
            timer = false;
        }

        timer = setInterval(function () {
            disabled = false;
        }, time);
    };
    this.stop = function () {
        clearInterval(timer);
        timer = false;
    };
    this.isRunning = function () {
        return timer !== false;
    };
}

function disableInventory(ms) {
    disabled = true;

    if (disabledFunction === null) {
        disabledFunction = new Interval(ms);
        disabledFunction.start();
    } else {
        if (disabledFunction.isRunning()) {
            disabledFunction.stop();
        }

        disabledFunction.start();
    }
}

function setCount(item) {
    count = item.count

    if (item.limit > 0) {
        count = item.count + " / " + item.limit
    }

    if (item.type === "item_weapon") {
        if (count == 0) {
            count = "";
        } else {
            count = '<img src="img/bullet.png" class="ammoIcon"> ' + item.count;
        }
    }

    if (item.type === "item_account" || item.type === "item_money") {
        count = formatMoney(item.count);
    }

    return count;
}

function setCost(item) {
    cost = item.price

    if (item.price == 0){
        cost = "$" + item.price
    }
    if (item.price > 0) {
        cost = "$" + item.price
    }
    return cost;
}

function formatMoney(n, c, d, t) {
    var c = isNaN(c = Math.abs(c)) ? 2 : c,
        d = d == undefined ? "." : d,
        t = t == undefined ? "," : t,
        s = n < 0 ? "-" : "",
        i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c))),
        j = (j = i.length) > 3 ? j % 3 : 0;

    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t);
};

$(document).ready(function () {
    $("#count").focus(function () {
        $(this).val("")
    }).blur(function () {
        if ($(this).val() == "") {
            $(this).val("1")
        }
    });

    $("#globalLeftArrow").click(function() {
        menuIndex--;
        if(menuIndex < 0){
            menuIndex = 3;
        }
        if(menuIndex == 0){
            setupBasicInfo(characterInfo);
        }else if (menuIndex == 1)
            setupStats(skills)  
        else if (menuIndex == 2){
            setupQuestInfo(questInfo)
        }else{
            setupBillingInfo(bills);
        }
    });

    $("#globalRightArrow").click(function() {
        menuIndex++;
        if(menuIndex > 3){
            menuIndex = 0;
        }
        if(menuIndex == 0){
            setupBasicInfo(characterInfo);
        }else if (menuIndex == 1)
            setupStats(skills)
        else if (menuIndex == 2){
            setupQuestInfo(questInfo)
        }else{
            setupBillingInfo(bills);
        }
    });

    $("body").on("keyup", function (key) {
        if (Config.closeKeys.includes(key.which)) {
            closeInventory();
        }
    });

    $('#use').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");

            if (itemData == undefined || itemData.usable == undefined) {
                return;
            }

            itemInventory = ui.draggable.data("inventory");

            if (itemInventory == undefined || itemInventory == "second") {
                return;
            }

            if (itemData.usable) {
                disableInventory(300);
                $.post("http://esx_inventoryhud/UseItem", JSON.stringify({
                    item: itemData
                }));
            }
        }
    });

    $('#give').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");

            if (itemData == undefined || itemData.canRemove == undefined) {
                return;
            }

            itemInventory = ui.draggable.data("inventory");

            if (itemInventory == undefined || itemInventory == "second") {
                return;
            }

            if (itemData.canRemove) {
                disableInventory(300);
                $.post("http://esx_inventoryhud/GetNearPlayers", JSON.stringify({
                    item: itemData
                }));
            }
        }
    });

    $('#drop').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");

            if (itemData == undefined || itemData.canRemove == undefined) {
                return;
            }

            itemInventory = ui.draggable.data("inventory");

            if (itemInventory == undefined || itemInventory == "second") {
                return;
            }

            if (itemData.canRemove) {
                disableInventory(300);
                if (itemData.name == "cash"){
                    characterInfo.money -= parseInt($("#count").val());
                    $("#dinero").html(characterInfo.money + "€");
                }
                $.post("http://esx_inventoryhud/DropItem", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            }
        }
    });
});

$.widget('ui.dialog', $.ui.dialog, {
    options: {
        // Determine if clicking outside the dialog shall close it
        clickOutside: false,
        // Element (id or class) that triggers the dialog opening 
        clickOutsideTrigger: ''
    },
    open: function () {
        var clickOutsideTriggerEl = $(this.options.clickOutsideTrigger),
            that = this;
        if (this.options.clickOutside) {
            // Add document wide click handler for the current dialog namespace
            $(document).on('click.ui.dialogClickOutside' + that.eventNamespace, function (event) {
                var $target = $(event.target);
                if ($target.closest($(clickOutsideTriggerEl)).length === 0 &&
                    $target.closest($(that.uiDialog)).length === 0) {
                    that.close();
                }
            });
        }
        // Invoke parent open method
        this._super();
    },
    close: function () {
        // Remove document wide click handler for the current dialog
        $(document).off('click.ui.dialogClickOutside' + this.eventNamespace);
        // Invoke parent close method 
        this._super();
    },
});