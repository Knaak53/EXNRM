INSERT INTO `jobs` (name, label) VALUES
  ('offpolice','Off-Duty'),
  ('offambulance','Off-Duty')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('offpolice',0,'recruit','Recluta',12,'{}','{}'),
  ('offpolice',1,'officer','Oficial',24,'{}','{}'),
  ('offpolice',2,'sergeant','Sargento',36,'{}','{}'),
  ('offpolice',3,'lieutenant','Teniente',48,'{}','{}'),
  ('offpolice',4,'boss','Jefe',0,'{}','{}'),
  ('offambulance',0,'ambulance','Celador',12,'{}','{}'),
  ('offambulance',1,'doctor','Enfermero',24,'{}','{}'),
  ('offambulance',2,'chief_doctor','Medico',36,'{}','{}'),
  ('offambulance',3,'boss','Jefe de guardia',48,'{}','{}')
;