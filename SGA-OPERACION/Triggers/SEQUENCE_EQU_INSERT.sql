CREATE OR REPLACE TRIGGER OPERACION.SEQUENCE_EQU_INSERT
AFTER INSERT ON operacion.EFPTOEQU_STD
REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW
DECLARE

BEGIN
--Juan Tinoco creacion de la tabla
insert into PQT_EQU_SEQUENCE(IDPAQ,TIPCAMB,PUNTO,CODETA,OBSERVACION,TIPEQU,COSTO)
VALUES (:new.idpaq,1,:new.punto,:new.codeta,0,:new.tipequ,:new.costo);
END;
/



