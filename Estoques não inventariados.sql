/*select t.cod_set, u.data_hora_inc, t.cod_prd, v.tipo_prd, v.descricao, t.est_atu from esestcad t, esprod_set_lote u, faprdcad v
where t.cod_set = u.cod_set and t.cod_prd = u.cod_prd and t.cod_prd = v.codigo
and t.est_atu <> 0
and v.tipo_prd in ('MED', 'DES', 'FIO', 'FNU', 'MAT', 'OPM')
and t.cod_set = '0158'
*/
select a.cod_prd, b.descricao, a.est_atu from esestcad a, faprdcad b
where a.cod_prd = b.codigo and a.cod_set = '0158' and a.est_atu <> 0 and a.cod_prd not in
(select cod_prd from esprod_set_lote where cod_set = '0158')

select a.cod_prd, b.descricao, a.est_atu from esestcad a, faprdcad b
where a.cod_prd = b.codigo and a.cod_set = '0096' and a.cod_prd not in
(select cod_prd from esprod_set_lote where cod_set = '0096')

select a.*, a.rowid from esestcad a, faprdcad b
where a.cod_prd = b.codigo and a.cod_set = '0096' and a.est_atu = 0 and a.cod_prd not in
(select cod_prd from esprod_set_lote where cod_set = '0096')
