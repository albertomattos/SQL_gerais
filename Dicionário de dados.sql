--select * from rel_dic_campo where upper(nome_campo) = 'ALTA_MED_MEDVIEW' order by nome_tabela
/*select t.*, t.rowid from rel_dic_campo t where t.nome_tabela like 'TM_HIS_REV_CONTA%'
select t.*, t.rowid from rel_dic_campo t where upper(t.apelido_campo) like '%MEDICO_ALTA_MEDICA%'*/


select t.*, t.rowid from rel_dic_tabela t where t.nome_tabela like 'FAPRDCAD%'
