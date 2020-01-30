select t.cod_pac, t.data_ent, u.cod_set, t.rowid from fapaccad t, fapaccom u
where t.cod_pac = u.cod_pac
and u.cod_set not in ('0118','0026','0011')
and t.tipo_pac = 'U'
order by 2 desc

--update fapaccom set cod_set = '0118' where cod_set <> '0118' and cod_pac in (select cod_pac from fapaccad where tipo_pac = 'U')
