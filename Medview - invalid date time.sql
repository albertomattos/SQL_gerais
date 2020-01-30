select t.*, t.rowid from mvprsitm t where cod_pac = '3606615'
--select t.*, t.rowid from mvprsitm t where dh_fim_med_uso is not null order by dh_fim_med_uso
select t.*, t.rowid from mvprsitm t where cod_pac = '2208625'

select t.*, t.rowid from mvprsitm t
where data_hora_prev_fim is not null
and data_hora_ini >= '20/02/2012'
order by data_hora_prev_fim
