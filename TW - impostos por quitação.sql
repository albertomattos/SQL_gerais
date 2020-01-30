SELECT DISTINCT FAPRDCAD.CODIGO Codigo,(FAPRDCAD.DESCRICAO) Produto,
       EXTRACT(MONTH FROM quitacao_produto.data_baixa) ||'/'|| EXTRACT (YEAR FROM quitacao_produto.data_baixa) MesAno,
       --SUM(FAFATPRD.QUANT) Qtd,
       SUM(quitacao_produto.valor_pago) Valor,
       DECODE (FAPRDCAD.COD_ABRAMGE,'1','N','0','S') Impostos  
FROM   quitacao_produto, FAPRDCAD
WHERE  quitacao_produto.cod_produto = FAPRDCAD.CODIGO 
AND    EXTRACT (YEAR FROM quitacao_produto.data_baixa) BETWEEN 2015 AND 2015
AND    EXTRACT (MONTH FROM quitacao_produto.data_baixa) BETWEEN 05 AND 05
AND    EXTRACT (DAY FROM quitacao_produto.data_baixa) BETWEEN 01 AND 31
AND    FAPRDCAD.TIPO_PRD = 'MED'
AND    FAPRDCAD.COD_ABRAMGE = '0'--1 é Não isento. 0 é isento.
GROUP BY(FAPRDCAD.CODIGO,FAPRDCAD.DESCRICAO,EXTRACT(MONTH FROM quitacao_produto.data_baixa) ||'/'||
EXTRACT (YEAR FROM quitacao_produto.data_baixa),FAPRDCAD.COD_ABRAMGE);
