CREATE OR REPLACE TRIGGER OPERACION.SEQUENCE_EQU_DELETE
AFTER DELETE ON operacion.EFPTOEQU_STD
REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW
DECLARE

BEGIN
--Juan Tinoco creacion de la tabla
insert into PQT_EQU_SEQUENCE(IDPAQ,TIPCAMB,PUNTO,CODETA,OBSERVACION,TIPEQU,COSTO)
VALUES (:old.idpaq,2,:old.punto,:old.codeta,0,:old.tipequ,:old.costo);
END;
/


