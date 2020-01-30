select distinct t.documento, t.data_mov, t.pend_sit_mot
from esmovcad t, esmovite u
where t.tipo_documento = u.tipo_documento and t.documento = u.documento
and t.tipo_documento = 'PED'
and t.data_mov between '01/10/2017' and '31/10/2017'
and t.pend_sit_mot = 'S'
order by 1
