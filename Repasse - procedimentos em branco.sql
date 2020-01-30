select comanda, tipo_comanda, codigo, quant, cod_pro, tipo_pgto, tipo_ato, cod_guia, numero_repasse
from famovprd where codigo in ('009897')
--and numero_repasse is not null
and comanda in (select comanda from famovcad where data_mov between '16/04/2015' and '16/04/2015')

select e.nome_pac, a.destino, b.codigo, a.valor_tot, c.req_dev, a.cod_fatura, b.cod_pro, b.tipo_pgto, d.cod_pac, d.cod_con, d.cod_pla
from famovdestino a, famovprd b, famovcad c, fapaccad d, faprtcad e, fafatcad f, faremcad g, faprdcad h, faprocad i
where a.sequencial = b.sequencial
and b.comanda = c.comanda
and c.cod_pac = d.cod_pac
and d.cod_prt = e.cod_prt
and f.fatura = a.cod_fatura
and g.remessa = f.remessa
and h.codigo = b.codigo
and i.cod_pro = b.cod_pro
and g.data_emiss between "16/06/2008" and "30/06/2008"
and a.numero_repasse is null
and i.grupo = "694"
and d.cod_con <> "058"
order by d.cod_con, d.cod_pla, b.cod_pro, e.nome_pac, b.codigo
--and b.cod_pro in ('011051')--,'011980','014994','019905')
--and b.tipo_pgto = "R"
--and h.tipo_prd = "ANE"
--and a.destino = "C"
--order by a.destino, b.cod_pro, e.nome_pac
--and b.codigo in ('093606','040724')
select * from famovdestino

select * from faprocad where grupo = "694"
