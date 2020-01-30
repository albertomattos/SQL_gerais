select t.*, t.rowid from  ESPCLI_PROF_UNID t where t.cod_pro in (
select b.cod_pro from faprocad b, faespcad c, faesppro d where 
b.cod_pro = d.cod_pro and d.cod_esp = c.cod_esp
and c.cod_esp = 'CARDI'
and d.sn_principal = 'S')
--t.cod_ala = 'PSCA'
