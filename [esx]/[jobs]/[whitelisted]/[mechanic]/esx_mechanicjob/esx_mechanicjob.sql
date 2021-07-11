USE `es_extended`;

INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_mechanic', 'Mecanico', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_mechanic', 'Mecanico', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_mechanic', 'Mecanico', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('mechanic', 'Mecanico')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	(25, 'mechanic',0,'recrue', 'Aprendiz', 400,'{}','{}'),
	(26,'mechanic',1,'novice','Oficial de 2ª', 800,'{}','{}'),
	(27,'mechanic',2,'experimente','Oficial de 1ª', 1200,'{}','{}'),
	(28'mechanic',3,'boss',"Jefe de taller", 2000,'{}','{}')
;

INSERT INTO `items` (name, label, weight) VALUES
	('gazbottle', 'Botella de gas', 2, 10, 0, 1),
	('fixtool', 'Herramientas reparación', 2, 10, 0, 1),
	('carotool', 'Herramientas carrocería', 2, 10, 0, 1),
	('blowpipe', 'Soplete', 1, 10, 0, 1),
	('fixkit', 'Kit de reparación', 1, 10, 0, 1),
	('carokit', 'Kit de carrocería', 1, 10, 0, 1)
;
