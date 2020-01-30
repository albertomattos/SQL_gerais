select distinct bai_res, count(bai_res) from faprtcad where cod_prt in
(select cod_prt from fapaccad where data_ent between "01/01/2009" and "31/12/2009" and tipo_pac = "U")
group by bai_res
