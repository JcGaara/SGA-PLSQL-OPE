CREATE OR REPLACE TRIGGER OPERACION.t_reginsdth_TBU
  BEFORE UPDATE ON operacion.reginsdth
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW

 /**************************************************************************
   NOMBRE:     T_REGINSDTH_TBU
   PROPOSITO:  Actualizar informacion de la tabla

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        23/04/2009  Miguel Londoña    Cambio en el calculo de dias de vigencia en nueva activacion REQ. XXXXX
   2.0        13/11/2009  Marcos Echevarria El estado se actualizará cuando se hace un corte o reconexion REQ. 108907
   **************************************************************************/
DECLARE
  ln_diasalerta number;
  ln_diasgracia number;
  ln_diasvigencia number;
  max_IDVIGENCIA number;
BEGIN

   if updating('fecactconax') then
     if :new.fecinivig is null then
        :new.fecinivig := trunc(:new.fecactconax);
        --<1.0
        ln_diasvigencia:= billcolper.f_parametrosfac(655);
        :new.fecfinvig := :new.fecinivig + ln_diasvigencia;
        --:new.fecfinvig := :new.fecinivig + 30;
        ln_diasalerta  := billcolper.f_parametrosfac(651); -- dias previos a fin para generar alerta
        :new.fecalerta := :new.fecinivig + ln_diasvigencia - ln_diasalerta;
        --:new.fecalerta := :new.fecinivig + 30 - ln_diasalerta;
        ln_diasgracia  := billcolper.f_parametrosfac(652); -- dias despues a fin para generar corte
        :new.feccorte  := :new.fecinivig + ln_diasvigencia + ln_diasgracia;
        --:new.feccorte  := :new.fecinivig + 30 + ln_diasgracia;
        --1.0>
        :new.mesessinsrv    := 0;
     end if;
   end if;

   if updating('estado') then
     :new.fecusumod := sysdate;
     :new.codusumod := user;
     if :old.estado != :new.estado then
        insert into operacion.log_reginsdth(numregistro,estado,codusumod,fecusumod)
        values(:old.numregistro,:old.estado,:old.codusumod,:old.fecusumod);
        -- Se modifica tambien el registro en la base de datos PESGAINT a fin de
        -- que los estados se encuentren actualizados.
        update reginsdth_web
           set estado = :new.estado
         where numregistro = :new.numregistro;
         --<2.0>
         if ((nvl(:new.flg_recarga,0) = 1) and (:old.estado in ('13','14')) and (:new.estado in ('16','17')) )then
            begin
               select max(IDVIGENCIA) into max_IDVIGENCIA
               from REGINSDTH_VIGENCIA
               where numregistro= :new.numregistro
               and estado_new= :old.estado;
            exception
              when no_data_found then
                   max_IDVIGENCIA:= 0;
            end;
            if (max_IDVIGENCIA > 0) then
             update REGINSDTH_VIGENCIA set estado_new = :new.estado where IDVIGENCIA=max_IDVIGENCIA;
            end if;
         end if;
         --</2.0>
     end if;
   end if;

END;
/



