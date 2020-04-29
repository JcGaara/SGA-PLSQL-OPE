CREATE OR REPLACE TRIGGER OPERACION.T_INSSRV_AI
after INSERT
ON OPERACION.INSSRV
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN

-- 10/12/2002 10:20 --
-- Inserta en la tabla TYSTIPSRV_ATENTION
--INICIO
    insert into inssrv_atention (CODINSSRV,CODSTATUS,CID)
    values (:new.codinssrv,:new.estinssrv,:new.cid);

--FIN
END;
/



