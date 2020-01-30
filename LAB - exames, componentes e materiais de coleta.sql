--select a.codigo, a.descricao exame, b.descricao bancada, c.cod_com, d.descricao componente,
--f.descricao mat_coleta, e.cod_mat_coleta, e.cod_rec_coleta, f.rowid
select a.codigo, a.descricao exame, b.descricao bancada, c.cod_com,
f.descricao mat_coleta, e.cod_rec_coleta, f.rowid
from faprdcad a, lbbancad b, lbexacom c, lbcomcad d, lbmatcom e, lbmatcad f
where a.cod_bancada = b.cod_bancada(+)
and a.codigo = c.cod_prd and c.cod_com = d.cod_com
and d.cod_com = e.cod_com and e.cod_mat_coleta = f.cod_mat_coleta
and a.tipo_prd = 'LAB'
order by 2, 5
