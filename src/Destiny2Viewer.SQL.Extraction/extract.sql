attach database 'D:\Destiny2Viewer\d2.db' as target;

-- Drop Tables
drop view if exists target.WeaponStatView;
drop table if exists target.WeaponStats;
drop table if exists target.PlugSetHashSockets;
drop table if exists target.WeaponPlugSetHashes;
drop table if exists target.CuratedRolls;
drop table if exists target.Sockets;
drop table if exists target.Weapons;
drop table if exists target.Stats;


-- Create Tables
create table if not exists target.Sockets (
    id integer not null ,
    name text not null ,
    description text not null ,
    display_name text not null ,
    tier_type text not null ,
    icon_url text not null ,
    tooltip jsonb not null,
    constraint pk_sockets_id primary key (id)
);

create index if not exists target.idx_sockets_name on Sockets (name);
create index if not exists target.idx_sockets_display_name on Sockets (display_name);
create index if not exists target.idx_sockets_tier_type on Sockets (tier_type);

insert into target.Sockets (id, name, description, display_name, tier_type, icon_url, tooltip)
with socket_cte as (
    select 'displayProperties' as DisplayProperties
)
select
    diid.json -> 'hash' as Id,
    diid.json -> DisplayProperties ->> 'name' as Name,
    diid.json -> DisplayProperties ->> 'description' as Description,
    diid.json ->> 'itemTypeDisplayName' as DisplayName,
    coalesce(diid.json -> 'inventory' ->> 'tierTypeName', '') as TierType,
    coalesce(diid.json -> DisplayProperties ->> 'icon', '') as IconUrl,
    diid.json -> 'tooltipNotifications' as ToolTip
from DestinyInventoryItemDefinition as diid, socket_cte where json ->> 'itemType' = 19 and Name is not '';



create table if not exists target.Weapons
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

create index if not exists target.idx_weapon_name on Weapons (name);
create index if not exists target.idx_weapon_display_name on Weapons (display_name);
create index if not exists target.idx_weapon_tier_type on Weapons (tier_type);
create index if not exists target.idx_weapon_ammo_type on Weapons (ammo_type);
create index if not exists target.idx_weapon_slot on Weapons (slot);
create index if not exists target.idx_weapon_damage_type on Weapons (damage_type);
create index if not exists target.idx_season_name on Weapons (season_name);
create index if not exists target.idx_year on Weapons (year);
create index if not exists target.idx_genre on Weapons (genre);
create index if not exists target.idx_start_date on Weapons (start_date);
create index if not exists target.idx_end_date on Weapons (end_date);
create index if not exists target.idx_duration on Weapons (duration);



insert into target.Weapons (id,
                            name,
                            flavor_text,
                            display_name,
                            tier_type,
                            ammo_type,
                            slot,
                            damage_type,
                            damage_type_url,
                            icon_url,
                            watermark_url,
                            screenshot_url)
with weapon_cte as (select 'hash'                  as ItemId,
                           'displayProperties'     as DisplayProperties,
                           'name'                  as Name,
                           'icon'                  as Icon,
                           'iconWatermark'         as Watermark,
                           'screenshot'            as Screenshot,
                           'flavorText'            as FlavorText,
                           'itemTypeDisplayName'   as DisplayName,
                           'inventory'             as Inventory,
                           'tierTypeName'          as TierType,
                           'equippingBlock'        as Equipment,
                           'ammoType'              as AmmoType,
                           'equipmentSlotTypeHash' as Slot,
                           'defaultDamageTypeHash' as DamageType)
