select x.natureza, count(*) from (
select h.natureza
from blciru_realizada a, fapaccad d, blproc_cirurgico f, faconcad h
where d.cod_pac = a.cod_pac
and d.cod_con = h.cod_con and a.cd_ciru_realizada = f.cd_ciru_realizada
and f.data_hora_ini between '26/04/2016' and '27/04/2016'
group by a.cod_pac, h.natureza
order by h.natureza
)x group by x.natureza
