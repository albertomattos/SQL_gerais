SELECT fausucad.nome, fausucad.matricula, /*faprdcad.tipo_prd, */faprdcad.descricao, imagnexa.cod_agenda, imagncad.data, imagnexa.cod_pac
FROM imagnexa imagnexa, imagncad imagncad, faususis faususis, fausucad fausucad, faprocad faprocad, FAPRDCAD FAPRDCAD, FATIPCAD FATIPCAD
WHERE (imagncad.cod_agenda = imagnexa.cod_agenda)
       AND (faususis.matricula = imagnexa.matricula)
       AND (fausucad.matricula = faususis.matricula)
       AND (faprocad.cod_pro = imagncad.cod_pro)
       AND (FAPRDCAD.CODIGO = imagnexa.COD_PRD)
       --AND (FATIPCAD.TIPO_PRD = FAPRDCAD.TIPO_PRD)
       AND imagnexa.dthora_marcacao BETWEEN TO_DATE('2015/09/01 00:00:00','YYYY/MM/DD HH24:MI:SS')
       AND TO_DATE('2015/09/30 23:59:59','YYYY/MM/DD HH24:MI:SS')
       --AND (FAPRDCAD.TIPO_PRD <> 'CON')
       and fausucad.matricula = '3781' --and imagnexa.cod_pac = 'I703638'
       and (imagnexa.cod_pac is not null and imagnexa.cod_pac <> ' ')
GROUP BY fausucad.NOME, fausucad.matricula,/* faprdcad.tipo_prd,*/ faprdcad.descricao, imagnexa.cod_agenda, imagncad.data, imagnexa.cod_pac
ORDER BY fausucad.nome--, faprdcad.tipo_prd