select json ->> ItemId,
       json -> DisplayProperties ->> Name                 as Name,
       json ->> FlavorText                                as FlavorText,
       json ->> DisplayName                               as DisplayName,
       json -> Inventory ->> TierType                     as TierType,
       case json -> Equipment ->> AmmoType
           when 3 then 'Heavy'
           when 2 then 'Special'
           when 1 then 'Primary'
           end                                            as AmmoType,
       case json -> Equipment ->> Slot
           when 953998645 then 'Power'
           when 2465295065 then 'Energy'
           when 1498876634 then 'Kinetic'
           end                                            as Slot,
       (select json ->> DisplayProperties ->> Name
        from DestinyDamageTypeDefinition dd
        where d.json ->> DamageType = dd.json ->> ItemId) as DamageType,
       (select json ->> DisplayProperties ->> Icon
        from DestinyDamageTypeDefinition dd
        where d.json ->> DamageType = dd.json ->> ItemId) as DamageIconUrl,
       json -> DisplayProperties ->> Icon                 as IconUrl,
       json ->> Watermark                                 as WatermarkUrl,
       json ->> Screenshot                                as Screenshot
from DestinyInventoryItemDefinition d,
     weapon_cte
where json ->> 'itemType' = 3;


CREATE TABLE IF NOT EXISTS target.Stats
(
    id               not null,
    name        text not null,
    icon        text null default '',
    category    text not null,
    type        text not null,
    description text not null,
    constraint pk_stats_id primary key (id)
);

create index target.idx_stats_name on Stats (Name);
create index target.idx_stats_icon on Stats (icon);
create index target.idx_stats_category on Stats (category);
create index target.id_stats_type on Stats (type);

Insert into target.Stats (id, name, icon, category, type, description)
select json ->> 'hash'                                       as Id,
       json ->> 'displayProperties' ->> 'name'               as Name,
       coalesce(json ->> 'displayProperties' ->> 'icon', '') as Icon,
       case json ->> 'statCategory'
           when 0 then 'Gameplay'
           when 1 then 'Weapon'
           when 2 then 'Defense'
           when 3 then 'Primary'
           end                                               as Category,
       case json ->> 'aggregationType'
           when 0 then 'CharacterAverage'
           when 1 then 'Character'
           when 2 then 'Item'
           end                                               as Type,
       json ->> 'displayProperties' ->> 'description'        as Description
from DestinyStatDefinition
where Name is not '';



CREATE TABLE IF NOT EXISTS target.WeaponStats
(
    WeaponId integer not null,
    StatId   integer not null,
    Value    integer not null,
    foreign key (WeaponId) references Weapons (Id),
    foreign key (StatId) references Stats (Id),
    constraint pk_weapon_stats_id primary key (WeaponId, StatId)
);

insert into target.WeaponStats (WeaponId, StatId, Value)
with cte as (select DestinyInventoryItemDefinition.json ->> 'hash' as Id,
                    json_each.value
             from DestinyInventoryItemDefinition, json_each(DestinyInventoryItemDefinition.json, '$.investmentStats')
             WHERE DestinyInventoryItemDefinition.json ->> 'itemType' = 3)
select Id,
       cte.value ->> 'statTypeHash' as StatTypeHash,
       cte.value ->> 'value'        as Value
from cte
order by Id;


create table if not exists target.PlugSetHashSockets (
    plug_set_id integer not null,
    socket_id integer not null,
    constraint fk_plug_set_hash_id foreign key (socket_id) references Sockets (id),
    constraint pk_plug_set_hash_sockets primary key (plug_set_id, socket_id)
);

insert into target.PlugSetHashSockets (plug_set_id, socket_id)
with cte as (select DestinyPlugSetDefinition.id as PlugSetHash, value as json
             from DestinyPlugSetDefinition, json_each(DestinyPlugSetDefinition.json ->> 'reusablePlugItems'))
select distinct PlugSetHash, json ->> 'plugItemHash' as SocketId from cte;

create table if not exists target.WeaponPlugSetHashes (
    weapon_id integer not null ,
    plug_set_hash integer not null ,
    constraint fk_socket_plugsets_weapon_id foreign key (weapon_id) references Weapons (id),
    constraint fk_socket_plugsets_plug_set_hash foreign key (plug_set_hash) references PlugSetHashSockets(plug_set_id),
    constraint pk_socket_plugsets_weapon_id primary key (weapon_id, plug_set_hash)
);

