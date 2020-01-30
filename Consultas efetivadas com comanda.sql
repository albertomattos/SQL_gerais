select imagncad.cod_agenda, imagnexa.cod_pac, fapaccad.data_ent, fapaccad.tipo_pac,
imagncad.cod_uni, fapaccad.cod_con, fapaccad.cod_pla
from imagnexa, imagncad, fapaccad
where imagnexa.cod_agenda = imagncad.cod_agenda
--and imagncad.cod_uni = "BARR"
and imagnexa.cod_pac = fapaccad.cod_pac
and fapaccad.data_ent between '01/06/2015' and '30/06/2015'
order by imagnexa.cod_pac
