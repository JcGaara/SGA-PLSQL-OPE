CREATE OR REPLACE PROCEDURE OPERACION.P_ACTUALIZAR_PROGRAMACION IS


------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
/*
c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.P_ACTUALIZAR_PROGRAMACION';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='275';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
*/
--------------------------------------------------


/*********************************************************************************************
Permite actualizar informacion en los campos de progrmación

31-03-2004		creado			            Victor Valqui
11/01/2005     Se agrego la tarea 425     Carlos Corrales
*********************************************************************************************/
BEGIN

--Se actualiza la fecha de pext en la tabla de programacion.
	update solotpto_id
	set fecpex = f_get_fecha_pext(solotpto_id.codsolot, solotpto_id.punto)
	where (codsolot, punto) in (
	select codsolot, punto
		from solotpto_id
		where codsolot in (select codsolot from tareawf, wf
			 	where tareawf.idwf = wf.idwf and
	   		 		  tareadef in (316, 323, 376, 425) and
					  estwf <> 5 )
			and fecpex is null
	union
	select codsolot, punto
	   from solotpto_id
	   where (codsolot, punto ) in (select codsolot, punto from preubi where fecfinins is not null)
			and fecpex is null);

--
commit;

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
END;
/


