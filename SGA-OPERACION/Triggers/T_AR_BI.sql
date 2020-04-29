CREATE OR REPLACE TRIGGER OPERACION.T_AR_BI
BefORE INSERT
ON OPERACION.AR
RefERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN
   tmpVar := 0;
   Select DOCID.NextVal into tmpVar from dual;
   insert into DOC (docid,doctipid) values (tmpVar,4);  -- inserta en la tabla documentos
   :NEW.docid := tmpVar;
   insert into DOCESTHIS (docid,docest,docestold,fecha) values (:NEW.docid,:NEW.ESTAR,null,:new.fecusu);
   EXCEPTION
     WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR (-20500, 'No se pudo insertar el correspondiente documento');
END;
/



