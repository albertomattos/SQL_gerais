select a.codigo, b.descricao, b.uni_distri, a.quant, b.custo_atu from fakitprd a, faprdcad b where
a.codigo = b.codigo
and a.cod_kit = "265520"
order by b.descricao
