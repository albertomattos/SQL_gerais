select f.cod_con, f.fantasia, c.inicio, c.termino, c.rowid from conv_unidade_guia c, faconcad f
where f.cod_con = c.cod_con
order by f.cod_con
