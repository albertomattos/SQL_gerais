select t.cod_prd, u.descricao, u.tipo_prd, t.est_atu, t.localizacao from esestcad t, faprdcad u
where t.cod_prd = u.codigo
and t.cod_set = '0302'
