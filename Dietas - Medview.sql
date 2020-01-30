select t.data_hora_presc, u.leito, u.cod_pac, v.nome_pac, w.descricao, y.descricao
from mvchkdie t, fapaccad u, faprtcad v, mvdiecad w, faprccad x, faprdcad y
where t.cod_pac = u.cod_pac and u.cod_prt = v.cod_prt
and t.cod_dieta = w.cod_dieta
and u.cod_pac = x.cod_pac and x.cod_prd = y.codigo
and u.tipo_pac = 'I' and u.data_alta is null
and t.data_hora_presc >= '19/04/2012'
and x.principal = 'S'
