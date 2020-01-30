select t.*, t.rowid, u.descricao from fapricad t, famodcad u where t.cod_mod = u.cod_mod and t.sistema = u.sistema
--and t.cod_grupo = 'ALMLI' order by t.cod_mod
--and t.cod_mod like '%ESPRD%'
AND T.cod_mod in ('FAPRD','ESPRD')
and t.sistema = 'EST'
--and cod_grupo in ('AUDIT')
--and t.cod_grupo in ('FARN1', 'FARN2','FARRE')
and t.privilegio > 1
--order by privilegio desc
--select * from fapricad where cod_mod = 'FAPAC' and privilegio >= 4 and cod_grupo not in ('WPD','GTI', 'GIT', 'INFO') order by sistema, cod_grupo
--update fapricad set privilegio = "0" where cod_mod = "WPLOG" and privilegio <> "9"
/*
select distinct a.cod_grupo, c.nome, c.apelido, c.setor from fapricad a, faususis b, fausucad c
where a.cod_grupo = b.cod_grupo and b.matricula = c.matricula
and a.sistema = b.sistema and c.ind_usuario_ativo = 'S'
and a.sistema = 'DIA' and a.cod_mod like 'DIAFP%'*/
and t.cod_grupo not in ('WPD','TISUP', 'TI')
--order by t.cod_mod
order by 1,2,3
/*
select distinct c.nome, c.apelido, c.setor, a.cod_grupo from fapricad a, faususis b, fausucad c
where a.cod_grupo = b.cod_grupo and b.matricula = c.matricula
and a.sistema = b.sistema and c.ind_usuario_ativo = 'S'
and a.sistema = 'EST' and a.cod_grupo in ('CAD','FARGE','ALMGE','SUPGE','CADP')

*/
