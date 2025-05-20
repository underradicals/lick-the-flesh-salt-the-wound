with socket_cte as (
    select 'displayProperties' as DisplayProperties
)
select
    json -> 'hash' as Id,
    json -> DisplayProperties ->> 'name' as Name,
    json -> DisplayProperties ->> 'description' as Description,
    json ->> 'itemTypeDisplayName' as DisplayName,
    coalesce(json -> 'inventory' ->> 'tierTypeName', '') as TierType,
    coalesce(json -> DisplayProperties ->> 'icon', '') as IconUrl,
    json -> 'tooltipNotifications' as ToolTip
from DestinyInventoryItemDefinition, socket_cte where json ->> 'itemType' = 19 and Name is not '';