-- MySQL Script generated by MySQL Workbench
-- dim. 08 mars 2020 23:37:35 CET
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema pyl_cartels
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema pyl_cartels
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pyl_cartels` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
USE `pyl_cartels` ;

-- -----------------------------------------------------
-- Table `pyl_cartels`.`individu`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pyl_cartels`.`individu` ;

CREATE TABLE IF NOT EXISTS `pyl_cartels`.`individu` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `prenom` VARCHAR(45) NULL,
  `ddn` DATE NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pyl_cartels`.`groupe`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pyl_cartels`.`groupe` ;

CREATE TABLE IF NOT EXISTS `pyl_cartels`.`groupe` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `budjet` INT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pyl_cartels`.`role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pyl_cartels`.`role` ;

CREATE TABLE IF NOT EXISTS `pyl_cartels`.`role` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(50) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pyl_cartels`.`territoire`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pyl_cartels`.`territoire` ;

CREATE TABLE IF NOT EXISTS `pyl_cartels`.`territoire` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(60) NOT NULL,
  `id_territoire_parent` INT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_territoire_parent`
    FOREIGN KEY (`id_territoire_parent`)
    REFERENCES `pyl_cartels`.`territoire` (`id`))
ENGINE = InnoDB;




-- -----------------------------------------------------
-- Table `pyl_cartels`.`lien_membre_groupe`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pyl_cartels`.`lien_membre_groupe` ;

CREATE TABLE IF NOT EXISTS `pyl_cartels`.`lien_membre_groupe` (
  `id_groupe` INT UNSIGNED NOT NULL,
  `id_individu` INT UNSIGNED NOT NULL,
  `id_role` INT UNSIGNED NOT NULL,
  `id_superieur_hierachique` INT UNSIGNED NULL DEFAULT NULL,
  `pseudo` VARCHAR(45) NULL,
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
  `updated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_groupe`, `id_individu`),
  UNIQUE INDEX (id),
  CONSTRAINT `fk_mb_grp_groupe`
    FOREIGN KEY (`id_groupe`)
    REFERENCES `pyl_cartels`.`groupe` (`id`),
  CONSTRAINT `fk_mb_grp_membre`
    FOREIGN KEY (`id_individu`)
    REFERENCES `pyl_cartels`.`individu` (`id`),
  CONSTRAINT `fk_mb_grp_role`
    FOREIGN KEY (`id_role`)
    REFERENCES `pyl_cartels`.`role` (`id`))
ENGINE = InnoDB;




-- -----------------------------------------------------
-- Table `pyl_cartels`.`interaction`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pyl_cartels`.`interaction` ;

