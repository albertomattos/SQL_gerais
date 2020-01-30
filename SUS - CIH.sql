select * from faprccad where cod_pac in (select cod_pac from fapaccad where cod_con = "350") and prev_real = "R"

select * from faprccad where cod_pac in (select cod_pac  from fapaccad where cod_con = "350") and COD_SET = ""

--select cod_ala, cod_pac from fapaccad where cod_con = "350" and tipo_pac <> "U"

--update faprccad set cod_set = "5088" where cod_pac in (select cod_pac from fapaccad where cod_con = "350" and tipo_pac <> "U") and prev_real = "R"

select
"update faprccad set cod_set = """||cod_set||""" where cod_pac = """||cod_pac||""" and prev_real = ""R"";"
from faprccad where cod_pac in (select cod_pac  from fapaccad where cod_con = "350") and prev_real = "R"
