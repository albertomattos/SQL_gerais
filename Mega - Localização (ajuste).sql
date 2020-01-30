select t.*, t.rowid from mgrh.rh_hist_organograma t, mgglo.glo_organofunc u
where t.orf_in_reduzido = u.orf_in_reduzido
and u.orf_in_reduzido = '142'
--and u.orf_st_descricao like 'FAT%'

--SELECT * FROM mgglo.glo_organofunc where orf_ch_tipo = 'A'
