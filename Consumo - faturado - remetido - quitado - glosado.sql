select
  count(a.cod_pac) "nº Contas",
  count(c.cod_fatura) "nº Faturas",
  sum(sum( distinct case when (select d.remessa from fafatcad d where d.fatura = c.cod_fatura) is not null then '1' else '0' end)) "nº Remetidas",
  sum(case when c.cod_fatura in (select d.fatura from fafatcad d where d.remessa is not null and d.cod_pac = a.cod_pac) then sum(c.valor_tot * decode(req_dev,'R',1,-1)) end) "Total Remetido",
  to_char(sum((select d.valor_pago from fafatcad d where d.fatura = c.cod_fatura)), '999G999G999D90', 'nls_numeric_characters='',.''') "Quitação",
  to_char(sum(sum(c.valor_tot * decode(req_dev,'R',1,-1))), '999G999G999D90', 'nls_numeric_characters='',.''') "Consumo Total",
  to_char(sum(case when c.cod_fatura is not null and c.cod_fatura != ' ' then sum(c.valor_tot * decode(req_dev,'R',1,-1)) end), '999G999G999D90', 'nls_numeric_characters='',.''') "Total Faturado",
  to_char(sum((select case when d.valor_pago > 0 and d.valor_pago < d.valor_tot and d.quitada != 'N' then nvl(d.valor_tot,0)-nvl(d.valor_pago,0) end glosa from fafatcad d where d.fatura = c.cod_fatura and d.valor_tot != 0)), '999G999G999D90', 'nls_numeric_characters='',.''') "Glosa"

from famovcad a inner join famovprd b on b.tipo_comanda = a.tipo_comanda and a.comanda = b.comanda
                inner join famovdestino c on c.sequencial = b.sequencial        
where 1=1
      and (b.tipo_pgto != 'N' or  b.tipo_pgto is null or  b.tipo_pgto = 'R' or  b.tipo_pgto = 'H')
      and a.data_mov between '01/10/2016' and '27/10/2016'
      and c.destino in ('X','C','P')
      and b.tipo_pgto in ('H','R','D')      
group by c.cod_fatura, a.cod_pac


--Consumido:
select sum(round(decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)),2)) total
from famovcad a, famovprd b, famovdestino c, faprdcad d where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.cod_pac = '1322151'
and c.destino <> 'H' and b.tipo_pgto <> 'N' group by a.req_dev
--Faturado:
select sum(round(decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)),2)) total
from famovcad a, famovprd b, famovdestino c, faprdcad d where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '19/10/2016' and '19/10/2016'
and c.destino <> 'H' and b.tipo_pgto <> 'N' and c.cod_fatura is not null group by a.req_dev
--Remetido:
select sum(round(decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)),2)) total
from famovcad a, famovprd b, famovdestino c, faprdcad d, fafatcad e where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and c.cod_fatura = e.fatura and a.data_mov between '19/10/2016' and '19/10/2016'
and c.destino <> 'H' and b.tipo_pgto <> 'N' and c.cod_fatura is not null and e.remessa is not null
group by a.req_dev
--Quitado:
select sum(valor_pago) from quitacao_produto where cod_fatura in (
select c.cod_fatura
from famovcad a, famovprd b, famovdestino c, faprdcad d where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.cod_pac = '1322151'
and c.destino <> 'H' and b.tipo_pgto <> 'N' and c.cod_fatura is not null)

select sum(valor_pago) from quitacao_taxa where cod_fatura in (
select c.cod_fatura
from famovcad a, famovprd b, famovdestino c, faprdcad d where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.cod_pac = '1322151'
and c.destino <> 'H' and b.tipo_pgto <> 'N' and c.cod_fatura is not null)
--Consumido detalhado:
select c.cod_fatura, b.codigo, a.cod_pac, c.valor_tot
from famovcad a, famovprd b, famovdestino c, faprdcad d where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.cod_pac = '1322151'
and c.destino <> 'H' and b.tipo_pgto <> 'N'
