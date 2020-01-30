select distinct p.cod_prt, r.data_ent, r.tipo_pac, p.nome_pac, p.fone_res, p.celular from faprtcad p, fapaccad r
where r.cod_prt = p.cod_prt
and r.data_ent >= '01/01/2016'
and p.data_obito is null and r.tipo_pac in ('I','A')
--and r.cod_pro = '003205'
