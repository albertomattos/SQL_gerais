select pk_prtiss,fk_tabela,co_tabpreco_tiss,(select descricao from tab_preco_tiss
where co_tabpreco_tiss = cod_tabpreco) descricao,pk_prtiss,  fk_cod_uni, fk_cod_con, fk_tipo_prd, dh_validade
from tb_preco_conv_tiss
where fk_cod_uni = '0001'
and fk_cod_con = '066'
and fk_tipo_prd = 'LAB'
and dh_validade = '19/10/2011'
order by fk_cod_con,fk_tabela,co_tabpreco_tiss

select * from tb_preco_conv_tiss where fk_cod_con = 066 and fk_tabela = 38
