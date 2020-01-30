select p.cod_prt prontuário, p.nome_pac paciente, r.cod_pac registro, s.fantasia convênio, r.data_ent entrada, r.data_alta alta
from faprtcad p, fapaccad r, faconcad s
where r.cod_prt = p.cod_prt and r.cod_con = s.cod_con
and r.tipo_pac = 'I'
union
select p.cod_prt prontuário, p.nome_pac paciente, r.cod_pac registro, s.fantasia convênio, r.data_ent entrada, r.data_alta alta
from faprtcad@prodantigo p, fapaccad@prodantigo r, faconcad@prodantigo s
where r.cod_prt = p.cod_prt and r.cod_con = s.cod_con
and r.tipo_pac = 'I'
order by 2


/*
and r.data_ent >= "01/01/2005"

select count(*) from faprtcad p, fapaccad r
where r.cod_prt = p.cod_prt
and r.data_ent >= "01/01/2005"
*/
