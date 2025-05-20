-- PlugSetHashes
-- PlugSetHash ==> SocketId
with cte as (select DestinyPlugSetDefinition.id as PlugSetHash, value as json
             from DestinyPlugSetDefinition, json_each(DestinyPlugSetDefinition.json ->> 'reusablePlugItems'))
select PlugSetHash, json ->> 'plugItemHash' as SocketId from cte;