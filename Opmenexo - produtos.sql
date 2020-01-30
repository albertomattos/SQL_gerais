select codigo, descricao, descricao_comp, esfabricante.nome, num_registro, modelo_comercial, co_tuss, nu_ref_mat,
uni_compra, custo_atu
from faprdcad, esfabricante
where cod_fabric_padrao = cod_fabricante(+)
and bloqueado = 'N' and tipo_prd in ('ESP','OPM')
order by descricao
