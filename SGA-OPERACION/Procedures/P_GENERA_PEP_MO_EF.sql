CREATE OR REPLACE PROCEDURE OPERACION.P_GENERA_PEP_MO_EF is

/* Autor: Enrqiue Melendez 24/03/2008
   Generación auntomàtica de elementos PEP de mano de obra para proyectos por cotización
   Etapas CLIENTE - SOPORTE TERCEROS y CLIENTE - TRANSPORTE TERCEROS (etapa.flg_servicio_cotizacion = 1)
   Emelendez: 23/05/2008 Se añaden CLIENTE-PERMISOS y RED-PERMISOS (Permisos municipales PEXT)
   Modificado: Ricardo Antuñano 09/02/2009 -- Mejora en la ubicacion de las SOT a procesar.
*/

------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
/*
c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.P_GENERA_PEP_MO_EF';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='522';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
*/
--------------------------------------------------

nPid int;
/*CURSOR c1 IS
select distinct s.codsolot, s.numslc
  from solot s,
       solotpto sp,
       ( Select distinct operacion.ef.numslc, operacion.efptoeta.punto from operacion.ef, operacion.efptoeta, operacion.etapa
         where operacion.ef.codef = operacion.efptoeta.codef
         and operacion.efptoeta.codeta = operacion.etapa.codeta
         and operacion.etapa.flg_servicio_cotizacion = 1 ) ef
 where s.numslc is not null
   and to_char(s.fecusu,'YYYY-MM-DD')>='2008-07-01'
   and s.codsolot = sp.codsolot
   and s.numslc = ef.numslc
   and sp.efpto = ef.punto
   and s.codsolot not in ( Select distinct a.codsolot from z_ps_detalle_presupuesto a , solot b where a.codsolot=b.codsolot
         and to_char(b.fecusu,'YYYY-MM-DD')>='2008-07-01'
         and a.elementopep is not null and a.categoria in
         (select categoria from z_ps_rubro_etapa where codeta in (select codeta from etapa
         where flg_servicio_cotizacion = 1)));*/ --comentado REAS 2009.02.09

cursor pep_tipo_o is
select distinct s.codsolot, s.numslc
  from solot s,
       solotpto sp,
       ( Select distinct operacion.ef.numslc, operacion.efptoeta.punto from operacion.ef, operacion.efptoeta, operacion.etapa, z_ps_rubro_etapa
         where operacion.ef.codef = operacion.efptoeta.codef
         and operacion.efptoeta.codeta = operacion.etapa.codeta
         and operacion.etapa.flg_servicio_cotizacion = 1
         and operacion.efptoeta.codeta = z_ps_rubro_etapa.codeta
         and z_ps_rubro_etapa.clave = 'O'
         ) ef
 where s.numslc is not null
   and to_char(s.fecusu,'YYYY-MM-DD')>='2008-07-01'
   and s.codsolot = sp.codsolot
   and s.numslc = ef.numslc
   and sp.efpto = ef.punto
   and s.codsolot not in ( Select distinct a.codsolot from z_ps_detalle_presupuesto a , solot b where a.codsolot=b.codsolot
         and to_char(b.fecusu,'YYYY-MM-DD')>='2008-07-01'
         and a.elementopep is not null and (trim(a.categoria), trim(substr(a.elementopep,16,1))) in
         (select trim(categoria),trim(clave) from z_ps_rubro_etapa where codeta in (select codeta from etapa
         where flg_servicio_cotizacion = 1) and clave='O'));

cursor pep_tipo_r is
select distinct s.codsolot, s.numslc
  from solot s,
       solotpto sp,
       ( Select distinct operacion.ef.numslc, operacion.efptoeta.punto from operacion.ef, operacion.efptoeta, operacion.etapa, z_ps_rubro_etapa
         where operacion.ef.codef = operacion.efptoeta.codef
         and operacion.efptoeta.codeta = operacion.etapa.codeta
         and operacion.etapa.flg_servicio_cotizacion = 1
         and operacion.efptoeta.codeta = z_ps_rubro_etapa.codeta
         and z_ps_rubro_etapa.clave = 'R'
         ) ef
 where s.numslc is not null
   and to_char(s.fecusu,'YYYY-MM-DD')>='2008-07-01'
   and s.codsolot = sp.codsolot
   and s.numslc = ef.numslc
   and sp.efpto = ef.punto
   and s.codsolot not in ( Select distinct a.codsolot from z_ps_detalle_presupuesto a , solot b where a.codsolot=b.codsolot
         and to_char(b.fecusu,'YYYY-MM-DD')>='2008-07-01'
         and a.elementopep is not null and (trim(a.categoria), trim(substr(a.elementopep,16,1))) in
         (select trim(categoria),trim(clave) from z_ps_rubro_etapa where codeta in (select codeta from etapa
         where flg_servicio_cotizacion = 1) and clave='R'));

Begin
    FOR reg_tipo_o IN pep_tipo_o LOOP
        -- Call the procedure --
        financial.pq_z_ps_proyectossap.p_screa_def_pep_efmo(reg_tipo_o.numslc, reg_tipo_o.codsolot, 'PER',1, nPid) ;
        Commit;
    END LOOP;
    FOR reg_tipo_r IN pep_tipo_r LOOP
        -- Call the procedure --
        financial.pq_z_ps_proyectossap.p_screa_def_pep_efmo(reg_tipo_r.numslc, reg_tipo_r.codsolot, 'PER',1, nPid) ;
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


