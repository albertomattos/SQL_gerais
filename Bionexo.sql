select codigo, descricao, esfabricante.nome, uni_compra, custo_atu from faprdcad, esfabricante
where faprdcad.cod_fabric_padrao = esfabricante.cod_fabricante
and tipo_prd = 'MED' and bloqueado = 'N'
order by descricao
