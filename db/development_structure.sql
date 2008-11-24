CREATE TABLE `active_sources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `uri` varchar(255) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_active_sources_on_uri` (`uri`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

CREATE TABLE `data_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `location` varchar(255) NOT NULL,
  `mime` varchar(255) DEFAULT NULL,
  `source_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_data_records_on_source_id` (`source_id`),
  CONSTRAINT `data_records_to_active_sources` FOREIGN KEY (`source_id`) REFERENCES `active_sources` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `globalize_countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(2) DEFAULT NULL,
  `english_name` varchar(255) DEFAULT NULL,
  `date_format` varchar(255) DEFAULT NULL,
  `currency_format` varchar(255) DEFAULT NULL,
  `currency_code` varchar(3) DEFAULT NULL,
  `thousands_sep` varchar(2) DEFAULT NULL,
  `decimal_sep` varchar(2) DEFAULT NULL,
  `currency_decimal_sep` varchar(2) DEFAULT NULL,
  `number_grouping_scheme` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_globalize_countries_on_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=240 DEFAULT CHARSET=latin1;

CREATE TABLE `globalize_languages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iso_639_1` varchar(2) DEFAULT NULL,
  `iso_639_2` varchar(3) DEFAULT NULL,
  `iso_639_3` varchar(3) DEFAULT NULL,
  `rfc_3066` varchar(255) DEFAULT NULL,
  `english_name` varchar(255) DEFAULT NULL,
  `english_name_locale` varchar(255) DEFAULT NULL,
  `english_name_modifier` varchar(255) DEFAULT NULL,
  `native_name` varchar(255) DEFAULT NULL,
  `native_name_locale` varchar(255) DEFAULT NULL,
  `native_name_modifier` varchar(255) DEFAULT NULL,
  `macro_language` tinyint(1) DEFAULT NULL,
  `direction` varchar(255) DEFAULT NULL,
  `pluralization` varchar(255) DEFAULT NULL,
  `scope` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_globalize_languages_on_iso_639_1` (`iso_639_1`),
  KEY `index_globalize_languages_on_iso_639_2` (`iso_639_2`),
  KEY `index_globalize_languages_on_iso_639_3` (`iso_639_3`),
  KEY `index_globalize_languages_on_rfc_3066` (`rfc_3066`)
) ENGINE=InnoDB AUTO_INCREMENT=7597 DEFAULT CHARSET=latin1;

CREATE TABLE `globalize_translations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `tr_key` varchar(255) DEFAULT NULL,
  `table_name` varchar(255) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `facet` varchar(255) DEFAULT NULL,
  `built_in` tinyint(1) DEFAULT '1',
  `language_id` int(11) DEFAULT NULL,
  `pluralization_index` int(11) DEFAULT NULL,
  `text` text,
  `namespace` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_globalize_translations_on_tr_key_and_language_id` (`tr_key`,`language_id`),
  KEY `globalize_translations_table_name_and_item_and_language` (`table_name`,`item_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7069 DEFAULT CHARSET=latin1;

CREATE TABLE `open_id_authentication_associations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `issued` int(11) DEFAULT NULL,
  `lifetime` int(11) DEFAULT NULL,
  `handle` varchar(255) DEFAULT NULL,
  `assoc_type` varchar(255) DEFAULT NULL,
  `server_url` blob,
  `secret` blob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `open_id_authentication_nonces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` int(11) NOT NULL,
  `server_url` varchar(255) DEFAULT NULL,
  `salt` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `roles_users` (
  `role_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  KEY `index_roles_users_on_role_id` (`role_id`),
  KEY `index_roles_users_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `schema_info` (
  `version` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `semantic_properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `semantic_relations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `object_id` int(11) NOT NULL,
  `object_type` varchar(255) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `predicate_uri` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_semantic_relations_on_predicate_uri` (`predicate_uri`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `crypted_password` varchar(40) DEFAULT NULL,
  `salt` varchar(40) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `remember_token` varchar(255) DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `open_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

CREATE TABLE `workflows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state` varchar(255) NOT NULL,
  `arguments` varchar(255) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `source_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_workflows_on_source_id` (`source_id`),
  CONSTRAINT `workflows_to_active_sources` FOREIGN KEY (`source_id`) REFERENCES `active_sources` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `schema_info` (version) VALUES (15)