ALTER TABLE faprocad
MODIFY (nome_pro VARCHAR2(70) NOT NULL);

CONSTRAINT Check_Code check (Code LIKE '[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9]')

--alter table faprocad add constraint ck_nome_pro check (REGEXP_LIKE(nome_pro,'[[:alpha:]]{70}'));
alter table faprocad add constraint ck_nome_pro check (REGEXP_LIKE(nome_pro, '[^0-9]'));
--This checks that there are 70 alphabetic characters.

REGEXP_LIKE(PROD_NUM, '^[[:digit:]]{9}$')
alter table faprocad drop constraint ck_nome_pro;