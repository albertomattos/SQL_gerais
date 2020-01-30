select b.pes_st_nome, i.orf_st_descricao, i.orf_in_reduzido, i.orf_st_extenso, j.hor_dt_inicio
from mgrh.rh_colaborador a, mgrh.rh_pessoa b, mgglo.glo_organofunc i, mgrh.rh_hist_organograma j
where a.pes_in_codigo = b.pes_in_codigo
and a.col_in_codigo = j.col_in_codigo and j.orf_in_reduzido = i.orf_in_reduzido
and a.col_in_codigo not in (select col_in_codigo from mgrh.rh_rescisao)
and j.hor_dt_inicio=(select max(j2.hor_dt_inicio) from mgrh.rh_hist_organograma j2 where j.col_in_codigo = j2.col_in_codigo)
--and j.orf_in_reduzido = '29'
group by b.pes_st_nome, i.orf_st_descricao, i.orf_in_reduzido, i.orf_st_extenso, j.hor_dt_inicio
order by b.pes_st_nome

/*
update mgrh.rh_hist_organograma set orf_in_reduzido = '30' where orf_in_reduzido = '145'
--select * from mgrh.rh_hist_organograma where orf_in_reduzido = '145'
select pes_st_nome from mgrh.rh_pessoa where pes_in_codigo in(
select pes_in_codigo from mgrh.rh_colaborador where col_in_codigo = '158')*/
