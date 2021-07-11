USE `es_extended`;

CREATE TABLE `weashops` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`zone` varchar(255) NOT NULL,
	`item` varchar(255) NOT NULL,
	`price` int(11) NOT NULL,

	PRIMARY KEY (`id`)
);

INSERT INTO `licenses` (`type`, `label`) VALUES
	('weapon', "Permis de port d'arme")
;

INSERT INTO `weashops` (`zone`, `item`, `price`) VALUES
	('GunShop','WEAPON_PISTOL', 800),
	('GunShop', 'WEAPON_FLASHLIGHT', 60),
	('GunShop', 'WEAPON_MACHETE', 400),
	('GunShop', 'WEAPON_NIGHTSTICK', 150),
	('GunShop', 'WEAPON_BAT', 175),
	('GunShop', 'WEAPON_KNIFE', 250),
	('GunShop', 'WEAPON_STUNGUN', 50),
	('GunShop', 'WEAPON_MICROSMG', 1400),
	('GunShop', 'WEAPON_PUMPSHOTGUN', 3400),
	('GunShop', 'WEAPON_ASSAULTRIFLE', 10000),
	('GunShop', 'WEAPON_SPECIALCARBINE', 15000),
	('GunShop', 'WEAPON_SNIPERRIFLE', 22000),
	('GunShop', 'WEAPON_FIREWORK', 18000),
	('GunShop', 'WEAPON_BZGAS', 200),
	('GunShop', 'WEAPON_FIREEXTINGUISHER', 100),
	('GunShop', 'WEAPON_BALL', 50),
	('GunShop', 'WEAPON_SMOKEGRENADE', 100)
;
