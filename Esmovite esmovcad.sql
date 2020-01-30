select t.tipo_documento, t.documento, t.cod_prd, t.quant, t.validade, t.lote, t.cod_barra_int, t.cod_fabricante, t.rowid
from esmovite t where t.documento = '0014528' and t.tipo_documento = 'BAL'
and t.cod_prd = '009551'

select t.tipo_documento, u.tipo_documento, t.documento, t.cod_prd, t.quant, t.validade, t.lote, t.cod_barra_int,
t.cod_fabricante, t.rowid from esmovite t, esmovcad u where t.tipo_documento = u.tipo_documento and t.documento = u.documento
and t.documento = '0007496' and t.tipo_documento = 'TRA' and t.cod_prd = '009551'

select t.pendente, u.data_mov data, t.tipo_documento tipo, t.documento, t.cod_prd, t.quant, t.validade, t.lote,
t.cod_barra_int, t.cod_fabricante, t.rowid
from esmovite t, esmovcad u where t.documento = u.documento and t.tipo_documento = u.tipo_documento
and u.data_mov between '01/01/2014' and '31/01/2014' and u.tipo_documento = 'TRA'/* and u.set_est = '0155'*/
and t.cod_prd = '043658' and t.lote is null
