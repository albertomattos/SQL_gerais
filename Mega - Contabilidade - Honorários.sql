select distinct a.acao_st_nome from mgglo.glo_acao a where upper(a.acao_st_nome) like '%HONOR%',
     mgglo.glo_acaomovimento b
where a.ACAO_TAB_IN_CODIGO = b.ACAO_TAB_IN_CODIGO
and   a.ACAO_PAD_IN_CODIGO = b.ACAO_PAD_IN_CODIGO
and   a.ACAO_IN_CODIGO     = b.ACAO_IN_CODIGO
and   a.acao_bo_contab =  'S'
and   b.acaom_re_valorcontabil <> 0
and   b.acaom_re_valorcontabilreal = 0
and   b.acaom_dt_dataemissao between '01/01/2015' and '28/03/2016'   
order by b.acaom_dt_dataemissao desc   

---
select t.*, t.rowid
from fin_movimento t where upper(t.mov_st_complhist) like 'HONOR%'
--and t.mov_in_numlancto like '97469%'

---

select t.*, t.rowid from con_item_lancamento t where upper(t.ite_st_complemento) like '%LELIS%'
and t.ite_dt_conversao between '01/01/2012' and '31/12/2012'
