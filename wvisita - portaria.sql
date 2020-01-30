--Visitas de acompanhantes:
SELECT a.DATA_INI, d.DESCRICAO, e.COD_PAC, c.NOME, b.COD_VISITANTE, f.NOME_PAC, e.leito
FROM VISITA a, VISITA_VISITANTE b, VISITANTE c, TIPO_VISITA d, FAPACCAD e, FAPRTCAD f
WHERE b.COD_VISITA = a.COD_VISITA AND c.COD_VISITANTE = b.COD_VISITANTE AND d.COD_TIPO_VISITA = a.COD_TIPO_VISITA
AND e.COD_PAC = a.COD_PAC AND f.COD_PRT = e.COD_PRT and a.data_ini between '21/09/2017' and '22/09/2017'

--Clientes em geral:
SELECT a.DATA_INI, d.DESCRICAO, c.NOME FROM VISITA a, VISITA_VISITANTE b, VISITANTE c, TIPO_VISITA d
WHERE b.COD_VISITA = a.COD_VISITA AND c.COD_VISITANTE = b.COD_VISITANTE AND d.COD_TIPO_VISITA = a.COD_TIPO_VISITA
and a.data_ini between '21/09/2017' and '22/09/2017'

SELECT VISITA.DATA_INI, TIPO_VISITA.DESCRICAO, 
       FAPACCAD.COD_PAC, VISITANTE.NOME, 
       FAPRTCAD.NOME_PAC, FAPACCAD.LEITO
FROM VISITA VISITA
     , VISITA_VISITANTE VISITA_VISITANTE
     , VISITANTE VISITANTE
     , TIPO_VISITA TIPO_VISITA, FAPACCAD FAPACCAD
     , FAPRTCAD FAPRTCAD
WHERE 
      (VISITA_VISITANTE.COD_VISITA = VISITA.COD_VISITA)
       AND 
      (VISITANTE.COD_VISITANTE = VISITA_VISITANTE.COD_VISITANTE)
       AND 
      (TIPO_VISITA.COD_TIPO_VISITA = VISITA.COD_TIPO_VISITA)
       AND (FAPACCAD.COD_PAC = VISITA.COD_PAC)
       AND (FAPRTCAD.COD_PRT = FAPACCAD.COD_PRT)
       AND (( VISITA_VISITANTE.COD_VISITA = 4066 ))