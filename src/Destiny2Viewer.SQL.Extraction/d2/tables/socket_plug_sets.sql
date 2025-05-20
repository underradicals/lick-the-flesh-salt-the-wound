create table if not exists WeaponPlugSetHashes (
    weapon_id integer not null ,
    plug_set_hash integer not null ,
    constraint fk_socket_plugsets_weapon_id foreign key (weapon_id) references Weapons (id),
    constraint fk_socket_plugsets_plug_set_hash foreign key (plug_set_hash) references PlugSetHashSockets(plug_set_id),
    constraint pk_socket_plugsets_weapon_id primary key (weapon_id, plug_set_hash)
);