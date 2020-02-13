CREATE TABLE IF NOT EXISTS player_gold (
    id int primary key not null auto_increment,
    player_name varchar(50) not null,
    amount int default 0,

    foreign key (player_name)
        references player(name)
        on update cascade on delete cascade
);
