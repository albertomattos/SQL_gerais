--select COUNT(*) from faprtcad t where t.cep_res is null
--select t.*, t.rowid from faprtcad t where t.cep_res is null AND nome_pac like 'E%'
--update faprtcad set cep_res = '69025050' where cep_res is null and nome_pac like ' %' and nome_pac NOT like 'ERI%'
--update faprtcad set data_abertu = '01/01/2009' where data_abertu is null

select t.cod_prt, t.cep_res, t.data_abertu, u.apelido, u.setor from faprtcad t, fausucad u
where t.cod_matricula_prt = u.matricula and t.cep_res = '69025050' and t.data_abertu >= '01/04/2013'
order by u.apelido desc
