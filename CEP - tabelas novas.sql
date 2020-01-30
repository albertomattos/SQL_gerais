select t.*, t.rowid from tb_cep t where t.co_cep = '69023000'
select t.*, t.rowid from tb_logradouro t where t.fk_cep = '29218' --888668 994235 54746
select max(t.pk_cep) from tb_cep t
select max(t.pk_lograd) from tb_logradouro t
