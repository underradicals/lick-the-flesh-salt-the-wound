select
    json ->> 'hash' as Id,
    json ->> 'displayProperties' ->> 'name' as Name,
    coalesce(json ->> 'displayProperties' ->> 'icon', '') as Icon,
    case json ->> 'statCategory'
        when 0 then 'Gameplay'
        when 1 then 'Weapon'
        when 2 then 'Defense'
        when 3 then 'Primary'
        end as Category,
    case json ->> 'aggregationType'
        when 0 then 'CharacterAverage'
        when 1 then 'Character'
        when 2 then 'Item'
        end as Type,
    json ->> 'displayProperties' ->> 'description' as Description
from DestinyStatDefinition where Name is not '';