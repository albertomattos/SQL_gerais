--select * from usr_nci.custo_por_cc@nci where data_custo = '01/07/2015' and cod_cliente in ('0118','0026')
select distinct
(select sum(b.valor)
from usr_nci.vec_Ccus@nci a, usr_nci.ccu_mcdc@nci b, usr_nci.ccu_ccic@nci c, usr_nci.ccu_cust@nci d
where b.ano_mes >= '201512' and b.ano_mes <= '201512'
  and a.codigo = b.cod_ccu
  and b.cod_ccu = c.cod_ccu
  and b.cod_cus = c.cod_cus
  and c.cod_cus = d.cod_cus
  and b.cod_cus not in ('00018','00019','00020','00021','00022','00024','00025','00026','00027','00036')
  and a.cod_cliente = '0303')+
(select sum(b.valor)
from usr_nci.vec_Ccus@nci a, usr_nci.ccu_mcic@nci b, usr_nci.ccu_ccic@nci c, usr_nci.ccu_cust@nci d
where b.ano_mes >= '201512' and b.ano_mes <= '201512'
  and a.codigo = b.cod_ccu
  and b.cod_ccu = c.cod_ccu
  and b.cod_cus = c.cod_cus
  and c.cod_cus = d.cod_cus
  and b.cod_cus not in ('00018','00019','00020','00021','00022','00024','00025','00026','00027','00036')
  and a.cod_cliente = '0303')
from usr_nci.ccu_mcic@nci
--
select distinct 
(select sum(b.valor)
        from usr_nci.vec_Ccus@nci a, usr_nci.ccu_mcdc@nci b, usr_nci.ccu_ccic@nci c, usr_nci.ccu_cust@nci d
        where b.ano_mes >= '201510' and b.ano_mes <= '201510'
        and a.codigo = b.cod_ccu
        and b.cod_ccu = c.cod_ccu
        and b.cod_cus = c.cod_cus
        and c.cod_cus = d.cod_cus
        and a.cod_cliente = '0118')+
(select sum(b.valor)
        from usr_nci.vec_Ccus@nci a, usr_nci.ccu_mcic@nci b, usr_nci.ccu_ccic@nci c, usr_nci.ccu_cust@nci d
        where b.ano_mes >= '201510' and b.ano_mes <= '201510'
        and a.codigo = b.cod_ccu
        and b.cod_ccu = c.cod_ccu
        and b.cod_cus = c.cod_cus
        and c.cod_cus = d.cod_cus
        and a.cod_cliente = '0118')
from usr_nci.ccu_mcic@nci


---------
select sum(valor) from usr_nci.custo_por_cc@nci where cod_cliente = '0302'
and data_custo >= $COMPETENCE_FROM
and data_custo <= $COMPETENCE_UNTIL
