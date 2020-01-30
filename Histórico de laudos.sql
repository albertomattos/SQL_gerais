select t.*, t.rowid from immovcad t where t.comanda in (select t.comanda from immovlau t where t.pk_movlau = '13297')

select t.*, t.rowid from tb_hist_lau_dia t order by 2
