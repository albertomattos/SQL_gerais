select t.cla_in_reduzido, t.cla_st_extenso, t.cla_st_descricao, u.int_st_campoext, t.cla_ch_natureza, t.*, t.rowid
from mgfin.fin_classe t, mgint.int_deparaclasse u
where t.cla_in_reduzido = u.cla_in_reduzido
and t.cla_ch_anasin = 'A'
order by 1
select * from esgcncad
select * from fatipcad
