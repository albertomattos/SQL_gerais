select imagnexa.cod_pac, fapaccad.data_ent, imagncad.cod_uni
from imagnexa, imagncad, fapaccad
where imagnexa.cod_agenda = imagncad.cod_agenda
and imagncad.cod_uni = "BARR"
and imagnexa.cod_pac = fapaccad.cod_pac
and fapaccad.data_ent between "01/04/2006" and "10/04/2006"
