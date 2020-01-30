select cod_cbhpm, codigo, descricao from faprdcad where tipo_prd ='PRO'/* in ('RAT','MEN','END')*/ and cod_cbhpm not in
(select b.cod_cbhpm from faprecad a, faprdcad b where a.codigo = b.codigo and a.tabela = '03' and a.validade = '01/01/2015'
and b.tipo_prd = 'PRO')
order by 1

--select a.cod_cbhpm, a.codigo, a.descricao, a.porte_anes from faprdcad a where a.tipo_prd ='PRO'
