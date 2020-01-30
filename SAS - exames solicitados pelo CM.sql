-- Mudar a data do último delete...
delete from solic_exames_cm;
insert into solic_exames_cm (select * from relporprof);

--select t.*, t.rowid from solic_exames_cm t where t.mes_ano > '01/05/2015';
update solic_exames_cm set mes_ano = '01/01/2015' where mes_ano = '012015';
update solic_exames_cm set mes_ano = '01/02/2015' where mes_ano = '022015';
update solic_exames_cm set mes_ano = '01/03/2015' where mes_ano = '032015';
update solic_exames_cm set mes_ano = '01/04/2015' where mes_ano = '042015';
update solic_exames_cm set mes_ano = '01/05/2015' where mes_ano = '052015';
update solic_exames_cm set mes_ano = '01/06/2015' where mes_ano = '062015';
update solic_exames_cm set mes_ano = '01/07/2015' where mes_ano = '072015';
update solic_exames_cm set mes_ano = '01/08/2015' where mes_ano = '082015';
update solic_exames_cm set mes_ano = '01/09/2015' where mes_ano = '092015';
update solic_exames_cm set mes_ano = '01/10/2015' where mes_ano = '102015';
update solic_exames_cm set mes_ano = '01/11/2015' where mes_ano = '112015';
update solic_exames_cm set mes_ano = '01/12/2015' where mes_ano = '122015';
delete from solic_exames_cm where mes_ano <> TO_CHAR(sysdate, 'DD/MM/YYYY');
commit;

select * from solic_exames_cm where mes_ano = TO_CHAR(sysdate, 'DD/MM/YYYY')

SELECT TO_CHAR(sysdate, 'DD/MM/YYYY') FROM dual;
