/*
◦ Año: 2021
◦ Grupo: 06
◦ Integrantes: María Campoo -  Juan Ig. Burgos
◦ Tema: Amdinistracion del Alquiler de Canchas de Futbol
◦ Nombre del Esquema: lbd2021g06tp01cancha
◦ Plataforma (SO) y versión: Windows 10 Enterprise (64 bits)
◦ Motor y versión: MySql 8.0.16
◦ GitHub Repositorio: https://github.com/JuanIBurgos/LBD2021G06.git
◦ GitHub Usuario:  https://github.com/JuanIBurgos
*/

-- -----------------------------------------------------
-- Schema LBD2021G06TP1Cancha
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `LBD2021G06TP1Cancha` ;

-- -----------------------------------------------------
-- Schema LBD2021G06TP1Cancha
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LBD2021G06TP1Cancha` DEFAULT CHARACTER SET utf8 ;
USE `LBD2021G06TP1Cancha` ;

-- -----------------------------------------------------
-- Table `PERSONAS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PERSONAS` ;

CREATE TABLE IF NOT EXISTS `PERSONAS` (
  `DNI` INT NOT NULL,
  `Apellidos` VARCHAR(25) NOT NULL,
  `Nombres` VARCHAR(25) NOT NULL,
  `CorreoElectronico` VARCHAR(50) NOT NULL,
  `Telefono` VARCHAR(12) NOT NULL,
  `Direccion` VARCHAR(50) NOT NULL,
  `Estado` CHAR(1) NOT NULL,
  PRIMARY KEY (`DNI`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `UX_DNI` ON `PERSONAS` (`DNI` ASC) VISIBLE;

CREATE INDEX `IX_Apellidos_UNIQUE` ON `PERSONAS` (`Apellidos` ASC) INVISIBLE;

CREATE INDEX `IX_Estado` ON `PERSONAS` (`Estado` ASC) INVISIBLE;


-- -----------------------------------------------------
-- Table `TORNEOS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TORNEOS` ;

CREATE TABLE IF NOT EXISTS `TORNEOS` (
  `idTorneos` INT NOT NULL,
  `Nombre` VARCHAR(45) NOT NULL,
  `Categorias` VARCHAR(45) NOT NULL,
  `CantidadDeEquipos` INT CHECK (`CantidadDeEquipos`>4),
  PRIMARY KEY (`idTorneos`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `UX_Nombre` ON `TORNEOS` (`Nombre` ASC) INVISIBLE;


-- -----------------------------------------------------
-- Table `EQUIPOS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EQUIPOS` ;

CREATE TABLE IF NOT EXISTS `EQUIPOS` (
  `idEquipos` INT NOT NULL,
  `idTorneos` INT NOT NULL,
  `Nombre` VARCHAR(45) NOT NULL,
  `CantidadDeJugadores` INT NOT NULL CHECK (`CantidadDeJugadores`>5),
  PRIMARY KEY (`idEquipos`, `idTorneos`),
  CONSTRAINT `fk_EQUIPOS_TORNEOS1`
    FOREIGN KEY (`idTorneos`)
    REFERENCES `TORNEOS` (`idTorneos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `Nombre_UNIQUE` ON `EQUIPOS` (`Nombre` ASC) VISIBLE;

