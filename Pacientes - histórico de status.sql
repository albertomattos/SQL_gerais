--Para excluir um paciente, tem que escluir desta tabela
select t.*, t.rowid from tb_hist_stat_atend t where t.fk_fa_pac = '8463301'

--select t.*, t.rowid from hist_status_pac_ur t where t.cod_pac = '8463301'
