select * from fainacad where cod_ina_unificado is null

select proced_realiz, count(proced_realiz) from suaihcad where proced_realiz in (
	select cod_ina from fainacad where cod_ina_unificado is null)
group by proced_realiz
order by count(proced_realiz) desc
