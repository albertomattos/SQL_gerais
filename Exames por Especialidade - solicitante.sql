SELECT b.cod_pro, b.nome_pro,count(f.descricao)
FROM FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f, faesppro g, faespcad h
     WHERE b.COD_PRO = a.COD_PRO_SA AND c.COD_PAC = a.COD_PAC AND d.COMANDA = c.COMANDA AND d.TIPO_COMANDA = c.TIPO_COMANDA
     AND e.CODIGO = d.COD_PRD AND f.TIPO_PRD = e.TIPO_PRD and b.cod_pro = g.cod_pro and g.cod_esp = h.cod_esp
     AND a.DATA_ENT BETWEEN TO_DATE('2013/06/01','YYYY/MM/DD') AND TO_DATE('2013/06/30','YYYY/MM/DD')
     AND c.COD_UNI = '0001' and g.sn_principal = 'S' and e.tipo_prd <> 'CON'
GROUP BY b.cod_pro, b.nome_pro
ORDER BY b.nome_pro
