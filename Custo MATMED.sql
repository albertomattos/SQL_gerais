select sum(a.valor_tot) as soma_valor, sum(d.custo_atu) as custo
from famovdestino a, famovcad b, famovprd c, faprdcad d, fapaccad e where a.sequencial = c.sequencial
and c.comanda = b.comanda
and c.tipo_comanda = b.tipo_comanda
and c.codigo = d.codigo
and b.cod_pac = e.cod_pac
and a.destino in ("C","P")
and d.tipo_prd in ("DES", "FIO", "SNC", "ESP", "DCN", "MED", "SNT", "MDE", "MEP")
and e.data_ent between "01/10/2009" and "31/10/2009"
and b.set_ori = "3314"
and b.req_dev = "R";
select sum(a.valor_tot) as soma_valor, sum(d.custo_atu) as custo
from famovdestino a, famovcad b, famovprd c, faprdcad d, fapaccad e where a.sequencial = c.sequencial
and c.comanda = b.comanda
and c.tipo_comanda = b.tipo_comanda
and c.codigo = d.codigo
and b.cod_pac = e.cod_pac
and a.destino in ("C","P")
and d.tipo_prd in ("ESP")
and e.data_ent between "01/10/2009" and "31/10/2009"
and b.set_ori = "3314"
and b.req_dev = "R";
select sum(a.valor_tot) as soma_valor, sum(d.custo_atu) as custo
from famovdestino a, famovcad b, famovprd c, faprdcad d, fapaccad e where a.sequencial = c.sequencial
and c.comanda = b.comanda
and c.tipo_comanda = b.tipo_comanda
and c.codigo = d.codigo
and b.cod_pac = e.cod_pac
and a.destino in ("C","P")
and d.tipo_prd in ("MDE")
and e.data_ent between "01/10/2009" and "31/10/2009"
and b.set_ori = "3314"
and b.req_dev = "R"
