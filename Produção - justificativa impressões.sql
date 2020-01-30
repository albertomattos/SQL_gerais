--FATURAMENTO - Consumo por período
select sum(round(decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)),2)) total
from famovcad a, famovprd b, famovdestino c, faprdcad d where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and c.destino <> 'H' and a.data_mov >= '20/05/2016' and a.data_mov <= '19/06/2016'
group by a.req_dev
--Atendimentos PS
select count(*) from fapaccad where tipo_pac = 'U' and fapaccad.data_ent >= '20/05/2016' and fapaccad.data_ent <= '19/06/2016'
--Consultas CM
select sum(count(c.descricao)) soma from wpd.famovprd@prod a, wpd.famovcad@prod b, wpd.faprdcad@prod c, wpd.fapaccad@prod d, wpd.fatipcad@prod e
where c.codigo = a.codigo and a.comanda = b.comanda and d.cod_pac = b.cod_pac and c.tipo_prd = e.tipo_prd and c.tipo_prd = 'CON'
and b.data_mov >= '20/05/2016' and b.data_mov <= '19/06/2016' and d.tipo_pac = 'A' and d.cod_ala in ('CMED','PEDI','CNEU','DAYH') group by c.descricao
--Consultas Check-Up
select sum(count(c.descricao)) soma from wpd.famovprd@prod a, wpd.famovcad@prod b, wpd.faprdcad@prod c, wpd.fapaccad@prod d, wpd.fatipcad@prod e
where c.codigo = a.codigo and a.comanda = b.comanda and d.cod_pac = b.cod_pac and c.tipo_prd = e.tipo_prd and c.tipo_prd = 'CON'
and b.data_mov >= '20/05/2016' and b.data_mov <= '19/06/2016' and d.tipo_pac = 'A' and d.cod_ala ='CHEC' group by c.descricao
--Exames CDI
SELECT sum(SUM(FAMOVPRD.QUANT * DECODE(REQ_DEV,'R',1,-1) / (SELECT COUNT(*) FROM FAMOVDESTINO WHERE SEQUENCIAL = FAMOVPRD.SEQUENCIAL 
AND FAMOVDESTINO.DESTINO IN ('H','C','P')))) AS QTD_PER FROM FAMOVDESTINO, FATIPCAD, FASETCAD,FAPRDCAD, FAPACCAD, FAMOVCAD, FAMOVPRD, FAPRTCAD
WHERE FAMOVCAD.DATA_MOV >= '20/05/2016' AND FAMOVCAD.DATA_MOV <= '19/06/2016'
AND FAMOVDESTINO.DESTINO IN ('H','C','P') AND FAPRDCAD.TIPO_PRD  IN ('RAD','REM','TOM','USG') AND fapaccad.cod_uni IN ('0001')
AND FAMOVDESTINO.COD_UNI_COBRANCA IN ('0001') AND FAMOVDESTINO.SEQUENCIAL = FAMOVPRD.SEQUENCIAL 
AND FAMOVPRD.TIPO_COMANDA = FAMOVCAD.TIPO_COMANDA AND FAMOVPRD.COMANDA = FAMOVCAD.COMANDA AND FAMOVPRD.CODIGO  = FAPRDCAD.CODIGO
AND FAPACCAD.COD_PRT = FAPRTCAD.COD_PRT AND FAMOVCAD.COD_PAC = FAPACCAD.COD_PAC AND FAPRDCAD.TIPO_PRD = FATIPCAD.TIPO_PRD
AND FAMOVCAD.SET_ORI  = FASETCAD.COD_SET GROUP BY FAPRDCAD.CODIGO,FAPRDCAD.TIPO_PRD , FAPRDCAD.DESCRICAO
--Diárias UTI Neoped
select sum(count(c.descricao)) soma from wpd.famovprd@prod a, wpd.famovcad@prod b, wpd.faprdcad@prod c, wpd.fapaccad@prod d, wpd.fatipcad@prod e
where c.codigo = a.codigo and a.comanda = b.comanda and d.cod_pac = b.cod_pac and c.tipo_prd = e.tipo_prd and c.tipo_prd = 'DIA'
and b.data_mov >= '20/05/2016' and b.data_mov <= '19/06/2016' and d.tipo_pac = 'I' and b.set_ori = '0121'
group by c.descricao
--Diárias UTI Geral
select sum(count(c.descricao)) soma from wpd.famovprd@prod a, wpd.famovcad@prod b, wpd.faprdcad@prod c, wpd.fapaccad@prod d, wpd.fatipcad@prod e
where c.codigo = a.codigo and a.comanda = b.comanda and d.cod_pac = b.cod_pac and c.tipo_prd = e.tipo_prd and c.tipo_prd = 'DIA'
and b.data_mov >= '20/05/2016' and b.data_mov <= '19/06/2016' and d.tipo_pac = 'I' and b.set_ori = '0125'
group by c.descricao
--Diárias UTI Coronariana
select sum(count(c.descricao)) soma from wpd.famovprd@prod a, wpd.famovcad@prod b, wpd.faprdcad@prod c, wpd.fapaccad@prod d, wpd.fatipcad@prod e
where c.codigo = a.codigo and a.comanda = b.comanda and d.cod_pac = b.cod_pac and c.tipo_prd = e.tipo_prd and c.tipo_prd = 'DIA'
and b.data_mov >= '20/05/2016' and b.data_mov <= '19/06/2016' and d.tipo_pac = 'I' and b.set_ori = '0025'
group by c.descricao
--Diárias UNID
select sum(count(c.descricao)) soma from wpd.famovprd@prod a, wpd.famovcad@prod b, wpd.faprdcad@prod c, wpd.fapaccad@prod d, wpd.fatipcad@prod e
where c.codigo = a.codigo and a.comanda = b.comanda and d.cod_pac = b.cod_pac and c.tipo_prd = e.tipo_prd and c.tipo_prd = 'DIA'
and b.data_mov >= '20/05/2016' and b.data_mov <= '19/06/2016' and d.tipo_pac = 'I'
and b.set_ori in ('0006','0104','0130','0132','0133','0134','0191','0453') group by c.descricao
--Requisições para a Farmácia
select count(distinct documento) from esmovcad where tipo_documento = 'REQ' and data_mov between '20/05/2016' and '19/06/2016' and set_est = '0155'
--Requisições para o Almoxarifado
select count(distinct documento) from esmovcad where tipo_documento = 'REQ' and data_mov between '20/05/2016' and '19/06/2016' and set_est = '0302'
--Exames Laboratoriais
select sum(soma) from (
SELECT sum(SUM(FAMOVPRD.QUANT * DECODE(REQ_DEV,'R',1,-1) / (SELECT COUNT(*) FROM FAMOVDESTINO WHERE SEQUENCIAL = FAMOVPRD.SEQUENCIAL 
AND FAMOVDESTINO.DESTINO IN ('H','C','P')))) soma FROM FAMOVDESTINO, FATIPCAD, FASETCAD,FAPRDCAD, FAPACCAD, FAMOVCAD, FAMOVPRD, FAPRTCAD
WHERE FAMOVCAD.DATA_MOV >= '20/05/2016' AND FAMOVCAD.DATA_MOV <= '19/06/2016'AND FAMOVDESTINO.DESTINO IN ('H','C','P') AND fapaccad.cod_uni IN ('0001')
and fapaccad.cod_ala = 'LABO' and fatipcad.pre_class = 'EXA' AND FAMOVDESTINO.COD_UNI_COBRANCA IN ('0001') AND FAMOVDESTINO.SEQUENCIAL = FAMOVPRD.SEQUENCIAL 
AND FAMOVPRD.TIPO_COMANDA = FAMOVCAD.TIPO_COMANDA AND FAMOVPRD.COMANDA = FAMOVCAD.COMANDA AND FAMOVPRD.CODIGO  = FAPRDCAD.CODIGO
AND FAPACCAD.COD_PRT = FAPRTCAD.COD_PRT AND FAMOVCAD.COD_PAC = FAPACCAD.COD_PAC AND FAPRDCAD.TIPO_PRD = FATIPCAD.TIPO_PRD
AND FAMOVCAD.SET_ORI  = FASETCAD.COD_SET GROUP BY FAPRDCAD.CODIGO,FAPRDCAD.TIPO_PRD , FAPRDCAD.DESCRICAO
union
SELECT sum(SUM(FAMOVPRD.QUANT * DECODE(REQ_DEV,'R',1,-1) / (SELECT COUNT(*) FROM FAMOVDESTINO WHERE SEQUENCIAL = FAMOVPRD.SEQUENCIAL 
AND FAMOVDESTINO.DESTINO IN ('H','C','P')))) soma FROM FAMOVDESTINO, FATIPCAD, FASETCAD,FAPRDCAD, FAPACCAD, FAMOVCAD, FAMOVPRD, FAPRTCAD
WHERE FAMOVCAD.DATA_MOV >= '20/05/2016' AND FAMOVCAD.DATA_MOV <= '19/06/2016'
AND FAMOVDESTINO.DESTINO IN ('H','C','P') AND FAPRDCAD.TIPO_PRD IN ('LAB') AND fapaccad.cod_uni IN ('0001')
and fapaccad.cod_ala <>'LABO' AND FAMOVDESTINO.COD_UNI_COBRANCA IN ('0001') AND FAMOVDESTINO.SEQUENCIAL = FAMOVPRD.SEQUENCIAL 
AND FAMOVPRD.TIPO_COMANDA = FAMOVCAD.TIPO_COMANDA AND FAMOVPRD.COMANDA = FAMOVCAD.COMANDA AND FAMOVPRD.CODIGO  = FAPRDCAD.CODIGO
AND FAPACCAD.COD_PRT = FAPRTCAD.COD_PRT AND FAMOVCAD.COD_PAC = FAPACCAD.COD_PAC AND FAPRDCAD.TIPO_PRD = FATIPCAD.TIPO_PRD
AND FAMOVCAD.SET_ORI  = FASETCAD.COD_SET GROUP BY FAPRDCAD.CODIGO,FAPRDCAD.TIPO_PRD , FAPRDCAD.DESCRICAO)
--Internações eletivas (sem hemodiálise)
select count(*) from fapaccad a, fapaccom b where b.cod_pac = a.cod_pac and a.data_ent >= '20/05/2016'
and a.data_ent <= '19/06/2016' and b.eletiva_emergencia <> 'M' and a.tipo_pac = 'I' and a.cod_ala <> 'HMDA'
--Procedimentos realizados no CC
SELECT sum(count(nome_pro))
FROM BLCIRU_REALIZADA, BLSTAT_CIRU_REZD, BLCIRU_STATUS, BLPROC_CIRURGICO, FAPRDCAD, FAPROCAD, BLEQPE_PROC_CIRU,
faespcad, faesppro WHERE  BLCIRU_REALIZADA.CD_CIRU_REALIZADA = BLSTAT_CIRU_REZD.CD_CIRU_REALIZADA
AND  BLSTAT_CIRU_REZD.CD_CIRU_STATUS      = BLCIRU_STATUS.CD_CIRU_STATUS
AND  BLCIRU_REALIZADA.CD_CIRU_REALIZADA   = BLPROC_CIRURGICO.CD_CIRU_REALIZADA
AND  BLPROC_CIRURGICO.CD_PROC_CIRURGICO   = FAPRDCAD.CODIGO
AND  BLPROC_CIRURGICO.CD_PROC_CIRURGICO   = BLEQPE_PROC_CIRU.CD_PROC_CIRURGICO
AND  BLPROC_CIRURGICO.CD_CIRU_REALIZADA   = BLEQPE_PROC_CIRU.CD_CIRU_REALIZADA
AND  BLPROC_CIRURGICO.REGIAO = BLEQPE_PROC_CIRU.REGIAO AND BLEQPE_PROC_CIRU.CD_PROFISSIONAL = FAPROCAD.COD_PRO
and faprocad.cod_pro = faesppro.cod_pro and faespcad.cod_esp = faesppro.cod_esp
and faesppro.sn_principal = 'S' AND  BLEQPE_PROC_CIRU.COD_ATO IN ('01') AND  BLCIRU_STATUS.CD_CIRU_STATUS = 'E'
AND BLPROC_CIRURGICO.DATA_HORA_INI >= '20/05/2016' AND BLPROC_CIRURGICO.DATA_HORA_INI <= '20/06/2016'
group by faprocad.nome_pro, faespcad.descricao, BLPROC_CIRURGICO.DATA_HORA_INI
--Procedimentos realizados Hemodinâmica
select count(*) from wpd.famovprd@prod a, wpd.famovcad@prod b, wpd.faprdcad@prod c, wpd.fapaccad@prod d
where c.codigo = a.codigo and a.comanda = b.comanda and d.cod_pac = b.cod_pac and c.tipo_prd = 'PRO'
and b.data_mov >= '20/05/2016' and b.data_mov <= '19/06/2016' and b.set_ori = '0124' and a.tipo_ato = '01'
--Procedimentos solicitados (Central de Autorização)
select count(*) from TB_AUTORIZ_CABEC t where t.dh_solicitacao >= '20/05/2016' and t.dh_solicitacao <= '20/06/2016'
      and t.fk_msgaut <> 9 and t.fk_cod_uni = '0001' and t.st_envio in ('1', '2', '3')
