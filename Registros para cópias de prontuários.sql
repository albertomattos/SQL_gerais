select d.descricao, b.quant, c.valor_tot
from famovcad a, famovprd b, famovdestino c, faprdcad d
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo
and a.cod_pac in (
select t.cod_pac from fapaccad t where upper(t.obs1) like '%PIA%PRONTU%' and t.cod_pac not in ('7016634','L255604'))