CREATE TABLE IF NOT EXISTS `pyl_cartels`.`interaction` (
  `id_lien_membre_groupe1` INT UNSIGNED NOT NULL,
  `id_lien_membre_groupe2` INT UNSIGNED NOT NULL,
  `type` ENUM('hostile', 'neutre', 'commercial', 'cooperative') NOT NULL DEFAULT 'neutre',
  `description` TEXT NULL,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_lien_membre_groupe1`, `id_lien_membre_groupe2`),
  CONSTRAINT `fk_id_lien_membre_groupe1`
    FOREIGN KEY (`id_lien_membre_groupe1`)
    REFERENCES `pyl_cartels`.`lien_membre_groupe` (`id`),
  CONSTRAINT `fk_id_lien_membre_groupe2`
    FOREIGN KEY (`id_lien_membre_groupe2`)
    REFERENCES `pyl_cartels`.`lien_membre_groupe` (`id`))
ENGINE = InnoDB;




-- -----------------------------------------------------
-- Table `pyl_cartels`.`competence`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pyl_cartels`.`competence` ;

CREATE TABLE IF NOT EXISTS `pyl_cartels`.`competence` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pyl_cartels`.`type_relation_inter_groupe`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pyl_cartels`.`type_relation_inter_groupe` ;

CREATE TABLE IF NOT EXISTS `pyl_cartels`.`type_relation_inter_groupe` (
  `id_groupe1` INT UNSIGNED NOT NULL,
  `id_groupe2` INT UNSIGNED NOT NULL,
  `type_relation` ENUM('hostile', 'neutre', 'commercial', 'cooperative') NOT NULL DEFAULT 'neutre',
  `description` TEXT NULL,
  `updated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_groupe1`, `id_groupe2`),
  CONSTRAINT `fk_rel_int_groupe1`
    FOREIGN KEY (`id_groupe1`)
    REFERENCES `pyl_cartels`.`groupe` (`id`),
  CONSTRAINT `fk_rel_int_groupe2`
    FOREIGN KEY (`id_groupe2`)
    REFERENCES `pyl_cartels`.`groupe` (`id`))
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `pyl_cartels`.`lien_territoire_groupe`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pyl_cartels`.`lien_territoire_groupe` ;

CREATE TABLE IF NOT EXISTS `pyl_cartels`.`lien_territoire_groupe` (
  `id_territoire` INT UNSIGNED NOT NULL,
  `id_groupe` INT UNSIGNED NOT NULL,
  `type_lien` ENUM('democratique', 'domination', 'jalousie', 'aucun', 'origine') NULL DEFAULT 'aucun',
  `description` TEXT NULL,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_territoire`, `id_groupe`),
  CONSTRAINT `fk_lien_tg_territoire`
    FOREIGN KEY (`id_territoire`)
    REFERENCES `pyl_cartels`.`territoire` (`id`),
  CONSTRAINT `fk_lien_tg_groupe`
    FOREIGN KEY (`id_groupe`)
    REFERENCES `pyl_cartels`.`groupe` (`id`))
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `pyl_cartels`.`lien_individu_competence`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pyl_cartels`.`lien_individu_competence` ;

CREATE TABLE IF NOT EXISTS `pyl_cartels`.`lien_individu_competence` (
  `id_individu` INT UNSIGNED NOT NULL,
  `id_competence` INT UNSIGNED NOT NULL,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_individu`, `id_competence`),
  CONSTRAINT `fk_ind_comp_individu`
    FOREIGN KEY (`id_individu`)
    REFERENCES `pyl_cartels`.`individu` (`id`),
  CONSTRAINT `fk_ind_comp_competence`
    FOREIGN KEY (`id_competence`)
    REFERENCES `pyl_cartels`.`competence` (`id`))
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `pyl_cartels`.`point_faible`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pyl_cartels`.`point_faible` ;

CREATE TABLE IF NOT EXISTS `pyl_cartels`.`point_faible` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pyl_cartels`.`lien_point_faible_individu`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pyl_cartels`.`lien_point_faible_individu` ;

CREATE TABLE IF NOT EXISTS `pyl_cartels`.`lien_point_faible_individu` (
  `id_individu` INT UNSIGNED NOT NULL,
  `id_point_faible` INT UNSIGNED NOT NULL,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_individu`, `id_point_faible`),
  CONSTRAINT `fk_pt_ind_point_faible`
    FOREIGN KEY (`id_point_faible`)
    REFERENCES `pyl_cartels`.`point_faible` (`id`),
  CONSTRAINT `fk_pt_ind_individu`
    FOREIGN KEY (`id_individu`)
    REFERENCES `pyl_cartels`.`individu` (`id`))
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `pyl_cartels`.`ressource`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pyl_cartels`.`ressource` ;

CREATE TABLE IF NOT EXISTS `pyl_cartels`.`ressource` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(60) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pyl_cartels`.`lien_rss_territoire`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pyl_cartels`.`lien_rss_territoire` ;

CREATE TABLE IF NOT EXISTS `pyl_cartels`.`lien_rss_territoire` (
  `id_ressource` INT UNSIGNED NOT NULL,
  `id_territoire` INT UNSIGNED NOT NULL,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_ressource`, `id_territoire`),
  CONSTRAINT `fk_rss_ter_territoire`
    FOREIGN KEY (`id_territoire`)
    REFERENCES `pyl_cartels`.`territoire` (`id`),
  CONSTRAINT `fk_rss_ter_rss`
    FOREIGN KEY (`id_ressource`)
    REFERENCES `pyl_cartels`.`ressource` (`id`))
ENGINE = InnoDB;

CREATE INDEX `fk_id_territoire_idx` ON `pyl_cartels`.`lien_rss_territoire` (`id_territoire` ASC);
CREATE INDEX `fk_point_faible_idx` ON `pyl_cartels`.`lien_point_faible_individu` (`id_point_faible` ASC);
CREATE INDEX `pk_competence_idx` ON `pyl_cartels`.`lien_individu_competence` (`id_competence` ASC);
CREATE INDEX `fk_groupe_idx` ON `pyl_cartels`.`lien_territoire_groupe` (`id_groupe` ASC);
CREATE INDEX `fk_groupe2_idx` ON `pyl_cartels`.`type_relation_inter_groupe` (`id_groupe2` ASC);
CREATE INDEX `fk_territoire_parent_idx` ON `pyl_cartels`.`territoire` (`id_territoire_parent` ASC);
CREATE INDEX `fk_role_idx` ON `pyl_cartels`.`lien_membre_groupe` (`id_role` ASC);
CREATE INDEX `fk_groupe_idx` ON `pyl_cartels`.`lien_membre_groupe` (`id_groupe` ASC);
CREATE INDEX `fk_individu2_idx` ON `pyl_cartels`.`interaction` (`id_lien_membre_groupe2` ASC);



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;