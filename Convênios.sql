select cod_pac, fapaccad.matricula, faconcad.fantasia, fapaccad.cod_con, num_guia, fapaccad.senha, data_ent,
hora_ent, tipo_pac, apelido, fausucad.setor
from fapaccad, fausucad, faconcad
where fapaccad.cod_matricula = fausucad.matricula
and fapaccad.cod_con = faconcad.cod_con
and data_ent > "02/10/2006"
and tipo_pac <> "I"
--and hora_ent >= "16:00"
and (fapaccad.cod_con = "056" or fapaccad.cod_con = "018" or fapaccad.cod_con = "079"
     or fapaccad.cod_con = "032" or fapaccad.cod_con = "075" or fapaccad.cod_con = "098")
order by fapaccad.cod_con, data_ent, hora_ent
