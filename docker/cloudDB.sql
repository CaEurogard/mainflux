-- Adminer 4.7.1 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';


CREATE DATABASE `digitaix`;
CREATE DATABASE `nats`;
CREATE DATABASE `cloudDB`;
USE `cloudDB`;

DELIMITER ;;

DROP PROCEDURE IF EXISTS `only_changed_states`;;
CREATE PROCEDURE `only_changed_states`(IN `uuid_in` char(40), IN `val_in` int, IN `typ_in` int)
BEGIN
#SET @uuid = 1; # product id
#SET @val = 1; # new product price

insert into `Digitalwerte`(`uuid`,`timestamp`, `val`,`typ`)
select v.uuid, now(), v.val, typ_in as typ
from
(select uuid_in as `uuid`, val_in as `val`) as v
left outer join
(select uuid,val from `Digitalwerte` where `uuid`=uuid_in order by `id` desc limit 1) as p
on (v.uuid=p.uuid)
where
(p.val is null) or
(p.val <> v.val);
END;;

DELIMITER ;

DROP TABLE IF EXISTS `ChargenTexte`;
CREATE TABLE `ChargenTexte` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `DatZeit` datetime NOT NULL,
  `Thingid` char(36) NOT NULL,
  `KeyText` varchar(50) NOT NULL,
  `Text` tinytext NOT NULL,
  `Active` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `Digitalwerte`;
CREATE TABLE `Digitalwerte` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime DEFAULT NULL,
  `val` tinyint(4) DEFAULT NULL,
  `typ` tinyint(4) DEFAULT NULL COMMENT '0=meldung,1=störung',
  `uuid` char(36) NOT NULL,
  PRIMARY KEY (`id`,`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `Handling`;
CREATE TABLE `Handling` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `thingId` char(36) NOT NULL,
  `addressSpaceItem` varchar(100) NOT NULL,
  `Handlungsempfehlung` int(11) NOT NULL,
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `links`;
CREATE TABLE `links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `thingId` char(36) DEFAULT NULL,
  `channelId` char(36) DEFAULT NULL,
  `link` varchar(100) DEFAULT NULL,
  `machineId` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `Stoerungen`;
CREATE TABLE `Stoerungen` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Meldungsnr` int(11) NOT NULL,
  `Handlungsempfehlung` int(11) NOT NULL,
  `Deutsch` text NOT NULL,
  `Englisch` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `template`;
CREATE TABLE `template` (
  `uuid` char(36) NOT NULL,
  `label` varchar(100) NOT NULL,
  `metadata` varchar(100) DEFAULT NULL,
  `thingId` char(36) DEFAULT NULL,
  PRIMARY KEY (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- 2019-06-19 10:09:59
