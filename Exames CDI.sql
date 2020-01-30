select distinct codigo, descricao, tipo_prd from faprdcad d where codigo in(
select codigo from famovprd a, famovcad b where a.comanda = b.comanda
and a.tipo_comanda = b.tipo_comanda
and b.tipo_comanda = 'CDI')
--and d.tipo_prd in (select tipo_prd from fatipcad where pre_class = 'EXA')
order by tipo_prd, descricao
