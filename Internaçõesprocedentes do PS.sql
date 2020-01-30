/*SELECT COUNT(*) COUNT_2
FROM FAPACCAD FAPACCAD, FAESPCAD FAESPCAD, fapaccom fapaccom
WHERE (FAESPCAD.COD_ESP = FAPACCAD.COD_ESP) AND 
fapaccad.cod_pac = fapaccom.cod_pac and
(
      ( FAPACCAD.DATA_ENT BETWEEN TO_DATE('2015/06/01','YYYY/MM/DD') AND TO_DATE('2015/06/30','YYYY/MM/DD') )
       AND ( FAPACCOM.COD_PCN = 'PS' )       AND ( FAPACCAD.TIPO_PAC = 'I' ))
*/
select c.cod_set, c.descricao
from fapaccad a, fapaccom b, fasetcad c
where b.cod_pac = a.cod_pac and b.cod_set = c.cod_set
and a.DATA_ENT BETWEEN TO_DATE('2015/06/01','YYYY/MM/DD') AND TO_DATE('2015/06/30','YYYY/MM/DD')and b.cod_pcn = 'PS'
and a.tipo_pac = 'I'
and c.cod_set = '0135'
and c.cod_set in ('0025','0125','0128','0047')
