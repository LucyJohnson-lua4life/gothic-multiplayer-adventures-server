CREATE TABLE IF NOT EXISTS inventory (
    id int primary key not null auto_increment,
    inventory_from varchar(50) not null,
	item_name varchar(50) not null,
    amount int not null,

    foreign key (inventory_from)
        references player(name)
        on update cascade on delete cascade

);
