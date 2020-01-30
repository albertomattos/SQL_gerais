select t.*, t.rowid from sasprod.cmn_employments t

update bsc_indicators set ac_input = ' ' where ac_input is null;
