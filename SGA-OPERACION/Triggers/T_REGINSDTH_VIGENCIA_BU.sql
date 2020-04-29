CREATE OR REPLACE TRIGGER OPERACION.t_reginsdth_vigencia_bu
  before update on operacion.reginsdth_vigencia
  referencing old as old new as new
  for each row
  /*********************************************************************************************
    NOMBRE:            operacion.t_reginsdth_vigencia_bu
    PROPOSITO:
    REVISIONES:
    Ver        Fecha        Autor           Descripcion
    ---------  ----------  ---------------  -----------------------------------
    1.0        24/08/2010  Edson Caqui      Creacion RQ 98790
  ***********************************************************************************************/
declare
begin
  :new.usumod := user;
  :new.fecmod := sysdate;
end;
/



