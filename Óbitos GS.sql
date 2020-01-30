select count(*) from fapaccad where cod_con = "004"
and cod_prt in(
	select cod_prt from faprtcad where data_obito is not null)

select cod_prt, nome_pac, nascimento, data_obito from faprtcad where data_obito is not null and cod_prt in (
	select distinct cod_prt from fapaccad where cod_con = "004" and cod_pla in ('04','03','05'))
order by nome_pac
