select nome_pro,crm,funcionario,cod_profissao,fone_celular,fone_res,fone_tra from faprocad where cod_pro in (select cod_pro from faesppro
	where cod_esp in ('CBMFA','CICAR','CIMAO','CIONC','CIPED','CIPLA','CIRAD','CIRCP','CIRGE','CIRMA','CITOR','CIVAS',
	'MICRO','NEUCI','PEDIC')) and inativo = "N" order by nome_pro
