select modulo, funcao, apelido, sistema, data, complemento from falogcad t, fausucad u
where t.matricula = u.matricula
and sistema = 'EST'
and funcao in ('ALT','EXC')
and modulo like 'ESCOT'
and data between '13/12/2013' and '14/12/2013'
and complemento like '%COTA%'
and u.apelido like 'PRISCILA%'
order by data
