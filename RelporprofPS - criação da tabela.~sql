--drop table relporprofps
create table "ADMWPD".relporprofps (
desc_esp varchar2(30),
cod_pro varchar2(6),
nome_pro varchar2(70) not null,
count_exa_cdi number(4,0),
count_exa_rax number(4,0),
count_exa_rem number(4,0),
count_exa_tom number(4,0),
count_exa_usg number(4,0),
count_exa_end number(4,0),
count_exa_lab number(5,0),
count_cirurgias number(4,0),
count_consultas number(4,0),
mes_ano date
) tablespace "WPDDADOS";

--alter table relporprofps add count_exa_lab number(4,0);

grant ALL on relporprofps to wpd;

/*insert into relporprofps (cod_pro, nome_pro) 
(select cod_pro, nome_pro from faprocad where inativo = 'N' and cod_profissao = 'MEDC');*/

select * from relporprofps;
commit;
