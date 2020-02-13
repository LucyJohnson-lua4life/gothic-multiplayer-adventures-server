CREATE TABLE IF NOT EXISTS player (
    name varchar(50) PRIMARY KEY,
	inventory varchar(50) NULL,
    password varchar(70) NOT NULL,
	class_id int,
	body_model varchar(20),
	head_model varchar(20),
	body_tex int,
	head_tex int,
	
	melee_weapon varchar(50),
	armor varchar(50),
	ranged_weapon varchar(50),
	
	str int,
	dex int,
	one_h int,
	two_h int,
	bow int,
	cbow int,	
	health int,
	max_health int,
	mana int,
	max_mana int,
	magic_level int,

	pos_x double,
	pos_y double,
	pos_z double


);

INSERT INTO player (name,password,body_model,head_model,body_tex,head_tex, melee_weapon, armor, ranged_weapon, str, dex, one_h, two_h, bow, cbow, health, max_health, mana, max_mana, magic_level, pos_x , pos_y , pos_z) VALUES ("Vim","12345","Hum_Body_Naked0","Hum_Head_Fighter",1, 1,"ItMW_1H_FerrosSword_Mis","ITAR_Bloodwyn_Addon",null, 100, 50, 60, 60, 30, 30, 1040, 1040, 50, 50, 1, 0, 0, 0);  

 --   FOREIGN KEY (inventory)
   --     REFERENCES inventory (inventory_from)
     --   ON UPDATE CASCADE ON DELETE CASCADE