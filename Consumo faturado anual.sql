select sum(c.valor_tot) from famovcad a, famovprd b, famovdestino c where
a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial
and a.data_mov between '01/01/2011' and '31/12/2011'
and a.req_dev = 'D'
and c.cod_fatura is not null
