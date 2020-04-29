CREATE OR REPLACE PROCEDURE OPERACION.p_verifica_det_requisicion
(numrequisicion in number, strestadolinea out string)


IS

   numverificar   number;
   intcodsolot    int;
   intpunto       int;
   intorden       int;
   strestado      varchar2(10);


   cursor cursor_detalles is
   select
      codsolot, punto, orden
   from financial.z_ps_transacciones_det_spw
   where
   id_requisicion = numrequisicion;

BEGIN


   open cursor_detalles;
   numverificar := 0;
   fetch cursor_detalles into intcodsolot,intpunto, intorden;

   loop
      select
        cab.id_requisicion, cab.estado_linea
      into
        numverificar, strestadolinea
      from
      financial.z_ps_transacciones_spw  cab,
      financial.z_ps_transacciones_det_spw det
      where
      cab.id_requisicion = det.id_requisicion
      and det.codsolot = intcodsolot
      and det.punto = intpunto
      and det.orden = intorden
      and cab.estado_linea in (1,3);



     fetch cursor_detalles into intcodsolot,intpunto, intorden;
     exit when  cursor_detalles %NOTFOUND;
   end loop;


END;
/


