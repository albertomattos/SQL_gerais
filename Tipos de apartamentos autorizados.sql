SELECT FAPLALET.COD_TIPO,FALETCAD.DESCRICAO,
COD_CON,COD_PLA,COD_SUB
FROM FAPLALET,FALETCAD
WHERE FAPLALET.COD_TIPO=FALETCAD.COD_TIPO
and faplalet.cod_tipo = 'UN'
ORDER BY FAPLALET.COD_TIPO

select t.*, t.rowid from faplalet t where t.cod_tipo = 'UU'
