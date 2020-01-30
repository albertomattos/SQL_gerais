select * from MGFIN.FIN_CONTASPAGAR
where cpa_in_ap like '%5124%'
select * from MGFIN.FIN_MOVFIN
select * from MGFIN.FIN_MOVIMENTO where MOV_RE_VALOR like '%1506,75' AND MOV_ST_COMPLHIST like '%10283%'

update MGFIN.FIN_MOVIMENTO set acao_in_codigo = '68' where MOV_RE_VALOR like '%1506,75' and ACAO_IN_CODIGO = '919' AND MOV_ST_COMPLHIST like '%10283%37%'
