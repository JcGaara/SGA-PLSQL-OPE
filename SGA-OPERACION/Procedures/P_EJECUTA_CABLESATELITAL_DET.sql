CREATE OR REPLACE PROCEDURE OPERACION.P_EJECUTA_CABLESATELITAL_DET(p_codsolot number)
IS

  /********************************************************************************
      NOMBRE: P_EJECUTA_CABLESATELITAL_DET

      Creacion
      Ver     Fecha          Autor              Descripcion
     ------  ----------  ----------            --------------------
      1.0     15/04/2009  Hector Huaman M.    REQ-89743:Corregir la asignacion incorrecta de la fecha  de inicio de servicio
  ********************************************************************************/


l_count number;
l_cont number;
l_numslc vtatabslcfac.numslc%type;
l_idwf  wf.idwf%type;
l_idtareawf tareawf.idtareawf%type;
l_fecactconax reginsdth.fecactconax%type;

cursor  c_tarea is
select idtareawf,ESTTAREA,TAREADEF from tareawf where idwf = l_idwf and idtareawf = l_idtareawf;
cursor c_trssolot is
select codtrs,fectrs,esttrs from trssolot where codsolot = p_codsolot;
cursor  c_tareacpy is
select idtareawf from tareawfcpy where idwf = l_idwf;

BEGIN
     select distinct numslc into l_numslc from solot where codsolot = p_codsolot;
     select count(*) into l_count from vtatabslcfac a, reginsdth b
     where a.numslc = b.numslc and b.estado='02' and b.flg_facturable=1 and b.flg_validado=1 and a.numslc = l_numslc;
     select idwf into l_idwf from wf where valido=1 and codsolot = p_codsolot;
     select count(*) into  l_cont from reginsdth where estado='02' and flg_facturable=1 and flg_validado=1 and codsolot=p_codsolot;
     select fecactconax into  l_fecactconax from reginsdth where estado='02' and flg_facturable=1 and flg_validado=1 and codsolot = p_codsolot;

   if l_cont>0 then
   for lc_tareacpy in c_tareacpy loop
   l_idtareawf := lc_tareacpy.idtareawf;
    for lc_tarea in c_tarea loop

       if lc_tarea.esttarea in (1, 2) and lc_tarea.TAREADEF=299 then
              -- Crea los registro de transaccion para la aprobacion en contrato
              update reginsdth set estado = '07' where estado='02' and flg_facturable=1 and flg_validado=1 and codsolot = p_codsolot;

          OPERACION.pq_solot.p_crear_trssolot( 4, p_codsolot, null, null, null, null);
          for lc_trssolot in c_trssolot loop
             operacion.pq_solot.p_exe_trssolot(lc_trssolot.codtrs,2,l_fecactconax);
          end loop;
          --Modificado MBALCAZAR 25/06/08 - Inicio
            if l_idtareawf is not null then
             opewf.pq_wf.P_CHG_STATUS_TAREAWF(l_idtareawf,4,4,0,sysdate,sysdate);
             --update solotpto set fecinisrv=to_date(l_fecactconax,'dd/mm/yyyy') where codsolot= p_codsolot;
             --REQ-89743
             update solotpto set fecinisrv=trunc(l_fecactconax) where codsolot= p_codsolot;
             commit;
            end if;
           --Modificado MBALCAZAR 25/06/08 -Fin
       end if;

        --Modificado MBALCAZAR 16/07/08 - Inicio
       if lc_tarea.esttarea=4 and lc_tarea.TAREADEF=299 then
             update reginsdth set estado = '07' where estado='02' and flg_facturable=1 and flg_validado=1 and codsolot = p_codsolot;
             --update solotpto set fecinisrv=to_date(l_fecactconax,'dd/mm/yyyy') where codsolot= p_codsolot;
             --REQ-89743
             update solotpto set fecinisrv=trunc(l_fecactconax) where codsolot= p_codsolot
             and fecinisrv is null; --REQ 93172
            commit;
       end if;
        --Modificado MBALCAZAR 16/07/08 -Fin
    end loop;

    end loop;
     end if;
END;
/


