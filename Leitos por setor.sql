select leito, faleicad.descricao, fasetcad.cod_set, fasetcad.descricao from faleicad, fasetcad where faleicad.cod_set = fasetcad.cod_set
and desativado is null and tipo <> 'HP'
order by 4,2
