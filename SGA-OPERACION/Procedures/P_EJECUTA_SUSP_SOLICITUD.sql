CREATE OR REPLACE PROCEDURE OPERACION.P_EJECUTA_SUSP_SOLICITUD IS
  /******************************************************************************
     Ver        Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
     1.0        03/12/2008  Hector Huaman M.  Coloca en ejecución la SOT de suspension tomando como referencia
                                              la fecha de compromiso.
     2.0        06/10/2010                    REQ.139588
  ******************************************************************************/
  ------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
/*
c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.P_EJECUTA_SUSP_SOLICITUD';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='2483';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
*/
--------------------------------------------------
CURSOR c1 IS
select
      s.codsolot,
      s.tiptra,
      s.estsol,
      s.feccom
from
       solot s, tmp_solot_codigo t
where
      s.tiptra=444
      and s.estsol=11
      and t.codsolot=s.codsolot and t.estado=3;

l_var varchar2(1000);
l_estsol solot.estsol%type;
l_wf wf.idwf%type;
l_estsol_des estsol.descripcion%type;
ls_idwf     wf.idwf%type;
l_cont      number;
l_fecpend  solot.feccom%type;

BEGIN
  l_fecpend := trunc(sysdate);
     FOR reg IN c1 LOOP
        BEGIN
             l_var := '';
              --Validamos que el estado sea aprobado, caso contrario no se le asigna Work Flow
              if  reg.estsol = 11 and (trunc(reg.feccom) <= l_fecpend) then

                  OPERACION.PQ_SOLOT.p_ejecutar_solot(reg.codsolot);
                  --Se graba el cambio de estado a "En ejecución". Ingresado por GOA y RPL el 19/02/2008.
                   insert into SOLOTCHGEST (codsolot,tipo, estado, fecha, observacion)
                          values (reg.codsolot,1,17,sysdate,'Cambio de estado y asignación de workflow automática');

                  select idwf into l_wf from wf where codsolot = reg.codsolot and valido=1;

                  update OPERACION.TMP_SOLOT_CODIGO
                  set estado = 4, fechaejecucion=sysdate, observacion='Se realizo la asignacion del WF - ' || l_wf || ' a la SOT'
                  where codsolot = reg.codsolot and estado<>6;
                  -- Se valida que no existan tareas abiertas y se cierra el WF
                  BEGIN
                  select idwf into ls_idwf from wf where codsolot=reg.codsolot and valido=1 ;
                     select count(*) into l_cont from tareawfcpy, tareawf
                     where tareawfcpy.idtareawf = tareawf.idtareawf (+)
                     and tareawfcpy.idwf =ls_idwf
                     and nvl(tareawf.tipesttar,1) in (1,2,3);
                  EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                       l_cont := NULL;
                  END;
                    if l_cont = 0 then
                       PQ_WF.P_CERRAR_WF(ls_idwf);
                    end if;
              else
                     select estsol.descripcion into l_estsol_des from estsol where estsol = l_estsol;

                      update OPERACION.TMP_SOLOT_CODIGO
                      set estado = 5, fechaejecucion=sysdate, observacion='El Estado de la SOT no esta en Aprobado. Se encunetra en estado - ' || l_estsol_des
                      where codsolot = reg.codsolot;
              end if;
        EXCEPTION
              WHEN OTHERS THEN
                   l_var := 'P_EJECUTA_SUSP_SOLICITUD - SOT: ' || reg.codsolot ||
                 ' Revisar el JOB 235 - Problema presentado: : ' || sqlerrm;
        END;

        if trim(l_var) <> '' then
           opewf.pq_send_mail_job.p_send_mail('Revisar JOB Nro 235 - asignacion automatica de WFs para suspensión de pedido del cliente',
                                           'DL-PE-ITSoportealNegocio',--2.0
                                           l_var);
        end if;
     commit;
END LOOP;


--------------------------------------------------
---ester codigo se debe poner en todos los stores
---que se llaman con un job
--para ver si termino satisfactoriamente
/*
sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);

------------------------
exception
  when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm||' error(lineas) '||DBMS_UTILITY.format_error_backtrace, '1',c_sec_grabacion );
     raise_application_error(-20000,sqlerrm);
*/
END;
/


