select * from wpd.fapaccad@prod a, wpd.fapaccom@prod b
where a.cod_pac = b.cod_pac
and a.data_ent between '01/02/2013' and '28/02/2013'
and a.tipo_pac = 'I'
and cod_ala <> 'HMDA'

select :P_MES, :P_ITEM, e.codigo, count(*)
from wpd.fapaccad@prod a, wpd.fapaccom@prod b
where a.cod_pac = b.cod_pac
and b.cod_set = e.cod_cliente
and a.data_ent between :P_DATA_INICIAL and :P_DATA_FINAL
and a.tipo_pac = 'I'
and cod_ala <> 'HMDA'
group by e.codigo
