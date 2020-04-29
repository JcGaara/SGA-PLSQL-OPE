CREATE OR REPLACE PROCEDURE OPERACION.borravigresumen is
  maxid number;
  contid number;
  i number;
begin
  select max(id) into maxid from VIGRESUMEN;
  contid := 0;
  i:=0;
  while contid <= maxid loop
	  delete from VIGRESUMEN where id = contid;
    contid := contid + 1;
    if i=10000 then
    commit;
    i:=0;
    end if;
  end loop;
end borravigresumen;
/


