select t.data_dig, t.data_emiss, t.nota, w.fantasia fornecedor, u.cod_prd, v.descricao produto, u.quant, u.valor, u.valor_tot,
x.descricao tipo_produto, y.descricao grupo_contabil

from esmovcad t, esmovite u, esforcad w, faprdcad v, fatipcad x, esgcncad y

where t.tipo_documento = u.tipo_documento and t.documento = u.documento
and w.cod_for = t.cod_for and u.cod_prd = v.codigo and v.tipo_prd = x.tipo_prd and v.cod_gcn = y.cod_gcn
and t.data_dig between '01/08/2014' and '02/08/2014'
and t.tipo_documento = 'COM'

group by t.nota, t.data_dig, t.data_emiss, x.descricao, u.cod_prd, v.descricao, u.quant, u.valor, u.valor_tot,
y.descricao, w.fantasia

order by 1,3
