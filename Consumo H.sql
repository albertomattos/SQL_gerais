select c.nome usuario, e.cod_pac, f.nome_pac, g.codigo, g.descricao, h.fantasia, d.valor_tot
from famovcad a, famovprd b, fausucad c, famovdestino d, fapaccad e, faprtcad f, faprdcad g, faconcad h
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and a.usuario = c.apelido and b.sequencial = d.sequencial and e.cod_con = h.cod_con
and a.cod_pac = e.cod_pac and e.cod_prt = f.cod_prt and b.codigo = g.codigo
and d.destino = 'H'
and a.data_mov between '28/06/2013' and '28/06/2013'
and g.tipo_prd <> 'KIT'
