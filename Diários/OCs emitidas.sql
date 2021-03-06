drop table ordensdecompra;
create global temporary table ordensdecompra (tipo_prd varchar2(3), valor_tot number(9,2));
insert into ordensdecompra(tipo_prd, valor_tot) 
select v.tipo_prd,
       decode(v.tipo_prd, 'DES', sum(u.valor_tot),
                          'MED', sum(u.valor_tot),
                          'MHL', sum(u.valor_tot),
                          'MMA', sum(u.valor_tot),
                          'OBR', sum(u.valor_tot),
                          'OPM', sum(u.valor_tot),
                          'MEX', sum(u.valor_tot),
                          'GAS', sum(u.valor_tot),
                          'FIO', sum(u.valor_tot),
                          '9999999,99') "QTDE"
from esmovcad t, esmovite u, faprdcad v, fatipcad w
where t.tipo_documento = u.tipo_documento and t.documento = u.documento
and u.cod_prd = v.codigo and v.tipo_prd = w.tipo_prd and w.natureza is null
and t.data_mov between '01/10/2012' and '10/10/2012' and u.tipo_documento = 'PED'
group by v.tipo_prd
union
select 'OUT', sum(u.valor_tot) from esmovcad t, esmovite u, faprdcad v, fatipcad w
where t.tipo_documento = u.tipo_documento and t.documento = u.documento
and u.cod_prd = v.codigo and v.tipo_prd = w.tipo_prd and w.natureza is null
and t.data_mov between '01/10/2012' and '10/10/2012' and u.tipo_documento = 'PED'
and v.tipo_prd in ('FNU','ICC','MAT','IMO','EQU','LAB');
select * from ordensdecompra where valor_tot <> '9999999,99' order by tipo_prd;
