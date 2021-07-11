DROP EVENT IF EXISTS `whitelist_updater`;
CREATE EVENT `whitelist_updater`  ON SCHEDULE EVERY 6 HOUR 
STARTS CURRENT_TIMESTAMP 
DO 

BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE identifier varchar(100) DEFAULT "";

	-- declare cursor for employee email
	DEClARE curId 
		CURSOR FOR 
			SELECT identifier FROM whitelisted where DATEDIFF(now(), entryDate) > 3;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

	OPEN curId;

	getEmail: LOOP
		FETCH curId INTO emailAddress;
		IF finished = 1 THEN 
			LEAVE getEmail;
		END IF;
		-- build email list
		SET emailList = CONCAT(emailAddress,";",emailList);
	END LOOP getEmail;
	CLOSE curId;
	
END

ALTER EVENT `whitelist_updater` ON  COMPLETION PRESERVE ENABLE;









DELIMITER $$
CREATE PROCEDURE createEmailList (
	INOUT emailList varchar(4000)
)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE emailAddress varchar(100) DEFAULT "";

	-- declare cursor for employee email
	DEClARE curEmail 
		CURSOR FOR 
			SELECT email FROM employees;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

	OPEN curEmail;

	getEmail: LOOP
		FETCH curEmail INTO emailAddress;
		IF finished = 1 THEN 
			LEAVE getEmail;
		END IF;
		-- build email list
		SET emailList = CONCAT(emailAddress,";",emailList);
	END LOOP getEmail;
	CLOSE curEmail;

END$$
DELIMITER ;