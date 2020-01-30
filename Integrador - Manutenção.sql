select count(*) from int_xml

--Mudar o pro_in_id para cada tipo de serviço
DELETE FROM int_xml x WHERE x.trn_in_id IN
(SELECT tr.trn_in_id FROM int_transacao tr where tr.pro_in_id=207 and tr.trn_st_status='D')

DELETE FROM int_xml x WHERE x.trn_in_id IN (SELECT tr.trn_in_id FROM int_transacao tr
where /*tr.pro_in_id=207 and tr.trn_st_status='A'and*/ tr.trn_dt_datatranscao < '01/07/2016')

--Mudar o pro_in_id para cada tipo de serviço
delete int_transacao t where/* t.pro_in_id=207 and t.trn_st_status='D' */t.trn_dt_datatranscao < '01/07/2016'

select count(*) from int_transacao

select tr.trn_in_id, tr.trn_dt_datatranscao from int_transacao tr where tr.trn_dt_datatranscao < sysdate-120

--Com esse select você pode observar os serviços ativos em sua base de dados:
select t.pro_in_id,t.pro_st_descricao,t.pro_bo_ativo from int_processo t
where t.pro_bo_ativo='S' and t.pro_ch_acao='R'
order by t.pro_in_id

/*
207 - AGENTES **
308 - BAIXA DE CONTAS A PAGAR/RECEBER **
306 - FATURA A PAGAR/RECEBER **
202 - INTEGRACAO DE CLIENTES
203 - INTEGRACAO DE FORNECEDORES
401 - INTEGRACAO DE MOVIMENTACAO CONTABIL
305 - INTEGRACAO DE MOVIMENTOS VINCULADOS CPA/CRE **
302 - INTEGRACAO DO CONTAS A PAGAR
301 - INTEGRACAO DO CONTAS A RECEBER
8000 - MOVIMENTACAO CONTABIL WPD
307 - MOVIMENTACAO FINACNEIRA **
*/
