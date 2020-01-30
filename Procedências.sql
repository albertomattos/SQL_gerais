select distinct  cod_pcn, count(cod_pcn) quantidade from fapaccom group by 1
select count(*) from fapaccom where cod_pcn is null
update fapaccom set cod_pcn = "" where cod_pcn is null
