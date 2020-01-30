--drop table solic_exames_ps
/*create table "ADMWPD".solic_exames_ps (
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
mes_ano varchar2(10)
) tablespace "WPDDADOS";

grant ALL on solic_exames_ps to wpd;*/

delete from solic_exames_ps;
insert into solic_exames_ps (select * from relporprofps);

--select t.*, t.rowid from solic_exames_ps t where t.mes_ano > '01/05/2015';
update solic_exames_ps set mes_ano = '01/01/2015' where mes_ano = '012015';
update solic_exames_ps set mes_ano = '01/02/2015' where mes_ano = '022015';
update solic_exames_ps set mes_ano = '01/03/2015' where mes_ano = '032015';
update solic_exames_ps set mes_ano = '01/04/2015' where mes_ano = '042015';
update solic_exames_ps set mes_ano = '01/05/2015' where mes_ano = '052015';
update solic_exames_ps set mes_ano = '01/06/2015' where mes_ano = '062015';
update solic_exames_ps set mes_ano = '01/07/2015' where mes_ano = '072015';
update solic_exames_ps set mes_ano = '01/08/2015' where mes_ano = '082015';
update solic_exames_ps set mes_ano = '01/09/2015' where mes_ano = '092015';
update solic_exames_ps set mes_ano = '01/10/2015' where mes_ano = '102015';
update solic_exames_ps set mes_ano = '01/11/2015' where mes_ano = '112015';
update solic_exames_ps set mes_ano = '01/12/2015' where mes_ano = '122015';
delete from solic_exames_ps where mes_ano <> '01/06/2015';
commit;
select * from solic_exames_ps where length(mes_ano)=6
delete from solic_exames_ps where length(mes_ano)=6
