select tip_atend,cod_pac from fapaccad where cod_pac in (select cod_pac from fafatcad where remessa = "051649")
and tip_atend = "M"

select * from fapaccom where cod_pac in (select cod_pac from fapaccad where cod_mae = "G775620")

update fapaccom set num_atestado_nasc = "450840907" where num_atestado_nasc = "450840819"

update fapaccom set num_atestado_nasc = replace (num_atestado_nasc,"-","") where num_atestado_nasc like "%-%"
