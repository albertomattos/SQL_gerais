select cod_pac, cod_pla, tipo_pac, data_ent, fapaccad.matricula, num_guia, fapaccad.senha, apelido
from fapaccad, fausucad
where cod_matricula = fausucad.matricula and cod_con = "032" and data_ent >= "01/04/2006" and tipo_pac = "E"
order by data_ent
