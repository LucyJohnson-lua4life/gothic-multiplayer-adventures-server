CREATE TABLE IF NOT EXISTS inventory (
    id int primary key not null auto_increment,
	item_instance varchar(50) not null,
    pos_x int,
    pos_y int,
    pos_z int,
    amount int not null
);
