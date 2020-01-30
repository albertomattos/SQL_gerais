select b.tipo_prd, to_char(c.hora_mov,'HH24:MI'), count(*) qtde
from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac
and b.codigo = a.codigo
and c.data_mov between '01/08/2013' and '31/08/2013'
and to_char(c.hora_mov,'HH24:Mi') between '07:00' and '18:59'
and b.tipo_prd = 'TOM'
--and b.cod_gru not in ('DENS','MAMO')
group by b.tipo_prd, c.hora_mov
order by to_char(c.hora_mov,'HH24,MI')
/*
select count(*) qtde from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac
and b.codigo = a.codigo
and c.data_mov between '01/12/2011' and '31/12/2011'
and b.tipo_prd = 'TOM'
and b.cod_gru not in ('DENS','MAMO')
*/
