select t.cod_pac, u.data_ent, v.nome_pac, w.nome_pro
from fapaccom t, fapaccad u, faprtcad v, faprocad w
where t.cod_pac = u.cod_pac and u.cod_prt = v.cod_prt and u.cod_pro_sa = w.cod_pro
and t.origem = 'V' and u.data_ent between '01/07/2013' and '31/07/2013'
and u.tipo_pac = 'A'

SELECT FAPACCAD.COD_PAC,FAPACCAD.TIPO_PAC,FAPACCAD.DATA_ENT,FAPACCAD.COD_CON,FAPACCAD.COD_PLA,FAPACCAD.DATA_ALTA,
 to_char(FAPACCAD.HORA_ENT,'HH24:MI') HORA_ENT,to_char(FAPACCAD.HORA_ALTA,'HH24:MI') HORA_ALTA,FAPRTCAD.NOME_PAC,
       ( SELECT FAAPTCAD.COD_SET FROM FAAPTCAD, FALEICAD WHERE FALEICAD.LEITO = FAPACCAD.LEITO
            AND FALEICAD.COD_APT = FAAPTCAD.COD_APT ) AS SETOR,
       ( SELECT FANTASIA FROM FACONCAD WHERE COD_CON = FAPACCAD.COD_CON ) AS FANTASIA,
       ( SELECT NOME_PRO FROM FAPROCAD WHERE COD_PRO = FAPACCAD.COD_PRO ) AS NOME_PRO
  FROM FAPACCAD, FAPRTCAD, fapaccom
 WHERE FAPACCAD.COD_PRT = FAPRTCAD.COD_PRT and fapaccad.cod_pac = fapaccom.cod_pac
 AND FAPACCAD.COD_UNI IN ('0001')   AND FAPACCAD.DATA_ENT >= '01/07/2013'
   AND FAPACCAD.DATA_ENT <= '31/07/2013'   AND FAPACCAD.TIPO_PAC IN ('A','@')
   AND NOT EXISTS ( SELECT COD_PAC
                      FROM FAMOVCAD
                     WHERE FAMOVCAD.COD_PAC = FAPACCAD.COD_PAC )
 and fapaccom.origem <> 'V'
 ORDER BY FAPACCAD.TIPO_PAC, FAPACCAD.COD_PAC
