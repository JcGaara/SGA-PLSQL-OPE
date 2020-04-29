CREATE OR REPLACE PROCEDURE OPERACION.P_EJECUTA_INTER_SAPSGA_PEP2 is


--------------------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
/*c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.P_EJECUTA_INTER_SAPSGA_PEP2';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='234';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );*/
--------------------------------------------------


l_pid number;
CURSOR c1 IS
select * from TMP_INTERFACE_SAPSGA_PEP2 where estado = 0;
begin
    FOR reg IN c1 LOOP
        pq_z_ps_proyectossap.p_screa_def_pep_ef(reg.A_NUMSCL,reg.A_CODSOLOT,reg.A_CFG,l_pid);
        update TMP_INTERFACE_SAPSGA_PEP2
        set estado = 1, fechaejecucion=sysdate
        where A_NUMSCL = reg.A_NUMSCL AND A_CODSOLOT = reg.A_CODSOLOT and A_CFG = reg.A_CFG ;
    END LOOP;
    commit;

--------------------------------------------------
---ester codigo se debe poner en todos los stores 
---que se llaman con un job
--para ver si termino satisfactoriamente
/*sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);

------------------------      
exception  
  when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);*/

end;
/