CREATE INDEX `fk_EQUIPOS_TORNEOS1_idx` ON `EQUIPOS` (`idTorneos` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `CLIENTES`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CLIENTES` ;

CREATE TABLE IF NOT EXISTS `CLIENTES` (
  `DNI` INT NOT NULL,
  `FechaDeAlta` DATETIME NOT NULL DEFAULT current_timestamp,
  `Tipo` VARCHAR(5) NOT NULL,
  `EQUIPOS_idEquipos` INT NOT NULL,
  `EQUIPOS_idTorneos` INT NOT NULL,
  PRIMARY KEY (`DNI`, `EQUIPOS_idEquipos`, `EQUIPOS_idTorneos`),
  CONSTRAINT `fk_CLIENTES_PERSONAS1`
    FOREIGN KEY (`DNI`)
    REFERENCES `PERSONAS` (`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CLIENTES_EQUIPOS1`
    FOREIGN KEY (`EQUIPOS_idEquipos` , `EQUIPOS_idTorneos`)
    REFERENCES `EQUIPOS` (`idEquipos` , `idTorneos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_CLIENTES_EQUIPOS1_idx` ON `CLIENTES` (`EQUIPOS_idEquipos` ASC, `EQUIPOS_idTorneos` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `ADMINISTRADORES`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ADMINISTRADORES` ;

CREATE TABLE IF NOT EXISTS `ADMINISTRADORES` (
  `DNI` INT NOT NULL,
  `idTorneos` INT NOT NULL,
  `CUIT` VARCHAR(13) NOT NULL,
  PRIMARY KEY (`DNI`, `idTorneos`),
  CONSTRAINT `fk_ADMINISTRADORES_PERSONAS1`
    FOREIGN KEY (`DNI`)
    REFERENCES `PERSONAS` (`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ADMINISTRADORES_TORNEOS1`
    FOREIGN KEY (`idTorneos`)
    REFERENCES `TORNEOS` (`idTorneos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `CUIT_UNIQUE` ON `ADMINISTRADORES` (`CUIT` ASC) VISIBLE;

CREATE INDEX `fk_ADMINISTRADORES_TORNEOS1_idx` ON `ADMINISTRADORES` (`idTorneos` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `PERSONALDEMANTENIMIENTO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PERSONALDEMANTENIMIENTO` ;

CREATE TABLE IF NOT EXISTS `PERSONALDEMANTENIMIENTO` (
  `DNI` INT NOT NULL,
  `CUIT` VARCHAR(13) NOT NULL,
  PRIMARY KEY (`DNI`),
  CONSTRAINT `fk_PERSONALDEMANTENIMIENTO_PERSONAS`
    FOREIGN KEY (`DNI`)
    REFERENCES `PERSONAS` (`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `CUIT_UNIQUE` ON `PERSONALDEMANTENIMIENTO` (`CUIT` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `CANCHAS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CANCHAS` ;

CREATE TABLE IF NOT EXISTS `CANCHAS` (
  `idCanchas` TINYINT(2) NOT NULL,
  `Numero` TINYINT(2) NOT NULL,
  `Tamanio` CHAR(1) NOT NULL,
  `Observaciones` VARCHAR(255) NULL,
  PRIMARY KEY (`idCanchas`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `UX_Numero` ON `CANCHAS` (`Numero` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `MANTENIMIENTOS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MANTENIMIENTOS` ;

CREATE TABLE IF NOT EXISTS `MANTENIMIENTOS` (
  `idMantenimientos` INT NOT NULL,
  `idCanchas` TINYINT(2) NOT NULL,
  `DNI` INT NOT NULL,
  `Estado` CHAR(1) NOT NULL,
  `Descripcion` VARCHAR(255) NOT NULL,
  `FechaDeReporte` DATETIME NOT NULL DEFAULT current_timestamp,
  `FechaDelArreglo` DATETIME NULL,
  `Observaciones` VARCHAR(255) NULL,
  PRIMARY KEY (`idMantenimientos`),
  CONSTRAINT `fk_MANTENIMIENTOS_CANCHAS1`
    FOREIGN KEY (`idCanchas`)
    REFERENCES `CANCHAS` (`idCanchas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MANTENIMIENTOS_PERSONALDEMANTENIMIENTO1`
    FOREIGN KEY (`DNI`)
    REFERENCES `PERSONALDEMANTENIMIENTO` (`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `IX_Estado` ON `MANTENIMIENTOS` (`Estado` ASC) VISIBLE;

CREATE INDEX `fk_MANTENIMIENTOS_CANCHAS1_idx` ON `MANTENIMIENTOS` (`idCanchas` ASC) VISIBLE;

CREATE INDEX `fk_MANTENIMIENTOS_PERSONALDEMANTENIMIENTO1_idx` ON `MANTENIMIENTOS` (`DNI` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `TURNOS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TURNOS` ;

CREATE TABLE IF NOT EXISTS `TURNOS` (
  `idTurnos` INT NOT NULL,
  `idCanchas` TINYINT(2) NOT NULL,
  `DNI` INT NOT NULL,
  `ADMINISTRADORES_DNI` INT NOT NULL,
  `idTorneos` INT NOT NULL,
  `Fecha` DATETIME NOT NULL,
  `HorarioInicio` DATETIME NOT NULL,
  `HorarioFin` DATETIME NOT NULL,
  `Estado` CHAR(1) NOT NULL,
  `Observaciones` VARCHAR(255) NULL,
  PRIMARY KEY (`idTurnos`, `idCanchas`, `DNI`, `ADMINISTRADORES_DNI`, `idTorneos`),
  CONSTRAINT `fk_TURNOS_CANCHAS1`
    FOREIGN KEY (`idCanchas`)
    REFERENCES `CANCHAS` (`idCanchas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TURNOS_CLIENTES1`
    FOREIGN KEY (`DNI`)
    REFERENCES `CLIENTES` (`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TURNOS_ADMINISTRADORES1`
    FOREIGN KEY (`ADMINISTRADORES_DNI`)
    REFERENCES `ADMINISTRADORES` (`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TURNOS_TORNEOS1`
    FOREIGN KEY (`idTorneos`)
    REFERENCES `TORNEOS` (`idTorneos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_TURNOS_CANCHAS1_idx` ON `TURNOS` (`idCanchas` ASC) VISIBLE;

CREATE INDEX `fk_TURNOS_CLIENTES1_idx` ON `TURNOS` (`DNI` ASC) VISIBLE;

CREATE INDEX `fk_TURNOS_ADMINISTRADORES1_idx` ON `TURNOS` (`ADMINISTRADORES_DNI` ASC) VISIBLE;

CREATE INDEX `fk_TURNOS_TORNEOS1_idx` ON `TURNOS` (`idTorneos` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `PAGO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PAGO` ;

CREATE TABLE IF NOT EXISTS `PAGO` (
  `idPago` INT NOT NULL,
  `TURNOS_idTurnos` INT NOT NULL,
  `TURNOS_DNI` INT NOT NULL,
  `TURNOS_idCanchas` TINYINT(2) NOT NULL,
  `TURNOS_ADMINISTRADORES_DNI` INT NOT NULL,
  `TURNOS_idTorneos` INT NOT NULL,
  `Fecha` DATETIME NOT NULL,
  `Monto` DECIMAL(10,2) NOT NULL,
  `Estado` CHAR(1) NOT NULL,
  `Observaciones` VARCHAR(255) NULL,
  PRIMARY KEY (`idPago`, `TURNOS_idTurnos`, `TURNOS_DNI`, `TURNOS_idCanchas`, `TURNOS_ADMINISTRADORES_DNI`, `TURNOS_idTorneos`),
  CONSTRAINT `fk_PAGO_TURNOS1`
    FOREIGN KEY (`TURNOS_idTurnos` , `TURNOS_idCanchas` , `TURNOS_DNI` , `TURNOS_ADMINISTRADORES_DNI` , `TURNOS_idTorneos`)
    REFERENCES `TURNOS` (`idTurnos` , `idCanchas` , `DNI` , `ADMINISTRADORES_DNI` , `idTorneos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_PAGO_TURNOS1_idx` ON `PAGO` (`TURNOS_idTurnos` ASC, `TURNOS_idCanchas` ASC, `TURNOS_DNI` ASC, `TURNOS_ADMINISTRADORES_DNI` ASC, `TURNOS_idTorneos` ASC) VISIBLE;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- Comenzamos a colmar las tablas de valores
INSERT INTO `PERSONAS` VALUES(32365441, 'Burgos', 'Juan Ignacio','juanburgos86b@gmail.com','42415474','Av. Mate de Luna 1402','A');
INSERT INTO `PERSONAS` VALUES(38762512, 'Campoo', 'Maria de los Angeles','mariacampoo@gmail.com','4221589','Av.Sarmiento 757','A');
INSERT INTO `PERSONAS` VALUES(31733814, 'Beridio', 'Jose Manuel','beri86b@gmail.com','422535314','Av. Alem 14','A');
INSERT INTO `PERSONAS` VALUES(42386541, 'Juarez', 'Delia','leilu28@hotmail.com','43654172','Marcos Paz 500','B');
INSERT INTO `PERSONAS` VALUES(40232314, 'Santolaya', 'Juan Diego','santiSantolaya@gmail.com','45303168','San lorenzo 427','A');
INSERT INTO `PERSONAS` VALUES(43059810, 'Barrionuevo', 'Marta ','mBarrionuevo@gmail.com','44235415','Av. Vascardy','B');
INSERT INTO `PERSONAS` VALUES(44862456, 'Galleguillo', 'Sergio','elgallo@gmail.com','4363513','Av. Mate de Luna 1402','A');
INSERT INTO `PERSONAS` VALUES(45733814, 'Gallina', 'Pablo','pablogal@gmail.com','4317513','Av. Mate de Luna 1402','A');
INSERT INTO `PERSONAS` VALUES(35103314, 'Salinas', 'Juan Pablo','juanSalina@gmail.com','4273513','Rivadavia 1230','A');
INSERT INTO `PERSONAS` VALUES(36817934, 'Zapata', 'Pablo Exequiel','pablozapata@hotmail.com','4251033','Benjamin Matienzo 402','A');

INSERT INTO `PERSONAS` VALUES(31351789, 'Mirabal', 'Solange','smirabal@gmail.com','45135133','La acacias 135','A');
INSERT INTO `PERSONAS` VALUES(45733814, 'Gallina', 'Pablo','pablogal@gmail.com','43513','Av. Mate de Luna 1402','A');
INSERT INTO `PERSONAS` VALUES(44124598, 'Pedraza', 'Paula Solange','paupedraza@gmail.com','430294567','Rioja 451','A');
INSERT INTO `PERSONAS` VALUES(45723814, 'Di Santi', 'Santiago','DisantiFlass@gmail.com','43513','Pasajes Las Rosas 26','A');
INSERT INTO `PERSONAS` VALUES(44125048, 'Martinez', 'Paulo','pauloMartinez35@gmail.com','431894678','Republica del Libano 451','A');
INSERT INTO `PERSONAS` VALUES(45824817, 'Barboza', 'Segio','sergioB93@gmail.com','4237814','Pasaje Padilla 26','A');
INSERT INTO `PERSONAS` VALUES(44137854, 'Osores', 'Maria Paula','pauosores23@gmail.com','45130465','Marcos Paz 1525','A');
INSERT INTO `PERSONAS` VALUES(45148245, 'Pauli', 'Sandra','sandraPauli@gmail.com','4241589','Colon 1026','A');
INSERT INTO `PERSONAS` VALUES(42481692, 'Cardozo', 'Francisco','pachocardozo@gmail.com','4241874','Indepoendencia 1828','A');
INSERT INTO `PERSONAS` VALUES(45158147, 'Martinez', 'Cesar','cesarm461@gmail.com','43457895','Rivadavia 1250','A');
SELECT * FROM `PERSONAS`;

-- Ingresamos las canchas tenemos 5 canchas
INSERT INTO `CANCHAS` VALUES (1,1 ,"M","Con cesped sintetico - techada");
INSERT INTO `CANCHAS` VALUES (2,2 ,"G","Con cesped sintetico - techada");
INSERT INTO `CANCHAS` VALUES (3,3 ,"C","Con cesped sintetico - aire libre");
INSERT INTO `CANCHAS` VALUES (4,4 ,"G","Con cesped sintetico - techada - iluminada");
INSERT INTO `CANCHAS` VALUES (5,5 ,"M","Con cesped sintetico - techada - iluminada");
SELECT * FROM `CANCHAS`;

-- Definimos los torneos
DELETE FROM `TORNEOS` WHERE `idTorneos`=3;
INSERT INTO `TORNEOS` VALUES (2,"Cebollitas","Jovenes",6);
INSERT INTO `TORNEOS` VALUES (3,"Picapiedras","Ninios",8);
SELECT * FROM `TORNEOS`;