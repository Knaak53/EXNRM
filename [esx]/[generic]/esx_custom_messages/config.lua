Config = {}

Config.messages = {
	clothesShop = {
		title = "Tienda de Ropa",
		npcImage = "clothes.png",
		messages = {
			hello = {
				hello1 = {
					message = "Hola, te puedo ayudar en algo? Seguro que tenemos tu talla.",
					audio = "ropa_hola1.mp3",
					duration = 4200
				},
				hello2 = {
					message = "Buenas, necesitas ayuda? Estare encantada de atenderte.",
					audio = "ropa_hola2.mp3",
					duration = 4200
				}
			},
			buy = {
				buy1 = {
					message = "Wow! Te queda fabuloso! Espero que vuelvas pronto.",
					audio = "ropa_buy1.mp3",
					duration = 7000
				},
				buy2 = {
					message = "Eso te queda de muerte! Recuerda que pronto tendremos rebajas.",
					audio = "ropa_buy2.mp3",
					duration = 4200
				}
			}	
		}	
	},
	accesoriesShop = {
		title = "Tienda de Accesorios",
		npcImage = "accessories.png",
		messages = {
			hello = {
				hello1 = {
					message = "Holi, me llamo Charline, me encargo de los complementos, en que puedo ayudarte?.",
					audio = "ropa_c_hola1.mp3",
					duration = 6000
				},
				hello2 = {
					message = "Bonjour, gafas, sombreros, pendientes... tenemos todo tipo de complementos.",
					audio = "ropa_c_hola2.mp3",
					duration = 6000
				}
			},
			buy = {
				buy1 = {
					message = "Chao! Que lo pases bien.",
					audio = "ropa_c_buy2.mp3",
					duration = 3000
				},
				buy2 = {
					message = "Au revoir, quel style!",
					audio = "ropa_c_buy1.mp3",
					duration = 4200
				}
			}
		}	
	},
	badulakes = {
		title = "Tendero del Badulake",
		npcImage = "shop.png",
		messages = {
			hello = {
				hello1 = {
					message = 'Hola! Dejeme las cosas por aqui, que se las paso por caja.',
					audio = "hola1.mp3",
					duration = 4000
				},
				hello2 = {
					message = 'Buenas! Eso es todo o desearia algo mas?',
					audio = "hola2.mp3",
					duration = 4000
				},
				hello3 = {
					message = 'Salam malecum amigo! Dejeme que le ayude con todos esos productos, anda.',
					audio = "hola3.mp3",
					duration = 4000
				}
			},
			ticket = {
				ticket1 = {
					message = 'Aqui tiene su ticket, va a pagar en efectivo o con tarjeta?',
					audio = "cuenta1.mp3",
					duration = 4000
				},
				ticket2 = {
					message = 'Bueno, este es el total, como desea pagarlo?',
					audio = "cuenta2.mp3",
					duration = 4000
				},
				ticket3 = {
					message = 'Pues aqui tiene su cuenta, me confirma que todo esta bien?',
					audio = "cuenta3.mp3",
					duration = 4000
				}
			},
			bye = {
				bye1 = {
					message = 'Muchas gracias, vuelva pronto!',
					audio = "adios1.mp3",
					duration = 4000
				},
				bye2 = {
					message = 'Adios, Vuelva cuando quiera!',
					audio = "adios2.mp3",
					duration = 4000
				},
				bye3 = {
					message = 'Gracias por confiar en badulakes Caronte!',
					audio = "adios3.mp3",
					duration = 4000
				}
			}	
		}	
	},
	jobListing = {
		title = 'OFICINA DE EMPLEO',
		npcImage = 'emp_office.png',
		messages = {
			jobInProcess = {
				message = 'Saludos! Me pongo en contacto con usted desde la oficina de empleo de Caronte para informarle de que su solicitud ha sido procesada y su curriculum ha sido entregado a la empresa, le deseamos mucha suerte en el proceso de selección.',
				audio = 'curriculum.mp3',
				duration = 13000
			},
			contracted = {
				message = 'Saludos! Le llamo desde la oficina de empleo de Caronte para informarle de que la empresa quiere contratar sus servicios. Enhorabuena! Recibirá noticias por parte de la empresa para gestionar su incorporación en breve.',
				audio = 'contratado.mp3',
				duration = 10000
			}
		}
	},
	weaponShop = {
		title = "Tienda de Armas",
		npcImage = "weapons.png",
		messages = {
			hello = {
				hello1 = {
					message = "Hey, que pasa, estas en la mejor armeria de Caronte, espero que tengas licencia de armas.",
					audio = "hello1.mp3",
					duration = 7000
				},
				hello2 = {
					message = "Hey, que pasa, estas en la mejor armeria de Caronte, espero que tengas licencia de armas.",
					audio = "hello2.mp3",
					duration = 4200
				}
			},
			buy = {
				buy1 = {
					message = "Ten cuidado con lo que haces, recuerda que es para defensa propia.",
					audio = "buy1.mp3",
					duration = 4000
				},
				buy2 = {
					message = "Andate con ojo y usalo bien o la policia te retirara la licencia en menos que canta un gallo.",
					audio = "buy2.mp3",
					duration = 7000
				}
			},
			noLicense = {
				message = "Veo que no tienes licencia, asi que no puedo venderte nada, ve a comisaria si quieres obtener tu licencia.",
				audio = "license.mp3",
				duration = 7000
			}
		}	
	},
	dmv = {
		title = 'EXAMINADOR',
		npcImage = 'drive_teacher.png',
		messages = {
			testOk = {
				message = 'Enhorabuena, Has aprobado el examen teorico, ahora, ya puedes realizar examenes practicos!',
				audio = 'drive_congrats_t.mp3',
				duration = 6000
			},
			hello = {
				message = 'Hola! Me llamo Marcus y hoy sere tu examinador, por favor, sigue mis indicaciones para realizar la prueba.',
				audio = 'drive_start_practice.mp3',
				duration = 7000
			},
			practiceSuccess = {
				message = 'Enhorabuena, Has aprobado el examen practico, ya tienes tu carnet de conducir!',
				audio = 'drive_congrats_p.mp3',
				duration = 4000
			},
			speedLimit = {
				message = 'Cuidado, has superado el limite de velocidad, por desgracia tengo que ponerte una falta.',
				audio = 'drive_limit.mp3',
				duration = 5000
			},
			crash = {
				message = 'Eh! Mira por donde vas, has estropeado el coche de practicas y solo tenemos uno. Tienes una falta!',
				audio = 'drive_crash.mp3',
				duration = 7000
			},
			zoneSpeed = {
				message = 'Recuerda, que en esta zona el limite de velocidad es de 40Km/h utiliza musculo \"Y\" para activar la velocidad de crucero.',
				audio = 'drive_urban.mp3',
				duration = 7000
			},
			stop = {
				message = 'Debes frenar completamente en los stops, y ceder el paso a los vehiculos que tengan prioridad!',
				audio = 'drive_stop.mp3',
				duration = 5000
			},
			ceda = {
				message = 'En un ceda el paso, no es necesario parar completamente, pero es una practica muy prudente, recuerdalo.',
				audio = 'drive_ceda.mp3',
				duration = 6000
			},
			continue = {
				message = 'Continua hasta el siguiente punto, lo he marcado en el GPS, pero no quites los ojos de la carretera.',
				audio = 'drive_next_gps.mp3',
				duration = 5200
			},
			midZone = {
				message = 'Ahora estamos mas alejados de la zona urbana, aqui el limite de velocidad es de 80Km/h.',
				audio = 'drive_conventional.mp3',
				duration = 5000
			},
			highway = {
				message = 'Vamos a entrar en la autopista, asi que ahora, el limite de velocidad es de 120Km/h.',
				audio = 'drive_autopista.mp3',
				duration = 5000
			},
			nextPoint = {
				message = 'Avanza hasta el siguiente punto para continuar.',
				audio = 'drive_next.mp3',
				duration = 5000
			},
		}
	}
}