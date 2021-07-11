--
-- Contenu de la table `jobs`
--
INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('gopostal', 'Correos Caronte', 0);

--
-- Contenu de la table `job_grades`
--

INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(43, 'gopostal', 0, 'employee', 'Repartidor', 0, '', '');

--
-- Contenu de la table `items`
--

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES 
('letter', 'Carta', '0', '0', '1'), 
('colis', 'Paquete', '0', '0', '1');