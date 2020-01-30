select modulo, funcao, apelido, sistema, data, complemento from falogcad, fausucad
where falogcad.matricula = fausucad.matricula
--and sistema='EST'
/*and funcao in ('ALT','EXC')*/
--and funcao = "INC"
--and modulo not in ('ESPED','ESCOM','ESEMP')
--and modulo = "FAMOV"
--and data >='2007-01-01 00:00:00'
and data between '2008-07-23 00:00:00' and '2008-07-23 23:00:00'
and complemento like '%ST%G611907%'
--and fausucad.apelido = "RODRIGUES"
order by data
