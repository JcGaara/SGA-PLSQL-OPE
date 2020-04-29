CREATE OR REPLACE PROCEDURE OPERACION.P_GENERA_PEP_MO_AUTO is
/*
       Creado por Enrique Melendez. Genera Elementos PEP de mano de obra
       para los proyectos que se valiricen en el día
       Modificado 23/05/2008
2.0    18/10/2011    Edilberto Astulle                Excluir tipos de servicio para generacion de PEPs de mano de obra
       
*/

------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
/*
c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.P_GENERA_PEP_MO_AUTO';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='502';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
*/
--------------------------------------------------




nPid Integer;
CURSOR c1 IS
Select distinct a.codsolot,d.numslc
From etapa c,solotptoetaact b, solotptoeta a,solot d, wf
where a.codsolot = b.codsolot
and a.codsolot = d.codsolot
and a.punto = b.punto
and a.orden = b.orden
and a.codeta = c.codeta
and d.codsolot = wf.codsolot
and Trunc(wf.fecusu) > '11/03/2008' -- Para SOTs que no fueron generadas anteriormente (F. de cambio generacion PEPs)
and a.esteta IN (5)
and (b.pep is null or Trim(b.pep) = '')
and b.canliq > 0
and b.cosliq > 0
and d.numslc is not null
and c.tipo is not null
and d.tipsrv not in (select codigoc from opedd where tipopedd = 1026) ;--2.0



Begin
    FOR reg IN c1 LOOP
        -- Call the procedure --
        financial.pq_z_ps_proyectossap.p_screa_def_pep_sotmo(reg.numslc, reg.codsolot, 'PER', nPid) ;
        Commit;
    END LOOP;
    Commit;


--------------------------------------------------
---ester codigo se debe poner en todos los stores
---que se llaman con un job
--para ver si termino satisfactoriamente
/*
sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);

exception
   when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);
*/
End;
/