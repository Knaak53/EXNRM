var btc = 0;
var inversion = 0;
var currentPrice = 0;
var isActive = false;
var playerMoney = 0;
var accounts = [];
var account = "";

window.addEventListener("message", function (event) {
    if (event.data.action == "open") {
    	isActive = true
    	worker()

        btc = event.data.btc;
        inversion = event.data.inversion;
        playerMoney = event.data.playerMoney;
        accounts = event.data.accounts;
        account = event.data.account;

        $("#walletBTC").html("BTC: " + btc); 
        $("#graphicsContainer").html('<div id="invisibleHeader"></div><div style="height: 130%; background-color: #1D2330; overflow:hidden; box-sizing: border-box; border: 2px solid lightgrey; border-radius: 12px; text-align: right; line-height:14px; font-size: 12px; font-feature-settings: normal; text-size-adjust: 100%; box-shadow: inset 0 -20px 0 0 #262B38;padding:1px;padding: 0px; margin: 0px; width: 100%;"><div style="height:540px; padding:0px; margin:0px; width: 100%;"><iframe src="https://widget.coinlib.io/widget?type=chart&theme=dark&coin_id=859&pref_coin_id=1506" width="100%" height="536px" scrolling="auto" marginwidth="0" marginheight="0" frameborder="0" border="0" style="border:0;margin:0;padding:0;line-height:14px;"></iframe></div><div style="color: #626B7F; line-height: 14px; font-weight: 400; font-size: 11px; box-sizing: border-box; padding: 2px 6px; width: 100%; font-family: Verdana, Tahoma, Arial, sans-serif;"><a style="font-weight: 500; color: #626B7F; text-decoration:none; font-size:11px">Cryptocurrency Prices</a>&nbsp;by Caronte trading view (COINLIB)</div></div>');
        $("#buyAndSellContainer").css("display", "block"); 
        $("#reciveContainer").css("display", "none");
        $("#sendButtons").css("display", "none");

        $("#selfAccountContainer").html("Tu cuenta BTC:&nbsp;<span style=\"user-select: all;\">" + account + "</span>");
        $('#qr').html("");
        $('#qr').qrcode({width: 128,height: 128,text: account});

        showNotification("¡Atencion!<br>Los precios de compra y venta pueden variar ligeramente en el momento de la transaccion debido a la discrepancia entre los distintos proveedores de datos.", "w");
        $("body, html").css("display", "flex");  

        $( "#btcAccount" ).autocomplete({
          source: accounts
        });           
    }
})

