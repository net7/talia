CREATE TABLE `dirty_relation_records` (
  `id` int(11) NOT NULL auto_increment,
  `source_record_id` int(11) NOT NULL,
  `uri` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `source_records` (
  `id` int(11) NOT NULL auto_increment,
  `uri` varchar(255) NOT NULL,
  `name` varchar(255) default NULL,
  `workflow_state` int(11) NOT NULL,
  `primary_source` tinyint(1) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_source_records_on_uri` (`uri`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `source_type_records` (
  `id` int(11) NOT NULL auto_increment,
  `source_record_id` int(11) NOT NULL,
  `uri` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO schema_info (version) VALUES (2)