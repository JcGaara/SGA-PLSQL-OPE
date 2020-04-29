CREATE OR REPLACE TRIGGER OPERACION.T_incidence_dth_bi
  /******************************************************************************
  REVISIONS:
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        05/08/2009  Juan Gallegos O. RQ98080 crear id secuencial a la tabla incidence_dth
  ******************************************************************************/
  BEFORE INSERT ON operacion.incidence_dth
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
DECLARE
  id number;
BEGIN

  if :new.idincdth is null then
    select sq_idincdth.nextval into id from dual;
    :new.idincdth := id;
  end if;

END;
/



