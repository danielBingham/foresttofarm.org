
CREATE TABLE `habits` (
    `id` int unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar (255),
    `symbol` varchar (255),
    `description` text,
    PRIMARY KEY (`id`),
    KEY `name` (`name`)
);

INSERT INTO `habits` (`symbol`, `name`, `description`) 
        VALUES ('E', 'Evergreen', ''),
        ('std', 'Standard', 'Single-trunked and nonsuckering.'),
        ('skr', 'Suckering', 'Sending up shoots at a distance from the trunk from roots, rhizomes, or stolons.'),
        ('spr', 'Sprouting', 'A standard tree that sends up shoots from the base.'),
        ('ms', 'Multistemmed', 'Multiple shoots arising from the crown.'),
        ('Ctkt', 'Clumping Thicket Former', 'Forming a colony by sending up shoots at a distance from the crown, but not spreading beyond a certain size.'),
        ('Rtkt', 'Running Thicket Former', 'Forming a colony by spreading up shoots at a distance from the crown and spreading indefinitly.'),
        ('Cmat', 'Clumping Mat Former', 'Makes a dense prostrate carpet that does not spread beyond a certain size.'),
        ('Rmat', 'Running Mat Former', 'Makes a dense prostrate carpet that spreads indefinitely.'),
        ('w', 'Woody', ''),
        ('r', 'Herbacious', ''),
        ('vine', 'Vine', 'Ordinary vine sending a single shoot or multiple shoots from a crown.'),
        ('v/skr', 'Suckering Vine', 'Sends up suckers at a distance from the parent plant from roots, rhizomes or stolons.'),
        ('a', 'Annual', 'Self seeding annual herb.'),
        ('e', 'Ephemeral', 'Emerging in spring and dying back by summer every year.'),
        ('clmp', 'Clumper', 'Spreading to a certain width and no wider.'),
        ('run', 'Runner', 'Spreading indefinitely by stolons or rhizomes.');

CREATE TABLE `root_patterns` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(255),
    `symbol` varchar(255),
    `description` varchar(255),
    PRIMARY KEY (`id`),
    KEY `name` (`name`)
);

INSERT INTO `root_patterns` (`symbol`, `name`, `description`)
        VALUES ('F', 'Flat', 'Mostly shallow roots forming a "plate" near the soil surface.  May also develope vertical "sinkers" or "strikers" in various places.'),
        ('FB', 'Fibrous', 'Dividing into a large number of fine roots immediately upon leaving the crown.'),
        ('H', 'Heart', 'Dividing from the crown into a number of main roots that both angle downward and spread outward.'),
        ('T', 'Tap', 'A carrotlike root (sometimes branching) driving directly downward.'),
        ('Sk', 'Suckering', 'Sending up new Plants from underground runners (either rhizomes or root sprouts) at a distance from the trunk or crown.'),
        ('St', 'Stoloniferous', 'Rooting from creeping stems above the ground.'),
        ('B', 'Bulb', 'Modified leaves forming a swollen base.  Onions and garlic are bulbs.'),
        ('C', 'Corm', 'A thick swelling at the base of the stem.'),
        ('R', 'Rhizomatous', 'Underground stems that send out shoots and roots periodically along their length.  They can travel great distances, or stay close to the crown.'),
        ('Tu', 'Tuberous', 'Producing swollen potato-like "roots" (actually modified stems).'),
        ('Fl', 'Fleshy', 'Thick or swollen, usually a form of fibrous or tap roots.');

CREATE TABLE `habitats` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(255),
    PRIMARY KEY(`id`)
);

INSERT INTO `habitats` (`name`) VALUES ('Disturbed'), ('Meadows'), ('Prairies'), ('Oldfields'), ('Thickets'), ('Edges'), ('Gaps/Clearings'), ('Open Woods'), ('Forest'), ('Conifer Forest'), ('Other');


CREATE TABLE `harvests` (
    `id` int unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(255),
    PRIMARY KEY(`id`)
); 

INSERT INTO `harvests` (`name`) VALUES ('Fruit'), ('Nuts/Mast'), ('Greens'), ('Roots'), ('Culinary'), ('Tea'), ('Other'), ('Medicinal');

CREATE TABLE `roles` (
    `id` int unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(255),
    PRIMARY KEY(`id`)
);

INSERT INTO `roles` (`name`) VALUES 
	('Nitrogen Fixer'), 
	('Dynamic Accumulator'), 
	('Wildlife Food'),
	('Wildlife Shelter'), 
	('Invertabrate Shelter'), 
	('Generalist Nectary'), 
	('Specialist Nectary'),
	('Ground Cover'), 
	('Aromatic'), 
	('Coppice');

