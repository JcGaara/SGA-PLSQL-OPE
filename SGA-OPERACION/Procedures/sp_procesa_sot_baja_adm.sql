create or replace procedure operacion.sp_procesa_sot_baja_adm(av_sot_baja operacion.solot.codsolot%type,
                                                              an_error    out integer,
                                                              av_error    out varchar2) is

 /*******************************************************************************************************
   NOMBRE:       OPERACION.PQ_IW_SGA_BSCS
   PROPOSITO:    Paquete de objetos necesarios para la Conexion del SGA - BSCS
   REVISIONES:
   Version    Fecha       Autor            Solicitado por    Descripcion
   ---------  ----------  ---------------  --------------    -----------------------------------------
    1.0            					                                 Creación
    2.0       17/02/2016  Alfonso Muñante                    SGA-SD-438726-1
  *******************************************************************************************************/


															  
  cn_estcerrado constant number := 4;
  ln_tareadef number;
  le_regularizacion exception;

  cursor c_solot(an_tareadef number) is
    select c.idtareawf, c.mottarchg, c.idwf, c.tarea, c.tareadef
      from solot a, wf b, tareawf c
     where a.codsolot = b.codsolot
       and b.idwf = c.idwf
       and c.tareadef = an_tareadef
       and b.valido = 1
       and a.estsol = 17
       and c.esttarea = 1
       and a.codsolot = av_sot_baja;

begin
  -- Alineamos la SOT de Baja
  OPERACION.PQ_SGA_BSCS.P_REGULARIZA_SOT_BAJA (av_sot_baja, an_error, av_error);

  IF an_error <> 0 THEN
     RAISE le_regularizacion;
  END IF;

  ln_tareadef := 448;  --Liberar recursos asignados
  FOR c_tarea IN c_solot(ln_tareadef) LOOP
      PQ_WF.P_CHG_STATUS_TAREAWF(c_tarea.idtareawf,
                                 cn_estcerrado,
                                 cn_estcerrado,
                                 c_tarea.mottarchg,
                                 sysdate,
                                 sysdate);
  end loop;

  ln_tareadef := 1012; --Liberar Números Telefónicos
  FOR c_tarea IN c_solot(ln_tareadef) LOOP
      PQ_WF.P_CHG_STATUS_TAREAWF(c_tarea.idtareawf,
                                 cn_estcerrado,
                                 cn_estcerrado,
                                 c_tarea.mottarchg,
                                 sysdate,
                                 sysdate);
  end loop;

  ln_tareadef := 299; --Activación/Desactivación del servicio
  FOR r_solot IN c_solot(ln_tareadef) LOOP
    BEGIN
      operacion.pq_solot.p_activacion_automatica(r_solot.idtareawf,
                                                 r_solot.idwf,
                                                 r_solot.tarea,
                                                 r_solot.tareadef);
      --Cerramos la baja administrativa
      PQ_WF.P_CHG_STATUS_TAREAWF(r_solot.idtareawf,
                                 cn_estcerrado,
                                 cn_estcerrado,
                                 r_solot.mottarchg,
                                 sysdate,
                                 sysdate);
    end;
  end loop;



  an_error := 1;
  av_error := 'OK';

exception
  when le_regularizacion then
    an_error := -1;
    rollback;
    raise_application_error(-20500,
                            'Error Ejecutar proceso sp_procesa_sot_baja_adm ' ||
                            av_error || ' - Linea (' ||
                            dbms_utility.format_error_backtrace || ')');          
  when others then
    an_error := sqlcode;
    av_error := sqlerrm;
    rollback;
    raise_application_error(-20500,
                            'Error Ejecutar proceso sp_procesa_sot_baja_adm ' ||
                            av_error  || ' - Linea (' ||
                            dbms_utility.format_error_backtrace || ')');
end;
/