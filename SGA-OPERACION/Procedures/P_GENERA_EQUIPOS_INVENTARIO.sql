CREATE OR REPLACE PROCEDURE OPERACION.P_GENERA_EQUIPOS_INVENTARIO is
/*
       Creado por Enrique Melendez. Registra el Inventario de equipos por CID
       Para los proyectos con reserva generada y solo para
       TPI, Explora y Masivos (DTH)
       Modificado 04/06/2008
*/


------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
/*
c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.P_GENERA_EQUIPOS_INVENTARIO';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='842';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
*/
--------------------------------------------------



cUser Char(13);
CURSOR c1 IS
SELECT   solotptoequ.codsolot,
         solotptoequ.punto,
         solotptoequ.orden,
         solotptoequ.tipequ,
         solotptoequ.nro_res,
         solotptoequ.nro_res_l,
         solotpto.cid,
         solot.tipsrv,
         solotpto_id.responsable_pi,
         usuarioope.area
    FROM solotptoequ, solotpto, solot, solotpto_id, usuarioope
   WHERE (solotptoequ.codsolot = solotpto.codsolot)
         and (solotptoequ.punto = solotpto.punto)
         and (solotpto.codsolot = solot.codsolot)
         and (solotpto.codsolot = solotpto_id.codsolot)
         and (solotpto.punto = solotpto_id.punto)
         and (solotpto_id.responsable_pi = usuarioope.usuario)
         and (nro_res is not null or nro_res_l is not null)
         and (solot.tipsrv in (58,59,61)) -- Xplora, TPI, Paquetes Masivos (DTH)
         and (solotpto.cid is not null)
         and (solotpto.fecinisrv is not null) -- Fecha de servicio
--         and solotpto.codsolot =153071
         and solotpto.cid || solotptoequ.tipequ not In
             ( Select cid || tipequ From equxcid Where nivel = 0 and solotpto.cid = equxcid.cid)
         Order By codsolot, punto, orden ;

Begin
    FOR reg IN c1 LOOP
        cUser := reg.responsable_pi;
        if cUser is null then
           cUser := 'JBRAVOF';
        end if;
        -- Call the procedure --
        operacion.P_UPD_EQUXCID_SOLOT_USER ( reg.codsolot , reg.punto , reg.orden , reg.cid, cUser, reg.area );
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

------------------------      
exception  
  when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);
*/    
End;
/


