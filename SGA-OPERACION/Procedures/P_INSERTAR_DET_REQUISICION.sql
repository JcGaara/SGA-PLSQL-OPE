CREATE OR REPLACE PROCEDURE OPERACION.p_insertar_det_requisicion
(numrequisicion in number, strproyecto in string, numsolot in number,
numcodeta in number , numpunto in number,
numorden in number, dtfechavalorizacion in date,
nummonto in number, nummulta in number, numtotal in number, flgtipo in number default null)


IS


BEGIN

  insert into financial.z_ps_transacciones_det_spw
  (id_transaccion,id_requisicion,codsolot,punto,orden,codeta,fecha_valorizacion,usuario_registro,fecha_registro,modificado_por,fecha_modificacion,numslc,estado_linea,monto_soles, multa, total)
  values
  (financial.z_ps_spw_trxn_s.nextVal,numrequisicion,numsolot,numpunto, numorden,numcodeta,dtfechavalorizacion, user, sysdate, user, sysdate, strproyecto,'1',nummonto, nummulta, numtotal);



  if flgtipo is not null then
     if (flgtipo = 1) then

        update solotptoetaact
        set flg_spgenerado = 1
        where codsolot = numsolot
        and punto = numpunto
        and orden = numorden
        and flg_spgenerado in (0,2);

        update solotptoetamat
        set flg_spgenerado = 1
        where codsolot = numsolot
        and punto = numpunto
        and orden = numorden
        and flg_spgenerado in (0,2);

     end if;

     if (flgtipo = 2) then
        update solotptoetaact
        set flg_spgenerado = 1
        where codsolot = numsolot
        and punto = numpunto
        and orden = numorden
        and flg_spgenerado in (0,2);
     end if;

     if (flgtipo = 3) then
        update solotptoetamat
        set flg_spgenerado = 1
        where codsolot = numsolot
        and punto = numpunto
        and orden = numorden
        and flg_spgenerado in (0,2);
     end if;

  end if;



END;
/


