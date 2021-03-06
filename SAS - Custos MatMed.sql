insert into custo_matmed (
select ('01'||'/'||SUBSTR(ano_mes, 5 ,2)||'/'||SUBSTR(ano_mes, 1 ,4)),
sum(tot) tot from (
  select b.ano_mes, a.cod_cliente, a.descricao, sum(b.valor) tot
  from vec_Ccus a, ccu_mcdc b,ccu_ccic c, ccu_cust d where a.codigo = b.cod_ccu and b.cod_ccu = c.cod_ccu and b.cod_cus = c.cod_cus
  and c.cod_cus = d.cod_cus
  and b.cod_cus in ('00020','00021','00022','00024','00025','00026','00027') --Itens fatur�veis
  and b.ano_mes = '201612'--Mudar o m�s
  group by b.ano_mes, a.cod_cliente, a.descricao
union
  select b.ano_mes, a.cod_cliente, a.descricao, sum(b.valor) tot
  from vec_Ccus a, ccu_mcic b, ccu_ccic c, ccu_cust d where
  a.codigo = b.cod_ccu and b.cod_ccu = c.cod_ccu and b.cod_cus = c.cod_cus and c.cod_cus = d.cod_cus
  and b.cod_cus in ('00020','00021','00022','00024','00025','00026','00027') --Itens fatur�veis
  and b.ano_mes = '201612'--Mudar o m�s
  group by b.ano_mes, a.cod_cliente, a.descricao)
  group by ano_mes
  )

--delete from custo_matmed where data_custo = '01/12/2016'
