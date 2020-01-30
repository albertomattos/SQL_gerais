select distinct uni_estoqu, count (uni_estoqu) from faprdcad where bloqueado = 'N'
group by uni_estoqu
order by uni_estoqu
order by count(uni_estoqu) desc

update faprdcad set uni_estoqu = 'UN' where uni_estoqu = 'UND'

select * from faprdcad where uni_estoqu = 'BB'

select distinct uni_compra, count (uni_compra) from faprdcad where bloqueado = 'N'
group by uni_compra
order by uni_compra
order by count(uni_compra) desc

update faprdcad set uni_compra = 'UN' where uni_compra = 'UND'

update faprdcad set uni_distri = 'UN' where uni_distri = 'UND'

select * from faprdcad

 where uni_compra = 'BB'

select tipo_prd, descricao, data_cad, codigo from faprdcad where data_cad >= '24/03/2011' order by tipo_prd, descricao

select ult_compra, descricao, codigo from faprdcad where descricao like 'CARTUCHO%' order by ult_compra

update faprdcad set tipo_prd = 'STI' where descricao like 'CARTUCHO%' and tipo_prd = 'ESC'

update faprdcad set descricao = replace (descricao, 'TONNER', 'TONER') where descricao like 'TONNER%' and tipo_prd = 'STI'
