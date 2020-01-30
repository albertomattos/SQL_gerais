select v.codigo, v.descricao, v.tipo_prd, t.documento, t.quant, t.qtd_atendida, u.data_mov
from popedite t, popedcad u, faprdcad v
where t.documento = u.documento and t.cod_prd = v.codigo
and u.data_mov >= '01/01/2012' and u.set_con = '0312'
and v.tipo_prd in ('IMO', 'MEX') and v.gru_est in ('STI','EQI') and v.lin_mat <> 'CART'
order by 2
