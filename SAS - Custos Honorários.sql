insert into custo_hon (
select ('01'||'/'||SUBSTR(ano_mes, 5 ,2)||'/'||SUBSTR(ano_mes, 1 ,4)),
sum(tot) tot from (
  select b.ano_mes, a.cod_cliente, a.descricao, sum(b.valor) tot
  from vec_Ccus a, ccu_mcdc b,ccu_ccic c, ccu_cust d where a.codigo = b.cod_ccu and b.cod_ccu = c.cod_ccu and b.cod_cus = c.cod_cus
  and c.cod_cus = d.cod_cus
  and b.cod_cus in ('00018','00019','00096','00097') --honorários
  and b.ano_mes = '201612'--Mudar o mês
  group by b.ano_mes, a.cod_cliente, a.descricao
union
  select b.ano_mes, a.cod_cliente, a.descricao, sum(b.valor) tot
  from vec_Ccus a, ccu_mcic b, ccu_ccic c, ccu_cust d where
  a.codigo = b.cod_ccu and b.cod_ccu = c.cod_ccu and b.cod_cus = c.cod_cus and c.cod_cus = d.cod_cus
  and b.cod_cus in ('00018','00019','00096','00097')
  and b.ano_mes = '201612'--Mudar o mês
  group by b.ano_mes, a.cod_cliente, a.descricao)
  group by ano_mes
  )
  
  --select * from custo_hon
