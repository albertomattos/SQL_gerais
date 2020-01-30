select * from faccgcad where tipo_prd = "ESP" order by acres_intand cod_con = "001"
update faccgcad set acres_int = "-30.0", acres_ext = "-30.0", acres_urg = "-30.0", acres_amb = "-30.0"
where tipo_prd = "ESP" and cod_con = "041"

select faccgcad.*, fantasia from faccgcad, faconcad where faccgcad.cod_con = faconcad.cod_con
and tipo_prd = "ESP" and ind_inativo = "0" order by acres_int

select * from faconcad
