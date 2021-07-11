var textMessageQueue = [];
var currentShowingTexts = 0;
var currentTextMessageId = 0;

window.addEventListener("message", function (event) {
    if (event.data.action == "show") {
        showMessage(event.data.title, event.data.text, event.data.img, event.data.audio);
	} 
    else if (event.data.action == "showText") {
        if (currentShowingTexts < 3){
            showTextMessage(event.data.message, event.data.messageType, event.data.item, event.data.movementType)
        }else{
            textMessageQueue.push({message: event.data.message, type: event.data.messageType, item: event.data.item, movement: event.data.movementType});
        } 
    }
    else if (event.data.action == "hide") {
		$("#mainContainer").animate({opacity: 0}, 500);
	} 
});

function showMessage(title, text, img, audio){
    $("#titleContainer").html(title);
    $("#textContainer").html(text);
    $("#imgContainer").css("background-image", "url(img/" + img + ")");    
    $("#audio").attr("src", "audio/" + audio);
    $("#mainContainer").animate({opacity: 1}, 300);
    $("#audio").prop("volume", 0.3);
    $("#audio")[0].play();
}

function getImgNodeByMessageType(type, item, movement){
    var finalNode = "";
    if (type == "info"){
        finalNode += '<div class="imgIcon" style="background-image: url(img/info.png)">'
    }else if (type == "item"){
        var background = "";
        if (movement == "add"){
            background = "img/itemAdd.png";
        }else{
            background = "img/itemRemove.png";
        }
        finalNode += '<div class="imgIcon" style="background-image: url(' + background + ')"><div class="imgItem" style="background-image: url(img/items/' + item + '.png);"></div>'
    }else{
        finalNode = '<div class="imgIcon">';
    }
    return finalNode + '</div>';
}

function showTextMessage(message, type, item, movement){
    currentShowingTexts++;
    currentTextMessageId++;
    var assignedId = currentTextMessageId;
    var imgNode = getImgNodeByMessageType(type, item, movement)
    $("#textNotificationPanel").append('<div id="message-' + assignedId + '" class="textNotification">' + imgNode +'<div class="textNotificationArea">' + getMessageTextWithColors(message) + '</div></div>');
    $("#message-" + assignedId).animate({"margin-left": '0%'}, 350);
    setTimeout(function(){ 
        $("#message-" + assignedId).animate({"margin-left": '100%'}, 500)
        setTimeout(function(){
            $("#message-" + assignedId).remove();
            currentShowingTexts--;
            if(textMessageQueue.length > 0 && currentShowingTexts < 3){
                setTimeout(function(){
                    showTextMessage(textMessageQueue[0].message, textMessageQueue[0].type, textMessageQueue[0].item, textMessageQueue[0].movement)
                }, 0);
                setTimeout(function(){
                    textMessageQueue.splice(0, 1) 
                }, 150);     
            }
        }, 450);
    }, 5000 + (currentShowingTexts * 200));
}

function getMessageTextWithColors(message){
    var finalMessage = '<div class="textDiv">';
    if (message.includes("~")){
        var colorIndexes = [];//message.match("~[rbgypocmusw]~");
        var pattern = /~[rbgypocmusw]~/g;
        while ((match = pattern.exec(message)) != null) {
            colorIndexes.push(match.index)
        }
        if(colorIndexes != null && colorIndexes != undefined && colorIndexes.length > 0){
            finalMessage += "<span>" + message.substring(0, colorIndexes[0] - 1)
            if (message.charAt(colorIndexes[0] + 3) == " "){
                finalMessage += "</span>"
            }else{
               finalMessage += "&nbsp;" + "</span>"; 
            }
            for(var i = 0; i < colorIndexes.length; i++){
                if(colorIndexes.length - i >= 2){
                    finalMessage += getStringPortionWithColor(colorIndexes[i], colorIndexes[i + 1], message)
                }else{
                    finalMessage += getStringPortionWithColor(colorIndexes[i], message.length, message)
                }
            }
        }
        return finalMessage + "</div>";
    }
    return message;
}   

function getStringPortionWithColor(start, end, message){
    var colorToApply = getColorSpanStart(message.charAt(start + 1))
    return colorToApply + message.substring(start + 3, end).replaceAll(" ", "&nbsp;") + "</span>"
}

function getColorSpanStart(colorStartLetter){
    var colorName = ""
    switch(colorStartLetter.toLowerCase()){
        case "r":
            colorName = "red";
            break;
        case "b":
            colorName = "blue";
            break;
        case "g":
            colorName = "green";
            break;
        case "y":
            colorName = "yellow";
            break;
        case "p":
            colorName = "purple";
            break;
        case "o":
            colorName = "orange";
            break;
        case "c":
            colorName = "grey";
            break;
        case "m":
            colorName = "darkgrey";
            break;
        case "u":
            colorName = "black";
            break;
        default:
            colorName = "white";
            break;
    }
    return '<span style="color: ' + colorName + '">'
}