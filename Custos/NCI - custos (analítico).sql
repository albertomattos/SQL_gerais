--Script Interact:
select sum(valor) from usr_nci.custo_por_cc@nci where cod_cliente = '0303'
and data_custo >= $COMPETENCE_FROM
and data_custo <= $COMPETENCE_UNTIL

/*create table "USR_NCI".custo_por_cc (
ano_mes varchar2(6),
data_custo date,
cod_cliente varchar2(4),
descricao varchar2(40),
valor number(12,2)
) tablespace "TS_NCI";

--grant ALL on solic_exa_cdi to wpd;
*/
delete from custo_por_cc;
insert into custo_por_cc (ano_mes, cod_cliente, descricao, valor)
(
select distinct b.ano_mes, a.cod_cliente, a.descricao, sum(b.valor) tot
from vec_Ccus a, ccu_mcdc b,ccu_ccic c, ccu_cust d
where b.ano_mes >= '201501' and b.ano_mes <= '201505'
  and a.codigo = b.cod_ccu
  and b.cod_ccu = c.cod_ccu
  and b.cod_cus = c.cod_cus
  and c.cod_cus = d.cod_cus
group by b.ano_mes, a.cod_cliente, a.descricao
union
select distinct b.ano_mes, a.cod_cliente, a.descricao, sum(b.valor) tot
from vec_Ccus a, ccu_mcic b, ccu_ccic c, ccu_cust d
where b.ano_mes >= '201501' and b.ano_mes <= '201505'
  and a.codigo = b.cod_ccu
  and b.cod_ccu = c.cod_ccu
  and b.cod_cus = c.cod_cus
  and c.cod_cus = d.cod_cus
group by b.ano_mes, a.cod_cliente, a.descricao
)

update custo_por_cc set data_custo = '01/01/2015' where ano_mes = '201501';
update custo_por_cc set data_custo = '01/02/2015' where ano_mes = '201502';
update custo_por_cc set data_custo = '01/03/2015' where ano_mes = '201503';
update custo_por_cc set data_custo = '01/04/2015' where ano_mes = '201504';
update custo_por_cc set data_custo = '01/05/2015' where ano_mes = '201505';
update custo_por_cc set data_custo = '01/06/2015' where ano_mes = '201506';
update custo_por_cc set data_custo = '01/07/2015' where ano_mes = '201507';
update custo_por_cc set data_custo = '01/08/2015' where ano_mes = '201508';
update custo_por_cc set data_custo = '01/09/2015' where ano_mes = '201509';
update custo_por_cc set data_custo = '01/10/2015' where ano_mes = '201510';
update custo_por_cc set data_custo = '01/11/2015' where ano_mes = '201511';
update custo_por_cc set data_custo = '01/12/2015' where ano_mes = '201512';
commit;
