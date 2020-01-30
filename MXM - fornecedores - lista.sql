select f.for_codigo,f.for_nome,f.for_nomefant,f.for_cgc,f.for_inscricao,f.for_email,f.for_tel,f.for_fax,f.for_endereco,
f.for_cidade,f.for_bairro,f.for_cep,f.for_uf,
c.fcc_nmbanco,c.fcc_agencia,c.fcc_conta,
t.ftb_nocontab,t.ftb_nocontabant, f.for_respcad
from fornec_for f, forcc_fcc c, forctb_ftb t
where c.fcc_cdclifor = f.for_codigo
and t.ftb_codfor = f.for_codigo
--and for_respcad = 'ROBERTA'
--and c.fcc_conta not like '%-%'
order by for_respcad, for_codigo
select for_codigo, for_cgc, FOR_NOME from fornec_for where for_respcad = 'ROBERTA' order by for_nome