insert into target.WeaponPlugSetHashes (weapon_id, plug_set_hash)
select diid.id, value
from DestinyInventoryItemDefinition as diid,
     json_tree(diid.json ->> 'sockets' ->> 'socketEntries') as jt
where diid.json ->> 'itemType' = 3 and
      (key = 'reusablePlugSetHash' or key = 'randomizedPlugSetHash');


Create table if not exists target.CuratedRolls (
    weapon_id integer not null,
    socket_id integer not null,
    constraint fk_curated_rolls_weapon_id foreign key (weapon_id) references Weapons (id),
    constraint fk_curated_rolls_socket_id foreign key (socket_id) references Sockets (id),
    constraint pk_curated_rolls primary key (weapon_id, socket_id)
);


insert into target.CuratedRolls (weapon_id, socket_id)
select distinct diid.id as WeaponId,
       value   as SocketId
from DestinyInventoryItemDefinition as diid,
     json_tree(diid.json ->> 'sockets' ->> 'socketEntries') as jt
where diid.json ->> 'itemType' = 3
  and key = 'singleInitialItemHash';


-- Update Tables
update target.Weapons
set season_name = 'Red War',
    season_icon = '/common/destiny2_content/icons/season1.png',
    year        = 1,
    season      = 1,
    start_date  = '2017-09-06T17:00:00Z',
    end_date    = '2017-12-08T17:00:00Z',
    genre       = 'Vanilla',
    duration    = 93
where substr(watermark_url, 32, 67) = 'fb50cd68a9850bd323872be4f6be115c.png';


update target.Weapons
set season_name = 'Curse of Osiris',
    season_icon = '/common/destiny2_content/icons/season2.png',
    year        = 1,
    season      = 2,
    start_date  = '2017-12-08T17:00:00Z',
    end_date    = '2018-05-08T17:00:00Z',
    genre       = 'Vanilla',
    duration    = 151
where substr(watermark_url, 32, 67) = '2c024f088557ca6cceae1e8030c67169.png';


update target.Weapons
set season_name = 'Warmind',
    season_icon = '/common/destiny2_content/icons/season3.png',
    year        = 1,
    season      = 3,
    start_date  = '2018-05-08T17:00:00Z',
    end_date    = '2018-09-04T17:00:00Z',
    genre       = 'Vanilla',
    duration    = 119
where substr(watermark_url, 32, 67) = 'ed6c4762c48bd132d538ced83c1699a6.png';


update target.Weapons
set season_name = 'Season of the Outlaw',
    season_icon = '/common/destiny2_content/icons/season4.png',
    year        = 2,
    season      = 4,
    start_date  = '2018-09-04T17:00:00Z',
    end_date    = '2018-12-04T17:00:00Z',
    genre       = 'Forsaken',
    duration    = 91
where substr(watermark_url, 32, 67) = '1b6c8b94cec61ea42edb1e2cb6b45a31.png';


update target.Weapons
set season_name = 'Season of the Forge',
    season_icon = '/common/destiny2_content/icons/season5.png',
    year        = 2,
    season      = 5,
    start_date  = '2018-12-04T17:00:00Z',
    end_date    = '2019-05-05T17:00:00Z',
    genre       = 'Forsaken',
    duration    = 152
where substr(watermark_url, 32, 67) = '448f071a7637fcefb2fccf76902dcf7d.png';


update target.Weapons
set season_name = 'Season of the Drifter',
    season_icon = '/common/destiny2_content/icons/season6.png',
    year        = 2,
    season      = 6,
    start_date  = '2019-05-05T17:00:00Z',
    end_date    = '2019-06-04T17:00:00Z',
    genre       = 'Forsaken',
    duration    = 30
where substr(watermark_url, 32, 67) = '1448dde4efdb57b07f5473f87c4fccd7.png';


