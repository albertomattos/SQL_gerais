select faconcad.fantasia, faprdcad.descricao /*count(faprdcad.descricao)*/
from famovcad, faprdcad, famovprd, fapaccad, faconcad
where famovcad.comanda = famovprd.comanda
and famovprd.codigo = faprdcad. codigo
and famovcad.cod_pac = fapaccad.cod_pac
and fapaccad.cod_con = faconcad.cod_con
and faprdcad.tipo_prd in (select tipo_prd from fatipcad where pre_class in ('HON', 'EXA'))
and famovcad.data_mov between '01/01/2011' and '01/02/2011'
and famovcad.set_ori = '0124'
--and famovprd.tipo_ato = '01'
/*and (famovprd.tipo_ato = '01' or famovprd.tipo_ato = "02" or famovprd.tipo_ato = "04" or famovprd.tipo_ato = "05"
or famovprd.tipo_ato = "06" or famovprd.tipo_ato = "07" or famovprd.tipo_ato = "09" or famovprd.tipo_ato = "10"
or famovprd.tipo_ato = "57" or famovprd.tipo_ato = "98" or famovprd.tipo_ato = "99")*/
group by faconcad.fantasia, faprdcad.descricao, famovcad.cod_pac, fapaccad.data_ent, famovprd.valor
order by faprdcad.descricao, faconcad.fantasia
