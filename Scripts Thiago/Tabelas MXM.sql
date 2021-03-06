--Tabela de clientes
select * from cliente_cli
select * from fornec_for
--Forma de pagamento
select * from fmpagban_fpb
--Contas a pagar / receber
select * from ti_grupopagarreceber_tgcpr where tgcpr_cdfor = '14722938000120'
select * from ti_pagarreceber_tcpr where tcpr_sqprocesso = '803'
--T�tulos
select * from ti_arqreqpag_tarp where tarp_cdfornecedor = '14722938000120'
--Grupos de pagamentos
select * from grpag_gpa
--Condi��es de pagamento
select * from condpag_cpg
--Antecipa��es
select * from anteccp_acp where acp_cdfor = '14722938000120' order by acp_data
select * from anteccpgrp_agrp where agrp_cdfor = '14722938000120'

select * from titcpgracrdec_pgad where pgad_cdfor = '14722938000120'
select * from titcpgrbx_pgrb where pgrb_cdfor = '14722938000120' order by pgrb_notitulo
select * from titcpgr_pgr where pgr_cdfor = '14722938000120' order by pgr_notitulo

--Fluxo do caixa
select * from fluxocx_fcx

SELECT * FROM FGPAGIR_FGI
 WHERE FGI_CODFOR = '14722938000120'
   AND FGI_CODEMP = ''
   AND (FGI_CODFILIAL = '' OR FGI_CODFILIAL IS NULL)
   AND (FGI_CODMOEDA  = '' OR FGI_CODMOEDA IS NULL)
   AND FGI_CODGRPAG IS NOT NULL
   
SELECT * FROM TITCP_TCP WHERE TCP_CDFOR = '14722938000120' AND TCP_NOTITULO = 'E00000014324'

SELECT ITM_SQINTEGRACAO AS SQINTEGRACAO, ITM_TPINTEGRACAO FROM TITCP_TCP, INTMODTCP_IMP, INTEGMODULOS_ITM   
WHERE TCP_CDFOR = '14722938000120' AND ( TCP_NOTITULO = 'E00000014324' OR TCP_NOTITPARC   = 'E00000014324'
OR TCP_NOTITPARCOR = 'E00000014324') AND IMP_CDFOR = TCP_CDFOR AND IMP_NOTITULO = TCP_NOTITULO AND ITM_SQINTEGRACAO = IMP_SQINTEGRACAO
AND ITM_TPINTEGRACAO NOT IN (9, 12, 14)
   
SELECT INTEGMODULOS_ITM.*, TITCP_TCP.*, CASE WHEN ITM_TPINTEGRACAO IN(9, 12, 14) THEN (SELECT IMP_SQINTEGRACAO 
FROM INTMODTCP_IMP, INTEGMODULOS_ITM WHERE IMP_CDFOR = TCP_CDFOR AND IMP_NOTITULO = TCP_NOTITULO
AND IMP_SQINTEGRACAO = ITM_SQINTEGRACAO AND ITM_TPINTEGRACAO NOT IN (9, 12, 14)) ELSE ITM_SQINTEGRACAO END AS SQINTEGRACAO 
FROM INTMODTCP_IMP, INTEGMODULOS_ITM, TITCP_TCP WHERE ITM_SQINTEGRACAO = 50770 AND IMP_SQINTEGRACAO = ITM_SQINTEGRACAO
AND IMP_CDFOR = TCP_CDFOR AND IMP_NOTITULO = TCP_NOTITULO

SELECT * FROM TITCPGR_PGR WHERE PGR_CDFOR = '14722938000120' AND PGR_NOTITULO = 'E00000014324'  
SELECT * FROM TITCPCC_PCC WHERE PCC_CDFOR = '14722938000120' AND PCC_NOTITULO = 'E00000014324'

SELECT CALCJDC('TCP','14722938000120','E00000014324','01','8/6/2007','8/6/2007','C','N',NULL,0) AS CALCJDC FROM DUAL
  
SELECT * FROM TITCPACRDEC_PAD WHERE PAD_CDFOR = '14722938000120' AND PAD_NOTITULO = 'E00000014324'

SELECT RELTPCRED_RTPC.*, TITORI.TCP_VLRTITULO RTPC_VALORTITULO,TITCRED.TCP_VLRTITULO RTPC_VALORTITULOCREDITO FROM RELTPCRED_RTPC,
TITCP_TCP TITORI,TITCP_TCP TITCRED WHERE RTPC_CDFOR = '14722938000120' AND RTPC_NOTITULO = 'E00000014324'
AND TITORI.TCP_CDFOR = RTPC_CDFOR AND TITORI.TCP_NOTITULO = RTPC_NOTITULO AND TITCRED.TCP_CDFOR = RTPC_CDFOR
AND TITCRED.TCP_NOTITULO = RTPC_NOTITCRED

SELECT * FROM INTMODCTB_IMC  WHERE IMC_SQINTEGRACAO = 50770

SELECT * FROM LANCCTB_LCT  WHERE LCT_CDEMPRESA = '001'   AND LCT_LOTE      = 'SCP_PR'
AND LCT_DATA      = TO_DATE('06/06/07', 'DD/MM/RR') 
AND LCT_LANCCTB   = '002778' ORDER BY LCT_CDEMPRESA, LCT_LOTE, LCT_LANCCTB, LCT_DATA, LCT_SEQ

SELECT * FROM TIPULO_TIP  WHERE TIP_CDTIPULO = '02'

SELECT * FROM TPCOBR_TCP WHERE TCP_CDTPCOBR = '01'

SELECT TCPR_NOPEDCOMPRA FROM TITCP_TCPR,INTMODTCP_IMP ,INTEGMODULOS_ITM           
WHERE TCPR_CDFOR = '14722938000120' AND (    TCPR_NOTITULO = 'E00000014324' OR TCPR_NOTITPARC = 'E00000014324')                                               
AND TCPR_CDFOR         = IMP_CDFOR AND TCPR_NOTITULO      = IMP_NOTITULO            
AND IMP_SQINTEGRACAO   = ITM_SQINTEGRACAO AND ITM_TPINTEGRACAO   = '8'

SELECT * FROM CDPLANO_CPLC  WHERE CPLC_CODIGO = '0001'