select a.codigo, a.cod_amb, a.cod_cbhpm, a.descricao_comp, a.duracao, a.rowid froM faprdcad a
where A.TIPO_PRD = 'PRO' AND descricao like '%VARICO%%'