CREATE TABLE `drawbacks` (
    `id` int unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(255),
    PRIMARY KEY(`id`)
);

INSERT INTO `drawbacks` (`name`) VALUES ('Allelopathic'), ('Dispersive'), ('Expansive'), ('Hay fever'), ('Persistent'), ('Sprawling vigorous vine'), ('Stings'), ('Thorny'), ('Poison');

CREATE TABLE `light_tolerances` (
    `id` int unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(255),
    PRIMARY KEY(`id`)
);

INSERT INTO `light_tolerances` (`name`) VALUES ('Full Sun'), ('Partial Shade'), ('Full Shade');

CREATE TABLE `moisture_tolerances` (
    `id` int unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(255),
    PRIMARY KEY(`id`)
);

INSERT INTO `moisture_tolerances` (`name`) VALUES ('Xeric'), ('Mesic'), ('Hydric');

CREATE TABLE `images` (
	`id` int unsigned NOT NULL AUTO_INCREMENT,
	`created_at` TIMESTAMP,
	`updated_at` TIMESTAMP,
	`width` int unsigned DEFAULT '1024',
	`height` int unsigned DEFAULT '768',
	PRIMARY KEY (`id`)
);

CREATE TABLE `plants_images` (
	`plant_id` int unsigned NOT NULL,
	`image_id` int unsigned NOT NULL,
	PRIMARY KEY (`plant_id`, `image_id`)
);


CREATE TABLE `plants` (
    `id` int unsigned NOT NULL AUTO_INCREMENT,
	`created_at` TIMESTAMP,
	`updated_at` TIMESTAMP,
    `genus` varchar(255),
    `species` varchar(255),
    `family` varchar(255),
	`minimum_PH` float,
	`maximum_PH` float,
	`minimum_height` float,
    `maximum_height` float,
	`minimum_width` float,
    `maximum_width` float,
    `minimum_zone` char(2),
    `maximum_zone` char(2),
    `growth_rate` ENUM('s', 's-m', 'm', 'm-f', 'f'),
    `form` ENUM('tree', 'shrub', 'vine', 'herb'),
    `native_region` ENUM('ASIA', 'AUST', 'CULT', 'ENA', 'EUR', 'EURA', 'PRAI', 'SAM', 'WNA'),
    PRIMARY KEY(`id`),
    KEY `genus` (`genus`),
    KEY `species` (`species`)
);

CREATE TABLE `common_names` (
	`id` int unsigned NOT NULL AUTO_INCREMENT,
	`plant_id` int unsigned NOT NULL,
	`name` varchar(255),
	PRIMARY KEY (`id`),
	KEY `plant_id` (`plant_id`)
);

CREATE TABLE `plants_habits` (
    `habit_id` int unsigned NOT NULL,
    `plant_id` int unsigned NOT NULL,
    PRIMARY KEY(`habit_id`, `plant_id`)
);

CREATE TABLE `plants_root_patterns` (
    `root_pattern_id` int unsigned NOT NULL,
    `plant_id` int unsigned NOT NULL,
    PRIMARY KEY (`root_pattern_id`, `plant_id`)
);


CREATE TABLE `plants_habitats` (
    `plant_id` int unsigned NOT NULL,
    `habitat_id` int unsigned NOT NULL,
    PRIMARY KEY (`habitat_id`, `plant_id`)
);

CREATE TABLE `plants_harvests` (
    `plant_id` int unsigned NOT NULL,
    `harvest_id` int unsigned NOT NULL,
	`rating` int unsigned,
    PRIMARY KEY (`harvest_id`,`plant_id`)
);

CREATE TABLE `plants_roles` (
    `plant_id` int unsigned NOT NULL,
    `role_id` int unsigned NOT NULL,
    PRIMARY KEY (`plant_id`,`role_id`)
);

CREATE TABLE `plant_drawbacks` (
    `plant_id` int unsigned NOT NULL,
    `drawback_id` int unsigned NOT NULL,
    PRIMARY KEY (`drawback_id`,`plant_id`)
);

CREATE TABLE `plants_light_tolerances` (
    `plant_id` int unsigned NOT NULL,
    `light_tolerance_id` int unsigned NOT NULL,
    PRIMARY KEY (`plant_id`,`light_tolerance_id`)
);

CREATE TABLE `plants_moisture_tolerances` (
    `plant_id` int unsigned NOT NULL,
    `moisture_tolerance_id` int unsigned NOT NULL,
    PRIMARY KEY (`moisture_tolerance_id`,`plant_id`)
);

