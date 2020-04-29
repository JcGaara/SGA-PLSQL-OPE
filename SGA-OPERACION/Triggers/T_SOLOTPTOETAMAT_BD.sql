CREATE OR REPLACE TRIGGER OPERACION.t_solotptoetamat_bd
BEFORE DELETE ON OPERACION.solotptoetamat
FOR EACH ROW
DECLARE
ln_nro_res  number;

BEGIN

   if :old.nro_res is not null then
      RAISE_APPLICATION_ERROR(-20500,'Se tiene asociado una reserva, primero eliminar la reserva para borrar..');
   end if;

END;
/



