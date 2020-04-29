CREATE OR REPLACE FUNCTION OPERACION.F_EF_CONFORME(a_proyecto in char) RETURN NUMBER IS
  -- devuelve 1 si es correcto
  -- 0 si no lo es
  -- da error para alguno de los problemas conocidos
  /***************************************************************************************
  Fecha   Descripcion                                 Responsable
  ----------  --------------------------------------------------------------------- --------------
  19-10-2004 Se ingreso la validacion de la existencia de un EF en el flujo de Peru   VVALQUI
  08-11-2006 se ingreso la validadion para proyectos Pymes flujo de Peru CNAJARRO
  08-05-2009 Se agrego una condicion para que los proyectos de venta de equipos siga el flujo pyme  RPARI
  12/06/2014 Se agrego una validacion para la Portabilidad de Numeros Fijos José Ruiz
  20/10/2014 Se valida que la variable ls_numsec sea nula. José Ruiz/Freddy Gonzales
  05/04/2018 Se modificó el vencimiento de factibilidad de 30 a 60 Conrad Agüero
  22/02/2019 ALTA_CLOUD_AUTO Se ingresó la validacion a ventas cloud automaticas
  **************************************************************************************/
  tmpVar           NUMBER;
  l_estef          ef.estef%type;
  l_rentable       ef.rentable%type;
  l_fecapr         ef.fecapr%type;
  l_codef          ef.codef%type;
  l_estar          ar.estar%type;
  tmpvar1          constante.valor%type;
  ln_proyect_pymes number;
  ls_estsolfac     vtatabslcfac.estsolfac%type;
  ls_estapr        char(1);
  ls_tipsrv        char(4);
  ln_flg_portable  vtatabslcfac.flg_portable%type;
  ls_numsec        sales.porta_num_fijos.numsec%type;
  ln_vto_facti     number; --05/04/2018
  cursor cur_det is
    select *
      from vtadetptoenl
     where numslc = a_proyecto
       and on_net = 0;

  l_tmp number;
  ln_proy_venta_equ NUMBER;
  ln_flg_sisact_sga NUMBER;
  ln_flg_cloud_sga NUMBER;--ALTA_CLOUD_AUTO
  
