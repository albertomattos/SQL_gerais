select * from tb_preco_conv_tiss where fk_cod_con = '066' and co_tabpreco_tiss = '00' order by fk_tipo_prd

update tb_preco_conv_tiss set co_tabpreco_tiss = '16' where fk_cod_con = '066' and co_tabpreco_tiss = '00'
