select t.*, t.rowid from tb_triagem_fila t
update tb_triagem_fila set nu_prox_senha = '1' where sn_zera_novo_dia = 'N'
