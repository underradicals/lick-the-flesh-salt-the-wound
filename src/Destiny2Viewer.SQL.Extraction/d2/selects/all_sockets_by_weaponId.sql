-- Which sockets are associated with a particular weaponId?
select wph.weapon_id, pss.socket_id, sk.name, sk.display_name
from WeaponPlugSetHashes as wph
         inner join PlugSetHashSockets as pss
         inner join Sockets as sk
             on wph.plug_set_hash = pss.plug_set_id
             and pss.socket_id = sk.id
where weapon_id = 32287609 and display_name != 'Shader';

-- How many weapons use a particular socket?
select distinct wph.weapon_id, pss.socket_id
from WeaponPlugSetHashes as wph
         inner join PlugSetHashSockets as pss
         inner join Sockets as sk
             on wph.plug_set_hash = pss.plug_set_id
             and pss.socket_id = sk.id
where display_name != 'Shader' and pss.socket_id = 47981717;