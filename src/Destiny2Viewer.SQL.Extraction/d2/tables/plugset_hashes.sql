create table if not exists PlugSetHashSockets (
    plug_set_id integer not null,
    socket_id integer not null,
    constraint fk_plug_set_hash_id foreign key (socket_id) references Sockets (id),
    constraint pk_plug_set_hash_sockets primary key (plug_set_id, socket_id)
);