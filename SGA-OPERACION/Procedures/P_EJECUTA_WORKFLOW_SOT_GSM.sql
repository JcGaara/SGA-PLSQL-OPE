CREATE OR REPLACE PROCEDURE OPERACION.P_EJECUTA_WORKFLOW_SOT_GSM is

 /************************************************************
  NOMBRE:     P_EJECUTA_WORKFLOW_SOT_GSM
  PROPOSITO:  Asignacion Automatica de WF
  PROGRAMADO EN JOB:  NO

  REVISIONES:
  Version      Fecha        Autor           Descripcisn
  ---------  ----------  ---------------  ------------------------

  1.0        19/03/2009  Hector Huaman    REQ-85701: se modifico query, validar puerta - puerta por el flg_puerta
  2.0        18/11/2009  Joseph Asencios  REQ-109875: Se agregó el tipo de trabajo 469 para la generación automática de WF.
  3.0        14/01/2010  Luis Patiño      proy-cdma:  Se quito del cursor el tipo de trabajo de instalacion cdma
  4.0        06/10/2010                      REQ.139588
***********************************************************/
------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
/*c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.P_EJECUTA_WORKFLOW_SOT_GSM';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='5243';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );*/
--------------------------------------------------


CURSOR c1 IS
select
       t.codsolot,
       t.estsolot,
       s.tiptra
from
       OPERACION.TMP_SOLOT_CODIGO t,
       solot s
where
       s.codsolot = t.codsolot
       and t.estado = 3
       /*and s.tiptra = 464*/ --REQ 109875
--     and s.tiptra in (464,469);--REQ 109875
       and s.tiptra in (464,469,457);-- 3.0

l_var varchar2(1000);
l_estsol solot.estsol%type;
l_wf wf.idwf%type;
l_estsol_des estsol.descripcion%type;
ls_idwf     wf.idwf%type;
l_cont      number;
ln_3playpuerta number;
begin
--HAHM Procedmiento que unifica SOT
  OPERACION.P_UNIFICACION_SOT;
    FOR reg IN c1 LOOP
        BEGIN
             l_var := '';
         --REQ 85701
         select count(*)
           into ln_3playpuerta
           from vtatabprecon v, solot s
          where v.numslc = s.numslc
            and s.codsolot = reg.codsolot
            and (v.codmotivo_tf in
                (select codmotivo
                    from vtatabmotivo_venta
                   where codtipomotivo = '023'--REQ-85701: modifico query, validar puerta - puerta por el flg_puerta
                     and flg_puerta = 1) or v.codmotivo = 22);

             if ln_3playpuerta>0 then
             update OPERACION.TMP_SOLOT_CODIGO
                  set estado = 4, fechaejecucion=sysdate, observacion='Se realizo la asignacion del WF - ' || l_wf || ' a la SOT'
                  where codsolot = reg.codsolot;
             else
              --Obtenemos el estado de la SOT
              select estsol into l_estsol from solot where codsolot = reg.codsolot;

              if reg.tiptra <> 117 and reg.tiptra <> 370 and reg.tiptra <> 371 then
                      --Actualizamos el codubi de la SOLOTPTO
                      update inssrv i2
                      set i2.codubi = (select c.codubi
                      from vtatabcli c, inssrv i
                      where c.codcli = i.codcli
                      and i2.codinssrv = i.codinssrv)
                      where i2.codubi is null
                      and i2.codinssrv in (select s3.codinssrv from solotpto s3 where s3.codsolot=reg.codsolot);

                      --Actualizamos el codubi de la SOLOTPTO
                      update solotpto s2
                      set s2.codubi = (select c.codubi
                      from vtatabcli c, inssrv i
                      where c.codcli = i.codcli
                      and s2.codinssrv = i.codinssrv)
                      where s2.codubi is null
                      and s2.codsolot = reg.codsolot;
              end if;
              --Validamos que el estado sea aprobado, caso contrario no se le asigna Work Flow
              -- Se valida también que la SOT tenga alguno de los estados de Rechazado.
              if l_estsol = 11 or l_estsol=19 or l_estsol=30 or l_estsol=17/*n_tipestsol = 7*/ then

                  if reg.estsolot is null then
                      OPERACION.PQ_SOLOT.p_ejecutar_solot(reg.codsolot);
                  else
                      OPERACION.PQ_SOLOT.p_ejecutar_solot(reg.codsolot,reg.estsolot);
                  end if;

                   --Se graba el cambio de estado a "En ejecución". Ingresado por GOA y RPL el 19/02/2008.
                   insert into SOLOTCHGEST (codsolot,tipo, estado, fecha, observacion)
                          values (reg.codsolot,1,17,sysdate,'Cambio de estado y asignación de workflow automática');
                  --Fin de Codigo.


                  select idwf into l_wf from wf where codsolot = reg.codsolot and valido=1;

                  update OPERACION.TMP_SOLOT_CODIGO
                  set estado = 4, fechaejecucion=sysdate, observacion='Se realizo la asignacion del WF - ' || l_wf || ' a la SOT'
                  where codsolot = reg.codsolot and estado<>6;

                  ---HAHM se consideracion para  nuevos tipos de SOT:DESACTIVACIÓN POR SUSTITUCIÓN y CANCELACIÓN DE FACTURACIÓN que pase a  estado atentida
                  if reg.tiptra = 117 or reg.tiptra = 370 or reg.tiptra = 371 or reg.tiptra =403 or reg.tiptra =7 then
                     operacion.pq_solot.p_chg_estado_solot(reg.codsolot,29);
                  end if;


/*                   if reg.tiptra = 363 or reg.tiptra = 364  then
                     operacion.pq_solot.p_chg_estado_solot(reg.codsolot,12);
                  end if;*/
                  -- REQ.65285 HHM
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

                   -- REQ.65285 HHM  FIN

              else

                     select estsol.descripcion into l_estsol_des from estsol where estsol = l_estsol;

                      update OPERACION.TMP_SOLOT_CODIGO
                      set estado = 5, fechaejecucion=sysdate, observacion='El Estado de la SOT no esta en Aprobado. Se encuetra en estado - ' || l_estsol_des
                      where codsolot = reg.codsolot;

              end if;
              end if;
        EXCEPTION
              WHEN OTHERS THEN
                   l_var := 'OPERACION.P_EJECUTA_WORKFLOW_SOT_GSM  - SOT: ' || reg.codsolot ||
                 ' Revisar el JOB 5243 - Problema presentado: : ' || sqlerrm;

        END;

        if trim(l_var) <> '' then
           opewf.pq_send_mail_job.p_send_mail('Revisar JOB Nro 5243 - asignacion automatica de WFs',
                                           'DL-PE-ITSoportealNegocio', --4.0
                                           l_var);
        end if;


     commit;
     END LOOP;

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


