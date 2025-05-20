Create table if not exists CuratedRolls (
    weapon_id integer not null,
    socket_id integer not null,
    constraint fk_curated_rolls_weapon_id foreign key (weapon_id) references Weapons (id),
    constraint fk_curated_rolls_socket_id foreign key (socket_id) references Sockets (id),
    constraint pk_curated_rolls primary key (weapon_id, socket_id)
);