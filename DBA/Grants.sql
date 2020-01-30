
grant create session to admvfr;

GRANT CREATE TABLE TO admvfr;

select 'grant select, insert, update, delete on '|| table_name ||' to admvfr;'
from user_tables  where table_name like 'LWS%SEQ'

Grant select on seq_name to user_name;
