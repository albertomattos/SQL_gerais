set serverout on verify OFF HEADING OFF linesize 1000 pagesize 1000;
accept v_tabela prompt 'nome da tabela: '
drop table REENG_INDICES;
CREATE TABLE REENG_INDICES
(TEXTO VARCHAR2(2000));

---------------------------------------------------
---------------------------------------------------
--INDÍCES--------------------------------------
---------------------------------------------------
declare
	v_tab		user_constraints.table_name%type;
	v_indexname	user_constraints.constraint_name%type;
	v_ind		user_constraints.constraint_name%type;
	v_coluna	user_cons_columns.column_name%type;
	v_posicao	user_cons_columns.position%type;

	s_texto1	varchar2(2000);
	s_colunas	varchar2(2000);
	s_verifica_ind 	user_indexes.table_name%type;
	s_verifica_coluna	user_ind_columns.column_name%type;
	s_verifica_tab	user_indexes.table_name%type;

	cursor pega_tb is 
		select index_name,table_name
		from user_indexes
		where table_name LIKE upper('&v_tabela')
		  and not index_name like '%PKX'
                  and index_name not in (select constraint_name 
					 from user_constraints
 					 where constraint_type IN ('P','U')
 					);
	
	cursor pega_ind is
	select a.index_name, b.column_name, b.column_position
	from user_indexes a, user_ind_columns b
	where a.table_name = b.table_name
	  and a.index_name = b.index_name
	  and a.index_name = v_ind
          and a.table_name = v_tab
	order by b.column_position;
begin

	s_verifica_tab    := '';
	s_verifica_coluna := 'x';
	s_colunas 	  := ''; 	
	s_verifica_ind    := '';
	--DBMS_OUTPUT.ENABLE(20000);

	open pega_tb;
	fetch pega_tb into v_ind,v_tab;

	while pega_tb%found loop

		open pega_ind;
		fetch pega_ind into v_indexname, v_coluna, v_posicao;
		s_verifica_ind := v_indexname;
		while pega_ind%found loop

			    if s_verifica_coluna = 'x' then
				s_colunas := v_coluna;
			    else
				s_colunas := s_colunas||','||v_coluna;	
			    end if;

			    s_verifica_coluna := v_coluna;	

			fetch pega_ind into v_indexname, v_coluna, v_posicao;	
	        end loop;
		close pega_ind;

		if s_colunas <> ' ' then
			s_texto1 := 'create index '||v_indexname||' on '||v_tab||'('||s_colunas||') tablespace mxmidad;';
    			insert into REENG_INDICES(texto) values(s_texto1);
    			commit;	
			s_verifica_tab    := '';
			s_verifica_coluna := 'x';
			s_colunas 	  := ''; 
		end if;

		s_verifica_tab    := '';
		s_verifica_coluna := 'x';
		s_colunas 	  := ''; 	

	   	fetch pega_tb into v_ind,v_tab;			
        end loop;
	close pega_tb;
end;
/
SPOOL REL_REENG_IND.SQL;
--- MXM --------------------------------------------
SELECT 'Data: '||TO_CHAR(SYSDATE,'DD/MM/YYYY') FROM DUAL;
---------------------------------------------------
select * from reeng_indices
order by 1;
SPOOL OFF;

ED REL_REENG_IND.SQL