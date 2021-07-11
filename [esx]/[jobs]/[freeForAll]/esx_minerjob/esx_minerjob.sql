INSERT INTO `jobs` (name, label, whitelisted) VALUES
	('miner', 'Minero', 0)
;

INSERT INTO `job_grades` (id, job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	(42, 'miner', 0, 'employee', 'Oficial', 0, '{}', '{}')
;

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
	('stones', 'Piedra', 1, 0, 1),
	('washedstones', 'Washed stones', 1, 0, 1),
	('diamond', 'Diamond', 1, 0, 1),
	('gold', 'Gold', 2, 0, 1),
	('iron', 'Iron', 2, 0, 1),
	('copper', 'Cobre', 2, 0, 1)
;
