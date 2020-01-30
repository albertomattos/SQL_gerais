--Script sendo utilizado no Interact.
SELECT sum(SUM(FAMOVPRD.QUANT * DECODE(REQ_DEV,'R',1,-1) /
(SELECT COUNT(*) FROM FAMOVDESTINO WHERE SEQUENCIAL = FAMOVPRD.SEQUENCIAL 
AND FAMOVDESTINO.DESTINO IN ('H','C','P')))) AS QTD_PER
FROM FAMOVDESTINO, FATIPCAD, FASETCAD,FAPRDCAD, FAPACCAD, FAMOVCAD, FAMOVPRD, FAPRTCAD
WHERE FAMOVCAD.DATA_MOV >= '01/01/2015'
AND FAMOVCAD.DATA_MOV <= '31/01/2015' 
AND FAMOVDESTINO.DESTINO IN ('H','C','P') AND FAPRDCAD.TIPO_PRD  IN ('RAD','REM','TOM','USG') AND fapaccad.cod_uni IN ('0001')
AND FAMOVDESTINO.COD_UNI_COBRANCA IN ('0001') AND FAMOVDESTINO.SEQUENCIAL = FAMOVPRD.SEQUENCIAL 
AND FAMOVPRD.TIPO_COMANDA = FAMOVCAD.TIPO_COMANDA AND FAMOVPRD.COMANDA = FAMOVCAD.COMANDA AND FAMOVPRD.CODIGO  = FAPRDCAD.CODIGO
AND FAPACCAD.COD_PRT = FAPRTCAD.COD_PRT AND FAMOVCAD.COD_PAC = FAPACCAD.COD_PAC AND FAPRDCAD.TIPO_PRD = FATIPCAD.TIPO_PRD
AND FAMOVCAD.SET_ORI  = FASETCAD.COD_SET GROUP BY FAPRDCAD.CODIGO,FAPRDCAD.TIPO_PRD , FAPRDCAD.DESCRICAO


    select sum(count(c.descricao)) soma
    from wpd.famovprd@prod a, wpd.famovcad@prod b, wpd.faprdcad@prod c, wpd.fapaccad@prod d, wpd.fatipcad@prod e
    where c.codigo = a.codigo
        and a.comanda = b.comanda
        and d.cod_pac = b.cod_pac
        and c.tipo_prd = e.tipo_prd
        and to_char(b.data_mov,'YYYY/MM/DD') between '2015/01/01' and '2015/01/31'
        and b.tipo_comanda = 'CDI'
        and e.pre_class = 'EXA'
    group by c.descricao


    select sum(count(c.codigo)) soma
    from wpd.famovprd@prod a, wpd.famovcad@prod b, wpd.faprdcad@prod c, wpd.fapaccad@prod d, wpd.fatipcad@prod e
    where c.codigo = a.codigo
        and a.comanda = b.comanda
        and d.cod_pac = b.cod_pac
        and c.tipo_prd = e.tipo_prd
        and to_char(b.data_mov,'YYYY/MM/DD') between '2015/01/01' and '2015/01/31'
        and e.TIPO_PRD in ('RAD','REM','TOM','USG')
    group by c.codigo

    select distinct b.tipo_comanda
    from wpd.famovprd@prod a, wpd.famovcad@prod b, wpd.faprdcad@prod c, wpd.fapaccad@prod d, wpd.fatipcad@prod e
    where c.codigo = a.codigo
        and a.comanda = b.comanda
        and d.cod_pac = b.cod_pac
        and c.tipo_prd = e.tipo_prd
        and to_char(b.data_mov,'YYYY/MM/DD') between '2015/01/01' and '2015/01/31'
        and e.TIPO_PRD in ('RAD','REM','TOM','USG')
--    group by b.tipo_comanda, c.descricao


    select sum(a.quant) soma
    from wpd.famovprd@prod a, wpd.famovcad@prod b, wpd.faprdcad@prod c, wpd.fapaccad@prod d, wpd.fatipcad@prod e
    where c.codigo = a.codigo
        and a.comanda = b.comanda
        and d.cod_pac = b.cod_pac
        and c.tipo_prd = e.tipo_prd
        and b.data_mov between '01/01/2015' and '31/01/2015'
        and e.TIPO_PRD in ('RAD','REM','TOM','USG')
    --group by a.quant
