CREATE OR REPLACE FUNCTION OPERACION.f_get_PREUBI return number is
                      result number;
 begin
  select nvl(max(IDUBI),0) + 1
                       into result from PREUBI;
                           return (result);
 end;
/


