select a.cod_pac, g.nome_pac, b.data_mov, h.fantasia, c.codigo, e.descricao, f.descricao setor_comanda, c.quant, d.valor unitario,
d.valor_tot total
from fapaccad a, famovcad b, famovprd c, famovdestino d, faprdcad e, fasetcad f, faprtcad g, faconcad h
where a.cod_pac = b.cod_pac and b.comanda = c.comanda and b.tipo_comanda = c.tipo_comanda
and c.sequencial = d.sequencial and c.codigo = e.codigo and b.set_ori = f.cod_set
and a.cod_prt = g.cod_prt and a.cod_con = h.cod_con
and a.data_ent >= '01/03/2013'
and e.tipo_prd = 'PRO'
and c.codigo not in ('217240','000007','000020','216611')
and a.cod_pac in (select cod_pac from fapaccom where cod_set = '0025')
