select t.documento, T.NOTA, y.documento, t.data_emiss, w.fantasia, x.valor_tot, y.data_venci
from esmovcad t, esmovite u, esforcad w, cpmovcad x, cpmovite y
where t.tipo_documento = u.tipo_documento and t.documento = u.documento
and w.cod_for = t.cod_for
and t.documento = x.documento_ori and t.tipo_documento = x.tipo_doc_ori
and x.lancamento = y.lancamento and t.nota = y.documento
and t.data_emiss between '01/08/2014' and '02/08/2014'
and t.tipo_documento = 'COM'
group by t.documento, T.NOTA, y.documento, t.data_emiss, w.fantasia, x.valor_tot, y.data_venci
order by 5

--select * from cpmovite where documento = '00000000784'
