select t.*, u.ds_termin, u.no_estacao, t.rowid from tb_terminal t, tb_totem u
where t.fk_ctotem = u.pk_ctotem
