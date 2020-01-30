select a.cod_pac, e.nome_pac, f.fantasia, b.data_mov, c.codigo, g.descricao, d.valor, c.quant, d.valor_tot
from fapaccad a, famovcad b, famovprd c, famovdestino d, faprtcad e, faconcad f, faprdcad g
where a.cod_pac = b.cod_pac and b.comanda = c.comanda and b.tipo_comanda = c.tipo_comanda
and c.sequencial = d.sequencial and a.cod_prt = e.cod_prt and a.cod_con = f.cod_con and c.codigo = g.codigo
and a.data_ent >= '01/03/2013'
and c.codigo in ('221026','052089','025090','052091')
and a.cod_pac in (select cod_pac from fapaccom where cod_set = '0025')
order by 4
