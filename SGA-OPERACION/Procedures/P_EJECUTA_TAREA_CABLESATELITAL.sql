CREATE OR REPLACE PROCEDURE OPERACION.P_EJECUTA_TAREA_CABLESATELITAL
is

l_cont1 number;
------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
/*c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.P_EJECUTA_TAREA_CABLESATELITAL';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='662';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );*/
------------------------------------

l_codsolot solot.codsolot%type;
cursor c_tmp is
select numregistro,codsolot from reginsdth where estado = '02' and flg_facturable=1 and flg_validado=1 and codsolot is not null order by numregistro;
begin

     for lc_tmp in c_tmp loop
     --Modificado MBALCAZAR 31/07/08 - Inicio
           select count(*)  into  l_cont1 from tareawf where esttarea in (1,2,4) and tareadef=299 and idwf in (select idwf from wf where valido=1 and codsolot=lc_tmp.codsolot );
           if l_cont1 > 0 then
                       operacion.P_EJECUTA_CABLESATELITAL_DET(lc_tmp.codsolot);
                       commit;
           end if;
      --Modificado MBALCAZAR 31/07/08 - Fin
      end loop;

-- Este codigo se debe poner en todos los stores que se llaman con un job para ver si termino satisfactoriamente
/*sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);
------------------------------
exception
  when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);*/
end;
/


