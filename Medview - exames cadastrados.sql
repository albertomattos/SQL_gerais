SELECT a.CODIGO, d.descricao, d.tipo_prd, b.dsc_tipo_grupo_exa, c.dsc_grupo_exa
FROM ITEM_GRUPO_EXA a, tipo_grupo_exames b, grupo_exames c, faprdcad d
where a.cod_grupo_exa = c.cod_grupo_exa and b.cod_tipo_grupo_exa = c.cod_tipo_grupo_exa and a.codigo = d.codigo
