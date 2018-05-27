# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.20)
# Database: ethz
# Generation Time: 2018-05-27 05:32:15 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table accounts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `accounts`;

CREATE TABLE `accounts` (
  `uid` bigint(11) NOT NULL COMMENT '用户id',
  `currency` int(10) unsigned NOT NULL COMMENT '货币id',
  `balance` decimal(32,18) NOT NULL DEFAULT '0.000000000000000000' COMMENT '余额',
  `locked` decimal(32,18) NOT NULL DEFAULT '0.000000000000000000' COMMENT '锁定额',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`uid`,`currency`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户账户';

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;

INSERT INTO `accounts` (`uid`, `currency`, `balance`, `locked`, `created_at`, `updated_at`)
VALUES
	(4,1,997.000000000000000000,0.000000000000000000,'2018-05-26 11:07:48','2018-05-26 19:18:50');

/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table accounts_details
# ------------------------------------------------------------

DROP TABLE IF EXISTS `accounts_details`;

CREATE TABLE `accounts_details` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` bigint(11) NOT NULL COMMENT '用户id',
  `currency` int(10) unsigned NOT NULL COMMENT '货币id',
  `type` tinyint(4) NOT NULL COMMENT '类型，1：充币，2：交易买入，0：系统操作，-1：提币，-2：交易卖出，3：竞猜',
  `change_balance` decimal(32,18) NOT NULL COMMENT '变动额',
  `target_id` int(11) unsigned DEFAULT '0' COMMENT '订单ID',
  `balance` decimal(32,18) NOT NULL COMMENT '变动后余额',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `uid_currency` (`uid`,`currency`) USING BTREE,
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户账户明细';

LOCK TABLES `accounts_details` WRITE;
/*!40000 ALTER TABLE `accounts_details` DISABLE KEYS */;

INSERT INTO `accounts_details` (`id`, `uid`, `currency`, `type`, `change_balance`, `target_id`, `balance`, `remark`, `created_at`)
VALUES
	(1,4,1,3,1.000000000000000000,1,1001.000000000000000000,'竞猜：1 ETH','2018-05-26 11:18:26'),
	(2,4,1,3,1.000000000000000000,2,1000.000000000000000000,'竞猜：1 ETH','2018-05-26 11:19:01'),
	(3,4,1,3,1.000000000000000000,3,999.000000000000000000,'竞猜：1 ETH','2018-05-26 11:19:07');

/*!40000 ALTER TABLE `accounts_details` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table admin_menu
# ------------------------------------------------------------

DROP TABLE IF EXISTS `admin_menu`;

CREATE TABLE `admin_menu` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL DEFAULT '0',
  `order` int(11) NOT NULL DEFAULT '0',
  `title` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `uri` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `admin_menu` WRITE;
/*!40000 ALTER TABLE `admin_menu` DISABLE KEYS */;

INSERT INTO `admin_menu` (`id`, `parent_id`, `order`, `title`, `icon`, `uri`, `created_at`, `updated_at`)
VALUES
	(1,0,1,'Index','fa-bar-chart','/',NULL,NULL),
	(2,0,9,'系统管理','fa-tasks',NULL,NULL,'2018-05-18 06:45:52'),
	(3,2,10,'管理员','fa-users','auth/users',NULL,'2018-05-18 06:45:41'),
	(4,2,11,'角色管理','fa-user','auth/roles',NULL,'2018-05-18 06:45:41'),
	(5,2,12,'权限管理','fa-ban','auth/permissions',NULL,'2018-05-18 06:45:41'),
	(6,2,13,'后台菜单','fa-bars','auth/menu',NULL,'2018-05-18 06:45:41'),
	(7,2,14,'操作日志','fa-history','auth/logs',NULL,'2018-05-18 06:45:41'),
	(8,0,2,'运营管理','fa-align-justify',NULL,'2018-05-18 05:57:49','2018-05-18 06:45:40'),
	(9,8,3,'币种管理','fa-bars','currency','2018-05-18 05:58:39','2018-05-18 06:45:40'),
	(10,8,4,'充值管理','fa-btc','deposits/currency','2018-05-18 06:24:52','2018-05-18 06:45:41'),
	(11,8,5,'补单管理','fa-bars','deposits/create','2018-05-18 06:35:04','2018-05-18 06:45:41'),
	(12,8,6,'提现管理','fa-btc','withdraws/currency','2018-05-18 06:44:06','2018-05-18 06:45:41'),
	(13,0,7,'用户管理','fa-bars',NULL,'2018-05-18 06:44:26','2018-05-18 06:45:41'),
	(14,13,8,'会员管理','fa-user','user','2018-05-18 06:45:32','2018-05-18 06:45:41'),
	(15,0,15,'Api tester','fa-sliders','api-tester','2018-05-25 01:33:13','2018-05-25 01:33:13');

/*!40000 ALTER TABLE `admin_menu` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table admin_operation_log
# ------------------------------------------------------------

DROP TABLE IF EXISTS `admin_operation_log`;

CREATE TABLE `admin_operation_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `method` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `input` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_operation_log_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `admin_operation_log` WRITE;
/*!40000 ALTER TABLE `admin_operation_log` DISABLE KEYS */;

INSERT INTO `admin_operation_log` (`id`, `user_id`, `path`, `method`, `ip`, `input`, `created_at`, `updated_at`)
VALUES
	(1,1,'admin','GET','127.0.0.1','[]','2018-05-18 04:56:36','2018-05-18 04:56:36'),
	(2,1,'admin','GET','127.0.0.1','[]','2018-05-18 05:01:54','2018-05-18 05:01:54'),
	(3,1,'admin/auth/menu','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 05:02:30','2018-05-18 05:02:30'),
	(4,1,'admin/auth/menu/1/edit','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 05:02:39','2018-05-18 05:02:39'),
	(5,1,'admin/auth/menu','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 05:02:42','2018-05-18 05:02:42'),
	(6,1,'admin/auth/users','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 05:02:45','2018-05-18 05:02:45'),
	(7,1,'admin/auth/users/1/edit','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 05:02:48','2018-05-18 05:02:48'),
	(8,1,'admin/auth/users','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 05:02:52','2018-05-18 05:02:52'),
	(9,1,'admin/auth/users','GET','127.0.0.1','[]','2018-05-18 05:02:54','2018-05-18 05:02:54'),
	(10,1,'admin/auth/users','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 05:02:59','2018-05-18 05:02:59'),
	(11,1,'admin/auth/users/1/edit','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 05:03:01','2018-05-18 05:03:01'),
	(12,1,'admin/auth/users/1/edit','GET','127.0.0.1','[]','2018-05-18 05:04:09','2018-05-18 05:04:09'),
	(13,1,'admin/auth/users/1/edit','GET','127.0.0.1','[]','2018-05-18 05:04:32','2018-05-18 05:04:32'),
	(14,1,'admin/auth/users','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 05:04:49','2018-05-18 05:04:49'),
	(15,1,'admin/auth/menu','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 05:04:56','2018-05-18 05:04:56'),
	(16,1,'admin/auth/menu/1/edit','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 05:04:59','2018-05-18 05:04:59'),
	(17,1,'admin/auth/menu','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 05:05:04','2018-05-18 05:05:04'),
	(18,1,'admin/auth/menu/3/edit','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 05:05:08','2018-05-18 05:05:08'),
	(19,1,'admin/auth/menu/3','PUT','127.0.0.1','{\"parent_id\":\"2\",\"title\":\"\\u7ba1\\u7406\\u5458\",\"icon\":\"fa-users\",\"uri\":\"auth\\/users\",\"roles\":[null],\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\",\"_method\":\"PUT\",\"_previous_\":\"http:\\/\\/guess.me\\/admin\\/auth\\/menu\"}','2018-05-18 05:05:23','2018-05-18 05:05:23'),
	(20,1,'admin/auth/menu','GET','127.0.0.1','[]','2018-05-18 05:05:23','2018-05-18 05:05:23'),
	(21,1,'admin/auth/menu/4/edit','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 05:05:27','2018-05-18 05:05:27'),
	(22,1,'admin/auth/menu/4','PUT','127.0.0.1','{\"parent_id\":\"2\",\"title\":\"\\u89d2\\u8272\\u7ba1\\u7406\",\"icon\":\"fa-user\",\"uri\":\"auth\\/roles\",\"roles\":[null],\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\",\"_method\":\"PUT\",\"_previous_\":\"http:\\/\\/guess.me\\/admin\\/auth\\/menu\"}','2018-05-18 05:05:36','2018-05-18 05:05:36'),
	(23,1,'admin/auth/menu','GET','127.0.0.1','[]','2018-05-18 05:05:37','2018-05-18 05:05:37'),
	(24,1,'admin/auth/menu/5/edit','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 05:05:40','2018-05-18 05:05:40'),
	(25,1,'admin/auth/menu/5','PUT','127.0.0.1','{\"parent_id\":\"2\",\"title\":\"\\u6743\\u9650\\u7ba1\\u7406\",\"icon\":\"fa-ban\",\"uri\":\"auth\\/permissions\",\"roles\":[null],\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\",\"_method\":\"PUT\",\"_previous_\":\"http:\\/\\/guess.me\\/admin\\/auth\\/menu\"}','2018-05-18 05:05:48','2018-05-18 05:05:48'),
	(26,1,'admin/auth/menu','GET','127.0.0.1','[]','2018-05-18 05:05:49','2018-05-18 05:05:49'),
	(27,1,'admin/auth/menu/6/edit','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 05:05:52','2018-05-18 05:05:52'),
	(28,1,'admin/auth/menu/6','PUT','127.0.0.1','{\"parent_id\":\"2\",\"title\":\"\\u540e\\u53f0\\u83dc\\u5355\",\"icon\":\"fa-bars\",\"uri\":\"auth\\/menu\",\"roles\":[null],\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\",\"_method\":\"PUT\",\"_previous_\":\"http:\\/\\/guess.me\\/admin\\/auth\\/menu\"}','2018-05-18 05:06:07','2018-05-18 05:06:07'),
	(29,1,'admin/auth/menu','GET','127.0.0.1','[]','2018-05-18 05:06:07','2018-05-18 05:06:07'),
	(30,1,'admin/auth/menu/7/edit','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 05:06:10','2018-05-18 05:06:10'),
	(31,1,'admin/auth/menu/7','PUT','127.0.0.1','{\"parent_id\":\"2\",\"title\":\"\\u64cd\\u4f5c\\u65e5\\u5fd7\",\"icon\":\"fa-history\",\"uri\":\"auth\\/logs\",\"roles\":[null],\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\",\"_method\":\"PUT\",\"_previous_\":\"http:\\/\\/guess.me\\/admin\\/auth\\/menu\"}','2018-05-18 05:06:20','2018-05-18 05:06:20'),
	(32,1,'admin/auth/menu','GET','127.0.0.1','[]','2018-05-18 05:06:20','2018-05-18 05:06:20'),
	(33,1,'admin/auth/menu/2/edit','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 05:06:24','2018-05-18 05:06:24'),
	(34,1,'admin/auth/menu/2','PUT','127.0.0.1','{\"parent_id\":\"0\",\"title\":\"\\u540e\\u53f0\\u7ba1\\u7406\",\"icon\":\"fa-tasks\",\"uri\":null,\"roles\":[\"1\",null],\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\",\"_method\":\"PUT\",\"_previous_\":\"http:\\/\\/guess.me\\/admin\\/auth\\/menu\"}','2018-05-18 05:06:31','2018-05-18 05:06:31'),
	(35,1,'admin/auth/menu','GET','127.0.0.1','[]','2018-05-18 05:06:32','2018-05-18 05:06:32'),
	(36,1,'admin/auth/menu','GET','127.0.0.1','[]','2018-05-18 05:37:10','2018-05-18 05:37:10'),
	(37,1,'admin/auth/menu','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 05:57:38','2018-05-18 05:57:38'),
	(38,1,'admin/auth/menu','POST','::1','{\"parent_id\":\"0\",\"title\":\"\\u8fd0\\u8425\\u7ba1\\u7406\",\"icon\":\"fa-align-justify\",\"uri\":null,\"roles\":[null],\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\"}','2018-05-18 05:57:48','2018-05-18 05:57:48'),
	(39,1,'admin/auth/menu','GET','::1','[]','2018-05-18 05:57:49','2018-05-18 05:57:49'),
	(40,1,'admin/auth/menu','POST','::1','{\"parent_id\":\"6\",\"title\":\"\\u5e01\\u79cd\\u7ba1\\u7406\",\"icon\":\"fa-bars\",\"uri\":\"currency\",\"roles\":[null],\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\"}','2018-05-18 05:58:38','2018-05-18 05:58:38'),
	(41,1,'admin/auth/menu','GET','::1','[]','2018-05-18 05:58:39','2018-05-18 05:58:39'),
	(42,1,'admin/auth/menu','POST','::1','{\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\",\"_order\":\"[{\\\"id\\\":1},{\\\"id\\\":2,\\\"children\\\":[{\\\"id\\\":3},{\\\"id\\\":4},{\\\"id\\\":5},{\\\"id\\\":6},{\\\"id\\\":7}]},{\\\"id\\\":8,\\\"children\\\":[{\\\"id\\\":9}]}]\"}','2018-05-18 05:58:49','2018-05-18 05:58:49'),
	(43,1,'admin/auth/menu','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 05:58:50','2018-05-18 05:58:50'),
	(44,1,'admin/auth/menu','GET','::1','[]','2018-05-18 06:02:22','2018-05-18 06:02:22'),
	(45,1,'admin/currency','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 06:02:25','2018-05-18 06:02:25'),
	(46,1,'admin/currency','GET','::1','[]','2018-05-18 06:02:26','2018-05-18 06:02:26'),
	(47,1,'admin/currency','GET','::1','[]','2018-05-18 06:03:39','2018-05-18 06:03:39'),
	(48,1,'admin/currency','GET','::1','[]','2018-05-18 06:05:08','2018-05-18 06:05:08'),
	(49,1,'admin/currency','GET','::1','[]','2018-05-18 06:06:29','2018-05-18 06:06:29'),
	(50,1,'admin/currency','GET','::1','[]','2018-05-18 06:08:33','2018-05-18 06:08:33'),
	(51,1,'admin/currency/1','PUT','::1','{\"status\":\"off\",\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\",\"_method\":\"PUT\"}','2018-05-18 06:08:38','2018-05-18 06:08:38'),
	(52,1,'admin/currency','GET','::1','[]','2018-05-18 06:08:43','2018-05-18 06:08:43'),
	(53,1,'admin/currency/1/edit','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 06:08:50','2018-05-18 06:08:50'),
	(54,1,'admin/currency','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 06:12:42','2018-05-18 06:12:42'),
	(55,1,'admin/currency/7','DELETE','::1','{\"_method\":\"delete\",\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\"}','2018-05-18 06:12:46','2018-05-18 06:12:46'),
	(56,1,'admin/currency/7','DELETE','::1','{\"_method\":\"delete\",\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\"}','2018-05-18 06:12:48','2018-05-18 06:12:48'),
	(57,1,'admin/currency/7','DELETE','::1','{\"_method\":\"delete\",\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\"}','2018-05-18 06:12:54','2018-05-18 06:12:54'),
	(58,1,'admin/currency/7','DELETE','::1','{\"_method\":\"delete\",\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\"}','2018-05-18 06:14:42','2018-05-18 06:14:42'),
	(59,1,'admin/currency/7','DELETE','::1','{\"_method\":\"delete\",\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\"}','2018-05-18 06:15:22','2018-05-18 06:15:22'),
	(60,1,'admin/currency','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 06:15:23','2018-05-18 06:15:23'),
	(61,1,'admin/currency/5','DELETE','::1','{\"_method\":\"delete\",\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\"}','2018-05-18 06:16:34','2018-05-18 06:16:34'),
	(62,1,'admin/currency','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 06:16:34','2018-05-18 06:16:34'),
	(63,1,'admin/currency/4','DELETE','::1','{\"_method\":\"delete\",\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\"}','2018-05-18 06:16:38','2018-05-18 06:16:38'),
	(64,1,'admin/currency','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 06:16:39','2018-05-18 06:16:39'),
	(65,1,'admin/currency/3','DELETE','::1','{\"_method\":\"delete\",\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\"}','2018-05-18 06:16:42','2018-05-18 06:16:42'),
	(66,1,'admin/currency','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 06:16:43','2018-05-18 06:16:43'),
	(67,1,'admin/currency/1','DELETE','::1','{\"_method\":\"delete\",\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\"}','2018-05-18 06:16:46','2018-05-18 06:16:46'),
	(68,1,'admin/currency','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 06:16:47','2018-05-18 06:16:47'),
	(69,1,'admin/currency','GET','::1','[]','2018-05-18 06:17:11','2018-05-18 06:17:11'),
	(70,1,'admin/currency/1/edit','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 06:17:17','2018-05-18 06:17:17'),
	(71,1,'admin/currency/1','PUT','::1','{\"code\":\"ETH\",\"name\":\"\\u4ee5\\u592a\\u5e01\",\"is_virtual\":\"on\",\"is_base_currency\":\"on\",\"status\":\"on\",\"decimals\":\"18\",\"min_trading_val\":\"0.00001000\",\"trading_service_rate\":\"0.00100000\",\"withdraw_service_charge\":\"0.00001000\",\"fee\":\"0.000000008897163264\",\"enable_deposit\":\"on\",\"enable_withdraw\":\"on\",\"up_number_audit\":null,\"extract_number_audit\":\"100.00000000\",\"transfer_number\":null,\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\",\"_method\":\"PUT\",\"_previous_\":\"http:\\/\\/guess.me\\/admin\\/currency\"}','2018-05-18 06:21:50','2018-05-18 06:21:50'),
	(72,1,'admin/currency','GET','::1','[]','2018-05-18 06:21:50','2018-05-18 06:21:50'),
	(73,1,'admin/currency/1/edit','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 06:21:53','2018-05-18 06:21:53'),
	(74,1,'admin/currency','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 06:23:18','2018-05-18 06:23:18'),
	(75,1,'admin/auth/menu','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 06:23:22','2018-05-18 06:23:22'),
	(76,1,'admin/auth/menu','POST','::1','{\"parent_id\":\"8\",\"title\":\"\\u5145\\u503c\\u7ba1\\u7406\",\"icon\":\"fa-btc\",\"uri\":\"deposits\\/currency\",\"roles\":[null],\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\"}','2018-05-18 06:24:52','2018-05-18 06:24:52'),
	(77,1,'admin/auth/menu','GET','::1','[]','2018-05-18 06:24:52','2018-05-18 06:24:52'),
	(78,1,'admin/auth/menu','GET','::1','[]','2018-05-18 06:25:44','2018-05-18 06:25:44'),
	(79,1,'admin/deposits/currency','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 06:25:47','2018-05-18 06:25:47'),
	(80,1,'admin/deposits/currency','GET','::1','[]','2018-05-18 06:26:20','2018-05-18 06:26:20'),
	(81,1,'admin/auth/menu','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 06:27:57','2018-05-18 06:27:57'),
	(82,1,'admin/auth/menu','POST','::1','{\"parent_id\":\"8\",\"title\":\"\\u8865\\u5355\\u7ba1\\u7406\",\"icon\":\"fa-bars\",\"uri\":\"deposits\\/create\",\"roles\":[null],\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\"}','2018-05-18 06:35:04','2018-05-18 06:35:04'),
	(83,1,'admin/auth/menu','GET','::1','[]','2018-05-18 06:35:04','2018-05-18 06:35:04'),
	(84,1,'admin/auth/menu','POST','::1','{\"parent_id\":\"8\",\"title\":\"\\u63d0\\u73b0\\u7ba1\\u7406\",\"icon\":\"fa-btc\",\"uri\":\"withdraws\\/currency\",\"roles\":[null],\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\"}','2018-05-18 06:44:06','2018-05-18 06:44:06'),
	(85,1,'admin/auth/menu','GET','::1','[]','2018-05-18 06:44:06','2018-05-18 06:44:06'),
	(86,1,'admin/auth/menu','POST','::1','{\"parent_id\":\"0\",\"title\":\"\\u7528\\u6237\\u7ba1\\u7406\",\"icon\":\"fa-bars\",\"uri\":null,\"roles\":[null],\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\"}','2018-05-18 06:44:25','2018-05-18 06:44:25'),
	(87,1,'admin/auth/menu','GET','::1','[]','2018-05-18 06:44:26','2018-05-18 06:44:26'),
	(88,1,'admin/auth/menu','POST','::1','{\"parent_id\":\"13\",\"title\":\"\\u4f1a\\u5458\\u7ba1\\u7406\",\"icon\":\"fa-user\",\"uri\":\"user\",\"roles\":[null],\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\"}','2018-05-18 06:45:32','2018-05-18 06:45:32'),
	(89,1,'admin/auth/menu','GET','::1','[]','2018-05-18 06:45:32','2018-05-18 06:45:32'),
	(90,1,'admin/auth/menu','POST','::1','{\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\",\"_order\":\"[{\\\"id\\\":1},{\\\"id\\\":8,\\\"children\\\":[{\\\"id\\\":9},{\\\"id\\\":10},{\\\"id\\\":11},{\\\"id\\\":12}]},{\\\"id\\\":13,\\\"children\\\":[{\\\"id\\\":14}]},{\\\"id\\\":2,\\\"children\\\":[{\\\"id\\\":3},{\\\"id\\\":4},{\\\"id\\\":5},{\\\"id\\\":6},{\\\"id\\\":7}]}]\"}','2018-05-18 06:45:40','2018-05-18 06:45:40'),
	(91,1,'admin/auth/menu','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 06:45:41','2018-05-18 06:45:41'),
	(92,1,'admin/auth/menu/2/edit','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 06:45:42','2018-05-18 06:45:42'),
	(93,1,'admin/auth/menu/2','PUT','::1','{\"parent_id\":\"0\",\"title\":\"\\u7cfb\\u7edf\\u7ba1\\u7406\",\"icon\":\"fa-tasks\",\"uri\":null,\"roles\":[\"1\",null],\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\",\"_method\":\"PUT\",\"_previous_\":\"http:\\/\\/guess.me\\/admin\\/auth\\/menu\"}','2018-05-18 06:45:51','2018-05-18 06:45:51'),
	(94,1,'admin/auth/menu','GET','::1','[]','2018-05-18 06:45:52','2018-05-18 06:45:52'),
	(95,1,'admin/auth/menu','GET','::1','[]','2018-05-18 06:46:01','2018-05-18 06:46:01'),
	(96,1,'admin/user','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 06:46:03','2018-05-18 06:46:03'),
	(97,1,'admin/user','GET','::1','[]','2018-05-18 06:46:54','2018-05-18 06:46:54'),
	(98,1,'admin/user','GET','::1','[]','2018-05-18 06:48:50','2018-05-18 06:48:50'),
	(99,1,'admin/user','GET','::1','[]','2018-05-18 06:50:04','2018-05-18 06:50:04'),
	(100,1,'admin/user','GET','::1','[]','2018-05-18 06:51:39','2018-05-18 06:51:39'),
	(101,1,'admin/user/1/edit','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 06:51:47','2018-05-18 06:51:47'),
	(102,1,'admin/user','GET','::1','[]','2018-05-18 06:51:48','2018-05-18 06:51:48'),
	(103,1,'admin/user/1/edit','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-18 06:52:39','2018-05-18 06:52:39'),
	(104,1,'admin/user/1/edit','GET','::1','[]','2018-05-18 06:53:02','2018-05-18 06:53:02'),
	(105,1,'admin/user/1/edit','GET','::1','[]','2018-05-18 06:54:03','2018-05-18 06:54:03'),
	(106,1,'admin/user/1','PUT','::1','{\"name\":\"zohar01\",\"email\":\"zohar@qq.com\",\"mobile\":null,\"password\":\"$2y$10$2pBBi\\/tjuIxGNZO72va8wuy1QQxR0D6QoZerX2lP0i.hLMtmcn1RW\",\"password_confirmation\":\"$2y$10$2pBBi\\/tjuIxGNZO72va8wuy1QQxR0D6QoZerX2lP0i.hLMtmcn1RW\",\"is_delete\":\"on\",\"_token\":\"JOFcR1IprwhaBqPbZfgjvhBp7LRD95W4CCXGkkXH\",\"_method\":\"PUT\"}','2018-05-18 06:54:11','2018-05-18 06:54:11'),
	(107,1,'admin/user','GET','::1','[]','2018-05-18 06:54:11','2018-05-18 06:54:11'),
	(108,1,'admin/user','GET','::1','[]','2018-05-18 06:59:57','2018-05-18 06:59:57'),
	(109,1,'admin/user','GET','::1','[]','2018-05-19 17:06:45','2018-05-19 17:06:45'),
	(110,1,'admin/user','GET','::1','[]','2018-05-19 17:15:30','2018-05-19 17:15:30'),
	(111,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 03:53:15','2018-05-20 03:53:15'),
	(112,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 03:57:30','2018-05-20 03:57:30'),
	(113,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 03:58:05','2018-05-20 03:58:05'),
	(114,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 03:59:33','2018-05-20 03:59:33'),
	(115,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 03:59:49','2018-05-20 03:59:49'),
	(116,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:04:09','2018-05-20 04:04:09'),
	(117,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:06:20','2018-05-20 04:06:20'),
	(118,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:06:32','2018-05-20 04:06:32'),
	(119,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:06:46','2018-05-20 04:06:46'),
	(120,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:06:59','2018-05-20 04:06:59'),
	(121,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:07:05','2018-05-20 04:07:05'),
	(122,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:07:14','2018-05-20 04:07:14'),
	(123,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:07:20','2018-05-20 04:07:20'),
	(124,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:07:31','2018-05-20 04:07:31'),
	(125,1,'admin/guess/create','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-20 04:07:34','2018-05-20 04:07:34'),
	(126,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:07:35','2018-05-20 04:07:35'),
	(127,1,'admin/guess/create','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-20 04:09:19','2018-05-20 04:09:19'),
	(128,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:09:20','2018-05-20 04:09:20'),
	(129,1,'admin/guess/create','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-20 04:09:32','2018-05-20 04:09:32'),
	(130,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:09:33','2018-05-20 04:09:33'),
	(131,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:10:33','2018-05-20 04:10:33'),
	(132,1,'admin/guess/create','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-20 04:10:35','2018-05-20 04:10:35'),
	(133,1,'admin/guess/create','GET','127.0.0.1','[]','2018-05-20 04:11:34','2018-05-20 04:11:34'),
	(134,1,'admin/guess/create','GET','127.0.0.1','[]','2018-05-20 04:11:42','2018-05-20 04:11:42'),
	(135,1,'admin/guess/create','GET','127.0.0.1','[]','2018-05-20 04:12:01','2018-05-20 04:12:01'),
	(136,1,'admin/guess/create','GET','127.0.0.1','[]','2018-05-20 04:12:31','2018-05-20 04:12:31'),
	(137,1,'admin/guess','POST','127.0.0.1','{\"currency\":\"ETH\",\"title\":\"\\u4ee5\\u592a\\u7ade\\u731c\\u7b2c\\u4e00\\u671f\",\"period\":\"20101\",\"status\":\"on\",\"expect_price\":\"4680.99\",\"charges\":\"20\",\"max_amount\":\"9999\",\"min_amount\":\"1\",\"open_time\":\"2018-05-21 00:00:00\",\"start_time\":\"2018-05-20 19:00:00\",\"end_time\":\"2018-05-20 23:00:00\",\"_token\":\"qib5xicqzQCIiuQoXrbF0py5lGrjuSAXqXUibASI\"}','2018-05-20 04:15:33','2018-05-20 04:15:33'),
	(138,1,'admin/guess/create','GET','127.0.0.1','[]','2018-05-20 04:15:35','2018-05-20 04:15:35'),
	(139,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:18:31','2018-05-20 04:18:31'),
	(140,1,'admin/guess/create','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-20 04:18:33','2018-05-20 04:18:33'),
	(141,1,'admin/guess','POST','127.0.0.1','{\"currency\":\"ETH\",\"title\":\"\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4\",\"period\":\"2019876\",\"status\":\"on\",\"expect_price\":\"4987.987\",\"charges\":\"20\",\"max_amount\":\"10000\",\"min_amount\":\"1\",\"open_time\":\"2018-05-21 00:00:00\",\"start_time\":\"2018-05-20 13:00:00\",\"end_time\":\"2018-05-20 23:00:00\",\"_token\":\"qib5xicqzQCIiuQoXrbF0py5lGrjuSAXqXUibASI\",\"_previous_\":\"http:\\/\\/guess.me\\/admin\\/guess\"}','2018-05-20 04:19:29','2018-05-20 04:19:29'),
	(142,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:20:27','2018-05-20 04:20:27'),
	(143,1,'admin/guess/create','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-20 04:20:29','2018-05-20 04:20:29'),
	(144,1,'admin/guess','POST','127.0.0.1','{\"currency\":\"ETH\",\"title\":\"\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4\",\"period\":\"209\",\"status\":\"on\",\"expect_price\":\"4680.99\",\"charges\":\"20\",\"max_amount\":\"10000\",\"min_amount\":\"1\",\"open_time\":\"2018-05-21 00:00:00\",\"start_time\":\"2018-05-20 13:00:00\",\"end_time\":\"2018-05-20 23:00:00\",\"_token\":\"qib5xicqzQCIiuQoXrbF0py5lGrjuSAXqXUibASI\",\"_previous_\":\"http:\\/\\/guess.me\\/admin\\/guess\"}','2018-05-20 04:21:13','2018-05-20 04:21:13'),
	(145,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:24:19','2018-05-20 04:24:19'),
	(146,1,'admin/guess/create','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-20 04:24:21','2018-05-20 04:24:21'),
	(147,1,'admin/guess','POST','127.0.0.1','{\"currency\":null,\"title\":null,\"period\":null,\"status\":\"off\",\"expect_price\":\"0\",\"charges\":\"0\",\"max_amount\":\"0\",\"min_amount\":\"0\",\"open_time\":null,\"start_time\":null,\"end_time\":null,\"_token\":\"qib5xicqzQCIiuQoXrbF0py5lGrjuSAXqXUibASI\",\"_previous_\":\"http:\\/\\/guess.me\\/admin\\/guess\"}','2018-05-20 04:24:33','2018-05-20 04:24:33'),
	(148,1,'admin/guess/create','GET','127.0.0.1','[]','2018-05-20 04:24:34','2018-05-20 04:24:34'),
	(149,1,'admin/guess','POST','127.0.0.1','{\"currency\":\"ETH\",\"title\":\"\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4\",\"period\":\"2\",\"status\":\"on\",\"expect_price\":\"0\",\"charges\":\"0\",\"max_amount\":\"0\",\"min_amount\":\"0\",\"open_time\":null,\"start_time\":null,\"end_time\":null,\"_token\":\"qib5xicqzQCIiuQoXrbF0py5lGrjuSAXqXUibASI\"}','2018-05-20 04:24:55','2018-05-20 04:24:55'),
	(150,1,'admin/guess/create','GET','127.0.0.1','[]','2018-05-20 04:24:55','2018-05-20 04:24:55'),
	(151,1,'admin/guess','POST','127.0.0.1','{\"currency\":\"ETH\",\"title\":\"\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4\",\"period\":\"2\",\"status\":\"on\",\"expect_price\":\"4680.99\",\"charges\":\"20\",\"max_amount\":\"10000\",\"min_amount\":\"1\",\"open_time\":\"2018-05-21 00:00:00\",\"start_time\":\"2018-05-20 13:00:00\",\"end_time\":\"2018-05-20 23:00:00\",\"_token\":\"qib5xicqzQCIiuQoXrbF0py5lGrjuSAXqXUibASI\"}','2018-05-20 04:25:42','2018-05-20 04:25:42'),
	(152,1,'admin/guess/create','GET','127.0.0.1','[]','2018-05-20 04:25:43','2018-05-20 04:25:43'),
	(153,1,'admin/guess','POST','127.0.0.1','{\"currency\":\"ETH\",\"title\":\"\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4\",\"period\":\"2\",\"status\":\"on\",\"expect_price\":\"4680.99\",\"charges\":\"20\",\"max_amount\":\"10000\",\"min_amount\":\"1\",\"open_time\":\"2018-05-21 00:00:00\",\"start_time\":\"2018-05-20 13:00:00\",\"end_time\":\"2018-05-20 23:00:00\",\"_token\":\"qib5xicqzQCIiuQoXrbF0py5lGrjuSAXqXUibASI\"}','2018-05-20 04:26:15','2018-05-20 04:26:15'),
	(154,1,'admin/guess/create','GET','127.0.0.1','[]','2018-05-20 04:26:16','2018-05-20 04:26:16'),
	(155,1,'admin/guess','POST','127.0.0.1','{\"currency\":\"1\",\"title\":\"\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4\",\"period\":\"2\",\"status\":\"on\",\"expect_price\":\"4680.99\",\"charges\":\"20\",\"max_amount\":\"10000\",\"min_amount\":\"1\",\"open_time\":\"2018-05-21 00:00:00\",\"start_time\":\"2018-05-20 13:00:00\",\"end_time\":\"2018-05-20 23:00:00\",\"_token\":\"qib5xicqzQCIiuQoXrbF0py5lGrjuSAXqXUibASI\"}','2018-05-20 04:26:21','2018-05-20 04:26:21'),
	(156,1,'admin/guess/create','GET','127.0.0.1','[]','2018-05-20 04:26:22','2018-05-20 04:26:22'),
	(157,1,'admin/guess/create','GET','127.0.0.1','[]','2018-05-20 04:26:25','2018-05-20 04:26:25'),
	(158,1,'admin/guess','POST','127.0.0.1','{\"currency\":\"1\",\"title\":\"\\u5feb\\u8baf\",\"period\":\"1\",\"status\":\"on\",\"expect_price\":\"4680.99\",\"charges\":\"20\",\"max_amount\":\"10000\",\"min_amount\":\"1\",\"open_time\":\"2018-05-21 00:00:00\",\"start_time\":\"2018-05-20 13:00:00\",\"end_time\":\"2018-05-20 23:00:00\",\"_token\":\"qib5xicqzQCIiuQoXrbF0py5lGrjuSAXqXUibASI\"}','2018-05-20 04:27:02','2018-05-20 04:27:02'),
	(159,1,'admin/guess/create','GET','127.0.0.1','[]','2018-05-20 04:27:03','2018-05-20 04:27:03'),
	(160,1,'admin/guess','POST','127.0.0.1','{\"currency\":\"1\",\"title\":\"\\u5feb\\u8baf\",\"period\":\"1\",\"status\":\"on\",\"expect_price\":\"4680.99\",\"charges\":\"20\",\"max_amount\":\"10000\",\"min_amount\":\"1\",\"open_time\":\"2018-05-21 00:00:00\",\"start_time\":\"2018-05-20 13:00:00\",\"end_time\":\"2018-05-20 23:00:00\",\"_token\":\"qib5xicqzQCIiuQoXrbF0py5lGrjuSAXqXUibASI\"}','2018-05-20 04:27:37','2018-05-20 04:27:37'),
	(161,1,'admin/guess/create','GET','127.0.0.1','[]','2018-05-20 04:27:38','2018-05-20 04:27:38'),
	(162,1,'admin/guess','POST','127.0.0.1','{\"currency\":\"1\",\"title\":\"\\u5feb\\u8baf\",\"period\":\"1\",\"status\":\"on\",\"expect_price\":\"4680.99\",\"charges\":\"20\",\"max_amount\":\"10000\",\"min_amount\":\"1\",\"open_time\":\"2018-05-21 00:00:00\",\"start_time\":\"2018-05-20 13:00:00\",\"end_time\":\"2018-05-20 23:00:00\",\"_token\":\"qib5xicqzQCIiuQoXrbF0py5lGrjuSAXqXUibASI\"}','2018-05-20 04:38:08','2018-05-20 04:38:08'),
	(163,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:38:08','2018-05-20 04:38:08'),
	(164,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:40:07','2018-05-20 04:40:07'),
	(165,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:40:27','2018-05-20 04:40:27'),
	(166,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:40:38','2018-05-20 04:40:38'),
	(167,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:47:20','2018-05-20 04:47:20'),
	(168,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:48:31','2018-05-20 04:48:31'),
	(169,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:51:28','2018-05-20 04:51:28'),
	(170,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:51:29','2018-05-20 04:51:29'),
	(171,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:54:47','2018-05-20 04:54:47'),
	(172,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:54:49','2018-05-20 04:54:49'),
	(173,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:55:09','2018-05-20 04:55:09'),
	(174,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:55:20','2018-05-20 04:55:20'),
	(175,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:55:46','2018-05-20 04:55:46'),
	(176,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:56:35','2018-05-20 04:56:35'),
	(177,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:57:16','2018-05-20 04:57:16'),
	(178,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:57:26','2018-05-20 04:57:26'),
	(179,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 04:57:43','2018-05-20 04:57:43'),
	(180,1,'admin/guess','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-20 04:58:35','2018-05-20 04:58:35'),
	(181,1,'admin/guess/1/edit','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-20 05:01:25','2018-05-20 05:01:25'),
	(182,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:02:19','2018-05-20 05:02:19'),
	(183,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:02:29','2018-05-20 05:02:29'),
	(184,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:02:40','2018-05-20 05:02:40'),
	(185,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:02:51','2018-05-20 05:02:51'),
	(186,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:03:28','2018-05-20 05:03:28'),
	(187,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:03:40','2018-05-20 05:03:40'),
	(188,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:03:48','2018-05-20 05:03:48'),
	(189,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:03:57','2018-05-20 05:03:57'),
	(190,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:04:27','2018-05-20 05:04:27'),
	(191,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:05:09','2018-05-20 05:05:09'),
	(192,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:07:08','2018-05-20 05:07:08'),
	(193,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:07:17','2018-05-20 05:07:17'),
	(194,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:07:51','2018-05-20 05:07:51'),
	(195,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:08:23','2018-05-20 05:08:23'),
	(196,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:08:38','2018-05-20 05:08:38'),
	(197,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:08:42','2018-05-20 05:08:42'),
	(198,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:08:54','2018-05-20 05:08:54'),
	(199,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:11:24','2018-05-20 05:11:24'),
	(200,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:11:35','2018-05-20 05:11:35'),
	(201,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:15:10','2018-05-20 05:15:10'),
	(202,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:17:00','2018-05-20 05:17:00'),
	(203,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:17:08','2018-05-20 05:17:08'),
	(204,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:19:23','2018-05-20 05:19:23'),
	(205,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:20:12','2018-05-20 05:20:12'),
	(206,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:26:09','2018-05-20 05:26:09'),
	(207,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:26:25','2018-05-20 05:26:25'),
	(208,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:26:41','2018-05-20 05:26:41'),
	(209,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:29:01','2018-05-20 05:29:01'),
	(210,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:31:51','2018-05-20 05:31:51'),
	(211,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:36:51','2018-05-20 05:36:51'),
	(212,1,'admin/guess/1','PUT','127.0.0.1','{\"currency\":\"1\",\"title\":\"\\u5feb\\u8baf\",\"period\":\"1\",\"status\":\"on\",\"expect_price\":\"4680.990000000000000000\",\"charges\":\"20.000000000000000000\",\"max_amount\":\"10000.000000000000000000\",\"min_amount\":\"1.000000000000000000\",\"open_time\":\"2018-05-21 23:00:00\",\"start_time\":\"2018-05-20 15:00:00\",\"end_time\":\"2018-05-20 23:00:00\",\"_token\":\"qib5xicqzQCIiuQoXrbF0py5lGrjuSAXqXUibASI\",\"_method\":\"PUT\",\"_previous_\":\"http:\\/\\/guess.me\\/admin\\/guess\\/create\"}','2018-05-20 05:37:31','2018-05-20 05:37:31'),
	(213,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:37:33','2018-05-20 05:37:33'),
	(214,1,'admin/guess/1','PUT','127.0.0.1','{\"currency\":\"1\",\"title\":\"\\u5feb\\u8baf\",\"period\":\"1\",\"status\":\"on\",\"expect_price\":\"4680.990000000000000000\",\"charges\":\"20.000000000000000000\",\"max_amount\":\"10000.000000000000000000\",\"min_amount\":\"1.000000000000000000\",\"open_time\":\"2018-05-21 23:00:00\",\"start_time\":\"2018-05-20 15:00:00\",\"end_time\":\"2018-05-20 23:00:00\",\"_token\":\"qib5xicqzQCIiuQoXrbF0py5lGrjuSAXqXUibASI\",\"_method\":\"PUT\"}','2018-05-20 05:38:08','2018-05-20 05:38:08'),
	(215,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 05:38:08','2018-05-20 05:38:08'),
	(216,1,'admin/guess/1/edit','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-20 05:38:15','2018-05-20 05:38:15'),
	(217,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 05:38:51','2018-05-20 05:38:51'),
	(218,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:01:30','2018-05-20 06:01:30'),
	(219,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:01:44','2018-05-20 06:01:44'),
	(220,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:03:25','2018-05-20 06:03:25'),
	(221,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:03:40','2018-05-20 06:03:40'),
	(222,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:06:41','2018-05-20 06:06:41'),
	(223,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:08:14','2018-05-20 06:08:14'),
	(224,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:08:21','2018-05-20 06:08:21'),
	(225,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:08:42','2018-05-20 06:08:42'),
	(226,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:09:27','2018-05-20 06:09:27'),
	(227,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:09:33','2018-05-20 06:09:33'),
	(228,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:09:45','2018-05-20 06:09:45'),
	(229,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:09:53','2018-05-20 06:09:53'),
	(230,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:10:40','2018-05-20 06:10:40'),
	(231,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:10:46','2018-05-20 06:10:46'),
	(232,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:11:27','2018-05-20 06:11:27'),
	(233,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:11:51','2018-05-20 06:11:51'),
	(234,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:11:56','2018-05-20 06:11:56'),
	(235,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:12:19','2018-05-20 06:12:19'),
	(236,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:12:22','2018-05-20 06:12:22'),
	(237,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:12:28','2018-05-20 06:12:28'),
	(238,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:12:46','2018-05-20 06:12:46'),
	(239,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:13:26','2018-05-20 06:13:26'),
	(240,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:13:38','2018-05-20 06:13:38'),
	(241,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:13:49','2018-05-20 06:13:49'),
	(242,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:14:04','2018-05-20 06:14:04'),
	(243,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:14:59','2018-05-20 06:14:59'),
	(244,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:15:07','2018-05-20 06:15:07'),
	(245,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 06:18:27','2018-05-20 06:18:27'),
	(246,1,'admin/guess','GET','127.0.0.1','{\"_pjax\":\"#pjax-container\"}','2018-05-20 06:19:05','2018-05-20 06:19:05'),
	(247,1,'admin/guess','GET','127.0.0.1','[]','2018-05-20 06:19:20','2018-05-20 06:19:20'),
	(248,1,'admin/guess/1/edit','GET','127.0.0.1','[]','2018-05-20 08:27:26','2018-05-20 08:27:26'),
	(249,1,'admin','GET','::1','[]','2018-05-24 15:16:05','2018-05-24 15:16:05'),
	(250,1,'admin/news','GET','::1','[]','2018-05-24 15:36:15','2018-05-24 15:36:15'),
	(251,1,'admin/news','GET','::1','[]','2018-05-24 15:37:40','2018-05-24 15:37:40'),
	(252,1,'admin/news','GET','::1','[]','2018-05-24 15:37:56','2018-05-24 15:37:56'),
	(253,1,'admin/news/create','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-24 15:38:00','2018-05-24 15:38:00'),
	(254,1,'admin/news/create','GET','::1','[]','2018-05-24 15:38:07','2018-05-24 15:38:07'),
	(255,1,'admin/news/create','GET','::1','[]','2018-05-24 15:43:23','2018-05-24 15:43:23'),
	(256,1,'admin/news/create','GET','::1','[]','2018-05-24 15:44:41','2018-05-24 15:44:41'),
	(257,1,'admin/news','POST','::1','{\"title\":\"\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4\",\"description\":\"\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4\",\"content\":\"<p>\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4<\\/p>\",\"author_id\":\"1\",\"status\":\"on\",\"_token\":\"z4xnJ9Vl0SIZgeUFo2VgzGnQKKWYNBNf0aU3rBno\"}','2018-05-24 15:45:13','2018-05-24 15:45:13'),
	(258,1,'admin/news','GET','::1','[]','2018-05-24 15:45:14','2018-05-24 15:45:14'),
	(259,1,'admin/news','GET','::1','[]','2018-05-24 15:45:19','2018-05-24 15:45:19'),
	(260,1,'admin/news/create','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-24 15:45:21','2018-05-24 15:45:21'),
	(261,1,'admin/news','POST','::1','{\"title\":\"\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4\",\"description\":\"\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4\",\"content\":\"<p>\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4<\\/p>\",\"author_id\":\"1\",\"status\":\"on\",\"_token\":\"z4xnJ9Vl0SIZgeUFo2VgzGnQKKWYNBNf0aU3rBno\",\"_previous_\":\"http:\\/\\/www.ethz.me\\/admin\\/news\"}','2018-05-24 15:45:31','2018-05-24 15:45:31'),
	(262,1,'admin/news','GET','::1','[]','2018-05-24 15:45:31','2018-05-24 15:45:31'),
	(263,1,'admin/news/16/edit','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-24 15:45:34','2018-05-24 15:45:34'),
	(264,1,'admin/news','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-24 15:45:37','2018-05-24 15:45:37'),
	(265,1,'admin/news','GET','::1','[]','2018-05-24 15:51:29','2018-05-24 15:51:29'),
	(266,1,'admin/news','GET','::1','[]','2018-05-24 15:51:48','2018-05-24 15:51:48'),
	(267,1,'admin/news','GET','::1','[]','2018-05-24 15:51:59','2018-05-24 15:51:59'),
	(268,1,'admin/news','GET','::1','[]','2018-05-24 15:52:15','2018-05-24 15:52:15'),
	(269,1,'admin/news','GET','::1','[]','2018-05-24 15:52:19','2018-05-24 15:52:19'),
	(270,1,'admin/news/16','PUT','::1','{\"name\":\"displayorder\",\"value\":\"1\",\"pk\":\"16\",\"_token\":\"z4xnJ9Vl0SIZgeUFo2VgzGnQKKWYNBNf0aU3rBno\",\"_editable\":\"1\",\"_method\":\"PUT\"}','2018-05-24 15:52:26','2018-05-24 15:52:26'),
	(271,1,'admin/news','GET','::1','[]','2018-05-24 15:52:27','2018-05-24 15:52:27'),
	(272,1,'admin/news/16','PUT','::1','{\"name\":\"displayorder\",\"value\":\"1\",\"pk\":\"16\",\"_token\":\"z4xnJ9Vl0SIZgeUFo2VgzGnQKKWYNBNf0aU3rBno\",\"_editable\":\"1\",\"_method\":\"PUT\"}','2018-05-24 15:52:33','2018-05-24 15:52:33'),
	(273,1,'admin/news/16','PUT','::1','{\"name\":\"displayorder\",\"value\":\"22\",\"pk\":\"16\",\"_token\":\"z4xnJ9Vl0SIZgeUFo2VgzGnQKKWYNBNf0aU3rBno\",\"_editable\":\"1\",\"_method\":\"PUT\"}','2018-05-24 15:52:48','2018-05-24 15:52:48'),
	(274,1,'admin/news/16','PUT','::1','{\"name\":\"displayorder\",\"value\":\"33\",\"pk\":\"16\",\"_token\":\"z4xnJ9Vl0SIZgeUFo2VgzGnQKKWYNBNf0aU3rBno\",\"_editable\":\"1\",\"_method\":\"PUT\"}','2018-05-24 15:52:54','2018-05-24 15:52:54'),
	(275,1,'admin/news/16/edit','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-24 15:53:06','2018-05-24 15:53:06'),
	(276,1,'admin/news/16/edit','GET','::1','[]','2018-05-24 15:56:18','2018-05-24 15:56:18'),
	(277,1,'admin/news','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-24 15:56:21','2018-05-24 15:56:21'),
	(278,1,'admin/news/16','PUT','::1','{\"name\":\"displayorder\",\"value\":\"1\",\"pk\":\"16\",\"_token\":\"z4xnJ9Vl0SIZgeUFo2VgzGnQKKWYNBNf0aU3rBno\",\"_editable\":\"1\",\"_method\":\"PUT\"}','2018-05-24 15:56:29','2018-05-24 15:56:29'),
	(279,1,'admin/news','GET','::1','[]','2018-05-24 16:00:43','2018-05-24 16:00:43'),
	(280,1,'admin/news/16','PUT','::1','{\"name\":\"displayorder\",\"value\":\"1\",\"pk\":\"16\",\"_token\":\"z4xnJ9Vl0SIZgeUFo2VgzGnQKKWYNBNf0aU3rBno\",\"_editable\":\"1\",\"_method\":\"PUT\"}','2018-05-24 16:00:47','2018-05-24 16:00:47'),
	(281,1,'admin/news/16','PUT','::1','{\"name\":\"displayorder\",\"value\":\"12\",\"pk\":\"16\",\"_token\":\"z4xnJ9Vl0SIZgeUFo2VgzGnQKKWYNBNf0aU3rBno\",\"_editable\":\"1\",\"_method\":\"PUT\"}','2018-05-24 16:01:32','2018-05-24 16:01:32'),
	(282,1,'admin/news/16/edit','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-24 16:03:50','2018-05-24 16:03:50'),
	(283,1,'admin/news/16','PUT','::1','{\"displayorder\":\"12\",\"title\":\"\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4\",\"description\":\"\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4\",\"content\":\"<p>\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4<\\/p>\",\"author_id\":\"1\",\"status\":\"on\",\"_token\":\"z4xnJ9Vl0SIZgeUFo2VgzGnQKKWYNBNf0aU3rBno\",\"_method\":\"PUT\",\"_previous_\":\"http:\\/\\/www.ethz.me\\/admin\\/news\"}','2018-05-24 16:03:58','2018-05-24 16:03:58'),
	(284,1,'admin/news','GET','::1','[]','2018-05-24 16:03:58','2018-05-24 16:03:58'),
	(285,1,'admin/news/16/edit','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-24 16:04:01','2018-05-24 16:04:01'),
	(286,1,'admin/news','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-24 16:04:06','2018-05-24 16:04:06'),
	(287,1,'admin/news/16','PUT','::1','{\"name\":\"displayorder\",\"value\":\"1\",\"pk\":\"16\",\"_token\":\"z4xnJ9Vl0SIZgeUFo2VgzGnQKKWYNBNf0aU3rBno\",\"_editable\":\"1\",\"_method\":\"PUT\"}','2018-05-24 16:04:11','2018-05-24 16:04:11'),
	(288,1,'admin/news','GET','::1','[]','2018-05-24 16:04:13','2018-05-24 16:04:13'),
	(289,1,'admin/news','GET','::1','[]','2018-05-24 16:04:16','2018-05-24 16:04:16'),
	(290,1,'admin/news/17','PUT','::1','{\"name\":\"displayorder\",\"value\":\"2\",\"pk\":\"17\",\"_token\":\"z4xnJ9Vl0SIZgeUFo2VgzGnQKKWYNBNf0aU3rBno\",\"_editable\":\"1\",\"_method\":\"PUT\"}','2018-05-24 16:04:21','2018-05-24 16:04:21'),
	(291,1,'admin/news','GET','::1','[]','2018-05-24 16:04:22','2018-05-24 16:04:22'),
	(292,1,'admin/news','GET','::1','[]','2018-05-24 16:04:27','2018-05-24 16:04:27'),
	(293,1,'admin/news/16/edit','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-24 16:04:49','2018-05-24 16:04:49'),
	(294,1,'admin/news/16','PUT','::1','{\"displayorder\":\"1\",\"title\":\"\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4\",\"description\":\"\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4\",\"content\":\"<p>\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4<\\/p>\",\"author_id\":\"1\",\"status\":\"on\",\"_token\":\"z4xnJ9Vl0SIZgeUFo2VgzGnQKKWYNBNf0aU3rBno\",\"_method\":\"PUT\",\"_previous_\":\"http:\\/\\/www.ethz.me\\/admin\\/news\"}','2018-05-24 16:04:53','2018-05-24 16:04:53'),
	(295,1,'admin/news','GET','::1','[]','2018-05-24 16:04:53','2018-05-24 16:04:53'),
	(296,1,'admin/news/17/edit','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-24 16:04:56','2018-05-24 16:04:56'),
	(297,1,'admin/news/17','PUT','::1','{\"displayorder\":\"2\",\"title\":\"\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4\",\"description\":\"\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4\",\"content\":\"<p>\\u7b2c\\u4e00\\u4e2a\\u804a\\u5929\\u5ba4<\\/p>\",\"author_id\":\"1\",\"status\":\"on\",\"_token\":\"z4xnJ9Vl0SIZgeUFo2VgzGnQKKWYNBNf0aU3rBno\",\"_method\":\"PUT\",\"_previous_\":\"http:\\/\\/www.ethz.me\\/admin\\/news\"}','2018-05-24 16:05:02','2018-05-24 16:05:02'),
	(298,1,'admin/news','GET','::1','[]','2018-05-24 16:05:02','2018-05-24 16:05:02'),
	(299,1,'admin/news','GET','::1','[]','2018-05-24 16:17:31','2018-05-24 16:17:31'),
	(300,1,'admin','GET','::1','[]','2018-05-25 01:31:21','2018-05-25 01:31:21'),
	(301,1,'admin','GET','::1','[]','2018-05-25 01:33:21','2018-05-25 01:33:21'),
	(302,1,'admin/api-tester','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-25 01:33:23','2018-05-25 01:33:23'),
	(303,1,'admin/api-tester/handle','POST','::1','{\"uri\":\"api\\/login\",\"method\":null,\"_token\":\"xBugeilU5WEKJX5ZGX0uANRjRcYQlbbLKQb9aoPg\",\"user\":\"1\",\"key\":[\"account\",\"password\"],\"val\":[\"945056167@qq.com\",\"123456\"]}','2018-05-25 01:34:53','2018-05-25 01:34:53'),
	(304,1,'admin/api-tester/handle','POST','::1','{\"uri\":\"api\\/login\",\"method\":null,\"_token\":\"xBugeilU5WEKJX5ZGX0uANRjRcYQlbbLKQb9aoPg\",\"user\":\"1\",\"key\":[\"account\",\"password\"],\"val\":[\"945056167@qq.com\",\"123456\"]}','2018-05-25 01:34:56','2018-05-25 01:34:56'),
	(305,1,'admin/api-tester/handle','POST','::1','{\"uri\":\"api\\/login\",\"method\":null,\"_token\":\"xBugeilU5WEKJX5ZGX0uANRjRcYQlbbLKQb9aoPg\",\"user\":\"1\",\"key\":[\"account\",\"password\"],\"val\":[\"945056167@qq.com\",\"123456\"]}','2018-05-25 01:34:57','2018-05-25 01:34:57'),
	(306,1,'admin/api-tester/handle','POST','::1','{\"uri\":\"api\\/login\",\"method\":null,\"_token\":\"xBugeilU5WEKJX5ZGX0uANRjRcYQlbbLKQb9aoPg\",\"user\":\"1\",\"key\":[\"account\",\"password\"],\"val\":[\"945056167@qq.com\",\"123456\"]}','2018-05-25 01:35:04','2018-05-25 01:35:04'),
	(307,1,'admin/api-tester','GET','::1','{\"_pjax\":\"#pjax-container\"}','2018-05-25 01:35:35','2018-05-25 01:35:35'),
	(308,1,'admin/api-tester/handle','POST','::1','{\"uri\":\"www.ethz.me\\/api\\/login\",\"method\":null,\"_token\":\"xBugeilU5WEKJX5ZGX0uANRjRcYQlbbLKQb9aoPg\",\"user\":null,\"key\":[\"account\",\"password\"],\"val\":[\"945056167@qq.com\",\"123456\"]}','2018-05-25 01:37:44','2018-05-25 01:37:44'),
	(309,1,'admin/api-tester/handle','POST','::1','{\"uri\":\"www.ethz.me\\/api\\/login\",\"method\":null,\"_token\":\"xBugeilU5WEKJX5ZGX0uANRjRcYQlbbLKQb9aoPg\",\"user\":\"post\",\"key\":[\"account\",\"password\"],\"val\":[\"945056167@qq.com\",\"123456\"]}','2018-05-25 01:37:57','2018-05-25 01:37:57'),
	(310,1,'admin/api-tester/handle','POST','::1','{\"uri\":\"www.ethz.me\\/api\\/login\",\"method\":null,\"_token\":\"xBugeilU5WEKJX5ZGX0uANRjRcYQlbbLKQb9aoPg\",\"user\":\"post\",\"key\":[\"account\",\"password\"],\"val\":[\"945056167@qq.com\",\"123456\"]}','2018-05-25 01:38:03','2018-05-25 01:38:03'),
	(311,1,'admin/api-tester/handle','POST','::1','{\"uri\":\"\\/api\\/login\",\"method\":null,\"_token\":\"xBugeilU5WEKJX5ZGX0uANRjRcYQlbbLKQb9aoPg\",\"user\":\"post\",\"key\":[\"account\",\"password\"],\"val\":[\"945056167@qq.com\",\"123456\"]}','2018-05-25 01:38:13','2018-05-25 01:38:13'),
	(312,1,'admin/api-tester/handle','POST','::1','{\"uri\":\"\\/api\\/login\",\"method\":null,\"_token\":\"xBugeilU5WEKJX5ZGX0uANRjRcYQlbbLKQb9aoPg\",\"user\":\"post\",\"key\":[\"account\",\"password\"],\"val\":[\"945056167@qq.com\",\"123456\"]}','2018-05-25 01:38:14','2018-05-25 01:38:14'),
	(313,1,'admin/api-tester/handle','POST','::1','{\"uri\":\"\\/api\\/login\",\"method\":null,\"_token\":\"xBugeilU5WEKJX5ZGX0uANRjRcYQlbbLKQb9aoPg\",\"user\":\"post\",\"key\":[\"account\",\"password\"],\"val\":[\"945056167@qq.com\",\"123456\"]}','2018-05-25 01:38:15','2018-05-25 01:38:15'),
	(314,1,'admin/api-tester/handle','POST','::1','{\"uri\":\"\\/api\\/login\",\"method\":null,\"_token\":\"xBugeilU5WEKJX5ZGX0uANRjRcYQlbbLKQb9aoPg\",\"user\":\"post\",\"key\":[\"account\",\"password\"],\"val\":[\"945056167@qq.com\",\"123456\"]}','2018-05-25 01:38:15','2018-05-25 01:38:15'),
	(315,1,'admin/api-tester/handle','POST','::1','{\"uri\":\"\\/api\\/login\",\"method\":null,\"_token\":\"xBugeilU5WEKJX5ZGX0uANRjRcYQlbbLKQb9aoPg\",\"user\":\"post\",\"key\":[\"account\",\"password\"],\"val\":[\"945056167@qq.com\",\"123456\"]}','2018-05-25 01:38:15','2018-05-25 01:38:15'),
	(316,1,'admin/api-tester/handle','POST','::1','{\"uri\":\"\\/api\\/login\",\"method\":null,\"_token\":\"xBugeilU5WEKJX5ZGX0uANRjRcYQlbbLKQb9aoPg\",\"user\":\"post\",\"key\":[\"account\",\"password\"],\"val\":[\"945056167@qq.com\",\"123456\"]}','2018-05-25 01:38:16','2018-05-25 01:38:16'),
	(317,1,'admin/api-tester/handle','POST','::1','{\"uri\":\"\\/api\\/login\",\"method\":null,\"_token\":\"xBugeilU5WEKJX5ZGX0uANRjRcYQlbbLKQb9aoPg\",\"user\":\"post\",\"key\":[\"account\",\"password\"],\"val\":[\"945056167@qq.com\",\"123456\"]}','2018-05-25 01:38:19','2018-05-25 01:38:19'),
	(318,1,'admin/api-tester/handle','POST','::1','{\"uri\":\"http:\\/\\/www.ethz.me\\/api\\/login\",\"method\":null,\"_token\":\"xBugeilU5WEKJX5ZGX0uANRjRcYQlbbLKQb9aoPg\",\"user\":\"post\",\"key\":[\"account\",\"password\"],\"val\":[\"945056167@qq.com\",\"123456\"]}','2018-05-25 01:38:32','2018-05-25 01:38:32'),
	(319,1,'admin/api-tester/handle','POST','::1','{\"uri\":\"www.ethz.me\\/api\\/login\",\"method\":null,\"_token\":\"xBugeilU5WEKJX5ZGX0uANRjRcYQlbbLKQb9aoPg\",\"user\":\"post\",\"key\":[\"account\",\"password\"],\"val\":[\"945056167@qq.com\",\"123456\"]}','2018-05-25 01:38:50','2018-05-25 01:38:50'),
	(320,1,'admin/api-tester/handle','POST','::1','{\"uri\":\"www.ethz.me\\/api\\/login\",\"method\":null,\"_token\":\"xBugeilU5WEKJX5ZGX0uANRjRcYQlbbLKQb9aoPg\",\"user\":\"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImUwZWIyODMxNWU4Mzc5MzM4ODRhNGU3MWQ4YmQyOWY4NGZiMDUyYTkzNDhlMzI0MzgwYzU2OTE4Y2E5MWVmNWVkZDQzM2Q1MzBhN2E5YTY2In0.eyJhdWQiOiIyIiwianRpIjoiZTBlYjI4MzE1ZTgzNzkzMzg4NGE0ZTcxZDhiZDI5Zjg0ZmIwNTJhOTM0OGUzMjQzODBjNTY5MThjYTkxZWY1ZWRkNDMzZDUzMGE3YTlhNjYiLCJpYXQiOjE1MjcxODI4ODUsIm5iZiI6MTUyNzE4Mjg4NSwiZXhwIjoxNTI4NDc4ODg1LCJzdWIiOiI0Iiwic2NvcGVzIjpbXX0.fJU8bm5j_A_xEjgQPJ_T8EKF069_Ei2DsD5D8zo6Huwc5EYm1T_CHvJBf-XG6TrlriOPYlJEKbExm9C-iCHmCRHOYXN6hZyhEMHqmgRslXfK36uMN9XkliI8o0Z3kcCoUcNbTzACvfrhsOWx8ek2o5OVlYIfq_nULAsvOOz_ihYhS7uQe4iYfU7Og06DBIfLFnBvO5ps4zuiO4o26-dvXLkVaYHC4-j_K3E3urD6JFtihCfnSQLbd7BRGYj5b4VYImqbWQXIBWHw5mYj2lygCsK3YeyCuBhgmsKfVfA2mCVS7qHOuVFk9P-7afCutvMfDVn5aI4aTbKZemsMMxpYZdwP9enb8oie2U65EJmCA5KFXIfncqw23InH-sB7h6t3LTszXomnlt3U3Mxag-2Rp_O6s_dq4sQpu25eaYgTMzl3-VIf5RYOsUigPbLlIPrcYOy3-e6BBxIH4oqX0QARd_GtUvSPn9YzAA0JBEc33tqDAxk-PJwUsk3PzdcNbdU20O3zPumEajm0JtWyjWskLqtBi0w6R_BER5xXHcdRGhwXMsqXHmznaHyeFK8gVdOJhFoboyB1G-_giIXr76opc0SGHhqxayuzFEXaMPO7h834xaekHTxL_V9jhagpatRi53p0zk3HGTvfpWRZJMd8GtY6I_eOAIB5JJeUFIoudzA\",\"key\":[\"account\",\"password\"],\"val\":[\"945056167@qq.com\",\"123456\"]}','2018-05-25 01:39:34','2018-05-25 01:39:34'),
	(321,1,'admin/api-tester/handle','POST','::1','{\"uri\":\"www.ethz.me\\/api\\/login\",\"method\":null,\"_token\":\"xBugeilU5WEKJX5ZGX0uANRjRcYQlbbLKQb9aoPg\",\"user\":\"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImUwZWIyODMxNWU4Mzc5MzM4ODRhNGU3MWQ4YmQyOWY4NGZiMDUyYTkzNDhlMzI0MzgwYzU2OTE4Y2E5MWVmNWVkZDQzM2Q1MzBhN2E5YTY2In0.eyJhdWQiOiIyIiwianRpIjoiZTBlYjI4MzE1ZTgzNzkzMzg4NGE0ZTcxZDhiZDI5Zjg0ZmIwNTJhOTM0OGUzMjQzODBjNTY5MThjYTkxZWY1ZWRkNDMzZDUzMGE3YTlhNjYiLCJpYXQiOjE1MjcxODI4ODUsIm5iZiI6MTUyNzE4Mjg4NSwiZXhwIjoxNTI4NDc4ODg1LCJzdWIiOiI0Iiwic2NvcGVzIjpbXX0.fJU8bm5j_A_xEjgQPJ_T8EKF069_Ei2DsD5D8zo6Huwc5EYm1T_CHvJBf-XG6TrlriOPYlJEKbExm9C-iCHmCRHOYXN6hZyhEMHqmgRslXfK36uMN9XkliI8o0Z3kcCoUcNbTzACvfrhsOWx8ek2o5OVlYIfq_nULAsvOOz_ihYhS7uQe4iYfU7Og06DBIfLFnBvO5ps4zuiO4o26-dvXLkVaYHC4-j_K3E3urD6JFtihCfnSQLbd7BRGYj5b4VYImqbWQXIBWHw5mYj2lygCsK3YeyCuBhgmsKfVfA2mCVS7qHOuVFk9P-7afCutvMfDVn5aI4aTbKZemsMMxpYZdwP9enb8oie2U65EJmCA5KFXIfncqw23InH-sB7h6t3LTszXomnlt3U3Mxag-2Rp_O6s_dq4sQpu25eaYgTMzl3-VIf5RYOsUigPbLlIPrcYOy3-e6BBxIH4oqX0QARd_GtUvSPn9YzAA0JBEc33tqDAxk-PJwUsk3PzdcNbdU20O3zPumEajm0JtWyjWskLqtBi0w6R_BER5xXHcdRGhwXMsqXHmznaHyeFK8gVdOJhFoboyB1G-_giIXr76opc0SGHhqxayuzFEXaMPO7h834xaekHTxL_V9jhagpatRi53p0zk3HGTvfpWRZJMd8GtY6I_eOAIB5JJeUFIoudzA\",\"key\":[\"account\",\"password\"],\"val\":[\"945056167@qq.com\",\"123456\"]}','2018-05-25 01:39:43','2018-05-25 01:39:43'),
	(322,1,'admin/api-tester/handle','POST','::1','{\"uri\":\"www.ethz.me\\/api\\/login\",\"method\":null,\"_token\":\"xBugeilU5WEKJX5ZGX0uANRjRcYQlbbLKQb9aoPg\",\"user\":null,\"key\":[\"account\",\"password\"],\"val\":[\"945056167@qq.com\",\"123456\"]}','2018-05-25 01:40:04','2018-05-25 01:40:04');

/*!40000 ALTER TABLE `admin_operation_log` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table admin_permissions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `admin_permissions`;

CREATE TABLE `admin_permissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `http_method` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `http_path` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `admin_permissions_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `admin_permissions` WRITE;
/*!40000 ALTER TABLE `admin_permissions` DISABLE KEYS */;

INSERT INTO `admin_permissions` (`id`, `name`, `slug`, `http_method`, `http_path`, `created_at`, `updated_at`)
VALUES
	(1,'All permission','*','','*',NULL,NULL),
	(2,'Dashboard','dashboard','GET','/',NULL,NULL),
	(3,'Login','auth.login','','/auth/login\r\n/auth/logout',NULL,NULL),
	(4,'User setting','auth.setting','GET,PUT','/auth/setting',NULL,NULL),
	(5,'Auth management','auth.management','','/auth/roles\r\n/auth/permissions\r\n/auth/menu\r\n/auth/logs',NULL,NULL),
	(6,'Api tester','ext.api-tester',NULL,'/api-tester*','2018-05-25 01:33:13','2018-05-25 01:33:13');

/*!40000 ALTER TABLE `admin_permissions` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table admin_role_menu
# ------------------------------------------------------------

DROP TABLE IF EXISTS `admin_role_menu`;

CREATE TABLE `admin_role_menu` (
  `role_id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  KEY `admin_role_menu_role_id_menu_id_index` (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `admin_role_menu` WRITE;
/*!40000 ALTER TABLE `admin_role_menu` DISABLE KEYS */;

INSERT INTO `admin_role_menu` (`role_id`, `menu_id`, `created_at`, `updated_at`)
VALUES
	(1,2,NULL,NULL);

/*!40000 ALTER TABLE `admin_role_menu` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table admin_role_permissions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `admin_role_permissions`;

CREATE TABLE `admin_role_permissions` (
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  KEY `admin_role_permissions_role_id_permission_id_index` (`role_id`,`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `admin_role_permissions` WRITE;
/*!40000 ALTER TABLE `admin_role_permissions` DISABLE KEYS */;

INSERT INTO `admin_role_permissions` (`role_id`, `permission_id`, `created_at`, `updated_at`)
VALUES
	(1,1,NULL,NULL);

/*!40000 ALTER TABLE `admin_role_permissions` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table admin_role_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `admin_role_users`;

CREATE TABLE `admin_role_users` (
  `role_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  KEY `admin_role_users_role_id_user_id_index` (`role_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `admin_role_users` WRITE;
/*!40000 ALTER TABLE `admin_role_users` DISABLE KEYS */;

INSERT INTO `admin_role_users` (`role_id`, `user_id`, `created_at`, `updated_at`)
VALUES
	(1,1,NULL,NULL);

/*!40000 ALTER TABLE `admin_role_users` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table admin_roles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `admin_roles`;

CREATE TABLE `admin_roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `admin_roles_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `admin_roles` WRITE;
/*!40000 ALTER TABLE `admin_roles` DISABLE KEYS */;

INSERT INTO `admin_roles` (`id`, `name`, `slug`, `created_at`, `updated_at`)
VALUES
	(1,'Administrator','administrator','2018-05-18 01:04:20','2018-05-18 01:04:20');

/*!40000 ALTER TABLE `admin_roles` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table admin_user_permissions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `admin_user_permissions`;

CREATE TABLE `admin_user_permissions` (
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  KEY `admin_user_permissions_user_id_permission_id_index` (`user_id`,`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



# Dump of table admin_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `admin_users`;

CREATE TABLE `admin_users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `admin_users_username_unique` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `admin_users` WRITE;
/*!40000 ALTER TABLE `admin_users` DISABLE KEYS */;

INSERT INTO `admin_users` (`id`, `username`, `password`, `name`, `avatar`, `remember_token`, `created_at`, `updated_at`)
VALUES
	(1,'admin','$2y$10$w2cARS1CEXYRb1vJpLN6O.rEZaB0cPOz1MgD7QFmELpKHSsfJscTS','Administrator',NULL,NULL,'2018-05-18 01:04:20','2018-05-18 01:04:20');

/*!40000 ALTER TABLE `admin_users` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table currency
# ------------------------------------------------------------

DROP TABLE IF EXISTS `currency`;

CREATE TABLE `currency` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `logo` varchar(255) DEFAULT NULL,
  `code` char(10) DEFAULT NULL COMMENT '代号',
  `name` varchar(64) DEFAULT NULL COMMENT '货币名称',
  `symbol` char(10) DEFAULT NULL COMMENT '货币符号',
  `is_virtual` tinyint(1) DEFAULT NULL COMMENT '是否虚拟货币，1：是，0：否',
  `decimals` smallint(5) DEFAULT '0' COMMENT '小数点',
  `min_trading_val` decimal(30,8) unsigned DEFAULT NULL COMMENT '最小交易额',
  `min_withdraw_amount` decimal(30,8) unsigned DEFAULT NULL COMMENT '最小提现额',
  `trading_service_rate` decimal(30,8) unsigned DEFAULT NULL COMMENT '交易手续费率',
  `withdraw_service_charge` decimal(30,8) DEFAULT NULL COMMENT '提现手续费',
  `fee` decimal(30,18) unsigned DEFAULT NULL COMMENT '旷工费',
  `is_base_currency` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '基础货币：0：否，1：是',
  `enable_deposit` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否开启充值，0：关闭，1：开启',
  `enable_withdraw` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否开启提现，0：关闭，1：开启',
  `up_number_audit` decimal(30,8) DEFAULT NULL COMMENT '充值审核额度',
  `extract_number_audit` decimal(30,8) DEFAULT NULL COMMENT '提现额度审核设置',
  `transfer_number` decimal(30,8) DEFAULT NULL COMMENT '转币额度设置',
  `recharge_number_audit` decimal(30,8) unsigned DEFAULT NULL COMMENT '生成充值码审核',
  `confirmations` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '网络确认',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否启用，1：启用，0：关闭',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='货币表';

LOCK TABLES `currency` WRITE;
/*!40000 ALTER TABLE `currency` DISABLE KEYS */;

INSERT INTO `currency` (`id`, `logo`, `code`, `name`, `symbol`, `is_virtual`, `decimals`, `min_trading_val`, `min_withdraw_amount`, `trading_service_rate`, `withdraw_service_charge`, `fee`, `is_base_currency`, `enable_deposit`, `enable_withdraw`, `up_number_audit`, `extract_number_audit`, `transfer_number`, `recharge_number_audit`, `confirmations`, `status`, `created_at`, `updated_at`)
VALUES
	(1,'currencies/6250754.png','ETH','以太币',NULL,1,18,0.00001000,NULL,0.00100000,0.00001000,0.000000008897163264,1,1,1,NULL,100.00000000,NULL,1000.00000000,2,1,'2017-11-10 03:20:13','2018-05-18 06:17:03');

/*!40000 ALTER TABLE `currency` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table deposits_addresses
# ------------------------------------------------------------

DROP TABLE IF EXISTS `deposits_addresses`;

CREATE TABLE `deposits_addresses` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` bigint(11) NOT NULL COMMENT '用户id',
  `currency` int(10) unsigned NOT NULL COMMENT '货币id',
  `address` varchar(255) NOT NULL COMMENT '地址',
  `password` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态，1：正常，0：删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `currency_address` (`currency`,`address`) USING BTREE,
  KEY `uid_currency` (`uid`,`currency`,`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户充值地址';

LOCK TABLES `deposits_addresses` WRITE;
/*!40000 ALTER TABLE `deposits_addresses` DISABLE KEYS */;

INSERT INTO `deposits_addresses` (`id`, `uid`, `currency`, `address`, `password`, `created_at`, `updated_at`, `status`)
VALUES
	(1,4,1,'a8d15e62c23bdded5a6929fb38f5ac21',NULL,'2018-05-26 23:15:24','2018-05-26 23:15:24',1);

/*!40000 ALTER TABLE `deposits_addresses` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table deposits_addresses_related
# ------------------------------------------------------------

DROP TABLE IF EXISTS `deposits_addresses_related`;

CREATE TABLE `deposits_addresses_related` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户UID',
  `address_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '充值地址',
  `currency` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '虚拟币',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `deposits_addresses_related` WRITE;
/*!40000 ALTER TABLE `deposits_addresses_related` DISABLE KEYS */;

INSERT INTO `deposits_addresses_related` (`id`, `uid`, `address_id`, `currency`, `status`, `created_at`, `updated_at`)
VALUES
	(1,4,1,1,1,'2018-05-26 15:15:58','2018-05-26 15:15:58');

/*!40000 ALTER TABLE `deposits_addresses_related` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table deposits_orders
# ------------------------------------------------------------

DROP TABLE IF EXISTS `deposits_orders`;

CREATE TABLE `deposits_orders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` bigint(11) NOT NULL COMMENT '用户id',
  `currency` int(10) unsigned NOT NULL COMMENT '货币id',
  `fee` decimal(32,18) unsigned NOT NULL COMMENT '矿工费',
  `amount` decimal(32,18) unsigned NOT NULL COMMENT '充值金额',
  `address` varchar(255) NOT NULL COMMENT '充值地址',
  `txid` varchar(255) NOT NULL COMMENT '交易哈希',
  `txout` bigint(20) unsigned NOT NULL COMMENT '充值到账详情索引',
  `confirmations` int(10) unsigned NOT NULL COMMENT '确认数',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注，存放审核失败等信息',
  `status` tinyint(4) NOT NULL DEFAULT '3' COMMENT '状态，3：等待足够确认数，2：等待审核，1：成功，0：审核失败',
  `done_at` timestamp NULL DEFAULT NULL COMMENT '完成时间',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `currency_txid` (`currency`,`txid`) USING BTREE,
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户充值记录';



# Dump of table erc20_tokens
# ------------------------------------------------------------

DROP TABLE IF EXISTS `erc20_tokens`;

CREATE TABLE `erc20_tokens` (
  `currency` int(10) unsigned NOT NULL,
  `contract` varchar(64) NOT NULL,
  PRIMARY KEY (`currency`),
  UNIQUE KEY `contract` (`contract`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `erc20_tokens` WRITE;
/*!40000 ALTER TABLE `erc20_tokens` DISABLE KEYS */;

INSERT INTO `erc20_tokens` (`currency`, `contract`)
VALUES
	(3,'0x86fa049857e0209aa7d9e616f7eb3b3b78ecfdb0'),
	(7,'0xD2E8F88dDdb95704C17E78E1cb07Ae3812DdfA24');

/*!40000 ALTER TABLE `erc20_tokens` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table feedback
# ------------------------------------------------------------

DROP TABLE IF EXISTS `feedback`;

CREATE TABLE `feedback` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `contact` varchar(255) DEFAULT NULL,
  `content` text,
  `remark` text,
  `status` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;



# Dump of table guess
# ------------------------------------------------------------

DROP TABLE IF EXISTS `guess`;

CREATE TABLE `guess` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `currency` int(10) unsigned DEFAULT '0' COMMENT '竞猜货币ID',
  `title` varchar(64) DEFAULT NULL COMMENT '竞猜标题',
  `expect_price` decimal(30,18) unsigned DEFAULT '0.000000000000000000' COMMENT '竞猜低价',
  `max_amount` decimal(30,18) unsigned DEFAULT '0.000000000000000000' COMMENT '最高投注',
  `min_amount` decimal(30,18) unsigned DEFAULT '0.000000000000000000' COMMENT '最低投注',
  `sum_amount` decimal(30,18) unsigned DEFAULT '0.000000000000000000' COMMENT '参与总额',
  `price` decimal(30,18) unsigned DEFAULT '0.000000000000000000' COMMENT '最终价格',
  `charges` decimal(30,18) unsigned DEFAULT '0.000000000000000000' COMMENT '平台运营手续费',
  `start_time` varchar(255) DEFAULT NULL COMMENT '开始时间',
  `end_time` varchar(255) DEFAULT NULL COMMENT '结束时间',
  `open_time` varchar(255) DEFAULT NULL COMMENT '开奖时间',
  `period` int(255) unsigned DEFAULT NULL COMMENT '周期',
  `number` int(10) unsigned DEFAULT '0' COMMENT '参与人数',
  `status` tinyint(1) unsigned DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `guess` WRITE;
/*!40000 ALTER TABLE `guess` DISABLE KEYS */;

INSERT INTO `guess` (`id`, `currency`, `title`, `expect_price`, `max_amount`, `min_amount`, `sum_amount`, `price`, `charges`, `start_time`, `end_time`, `open_time`, `period`, `number`, `status`, `created_at`, `updated_at`)
VALUES
	(1,1,'快讯',0.010000000000000000,10000.000000000000000000,1.000000000000000000,3.000000000000000000,0.010000000000000000,20.000000000000000000,'2018-05-20 15:00:00','2018-05-20 23:00:00','2018-05-21 23:00:00',1,3,1,'2018-05-20 04:38:17','2018-05-26 19:18:50');

/*!40000 ALTER TABLE `guess` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table guess_orders
# ------------------------------------------------------------

DROP TABLE IF EXISTS `guess_orders`;

CREATE TABLE `guess_orders` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '竞猜用户',
  `currency` int(10) unsigned DEFAULT '0' COMMENT '竞猜虚拟币ID',
  `guess_id` int(10) unsigned DEFAULT '0' COMMENT '竞猜id',
  `expect_price` decimal(30,18) unsigned DEFAULT NULL COMMENT '竞猜点数',
  `amount` decimal(30,18) unsigned DEFAULT '0.000000000000000000' COMMENT '竞猜费用',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `guess_orders` WRITE;
/*!40000 ALTER TABLE `guess_orders` DISABLE KEYS */;

INSERT INTO `guess_orders` (`id`, `uid`, `currency`, `guess_id`, `expect_price`, `amount`, `created_at`, `updated_at`)
VALUES
	(1,4,1,1,5000.000000000000000000,1.000000000000000000,'2018-05-26 11:18:26','2018-05-26 11:18:26'),
	(2,4,1,1,5000.000000000000000000,1.000000000000000000,'2018-05-26 11:19:01','2018-05-26 11:19:01'),
	(3,4,1,1,5000.000000000000000000,1.000000000000000000,'2018-05-26 11:19:07','2018-05-26 11:19:07');

/*!40000 ALTER TABLE `guess_orders` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table migrations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `migrations`;

CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;

INSERT INTO `migrations` (`id`, `migration`, `batch`)
VALUES
	(1,'2014_10_12_000000_create_users_table',1),
	(2,'2014_10_12_100000_create_password_resets_table',1),
	(3,'2016_01_04_173148_create_admin_tables',1),
	(4,'2016_06_01_000001_create_oauth_auth_codes_table',2),
	(5,'2016_06_01_000002_create_oauth_access_tokens_table',2),
	(6,'2016_06_01_000003_create_oauth_refresh_tokens_table',2),
	(7,'2016_06_01_000004_create_oauth_clients_table',2),
	(8,'2016_06_01_000005_create_oauth_personal_access_clients_table',2);

/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table news
# ------------------------------------------------------------

DROP TABLE IF EXISTS `news`;

CREATE TABLE `news` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `author_id` int(11) NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci,
  `slug` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('ACTIVE','INACTIVE') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE',
  `visited` int(10) unsigned NOT NULL DEFAULT '0',
  `displayorder` smallint(5) unsigned DEFAULT '99',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;

INSERT INTO `news` (`id`, `author_id`, `title`, `description`, `content`, `slug`, `status`, `visited`, `displayorder`, `created_at`, `updated_at`)
VALUES
	(16,1,'第一个聊天室','第一个聊天室','<p>第一个聊天室</p>',NULL,'ACTIVE',0,1,'2018-05-24 15:45:13','2018-05-24 16:04:53'),
	(17,1,'第一个聊天室','第一个聊天室','<p>第一个聊天室</p>',NULL,'ACTIVE',0,2,'2018-05-24 15:45:31','2018-05-24 16:05:02');

/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table oauth_access_tokens
# ------------------------------------------------------------

DROP TABLE IF EXISTS `oauth_access_tokens`;

CREATE TABLE `oauth_access_tokens` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `client_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_access_tokens_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `oauth_access_tokens` WRITE;
/*!40000 ALTER TABLE `oauth_access_tokens` DISABLE KEYS */;

INSERT INTO `oauth_access_tokens` (`id`, `user_id`, `client_id`, `name`, `scopes`, `revoked`, `created_at`, `updated_at`, `expires_at`)
VALUES
	('061a5de4f97f7dc180ee4b334d71b149282030543b1a47890931cedde62301faf6dee95733ca42d2',10,2,NULL,'[]',0,'2018-05-27 01:07:15','2018-05-27 01:07:15','2018-06-11 01:07:15'),
	('0eaa48418e6d2b3b19b14ed9660f5f6ea57c726cedaf0af7fd82e9dcc75abd359dc85b9a8ef608f3',1,2,NULL,'[]',0,'2018-05-25 01:16:31','2018-05-25 01:16:31','2018-06-09 01:16:31'),
	('1bf964c50cbda02d749c18339a3582f6d68813803e87d8910b7dfc7277772fbf889f8248cdb8ef60',2,2,NULL,'[]',0,'2018-05-27 01:23:35','2018-05-27 01:23:35','2018-06-11 01:23:35'),
	('2e04f5b7283ee254a5904e79843e6314f94e57a5cc47c198af3beceeb120c8e9beab57f81ac42acc',4,2,NULL,'[]',0,'2018-05-26 07:35:50','2018-05-26 07:35:50','2018-06-10 07:35:50'),
	('2e80eca78467ec675a19411516b2bea27b57b76a80440f42f473c9d1eca073ff87ef321270929db0',1,2,NULL,'[]',0,'2018-05-27 00:51:15','2018-05-27 00:51:15','2018-06-11 00:51:15'),
	('31ee62692edfec8aeba3859ed59929f794642326459f7864a3bcd307701abb70e4c0b12e9ec18ce8',10,2,NULL,'[]',0,'2018-05-27 01:37:17','2018-05-27 01:37:17','2018-06-11 01:37:17'),
	('42c789d826c52e03d69f8deb26d83b6978865e7b372dcb24e9f51dc2546225c4a7dbb415bc4a9f58',1,2,NULL,'[]',0,'2018-05-27 00:56:42','2018-05-27 00:56:42','2018-06-11 00:56:42'),
	('5a19d626c766ba2531d11442cd4f26d2c5c188caa43c17726fb9dd9f15d20c8779d088f6cfe6b316',1,2,NULL,'[]',0,'2018-05-25 01:15:43','2018-05-25 01:15:43','2018-06-09 01:15:43'),
	('675e12ab022c4f8e83ec2d062e03f8dd669796e7ef9bb7fb47fedc7f93c4758cecd47e1b703db589',9,2,NULL,'[]',0,'2018-05-26 07:38:29','2018-05-26 07:38:29','2018-06-10 07:38:28'),
	('691ea4d43c502b6363c5f7659949fef0dc73e999a634f6f883cd896024293039300f8d3ba9c381fe',4,2,NULL,'[]',0,'2018-05-26 07:30:04','2018-05-26 07:30:04','2018-06-10 07:30:04'),
	('71661a3769124647c189cbb68a27c03313766e9f11fb6a6f1b265edc0a4ae8b85fef71832f4b60ca',1,2,NULL,'[]',0,'2018-05-27 00:49:36','2018-05-27 00:49:36','2018-06-11 00:49:36'),
	('789f172804c01c62684ba057aad50e7461b4b5c98593775a59c7bcceed445b2795303d0141e6d972',8,2,NULL,'[]',0,'2018-05-25 10:01:15','2018-05-25 10:01:15','2018-06-09 10:01:15'),
	('838abb34663e31d52f4c4247426fcba9c7a7b0eec984e2a33eabd10eb90df234d75a7e64a73c70f9',7,2,NULL,'[]',0,'2018-05-25 09:59:23','2018-05-25 09:59:23','2018-06-09 09:59:23'),
	('872db0844aef2146154729d498e29dd5ab502efe01f34356c344e5b4ea9deb5cebff6930b13b739e',1,2,NULL,'[]',0,'2018-05-27 00:52:09','2018-05-27 00:52:09','2018-06-11 00:52:09'),
	('8c12e9f9a46c53eabf1c8ba70fcfb181aaf97fee4b30f64aae8138a2f62155d6a7b1c406536d74a7',10,2,NULL,'[]',0,'2018-05-27 13:05:01','2018-05-27 13:05:01','2018-06-11 13:05:01'),
	('8d5de6e0e6289078272a4352baec3f70bbd9e6aac80be69168cbfa86d64f2bad2f1f1c2f1de4f479',4,2,NULL,'[]',0,'2018-05-26 07:34:36','2018-05-26 07:34:36','2018-06-10 07:34:36'),
	('9982baf569956bc6ad3b8269cb34c1c390a1b03d34574f3260944c6b24bbf995d9d04ddfb87f08a2',1,2,NULL,'[]',0,'2018-05-27 01:22:27','2018-05-27 01:22:27','2018-06-11 01:22:27'),
	('9a67114fb31d1bb398b9548d45163be879fcd486a3248ac23468cce10dc581760131f69dd867644a',9,2,NULL,'[]',0,'2018-05-27 01:23:47','2018-05-27 01:23:47','2018-06-11 01:23:47'),
	('bd3e33536c40a40ba954a47e4274a44bb1d2d62a6fa9d862bb4fbc2d8e2a4b307035159998bf9bed',10,2,NULL,'[]',0,'2018-05-27 01:23:55','2018-05-27 01:23:55','2018-06-11 01:23:55'),
	('bf6c23b1efaea03344df02db9a5d05c870bf400eb31fd5dc1fee6d1a3d88c87eb035db723e33a2cf',10,2,NULL,'[]',0,'2018-05-27 13:14:56','2018-05-27 13:14:56','2018-06-11 13:14:56'),
	('c92c81c749c34fb7157f5014db48f7c98fcfe8df91989ece499db6e6a683ab75d8ee03e60690c0e2',1,2,NULL,'[]',0,'2018-05-27 00:53:35','2018-05-27 00:53:35','2018-06-11 00:53:35'),
	('e0a802c9559e152ce3316ca4683c1dc128f4c123953c59eab374ff7f0bd15b6fe879f9fbd0bc3e1b',4,2,NULL,'[]',0,'2018-05-26 07:31:37','2018-05-26 07:31:37','2018-06-10 07:31:37'),
	('e0eb28315e837933884a4e71d8bd29f84fb052a9348e324380c56918ca91ef5edd433d530a7a9a66',4,2,NULL,'[]',0,'2018-05-25 01:28:05','2018-05-25 01:28:05','2018-06-09 01:28:05'),
	('ea2b367c2bd8c4b38df4d908f02f664533dd463b3b0555b6e07cb0f61419ed309c62bd5dc9d525d3',4,2,NULL,'[]',0,'2018-05-26 07:36:19','2018-05-26 07:36:19','2018-06-10 07:36:19'),
	('ec50853f2ef5da3ba8823c9e184bea71c03cb626a13a1f147dc0ecdb557a46ca9a43ccc82f442805',10,2,NULL,'[]',0,'2018-05-27 01:24:10','2018-05-27 01:24:10','2018-06-11 01:24:10');

/*!40000 ALTER TABLE `oauth_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table oauth_auth_codes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `oauth_auth_codes`;

CREATE TABLE `oauth_auth_codes` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



# Dump of table oauth_clients
# ------------------------------------------------------------

DROP TABLE IF EXISTS `oauth_clients`;

CREATE TABLE `oauth_clients` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `secret` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `redirect` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `personal_access_client` tinyint(1) NOT NULL,
  `password_client` tinyint(1) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_clients_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `oauth_clients` WRITE;
/*!40000 ALTER TABLE `oauth_clients` DISABLE KEYS */;

INSERT INTO `oauth_clients` (`id`, `user_id`, `name`, `secret`, `redirect`, `personal_access_client`, `password_client`, `revoked`, `created_at`, `updated_at`)
VALUES
	(1,NULL,'Laravel Personal Access Client','e6FIyZ5nbVSROsuLlS8ABjSvMOcMO8l6tciuFyHe','http://localhost',1,0,0,'2018-03-14 07:13:20','2018-03-14 07:13:20'),
	(2,NULL,'Laravel Password Grant Client','mlCfl0HG0Y2H2mBsoOpXatS4b30Nf1gn0r72iZHk','http://localhost',0,1,0,'2018-03-14 07:13:20','2018-03-14 07:13:20'),
	(3,1,'1','nKDdQaJF0SWslafGluifQA57gyUPf5H8aqGgaeTW','http://ethz.me/auth/callback',0,0,0,'2018-05-25 00:43:43','2018-05-25 00:43:43');

/*!40000 ALTER TABLE `oauth_clients` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table oauth_personal_access_clients
# ------------------------------------------------------------

DROP TABLE IF EXISTS `oauth_personal_access_clients`;

CREATE TABLE `oauth_personal_access_clients` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_personal_access_clients_client_id_index` (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `oauth_personal_access_clients` WRITE;
/*!40000 ALTER TABLE `oauth_personal_access_clients` DISABLE KEYS */;

INSERT INTO `oauth_personal_access_clients` (`id`, `client_id`, `created_at`, `updated_at`)
VALUES
	(1,1,'2018-05-25 00:40:11','2018-05-25 00:40:11');

/*!40000 ALTER TABLE `oauth_personal_access_clients` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table oauth_refresh_tokens
# ------------------------------------------------------------

DROP TABLE IF EXISTS `oauth_refresh_tokens`;

CREATE TABLE `oauth_refresh_tokens` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `access_token_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_refresh_tokens_access_token_id_index` (`access_token_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `oauth_refresh_tokens` WRITE;
/*!40000 ALTER TABLE `oauth_refresh_tokens` DISABLE KEYS */;

INSERT INTO `oauth_refresh_tokens` (`id`, `access_token_id`, `revoked`, `expires_at`)
VALUES
	('001f989f230afc7967b7210fd103c5d0bc2451c263d9a94c7f33ad7b475eacc4f4e62298ad20e368','675e12ab022c4f8e83ec2d062e03f8dd669796e7ef9bb7fb47fedc7f93c4758cecd47e1b703db589',0,'2018-06-25 07:38:28'),
	('090551620b682853500267c578db7da34457780851a3ad2ddfeb7f373f574dfbb96ff8474e9eabb4','bd3e33536c40a40ba954a47e4274a44bb1d2d62a6fa9d862bb4fbc2d8e2a4b307035159998bf9bed',0,'2018-06-26 01:23:55'),
	('09e810604faf8254fcafb9403f9148e582a334b04ccada3f36f816aba5c98dd6c6717c5573f05af5','9a67114fb31d1bb398b9548d45163be879fcd486a3248ac23468cce10dc581760131f69dd867644a',0,'2018-06-26 01:23:47'),
	('0a904cb8eee7bf18bd1da9cb23aad91038873d1d6c63bf8afeea8abdaa092e8cd365771b7fabf9fd','061a5de4f97f7dc180ee4b334d71b149282030543b1a47890931cedde62301faf6dee95733ca42d2',0,'2018-06-26 01:07:15'),
	('0e35c839c8a620a730d98fe018a84fcdf4755c473c439f7d8accd8d8b077d6b89e86ca6e81095d60','42c789d826c52e03d69f8deb26d83b6978865e7b372dcb24e9f51dc2546225c4a7dbb415bc4a9f58',0,'2018-06-26 00:56:42'),
	('2fec51d13e6555ba7f3166452d2116e3eee6aaf89a7273b72334a3f1498e2d1f305884a0a7c5867e','9982baf569956bc6ad3b8269cb34c1c390a1b03d34574f3260944c6b24bbf995d9d04ddfb87f08a2',0,'2018-06-26 01:22:27'),
	('50152924f1cb7c23a7a7d8f5bb648690248e5031f44f0d7b800df37081d3d10412e6e67eb45de361','ea2b367c2bd8c4b38df4d908f02f664533dd463b3b0555b6e07cb0f61419ed309c62bd5dc9d525d3',0,'2018-06-25 07:36:19'),
	('571460d032aaf7942c94cc1689d54404105e70e5cb7e0e7ff59bf568e61ae12b9fe7b0c3b72783e5','2e80eca78467ec675a19411516b2bea27b57b76a80440f42f473c9d1eca073ff87ef321270929db0',0,'2018-06-26 00:51:15'),
	('5b154ed64a9e85bf6f76c73a65a2210ac9f91d0f8356a4c4d55d7b36fb4c73c4dce74bfd5749f6a3','0eaa48418e6d2b3b19b14ed9660f5f6ea57c726cedaf0af7fd82e9dcc75abd359dc85b9a8ef608f3',0,'2018-06-24 01:16:31'),
	('65c2980ba5b0ef65c47425359ac3dbc4765e832990a55a870b93a5ba6c52fa4a7f43573630679021','e0a802c9559e152ce3316ca4683c1dc128f4c123953c59eab374ff7f0bd15b6fe879f9fbd0bc3e1b',0,'2018-06-25 07:31:37'),
	('6a9a8a7f38bc2fd45c0471fd22132f0e30b36a39640beda8b10e160b74c10334478502d4c582ff0e','5a19d626c766ba2531d11442cd4f26d2c5c188caa43c17726fb9dd9f15d20c8779d088f6cfe6b316',0,'2018-06-24 01:15:43'),
	('6d0de1e884f6ac8e1c69610faa9538c17ddc4941380b24efcfb08049828d37adf23a80c001aa185e','c92c81c749c34fb7157f5014db48f7c98fcfe8df91989ece499db6e6a683ab75d8ee03e60690c0e2',0,'2018-06-26 00:53:35'),
	('71231343c37b25b9b96608b76a33b12bedccfe8e99073547beed9c1540f414dd7bdd3032ff3d19bb','71661a3769124647c189cbb68a27c03313766e9f11fb6a6f1b265edc0a4ae8b85fef71832f4b60ca',0,'2018-06-26 00:49:36'),
	('8eb1d6273450c55afda934396d0eb7336c23e9f9ed4c3fd63ca803bf99bf79a851cf38a169451f96','789f172804c01c62684ba057aad50e7461b4b5c98593775a59c7bcceed445b2795303d0141e6d972',0,'2018-06-24 10:01:15'),
	('98481ef2b3f56d249e076d9a4721669314e9f723491a86da54490aeb570b265c673a92e45f667f58','2e04f5b7283ee254a5904e79843e6314f94e57a5cc47c198af3beceeb120c8e9beab57f81ac42acc',0,'2018-06-25 07:35:50'),
	('a1c804984ef26c74c7a68653fe761fed0d497a2e6c6e45cbf8efe6397b3001bdeec6383f76fa4c45','8c12e9f9a46c53eabf1c8ba70fcfb181aaf97fee4b30f64aae8138a2f62155d6a7b1c406536d74a7',0,'2018-06-26 13:05:01'),
	('a9ec6a8ecd91e36ef34b5203151defa413313976db302468e1a43d66c1b44aa8cce3b6b28c3bf021','ec50853f2ef5da3ba8823c9e184bea71c03cb626a13a1f147dc0ecdb557a46ca9a43ccc82f442805',0,'2018-06-26 01:24:10'),
	('acab87f6e86f21255c8076ca5d1ba34b408c1c159dafd79d1a70f2eb097a055ee981bc892325a46f','691ea4d43c502b6363c5f7659949fef0dc73e999a634f6f883cd896024293039300f8d3ba9c381fe',0,'2018-06-25 07:30:04'),
	('aec6f911adde3cc48a903a94da3e871f8aaa214f38f8e903432e03926f4dce90e2746b2478b6ff16','838abb34663e31d52f4c4247426fcba9c7a7b0eec984e2a33eabd10eb90df234d75a7e64a73c70f9',0,'2018-06-24 09:59:23'),
	('c171172f9075208d6d15ab911d517513b7d30e3e54fca4d5409b19d99233337834022858f5771ae9','31ee62692edfec8aeba3859ed59929f794642326459f7864a3bcd307701abb70e4c0b12e9ec18ce8',0,'2018-06-26 01:37:17'),
	('c98a19ba9cb04715afaf4a2c1d85a96852803850442db916ba9daf207265348b91b2e2e0a2693300','872db0844aef2146154729d498e29dd5ab502efe01f34356c344e5b4ea9deb5cebff6930b13b739e',0,'2018-06-26 00:52:09'),
	('d6f5c8d0847a5d9f7e5a00d376c493d57bb5059da5e02de47404c8bd70a87f5a838e2e73213bc033','8d5de6e0e6289078272a4352baec3f70bbd9e6aac80be69168cbfa86d64f2bad2f1f1c2f1de4f479',0,'2018-06-25 07:34:36'),
	('da42e29aa0d8dbe7d161a15ec334204ff0518adfad593ed1d370962507a4b605160d3d8a3e935b1c','e0eb28315e837933884a4e71d8bd29f84fb052a9348e324380c56918ca91ef5edd433d530a7a9a66',0,'2018-06-24 01:28:05'),
	('e8766ab3050f65a6c25619d6167bf96aa9c861929c0006b24bea02f607d952e6f4169370f7a541ef','1bf964c50cbda02d749c18339a3582f6d68813803e87d8910b7dfc7277772fbf889f8248cdb8ef60',0,'2018-06-26 01:23:35'),
	('e92dbb714a31edf342cffb4f9ac4f3d96515e75dcf090396b594c6baccba29ed5621461fe29b4066','bf6c23b1efaea03344df02db9a5d05c870bf400eb31fd5dc1fee6d1a3d88c87eb035db723e33a2cf',0,'2018-06-26 13:14:56');

/*!40000 ALTER TABLE `oauth_refresh_tokens` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table password_resets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `password_resets`;

CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mobile` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `win_count` int(11) DEFAULT NULL,
  `invite_count` int(11) unsigned DEFAULT '0',
  `invite_uid` int(11) unsigned DEFAULT '0',
  `invite_code` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_delete` tinyint(1) unsigned DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;

INSERT INTO `users` (`id`, `name`, `email`, `mobile`, `password`, `avatar`, `win_count`, `invite_count`, `invite_uid`, `invite_code`, `remember_token`, `ip`, `is_delete`, `created_at`, `updated_at`)
VALUES
	(1,'zohar01','zohar@qq.com',NULL,'$2y$10$2pBBi/tjuIxGNZO72va8wuy1QQxR0D6QoZerX2lP0i.hLMtmcn1RW','1',NULL,NULL,0,'ASDCVFSAA','AYUKiuDhaQgagTtayoIz94xxIkTMTplNceLA6807hkd5llNJobrlxLD5bVsh',NULL,0,'2018-05-18 04:43:27','2018-05-20 08:10:36'),
	(2,'ddddd','ddddd@qq.com',NULL,'$2y$10$0gd6m5YUtyaKO.gvmlIAjOWIkNc7m2XPfbPVIZazs3T19.sVc7bA.','2',NULL,0,0,'5B012D7CE06F3','ZhtVSu5erLOY9NM7OCYVB6p1KBnGrsJXHVsjfvyftDKMA3i2JJZEGeKxUXKl',NULL,0,'2018-05-20 08:05:09','2018-05-20 08:05:09'),
	(3,'token','token@qq.com',NULL,'$2y$10$.Bi8DXAs9zh7DhzjwTlGi.TMMaqwBMeTxG5lF1voIO4zeGcwR/m82','3',NULL,1,0,'5B012D7CE06F1','ju8hE13zzPRMhDmKMHUTZgl4TGNKj7wuOz6aIUIjSwbvErosOkHdiyJQtULZ',NULL,0,'2018-05-20 08:05:49','2018-05-20 08:20:19'),
	(4,'比特币','945056167@qq.com',NULL,'$2y$10$xkH1z.rA6WnNRJlMWWBu0.R4e3ZlBmA/414/WQaIOeYe0lbWXcK/i','8',NULL,0,1,'5B012D7CE06F2','eWX4kHxot09NQvVXtDqfTJ9849KcmvAwREnvqiktsd1a5BwIl4NuUCxzjS4E',NULL,0,'2018-05-20 08:10:36','2018-05-20 08:10:36'),
	(5,'比特币现金2','945056164@qq.com',NULL,'$2y$10$bsvrxA74kZIs2NOOz2OqlOAoyc0yzZQ8CPGZoqf0ZOW8xho/JQgS.','4',NULL,1,3,'5B012FC311A32','IePPC40DeBvG0VVq93LhAKiYXoLN832mbeqqt1sSSHAa38vCIYGqwK2jmwXf',NULL,0,'2018-05-20 08:20:19','2018-05-20 08:21:03'),
	(6,'比特币现金3','945056165@qq.com',NULL,'$2y$10$9xM4lKc.tVNcnSeJLXf9ee56oe.EX3nQC12ZXnwCJMZvWsW/hNwHy','3',NULL,3,5,'5B012FEF9DFA6','OsCRWQVQ2hLwXI78eoxzdfiAVNTqfkOFbf9S3K8OGOlXzwLrwVVv667NkHBH',NULL,0,'2018-05-20 08:21:03','2018-05-26 07:38:28'),
	(7,'710355245','710355245@qq.com',NULL,'$2y$10$82L3LvYMzhVDTWTL52VG8uJx9OihKrpXx80IbuuGmhrZPfM5hkvc2','5',NULL,0,6,'5B076DF9D2E70',NULL,NULL,0,'2018-05-25 09:59:22','2018-05-25 09:59:22'),
	(8,'710355248','710355248@qq.com',NULL,'$2y$10$b7HnNgxLGL5wPlP0WmBvEuVfGUnn5yEs4KEZhtkvXXMUXgSCufZTu','7',NULL,0,6,'5B076E6A18422',NULL,'127.0.0.1',0,'2018-05-25 10:01:14','2018-05-25 10:01:14'),
	(9,'710355249','710355249@qq.com',NULL,'$2y$10$2pBBi/tjuIxGNZO72va8wuy1QQxR0D6QoZerX2lP0i.hLMtmcn1RW','4',NULL,0,6,'5B089E73D1D5C',NULL,'127.0.0.1',0,'2018-05-26 07:38:28','2018-05-26 07:38:28'),
	(10,'123456','123456@qq.com',NULL,'$2y$10$2pBBi/tjuIxGNZO72va8wuy1QQxR0D6QoZerX2lP0i.hLMtmcn1RW','7',NULL,0,0,'5B0994427F6B3',NULL,'127.0.0.1',0,'2018-05-27 01:07:14','2018-05-27 01:07:14');

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table users_invit
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users_invit`;

CREATE TABLE `users_invit` (
  `uid` int(11) unsigned NOT NULL,
  `first_uid` int(11) NOT NULL DEFAULT '0',
  `second_uid` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户层次管理';

LOCK TABLES `users_invit` WRITE;
/*!40000 ALTER TABLE `users_invit` DISABLE KEYS */;

INSERT INTO `users_invit` (`uid`, `first_uid`, `second_uid`, `created_at`, `updated_at`)
VALUES
	(5,3,0,'2018-05-20 08:20:19','2018-05-20 08:20:19'),
	(6,5,3,'2018-05-20 08:21:03','2018-05-20 08:21:03'),
	(7,6,5,'2018-05-25 09:59:22','2018-05-25 09:59:22'),
	(8,6,5,'2018-05-25 10:01:14','2018-05-25 10:01:14'),
	(9,6,5,'2018-05-26 07:38:28','2018-05-26 07:38:28');

/*!40000 ALTER TABLE `users_invit` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table withdraws_addresses
# ------------------------------------------------------------

DROP TABLE IF EXISTS `withdraws_addresses`;

CREATE TABLE `withdraws_addresses` (
  `id` bigint(24) unsigned NOT NULL AUTO_INCREMENT,
  `uid` bigint(11) NOT NULL COMMENT '用户id',
  `currency` int(10) unsigned NOT NULL COMMENT '货币id',
  `name` varchar(255) NOT NULL COMMENT '名称',
  `address` varchar(255) NOT NULL COMMENT '地址',
  `is_default` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否默认',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态，1：正常，0：删除',
  PRIMARY KEY (`id`),
  KEY `uid_currency` (`uid`,`currency`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户提现地址';

LOCK TABLES `withdraws_addresses` WRITE;
/*!40000 ALTER TABLE `withdraws_addresses` DISABLE KEYS */;

INSERT INTO `withdraws_addresses` (`id`, `uid`, `currency`, `name`, `address`, `is_default`, `created_at`, `updated_at`, `status`)
VALUES
	(1,2,3,'imToken','0x812503D22C62f39e683a14E5B8469e0DFFf35002',0,'2018-01-24 16:41:38','2018-01-24 16:41:38',1),
	(2,2,3,'free','0x5D2bd3Cc7a2f37b2142828FfE9834b083a7eE4F9',0,'2018-01-29 16:29:01','2018-01-29 16:29:01',1);

/*!40000 ALTER TABLE `withdraws_addresses` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table withdraws_orders
# ------------------------------------------------------------

DROP TABLE IF EXISTS `withdraws_orders`;

CREATE TABLE `withdraws_orders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` bigint(11) NOT NULL COMMENT '用户id',
  `currency` int(10) unsigned NOT NULL COMMENT '货币id',
  `fee` decimal(32,18) unsigned NOT NULL COMMENT '矿工费',
  `service_charge` decimal(32,18) DEFAULT NULL,
  `amount` decimal(32,18) unsigned NOT NULL COMMENT '到账金额',
  `sum_amount` decimal(32,18) unsigned NOT NULL COMMENT '总金额',
  `address_name` varchar(255) NOT NULL COMMENT '提现地址名称',
  `address` varchar(255) NOT NULL COMMENT '提现地址',
  `txid` varchar(255) DEFAULT NULL COMMENT '交易哈希',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注，存放提现失败等信息',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `done_at` timestamp NULL DEFAULT NULL COMMENT '完成时间',
  `status` tinyint(4) NOT NULL DEFAULT '3' COMMENT '状态，3：等待审核，2：等待提现，1：成功，0：审核失败，-1：提现失败',
  PRIMARY KEY (`id`),
  UNIQUE KEY `currency_txid` (`currency`,`txid`) USING BTREE,
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户提现记录';

LOCK TABLES `withdraws_orders` WRITE;
/*!40000 ALTER TABLE `withdraws_orders` DISABLE KEYS */;

INSERT INTO `withdraws_orders` (`id`, `uid`, `currency`, `fee`, `service_charge`, `amount`, `sum_amount`, `address_name`, `address`, `txid`, `remark`, `created_at`, `updated_at`, `done_at`, `status`)
VALUES
	(1,2,3,0.000100000000000000,NULL,0.000900000000000000,0.001000000000000000,'imToken','0x812503D22C62f39e683a14E5B8469e0DFFf35002','0xf78edb4e26eb7c87b6957d87045ac9e39c222bbf8af0c5d41e26c4970dc3d491','2018-01-29 15:40:35 申请提取 0.001 EOS，到地址 0x812503D22C62f39e683a14E5B8469e0DFFf35002','2018-01-29 15:39:47','2018-01-29 15:44:44','2018-01-29 15:40:36',1),
	(2,2,3,0.000100000000000000,NULL,0.000900000000000000,0.001000000000000000,'free','0x5D2bd3Cc7a2f37b2142828FfE9834b083a7eE4F9','0x223cbcfd95190bbf1ba32c21507b2777f1529c532f85bdefd25e0918dd3d62d2','2018-01-29 16:29:33 申请提取 0.001 EOS，到地址 0x5D2bd3Cc7a2f37b2142828FfE9834b083a7eE4F9','2018-01-29 16:29:20','2018-01-29 16:29:34','2018-01-29 16:29:34',1);

/*!40000 ALTER TABLE `withdraws_orders` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
