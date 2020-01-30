select tipo_prd,codigo,faprdcad.descricao,descricao_comp,esfabricante.nome,eslincad.descricao,gru_est,cod_gru,
uni_compra,uni_distri,uni_estoqu,divisor,data_cad,cod_gcn, cod_simpro,cod_bras,num_registro
from faprdcad, esfabricante, eslincad
where faprdcad.cod_fabric_padrao = esfabricante.cod_fabricante
and faprdcad.lin_mat = eslincad.cod_lin
and bloqueado = "N"
and tipo_prd in ('DES','FIO','MED')
order by tipo_prd
