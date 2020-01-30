select imagnexa.cod_pac, fapaccad.data_ent
from imagnexa, imagncad, fapaccad
where imagnexa.cod_agenda = imagncad.cod_agenda
and imagncad.cod_ala = "ORTO"
and imagnexa.cod_pac = fapaccad.cod_pac
and fapaccad.data_ent between "01/04/2006" and "30/04/2006"
order by fapaccad.data_ent