update target.Weapons
set season_name = 'Season of Opulence',
    season_icon = '/common/destiny2_content/icons/season7.png',
    year        = 2,
    season      = 7,
    start_date  = '2019-06-04T17:00:00Z',
    end_date    = '2019-10-01T17:00:00Z',
    genre       = 'Forsaken',
    duration    = 119
where substr(watermark_url, 32, 67) = '5364cc3900dc3615cb0c4b03c6221942.png';


update target.Weapons
set season_name = 'Shadowkeep',
    season_icon = '/common/destiny2_content/icons/season8_shadow_keep.png',
    year        = 3,
    season      = 8,
    start_date  = '2019-10-01T17:00:00Z',
    end_date    = '2019-12-10T17:00:00Z',
    genre       = 'Shadowkeep',
    duration    = 70
where substr(watermark_url, 32, 67) = '2352f9d04dc842cfcdda77636335ded9.png';


update target.Weapons
set season_name = 'Season of the Undying',
    season_icon = '/common/destiny2_content/icons/season8_season_of_the _undying.png',
    year        = 3,
    season      = 8,
    start_date  = '2019-10-01T17:00:00Z',
    end_date    = '2019-12-10T17:00:00Z',
    genre       = 'Shadowkeep',
    duration    = 70
where substr(watermark_url, 32, 67) = 'e8fe681196baf74917fa3e6f125349b0.png';


update target.Weapons
set season_name = 'Season of Dawn',
    season_icon = '/common/destiny2_content/icons/season9.png',
    year        = 3,
    season      = 9,
    start_date  = '2019-12-10T17:00:00Z',
    end_date    = '2020-03-10T17:00:00Z',
    genre       = 'Shadowkeep',
    duration    = 91
where substr(watermark_url, 32, 67) = '3ba38a2b9538bde2b45ec9313681d617.png';


update target.Weapons
set season_name = 'Season of the Worthy',
    season_icon = '/common/destiny2_content/icons/season10.png',
    year        = 3,
    season      = 10,
    start_date  = '2020-03-10T17:00:00Z',
    end_date    = '2020-06-09T17:00:00Z',
    genre       = 'Shadowkeep',
    duration    = 91
where substr(watermark_url, 32, 67) = 'b12630659223b53634e9f97c0a0a8305.png';


update target.Weapons
set season_name = 'Season of Arrivals',
    season_icon = '/common/destiny2_content/icons/DestinySeasonDefinition_97331ffcc89a51d8032b1e655546c218.png',
    year        = 3,
    season      = 11,
    start_date  = '2020-06-09T17:00:00Z',
    end_date    = '2020-11-10T17:00:00Z',
    genre       = 'Shadowkeep',
    duration    = 154
where substr(watermark_url, 32, 67) = '4c25426263cacf963777cd4988340838.png';


update target.Weapons
set season_name = 'Beyond Light',
    season_icon = '/common/destiny2_content/icons/DestinySeasonDefinition_a12fd678d5e2b9d614af4e02e43fbd5b.png',
    year        = 4,
    season      = 12,
    start_date  = '2020-11-10T17:00:00Z',
    end_date    = '2021-02-09T17:00:00Z',
    genre       = 'Beyond Light',
    duration    = 91
where substr(watermark_url, 32, 67) = '9e0f43538efe9f8d04546b4b0af6cc43.png';


update target.Weapons
set season_name = 'Season of the Hunt',
    season_icon = '/common/destiny2_content/icons/DestinySeasonDefinition_a12fd678d5e2b9d614af4e02e43fbd5b.png',
    year        = 4,
    season      = 12,
    start_date  = '2020-11-10T17:00:00Z',
    end_date    = '2021-02-09T17:00:00Z',
    genre       = 'Beyond Light',
    duration    = 91
where substr(watermark_url, 32, 67) = 'be3c0a95a8d1abc6e7c875d4294ba233.png';


