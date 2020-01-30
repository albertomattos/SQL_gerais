select p.tipo_prd, p.codigo, p.descricao, p.duracao, t.pre_class
from faprdcad p, fatipcad t where p.tipo_prd = t.tipo_prd and (t.pre_class = "HON" or t.pre_class = "EXA")
and p.bloqueado = "N" and (p.duracao is null or p.duracao = "00:00")
order by t.pre_class, p.tipo_prd, p.descricao

update faprdcad set duracao = "01:00" where tipo_prd = "HON" and duracao = "00:00"
select tipo_prd, duracao, descricao, codigo from faprdcad where tipo_prd = "HMD" and duracao <> "00:00"
