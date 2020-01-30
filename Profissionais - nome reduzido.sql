/*select t.crm, t.nome_pro, t.nome_reduzido, t.rowid from faprocad t where cod_profissao = 'MEDC' and t.inativo = 'N'
and cod_pro in (select cod_pro from faesppro where cod_esp in (select cod_esp from faespcad where descricao like 'CIRURG%'))
order by t.nome_pro

select t.nome_pro, t.nome_reduzido, t.rowid from faprocad t where t.nome_reduzido is null
and t.cod_profissao = 'MEDC' and t.inativo = 'N'
*/
--Buscar nomes sem sobrenome
select t.nome_pro, t.nome_reduzido, t.rowid from faprocad t where instr(t.nome_reduzido,' ',5,1)='0'
and t.cod_profissao = 'MEDC' and t.inativo = 'N'

--Retirar espaços em branco do final do campo
--UPDATE faprocad SET nome_reduzido=RTRIM(nome_reduzido) where nome_pro like 'ODIR DE SOUZA%'

-- Verificar profissionais com pacientes no momento
select DISTINCT b.nome_reduzido from fapaccad a, faprocad b
where a.cod_pro_sa = b.cod_pro
and a.data_alta is null and a.tipo_pac = 'I' AND A.LEITO NOT LIKE 'P%' ORDER BY 1
