select t.*, t.rowid from admedview.mvprsitm t
where data_hora_prev_fim is not null
and data_hora_ini >= '15/07/2011'
order by data_hora_prev_fim
