select imagnexa.cod_pac, fapaccad.data_ent, imagncad.cod_uni
from imagnexa, imagncad, fapaccad
where imagnexa.cod_agenda = imagncad.cod_agenda
and imagnexa.cod_pac = fapaccad.cod_pac
and fapaccad.data_ent between '01/01/2017' and '31/01/2017'
