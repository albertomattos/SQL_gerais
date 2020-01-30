select * from faususis

insert into faususis values ('LAB','WPD','1',NULL)

update faususis set cod_grupo = 'WPD' where cod_grupo = 'ADM'

select * from fapricad where cod_grupo = 'WPD'

update fapricad set privilegio = '9' where cod_grupo = 'WPD'