$(document).ready(function () {
    $('#close').click(function() {
        isActive = false;
        $("#graphicsContainer").html(""); 
        $("body, html").css("display", "none");
        $.post("http://esx_bitcoin/close", JSON.stringify({}));
    });

    $('#btcInput').on('input', function() {
      var currentBTCInput = $('#btcInput').val();
      var inputBTCPrice = Math.round(currentPrice * currentBTCInput)
      $('#eurInput').val(inputBTCPrice);
    });

    $('#eurInput').on('input', function() {
      var currentEURInput = $('#eurInput').val();
      var inputBTCPrice = currentEURInput / currentPrice;
      $('#btcInput').val(truncate(inputBTCPrice, 8).toFixed(8));
    });

    $("#buy").click(function() {
        $("#buyAndSellContainer").css("display", "block");
        $("#reciveContainer").css("display", "none");
        $("#buyButtons").css("display", "flex");
        $("#sendButtons").css("display", "none");
        showNotification("¡Atencion!<br>Los precios de compra y venta pueden variar ligeramente en el momento de la transaccion debido a la discrepancia entre los distintos proveedores de datos.", "w");
    });

    $("#send").click(function() {
        $("#buyAndSellContainer").css("display", "block");
        $("#buyButtons").css("display", "none");
        $("#reciveContainer").css("display", "none");
        $("#sendButtons").css("display", "flex");
        showNotification("Introduce la cantidad de BTC/EUR que quieres enviar y una direccion BTC valida", "n");
    });

    $("#recive").click(function() {
        $("#buyAndSellContainer").css("display", "none");
        $("#reciveContainer").css("display", "block");
        showNotification("Dale tu direccion a tus contactos para que puedan enviarte BTC", "n");
    });

    $("#buyButton").click(function() {
        if ($('#eurInput').val() > 0 && playerMoney >= $('#eurInput').val()){
          btc = truncate(btc + parseFloat($('#btcInput').val()), 8);
          playerMoney -= parseInt($('#eurInput').val());
          inversion += parseInt($('#eurInput').val());        
          $.post("http://esx_bitcoin/buyBitcoin", JSON.stringify({
              btc:  btc,
              price: inversion,
              btcPrice: parseInt($('#eurInput').val())
          }));
          showNotification("Has comprado " + $('#btcInput').val() + "BTC por " + parseInt($('#eurInput').val()) + "€", "n");
          $("#walletBTC").html("BTC: " + btc);
          $('#btcInput').val(0);
          $('#eurInput').val(0);
        }else{
          showNotification("No tienes suficientes fondos para comprar esa cantidad de Bitcoin!", "w");
        }  
    });

    $("#sellButton").click(function() {
        if ($('#eurInput').val() > 0 && btc >= truncate(parseFloat($('#btcInput').val()), 8)){
          btc = truncate(btc - parseFloat($('#btcInput').val()), 8);
          playerMoney += parseInt($('#eurInput').val());
          inversion -= parseInt($('#eurInput').val());        
          $.post("http://esx_bitcoin/sellBitcoin", JSON.stringify({
              btc:  btc,
              price: inversion,
              btcPrice: parseInt($('#eurInput').val())
          }));
          showNotification("Has vendido " + $('#btcInput').val() + "BTC por " + parseInt($('#eurInput').val()) + "€", "n");
          $("#walletBTC").html("BTC: " + btc);
          $('#btcInput').val(0);
          $('#eurInput').val(0);
        }else{
          showNotification("No tienes tanto BTC que vender!", "w");
        }  
    });

    $("#sendButton").click(function() {
        if ($('#eurInput').val() > 0 && btc >= truncate(parseFloat($('#btcInput').val()), 8)){
          if ($('#btcAccount').val() != account){
            btc = truncate(btc - parseFloat($('#btcInput').val()), 8);
            inversion -= parseInt($('#eurInput').val());
            var goodAccount = false 
            for(var i = 0; i < accounts.length; i++){
                if (accounts[i] == $('#btcAccount').val()) {
                  goodAccount = true 
                }
            }
            if (goodAccount){
              $.post("http://esx_bitcoin/sendBitcoin", JSON.stringify({
                  btc:  btc,
                  price: inversion,
                  btcSent: truncate(parseFloat($('#btcInput').val()), 8),
                  targetAccount: $('#btcAccount').val()
              }));
              showNotification("Has enviado " + $('#btcInput').val() + "BTC a <span style=\"text-transform: none;\">&nbsp;" + $('#btcAccount').val() + "</span>", "n");
              $("#walletBTC").html("BTC: " + btc);
              $('#btcInput').val(0);
              $('#eurInput').val(0);
            }else{
              showNotification("La cuenta de BTC que has introducido no es valida!", "w");
            }
          }else{
            showNotification("No puedes enviarte BTC a ti mismo!", "w");
          }
        }else{
          showNotification("No tienes tanto BTC que enviar!", "w");
        }  
    });
});

function showNotification(message, type){
  if (type == "n"){
    $("#buyWarning").css("color", "green");
    $("#buyWarning").css("border-color", "green");
    $("#buyWarning").css("background-color", "rgba(0, 90, 0, 0.2)");
  }else{
    $("#buyWarning").css("color", "red");
    $("#buyWarning").css("border-color", "red");
    $("#buyWarning").css("background-color", "rgba(90, 0, 0, 0.2)");
  }
  $("#buyWarning").html(message);
}

function truncate(v, p) {
    var s = Math.pow(10, p || 0);
    return Math.trunc(s * v) / s;
}


function worker() {
  if (isActive){
  	$.get("https://api.coin360.com/coin/latest?coin=btc&convert=eur", function(data, status){
  		currentPrice = Math.round(data.BTC.quotes.EUR.price)
      var currentPercentage = 0;
      currentPercentage = (btc == 0) ? 0.00 : parseFloat(((currentPrice * btc) / inversion) * 100 - 100).toFixed(2);
      if (currentPercentage > 0) {
        $("#walletPercentage").css("color", "green");
      }else{
        $("#walletPercentage").css("color", "red");
      }
      $("#walletPercentage").html(currentPercentage + "%");
	    $("#walletEUR").html( Math.round(currentPrice * btc) + "€");
	    setTimeout(worker, 10000);
  	});
  } 
}
