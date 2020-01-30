select * from faprecad where tabela = "99" and codigo in (select codigo from faprdcad where tipo_prd in ("ULT","TOM","RAX"))
and validade = "01/03/2009"
update faprecad set valor = "0.0001" where tabela = "99" and codigo in (select codigo from faprdcad where tipo_prd in ("ULT","TOM","RAX"))
and validade = "01/03/2009";
update faprecad set coef_filme = 0 where tabela = "99" and codigo in (select codigo from faprdcad where tipo_prd in ("ULT","TOM","RAX"))
and validade = "01/03/2009";
update faprecad set coef_honor = "0.01" where tabela = "99" and codigo in (select codigo from faprdcad where tipo_prd in ("ULT","TOM","RAX"))
and validade = "01/03/2009";
update faprecad set custo_oper = 0 where tabela = "99" and codigo in (select codigo from faprdcad where tipo_prd in ("ULT","TOM","RAX"))
and validade = "01/03/2009";
update faprecad set qtd_inicial = 0 where tabela = "99" and codigo in (select codigo from faprdcad where tipo_prd in ("ULT","TOM","RAX"))
and validade = "01/03/2009";
update faprecad set qtd_subseq = 0 where tabela = "99" and codigo in (select codigo from faprdcad where tipo_prd in ("ULT","TOM","RAX"))
and validade = "01/03/2009";
update faprecad set valor_sub = 0 where tabela = "99" and codigo in (select codigo from faprdcad where tipo_prd in ("ULT","TOM","RAX"))
and validade = "01/03/2009";

select * from faprecad where tabela = "99" and codigo in (select codigo from faprdcad where tipo_prd in ("TOM"))
and validade = "01/03/2009"