update target.Weapons
set season_name = 'Season of the Chosen',
    season_icon = '/common/destiny2_content/icons/DestinySeasonDefinition_d1eb59faf9fb654af3735c710f6e374a.png',
    year        = 4,
    season      = 13,
    start_date  = '2021-02-09T17:00:00Z',
    end_date    = '2021-05-11T17:00:00Z',
    genre       = 'Beyond Light',
    duration    = 91
where substr(watermark_url, 32, 67) = '5ac4a1d48a5221993a41a5bb524eda1b.png';


update target.Weapons
set season_name = 'Season of the Splicer',
    season_icon = '/common/destiny2_content/icons/DestinySeasonDefinition_471b4cef2f4c007d2a4ac33a02355054.png',
    year        = 4,
    season      = 14,
    start_date  = '2021-05-11T17:00:00Z',
    end_date    = '2021-08-24T17:00:00Z',
    genre       = 'Beyond Light',
    duration    = 105
where substr(watermark_url, 32, 67) = '23968435c2095c0f8119d82ee222c672.png';


update target.Weapons
set season_name = 'Season of the Lost',
    season_icon = '/common/destiny2_content/icons/DestinySeasonDefinition_265abf1e776ea726de1f1459392727b6.png',
    year        = 4,
    season      = 15,
    start_date  = '2021-08-24T17:00:00Z',
    end_date    = '2022-02-22T17:00:00Z',
    genre       = 'Beyond Light',
    duration    = 182
where substr(watermark_url, 32, 67) = 'd92e077d544925c4f37e564158f8f76a.png';


update target.Weapons
set season_name = '30th Anniversary',
    season_icon = '/common/destiny2_content/icons/30thAnniversary.png',
    year        = 4,
    season      = 15,
    start_date  = '2021-12-07T17:00:00Z',
    end_date    = '2022-02-22T17:00:00Z',
    genre       = 'Beyond Light',
    duration    = 77
where substr(watermark_url, 32, 67) = '671a19eca92ad9dcf39d4e9c92fcdf75.png';


update target.Weapons
set season_name = 'Witch Queen',
    season_icon = '/common/destiny2_content/icons/DestinySeasonDefinition_0f47a186cf0cb88d2388d811a6ec89cb.png',
    year        = 5,
    season      = 16,
    start_date  = '2022-02-22T17:00:00Z',
    end_date    = '2022-05-24T17:00:00Z',
    genre       = 'Witch Queen',
    duration    = 91
where substr(watermark_url, 32, 67) = 'b973f89ecd631a3e3d294e98268f7134.png';


update target.Weapons
set season_name = 'Season of the Risen',
    season_icon = '/common/destiny2_content/icons/DestinySeasonDefinition_0f47a186cf0cb88d2388d811a6ec89cb.png',
    year        = 5,
    season      = 16,
    start_date  = '2022-02-22T17:00:00Z',
    end_date    = '2022-05-24T17:00:00Z',
    genre       = 'Witch Queen',
    duration    = 91
where substr(watermark_url, 32, 67) = '6e4fdb4800c34ccac313dd1598bd7589.png';


update target.Weapons
set season_name = 'Season of the Haunted',
    season_icon = '/common/destiny2_content/icons/DestinySeasonDefinition_3847a7f2241ce39588bfc2c85239b055.png',
    year        = 5,
    season      = 17,
    start_date  = '2022-05-24T17:00:00Z',
    end_date    = '2022-08-23T17:00:00Z',
    genre       = 'Witch Queen',
    duration    = 91
where substr(watermark_url, 32, 67) = 'ab075a3679d69f40b8c2a319635d60a9.png';


update target.Weapons
set season_name = 'Season of the Plunder',
    season_icon = '/common/destiny2_content/icons/DestinySeasonDefinition_b358e1c398ec9f74b1f90318b0b08c21.png',
    year        = 5,
    season      = 18,
    start_date  = '2022-08-23T17:00:00Z',
    end_date    = '2022-12-06T17:00:00Z',
    genre       = 'Witch Queen',
    duration    = 105
