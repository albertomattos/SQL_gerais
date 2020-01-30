    select sum(count_exa_cdi) soma
    from admwpd.solic_exa_cdi@prod a
    where a.mes_ano between '01/07/2015' and '31/07/2015'

select t.*, t.rowid from solic_exa_cdi t;
select * from relporprof where mes_ano = '072015'
