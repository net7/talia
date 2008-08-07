# CocoaMySQL dump
# Version 0.7b5
# http://cocoamysql.sourceforge.net
#
# Host: 127.0.0.1 (MySQL 5.0.51b)
# Database: Talia_development
# Generation Time: 2008-08-06 12:14:25 +0200
# ************************************************************

# Dump of table active_sources
# ------------------------------------------------------------

CREATE TABLE `active_sources` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `uri` varchar(255) NOT NULL,
  `type` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_active_sources_on_uri` (`uri`)
) ENGINE=InnoDB AUTO_INCREMENT=3314 DEFAULT CHARSET=latin1;



# Dump of table data_records
# ------------------------------------------------------------

CREATE TABLE `data_records` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(255) default NULL,
  `location` varchar(255) NOT NULL,
  `mime` varchar(255) default NULL,
  `source_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `index_data_records_on_source_id` (`source_id`),
  CONSTRAINT `data_records_to_active_sources` FOREIGN KEY (`source_id`) REFERENCES `active_sources` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1612 DEFAULT CHARSET=latin1;



# Dump of table globalize_countries
# ------------------------------------------------------------

CREATE TABLE `globalize_countries` (
  `id` int(11) NOT NULL auto_increment,
  `code` varchar(2) default NULL,
  `english_name` varchar(255) default NULL,
  `date_format` varchar(255) default NULL,
  `currency_format` varchar(255) default NULL,
  `currency_code` varchar(3) default NULL,
  `thousands_sep` varchar(2) default NULL,
  `decimal_sep` varchar(2) default NULL,
  `currency_decimal_sep` varchar(2) default NULL,
  `number_grouping_scheme` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_globalize_countries_on_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table globalize_languages
# ------------------------------------------------------------

CREATE TABLE `globalize_languages` (
  `id` int(11) NOT NULL auto_increment,
  `iso_639_1` varchar(2) default NULL,
  `iso_639_2` varchar(3) default NULL,
  `iso_639_3` varchar(3) default NULL,
  `rfc_3066` varchar(255) default NULL,
  `english_name` varchar(255) default NULL,
  `english_name_locale` varchar(255) default NULL,
  `english_name_modifier` varchar(255) default NULL,
  `native_name` varchar(255) default NULL,
  `native_name_locale` varchar(255) default NULL,
  `native_name_modifier` varchar(255) default NULL,
  `macro_language` tinyint(1) default NULL,
  `direction` varchar(255) default NULL,
  `pluralization` varchar(255) default NULL,
  `scope` varchar(1) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_globalize_languages_on_iso_639_1` (`iso_639_1`),
  KEY `index_globalize_languages_on_iso_639_2` (`iso_639_2`),
  KEY `index_globalize_languages_on_iso_639_3` (`iso_639_3`),
  KEY `index_globalize_languages_on_rfc_3066` (`rfc_3066`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table globalize_translations
# ------------------------------------------------------------

CREATE TABLE `globalize_translations` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(255) default NULL,
  `tr_key` varchar(255) default NULL,
  `table_name` varchar(255) default NULL,
  `item_id` int(11) default NULL,
  `facet` varchar(255) default NULL,
  `built_in` tinyint(1) default '1',
  `language_id` int(11) default NULL,
  `pluralization_index` int(11) default NULL,
  `text` text,
  `namespace` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_globalize_translations_on_tr_key_and_language_id` (`tr_key`,`language_id`),
  KEY `globalize_translations_table_name_and_item_and_language` (`table_name`,`item_id`,`language_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table open_id_authentication_associations
# ------------------------------------------------------------

CREATE TABLE `open_id_authentication_associations` (
  `id` int(11) NOT NULL auto_increment,
  `issued` int(11) default NULL,
  `lifetime` int(11) default NULL,
  `handle` varchar(255) default NULL,
  `assoc_type` varchar(255) default NULL,
  `server_url` blob,
  `secret` blob,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table open_id_authentication_nonces
# ------------------------------------------------------------

CREATE TABLE `open_id_authentication_nonces` (
  `id` int(11) NOT NULL auto_increment,
  `timestamp` int(11) NOT NULL,
  `server_url` varchar(255) default NULL,
  `salt` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table roles
# ------------------------------------------------------------

CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

INSERT INTO `roles` (`id`,`name`) VALUES ('1','admin');
INSERT INTO `roles` (`id`,`name`) VALUES ('2','user');


# Dump of table roles_users
# ------------------------------------------------------------

CREATE TABLE `roles_users` (
  `role_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  KEY `index_roles_users_on_role_id` (`role_id`),
  KEY `index_roles_users_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `roles_users` (`role_id`,`user_id`) VALUES ('1','1');


# Dump of table schema_info
# ------------------------------------------------------------

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

INSERT INTO `schema_info` (`version`) VALUES ('15');


# Dump of table semantic_properties
# ------------------------------------------------------------

CREATE TABLE `semantic_properties` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `value` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16445 DEFAULT CHARSET=latin1;



# Dump of table semantic_relations
# ------------------------------------------------------------

CREATE TABLE `semantic_relations` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `object_id` int(11) NOT NULL,
  `object_type` varchar(255) default NULL,
  `subject_id` int(11) NOT NULL,
  `predicate_uri` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `index_semantic_relations_on_predicate_uri` (`predicate_uri`)
) ENGINE=InnoDB AUTO_INCREMENT=26450 DEFAULT CHARSET=latin1;



# Dump of table sessions
# ------------------------------------------------------------

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

INSERT INTO `sessions` (`id`,`session_id`,`data`,`created_at`,`updated_at`) VALUES ('1','dd0773bccafe2439ce1fe23f4947b348','BAh7ByIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo\nSGFzaHsABjoKQHVzZWR7ADodX19nbG9iYWxpemVfdHJhbnNsYXRpb25zexAi\nH1dlbGNvbWUgdG8gRGlzY292ZXJ5U291cmNlIh9XZWxjb21lIHRvIERpc2Nv\ndmVyeVNvdXJjZSIWQWJvdXQgVGhlIFByb2plY3QiFkFib3V0IFRoZSBQcm9q\nZWN0IgAiACIaQ29tbWl0dGVlIE9mIFNjaG9sYXJzIhpDb21taXR0ZWUgT2Yg\nU2Nob2xhcnMiFURldmVsb3BtZW50IFRlYW0iFURldmVsb3BtZW50IFRlYW0i\nEFNpbXBsZSBNb2RlIhBTaW1wbGUgTW9kZSIhU2ltcGxlIE1vZGUgSG9tZSBE\nZXNjcmlwdGlvbiIhU2ltcGxlIE1vZGUgSG9tZSBEZXNjcmlwdGlvbiIORnVs\nbCBNb2RlIg5GdWxsIE1vZGUiH0Z1bGwgTW9kZSBIb21lIERlc2NyaXB0aW9u\nIh9GdWxsIE1vZGUgSG9tZSBEZXNjcmlwdGlvbiIaRW50ZXIgaW4gU2Nob2xh\nciBtb2RlIhpFbnRlciBpbiBTY2hvbGFyIG1vZGUiDUNvbnRhY3RzIg1Db250\nYWN0cw==\n','2008-08-01 18:30:44','2008-08-01 18:58:00');
INSERT INTO `sessions` (`id`,`session_id`,`data`,`created_at`,`updated_at`) VALUES ('2','8e4bba6b59fe13203c314fbf8d625944','BAh7ByIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo\nSGFzaHsABjoKQHVzZWR7ADodX19nbG9iYWxpemVfdHJhbnNsYXRpb25zexAi\nH1dlbGNvbWUgdG8gRGlzY292ZXJ5U291cmNlIh9XZWxjb21lIHRvIERpc2Nv\ndmVyeVNvdXJjZSIWQWJvdXQgVGhlIFByb2plY3QiFkFib3V0IFRoZSBQcm9q\nZWN0IgAiACIaQ29tbWl0dGVlIE9mIFNjaG9sYXJzIhpDb21taXR0ZWUgT2Yg\nU2Nob2xhcnMiFURldmVsb3BtZW50IFRlYW0iFURldmVsb3BtZW50IFRlYW0i\nEFNpbXBsZSBNb2RlIhBTaW1wbGUgTW9kZSIhU2ltcGxlIE1vZGUgSG9tZSBE\nZXNjcmlwdGlvbiIhU2ltcGxlIE1vZGUgSG9tZSBEZXNjcmlwdGlvbiIORnVs\nbCBNb2RlIg5GdWxsIE1vZGUiH0Z1bGwgTW9kZSBIb21lIERlc2NyaXB0aW9u\nIh9GdWxsIE1vZGUgSG9tZSBEZXNjcmlwdGlvbiIaRW50ZXIgaW4gU2Nob2xh\nciBtb2RlIhpFbnRlciBpbiBTY2hvbGFyIG1vZGUiDUNvbnRhY3RzIg1Db250\nYWN0cw==\n','2008-08-02 09:55:10','2008-08-02 09:55:11');


# Dump of table users
# ------------------------------------------------------------

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `open_id` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

INSERT INTO `users` (`id`,`login`,`email`,`crypted_password`,`salt`,`created_at`,`updated_at`,`remember_token`,`remember_token_expires_at`,`open_id`) VALUES ('1','admin','admin@admins.foob','b457e44106bc408c6ff17a73c02e5eeb8be23918','2eeb3a96bf75f82802fc6b09c0848c01d40d464d','2008-08-01 18:28:46','2008-08-01 18:28:46',NULL,NULL,NULL);


# Dump of table workflows
# ------------------------------------------------------------

CREATE TABLE `workflows` (
  `id` int(11) NOT NULL auto_increment,
  `state` varchar(255) NOT NULL,
  `arguments` varchar(255) NOT NULL,
  `type` varchar(255) default NULL,
  `source_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_workflows_on_source_id` (`source_id`),
  CONSTRAINT `workflows_to_active_sources` FOREIGN KEY (`source_id`) REFERENCES `active_sources` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



