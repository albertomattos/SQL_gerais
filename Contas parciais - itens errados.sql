select b.cod_pac, a.comanda, a.codigo, c.descricao, b.req_dev, a.quant, b.data_mov, b.hora_mov, b.usuario, b.data_hora_dig
from famovprd a, famovcad b, faprdcad c
where a.comanda = b.comanda
and a.codigo = c.codigo
and a. codigo = "221995" and cod_pac = "G597045"
order by b.data_mov, b.hora_mov