BEGIN

  l_codef := to_number(a_proyecto);
  select tipsrv
  into ls_tipsrv
  from vtatabslcfac where numslc=a_proyecto ;
  
  SELECT COUNT(1)
    INTO ln_flg_sisact_sga
    FROM OPEDD O, TIPOPEDD T, VTATABSLCFAC V
   WHERE O.TIPOPEDD = T.TIPOPEDD
     AND V.IDSOLUCION = O.CODIGON
     AND V.NUMSLC = a_proyecto
     AND T.ABREV = 'SOLUCION_SISACT';
   --ALTA_CLOUD_AUTO  
  SELECT COUNT(1)
  INTO ln_flg_cloud_sga
  FROM OPERACION.PARAMETRO_CAB_ADC C, OPERACION.PARAMETRO_DET_ADC D
 WHERE C.id_parametro = D.id_parametro
   AND C.ABREVIATURA = 'FLAG_SGA_CLOUD'
   AND D.ABREVIATURA = 'SOL_ID'
   AND C.ESTADO = 1;
   
  if ln_flg_sisact_sga > 0 or ln_flg_cloud_sga > 0 then
    return 1;
  end if;

  select PQ_CONSTANTES.f_get_cfg into tmpvar1 from dual;

  if tmpvar1 = 'PER' then

    select F_VERIFICA_PROYECTO_PYMES(a_proyecto)
      into ln_proyect_pymes
      from dual;

    SELECT F_VERIFICA_PROYECTO_VE(a_proyecto) INTO ln_proy_venta_equ FROM DUAL;

    if ln_proyect_pymes = 1 OR ln_proy_venta_equ = 1 then

      select estsolfac
        into ls_estsolfac
        from vtatabslcfac
       where numslc = a_proyecto;
      if ls_estsolfac = '00' then
        RAISE_APPLICATION_ERROR(-20500,
                                'La Solicitud de Estudio de Factibilidad no esta aprobado por Preventas.');
      else
        select estapr
          into ls_estapr
          from CXCPSPCHQ
         where numslc = a_proyecto;

        if ls_estapr = 'P' then
          RAISE_APPLICATION_ERROR(-20500,
                                  'El proyecto esta pendiente en creditos.');
        end if;

        if ls_estapr = 'R' then
          RAISE_APPLICATION_ERROR(-20500,
                                  'El proyecto fue rechazado por creditos.');
        end if;

        begin
          SELECT estef INTO l_estef FROM ef WHERE numslc = a_proyecto;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20500,
                                    'El Estudio de Factibilidad de Operaciones no existe.');
        end;

      end if;

    else
      begin
        SELECT estef, fecapr
          INTO l_estef, l_fecapr
          FROM ef
         WHERE numslc = a_proyecto;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20500,
                                  'El Estudio de Factibilidad de Operaciones no existe.');
      end;

      if l_estef <> 2 then
        RAISE_APPLICATION_ERROR(-20500,
                                'El Estudio de Factibilidad no esta aprobado por Gerencia de Operaciones.');
      end if;

      SELECT o.codigon INTO ln_vto_facti FROM tipopedd t, opedd o WHERE t.tipopedd=o.tipopedd --05/04/2018
      AND o.codigoc='1' AND t.abrev='VTO_FACTIBILIDAD' AND o.abreviacion = 'FECAPR';--05/04/2018

      if (sysdate - l_fecapr) > 60 and ls_tipsrv = '0043' then
      RAISE_APPLICATION_ERROR(-20500,
                                'El Estudio de Factibilidad (Telefonia Publica) tiene mas de 60 dias.');
      elsif (sysdate - l_fecapr) > ln_vto_facti and ls_tipsrv != '0043' then --05/04/2018
        RAISE_APPLICATION_ERROR(-20500,
                                'El Estudio de Factibilidad tiene mas de '||ln_vto_facti||' dias.');--05/04/2018
      end if;

      select count(*) into tmpvar from ar where codef = l_codef;
      if tmpvar > 0 then
        select estar, rentable
          into l_estar, l_rentable
          from ar
         where codef = l_codef;
        if (l_estar = 3 and l_rentable = 1) or l_estar = 4 then
          null;
        else
          RAISE_APPLICATION_ERROR(-20500, 'El Proyecto no es rentable.');
        end if;
      end if;
    end if;
    /*
       if (l_req_ar = 0) or ( l_req_ar = 1 and l_rentable = 1 ) then
          null;
       else
          RAISE_APPLICATION_ERROR(-20500,'El Proyecto no es rentable.');
       end if;
    */


    /*Inicio PROY-8695 Inicio Portabilidad de numeros fijos*/
    /*se valida si el proyecto es Portable o no */
     select flg_portable
     into ln_flg_portable
     from vtatabslcfac
     where numslc=a_proyecto;

    /*Se verifica que el proyecto tenga un Número de SEC*/
    begin
       IF ln_flg_portable= 1 then
          select numsec
          into     ls_numsec
          from sales.porta_num_fijos
          where numslc= a_proyecto;

           if ls_numsec= '' OR ls_numsec IS NULL  then
              RAISE_APPLICATION_ERROR(-20500, 'Proyecto de Portabilidad: No se Genero el Número de SEC para El Proyecto.');
           end if;
        END IF;

        EXCEPTION
          WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20500, 'Proyecto de Portabilidad: No se Genero el Número de SEC para El Proyecto.');
     end ;

  elsif tmpvar1 = 'BRA' then
    l_tmp := pq_mt.f_valida_proceso_mt_ok(a_proyecto);
  end if;

  return 1;

END;
/