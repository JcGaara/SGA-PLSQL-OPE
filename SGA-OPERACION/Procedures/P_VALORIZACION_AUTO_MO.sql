CREATE OR REPLACE PROCEDURE OPERACION.P_VALORIZACION_AUTO_MO is
/* EMELENDEZ: 22/05/2008
   Valorización automática: Cuando el usuario pasa a estado Liquidado = 3
   Se valorizan las actividades y materiales de la sot y pasa a estado Valorizado = 5
--   Solo para masivos solot.tipsrv in (58,59) 05/08/2008 Se quita por req A. Dillerva
*/


------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.P_VALORIZACION_AUTO_MO';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='702';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
--------------------------------------------------


ld_costo decimal(10,4);
id_codact integer;
ld_codprecdis long;
sd_codmat char(15);

Cursor curEtapas Is
Select solotptoeta.codsolot, solotptoeta.punto, solotptoeta.orden
  From solotptoeta, solot
  where solotptoeta.codsolot = solot.codsolot
   and Trunc(solot.fecusu) > '11/03/2008'
   and solotptoeta.esteta = 3;
--   and solot.tipsrv in (58,59) REQ 63368 A. Dillerva (Para todos los tipsrv)

Begin
 For regEta in curEtapas LOOP
  Declare
  Cursor curAct Is
  Select * from solotptoetaact Where codsolot = regEta.codsolot And punto = regEta.punto And orden = regEta.orden ;
  Cursor curMat Is
  Select * from solotptoetamat Where codsolot = regEta.codsolot And punto = regEta.punto And orden = regEta.orden ;
  Begin
    Update solotptoeta Set esteta = 5, fecval = Sysdate Where CodSolot = regeta.codsolot and Punto = regeta.punto and Orden = regeta.orden;
    Commit;
       For reg in curAct loop
         If reg.codprecliq is null or reg.codprecliq = 0 Then
          BEGIN
               id_codact := reg.codact;
               Select codprecdis into ld_codprecdis from solotptoetaact Where codsolot = regeta.codsolot And punto = regeta.punto And orden = regeta.orden And codact = id_codact;
               Select costo into ld_costo from actxpreciario  Where codact = id_codact  And codprec = ld_codprecdis ;
               Update solotptoetaact set cosliq = ld_costo Where codsolot = regeta.codsolot And punto = regeta.punto And orden = regeta.orden And codact = id_codact;
               if reg.codprecliq is null or reg.codprecliq = 0 then
                  Update solotptoetaact set codprecliq = reg.codprecdis Where codsolot = regeta.codsolot And punto = regeta.punto And orden = regeta.orden And codact = id_codact;
               end if;
               commit;
          Exception
            when others then
            null;
          END;
         End If;
       end loop;
       For reg in curMat loop
         If reg.cosliq = 0 or reg.cosliq is null then
          BEGIN
               sd_codmat := reg.codmat;
               Select costo into ld_costo from matope  Where codmat = sd_codmat ;
               Update solotptoetamat set cosliq = ld_costo Where codsolot = regeta.codsolot And punto = regeta.punto And orden = regeta.orden And codmat = sd_codmat;
               commit;
          Exception
            when others then
            null;
          END;
         End If;
       End loop;
  End;
 End loop;

--------------------------------------------------
---ester codigo se debe poner en todos los stores
---que se llaman con un job
--para ver si termino satisfactoriamente
sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);

exception
   when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);

END;
/


