drop table solic_exa_cdi;
create table "ADMWPD".solic_exa_cdi (
cod_pro varchar2(6),
nome_pro varchar2(70) not null,
count_exa_cdi number(4,0),
mes_ano date,
count_consultas number(4,0)
) tablespace "WPDDADOS";

grant ALL on solic_exa_cdi to wpd;

/*insert into relporprof (cod_pro, nome_pro) 
(select cod_pro, nome_pro from faprocad where inativo = 'N' and cod_profissao = 'MEDC');*/

select t.*, t.rowid from solic_exa_cdi t;
commit;
