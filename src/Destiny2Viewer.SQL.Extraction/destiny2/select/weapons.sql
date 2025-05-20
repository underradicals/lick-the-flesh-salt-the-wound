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