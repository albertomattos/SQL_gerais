select estfocad.descricao, sum(cpmovite.valor_pago)
from cpmovite, cpmovcad, estfocad
where cpmovcad.lancamento = cpmovite.lancamento and
cpmovite.cod_fir = "0001" and
cpmovite.data_baixa between "01/08/2005" and "31/08/2005"
and estfocad.cod_tfo = cpmovcad.tipo_for
group by estfocad.descricao
order by estfocad.descricao

--select * from cpmovite
--select * from estfocad

