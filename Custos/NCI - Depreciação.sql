select b.ano_mes, a.cod_cliente, a.descricao, d.cod_cus, d.descricao, sum(b.valor) tot, b.rowid
from vec_Ccus a, ccu_mcdc b,ccu_ccic c, ccu_cust d
where b.ano_mes >= '201301' and b.ano_mes <= '201308'
  and a.codigo = b.cod_ccu
  and b.cod_ccu = c.cod_ccu
  and b.cod_cus = c.cod_cus
  and c.cod_cus = d.cod_cus
  and d.cod_cus = '00045'
  --and b.cod_cus not in ('00020','00021','00022','00024','00025','00026','00027','00036')
group by b.ano_mes, a.cod_cliente, a.descricao, d.cod_cus, d.descricao, b.rowid
union
select b.ano_mes, a.cod_cliente, a.descricao, d.cod_cus, d.descricao, sum(b.valor) tot, b.rowid
from vec_Ccus a, ccu_mcic b, ccu_ccic c, ccu_cust d
where b.ano_mes >= '201301' and b.ano_mes <= '201308'
  and a.codigo = b.cod_ccu
  and b.cod_ccu = c.cod_ccu
  and b.cod_cus = c.cod_cus
  and c.cod_cus = d.cod_cus
    and d.cod_cus = '00045'
  --and b.cod_cus not in ('00020','00021','00022','00024','00025','00026','00027','00036')
group by b.ano_mes, a.cod_cliente, a.descricao, d.cod_cus, d.descricao, b.rowid
