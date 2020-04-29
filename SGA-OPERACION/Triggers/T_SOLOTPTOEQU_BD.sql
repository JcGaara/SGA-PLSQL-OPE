CREATE OR REPLACE TRIGGER OPERACION.T_SOLOTPTOEQU_BD
BEFORE DELETE
ON OPERACION.SOLOTPTOEQU
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
ln_nro_res  number;

BEGIN

   if :old.nro_res is not null then
      RAISE_APPLICATION_ERROR(-20500,'Se tiene asociado una reserva, primero eliminar la reserva para borrar..');
   end if;
   
      if :old.nro_res_l is not null then
      RAISE_APPLICATION_ERROR(-20500,'Se tiene asociado una reserva leasing, primero eliminar la reserva para borrar..');
   end if;

END;
/



