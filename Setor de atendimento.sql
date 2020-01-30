select cod_pac, cod_con, cod_matricula, cod_sistema, cod_esp, data_ent
from fapaccad where data_ent >= "01/01/2008" and tipo_pac = "A"
and cod_pac in (select cod_pac from fapaccom where cod_set = "0156")
and cod_matricula in ("506","140688")

update fapaccom set cod_set = "0156" where cod_set = "3418" and
cod_pac in (select cod_pac from fapaccad where data_ent >= "01/01/2008" and tipo_pac = "A"
and cod_matricula in ("506","140688"))
