CREATE OR REPLACE FUNCTION OPERACION.F_VERIFICA_ESTADO_SER_CONAX(NUMREGINSTAL IN VARCHAR2)
RETURN NUMBER IS
---------------------------------------------------------------------------------------
--ln_resultado :  0 = ESTADO DEL SERVICIO DE INSTALACION DEL CLIENTE CON ERRORES
--ln_resultado :  1 = ESTADO DEL SERVICIO DE INSTALACION DEL CLIENTE OK
---------------------------------------------------------------------------------------
ln_totalreg     number;
ln_totalregok   number;
ln_resultado    number;



BEGIN
   ln_resultado := 0;

   -- NÚMERO DE ARCHIVOS ENVIADOS A CONAX PARA LA INSTALACION DE UN CLIENTE
   select count(*) into ln_totalreg from operacion.reg_archivos_enviados
   where numregins = NUMREGINSTAL;

  -- NÚMERO DE ARCHIVOS ENVIADOS A CONAX PARA LA INSTALACION DE UN CLIENTE EN ESTADO : PROCESADO OK
   select count(*) into ln_totalregok from operacion.reg_archivos_enviados
   where numregins = NUMREGINSTAL and estado = 2;

   if ln_totalreg = ln_totalregok  and ln_totalregok >0 then
      ln_resultado := 1;
   end if;

   return(ln_resultado);
END;
/


