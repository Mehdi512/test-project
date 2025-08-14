CREATE TABLE `box_type` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(60) NOT NULL UNIQUE,
	`parent` INT(11),
    `path` VARCHAR(255) NOT NULL,
    `level` INT(4) NOT NULL,
    `is_wrapper` TINYINT,
	`created_stamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
	PRIMARY KEY (`id`)
);

CREATE TABLE `box` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(60) NOT NULL,
	`type` INT(11) NOT NULL,
	`parent` INT(11),
	`path` VARCHAR(255) NOT NULL,
	`created_stamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
	PRIMARY KEY (`id`),
	INDEX(parent),
	FOREIGN KEY (`type`) REFERENCES `box_type` (`id`)
);

INSERT INTO `box_type` (`id`, `name`, `parent`, `path`, `level`, `is_wrapper`)
                VALUES (1, 'pallete', null, 'pallete/', 1, 1),
                       (2, 'box', 1, 'pallete/box/', 2, 1),
                       (3, 'brick', 2, 'pallete/box/brick/', 3, 0),
                       (4, 'sim_box', null, 'sim_box/', 1, 0),
                       (5, 'system_box', null, 'system_box/', 1, 0);