create table if not exists Sockets (
    id integer not null ,
    name text not null ,
    description text not null ,
    display_name text not null ,
    tier_type text not null ,
    icon_url text not null ,
    tooltip jsonb not null,
    constraint pk_sockets_id primary key (id)
);

create index if not exists idx_sockets_name on Sockets (name);
create index if not exists idx_sockets_display_name on Sockets (display_name);
create index if not exists idx_sockets_tier_type on Sockets (tier_type);