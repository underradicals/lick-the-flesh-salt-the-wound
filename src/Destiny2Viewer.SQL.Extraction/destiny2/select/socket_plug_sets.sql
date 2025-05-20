-- Just the Two Columns (reusablePlugSetHash, randomizedPlugSetHash)
-- WeaponId ==> PlugSetHash
select diid.id as WeaponId,
       value as PlugSetHash
from DestinyInventoryItemDefinition as diid,
     json_tree(diid.json ->> 'sockets' ->> 'socketEntries') as jt
where diid.json ->> 'itemType' = 3
  and (key = 'reusablePlugSetHash' or key = 'randomizedPlugSetHash');


select diid.id, value
from DestinyInventoryItemDefinition as diid,
     json_tree(diid.json ->> 'sockets' ->> 'socketEntries') as jt
where diid.json ->> 'itemType' = 3 and
      ((key != 'socketTypeHash' and value != 1288200359) and (key = 'reusablePlugSetHash' or key = 'randomizedPlugSetHash'));