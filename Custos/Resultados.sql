select cod_cliente, descricao, tipo, sum(tot)/6 tot from (
select a.cod_cliente, a.descricao, 'RECEITA' tipo, sum(b.valor) tot
from vec_Ccus a, ccu_mrec b
where b.ano_mes between '201301' and '201306'
  and a.codigo = b.cod_ccu
  and a.tipo = 'P'
group by  a.cod_cliente, a.descricao
union all
select a.cod_cliente, a.descricao, 'CUSTOS VARIÁVEIS PRÓPRIOS' TIPO, sum(b.valor) tot
from vec_Ccus a, ccu_mcdc b,ccu_ccic c
where b.ano_mes between '201301' and '201306'
  and a.codigo = b.cod_ccu
  and b.cod_ccu = c.cod_ccu
  and b.cod_cus = c.cod_cus
  and c.tipo = 'V'
  and a.tipo = 'P'
group by  a.cod_cliente, a.descricao
union all
select a.cod_cliente, a.descricao, 'CUSTOS VARIÁVEIS PRÓPRIOS' TIPO, sum(b.valor*c.porc_var/100) tot
from vec_Ccus a, ccu_mcic b,ccu_ccic c
where b.ano_mes between '201301' and '201306'
  and a.codigo = b.cod_ccu
  and b.cod_ccu = c.cod_ccu
  and b.cod_cus = c.cod_cus
  and c.tipo = 'M'
  and a.tipo = 'P'
group by  a.cod_cliente, a.descricao
union all
select a.cod_cliente, a.descricao, 'CUSTOS VARIÁVEIS PRÓPRIOS' TIPO, sum(b.valor) tot
from vec_Ccus a, ccu_mcic b,ccu_ccic c
where b.ano_mes between '201301' and '201306'
  and a.codigo = b.cod_ccu
  and b.cod_ccu = c.cod_ccu
  and b.cod_cus = c.cod_cus
  and c.tipo = 'V'
  and a.tipo = 'P'
group by  a.cod_cliente, a.descricao
union all
select a.cod_cliente, a.descricao, 'CUSTOS VARIÁVEIS PRÓPRIOS' TIPO, sum(b.valor*c.porc_var/100) tot
from vec_Ccus a, ccu_mcdc b,ccu_ccic c
where b.ano_mes between '201301' and '201306'
  and a.codigo = b.cod_ccu
  and b.cod_ccu = c.cod_ccu
  and b.cod_cus = c.cod_cus
  and c.tipo = 'M'
  and a.tipo = 'P'
group by  a.cod_cliente, a.descricao
union all
select a.cod_cliente, a.descricao, 'CUSTOS FIXOS PRÓPRIOS' TIPO, sum(b.valor) tot
from vec_Ccus a, ccu_mcdc b,ccu_ccic c
where b.ano_mes between '201301' and '201306'
  and a.codigo = b.cod_ccu
  and b.cod_ccu = c.cod_ccu
  and b.cod_cus = c.cod_cus
  and c.tipo = 'F'
  and a.tipo = 'P'
group by  a.cod_cliente, a.descricao
union all
select a.cod_cliente, a.descricao, 'CUSTOS FIXOS PRÓPRIOS' TIPO, sum(b.valor*c.porc_fix/100) tot
from vec_Ccus a, ccu_mcdc b,ccu_ccic c
where b.ano_mes between '201301' and '201306'
  and a.codigo = b.cod_ccu
  and b.cod_ccu = c.cod_ccu
  and b.cod_cus = c.cod_cus
  and c.tipo = 'M'
  and a.tipo = 'P'
group by  a.cod_cliente, a.descricao
union all
select a.cod_cliente, a.descricao, 'CUSTOS FIXOS PRÓPRIOS' TIPO, sum(b.valor) tot
from vec_Ccus a, ccu_mcic b,ccu_ccic c
where b.ano_mes between '201301' and '201306'
  and a.codigo = b.cod_ccu
  and b.cod_ccu = c.cod_ccu
  and b.cod_cus = c.cod_cus
  and c.tipo = 'F'
  and a.tipo = 'P'
group by  a.cod_cliente, a.descricao
union all
select a.cod_cliente, a.descricao, 'CUSTOS FIXOS PRÓPRIOS' TIPO, sum(b.valor*c.porc_fix/100) tot
from vec_Ccus a, ccu_mcic b,ccu_ccic c
where b.ano_mes between '201301' and '201306'
  and a.codigo = b.cod_ccu
  and b.cod_ccu = c.cod_ccu
  and b.cod_cus = c.cod_cus
  and c.tipo = 'M'
  and a.tipo = 'P'
group by  a.cod_cliente, a.descricao
union all
select a.cod_cliente, a.descricao, 'CUSTOS FIXOS ABSORVIDOS' TIPO, sum(b.val_CUS_FIX) tot
from vec_Ccus a, ccu_mRAT b
where b.ano_mes between '201301' and '201306'
  and a.codigo = b.cod_ccu_des
  and a.tipo = 'P'
group by  a.cod_cliente, a.descricao
union all
select a.cod_cliente, a.descricao, 'CUSTOS VARIÁVEIS ABSORVIDOS' TIPO, sum(b.val_CUS_VAR) tot
from vec_Ccus a, ccu_mRAT b
where b.ano_mes between '201301' and '201306'
  and a.codigo = b.cod_ccu_des
  and a.tipo = 'P'
group by  a.cod_cliente, a.descricao
)
group by cod_cliente, descricao, tipo
order by cod_cliente
