CREATE TABLE `active_sources` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `uri` varchar(255) NOT NULL,
  `type` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `data_records` (
  `id` int(11) NOT NULL auto_increment,
  `source_record_id` int(11) NOT NULL,
  `type` varchar(255) default NULL,
  `location` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `index_data_records_on_source_record_id` (`source_record_id`),
  CONSTRAINT `data_records_to_source_records` FOREIGN KEY (`source_record_id`) REFERENCES `source_records` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1110 DEFAULT CHARSET=utf8;

CREATE TABLE `dirty_relation_records` (
  `id` int(11) NOT NULL auto_increment,
  `source_record_id` int(11) NOT NULL,
  `uri` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `dirty_relation_records_to_source_records` (`source_record_id`),
  CONSTRAINT `dirty_relation_records_to_source_records` FOREIGN KEY (`source_record_id`) REFERENCES `source_records` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `open_id_authentication_associations` (
  `id` int(11) NOT NULL auto_increment,
  `issued` int(11) default NULL,
  `lifetime` int(11) default NULL,
  `handle` varchar(255) default NULL,
  `assoc_type` varchar(255) default NULL,
  `server_url` blob,
  `secret` blob,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `open_id_authentication_nonces` (
  `id` int(11) NOT NULL auto_increment,
  `timestamp` int(11) NOT NULL,
  `server_url` varchar(255) default NULL,
  `salt` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `roles_users` (
  `role_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  KEY `index_roles_users_on_role_id` (`role_id`),
  KEY `index_roles_users_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `semantic_properties` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `value` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `semantic_relations` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `object_id` int(11) NOT NULL,
  `object_type` varchar(255) default NULL,
  `subject_id` int(11) NOT NULL,
  `predicate_uri` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

CREATE TABLE `source_records` (
  `id` int(11) NOT NULL auto_increment,
  `uri` varchar(255) NOT NULL,
  `name` varchar(255) default NULL,
  `primary_source` tinyint(1) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_source_records_on_uri` (`uri`)
) ENGINE=InnoDB AUTO_INCREMENT=3065 DEFAULT CHARSET=utf8;

CREATE TABLE `type_records` (
  `id` int(11) NOT NULL auto_increment,
  `source_record_id` int(11) NOT NULL,
  `uri` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `type_records_to_source_records` (`source_record_id`),
  CONSTRAINT `type_records_to_source_records` FOREIGN KEY (`source_record_id`) REFERENCES `source_records` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4795 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `workflow_records` (
  `id` int(11) NOT NULL auto_increment,
  `source_record_id` int(11) NOT NULL,
  `state` varchar(255) NOT NULL,
  `arguments` varchar(255) default NULL,
  `type` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_workflow_records_on_source_record_id` (`source_record_id`),
  CONSTRAINT `workflow_records_to_source_records` FOREIGN KEY (`source_record_id`) REFERENCES `source_records` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `schema_info` (version) VALUES (13)