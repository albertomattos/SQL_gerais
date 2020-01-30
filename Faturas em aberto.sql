select e.fantasia, a.remessa, d.data_venci, d.data_emiss, a.fatura, a.cod_pac, b.matricula, b.senha, c.nome_pac,
b.nome_segu, a.data_emiss, b.data_ent, a.valor_tot, a.valor_guia
from fafatcad a, fapaccad b, faprtcad c, faremcad d, faconcad e
where a.cod_pac = b.cod_pac and b.cod_prt = c.cod_prt and a.remessa = d.remessa and a.cod_con = e.cod_con
and a.quitada = 'N'
and e.fantasia like 'BRADESCO%'
and d.data_venci between &data_venci and &data_venci
order by e.fantasia, d.data_venci, a.remessa, c.nome_pac
