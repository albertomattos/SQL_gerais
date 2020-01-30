select fasetcad.descricao ccusto, cod_set
from fasetcad
where fasetcad.bloqueado = 'N'
order by fasetcad.descricao
