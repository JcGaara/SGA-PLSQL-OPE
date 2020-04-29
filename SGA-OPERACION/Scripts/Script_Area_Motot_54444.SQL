-- insert areaope,motot
insert into areaope
(area,descripcion,flgderprv,estado,FLGCC)
select 
       (select max(area)+ 1 from areaope),
       'PORTABILIDAD Y DESPACHO',1,1,1
from dual;
commit;

declare
  ln_secuencia number:= 0;
  cursor c1 is
   select codmotot  
   from motot order by codmotot;
begin
   for r in c1 loop
       ln_secuencia := ln_secuencia + 1;
       if r.codmotot <> ln_secuencia then
          INSERT INTO MOTOT 
          (CODMOTOT,DESCRIPCION,FLGCOM,TIPMOTOT)
          VALUES
          (ln_secuencia,'Solicitud Cliente - Portabilidad',1,1);
          COMMIT;
          GOTO SALTA;
       end if;
   end loop;
   <<SALTA>>
    ln_secuencia := 0;
end;
/
