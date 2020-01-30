select cod_com, descricao componente from lbcomcad
where cod_com not in (select cod_com from lbmatcom)
