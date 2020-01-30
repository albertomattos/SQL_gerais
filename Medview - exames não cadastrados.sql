/*SELECT distinct d.tipo_prd
FROM ITEM_GRUPO_EXA a, tipo_grupo_exames b, grupo_exames c, faprdcad d
where a.cod_grupo_exa = c.cod_grupo_exa and b.cod_tipo_grupo_exa = c.cod_tipo_grupo_exa and a.codigo = d.codigo
*/
select t.codigo, t.descricao, t.tipo_prd from faprdcad t where t.tipo_prd in ('END','EXA','LAB','MEN','RAD','REM','TOM','USG')
and t.bloqueado = 'N' and t.codigo not in
(SELECT a.CODIGO
FROM ITEM_GRUPO_EXA a, tipo_grupo_exames b, grupo_exames c, faprdcad d
where a.cod_grupo_exa = c.cod_grupo_exa and b.cod_tipo_grupo_exa = c.cod_tipo_grupo_exa and a.codigo = d.codigo)
