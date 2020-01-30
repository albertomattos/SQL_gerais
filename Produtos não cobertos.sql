SELECT DISTINCT faprecad.validade, fapaccad.cod_prt, faprtcad.nome_pac, fapaccad.cod_pac, fapaccad.cod_con, faconcad.fantasia, fapaccad.cod_pla, 
                faplacad.nome_plano, faccicad.codigo, faprdcad.descricao, fatipcad.descricao descricao_2, faprecad.valor
FROM fapaccad fapaccad, faprtcad faprtcad, faconcad faconcad, faplacad faplacad, faccicad faccicad, faprdcad faprdcad
     , fatipcad fatipcad, faprecad faprecad
WHERE (faprtcad.cod_prt = fapaccad.cod_prt) AND (faconcad.cod_con = fapaccad.cod_con) AND 
      (faplacad.cod_pla = fapaccad.cod_pla) AND (faplacad.cod_con = fapaccad.cod_con)
       AND faccicad.cod_con = fapaccad.cod_con AND faccicad.cod_pla = fapaccad.cod_pla
       AND faprdcad.codigo = faccicad.codigo AND fatipcad.tipo_prd = faprdcad.tipo_prd
       AND faprecad.codigo = faprdcad.codigo
       AND (fapaccad.cod_pac = 'J958740' AND faccicad.tab_int = 'P32' AND fapaccad.tipo_pac = 'I'
   AND faprecad.validade=(select MAX(faprecad.validade) from faprecad where tabela = '32'
                           AND (faprecad.codigo = faprdcad.codigo) AND (faprecad.tabela = '32'))
   AND (faprecad.tabela = '32'))
ORDER BY fapaccad.cod_prt, faprtcad.nome_pac, fapaccad.cod_pac, fapaccad.cod_con, faconcad.fantasia, fapaccad.cod_pla,
faplacad.nome_plano, fatipcad.descricao, faprdcad.descricao
