set serverout on verify off linesize 1000 pagesize 1000;
DROP TABLE TBPK;
CREATE TABLE TBPK(TEXTO VARCHAR2(4000));
SPOOL REENG_PK.SQL;
accept v_tabela prompt 'Entre com o nome da tabela : '
accept v_owner  prompt 'Entre com o Schema.........: '
--- MXM --------------------------------------------
SELECT 'Data: '||TO_CHAR(SYSDATE,'DD/MM/YYYY') FROM DUAL;
---------------------------------------------------
--PRIMARY KEY--------------------------------------
---------------------------------------------------
declare
	v_tab		user_constraints.table_name%type;
	v_constraint	user_constraints.constraint_name%type;
	v_coluna	user_cons_columns.column_name%type;
	v_posicao	user_cons_columns.position%type;

	s_texto		varchar2(2000);
	s_colunas	varchar2(2000);
	s_verifica_coluna	user_cons_columns.column_name%type;
	s_verifica_tab	user_constraints.table_name%type;

	cursor pega_tb is 
		select table_name
		from all_tables
		where table_name LIKE upper('&v_tabela')
		and owner = '&v_owner';
	cursor pega_pk is
	select a.constraint_name, b.column_name, b.position
	from all_constraints a, all_cons_columns b
	where a.table_name = b.table_name
	  and a.constraint_name = b.constraint_name
          and a.owner = b.owner
	  and a.table_name = v_tab
          and a.owner = '&v_owner'
	  and constraint_type = 'P'
	order by b.position;
begin

	s_verifica_tab    := '';
	s_verifica_coluna := 'x';
	s_colunas 	  := ''; 	

	--DBMS_OUTPUT.ENABLE(20000);

	open pega_tb;
	fetch pega_tb into v_tab;

	while pega_tb%found loop

		open pega_pk;
		fetch pega_pk into v_constraint, v_coluna, v_posicao;

		while pega_pk%found loop

			    if s_verifica_coluna = 'x' then
				s_colunas := v_coluna;
			    else
				s_colunas := s_colunas||','||v_coluna;	
			    end if;
			    s_verifica_coluna := v_coluna;	
			fetch pega_pk into v_constraint, v_coluna, v_posicao;	
	        end loop;
		close pega_pk;

		s_texto := 'alter table '||v_tab||' add constraint '||v_tab||'_pkx primary key('||s_colunas||') using index tablespace mxmidad;';

		if s_colunas<> ' ' then
			INSERT INTO TBPK VALUES (S_TEXTO);
			--dbms_output.put_line(s_texto);
		end if;

		s_verifica_tab    := '';
		s_verifica_coluna := 'x';
		s_colunas 	  := ''; 	

	   	fetch pega_tb into v_tab;			
        end loop;
	close pega_tb;
end;
/
SELECT * FROM TBPK;
SPOOL OFF;
