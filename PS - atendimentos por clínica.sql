select DISTINCT b.cod_pro, b.nome_pro, c.descricao, a.cod_ala, e.descricao, a.data_ent, a.rowid
from fapaccad a, faprocad b, faespcad c, faesppro d, faalacad e where a.cod_pro = b.cod_pro
and b.cod_pro = d.cod_pro and d.cod_esp = c.cod_esp and a.cod_ala = e.cod_ala
and data_ent between '22/02/2018' and '23/02/2018'
and tipo_pac = 'U' and d.sn_principal = 'S'
--and a.cod_ala = 'CMED'
order by 5
/*
select DISTINCT b.cod_pro, b.nome_pro, c.descricao, a.cod_ala, e.cod_ala, a.rowid
from fapaccad a, faprocad b, faespcad c, faesppro d, espcli_prof_unid e where a.cod_pro = b.cod_pro
and b.cod_pro = d.cod_pro and d.cod_esp = c.cod_esp and b.cod_pro = e.cod_pro and b.cod_pro = e.cod_pro
and c.cod_esp = e.cod_esp
and data_ent between '01/01/2018' and '22/02/2018'
and a.cod_ala = 'CMED' and tipo_pac = 'U' and d.sn_principal = 'S'
order by 2,5,6*/

select DISTINCT b.cod_pro, b.nome_pro, c.descricao, e.cod_ala, c.cod_esp, e.rowid
from faprocad b, faespcad c, faesppro d, espcli_prof_unid e where 
b.cod_pro = d.cod_pro and d.cod_esp = c.cod_esp and b.cod_pro = e.cod_pro and b.cod_pro = e.cod_pro
and c.cod_esp = e.cod_esp
and c.cod_esp = 'CARDI'
and d.sn_principal = 'S'
order by 2,5
