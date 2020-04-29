CREATE OR REPLACE TRIGGER OPERACION.PLANO_AU
before UPDATE
ON PLANO REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW

/******************************************************************************
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------

    1        15/10/2009  Jimmy Farfán    REQ 104404: Tareas de GIS para
                                         Inventario de Planos
*******************************************************************************/
DECLARE

nSecuencial number;

BEGIN
  IF UPDATING('DIGITALIZACION') THEN
    if not nvl(:old.digitalizacion,0) = nvl(:new.digitalizacion,0) then
      INSERT INTO OPERACION.PLANOCHG (IDPLANO,  DIGITALIZACION )
      VALUES (:NEW.IDPLANO,  :new.DIGITALIZACION);
    end if;
  END IF;

END;
/



