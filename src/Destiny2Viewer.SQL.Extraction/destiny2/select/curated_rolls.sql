-- Curated Rolls
select diid.id as WeaponId,
       value   as SocketId
from DestinyInventoryItemDefinition as diid,
     json_tree(diid.json ->> 'sockets' ->> 'socketEntries') as jt
where diid.json ->> 'itemType' = 3
  and key = 'singleInitialItemHash';