where substr(watermark_url, 32, 67) = 'a3923ae7d2376a1c4eb0f1f154da7565.png';


update target.Weapons
set season_name = 'Season of the Seraph',
    season_icon = '/common/destiny2_content/icons/DestinySeasonDefinition_dd9fe0539a0c29c9e6f5f4d257d3c15a.png',
    year        = 5,
    season      = 19,
    start_date  = '2022-12-06T17:00:00Z',
    end_date    = '2023-02-28T17:00:00Z',
    genre       = 'Witch Queen',
    duration    = 84
where substr(watermark_url, 32, 67) = 'e775dcb3d47e3d54e0e24fbdb64b5763.png';


update target.Weapons
set season_name = 'Lightfall',
    season_icon = '/common/destiny2_content/icons/DestinySeasonDefinition_50d80a655bccddfd26e954dbfc3b9746.png',
    year        = 6,
    season      = 20,
    start_date  = '2023-02-28T17:00:00Z',
    end_date    = '2023-05-23T17:00:00Z',
    genre       = 'Lightfall',
    duration    = 84
where substr(watermark_url, 32, 67) = 'af00bdcd3e3b89e6e85c1f63ebc0b4e4.png';


update target.Weapons
set season_name = 'Season of Defiance',
    season_icon = '/common/destiny2_content/icons/DestinySeasonDefinition_50d80a655bccddfd26e954dbfc3b9746.png',
    year        = 6,
    season      = 20,
    start_date  = '2023-02-28T17:00:00Z',
    end_date    = '2023-05-23T17:00:00Z',
    genre       = 'Lightfall',
    duration    = 84
where substr(watermark_url, 32, 67) = '31445f1891ce9eb464ed1dcf28f43613.png';


update target.Weapons
set season_name = 'Season of the Deep',
    season_icon = '/common/destiny2_content/icons/DestinySeasonDefinition_f82759315a8d05fc597778d2086acee4.png',
    year        = 6,
    season      = 21,
    start_date  = '2023-05-23T17:00:00Z',
    end_date    = '2023-08-22T17:00:00Z',
    genre       = 'Lightfall',
    duration    = 91
where substr(watermark_url, 32, 67) = '6026e9d64e8c2b19f302dafb0286897b.png';


update target.Weapons
set season_name = 'Season of the Witch',
    season_icon = '/common/destiny2_content/icons/DestinySeasonDefinition_fdbb36bb7f4f81c0170ca0b2cced22d6.png',
    year        = 6,
    season      = 22,
    start_date  = '2023-08-22T17:00:00Z',
    end_date    = '2023-11-28T17:00:00Z',
    genre       = 'Lightfall',
    duration    = 98
where substr(watermark_url, 32, 67) = '3de52d90db7ee2feb086ef6665b736b6.png';


update target.Weapons
set season_name = 'Season of the Wish',
    season_icon = '/common/destiny2_content/icons/DestinySeasonDefinition_7026238c20605a7e6842a5d799732d4b.png',
    year        = 6,
    season      = 23,
    start_date  = '2023-11-28T17:00:00Z',
    end_date    = '2024-06-04T17:00:00Z',
    genre       = 'Lightfall',
    duration    = 189
where substr(watermark_url, 32, 67) = 'a2fb48090c8bc0e5785975fab9596ab5.png';


update target.Weapons
set season_name = 'Into the Light',
    season_icon = '/common/destiny2_content/icons/season23_into_the_light.png',
    year        = 6,
    season      = 23,
    start_date  = '2024-04-09T17:00:00Z',
    end_date    = '2024-06-04T17:00:00Z',
    genre       = 'Lightfall',
    duration    = 56
where substr(watermark_url, 32, 67) = 'd5a3f4d7d20fefc781fea3c60bde9434.png';


