select cod_pac, tipo_pac, data_ent, num_guia from fapaccad where cod_con = "010" and data_ent >= "01/06/2008"
order by tipo_pac

select * from faguicad where cod_pac = "G354122"
update famovprd set cod_guia='409861' where cod_guia in (select cod_guia from faguicad where cod_pac='G354122');
update immovprd set cod_guia = "409857" where cod_guia = "408576"

select * from fasencad where cod_guia in (select cod_guia from faguicad where cod_pac = "G556610")
update famovprd set cod_sen = "76368" where cod_guia in (select cod_guia from faguicad where cod_pac='G510869');

/*select remessa, num_guia, a.cod_pac, tipo_pac from fapaccad a, fafatcad b where a.cod_pac = b.cod_pac
and b.remessa in ('049796','049765','049797','050195','050177','050187')
order by tipo_pac, remessa

select a.cod_pac from fapaccad a, fafatcad b where a.cod_pac = b.cod_pac
and b.remessa in ('049796','049765','049797','050195','050177','050187')
order by tipo_pac, remessa

select cod_guia, cod_pac from faguicad where num_guia in
	(select num_guia from fapaccad where cod_pac in (
		select a.cod_pac from fapaccad a, fafatcad b where a.cod_pac = b.cod_pac
		and b.remessa in ('049796','049765','049797','050195','050177','050187')
		)) SELECT * FROM FAMOVPRD

update famovprd set cod_guia = XXXX
select cod_guia from famovprd where cod_guia in (
	select cod_guia from faguicad where cod_pac in(
		select a.cod_pac from fapaccad a, fafatcad b where a.cod_pac = b.cod_pac
		and b.remessa in ('049796','049765','049797','050195','050177','050187')
		))

unload to guia.sql delimiter";"
select "update famovprd set cod_guia='"||cod_guia from faguicad where num_guia in
	(select num_guia from fapaccad where cod_pac in (
		select a.cod_pac from fapaccad a, fafatcad b where a.cod_pac = b.cod_pac
		and b.remessa in ('049796','049765','049797','050195','050177','050187')
        ))||"' where cod_pac ="||select cod_pac from faguicad where num_guia in
	(select num_guia from fapaccad where cod_pac in (
		select a.cod_pac from fapaccad a, fafatcad b where a.cod_pac = b.cod_pac
		and b.remessa in ('049796','049765','049797','050195','050177','050187')
		))

update famovprd set cod_guia='408340' where cod_guia in (select cod_guia from faguicad where cod_pac='G381001');
update famovprd set cod_guia='408417' where cod_guia in (select cod_guia from faguicad where cod_pac='G495661');
update famovprd set cod_guia='408334' where cod_guia in (select cod_guia from faguicad where cod_pac='G378676');
update famovprd set cod_guia='408336' where cod_guia in (select cod_guia from faguicad where cod_pac='G468790');
update famovprd set cod_guia='408337' where cod_guia in (select cod_guia from faguicad where cod_pac='G475580');
update famovprd set cod_guia='408418' where cod_guia in (select cod_guia from faguicad where cod_pac='G421920');
update famovprd set cod_guia='408419' where cod_guia in (select cod_guia from faguicad where cod_pac='G425705');
update famovprd set cod_guia='408423' where cod_guia in (select cod_guia from faguicad where cod_pac='G500345');
update famovprd set cod_guia='408425' where cod_guia in (select cod_guia from faguicad where cod_pac='G499343');
update famovprd set cod_guia='408427' where cod_guia in (select cod_guia from faguicad where cod_pac='G488215');*/
