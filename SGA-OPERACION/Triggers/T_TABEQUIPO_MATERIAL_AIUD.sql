create or replace trigger OPERACION.T_TABEQUIPO_MATERIAL_AIUD
   after insert or update or delete
   on OPERACION.TABEQUIPO_MATERIAL
   referencing old as old new as  new
   for each row
/*------------------------------------------------------------------------------------------
    TRIGGER: OPERACION.T_TABEQUIPO_MATERIAL_AIUD
    MODIFICATION HISTORY
    Person       	Date        Comments
    ---------    	----------  --------------------------------------------------------------
    Mauro Zegarra	31/10/2011   Creacion
-------------------------------------------------------------------------------------------*/
declare
lc_usuario_log 	varchar2(100);
lc_accion      	char(1);
idlog          	number(18);

begin

   select HISTORICO.SQ_TABEQUIPO_MATERIAL_LOG.nextval into idlog from DUAL;

   select max(osuser) into lc_usuario_log
      from v$session
      where audsid = ( select userenv('sessionid') from dual);

   lc_usuario_log := trim(rpad(user||'-'||lc_usuario_log,50));

   if inserting then
      lc_accion := 'I';
      insert into HISTORICO.TABEQUIPO_MATERIAL_LOG(
                                ID,
                                IDEQUIPO,
                                NUMERO_SERIE,
                                IMEI_ESN_UA,
                                TIPO,
                                CODALMACEN,
                                ESTADO,
                                FEC_INGRESO,
                                USUREG,
                                FECREG,
                                TIPO_LOG)
                         values(
								idlog,
                                :new.IDEQUIPO,
                                :new.NUMERO_SERIE,
                                :new.IMEI_ESN_UA,
                                :new.TIPO,
                                :new.CODALMACEN,
                                :new.ESTADO,
                                :new.FEC_INGRESO,
                                lc_usuario_log,
								SYSDATE,
                                lc_accion
								);
    elsif updating or deleting then
      if updating then
         lc_accion := 'U';
      elsif deleting then
         lc_accion := 'D';
      end if;
      insert into HISTORICO.TABEQUIPO_MATERIAL_LOG(
                                ID,
                                IDEQUIPO,
                                NUMERO_SERIE,
                                IMEI_ESN_UA,
                                TIPO,
                                CODALMACEN,
                                ESTADO,
                                FEC_INGRESO,
                                USUREG,
                                FECREG,
                                TIPO_LOG)
                         values(
								idlog,
                                :old.IDEQUIPO,
                                :old.NUMERO_SERIE,
                                :old.IMEI_ESN_UA,
                                :old.TIPO,
                                :old.CODALMACEN,
                                :old.ESTADO,
                                :old.FEC_INGRESO,
								lc_usuario_log,
								SYSDATE,
                                lc_accion
                                );
      end if;
end;
/