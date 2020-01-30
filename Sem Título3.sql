select distinct t.cod_pro, v.nome_pro, count(t.cod_pro), to_char(data_mov,'MMYYYY')
from famovprd t, famovcad u, faprocad v, famovdestino x, fapaccad y
where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
and t.sequencial = x.sequencial
and t.cod_pro = v.cod_pro
and u.cod_pac = y.cod_pac
and t.codigo in (select codigo from faprdcad where tipo_prd = 'CON')
--and u.data_mov between '01/10/2012' and '31/10/2012'
and to_char(u.data_mov,'MMYYYY') = '102012'
and y.tipo_pac = 'A'
group by t.cod_pro, v.nome_pro, u.data_mov
order by 2;