update target.Weapons
set season_name = 'The Final Shape',
    season_icon = '/common/destiny2_content/icons/DestinySeasonDefinition_191cb7a0671a82cd7eb5a7c2d5e159ba.png',
    year        = 7,
    season      = 24,
    start_date  = '2024-06-04T17:00:00Z',
    end_date    = '2024-10-08T17:00:00Z',
    genre       = 'The Final Shape',
    duration    = 126
where substr(watermark_url, 32, 67) = 'e3ea0bd2e889b605614276876667759c.png';


update target.Weapons
set season_name = 'Episode 1: Echoes',
    season_icon = '/common/destiny2_content/icons/DestinySeasonDefinition_191cb7a0671a82cd7eb5a7c2d5e159ba.png',
    year        = 7,
    season      = 24,
    start_date  = '2024-06-04T17:00:00Z',
    end_date    = '2024-10-08T17:00:00Z',
    genre       = 'The Final Shape',
    duration    = 126
where substr(watermark_url, 32, 67) = '0337ec21962f67c7c493fedb447c4a9b.png';


update target.Weapons
set season_name = 'Episode 2: Revenant',
    season_icon = '/common/destiny2_content/icons/DestinySeasonDefinition_df1a769d27453619889872819b775924.png',
    year        = 7,
    season      = 25,
    start_date  = '2024-10-08T17:00:00Z',
    end_date    = '2025-02-04T17:00:00Z',
    genre       = 'The Final Shape',
    duration    = 119
where substr(watermark_url, 32, 67) = '5586f6a4193e34acc035209b5e9204d8.png';


update target.Weapons
set season_name = 'Episode 3: Heresy',
    season_icon = '/common/destiny2_content/icons/DestinySeasonDefinition_c704c59d44f0cfb7472cd09101eb8399.png',
    year        = 7,
    season      = 26,
    start_date  = '2025-02-04T17:00:00Z',
    end_date    = '2025-07-15T17:00:00Z',
    genre       = 'The Final Shape',
    duration    = 161
where substr(watermark_url, 32, 67) = '428c962c15612ea89693349d1b84531a.png';


update target.Weapons
set season_name = 'Crimson Days',
    season_icon = '/common/destiny2_content/icons/DestinyActivityModeDefinition_f9d1438e0536f36e868e691eb0acfc4d.png',
    year        = 0,
    season      = 0,
    start_date  = '',
    end_date    = '',
    genre       = '',
    duration    = 0
where substr(watermark_url, 32, 67) = '428c962c15612ea89693349d1b84531a.png';


update target.Weapons
set season_name = 'The Dawning',
    season_icon = '/common/destiny2_content/icons/DestinyEventCardDefinition_de8fe70bc9e0537c04681f5581c6c452.png',
    year        = 0,
    season      = 0,
    start_date  = '',
    end_date    = '',
    genre       = '',
    duration    = 0
where substr(watermark_url, 32, 67) = '428c962c15612ea89693349d1b84531a.png';


update target.Weapons
set season_name = 'The Revelry',
    season_icon = '/common/destiny2_content/icons/the_revelry.png',
    year        = 2,
    season      = 5,
    start_date  = '2019-04-16T17:00:00Z',
    end_date    = '2019-05-06T17:00:00Z',
    genre       = 'Vanilla',
    duration    = 20
where substr(watermark_url, 32, 67) = '428c962c15612ea89693349d1b84531a.png';


update target.Weapons
set season_name = 'The Guardian Games',
    season_icon = '/common/destiny2_content/icons/DestinyEventCardDefinition_ce6c2cf855dce694bcc89803b6bc44b7.png',
    year        = 0,
    season      = 0,
    start_date  = '',
    end_date    = '',
    genre       = '',
    duration    = 0
where substr(watermark_url, 32, 67) = '428c962c15612ea89693349d1b84531a.png';


create view if not exists target.WeaponStatView as
select s.Name, ws.WeaponId, ws.Value
from Stats s
         join WeaponStats ws
              on s.Id = ws.StatId
order by WeaponId;


detach database target;