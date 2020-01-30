select a.data_ent, to_char(a.hora_ent,'HH24:MI') hora, a.cod_pac, c.nome_pac, g.fantasia, b.nome_pro, h.descricao, f.valor
from fapaccad a, faprocad b, faprtcad c, famovcad d, famovprd e, famovdestino f, faconcad g, faprdcad h, faespcad i, faesppro j
where a.cod_pro = b.cod_pro and a.cod_prt = c.cod_prt and a.cod_pac = d.cod_pac and e.codigo = h.codigo
and d.comanda = e.comanda and d.tipo_comanda = e.tipo_comanda and e.sequencial = f.sequencial and a.cod_con = g.cod_con
and b.cod_pro = j.cod_pro and j.cod_esp = i.cod_esp
and j.sn_principal = 'S' and i.cod_esp = 'GINOB' and h.tipo_prd = 'CON' and a.tipo_pac = 'U'
and a.data_ent between '01/08/2013' and '31/08/2013'
and (to_char(a.hora_ent,'HH24:MI') between '19:00' and '23:59'
or to_char(a.hora_ent,'HH24:MI') between '00:00' and '06:59')
order by b.nome_pro, a.data_ent, a.hora_ent

--Relathos
SELECT FAPACCAD.DATA_ENT, FAPACCAD.COD_PAC, 
       FAPROCAD.NOME_PRO, FAPRTCAD.NOME_PAC, 
       FAMOVDESTINO.VALOR, FACONCAD.FANTASIA, 
       FAPRDCAD.DESCRICAO, 
       to_char(fapaccad.hora_ent,'HH24:MI') to_char_fapaccad_h
FROM FAPACCAD FAPACCAD, FAPROCAD FAPROCAD
     , FAPRTCAD FAPRTCAD, FAMOVCAD FAMOVCAD
     , FAMOVPRD FAMOVPRD
     , FAMOVDESTINO FAMOVDESTINO
     , FACONCAD FACONCAD, FAPRDCAD FAPRDCAD
     , FAESPPRO FAESPPRO, FAESPCAD FAESPCAD
WHERE (FAPROCAD.COD_PRO = FAPACCAD.COD_PRO) AND 
      (FAPRTCAD.COD_PRT = FAPACCAD.COD_PRT) AND 
      (FAMOVCAD.COD_PAC = FAPACCAD.COD_PAC) AND 
      (FAMOVPRD.TIPO_COMANDA = FAMOVCAD.TIPO_COMANDA)
       AND (FAMOVPRD.COMANDA = FAMOVCAD.COMANDA)
       AND 
      (FAMOVDESTINO.SEQUENCIAL = FAMOVPRD.SEQUENCIAL)
       AND (FACONCAD.COD_CON = FAPACCAD.COD_CON)
       AND (FAPRDCAD.CODIGO = FAMOVPRD.CODIGO)
       AND (FAESPPRO.COD_PRO = FAPROCAD.COD_PRO)
       AND (FAESPCAD.COD_ESP = FAESPPRO.COD_ESP)
       AND (( FAESPPRO.SN_PRINCIPAL = 'S' )
       AND ( FAESPPRO.COD_ESP = 'GINOB' )
       AND ( FAPRDCAD.TIPO_PRD = 'CON' )
       AND ( FAPACCAD.TIPO_PAC = 'U' )
       AND ( FAPACCAD.DATA_ENT BETWEEN TO_DATE('2013/08/01','YYYY/MM/DD') AND TO_DATE('2013/08/31','YYYY/MM/DD') )
       AND (    to_char(fapaccad.hora_ent,'HH24:MI') between '19:00' and '23:59' or to_char(fapaccad.hora_ent,'HH24:MI') between '00:00' and '06:59' )
      )
ORDER BY FAPROCAD.NOME_PRO, FAPACCAD.DATA_ENT, 
         FAPACCAD.HORA_ENT
