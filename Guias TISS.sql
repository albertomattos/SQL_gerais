select fapaccad.cod_pac, tip_atend, fatgucad.descricao, cod_ala, fapaccad.num_guia, faguicad.num_guia, faguicad.val_guia,
faguicad.data_emissao, fapaccad.data_ent
from fapaccad, faguicad, fatgucad
where fapaccad.cod_pac = faguicad.cod_pac
and faguicad.tipo_guia = fatgucad.tipo_guia
and data_ent = "23/04/2007"
and tipo_pac = "I"
