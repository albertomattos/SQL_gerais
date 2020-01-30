--select * from faconcad
select distinct faconcad.fantasia, faccgcad.tipo_prd, faccgcad.tab_int
from faccgcad, faconcad
where faconcad.cod_con = faccgcad.cod_con and faccgcad.tipo_prd = "DES" and faconcad.ind_inativo = "0"

