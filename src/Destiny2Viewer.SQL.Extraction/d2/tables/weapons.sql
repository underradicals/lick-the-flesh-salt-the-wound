create table if not exists Weapons
(
    id              integer not null,
    name            text    not null,
    flavor_text     text    not null,
    display_name    text    not null,
    tier_type       text    not null,
    ammo_type       text    not null,
    slot            text    not null,
    damage_type     text    not null,
    damage_type_url text    not null,
    icon_url        text    not null,
    watermark_url   text    not null,
    screenshot_url  text,
    season_name     text,
    season_icon     text,
    season          integer,
    year            integer,
    genre           text,
    start_date      text,
    end_date        text,
    duration        integer,
    constraint pk_weapon primary key (id)
);

create index if not exists idx_weapon_name on Weapons (name);
create index if not exists idx_weapon_display_name on Weapons (display_name);
create index if not exists idx_weapon_tier_type on Weapons (tier_type);
create index if not exists idx_weapon_ammo_type on Weapons (ammo_type);
create index if not exists idx_weapon_slot on Weapons (slot);
create index if not exists idx_weapon_damage_type on Weapons (damage_type);
create index if not exists idx_season_name on Weapons (season_name);
create index if not exists idx_year on Weapons (year);
create index if not exists idx_genre on Weapons (genre);
create index if not exists idx_start_date on Weapons (start_date);
create index if not exists idx_end_date on Weapons (end_date);
create index if not exists idx_duration on Weapons (duration);