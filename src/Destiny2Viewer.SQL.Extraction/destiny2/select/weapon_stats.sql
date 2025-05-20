with cte as (select
                 DestinyInventoryItemDefinition.json ->> 'hash' as Id, json_each.value
             from DestinyInventoryItemDefinition, json_each(DestinyInventoryItemDefinition.json, '$.investmentStats')
             WHERE DestinyInventoryItemDefinition.json ->> 'itemType' = 3)
select
    Id,
    cte.value ->> 'statTypeHash' as StatTypeHash,
    cte.value ->> 'value' as Value
from cte order by Id;