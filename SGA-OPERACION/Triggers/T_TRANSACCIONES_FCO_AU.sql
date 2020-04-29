CREATE OR REPLACE TRIGGER OPERACION.T_TRANSACCIONES_FCO_AU
AFTER UPDATE
ON OPERACION.TRANSACCIONES_FCO
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
/********************************************************************************
     Creacion
     Ver     Fecha          Autor             Descripcion
    ------  ----------  ----------       --------------------
     1.0     05/03/2010  Hector Huaman  M   REQ-94683: Creación
 ********************************************************************************/

BEGIN
  IF UPDATING ('ESTTRANSFCO') THEN
     if :new.esttransfco= 5 then
        update fco.suspension_old set estado=1 where idsuspension_old=:old.idsuspension_old;
     end if;
  END IF;

  IF UPDATING ('CODSOLOT') THEN
     if :new.codsolot is not null  then
        update fco.suspension_old set estado=0 where idsuspension_old=:old.idsuspension_old;
     end if;
  END IF;

END;
/



