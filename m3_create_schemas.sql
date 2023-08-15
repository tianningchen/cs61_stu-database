/**************************************************************
* This script creates the table schema for the stu_db database
***************************************************************/

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema stu_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema stu_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `stu_db` DEFAULT CHARACTER SET utf8 ;
USE `stu_db` ;

-- -----------------------------------------------------
-- Table `stu_db`.`Med`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stu_db`.`Med` (
  `sid` INT NOT NULL AUTO_INCREMENT,
  `sex` VARCHAR(1) NULL,
  `age` INT NULL,
  `health` INT NULL,
  PRIMARY KEY (`sid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stu_db`.`Edu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stu_db`.`Edu` (
  `sid` INT NOT NULL,
  `nursery` VARCHAR(1) NULL,
  `school` VARCHAR(10) NULL,
  `reason` VARCHAR(100) NULL,
  `higher` VARCHAR(1) NULL,
  PRIMARY KEY (`sid`),
  CONSTRAINT `edu_sid`
    FOREIGN KEY (`sid`)
    REFERENCES `stu_db`.`Med` (`sid`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stu_db`.`Fam`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stu_db`.`Fam` (
  `sid` INT NOT NULL,
  `address` VARCHAR(1) NULL,
  `famsize` VARCHAR(10) NULL,
  `Pstatus` VARCHAR(1) NULL,
  `guardian` VARCHAR(45) NULL,
  `famrel` INT NULL,
  PRIMARY KEY (`sid`),
  CONSTRAINT `fam_sid`
    FOREIGN KEY (`sid`)
    REFERENCES `stu_db`.`Med` (`sid`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stu_db`.`ParProf`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stu_db`.`ParProf` (
  `sid` INT NOT NULL,
  `Medu` INT NULL,
  `Fedu` INT NULL,
  `Mjob` VARCHAR(45) NULL,
  `Fjob` VARCHAR(45) NULL,
  PRIMARY KEY (`sid`),
  CONSTRAINT `parprof_sid`
    FOREIGN KEY (`sid`)
    REFERENCES `stu_db`.`Med` (`sid`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stu_db`.`Time`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stu_db`.`Time` (
  `sid` INT NOT NULL,
  `traveltime` INT NULL,
  `studytime` INT NULL,
  `activities` VARCHAR(1) NULL,
  `romantic` VARCHAR(1) NULL,
  `freetime` INT NULL,
  `goout` INT NULL,
  PRIMARY KEY (`sid`),
  CONSTRAINT `time_sid`
    FOREIGN KEY (`sid`)
    REFERENCES `stu_db`.`Med` (`sid`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stu_db`.`Courses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stu_db`.`Courses` (
  `sid` INT NOT NULL,
  `absences` INT NULL,
  `failures` INT NULL,
  PRIMARY KEY (`sid`),
  CONSTRAINT `courses_sid`
    FOREIGN KEY (`sid`)
    REFERENCES `stu_db`.`Med` (`sid`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stu_db`.`Supp`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stu_db`.`Supp` (
  `sid` INT NOT NULL,
  `schoolsup` VARCHAR(1) NULL,
  `famsup` VARCHAR(1) NULL,
  `paid` VARCHAR(1) NULL,
  `internet` VARCHAR(1) NULL,
  PRIMARY KEY (`sid`),
  CONSTRAINT `supp_sid`
    FOREIGN KEY (`sid`)
    REFERENCES `stu_db`.`Med` (`sid`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stu_db`.`Alc`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stu_db`.`Alc` (
  `sid` INT NOT NULL,
  `Dalc` INT NULL,
  `Walc` INT NULL,
  PRIMARY KEY (`sid`),
  CONSTRAINT `alc_sid`
    FOREIGN KEY (`sid`)
    REFERENCES `stu_db`.`Med` (`sid`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stu_db`.`Math`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stu_db`.`Math` (
  `sid` INT NOT NULL,
  `mG1` INT NULL,
  `mG2` INT NULL,
  `mG3` INT NULL,
  PRIMARY KEY (`sid`),
  CONSTRAINT `math_sid`
    FOREIGN KEY (`sid`)
    REFERENCES `stu_db`.`Med` (`sid`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stu_db`.`Port`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stu_db`.`Port` (
  `sid` INT NOT NULL,
  `pG1` INT NULL,
  `pG2` INT NULL,
  `pG3` INT NULL,
  PRIMARY KEY (`sid`),
  CONSTRAINT `port_sid`
    FOREIGN KEY (`sid`)
    REFERENCES `stu_db`.`Med` (`sid`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
