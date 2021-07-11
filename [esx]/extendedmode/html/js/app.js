(() => {

	ESX = {};
	ESX.HUDElements = [];

	ESX.setHUDDisplay = function (opacity) {
		$('#hud').css('opacity', opacity);
	};

	//	$('#hud').fadeOut('fast');
	ESX.insertHUDElement = function (name, index, priority, html, data) {
		ESX.HUDElements.push({
			name: name,
			index: index,
			priority: priority,
			html: html,
			data: data
		});

		ESX.HUDElements.sort((a, b) => {
			return a.index - b.index || b.priority - a.priority;
		});
	};

	ESX.updateHUDElement = function (name, data) {
		for (let i = 0; i < ESX.HUDElements.length; i++) {
			if (ESX.HUDElements[i].name == name) {
				ESX.HUDElements[i].data = data;
			}
		}

		ESX.refreshHUD();
	};

	ESX.deleteHUDElement = function (name) {
		for (let i = 0; i < ESX.HUDElements.length; i++) {
			if (ESX.HUDElements[i].name == name) {
				ESX.HUDElements.splice(i, 1);
			}
		}

		ESX.refreshHUD();
	};

	ESX.refreshHUD = function () {
		$('#hud').html('');

		for (let i = 0; i < ESX.HUDElements.length; i++) {
			let html = Mustache.render(ESX.HUDElements[i].html, ESX.HUDElements[i].data);
			$('#hud').append(html);
		}
		$('#hud').fadeIn()
		setTimeout(function() {
			$('#hud').fadeOut('fast');
		}, 3000);
	};
	ESX.refreshHUDTest = function () {
		$('#hud').html('');
		let html = "<div>Test</div>";
		$('#hud').append(html);
		for (let i = 0; i < ESX.HUDElements.length; i++) {

		}
		$('#hud').fadeIn()
		setTimeout(function() {
			$('#hud').fadeOut('fast');
		}, 3000);
	};

	ESX.inventoryNotification = function (add, label, count, wpercent) {
		let notif = '';

		$('#itemanim').attr('src','img/items/'+label+'.png')
		if (add) {
			notif += '+';
			getInMove()
		} else {
			notif += '-';
			getOutMove()
		}

		$('#backpack_full').css("height", wpercent+"%")
		console.log(label)
		//if (count) {
		//	notif += count + ' ' + '<img src="img/items/'+label+'">';
		//} else {
		//	notif += ' ' + '<img src="img/items/'+label+'.png">';
		//}

		//let elem = $('<div>' + notif + '</div>');
		//$('#inventory_notifications').append(elem);
		
		
		//$(elem).delay(1000).fadeOut(1000, function () {
		//	elem.remove();
		//});
	};

	ESX.toggleinventoryNotification = function (toggle) {
		if (toggle){
			$("#inventory_notifications").hide()
		}else{
			$("#inventory_notifications").show()
		}
	}

	window.onData = (data) => {
		switch (data.action) {
			case 'setHUDDisplay': {
				ESX.setHUDDisplay(data.opacity);
				break;
			}

			case 'insertHUDElement': {
				ESX.insertHUDElement(data.name, data.index, data.priority, data.html, data.data);
				break;
			}

			case 'updateHUDElement': {
				ESX.updateHUDElement(data.name, data.data);
				break;
			}

			case 'deleteHUDElement': {
				ESX.deleteHUDElement(data.name);
				break;
			}

			case 'inventoryNotification': {
				ESX.inventoryNotification(data.add, data.item, data.count, data.wpercent);
			}
			case 'toggle_inventoryNotification': {
				ESX.toggleinventoryNotification(data.toggle);
			}
		}
	};

	window.onload = function (e) {
		window.addEventListener('message', (event) => {
			onData(event.data);
			$('#hud').fadeOut('fast');
		});
	};
})();
