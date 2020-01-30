select a.cod_pac, a.cod_ala, d.descricao, a.tipo_pac, a.data_ent, a.hora_ent, e.apelido
from fapaccad a, fapaccom b, faalacad d, fausucad e where a.cod_pac = b.cod_pac and a.cod_ala = d.cod_ala
and e.matricula = a.cod_matricula and a.data_ent >= "07/11/2008"
and tipo_pac = "E" and a.cod_ala <> "DELF"
union
select a.cod_pac, a.cod_ala, d.descricao, a.tipo_pac, a.data_ent, a.hora_ent, e.apelido
from fapaccad a, fapaccom b, faalacad d, fausucad e where a.cod_pac = b.cod_pac and a.cod_ala = d.cod_ala
and e.matricula = a.cod_matricula and a.data_ent >= "07/11/2008"
and tipo_pac = "E" and e.apelido not in ("ROSELMA","DAIANE","LEILA CAROL","MARCIA DIAS","SANDRO","MIRALVO","ELIANE CANDIDA")
union
select a.cod_pac, a.cod_ala, d.descricao, a.tipo_pac, a.data_ent, a.hora_ent, e.apelido
from fapaccad a, fapaccom b, faalacad d, fausucad e where a.cod_pac = b.cod_pac and a.cod_ala = d.cod_ala
and e.matricula = a.cod_matricula and a.data_ent >= "07/11/2008"
and a.tipo_pac = "U" and a.cod_ala not in ("PEDI","CLIM","GINE","ORTO","CGER")
union
select a.cod_pac, a.cod_ala, d.descricao, a.tipo_pac, a.data_ent, a.hora_ent, e.apelido
from fapaccad a, fapaccom b, faalacad d, fausucad e where a.cod_pac = b.cod_pac and a.cod_ala = d.cod_ala
and e.matricula = a.cod_matricula and a.data_ent >= "07/11/2008"
and (a.tipo_pac = "A" and a.cod_ala <> "ANES" and e.apelido not in ("PATRICIA","ADAIAS"))
and (a.cod_ala <> "MEOC" and e.apelido <> "IVANIZE")
and (a.cod_ala <> "DELF" and e.apelido not in ("ROSELMA","DAIANE","LEILA CAROL","MARCIA DIAS","SANDRO","MIRALVO","ELIANE CANDIDA"))
union
select a.cod_pac, a.cod_ala, d.descricao, a.tipo_pac, a.data_ent, a.hora_ent, e.apelido
from fapaccad a, fapaccom b, faalacad d, fausucad e where a.cod_pac = b.cod_pac and a.cod_ala = d.cod_ala
and e.matricula = a.cod_matricula and a.data_ent >= "07/11/2008"
and a.tipo_pac = "I" and a.cod_ala not in ("UA2","UA3","UA4","UA5","UTIA","UTIN","UCO","UTIP")
order by a.tipo_pac, a.cod_ala, e.apelido, a.data_ent
