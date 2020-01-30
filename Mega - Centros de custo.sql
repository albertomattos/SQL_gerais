select t.cus_in_reduzido, t.cus_st_extenso, t.cus_st_descricao, t.cus_dt_limite, t.cus_ch_ativado
select *
from mgcon.con_centro_custo t
where t.cus_ch_ativado = 'S'
and t.cus_ch_tipo_conta = 'A'
and t.cus_dt_limite is null
order by 3
