RH_PESSOA
RH_REL_COLABORADOR
RH_HIST_JORNADA
RH_JORNADA

select * from mgrh.RH_HIST_JORNADA;
select * from mgrh.RH_JORNADA;


--PES_ST_NOME, JOR_ST_DESCRICAO, JOR_ST_OBSERVACAO

select a.PES_ST_NOME "FUNCIONARIO", 
       j.JOR_ST_DESCRICAO "JORNADA", 
       j.JOR_ST_OBSERVACAO "OBSERVACAO", 
       O.ORF_ST_DESCRICAO "CENTRO DE CUSTO"
from  mgrh.RH_PESSOA a, mgrh.RH_REL_COLABORADOR b, mgrh.RH_HIST_JORNADA hj, mgrh.RH_JORNADA j,
      MGRH.RH_HIST_ORGANOGRAMA HO,
      MGGLO.GLO_ORGANOFUNC O
where a.pes_in_codigo = b.pes_in_codigo
and b.col_in_codigo = hj.col_in_codigo
and j.jor_in_codigo = hj.jor_in_codigo
and hj.hjor_dt_inicio = (SELECT max(x.hjor_dt_inicio) FROM mgrh.RH_HIST_JORNADA x WHERE x.col_in_codigo = hj.col_in_codigo  )
and b.col_in_codigo not in (select col_in_codigo from mgrh.rh_rescisao)
and b.col_in_codigo = ho.col_in_codigo
AND   HO.ORF_TAB_IN_CODIGO = O.ORF_TAB_IN_CODIGO
AND   HO.ORF_PAD_IN_CODIGO = O.ORF_PAD_IN_CODIGO
AND   HO.ORF_IN_REDUZIDO   = O.ORF_IN_REDUZIDO
AND   HO.ORF_IDE_ST_CODIGO = O.ORF_IDE_ST_CODIGO
and ho.HOR_DT_INICIO = (SELECT max(HOO.HOR_DT_INICIO) FROM MGRH.RH_HIST_ORGANOGRAMA HOO WHERE HOO.COL_IN_CODIGO = b.col_in_codigo  )
group by a.PES_ST_NOME, j.JOR_ST_DESCRICAO, j.JOR_ST_OBSERVACAO, O.ORF_ST_DESCRICAO
ORDER BY PES_ST_NOME ASC;

ADRIANE PEREIRA ASSIS
