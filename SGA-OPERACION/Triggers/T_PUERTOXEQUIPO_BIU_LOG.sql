CREATE OR REPLACE TRIGGER OPERACION.t_puertoxequipo_BIU_log
AFTER INSERT or update or delete ON puertoxequipo    --
FOR EACH ROW
DECLARE  -- local variables
BEGIN
  if :old.estado <> :new.estado then
    INSERT INTO operacion.puertoxequipo_log    --(fecha,usuario,)
    VALUES  (sysdate,user,:NEW.CODPUERTO,:NEW.CODEQUIPO,:NEW.CODPRD,:NEW.CODTARJETA,
    :NEW.ESTADO,:NEW.IDE,:OLD.ESTADO);
  end if;
END ;
/



