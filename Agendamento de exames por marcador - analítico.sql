SELECT distinct imagnpac.nome_pac, imagncad.cod_agenda, imagncad.data, faprdcad.descricao, imagnexa.dthora_marcacao
FROM imagnexa imagnexa, imagncad imagncad, faususis faususis, fausucad fausucad, faprocad faprocad, FAPRDCAD FAPRDCAD,
imagnpac imagnpac
WHERE (imagncad.cod_agenda = imagnexa.cod_agenda) AND (faususis.matricula = imagnexa.matricula)
       AND (fausucad.matricula = faususis.matricula) and imagnexa.cod_prt_prov = imagnpac.cod_prt_prov
       AND (faprocad.cod_pro = imagncad.cod_pro) AND (FAPRDCAD.CODIGO = imagnexa.COD_PRD)
       and fausucad.matricula = '3633' and imagncad.data between '01/11/2015' and '31/12/2015'
       AND (FAPRDCAD.TIPO_PRD <> 'CON') and imagnpac.nome_pac like 'ANTONIA LIMA%'
GROUP BY imagnpac.nome_pac, imagncad.cod_agenda, imagncad.data, faprdcad.descricao, imagnexa.dthora_marcacao
order by 1,3
