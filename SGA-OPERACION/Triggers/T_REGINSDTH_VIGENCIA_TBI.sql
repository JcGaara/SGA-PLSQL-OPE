CREATE OR REPLACE TRIGGER OPERACION.t_REGINSDTH_VIGENCIA_TBI
 /**************************************************************************
   NOMBRE:     t_REGINSDTH_VIGENCIA_TBI
   PROPOSITO:  Cololar el correlativo en la tabla

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        13/11/2009  Marcos Echevarria creación del trigger
   **************************************************************************/

  BEFORE INSERT ON operacion.REGINSDTH_VIGENCIA
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
DECLARE
  id     number(15);
BEGIN

  if :new.IDVIGENCIA is null then
      SELECT OPERACION.SQ_REGINSDTH_VIGENCIA.nextval INTO :new.IDVIGENCIA FROM DUAL;
  end if;
END;
/



