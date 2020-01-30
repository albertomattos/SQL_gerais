select t.cod_prd, v.descricao, t.validade, t.lote, t.hab_cont_lot_val
from esmovite t, esmovcad u, faprdcad v where t.documento = u.documento and t.tipo_documento = u.tipo_documento
and t.cod_prd = v.codigo
and u.data_mov between '01/03/2014' and '24/03/2014'
and t.tipo_documento = 'COM' and v.tipo_prd = 'MED'
order by 2
