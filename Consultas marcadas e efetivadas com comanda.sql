select imagncad.cod_agenda, imagnexa.cod_pac, imagncad.cod_uni, imagncad.data, imagnpac.cod_con, imagnpac.cod_pla
from imagncad, imagnexa, imagnpac
where imagnpac.cod_prt_prov = imagnexa.cod_prt_prov
and imagncad.cod_agenda = imagnexa.cod_agenda
and (imagnexa.cod_pac is not null and imagnexa.cod_pac <> "")
and imagncad.data between "01/04/2006" and "01/04/2006"
order by imagnexa.cod_pac
