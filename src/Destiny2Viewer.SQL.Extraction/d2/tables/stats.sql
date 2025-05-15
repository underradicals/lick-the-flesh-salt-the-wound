CREATE TABLE IF NOT EXISTS Stats (
    Id not null ,
    Name text not null ,
    Icon text null default '' ,
    Category text not null ,
    Type text not null ,
    Description text not null,
    constraint pk_stats_id primary key (Id)
);