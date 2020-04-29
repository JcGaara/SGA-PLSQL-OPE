begin
delete opedd 
where tipopedd = (select tipopedd from tipopedd where abrev like 'PAR_PLATAF_JANUS')
and abreviacion = 'P_COD_CUENTA';

commit;
end;
/