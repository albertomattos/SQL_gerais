select b.ano_mes, a.cod_cliente, a.descricao, b.cod_cus, d.descricao, sum(b.valor) tot
--select *
from vec_Ccus a, ccu_mcdc b,ccu_ccic c, ccu_cust d
where b.ano_mes >= '201507' and b.ano_mes <= '201507'
  and a.codigo = b.cod_ccu
  and b.cod_ccu = c.cod_ccu
  and b.cod_cus = c.cod_cus
  and c.cod_cus = d.cod_cus
  and a.cod_cliente in ('0019','0289','0382')
  and b.cod_cus not in ('00018','00019','00020','00021','00022','00024','00025','00026','00027','00036')
group by b.ano_mes, a.cod_cliente, a.descricao, d.descricao, b.cod_cus
union
select b.ano_mes, a.cod_cliente, a.descricao, b.cod_cus, d.descricao, sum(b.valor) tot
from vec_Ccus a, ccu_mcic b, ccu_ccic c, ccu_cust d
where b.ano_mes >= '201507' and b.ano_mes <= '201507'
  and a.codigo = b.cod_ccu
  and b.cod_ccu = c.cod_ccu
  and b.cod_cus = c.cod_cus
  and c.cod_cus = d.cod_cus
  and a.cod_cliente in ('0019','0289','0382')
  and b.cod_cus not in ('00018','00019','00020','00021','00022','00024','00025','00026','00027','00036')
group by b.ano_mes, a.cod_cliente, a.descricao, d.descricao, b.cod_cus
