select round((round(sum(t.data_hora_fim-t.data_hora_ini)/0.0416667,0))/1680*100,2) ocupacao
from blproc_cirurgico t where t.data_hora_ini >= '01/07/2017'
and t.data_hora_fim <= '01/08/2017' and t.proc_principal = 'S'
and t.cd_ciru_realizada in (select cd_ciru_realizada from blstat_ciru_rezd
where cod_sac in ('1','2','3','4','5','6','7','8','SP01','SP02'))

select round((round(sum(t.data_hora_fim-t.data_hora_ini)/0.0416667,0))*60,2) ocupacao
from blproc_cirurgico t where t.data_hora_ini >= '01/07/2017'
and t.data_hora_fim <= '01/08/2017' and t.proc_principal = 'S'
and t.cd_ciru_realizada in (select cd_ciru_realizada from blstat_ciru_rezd
where cod_sac in ('1','2','3','4','5','6','7','8','SP01','SP02'))

