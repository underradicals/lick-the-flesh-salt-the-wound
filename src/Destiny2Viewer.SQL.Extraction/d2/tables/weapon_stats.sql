CREATE TABLE IF NOT EXISTS Stats
(
    id               not null,
    name        text not null,
    icon        text null default '',
    category    text not null,
    type        text not null,
    description text not null,
    constraint pk_stats_id primary key (id)
);

create index idx_stats_name on Stats (Name);
create index idx_stats_icon on Stats (icon);
create index idx_stats_category on Stats (category);
create index id_stats_type on Stats (type);