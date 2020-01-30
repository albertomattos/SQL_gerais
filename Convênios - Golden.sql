select cod_pac, fapaccad.matricula, faconcad.fantasia, num_guia, fapaccad.senha, data_ent,
hora_ent, tipo_pac, apelido, fausucad.setor
from fapaccad, fausucad, faconcad
where fapaccad.cod_matricula = fausucad.matricula
and fapaccad.cod_con = faconcad.cod_con
and data_ent = "18/07/2006"
and hora_ent >= "09:00"
and (fapaccad.cod_con = "001" or fapaccad.cod_con = "002" or fapaccad.cod_con = "004")
order by data_ent, hora_ent
