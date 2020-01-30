drop table pedidosdecompra;

create global temporary table pedidosdecompra (
documento varchar2(7), valor_inicial number(21,2), desc_item number(12,2), acresc_ipi number(12,2),
frete number(12,2), desc_fin number(12,2), desc_ger number(12,2),desc_ger_val number(12,2), vlr_acres number(12,2));

insert into pedidosdecompra (documento, frete, desc_fin, desc_ger, desc_ger_val, vlr_acres)
select b.documento, b.frete, b.desc_fin, b.desc_ger, b.desc_ger_val, b.vlr_acres
from esmovcad b
where b.tipo_documento = 'PED'
and b.data_mov between '01/11/2012' and '30/11/2012';

merge into pedidosdecompra a
using (select distinct a.documento, sum(a.quant*a.valor) valor_inicial,
sum(a.quant*a.valor*(a.desconto/100)) desc_item,
sum(a.quant*a.valor*(a.ipi/100)) acresc_ipi
from esmovite a
where a.tipo_documento = 'PED'
GROUP BY a.documento) b
on (a.documento = b.documento)
when matched then update set
a.valor_inicial = b.valor_inicial,
a.desc_item = b.desc_item,
a.acresc_ipi = b.acresc_ipi;

select * from pedidosdecompra;
select sum(ped.valor_inicial) inicial, sum(ped.desc_item+ped.desc_ger_val+ valor_inicial*(desc_ger/100)) descontos,
sum(acresc_ipi+ frete+ vlr_acres) acrescimos
from pedidosdecompra ped
