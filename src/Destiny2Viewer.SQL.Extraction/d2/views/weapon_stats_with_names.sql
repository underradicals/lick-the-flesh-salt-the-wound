create view if not exists WeaponStatView as
select s.Name, ws.WeaponId, ws.Value 
from Stats s 
    join WeaponStats ws 
        on s.Id = ws.StatId 
order by WeaponId;