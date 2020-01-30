select ano_mes, descricao, sum(tot) tot from (
select b.ano_mes, a.descricao, sum(b.valor) tot
from vec_Ccus a, ccu_mcdc b,ccu_ccic c, ccu_cust d
where /*b.ano_mes >= '201504' and b.ano_mes <= '201504'
  and */a.codigo = b.cod_ccu
  and b.cod_ccu = c.cod_ccu
  and b.cod_cus = c.cod_cus
  and c.cod_cus = d.cod_cus
 and a.cod_cliente = '0135'
  and b.cod_cus not in ('00020','00021','00022','00024','00025','00026','00027','00036') --Itens faturáveis
group by b.ano_mes, a.descricao
union
select b.ano_mes, a.descricao, sum(b.valor) tot
from vec_Ccus a, ccu_mcic b, ccu_ccic c, ccu_cust d
where /*b.ano_mes >= '201504' and b.ano_mes <= '201504'
  and */a.codigo = b.cod_ccu
  and b.cod_ccu = c.cod_ccu
  and b.cod_cus = c.cod_cus
  and c.cod_cus = d.cod_cus
  and a.cod_cliente = '0135'
  and b.cod_cus not in ('00020','00021','00022','00024','00025','00026','00027','00036')
group by b.ano_mes, a.descricao
)
group by ano_mes, descricao
order by 2,1
