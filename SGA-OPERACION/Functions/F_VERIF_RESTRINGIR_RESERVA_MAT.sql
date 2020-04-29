CREATE OR REPLACE FUNCTION OPERACION.F_VERIF_RESTRINGIR_RESERVA_MAT
RETURN NUMBER IS

/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        02/12/2008  Hector Huaman M. Devuelve:
                                           0 = El usuario no esta restringido el acceso para Reserva de Equipos
                                           1 = El usuario debe tener restringido el acceso para Reserva de Equipos
******************************************************************************/

ln_resultado number;
ln_cont number;

BEGIN
   ln_resultado := 0;
   --Verificacion de Restriccion
   select count(*) into ln_cont from accusudpt
   where codusu = user and tipo = 12;

  -- Si tiene registrado un tipo 12, entonces no podra realizar Generar de Reservas de Materiales
   if ln_cont > 0 then
      ln_resultado := 1;
   end if;

   return(ln_resultado);
END;
/


