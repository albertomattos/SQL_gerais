select a.leito, b.nome_pac, b.nascimento, c.natureza, d.nome_reduzido, f.descricao, a.cod_pac, a.cod_mae
from fapaccad a, faprtcad b, faconcad c, faprocad d, faesppro e, faespcad f, faleicad g
where a.cod_prt = b.cod_prt and a.cod_con = c.cod_con and a.cod_pro_sa = d.cod_pro and d.cod_pro = e.cod_pro
and e.cod_esp = f.cod_esp and a.leito = g.leito
and e.sn_principal = 'S'
and g.cod_set = '0191'
--and b.nome_pac not like 'RN%'
