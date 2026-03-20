-- -----------------------------------------------------------------------------
-- MySQL Simple Debugger
-- -----------------------------------------------------------------------------
-- Description: Lightweight debugging utility for MySQL/MariaDB stored procedures.
-- License: MIT (or Open Source)
-- Usage:
--   CALL debug__enable();      - Initialize the debug table in memory
--   CALL debug__msg('text');   - Log a simple message
--   CALL debug__var('n', 'v'); - Log variable name and value
--   CALL debug__show();        - Display results and cleanup
-- -----------------------------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- 1. Procedure to initialize the debugging environment
DROP PROCEDURE IF EXISTS `debug__enable`;
DELIMITER //
CREATE PROCEDURE `debug__enable`()
BEGIN
	IF EXISTS (SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME = 'debug__data' AND TABLE_SCHEMA = DATABASE()) THEN
		DROP TABLE debug__data;
	END IF;
	
	CREATE TABLE debug__data (
		msg VARCHAR(255),
		var VARCHAR(255),
		value VARCHAR(255))
	ENGINE = MEMORY; 
END//
DELIMITER ;

-- 2. Procedure to log a simple message
DROP PROCEDURE IF EXISTS `debug__msg`;
DELIMITER //
CREATE PROCEDURE `debug__msg`(IN `$in_msg` varchar(255))
BEGIN
	IF EXISTS (SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME = 'debug__data' AND TABLE_SCHEMA = DATABASE()) THEN
		INSERT INTO debug__data (msg, var, value) VALUES ($in_msg, '', '');
	END IF;
END//
DELIMITER ;

-- 3. Procedure to log a variable name and its value
DROP PROCEDURE IF EXISTS `debug__var`;
DELIMITER //
CREATE PROCEDURE `debug__var`(IN `$in_var` varchar(255), IN `$in_value` varchar(255))
BEGIN
	IF EXISTS (SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME = 'debug__data' AND TABLE_SCHEMA = DATABASE()) THEN
		INSERT INTO debug__data (msg, var, value) VALUES ('', $in_var, $in_value);
	END IF;
END//
DELIMITER ;

-- 4. Procedure to display the log and destroy the temporary table
DROP PROCEDURE IF EXISTS `debug__show`;
DELIMITER //
CREATE PROCEDURE `debug__show`()
BEGIN
	IF EXISTS (SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME = 'debug__data' AND TABLE_SCHEMA = DATABASE()) THEN

		-- Add summary record
		INSERT INTO debug__data
		SELECT CONCAT('DEBUG ', (SELECT COUNT(*) FROM debug__data), ' record(s)'), '', '';

		-- Select all records for the user
		SELECT * FROM debug__data;
		
		-- Cleanup
		DROP TABLE IF EXISTS debug__data;
		
		-- Show any engine warnings if present
		SHOW WARNINGS;
	END IF;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
