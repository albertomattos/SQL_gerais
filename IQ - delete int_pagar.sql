select codemp_d, num_docent, cgc, linha_txt from int_pagar where empresa = "001" and cod_lote = "00130823" order by num_docent
delete from int_pagar where empresa = "001" and cod_lote = "00130823" and linha_txt in ('30','37','20','31','38','28','35','24','27','34','39','29','36','41','32','40','33','42')
