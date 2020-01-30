select distinct a.cod_pac, b.fantasia, e.nome_plano, f.descricao
from fapaccad a, faconcad b, famovcad c, famovprd d, faplacad e, faprdcad f where
a.cod_con = b.cod_con and a.cod_pac = c.cod_pac and c.comanda = d.comanda and c.tipo_comanda = d.tipo_comanda
and a.cod_pla = e.cod_pla and a.cod_con = e.cod_con and d.codigo = f.codigo
and a.tipo_pac = 'I' and a.data_ent between '01/01/2016' and '30/04/2016' and b.cod_con not in ('001','069') and e.nome_plano like 'ENFER%'
and f.tipo_prd = 'DIA' and f.codigo not in ('203122','225816','203141','203168','203161','225169','227344')order by 4
