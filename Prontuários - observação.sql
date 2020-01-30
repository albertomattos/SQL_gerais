select faprtcad.obs1, faprtcad.cod_prt, cod_pac from faprtcad, fapaccad where faprtcad.cod_prt = fapaccad.cod_prt
and faprtcad.obs1 is not null and data_ent >= '01/05/2010' and tipo_pac = 'U'
order by cod_pac

select obs1, cod_prt from faprtcad where cod_prt in(
select cod_prt from fapaccad where cod_pac in (949574,952575,951637,949543,952463,951745,951830,951094,949079,951766,946571,946472,952530,951901,952490))

select fapaccad.cod_pac, faprtcad.obs1, faprtcad.cod_prt from faprtcad, fapaccad where faprtcad.cod_prt = fapaccad.cod_prt
and fapaccad.cod_pac in(984415,984847,988524,985170,985218,985191,985171,985231,985250,985243,985211,985234,984276,986142,985943)

