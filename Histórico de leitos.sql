/*select * from falehcad where cod_pac = "F634661"

select cod_pac, leito, data, hora
from falehcad
where data between "01/01/2007" and "28/01/2008"
and cod_pac in (select cod_pac from falehcad where leito = "410") order by cod_pac, data, hora
*/

select * from falehcad where cod_apt = "412" order by data desc
select * from falehcad where leito = "ONCD1"
insert into falehcad values ('ONCD1','DC','G841894','17/09/2008','07:40','N','1','','DAYON',NULL,NULL)

update falehcad set cod_apt = "UCO" where cod_apt = "UCO1"
