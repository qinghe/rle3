CREATE TABLE `assignments` (
  `website_id` int(11) NOT NULL DEFAULT '0',
  `blog_post_id` int(11) DEFAULT NULL,
  `menu_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `blog_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `blog_post_id` int(11) DEFAULT NULL,
  `spam` tinyint(1) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `body` text COLLATE utf8_unicode_ci,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_blog_comments_on_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `blog_posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `body` text COLLATE utf8_unicode_ci,
  `is_published` tinyint(1) DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_blog_posts_on_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `editors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `perma_name` varchar(200) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `html_attributes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `perma_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `pvalues` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `pvalues_desc` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `punits` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `neg_ok` tinyint(1) NOT NULL DEFAULT '0',
  `default_value` smallint(6) NOT NULL DEFAULT '0',
  `pvspecial` varchar(7) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `menu_levels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `menu_id` mediumint(9) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '0',
  `theme_id` smallint(6) NOT NULL DEFAULT '0',
  `detail_theme_id` smallint(6) NOT NULL DEFAULT '0',
  `ptheme_id` int(11) NOT NULL DEFAULT '0',
  `pdetail_theme_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `menus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL DEFAULT '0',
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `perma_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `root_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(11) DEFAULT NULL,
  `rgt` int(11) DEFAULT NULL,
  `clickable` tinyint(1) DEFAULT '1',
  `is_enabled` tinyint(1) DEFAULT '1',
  `inheritance` tinyint(1) DEFAULT '1',
  `theme_id` int(11) NOT NULL DEFAULT '0',
  `detail_theme_id` int(11) NOT NULL DEFAULT '0',
  `ptheme_id` int(11) NOT NULL DEFAULT '0',
  `pdetail_theme_id` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `page_layouts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` mediumint(9) DEFAULT '0',
  `root_id` mediumint(9) DEFAULT NULL,
  `parent_id` mediumint(9) DEFAULT NULL,
  `lft` smallint(6) NOT NULL DEFAULT '0',
  `rgt` smallint(6) NOT NULL DEFAULT '0',
  `title` varchar(200) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `perma_name` varchar(200) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `section_id` mediumint(9) DEFAULT '0',
  `section_instance` smallint(6) NOT NULL DEFAULT '0',
  `section_context` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `data_source` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `data_filter` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `is_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `copy_from_root_id` int(11) NOT NULL DEFAULT '0',
  `is_full_html` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `param_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `editor_id` mediumint(9) NOT NULL DEFAULT '0',
  `position` mediumint(9) DEFAULT '0',
  `perma_name` varchar(200) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `is_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `param_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page_layout_root_id` smallint(6) NOT NULL DEFAULT '0',
  `page_layout_id` smallint(6) NOT NULL DEFAULT '0',
  `section_param_id` smallint(6) NOT NULL DEFAULT '0',
  `theme_id` smallint(6) NOT NULL DEFAULT '0',
  `pvalue` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `unset` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `computed_pvalue` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `section_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `section_root_id` int(11) DEFAULT NULL,
  `section_id` int(11) DEFAULT NULL,
  `section_piece_param_id` int(11) DEFAULT NULL,
  `default_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_enabled` tinyint(1) DEFAULT '1',
  `disabled_ha_ids` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `section_piece_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `section_piece_id` smallint(6) NOT NULL DEFAULT '0',
  `editor_id` smallint(6) NOT NULL DEFAULT '0',
  `param_category_id` smallint(6) NOT NULL DEFAULT '0',
  `position` smallint(6) NOT NULL DEFAULT '0',
  `pclass` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `class_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `html_attribute_ids` varchar(1000) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `param_conditions` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_editable` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `section_pieces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `perma_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `html` varchar(12000) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `css` varchar(8000) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `js` varchar(60) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `is_root` tinyint(1) NOT NULL DEFAULT '0',
  `is_container` tinyint(1) NOT NULL DEFAULT '0',
  `is_selectable` tinyint(1) NOT NULL DEFAULT '0',
  `resources` varchar(10) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `section_texts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lang` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `body` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` mediumint(9) DEFAULT NULL,
  `root_id` mediumint(9) DEFAULT NULL,
  `parent_id` mediumint(9) DEFAULT NULL,
  `lft` smallint(6) NOT NULL DEFAULT '0',
  `rgt` smallint(6) NOT NULL DEFAULT '0',
  `perma_name` varchar(200) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `section_piece_id` mediumint(9) DEFAULT '0',
  `section_piece_instance` smallint(6) DEFAULT '0',
  `is_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `global_events` varchar(200) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `subscribed_global_events` varchar(200) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `template_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page_layout_id` int(11) DEFAULT NULL,
  `theme_id` int(11) DEFAULT NULL,
  `file_uid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `template_themes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) DEFAULT '0',
  `page_layout_root_id` int(11) NOT NULL DEFAULT '0',
  `title` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `perma_name` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `assigned_resource_ids` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `websites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `perma_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `index_page` int(11) NOT NULL DEFAULT '0',
  `list_template` int(11) NOT NULL DEFAULT '0',
  `detail_template` int(11) NOT NULL DEFAULT '0',
  `plist_template` int(11) NOT NULL DEFAULT '0',
  `pdetail_template` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20110614100723');

INSERT INTO schema_migrations (version) VALUES ('20110615130742');

INSERT INTO schema_migrations (version) VALUES ('20110616014717');

INSERT INTO schema_migrations (version) VALUES ('20110616023009');

INSERT INTO schema_migrations (version) VALUES ('20110616034119');

INSERT INTO schema_migrations (version) VALUES ('20110623093306');

INSERT INTO schema_migrations (version) VALUES ('20110630104825');

INSERT INTO schema_migrations (version) VALUES ('20110706115622');

INSERT INTO schema_migrations (version) VALUES ('20110707103731');

INSERT INTO schema_migrations (version) VALUES ('20110712114448');

INSERT INTO schema_migrations (version) VALUES ('20110915122156');

INSERT INTO schema_migrations (version) VALUES ('20110920130440');

INSERT INTO schema_migrations (version) VALUES ('20111013164757');

INSERT INTO schema_migrations (version) VALUES ('20120113124228');

INSERT INTO schema_migrations (version) VALUES ('20120113124312');