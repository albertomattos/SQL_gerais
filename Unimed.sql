select cod_pac, fapaccad.matricula, cod_con, num_guia, fapaccad.senha, data_ent,
hora_ent, tipo_pac, apelido, fausucad.setor
from fapaccad, fausucad
where fapaccad.cod_matricula = fausucad.matricula
and data_ent >= "12/07/2006"
--and hora_ent >= "10:00"
and cod_con = "079"
