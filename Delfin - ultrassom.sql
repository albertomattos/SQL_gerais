select a.comanda, a.cod_pac, a.data_mov, b.codigo, c.destino, d.cod_con, e.descricao
from famovcad a, famovprd b, famovdestino c, fapaccad d, faprdcad e
where a.comanda = b.comanda
and b.sequencial = c.sequencial
and a.cod_pac = d.cod_pac
and b.codigo = e.codigo
and a.cod_pac in (select cod_pac from fapaccom where cod_set = "8843") and data_mov >= "01/03/2008"
and c.destino = "H"
and e.tipo_prd = "ULT"
