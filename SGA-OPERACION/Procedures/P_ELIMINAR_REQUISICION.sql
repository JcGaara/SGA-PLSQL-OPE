CREATE OR REPLACE PROCEDURE OPERACION.p_eliminar_requisicion
(numrequisicion in int)


IS

   numtransaccion number;
   numcodsolot    number;
   numpunto       number;
   numorden       number;

   cursor cursor_detalle is
   select
   id_transaccion, codsolot, punto, orden
   from financial.z_ps_transacciones_det_spw
   where
   id_requisicion = numrequisicion;

   v_flg_generado number;
BEGIN

  -- Verificar tipo generado en la cabecera

  select flg_genera
  into v_flg_generado
  from financial.z_ps_transacciones_spw
  where
  id_requisicion = numrequisicion;

  --Borrar Detalles

    open cursor_detalle;
    fetch cursor_detalle into  numtransaccion, numcodsolot, numpunto, numorden;

    loop

        delete financial.z_ps_transacciones_det_spw
        where
        id_transaccion     = numtransaccion
        and id_requisicion = numrequisicion;

        if (v_flg_generado = 1) then
           update solotptoetamat
           set flg_spgenerado = 0
           where codsolot = numcodsolot
           and   punto    = numpunto
           and   orden    = numorden;

           update solotptoetaact
           set flg_spgenerado = 0
           where codsolot = numcodsolot
           and   punto    = numpunto
           and   orden    = numorden;

        end if;

        if (v_flg_generado = 2) then

           update solotptoetaact
           set flg_spgenerado = 0
           where codsolot = numcodsolot
           and   punto    = numpunto
           and   orden    = numorden;

        end if;


         if (v_flg_generado = 3) then

           update solotptoetamat
           set flg_spgenerado = 0
           where codsolot = numcodsolot
           and   punto    = numpunto
           and   orden    = numorden;

        end if;


        commit;



    fetch cursor_detalle into  numtransaccion, numcodsolot, numpunto, numorden;

    exit when  cursor_detalle %NOTFOUND;
    end loop;

    close cursor_detalle;


    --Borrar Cabecera

    delete financial.z_ps_transacciones_spw
    where id_requisicion =   numrequisicion;


END;
/


