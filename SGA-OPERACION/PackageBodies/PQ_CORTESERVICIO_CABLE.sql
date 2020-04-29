CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_CORTESERVICIO_CABLE AS


/**********************************************************************
Genara las sots para suspnciones, reconexiones de CABLE
**********************************************************************/

  PROCEDURE p_genera_transaccion
  IS

  ------------------------------------
  --VARIABLES PARA EL ENVIO DE CORREOS
  c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.PQ_CORTESERVICIO_CABLE.P_GENERA_TRANSACCION';
  c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='782';
  c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
  --------------------------------------------------


  l_dia number;
  l_tmp number;
  BEGIN

/*     begin
      If to_char(to_date('01/01/1995', 'dd/mm/yyyy'), 'd') <> '1' then
         raise_application_error(-20999,
                                 'Error en Configuracion de Dia Domingo <> 1' ||
                                 chr(13) ||
                                 'Modificar NLS_LANG = ''LATIN AMERICAN SPANISH_AMERICA.WE8ISO8859P1''');
      End If;
      end;
*/

      --<REQ ID=107653 OBS=COMENTADO POR USO DE FUNCIÓN f_get_fechas_corte>
      /*--verifica q no se ejecute en fin de semana
      select to_char(sysdate,'d')
      into l_dia
      from dual;
      --verifica q no se ejecute feriado
      select count(*)
      into l_tmp
      from tlftabfer
      where trunc(FECINI) = trunc(sysdate);*/
      --</REQ>
      --REQ-90111
      p_depura__transacciones_cable;
      --REQ-90111
      p_genera_reconexion_CABLE();      --ejecucion de reconexion Tf
      p_genera_transaccionCLC();  --genera las transacciones de CLC
      p_genera_RECCLC();          --genera reconexiones de lineas cortadas por CLC TF

      -- modificacion por Gustavo Ormeño 20/04/2007, para que genere CLC también días Viernes
      /*if ( (l_dia in (2,3,4,5)) and (l_tmp = 0) )  then*/  --<REQ ID=107653 OBS=COMENTADO POR USO DE FUNCIÓN f_get_fechas_corte>
      if ( f_get_fechas_corte = 1 ) then  --REQ 107653
        p_genera_suspencion_CABLE;
        p_genera_corte_CABLE; -- CORTES DE SERVICIO TRIPLE PLAY CON VOZ
        p_genera_CLC();             --genera CLC Tf
      end if;
/*
      -- modificacion por Gustavo Ormeño 20/04/2007, para que genere CLC también días Viernes
      if ( (l_dia in (2,3,4,5)) and (l_tmp = 0) )  then
         begin
            p_genera_suspencion_CABLE;        --ejecucion de suspenciones TF

          end;
       end if;
*/

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

/**********************************************************************
Genara las sots para suspenciones de SERVICIO DE CABLE
**********************************************************************/

  PROCEDURE p_genera_suspencion_CABLE
  IS
  l_codsolot solot.codsolot%type;
  l_flgenviar number;
  l_numpuntos number; --variable util para ubicar la instancia de paquete
-------------------------------------------------------------------------------------------------
--*************************** QUERY ANTIGUO 01-08-2008 ******************************************
/*  cursor cur_tra is
  select *
  from transacciones_CABLE
  where transaccion = 'SUSPENSION'
  and fecini is null
  and tipo in (10,12); -- se adiciona el 12 para cortes DTH*/
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
--*************************** QUERY MODIFICADA 01-08-2008 ****************************************
  cursor cur_tra is
  select *
  from transacciones_CABLE
  where transaccion = 'SUSPENSION'
  and fecini is null
  --ini 21.0
  --and tipo in (10,12,15) -- se adiciona el 12 para cortes DTH, 15 para triple play
  --ini 24.0
  --and tipo in (10,15);--Se quito 12 DTH Facturable para que sea manejado por el nuevo proceso
  and 1 = 2;  --Este query ya no debe devolver data. Cable Analogico y Triple Play deben ser manejarse por el nuevo proceso de cortes
  --fin 24.0
  --fin 21.0

--------------------------------------------------------------------------------------------------------

   hArch UTL_FILE.FILE_TYPE;
  vNomArch varchar2(100);

  BEGIN
  vNomArch := 'SUSPCABLE.htm';
  hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'w');
  l_flgenviar := 0;

  UTL_FILE.PUT_LINE(hArch,'<html>');
  UTL_FILE.PUT_LINE(hArch,'<head>');
  UTL_FILE.PUT_LINE(hArch,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
  UTL_FILE.PUT_LINE(hArch,'<title>Cortes por falta de pago - CABLE</title>');
  UTL_FILE.PUT_LINE(hArch,'</head>');
  UTL_FILE.PUT_LINE(hArch,'<body>');
  UTL_FILE.PUT_LINE(hArch,'<p><font color="#3366FF">CORTES POR FALTA DE PAGO: - CABLE '||to_char(sysdate,'dd/mm/yyyy hh24:mi') ||  '</font> </p>');

  UTL_FILE.FCLOSE(hArch);

   for c_tra in cur_tra loop
     begin
          if (f_verdocpendiente(c_tra.idfac) = 0 ) then --verifico no haya cancelado todos sus documentos.
             begin
--              update transacciones set fecini = sysdate where idtrans = c_tra.idtrans ;
              update transacciones_cable set fecini = sysdate, fecfin = sysdate where idtrans = c_tra.idtrans ; -- modificación para que la suspension quede anulada y no genere activación posterior
              end;
          else
              begin
                     l_numpuntos := 0;
                     if c_tra.tipo = 10 and f_cuenta_puntos_cable(c_tra.idfac) > 0 then
                             p_insert_sot(c_tra.codcli,409,'0061',1,958,l_codsolot);
                             p_insert_solotpto_cable(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac/*,c_inspaq.idinsxpaq*/);
                             l_numpuntos := 1;
                      elsif c_tra.tipo = 12 and f_cuenta_puntos_cable(c_tra.idfac) > 0 then
                             p_insert_sot(c_tra.codcli,425,'0061',1,958,l_codsolot);
                             p_insert_solotpto_cable(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac);
                             l_numpuntos := 1;
                      -- Loop que recorre cada registro de transacciones pendientes (línea 117)
--------------------------------------------------------------------------------------------------------
--*************************************** QUERY AGREGADA 01-08-2008 ************************************
                      elsif c_tra.tipo = 15 and f_cuenta_puntos_cable(c_tra.idfac) > 0 then
                             p_insert_sot(c_tra.codcli,441,'0061',1,958,l_codsolot);
                             p_insert_solotpto_cable(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac/*,c_inspaq.idinsxpaq*/);
                             l_numpuntos := 1;
--------------------------------------------------------------------------------------------------------
                      end if;

                     -- pq_solot.p_asig_wf(l_codsolot,48);
                     if l_numpuntos = 1 then
                        update transacciones_cable set fecini = sysdate, codsolot = l_codsolot
                        where idtrans = c_tra.idtrans ;
                        p_enviar_notificaciones(c_tra.idtrans,'SUSPCABLE.htm');
                        OPERACION.PQ_SOLOT.p_ejecutar_solot(l_codsolot);
 /*                    else
                        --l_flgenviar := 0;
                        --p_envia_correo_c_attach('Corte por Falta de Pago - Servicio de Cable - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno','SOT sin puntos activos, no generada - Cable. (IDFAC,NOMABR,CODCLI) = ('|| c_tra.idfac ||','||c_tra.nomabr||','||c_tra.codcli ||') ' ||to_char(sysdate,'dd/mm/yyyy hh24:mi'),null,'SGA');
                        -- NO SE GENERA SOLOT PORQUE NO SE UBICAN PUNTOS, POSIBLEMENTE EL SERVICIO Y ATENGA BAJA O EL RECIBO NO ESTE ASOCIADO A NINGÚN SERVICIO.
 */                  end if;
                   l_flgenviar := 1;
              end;
           end if;
        end;
      end loop;


     if l_flgenviar > 0 then
       hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'a');
       UTL_FILE.PUT_LINE(hArch,'</body>');
       UTL_FILE.PUT_LINE(hArch,'</html>');
       UTL_FILE.FCLOSE(hArch);
--         p_envia_correo_c_attach('Corte por Falta de Pago - Servicio de Cable - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno@claro.com.pe','Corte por Falta de Pago - Cable - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
         --<8 p_envia_correo_c_attach('Corte por Falta de Pago - Servicio de Cable - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'eduardo.rojas@claro.com.pe','Corte por Falta de Pago - Cable - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA'); --8>
         p_envia_correo_c_attach('Corte por Falta de Pago - Servicio de Cable - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'carlos.teran@claro.com.pe','Corte por Falta de Pago - Cable - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');--23.0
     end if;

  END;


/**********************************************************************
Genara las transacciones CLC para servicios de telefonía en triple play
**********************************************************************/

  PROCEDURE p_genera_transaccionCLC
  IS

  l_idtrans number;
  l_codsolot solot.codsolot%type;
  l_minnomabr transacciones_cable.nomabr%type;
  pendientes number;



  ---cursor transacciones analogicas
  cursor cur_traana is
  select distinct c.codcli--, c.nomabr se comenta el nomabr, ya que no es necesario para verificar si existe ya transaccion 23/06/2008
  from collections.cxccorlimcredlog  c, numtel n, inssrv i
  where c.tipo ='F' and
      c.flgtra = 0 and
      f_verificanumero(c.nomabr) = 1 and
      c.nomabr = n.numero and
      n.codinssrv = i.codinssrv and
      i.codcli = c.codcli and
      -- cambio en la condición para que considere sólo inssrv en estado activo
      i.estinssrv in (1)
      --ini 22.0
      and 1 = 2 --para que no devuelva ningun dato
      --fin 22.0
            -- para que no genere un nuevo registro de CLC sobre los mismo servicios -- 18/01/2008
            and (c.codcli, i.numero) not in (select t.codcli, d.nomabr
                                                           from transacciones_cable t, dettransacciones_cable d
                                                           where d.idtrans = t.idtrans
                                                           and t.fecini is null
                                                           and t.codcli = c.codcli
                                                           ) ;

  ---cursor detalle de transacciones analogicas
  cursor cur_detana(c_codcli vtatabcli.codcli%type) is
  select c.identificador, c.codcli,n.numero,i.codinssrv
  from collections.cxccorlimcredlog  c, numtel n, inssrv i
  where c.tipo ='F' and
        c.flgtra = 0 and
        f_verificanumero(c.nomabr) = 1 and
        n.numero = c.nomabr and
        n.codinssrv = i.codinssrv and
        i.codcli = c.codcli and
        c.codcli = c_codcli and
        -- cambio en la condición para que considere sólo inssrv en estado activo
        i.estinssrv in (1)
            -- para que no genere un nuevo registro de CLC sobre los mismo servicios -- 18/01/2008
              and (c.codcli, i.numero) not in (select t.codcli, d.nomabr
                                                           from transacciones_cable t, dettransacciones_cable d
                                                           where d.idtrans = t.idtrans
                                                           and t.fecini is null
                                                           and t.codcli = c.codcli
                                                           );

  ---reconexion CLIENTES CLC  analogicas
  cursor cur_recclcana is
  select distinct i.codcli
  from dettransacciones_cable d, inssrv  i
  where d.idtrans is null and
      d.estado = 3
      --ini 24.0
      and 1 = 2--para que no devuelva ningun dato
      --fin 24.0
      and d.codinssrv = i.codinssrv;

   ---reconexion CLIENTES CLC  analogicas detalle
  cursor cur_detrecclcana (c_codcli vtatabcli.codcli%type) is
  select d.nomabr,d.codinssrv,d.idtrans,d.estado,i.codcli
  from dettransacciones_cable d, inssrv  i
  where d.idtrans is null and
        d.estado = 3 and
        i.codcli =c_codcli and
        d.codinssrv = i.codinssrv;

  BEGIN




   for r_traana in cur_traana loop
     begin
       -- se verica primero que no exista ya un registro de CLC para ese clioente y numero
            begin

             select count(*)
                into pendientes
              from operacion.transacciones_cable t, operacion.solot s
             where t.codcli = r_traana.codcli
--               and t.nomabr = r_traana.nomabr
               and t.codsolot = s.codsolot(+)
               and (t.fecini is null or  s.estsol in (11,17,10))
               and transaccion = 'CLC'
                 ;

               exception WHEN NO_DATA_FOUND THEN pendientes := 0;
            end;

           if pendientes = 0 then
                    --genero la transaccion
                    SELECT SEQ_TRANSACCIONES_cable.NEXTVAL
                    INTO l_idtrans
                    FROM DUMMY_OPE;

                    insert into operacion.transacciones_cable(idtrans,codcli,transaccion,tipo)
                    values(l_idtrans,r_traana.codcli,'CLC',3);


                     --inserto detalle de transaccion
                     for r_detana in cur_detana(r_traana.codcli) loop
                           begin
                           insert into dettransacciones_cable(nomabr,codinssrv,idtrans,identificadorclc)
                           values (r_detana.numero,r_detana.codinssrv, l_idtrans,  r_detana.identificador);

                           update collections.cxccorlimcredlog set flgtra = 1 where  identificador = r_detana.identificador;
                           end;
                      end loop;

                      --actualizo cabecera de transaccion
                      select min(nomabr)
                      into l_minnomabr
                      from dettransacciones_cable
                      where idtrans = l_idtrans;

                      update operacion.transacciones_cable set nomabr = l_minnomabr where idtrans = l_idtrans;

                      commit;

             end if;

        end;
      end loop;--fin de cursor analogica


    for r_recclcana in cur_recclcana loop
     begin

        --genero la transaccion
        SELECT SEQ_TRANSACCIONES_cable.NEXTVAL
        INTO l_idtrans
        FROM DUMMY_OPE;

        insert into operacion.transacciones_cable(idtrans,codcli,transaccion,tipo)
        values(l_idtrans,r_recclcana.codcli,'RECCLC',3);


          --inserto detalle de transaccion
         for r_detrecclcana in cur_detrecclcana(r_recclcana.codcli) loop
               begin
               update dettransacciones_cable
               set idtrans = l_idtrans,
                   estado = 0
               where nomabr = r_detrecclcana.nomabr and
                     estado = 3;

               end;
          end loop;

          --actualizo cabecera de transaccion
          select min(nomabr)
          into l_minnomabr
          from dettransacciones_cable
          where idtrans = l_idtrans;

          update operacion.transacciones_cable set nomabr = l_minnomabr where idtrans = l_idtrans;


        end;
      end loop;--fin de cursor RECCLCANA


  END;


/**********************************************************************
Genara las sots para clc
**********************************************************************/

  PROCEDURE p_genera_CLC
  IS
  l_codsolot solot.codsolot%type;
  l_flgenviar number;
  cursor cur_tra is
  select *
  from transacciones_cable
  where transaccion = 'CLC'
  and fecini is null
  --ini 24.0
  and 1 = 2 --para que no devuelva ningun dato
  --fin 24.0
  and tipo in (3,4);
/*  cRutaArchivo constant varchar2(100) := '/u03/oracle/PESGAPRD/UTL_FILE';
  ls_enter constant varchar2(4) := chr(10) || chr(13);*/
  hArch UTL_FILE.FILE_TYPE;
  vNomArch varchar2(100);

  BEGIN

  vNomArch := 'CLCPTELFIJA.htm';
  hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'w');
  l_flgenviar := 0;


  UTL_FILE.PUT_LINE(hArch,'<html>');
  UTL_FILE.PUT_LINE(hArch,'<head>');
  UTL_FILE.PUT_LINE(hArch,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
  UTL_FILE.PUT_LINE(hArch,'<title>Corte por límite de Crédito - Telefonia Fija</title>');
  UTL_FILE.PUT_LINE(hArch,'</head>');
  UTL_FILE.PUT_LINE(hArch,'<body>');
  UTL_FILE.PUT_LINE(hArch,'<p><font color="#3366FF">CORTE POR LIMITE DE CREDITO: - '||to_char(sysdate,'dd/mm/yyyy hh24:mi') ||  '</font> </p>');

  UTL_FILE.FCLOSE(hArch);

   for c_tra in cur_tra loop
     begin
        --inserta sot
--         p_insert_sot(c_tra.codcli,3,'0004',1,891,l_codsolot);
        p_insert_sot(c_tra.codcli,451,'0004',1,891,l_codsolot);
        p_insert_solotpto_CLC(c_tra.idtrans,l_codsolot,c_tra.codcli);
        pq_solot.p_asig_wf(l_codsolot,817);

        update transacciones_cable set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
        p_enviar_notificacionesxnumero(c_tra.idtrans,'CLCPTELFIJA.htm');
        l_flgenviar := 1;

     end;
      end loop;


     if l_flgenviar > 0 then
       hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'a');
       UTL_FILE.PUT_LINE(hArch,'</body>');
       UTL_FILE.PUT_LINE(hArch,'</html>');
       UTL_FILE.FCLOSE(hArch);
     end if;

  END;


/**********************************************************************
Genara las sots para recclc
**********************************************************************/

  PROCEDURE p_genera_RECCLC
  IS
  l_codsolot solot.codsolot%type;
  l_flgenviar number;
  cursor cur_tra is
  select *
  from transacciones_cable
  where transaccion = 'RECCLC'
  --ini 24.0
  and 1 = 2 --para que no devuelva ningun dato
  --fin 24.0
  and fecini is null
-- se realiza cambio para que no considere
  and tipo in (3,4);
/*  cRutaArchivo constant varchar2(100) := '/u03/oracle/PESGAPRD/UTL_FILE';
  ls_enter constant varchar2(4) := chr(10) || chr(13);*/
  hArch UTL_FILE.FILE_TYPE;
  vNomArch varchar2(100);
  -- variable para verificar si existe SOT de CLC aún no aprobada
  estadoSot number;
  sotCLC number;
--  sotAnulada varchar2(100);

  BEGIN

  vNomArch := 'RECCLCPTELFIJA.htm';
  hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'w');
  l_flgenviar := 0;
--  sotAnulada := '';


  UTL_FILE.PUT_LINE(hArch,'<html>');
  UTL_FILE.PUT_LINE(hArch,'<head>');
  UTL_FILE.PUT_LINE(hArch,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
  UTL_FILE.PUT_LINE(hArch,'<title>Reconexiones CLC - Telefonia Fija</title>');
  UTL_FILE.PUT_LINE(hArch,'</head>');
  UTL_FILE.PUT_LINE(hArch,'<body>');
  UTL_FILE.PUT_LINE(hArch,'<p><font color="#3366FF">RECONEXION CLC: - '||to_char(sysdate,'dd/mm/yyyy hh24:mi') ||  '</font> </p>');

  UTL_FILE.FCLOSE(hArch);

   for c_tra in cur_tra loop
     begin
          --verifico si existe una SOT de CLC para la línea y el cliente
          estadoSot := 0;
          sotCLC := 0;

          select Nvl(max(codsolot), 0) into sotCLC
          from transacciones_cable
          where transaccion = 'CLC' and codcli = c_tra.codcli and nomabr = c_tra.nomabr and tipo in (3,4) ;

          if(sotCLC > 0) then
            select Nvl(estsol, 0) into estadoSot
            from solot
            where codsolot = sotCLC ;
          end if;

          if ( sotCLC > 0 ) and ( estadoSot = 11 ) then
            begin
             -- Se anula SOT CLC y se inserta observación
             update solot set estsol = 13, observacion = 'SOT anulada antes de entrar en ejecución, por activación de servicio por pago de deuda de cliente (proceso automático)' where codsolot = sotCLC ;
             -- Se registra LOG de cambio de estado
             insert into solotchgest (codsolot, tipo, estado, fecha, codusu) values (sotCLC,1,13,sysdate,user);
--             sotAnulada:= 'SOT '|| sotCLC || ' de Corte por Límite de Crédito, fue anulada' ;
--             l_flgenviar := 1;
             -- SE COLOCA EL NÚMERO DE LA SOT ANULADA EN EL REGISTRO DE LA TRANSACCIÓN DE RECONEXIÓN
             update transacciones_cable set fecini = sysdate, codsolot = sotCLC where idtrans = c_tra.idtrans ;
/*             p_envia_correo_c_attach('Reconexion CLC - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi')||' ANULACIÓN DE SOT '||sotCLC||' (CLC) POR PAGO DE DEUDA','DL-PE-CONMUTACION','Reconexiones CLC - Telefonia Fija - Anulación de SOT '|| sotCLC || 'por pago de deuda, ' ||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
*/
            end;
          else
            begin
              --inserta sot
              p_insert_sot(c_tra.codcli,452,'0004',1,891,l_codsolot);
              p_insert_solotpto_CLC(c_tra.idtrans,l_codsolot,c_tra.codcli);
              pq_solot.p_asig_wf(l_codsolot,818);

              update transacciones_cable set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
              p_enviar_notificacionesxnumero(c_tra.idtrans,'RECCLCPTELFIJA.htm');
              l_flgenviar := 1;
            end  ;
          end if;


     end;
      end loop;


     if l_flgenviar > 0 then
       hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'a');
       UTL_FILE.PUT_LINE(hArch,'</body>');
       UTL_FILE.PUT_LINE(hArch,'</html>');
       UTL_FILE.FCLOSE(hArch);
/*       p_envia_correo_c_attach('Reconexion CLC - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CONMUTACION@claro.com.pe','Reconexiones CLC - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
*/     end if;

  END;


/**********************************************************************
Insertar los puntos de lineas analogicas a la sot CLC
**********************************************************************/

  PROCEDURE p_insert_solotpto_CLC(v_idtrans transacciones.idtrans%type,
                                        v_codsolot solot.codsolot%type,
                                        v_codcli solot.codcli%type
                                        ) IS
  cursor cur_numeros is
  select distinct i.codsrv codsrvnue,i.bw bwnue,i.numero,i.codinssrv,i.cid,i.descripcion,i.direccion,2 tipo, 1 estado, 1 visible, i.codubi,1 flgmt
  from inssrv i, dettransacciones_cable d
  where d.idtrans = v_idtrans and
        d.codinssrv = i.codinssrv;
  l_cont number;

  BEGIN
  l_cont := 1;
     for c_ana in cur_numeros loop
        begin
         insert into solotpto(codsolot, punto,codsrvnue,bwnue,codinssrv,cid,descripcion,direccion,tipo,estado,visible,codubi,flgmt)
        values(v_codsolot,l_cont,c_ana.codsrvnue,c_ana.bwnue,c_ana.codinssrv,c_ana.cid,c_ana.descripcion,c_ana.direccion,c_ana.tipo,c_ana.estado,c_ana.visible,c_ana.codubi,c_ana.flgmt);
/*        insert into dettransacciones(idtrans,nomabr,codinssrv)
        values(v_idtrans,c_ana.numero,c_ana.codinssrv);*/
        l_cont := l_cont + 1;
        end;
      end loop;
  END;

-- Author  : MIGUEL.LONDONA
-- Created : 21/01/2009 11:24:51
-- Purpose : Verificar si el servicio es de Claro TV SAT

/*Modificación se agrega e.tipoestado <> 3 para que no se consideren registros con baja en reginsdth
 26/02/2009 JRAMOSM*/

function f_servicio_cablesat(pidfac char, pnumregistro out char, pflg_recarga out number) return number is
  Result number;
  ls_numregistro reginsdth.numregistro%type;
  ln_flg_recarga reginsdth.flg_recarga%type;
  l_cuenta_reg number;
begin
--<7.0
--ini 22.0
--select count(distinct numregistro)
select count(distinct r.numregistro)
--fin 22.0
      into l_cuenta_reg
      --ini 22.0
      --from bilfac b, cr c, instxproducto i, reginsdth r, estregdth e
      from bilfac b, cr c, instxproducto i, ope_srv_recarga_cab r,ope_srv_recarga_det e
      --fin 22.0
     where b.idbilfac = c.idbilfac
       and c.idinstprod = i.idinstprod
       --ini 22.0
       --and i.pid = r.pid
       and i.pid = e.pid
       --and r.estado=e.codestdth
       and r.numregistro = e.numregistro
       --fin 22.0
       and b.idfaccxc = pidfac
       --and e.tipoestado <> 3
       --ini 22.0
       --and nvl(e.tipoestado,0) <> 3; --<15.0>
       and r.estado <> '04'; --diferente de cancelado
       --fin 22.0
--7.0>
if (l_cuenta_reg <=1) then --<7.0>
  begin
    --ini 22.0
    --select distinct numregistro, nvl(flg_recarga,0)
    select distinct r.numregistro, nvl(flg_recarga,0)
    --fin 22.0
      into ls_numregistro, ln_flg_recarga
      --ini 22.0
      --from bilfac b, cr c, instxproducto i, reginsdth r, estregdth e
      from bilfac b, cr c, instxproducto i, ope_srv_recarga_cab r, ope_srv_recarga_det e
      --fin 22.0
     where b.idbilfac = c.idbilfac
       and c.idinstprod = i.idinstprod
       --ini 22.0
       --and i.pid = r.pid
       and i.pid = e.pid
       --and r.estado=e.codestdth
       and r.numregistro = e.numregistro
       --fin 22.0
       and b.idfaccxc = pidfac
       --and e.tipoestado <> 3
       --ini 22.0
       --and nvl(e.tipoestado,0) <> 3; --<15.0>
       and r.estado <> '04'; --diferente de cancelado
       --fin 22.0
    Result := 1;
  exception
    when no_data_found then
       ls_numregistro :=null;
       ln_flg_recarga :=0;
       Result := 0;
  end;
--<7.0
  else
  p_envia_correo_c_attach('Reconexion DTH Factura cancelada',
                                 'melvin.balcazar@claro.com.pe',--23.0
                                 'Doble registro con mismo PID activo en Reginsdth; Factura: ' ||
                                 pidfac,
                                 null,
                                 'SGA');
   p_envia_correo_c_attach('Reconexion DTH Factura cancelada',
                                 'jose.ramos@claro.com.pe',--23.0
                                 'Doble registro con mismo PID activo en Reginsdth; Factura: ' ||
                                 pidfac,
                                 null,
                                 'SGA');
end if;
--7.0>
  pnumregistro := ls_numregistro;
  pflg_recarga := ln_flg_recarga;
  return(Result);
end f_servicio_cablesat;


/**********************************************************************
Función invocada por un job, lee los cxctabfac cancelados para generar la reconexión automática de cable
**********************************************************************/

  PROCEDURE p_genera_rec_por_fac_cancelada IS

  ------------------------------------
  --VARIABLES PARA EL ENVIO DE CORREOS
  c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.PQ_CORTESERVICIO_CABLE.P_GENERA_REC_POR_FAC_CANCELADA';
  c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='682';
  c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
  --------------------------------------------------



  cursor cur_fac_cable is
    select idrecpago, idfac, codcli, nomabr
      from operacion.reconexionporpago_BOGA
     --where flgleido = 0;
     where flgleido = '0';--<18.0>

tieneCorte number;
emitidos number;
id_error operacion.reconexionporpago_BOGA.idrecpago%type;
ls_numregistro reginsdth.numregistro%type;
ln_flg_recarga number;

  BEGIN
      for c_fac_cable in cur_fac_cable loop
        begin
             -- para ver el error cuando se cae el job
             id_error := c_fac_cable.idrecpago              ;

             update operacion.reconexionporpago_BOGA set flgleido = 1, obs = 'Leído' where idrecpago = c_fac_cable.idrecpago;

             -- Si el servicio es de tvsat
             if f_servicio_cablesat(c_fac_cable.idfac,ls_numregistro,ln_flg_recarga) = 1 then
                 if ln_flg_recarga = 1 then
                    -- Si ya pertenence a recarga no debe verificar las suspenciones generadas por el sistema normal.
                    tieneCorte := 0;
                    --<12.0
                    update operacion.reconexionporpago_BOGA
                       set obs = 'Asociado a registro DTH con recarga'
                     where idrecpago = c_fac_cable.idrecpago;
                    --12.0>
                    GOTO VALIDA_CORTE;
                 else
                    --<12.0
                   update operacion.reconexionporpago_BOGA
                      set obs = 'Asociado a registro DTH sin recarga'
                    where idrecpago = c_fac_cable.idrecpago;
                    --12.0>
                    operacion.pq_control_dth.p_act_fechasxpago(ls_numregistro);
                    --<REQ ID = 84617>
                    operacion.pq_control_dth.p_gen_reconexion_adic(c_fac_cable.idfac,ls_numregistro);
                    --</REQ>
                 end if;
             end if;

             select count(*)
               into tieneCorte
               from transacciones_CABLE
              where codcli = c_fac_cable.codcli
                and nomabr = c_fac_cable.nomabr
                and transaccion in ('SUSPENSION', 'CLC', 'CORTE')
                and fecfin is null;

             <<VALIDA_CORTE>>
             if tieneCorte > 0 then

               --verifico que no existan otros documentos, para el cliente y la lìnea, que estèn pendientes de cancelar
  --             if collections.f_get_adeudados_BOGA(c_fac_cable.codcli, c_fac_cable.nomabr) = 0 then

               if (f_verificaVoz(c_fac_cable.nomabr) )= 0 then
                emitidos := collections.f_get_emitidos_boga(c_fac_cable.codcli, c_fac_cable.nomabr, c_fac_cable.idfac);
               else
                emitidos := collections.f_get_emitidos_boga_voz(c_fac_cable.codcli, c_fac_cable.nomabr, c_fac_cable.idfac);
               end if;

               if emitidos = 0 then
                 BEGIN
                     p_genera_transaccion_RECCLC(c_fac_cable.idfac, c_fac_cable.codcli , c_fac_cable.nomabr);
                     p_genera_transaccion_REC_CABLE(c_fac_cable.idfac , c_fac_cable.codcli , c_fac_cable.nomabr );
                 END;
               else
                  update operacion.reconexionporpago_BOGA set obs = 'Aún con documentos adeudados.' where idrecpago = c_fac_cable.idrecpago;
               end if;

             else
                --if ls_numregistro is not null then
                    --CASO: No tiene corte y es un recibo de DTH
                    --Enviar el bouquet adicional a reconectar
                --end if;
                null;

             end if;
        end;
        commit;
      end loop;
--<13.0
      operacion.pq_corteservicio_cable.p_insert_cancelacion_nc_cable;

-- INSERTA LOS RECIBOS CANCELADOS CON NOTA DE CRÉDITO PARA QUE SE RECONECTE EL SERVICIO
   /* insert into operacion.reconexionporpago_boga
      SELECT DISTINCT NULL,IDFAC,CODCLI,NOMABR,SYSDATE,USER,0,0,'',1
        FROM TRANSACCIONES_CABLE
       WHERE IDFAC IN
             (select IDFACCAN
                from faccanfac
               where fecusu > to_date('06/08/2008','dd/mm/yyyy') -- INICIO CORTE DE AUTOMATIZACION CORTES Y RECONEXIONES TRIPLE PLAY
                 AND idfaccan in (select idfac
                                    from transacciones_cable
                                   where TIPO = 15 AND transaccion = 'SUSPENSION' -- POR EL MOMENTO SOLO TIPO 15, TRIPLE PLAY
                                     AND FECFIN IS NULL));*/ --Se cambia por el procedimiento p_cancelacion_nc 13.0>

  --------------------------------------------------
  ---ester codigo se debe poner en todos los stores
  ---que se llaman con un job
  --para ver si termino satisfactoriamente
  sp_rep_registra_error
     (c_nom_proceso || 'Id de error: ' ||id_error, c_id_proceso,
      sqlerrm , '0', c_sec_grabacion);

  exception
     when others then
        sp_rep_registra_error
           (c_nom_proceso || 'Id de error: ' ||id_error, c_id_proceso,
            sqlerrm , '1',c_sec_grabacion );
        raise_application_error(-20000,sqlerrm);

  END;



/**********************************************************************
Genara las transacciones para las reconexionesLC este método es invocado por el trigger COLLECTIONS.T_CXCTABFAC_AU
**********************************************************************/

PROCEDURE p_genera_transaccion_RECCLC(v_idfac COLLECTIONS.CXCTABFAC.IDFAC%type, v_codcli COLLECTIONS.CXCTABFAC.CODCLI%type, v_nomabr COLLECTIONS.CXCTABFAC.NOMABR%type)
  IS

  cursor cur_suspension(c_idfac COLLECTIONS.CXCTABFAC.IDFAC%type,  l_codcli COLLECTIONS.CXCTABFAC.CODCLI%type, l_nomabr COLLECTIONS.CXCTABFAC.NOMABR%type) is
    select d.*, t.tipo
    from OPERACION.DETTRANSACCIONES_CABLE d, OPERACION.TRANSACCIONES_CABLE t, marketing.vtatabcli v
    where t.transaccion = 'CLC' and
    t.idtrans = d.idtrans and
    t.codcli = v.codcli and
    d.estado = 1 and
--    t.idfac =  c_idfac and
    t.codcli = l_codcli and
    t.nomabr = l_nomabr;

    l_idrecpago number;

  BEGIN
  -- obtiene el registro de la suspensión sobre la que se va areconectar la línea por medio del número de teléfono
  for c_sus in cur_suspension(v_idfac, v_codcli, v_nomabr) loop
     begin
         -- verifico que no existan otros documentos, para el cliente y la lìnea, que estèn pendientes de cancelar
         --if collections.f_get_cxtabfac_adeudados(v_codcli, v_nomabr) = 0 then

           -- inserta la reconexión a la que se le asignará una SOT con el procedimiento que corre con la SOT (a partir de la suspensión obtenida)
           INSERT INTO OPERACION.DETTRANSACCIONES_CABLE (NOMABR, CODINSSRV, IDENTIFICADORCLC, ESTADO, CODUSU)
              VALUES (c_sus.nomabr,c_sus.codinssrv,c_sus.IDENTIFICADORCLC,c_sus.tipo,'TRIGGER');
           -- actualiza el registro de la suspensión sobre la que se reconectó, se coloca el estado a cero para que ya no se considere en proximas reconexiones (a partir de la suspensión obtenida)
           UPDATE DETTRANSACCIONES_CABLE
              SET ESTADO = 0
              WHERE NOMABR = c_sus.nomabr AND CODINSSRV = c_sus.codinssrv AND IDTRANS = c_sus.idtrans AND IDENTIFICADORCLC = c_sus.IDENTIFICADORCLC AND ESTADO = c_sus.estado;
           -- activo el flag flgreconectado de la tabla operacion.reconexionporpago para indicar que se llevo a cabo la reconexión
           select max(idrecpago) into l_idrecpago
           from operacion.reconexionporpago_boga
           where idfac = v_idfac and codcli = v_codcli and nomabr = v_nomabr;
           update operacion.reconexionporpago_boga set flgreconectado = 1, obs='Con suspensión previa, Reconexión CLC efectuada' where idrecpago = l_idrecpago and flgreconectado = 0;
         --end if;
     end;
  end loop;
  p_genera_transaccionclc;
  p_genera_recclc;
END;


/**********************************************************************
Genera las transacciones para las RECONEXIONES DE CLBLE este método es invocado por el trigger COLLECTIONS.T_CXCTABFAC_AU
**********************************************************************/

  PROCEDURE  p_genera_transaccion_REC_CABLE(v_idfac COLLECTIONS.CXCTABFAC.IDFAC%type, v_codcli COLLECTIONS.CXCTABFAC.CODCLI%type, v_nomabr COLLECTIONS.CXCTABFAC.NOMABR%type)
  IS
  -- obtiene el registro de la suspensión sobre la que se va areconectar la línea por medio del nombre del cliente
  cursor cur_suspension(c_idfac COLLECTIONS.CXCTABFAC.IDFAC%type,  l_codcli COLLECTIONS.CXCTABFAC.CODCLI%type, l_nomabr COLLECTIONS.CXCTABFAC.NOMABR%type) is

    select *
    from OPERACION.transacciones_CABLE
    where TRANSACCION in ('SUSPENSION','CORTE')
    AND FECFIN IS NULL
    and fecini is not null -- Se incluye esta condicion pq se estan generando reconex para suspensiones que aún no tienen
    -- sot generada, G. ORMENO, J. RAMOS 16/01/2009
    --ini 21.0
    --AND TIPO in (10,12,15) -- TIPO 10 ==> CABLE (BOGA), SE ADICIONA EL TIPO 15 PARA TRIPLE PLAY
    --ini 24.0
    --AND TIPO in (10,15) --Se quito el tipo 12 que va a ser tratado por el nuevo proceso de corte
    and 1 = 2 --Cursor ya no debe devolver data. Cable Analogico y Triple Play seran tratados por el nuevo proceso de cortes
    --fin 24.0
    --fin 21.0
    --    AND idfac = c_idfac -- "DESCOMENTO", PARA SOLO REGISTRAR RECONEXIÓN DE LA SUPENSIÓN ASOCIADA AL DOCUMENTO
    AND CODCLI = l_codcli
    AND (NOMABR = l_nomabr OR F_VERIFICA_DOCUMENTOS(idfac,v_idfac) = 0 ) ; -- VERIFICA SI LOS RECIBOS SON DEL MISMO SERVICIO.


    l_idrecpago number;

  BEGIN
  for c_sus in cur_suspension(v_idfac, v_codcli, v_nomabr) loop
     begin
           -- inserta la reconexión a la que se le asignará una SOT con el procedimiento que corre con el JOB (a partir de la suspensión obtenida)
           INSERT INTO OPERACION.TRANSACCIONES_CABLE (IDFAC, NOMABR, CODCLI, TRANSACCION, CODUSU, IDTRANSORI, TIPO)
           VALUES (v_idfac,v_nomabr,c_sus.CODCLI, 'ACTIVACION', user,c_sus.IDTRANS,c_sus.tipo);
           -- actualiza el registro de la suspensión sobre la que se reconectó, se coloca la fech fin para que ya no se considere en proximas reconexiones (a partir de la suspensión obtenida)
           UPDATE OPERACION.TRANSACCIONES_CABLE
           SET FECFIN = sysdate
           WHERE IDTRANS = c_sus.IDTRANS;
           -- activo el flag flgreconectado de la tabla operacion.reconexionporpago para indicar que se llevo a cabo la reconexión
           select max(idrecpago) into l_idrecpago
           from operacion.reconexionporpago_BOGA
           where (idfac = v_idfac /*or idfac is null*/ ) and codcli = v_codcli;-- and nomabr = v_nomabr;
           update operacion.reconexionporpago_BOGA set flgreconectado = 1, obs='Con suspensión previa, Reconexión CABLE efectuada' where idrecpago = l_idrecpago and flgreconectado = 0;
         --end if;
     end;
  end loop;
  p_genera_reconexion_CABLE;

  END;

/**********************************************************************
Genera las transacciones para las SUSPENSIONES DE CLBLE este método es invocado por UN JOB
**********************************************************************/

PROCEDURE  p_genera_trans_CORTE_CABLE
  IS


  -- obtiene el registro de la suspensión sobre la que se va a reconectar la línea por medio del nombre del cliente
cursor cur_suspension is

    select *
      from operacion.pretransacciones_cable where Idfac
      in
      (
            SELECT IDFAC FROM operacion.pretransacciones_cable
            MINUS  --<17.0
            select idfac from transacciones_cable t where transaccion in ('SUSPENSION','CORTE') and fecfin is null
            --select idfac from transacciones_cable t where transaccion = 'SUSPENSION' and fecfin is null --17.0>
      )
    ;

    l_idrecpago number;

---------------------------------------------------------------------------------------------------------
--/*************************************** QUERY NUEVA 01-08-2008 ***************************************
-- Cursor a emplear
cursor cur_corte is

SELECT T.idtrans,
       T.idfac,
       T.nomabr,
       T.codcli,
       T.transaccion,
       T.tipo,
       a.sldact,
       v.nomcli,
       c.descripcion,
       a.sersut || '-' || a.numsut,
       a.fecemi,
       a.fecven
  FROM OPERACION.TRANSACCIONES_CABLE T,
       cxctabfac                     a,
       categoria                     c,
       vtatabcli                     v,
       solot                         s,
       estsol                        e
 WHERE tipo = 15
   --ini 24.0
   and 1 = 2 --para que no devuelva ningun registro
   --fin 24.0
   and TRANSACCION = 'SUSPENSION'
   AND T.FECFIN IS NULL
   AND T.IDFAC = a.IDFAC
   AND T.CODCLI = TO_NUMBER(v.codcli)
   AND v.idcategoria = c.idcategoria(+)
   and s.codsolot = t.codsolot
   AND s.fecfin + 20 < sysdate
   and s.estsol = e.estsol
   and e.estsol = 12
   AND a.estfacrec = 0
   AND f_verificaVoz(T.nomabr) > 0;

  BEGIN
  for c_sus in cur_suspension loop
     begin
           -- inserta la suspensión a la que se le asignará una SOT con el procedimiento que corre con el JOB
           INSERT INTO OPERACION.TRANSACCIONES_cable (IDFAC, NOMABR, CODCLI, TRANSACCION, CODUSU, IDTRANSORI, TIPO)
           VALUES (c_sus.idfac,c_sus.nomabr,c_sus.codcli, 'SUSPENSION', user,null,c_sus.tipo);
     end;
  end loop;

  -- Loop para recorrer el cursor
  for c_cor in cur_corte loop
    begin
    -- inserta el corte a la que se le asignará una SOT con el procedimiento que corre con el JOB
      INSERT INTO OPERACION.TRANSACCIONES_CABLE (IDFAC, NOMABR, CODCLI, TRANSACCION, CODUSU, IDTRANSORI, TIPO)
      VALUES (c_cor.idfac,c_cor.nomabr,c_cor.codcli, 'CORTE', user,c_cor.idtrans,c_cor.tipo);
      -- cierra la suspensión correspondiente, no volverá a ser considerada en la siguiente corrida del job.
      UPDATE OPERACION.TRANSACCIONES_CABLE
      SET FECFIN = sysdate
      WHERE IDFAC = c_cor.idfac AND (FECFIN IS NULL) AND (TRANSACCION IN ('SUSPENSION'));
    end;
  end loop;

  END;


/**********************************************************************
Genara las sots para reconexiones de Cable - Boga
**********************************************************************/

  PROCEDURE p_genera_reconexion_CABLE
  IS
  l_codsolot solot.codsolot%type;
  l_flgenviar number;
  l_numpuntos number; --variable util para ubicar la instancia de paquete

----------------------------------------------------------------------------------------------------------
--********************************************** QUERY ANTIGUA 01-08-2008 ********************************
/*  cursor cur_tra is
  select *
  from transacciones_CABLE
  where transaccion = 'ACTIVACION'
  and fecini is null
  and tipo in (10,12);
*/
  -- Cursor que lee las transacciones (línea 364)
----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------
--******************************************* QUERY MODIFICADA 01-08-2008 ********************************
  cursor cur_tra is
  select *
  from transacciones_CABLE
  where transaccion = 'ACTIVACION'
  and fecini is null
  --ini 21.0
  --and tipo in (10,12, 15); -- se incluye el tipo 15 para Triple Play
  --ini 24.0
  --and tipo in(10,15)
  and 1 = 2; --Cursor ya no debe devolver data, cable analogico y triple play deben ser manejados por el nuevo proceso de cortes
  --fin 24.0
  --fin 21.0
----------------------------------------------------------------------------------------------------------


/*  cRutaArchivo constant varchar2(100) := '/u03/oracle/PESGAPRD/UTL_FILE';
  ls_enter constant varchar2(4) := chr(10) || chr(13);*/
  hArch UTL_FILE.FILE_TYPE;
  vNomArch varchar2(100);

  -- variable para verificar si existe SOT de corte Cable aún no ejecutada
  estadoTareaSot number;
  sotCXPL number;
  existeSOT number;
  existeTarea number;
  tareaAgenda tareawf.idtareawf%type;
  tareaActivacion tareawf.idtareawf%type;

  BEGIN

  vNomArch := 'RCNXCABLE.htm';
  hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'w');
  l_flgenviar := 0;

  UTL_FILE.PUT_LINE(hArch,'<html>');
  UTL_FILE.PUT_LINE(hArch,'<head>');
  UTL_FILE.PUT_LINE(hArch,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
  UTL_FILE.PUT_LINE(hArch,'<title>Reconexion por falta de pago - Xplora</title>');
  UTL_FILE.PUT_LINE(hArch,'</head>');
  UTL_FILE.PUT_LINE(hArch,'<body>');
  UTL_FILE.PUT_LINE(hArch,'<p><font color="#3366FF">RECONEXION POR FALTA DE PAGO: - '||to_char(sysdate,'dd/mm/yyyy hh24:mi') ||  '</font> </p>');

  UTL_FILE.FCLOSE(hArch);

   for c_tra in cur_tra loop
     begin
        --verifico si existe una SOT de corte Explora para la línea y el cliente
          estadoTareaSot := 0;
          sotCXPL := 0;
          existeTarea := 0;

          select Nvl(max(codsolot), 0) into sotCXPL -- sot de corte previo
          from transacciones_CABLE
          where transaccion in ('SUSPENSION','CORTE') and codcli = c_tra.codcli and nomabr = c_tra.nomabr and tipo in (10,15) ;

          SELECT COUNT(*) INTO existeSOT FROM SOLOT WHERE CODSOLOT = sotCXPL; -- si la SOT existe

          IF( existeSOT > 0 ) then
              if(sotCXPL > 0) then
                  SELECT COUNT(*) INTO existeTarea FROM SOLOT s, wf, tareawf t WHERE t.idwf = wf.idwf and t.tareadef = 667 and wf.codsolot = s.codsolot and s.CODSOLOT = sotCXPL;
                  if (existeTarea > 0) then
                     select Nvl(esttarea, 0), t.idtareawf into estadoTareaSot, tareaAgenda
                     from wf, tareawf t
                     where t.idwf = wf.idwf and tareadef = 667 and wf.codsolot = sotCXPL and valido = 1 ;
                  end if;
              end if;
          else
              sotCXPL := 0;
          end if;

          if ( sotCXPL > 0 ) and ( estadoTareaSot = 1 ) then
            begin
              if ( c_tra.tipo = 10 ) then
                 -- Se anula SOT CLC y se inserta observación
                 update solot set estsol = 13, observacion = 'SOT anulada antes de entrar en ejecución, por activación de servicio por pago de deuda de cliente (proceso automático)' where codsolot = sotCXPL ;
                 -- Se registra LOG de cambio de estado
                 insert into solotchgest (codsolot, tipo, estado, fecha, codusu) values (sotCXPL,1,13,sysdate,user);
                 -- SE COLOCA EL NÚMERO DE LA SOT ANULADA EN EL REGISTRO DE LA TRANSACCIÓN DE RECONEXIÓN
                 update transacciones_CABLE set fecini = sysdate, codsolot = sotCXPL where idtrans = c_tra.idtrans ;
                 --<8 SE ENVÍA CORREO INFORMANDO SOBRE LA SOT ANULADA Y LA CONTINUIDAD DEL SERVICIO
                 --p_envia_correo_c_attach('Reconexion Servicio de Cable - '||to_char(sysdate,'dd/mm/yyyy hh24:mi')||' ANULACIÓN DE SOT '||sotCXPL||' (CORTE DE CABLE POR FALTA DE PAGO) POR PAGO DE DEUDA','eduardo.rojas@claro.com.pe','Reconexiones CFP - Cable - Anulación de SOT '|| sotCXPL || 'por pago de deuda, ' ||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');--8>
                 p_envia_correo_c_attach('Reconexion Servicio de Cable - '||to_char(sysdate,'dd/mm/yyyy hh24:mi')||' ANULACIÓN DE SOT '||sotCXPL||' (CORTE DE CABLE POR FALTA DE PAGO) POR PAGO DE DEUDA','carlos.teran@claro.com.pe','Reconexiones CFP - Cable - Anulación de SOT '|| sotCXPL || 'por pago de deuda, ' ||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
              elsif c_tra.tipo = 15 then
                   if f_cuenta_puntos_cable(c_tra.idfac) > 0 then
                    -- Cancelo la tarea de agendamiento no ejecutada para la SOT de suspensiòn.
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(tareaAgenda,5,5,0,SYSDATE,SYSDATE);
                    -- Anulo las transacciones de cable analògico pendientes
                    -- Se comenta el update G:ORMENO 20/08/2008
--                    update trssolot set esttrs = 3 where codsolot = sotCXPL and esttrs = 1;
                    -- Cierro la tarea de ACtivaciòn, con lo que debe de cerrarse la SOT.

                     /*select t.idtareawf into tareaActivacion
                     from wf, tareawf t
                     where t.idwf = wf.idwf and tareadef = 299 and wf.codsolot = sotCXPL  ;
                     OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(tareaActivacion,4,4,0,SYSDATE,SYSDATE);*/

                     -- Se ejecuta la tarea de Avtivacion/ Desactivacion de la SOT de susp., G. ORMENO 20/08/2008
                    operacion.p_ejecuta_activ_desactiv(sotCXPL,299,sysdate);

                    -- Creo la SOt de Reconexiòn.
                    p_insert_sot(c_tra.codcli,443,'0061',1,16,l_codsolot);
                    l_numpuntos := 0;
                    -- Inserto sòlo puntos digitales, ya que el cable analògico no se llegò a desactivar.
                    --p_insert_solotpto_cable_dig(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac/*,c_inspaq.idinsxpaq*/);
                    p_insert_solotpto_cable(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac/*,c_inspaq.idinsxpaq*/);
                    -- Actualizo la transacciòn
                    update transacciones_CABLE set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
                    p_enviar_notificaciones(c_tra.idtrans,'RCNXCABLE.htm');
                    l_flgenviar := 1;
                    -- se asigna wf
                    OPERACION.PQ_SOLOT.p_ejecutar_solot(l_codsolot);
                    -- Obtengo la tarea de Agendamiento de la SOT de reconexiòn
                    SELECT COUNT(*) INTO existeTarea FROM SOLOT s, wf, tareawf t WHERE t.idwf = wf.idwf and t.tareadef = 667 and wf.codsolot = s.codsolot and s.CODSOLOT = l_codsolot;
                    if (existeTarea > 0) then
                       select Nvl(esttarea, 0), t.idtareawf into estadoTareaSot, tareaAgenda
                       from wf, tareawf t
                       where t.idwf = wf.idwf and tareadef = 667 and wf.codsolot = l_codsolot and valido = 1;
                       -- Cancelo la tarea de agendamiento.
                       OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(tareaAgenda,5,5,0,SYSDATE,SYSDATE);

                    end if;
                    -- Se ejecuta la tarea de Avtivacion/ Desactivacion de la SOT de reconexión, G. ORMENO 20/08/2008
                    operacion.p_ejecuta_activ_desactiv(l_codsolot,299,sysdate);
/*                   else
                        --p_envia_correo_c_attach('Reconexión por Falta de Pago - Servicio de Cable - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno@claro.com.pe','SOT sin puntos activos, no generada - Cable. (IDFAC,NOMABR,CODCLI) = ('|| c_tra.idfac ||','||c_tra.nomabr||','||c_tra.codcli ||') ' ||to_char(sysdate,'dd/mm/yyyy hh24:mi'),null,'SGA');
                        -- NO SE GENERA SOLOT PORQUE NO SE UBICAN PUNTOS, POSIBLEMENTE EL SERVICIO Y ATENGA BAJA O EL RECIBO NO ESTE ASOCIADO A NINGÚN SERVICIO.
*/                 end if;
              end if;

            end;
          else
            begin
               if f_cuenta_puntos_cable(c_tra.idfac) > 0 then
                     if c_tra.tipo = 10 then
                             p_insert_sot(c_tra.codcli,410,'0061',1,16,l_codsolot);
                             l_numpuntos := 0;
                             p_insert_solotpto_cable(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac/*,c_inspaq.idinsxpaq*/);
                      elsif c_tra.tipo = 12 then
                             p_insert_sot(c_tra.codcli,428,'0061',1,16,l_codsolot);
                             l_numpuntos := 0;
                             p_insert_solotpto_cable(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac);
---------------------------------------------------------------------------------------------------------
--****************************************** QUERY AGREGADA 01-08-2008 **********************************
 -- Loop que recorre cada registro de transacciones pendientes (línea 451)
                      elsif c_tra.tipo = 15 then
                             p_insert_sot(c_tra.codcli,443,'0061',1,16,l_codsolot);
                             l_numpuntos := 0;
                             p_insert_solotpto_cable(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac/*,c_inspaq.idinsxpaq*/);
----------------------------------------------------------------------------------------------------------
                      end if;

                      update transacciones_CABLE set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
                      p_enviar_notificaciones(c_tra.idtrans,'RCNXCABLE.htm');
                      l_flgenviar := 1;
                      -- se asigna wf
                      OPERACION.PQ_SOLOT.p_ejecutar_solot(l_codsolot);
/*                 else
                      p_envia_correo_c_attach('Reconexión por Falta de Pago - Servicio de Cable - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno@claro.com.pe','SOT sin puntos activos, no generada - Cable. (IDFAC,NOMABR,CODCLI) = ('|| c_tra.idfac ||','||c_tra.nomabr||','||c_tra.codcli ||') ' ||to_char(sysdate,'dd/mm/yyyy hh24:mi'),null,'SGA');
*/                 end if;
             end  ;
          end if;

     end;
      end loop;

     if l_flgenviar > 0 then
       hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'a');
       UTL_FILE.PUT_LINE(hArch,'</body>');
       UTL_FILE.PUT_LINE(hArch,'</html>');
       UTL_FILE.FCLOSE(hArch);

         --<8 p_envia_correo_c_attach('Reconexion - Servicio de Cable - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'eduardo.rojas@claro.com.pe','Reconexion - Cable - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA'); 8>--
           p_envia_correo_c_attach('Reconexion Servicio de Cable - '||to_char(sysdate,'dd/mm/yyyy hh24:mi')||' ANULACIÓN DE SOT '||sotCXPL||' (CORTE DE CABLE POR FALTA DE PAGO) POR PAGO DE DEUDA','carlos.teran@claro.com.pe','Reconexiones CFP - Cable - Anulación de SOT '|| sotCXPL || 'por pago de deuda, ' ||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');

     end if;
  END;


/***********************************************************************
Inserta sots de telefonia fija
**********************************************************************  */

  PROCEDURE p_insert_sot(v_codcli in solot.codcli%type,
                         v_tiptra in solot.tiptra%type,
                         v_tipsrv in solot.tipsrv%type,
                         v_grado in solot.grado%type,
                         v_motivo in solot.codmotot%type,
                         v_codsolot out number ) IS

  BEGIN

  v_codsolot:=  F_GET_CLAVE_SOLOT();
  insert into solot(codsolot, codcli, estsol, tiptra,tipsrv, grado,codmotot,areasol)-- tiprec, feccom, fecini, fecfin, fecultest)
  values (v_codsolot, v_codcli, 11, v_tiptra,v_tipsrv,v_grado,v_motivo,202);-- 'S', sysdate, sysdate, sysdate, sysdate);

  END;


/**********************************************************************
Insertar el detalle de un paquete
**********************************************************************/

  PROCEDURE p_insert_solotpto_cable(v_idtrans transacciones.idtrans%type,
                                        v_codsolot solot.codsolot%type,
                                        v_codcli solot.codcli%type,
                                        v_idfac cxctabfac.idfac%type/*,
                                        v_idpaq number*/) IS
  cursor cur_servicios is
  select distinct so.codsrv codsrvnue,so.numero,so.bw bwnue,so.codinssrv,so.cid,so.descripcion,so.direccion,2 tipo,1 estado,1 visible, so.codubi, 1 flgmt--, i.pid
  from /*vtadetptoenl vs, */inssrv so--, insprd i
  where so.codinssrv in (
        select codinssrv from inssrv where codinssrv in (
        select codinssrv from insprd where pid in (
        select pid from instxproducto where idinstprod in (
        select idinstprod from cr where idbilfac in (
        select idbilfac from bilfac where idfaccxc = v_idfac)))) -- nuevos
  )
  and so.estinssrv not in (4,3)
--  and so.codinssrv = i.codinssrv(+) and i.flgprinc = 1
;


  l_cont number;
  l_contmax number;

  BEGIN
  l_cont := 1;
  l_contmax := 0;
  select max(punto)
  into l_contmax
  from solotpto
  where codsolot = v_codsolot;

  if l_contmax > 1
  then l_cont := l_contmax +1;
  end if;

     for c_servicios in cur_servicios loop
        begin
/*         insert into solotpto(codsolot, punto,codsrvnue,bwnue,codinssrv,cid,descripcion,direccion,tipo,estado,visible,codubi,flgmt)
        values(v_codsolot,l_cont,c_servicios.codsrvnue,c_servicios.bwnue,c_servicios.codinssrv,c_servicios.cid,c_servicios.descripcion,c_servicios.direccion,c_servicios.tipo,c_servicios.estado,c_servicios.visible,c_servicios.codubi,c_servicios.flgmt);*/
         insert into solotpto(codsolot, punto,codsrvnue,bwnue,codinssrv,cid,descripcion,direccion,tipo,estado,visible,codubi,flgmt/*,pid*/)
        values(v_codsolot,l_cont,c_servicios.codsrvnue,c_servicios.bwnue,c_servicios.codinssrv,c_servicios.cid,c_servicios.descripcion,c_servicios.direccion,c_servicios.tipo,c_servicios.estado,c_servicios.visible,c_servicios.codubi,c_servicios.flgmt/*,c_servicios.pid */);
  /*     insert into solotpto_id
              (codsolot,punto)
             values
              (v_codsolot, l_cont);
*/
        insert into dettransacciones_cable(idtrans,nomabr,codinssrv)
        values(v_idtrans,c_servicios.numero,c_servicios.codinssrv);
        l_cont := l_cont + 1;

        end;
      end loop;
  END;


/**********************************************************************
Insertar el detalle de un paquete
**********************************************************************/

  PROCEDURE p_insert_solotpto_cable_dig(v_idtrans transacciones.idtrans%type,
                                        v_codsolot solot.codsolot%type,
                                        v_codcli solot.codcli%type,
                                        v_idfac cxctabfac.idfac%type/*,
                                        v_idpaq number*/) IS
  cursor cur_servicios is
  select distinct so.codsrv codsrvnue,so.numero,so.bw bwnue,so.codinssrv,so.cid,so.descripcion,so.direccion,2 tipo,1 estado,1 visible, so.codubi, 1 flgmt--, i.pid
  from /*vtadetptoenl vs, */inssrv so--, insprd i
  where so.codinssrv in (
        select codinssrv from inssrv where codinssrv in (
        select codinssrv from insprd where pid in (
        select pid from instxproducto where idinstprod in (
        select idinstprod from cr where idbilfac in (
        select idbilfac from bilfac where idfaccxc = v_idfac)))) -- nuevos
  )
  and so.estinssrv not in (4,3)
  and so.codsrv not in ('5058')
--  and so.codinssrv = i.codinssrv(+) and i.flgprinc = 1
;


  l_cont number;
  l_contmax number;

  BEGIN
  l_cont := 1;
  l_contmax := 0;
  select max(punto)
  into l_contmax
  from solotpto
  where codsolot = v_codsolot;

  if l_contmax > 1
  then l_cont := l_contmax +1;
  end if;

     for c_servicios in cur_servicios loop
        begin
/*         insert into solotpto(codsolot, punto,codsrvnue,bwnue,codinssrv,cid,descripcion,direccion,tipo,estado,visible,codubi,flgmt)
        values(v_codsolot,l_cont,c_servicios.codsrvnue,c_servicios.bwnue,c_servicios.codinssrv,c_servicios.cid,c_servicios.descripcion,c_servicios.direccion,c_servicios.tipo,c_servicios.estado,c_servicios.visible,c_servicios.codubi,c_servicios.flgmt);*/
         insert into solotpto(codsolot, punto,codsrvnue,bwnue,codinssrv,cid,descripcion,direccion,tipo,estado,visible,codubi,flgmt/*,pid*/)
        values(v_codsolot,l_cont,c_servicios.codsrvnue,c_servicios.bwnue,c_servicios.codinssrv,c_servicios.cid,c_servicios.descripcion,c_servicios.direccion,c_servicios.tipo,c_servicios.estado,c_servicios.visible,c_servicios.codubi,c_servicios.flgmt/*,c_servicios.pid */);
  /*     insert into solotpto_id
              (codsolot,punto)
             values
              (v_codsolot, l_cont);
*/
        insert into dettransacciones_cable(idtrans,nomabr,codinssrv)
        values(v_idtrans,c_servicios.numero,c_servicios.codinssrv);
        l_cont := l_cont + 1;

        end;
      end loop;
  END;



/**********************************************************************
Insertar el detalle de la SOT para un servicio DTH
**********************************************************************/
/*
  PROCEDURE p_insert_solotpto_cable_DTH(v_idtrans transacciones.idtrans%type,
                                        v_codsolot solot.codsolot%type,
                                        v_codcli solot.codcli%type,
                                        v_idfac cxctabfac.idfac%type) IS
  cursor cur_servicios is
  select distinct so.codsrv codsrvnue,so.numero,so.bw bwnue,so.codinssrv,so.cid,so.descripcion,so.direccion,2 tipo,1 estado,1 visible, so.codubi, 1 flgmt
  from inssrv so
  where so.codinssrv in (
        select codinssrv from inssrv where codinssrv in (
        select codinssrv from insprd where pid in (
        select pid from instxproducto where idinstprod in (
        select idinstprod from cr where idbilfac in (
        select idbilfac from bilfac where idfaccxc = v_idfac))))
  )
;


  l_cont number;
  l_contmax number;

  BEGIN
  l_cont := 1;
  l_contmax := 0;
  select max(punto)
  into l_contmax
  from solotpto
  where codsolot = v_codsolot;

  if l_contmax > 1
  then l_cont := l_contmax +1;
  end if;

     for c_servicios in cur_servicios loop
        begin
         insert into solotpto(codsolot, punto,codsrvnue,bwnue,codinssrv,cid,descripcion,direccion,tipo,estado,visible,codubi,flgmt)
         values(v_codsolot,l_cont,c_servicios.codsrvnue,c_servicios.bwnue,c_servicios.codinssrv,c_servicios.cid,c_servicios.descripcion,c_servicios.direccion,c_servicios.tipo,c_servicios.estado,c_servicios.visible,c_servicios.codubi,c_servicios.flgmt );

        insert into dettransacciones_cable(idtrans,nomabr,codinssrv)
        values(v_idtrans,c_servicios.numero,c_servicios.codinssrv);
        l_cont := l_cont + 1;

        end;
      end loop;
  END;

*/
/**********************************************************************
Envia los emails de notificación de la incidencia a clientes y consultores
**********************************************************************/

  PROCEDURE p_enviar_notificaciones(v_idtrans transacciones.idtrans%type,
                                    v_archivo varchar2          )
  IS
  ls_titulo varchar2(100);
  ls_texto varchar2(4000);
  l_documento varchar2(20);
  l_numero cxctabfac.nomabr%type;
  l_codcli vtatabcli.codcli%type;
  l_nomcli vtatabcli.nomcli%type;
  l_codsolot solot.codsolot%type;
  l_cont number;


  cursor cur_det is
  select ltrim(t.nomabr) nomabr,ltrim(ts.DSCSRV) servicio,i.direccion||' - '|| NOMDST||'/'||NOMPVC||'/'||NOMEST direccion, i.descripcion sucursal
         from OPERACION.DETTRANSACCIONES_CABLE t,
           inssrv i,
           V_UBICACIONES d,
           tystabsrv ts
      where t.idtrans = v_idtrans and
            t.codinssrv = i.codinssrv and
            i.codubi = d.codubi(+) and
            i.codsrv = ts.codsrv (+)
            order by nomabr;

/*  cRutaArchivo constant varchar2(100) := '/u03/oracle/PESGAPRD/UTL_FILE';
  ls_enter constant varchar2(4) := chr(10) || chr(13);*/
  hArch UTL_FILE.FILE_TYPE;
  vNomArch varchar2(100);

  BEGIN

  vNomArch := v_archivo;
  hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'a');

  select c.sersut||'-'||c.numsut documento,t.nomabr,t.codcli,v.nomcli,codsolot
  into l_documento,l_numero,l_codcli,l_nomcli,l_codsolot
  from TRANSACCIONES_CABLE t, cxctabfac c, vtatabcli v
  where t.idtrans =v_idtrans and
        t.idfac = c.idfac and
        t.codcli = v.codcli;

  ls_texto := '<table border="1" width="100%" id="table1">'|| chr(13) || chr(10);
  UTL_FILE.PUT_LINE(hArch,ls_texto);

  ls_texto := '<tr>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="3" bgcolor="#CCCC00" width="20%">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Cliente</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="2">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    '|| l_nomcli||'</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'  </tr>'|| chr(13) || chr(10);
  UTL_FILE.PUT_LINE(hArch,ls_texto);

  ls_texto := '  <tr>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="3" bgcolor="#3366FF" width="20%">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Codigo</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="2">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    '|| l_codcli||'</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'  </tr>'|| chr(13) || chr(10);
  UTL_FILE.PUT_LINE(hArch,ls_texto);

  ls_texto := '  <tr>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="3" bgcolor="#CCCC00" width="20%">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Documento</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="2">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    '|| l_documento||'</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||' </tr>'|| chr(13) || chr(10);
  UTL_FILE.PUT_LINE(hArch,ls_texto);

  ls_texto := '  <tr>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="3" bgcolor="#3366FF" width="20%">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Cabecera</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="2">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    '|| l_numero||'</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||' </tr>'|| chr(13) || chr(10);
  UTL_FILE.PUT_LINE(hArch,ls_texto);

  ls_texto := '  <tr>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="3" bgcolor="#CCCC00" width="20%">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Solicitud OT</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="2">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    '|| l_codsolot||'</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||' </tr>'|| chr(13) || chr(10);
  UTL_FILE.PUT_LINE(hArch,ls_texto);

  ls_texto := '  <tr>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td align="center" width="12%" bgcolor="#3366FF">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Numero</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td align="center" width="16%" bgcolor="#3366FF">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Servicio</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="2" align="center" bgcolor="#3366FF">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Sucursal</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td align="center" width="41%" bgcolor="#3366FF">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Direccion</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'  </tr>'|| chr(13) || chr(10);
  UTL_FILE.PUT_LINE(hArch,ls_texto);

       for c_det in cur_det loop
        begin
          ls_texto := '  <tr>'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <td width="12%">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    '|| c_det.nomabr||'</span></td>'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <td width="16%">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    '|| c_det.servicio||'</span></td>'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <td colspan="2">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    '|| c_det.sucursal||'</span></td>'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <td width="41%">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    '|| c_det.direccion||'</span></td>'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'  </tr>'|| chr(13) || chr(10);
          UTL_FILE.PUT_LINE(hArch,ls_texto);

        end;
      end loop;

   ls_texto := '</table>';
   ls_texto := '<hr>';
   UTL_FILE.PUT_LINE(hArch,ls_texto);

UTL_FILE.FCLOSE(hArch);

END;

/**********************************************************************
Envia los emails de notificación de la incidencia a clientes y consultores x CLC
**********************************************************************/

  PROCEDURE p_enviar_notificacionesxnumero(v_idtrans transacciones.idtrans%type,
                                    v_archivo varchar2          )
  IS
  ls_titulo varchar2(100);
  ls_texto varchar2(4000);
  --l_documento varchar2(20);
  l_numero transacciones.nomabr%type;
  l_codcli vtatabcli.codcli%type;
  l_nomcli vtatabcli.nomcli%type;
  l_codsolot solot.codsolot%type;
  l_cont number;


  cursor cur_det is
  select ltrim(t.nomabr) nomabr,ltrim(ts.DSCSRV) servicio,i.direccion||' - '|| NOMDST||'/'||NOMPVC||'/'||NOMEST direccion, i.descripcion sucursal
         from dettransacciones_cable t,
           inssrv i,
           V_UBICACIONES d,
           tystabsrv ts
      where t.idtrans = v_idtrans and
            t.codinssrv = i.codinssrv and
            i.codubi = d.codubi(+) and
            i.codsrv = ts.codsrv (+)
            order by nomabr;

/*  cRutaArchivo constant varchar2(100) := '/u03/oracle/PESGAPRD/UTL_FILE';
  ls_enter constant varchar2(4) := chr(10) || chr(13);*/
  hArch UTL_FILE.FILE_TYPE;
  vNomArch varchar2(100);

  BEGIN

  vNomArch := v_archivo;
  hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'a');

  select t.nomabr,t.codcli,v.nomcli,codsolot
  into l_numero,l_codcli,l_nomcli,l_codsolot
  from transacciones_cable t,  vtatabcli v
  where t.idtrans =v_idtrans and
        t.codcli = v.codcli;

  ls_texto := '<table border="1" width="100%" id="table1">'|| chr(13) || chr(10);
  UTL_FILE.PUT_LINE(hArch,ls_texto);

  ls_texto := '<tr>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="3" bgcolor="#CCCC00" width="20%">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Cliente</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="2">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    '|| l_nomcli||'</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'  </tr>'|| chr(13) || chr(10);
  UTL_FILE.PUT_LINE(hArch,ls_texto);

  ls_texto := '  <tr>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="3" bgcolor="#3366FF" width="20%">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Codigo</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="2">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    '|| l_codcli||'</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'  </tr>'|| chr(13) || chr(10);
  UTL_FILE.PUT_LINE(hArch,ls_texto);

/*  ls_texto := '  <tr>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="3" bgcolor="#CCCC00" width="20%">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Documento</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="2">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    '|| l_documento||'</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||' </tr>'|| chr(13) || chr(10);
  UTL_FILE.PUT_LINE(hArch,ls_texto);*/

  ls_texto := '  <tr>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="3" bgcolor="#3366FF" width="20%">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Cabecera</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="2">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    '|| l_numero||'</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||' </tr>'|| chr(13) || chr(10);
  UTL_FILE.PUT_LINE(hArch,ls_texto);

  ls_texto := '  <tr>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="3" bgcolor="#CCCC00" width="20%">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Solicitud OT</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="2">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    '|| l_codsolot||'</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||' </tr>'|| chr(13) || chr(10);
  UTL_FILE.PUT_LINE(hArch,ls_texto);

  ls_texto := '  <tr>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td align="center" width="12%" bgcolor="#3366FF">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Numero</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td align="center" width="16%" bgcolor="#3366FF">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Servicio</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="2" align="center" bgcolor="#3366FF">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Sucursal</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td align="center" width="41%" bgcolor="#3366FF">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Direccion</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'  </tr>'|| chr(13) || chr(10);
  UTL_FILE.PUT_LINE(hArch,ls_texto);

       for c_det in cur_det loop
        begin
          ls_texto := '  <tr>'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <td width="12%">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    '|| c_det.nomabr||'</span></td>'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <td width="16%">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    '|| c_det.servicio||'</span></td>'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <td colspan="2">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    '|| c_det.sucursal||'</span></td>'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <td width="41%">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    '|| c_det.direccion||'</span></td>'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'  </tr>'|| chr(13) || chr(10);
          UTL_FILE.PUT_LINE(hArch,ls_texto);

        end;
      end loop;

   ls_texto := '</table>';
   ls_texto := '<hr>';
   UTL_FILE.PUT_LINE(hArch,ls_texto);

UTL_FILE.FCLOSE(hArch);

END;



FUNCTION f_verifica_documentos(v_idfac1 in OPERACION.TRANSACCIONES_CABLE.idfac%type, v_idfac2 OPERACION.TRANSACCIONES_CABLE.idfac%type) return number
  IS

  v_nomabr1 collections.cxctabfac.nomabr%type;
  v_nomabr2 collections.cxctabfac.nomabr%type;
  v_numslc1 operacion.inssrv.numslc%type;
  v_numslc2 operacion.inssrv.numslc%type;
  n_result number;

  cursor cur_proyecto(v_idfac in OPERACION.TRANSACCIONES_CABLE.idfac%type) is
              select distinct numslc from inssrv where codinssrv in (
                     select codinssrv from insprd where pid in (
                            select pid from instxproducto where idinstprod in (
                                   select idinstprod from cr where idbilfac in (
                                          select idbilfac from bilfac where idfaccxc = v_idfac))));

  BEGIN
          n_result := 1;

           select nomabr into v_nomabr1
           from cxctabfac
           where idfac = v_idfac1;

           select nomabr into v_nomabr2
           from cxctabfac
           where idfac = v_idfac2;

           if( v_nomabr1 is not null and v_nomabr2 is not null  and v_nomabr1 = v_nomabr2) then
               n_result := 0;
           else
                FOR C1 IN cur_proyecto(v_idfac1) LOOP
                    v_numslc1 := c1.numslc ;
                end loop;
                FOR C2 IN cur_proyecto(v_idfac2) LOOP
                    v_numslc2 := c2.numslc ;
                end loop;
                if v_numslc1 = v_numslc2 then
                   n_result := 0;
                end if;
           end if;

     RETURN n_result;

END;


/**********************************************************************
Funcion que carga los documentos vencidos según los criterios establecidos
**********************************************************************/

PROCEDURE p_cargapretransaccion
  IS

v_tipcam ctbtipcam.ventca%type;
cursor c_vencidos is
--<11.0
/*select c.nomabr, c.codcli, sum(decode(f.moneda_id, 1, f.sldact/v_tipcam, f.sldact)  ) -- TODO A DÓLARES
from CXCTABFACVENCIDOS c, CXCTABFAC f
where (c.nomabr, c.codcli) in (
    select distinct c1.nomabr, c1.codcli
      from CXCTABFACVENCIDOS c1
      minus
      select distinct nomabr, codcli
      from transacciones_cable t
      where transaccion = 'SUSPENSION' and fecfin is null )
AND c.idfac = f.idfac
group by c.nomabr, c.codcli
HAVING sum(decode(f.moneda_id, 1, f.sldact/v_tipcam, f.sldact)  ) > 40
;*/
select c.tipo,c.nomabr, c.codcli, sum(decode(f.moneda_id, 1, f.sldact/v_tipcam, f.sldact)  ) -- TODO A DÓLARES
from CXCTABFACVENCIDOS c, CXCTABFAC f
where (c.nomabr, c.codcli) in (
    select distinct c1.nomabr, c1.codcli
      from CXCTABFACVENCIDOS c1
      minus
      select distinct nomabr, codcli
      from transacciones_cable t
      where transaccion = 'SUSPENSION' and fecfin is null )
AND c.idfac = f.idfac
AND c.tipo=10  -- Cable
group by c.nomabr, c.codcli,c.tipo
--HAVING sum(decode(f.moneda_id, 1, f.sldact/v_tipcam, f.sldact)  ) > 40
HAVING sum(decode(f.moneda_id, 1, f.sldact/v_tipcam, f.sldact)  ) > 0.3--<20.0>
union
select  c.tipo,c.nomabr, c.codcli, sum(decode(f.moneda_id, 1, f.sldact, f.sldact*v_tipcam)  )  -- TODO A SOLES
from CXCTABFACVENCIDOS c, CXCTABFAC f
where (c.nomabr, c.codcli) in (
    select distinct c1.nomabr, c1.codcli
      from CXCTABFACVENCIDOS c1
      minus
      select distinct nomabr, codcli
      from transacciones_cable t
      where transaccion = 'SUSPENSION' and fecfin is null )
AND c.idfac = f.idfac
AND c.tipo=15   -- Triple Play
group by c.nomabr, c.codcli,c.tipo
--HAVING sum(decode(f.moneda_id, 1, f.sldact, f.sldact*v_tipcam)  ) > 15;
HAVING sum(decode(f.moneda_id, 1, f.sldact, f.sldact*v_tipcam)  ) > 1; --<20.0>
--11.0>
v_idfac CXCTABFACVENCIDOS.idfac%type;

r_vencido CXCTABFACVENCIDOS%rowtype;

  BEGIN

  dbms_utility.exec_ddl_statement('truncate table OPERACION.CXCTABFACVENCIDOS');
  dbms_utility.exec_ddl_statement('truncate table OPERACION.pretransacciones_CABLE');

  select ventca into v_tipcam from ctbtipcam where fectca = trunc(sysdate)  ; -- tipo de cambio del dolar del día

  /*"CARGA DE DOCUMENTOS VENCIDOS*/
        insert into CXCTABFACVENCIDOS
--Inicio cambio 02/02/2008  Gustavo Ormeño
--Inicio cambio 10/03/2008  Gustavo Ormeño

--------------------------------------------------------------------------------------------------
--*********************************** QUERY MODIFICADO 01-08-2008 ***************************** --
select distinct c.nomabr,
                c.sldact,
                c.codcli,
                v.nomcli,
                ca.descripcion categoria,
                c.idfac,
                c.sersut || '-' || c.numsut numdoc,
                c.fecemi,
                c.fecven,
                ca.idcategoria,
                decode(b.cicfac,14,10,15,10,24,10,25,10,15),-- tipo de servicio: cable 10, triple play 15
                MIN(trunc(MONTHS_BETWEEN(sysdate, i.fecini)))
  from cxctabfac c, bilfac b, inssrv i, vtatabcli v, categoria ca,
       insprd ip, instxproducto ins, cr
       --<16.0>
       --  instanciaservicio inserv --<14.0>
  where c.tipdoc IN ('REC', 'LET')
   and c.estfacrec = 0
   and c.estfac in ('02', '04')
   and b.idfaccxc = c.idfac
   and b.cicfac in (14, 15, 24, 25, 21, 26) -- cable y triple play
   and i.codinssrv = ip.codinssrv
   and ip.flgprinc = 1
   and ip.pid = ins.pid
   and ins.idinstprod = cr.idinstprod
   and cr.idbilfac = b.idbilfac
   --<14.0 and i.estinssrv = 1
   and (i.estinssrv = 1 or
       (i.estinssrv = 2 and
       'CLC' IN (select instanciaservicio.esttlfcli
                     from instanciaservicio
                    where instanciaservicio.codinssrv = i.codinssrv
                      and instanciaservicio.codcli = c.codcli)))--14.0>
   and i.codcli = c.codcli
   and c.codcli = v.codcli
   and ca.idcategoria(+) = v.idcategoria
   and c.fecemi > to_date('01/01/2007', 'dd/mm/yyyy')
   GROUP BY c.nomabr,
          c.sldact,
          c.codcli,
          v.nomcli,
          ca.descripcion,
          c.idfac,
          c.sersut || '-' || c.numsut,
          c.fecemi,
          c.fecven,
          ca.idcategoria,
          decode(b.cicfac,14,10,15,10,24,10,25,10,15);

--********************************** FIN DEL QUERY  *************************************** --
----------------------------------------------------------------------------------------------
       commit;


--Fin cambio 02/02/2008  Gustavo Ormeño
--Fin cambio 10/03/2008  Gustavo Ormeño

-------------------------------------------------------------------------------------------------------
--************************************ NUEVO QUERY 01-08-2008 *****************************************
     /*CARGA DE PRETRANSACCIONES*/

for c in c_vencidos loop
            -- cambio 10/03/2008  Gustavo Ormeño max por min
  select min(idfac) into v_idfac from CXCTABFACVENCIDOS where codcli = c.codcli and nomabr = c.nomabr ;

  if (v_idfac is not null) then
    select * into r_vencido from cxctabfacvencidos where to_number(idfac) = to_number(v_idfac);

    if f_verificaVoz(c.nomabr) = 0 then -- se verifica si contiene un servicio de voz
      if( r_vencido.diasServ <= 6 ) then -- si el servicio tiene menos de 6 meses
        --if ( collections.f_get_emitidos_boga(r_vencido.codcli,r_vencido.nomabr,r_vencido.idfac) >= 3 ) then -- si tiene más de tres adeudados
        if ( collections.f_get_emitidos_boga(r_vencido.codcli,r_vencido.nomabr,r_vencido.idfac) >= 2 ) then -- <20.0> si tiene más de dos adeudados
          insert into pretransacciones_cable
          select t.nomabr, t.sldact, t.codcli, t.nomcli, t.categoria, t.idfac, t.numdoc, t.fecemi, t.fecven, t.idcategoria, t.tipo
           from CXCTABFACVENCIDOS t where idfac = r_vencido.idfac;
         end if;
       else -- si el servicio tiene más de 6 meses
         --if (trunc(sysdate) >= trunc(r_vencido.fecven+61) ) then -- si tiene más de 61 días de vencido el documento más antiguo.
         if (trunc(sysdate) >= trunc(r_vencido.fecven+51) ) then --<20.0> si tiene más de 51 días de vencido el documento más antiguo.
           insert into pretransacciones_cable
           select t.nomabr, t.sldact, t.codcli, t.nomcli, t.categoria, t.idfac, t.numdoc, t.fecemi, t.fecven, t.idcategoria, t.tipo
           from CXCTABFACVENCIDOS t where idfac = r_vencido.idfac;
        end if;
      end if;
    else -- si tiene un servicio de voz
      if trunc(sysdate) > OPERACION.F_GET_FECHA_UTIL(r_vencido.fecven,15) then
        insert into pretransacciones_cable
        select t.nomabr, t.sldact, t.codcli, t.nomcli, t.categoria, t.idfac, t.numdoc,   t.fecemi, t.fecven, t.idcategoria, t.tipo
        from CXCTABFACVENCIDOS t where idfac = r_vencido.idfac;
      end if;
    end if;
  end if;
end loop;




--  carga de pretransacciones para documento vencidos de DTH
/*        insert into pretransacciones_cable
        select distinct c.nomabr, c.sldact, c.codcli,v.nomcli,  ca.descripcion categoria,c.idfac,c.sersut||'-'||c.numsut numdoc,
                       c.fecemi, c.fecven, ca.idcategoria, 12
          from cxctabfac c ,bilfac b, inssrv i, vtatabcli v, categoria ca, insprd ip, instxproducto ins, cr
          where c.tipdoc IN ('REC') and
                      c.estfacrec =0 and
--                      c.estfac not in ('01','06','11','05') and
                     c.estfac in ('02','04') and
--                      c.sldact > decode(c.moneda_id, 1, v_tipcam * 40, 40)  and --166129
                      trunc(sysdate) >= OPERACION.F_GET_FECHA_UTIL(c.fecven,2) and
                      b.idfaccxc = c.idfac and --29971
                      b.cicfac in (22,23) and -- ciclos de facturación DTH
                     i.codinssrv = ip.codinssrv and
                     ip.flgprinc = 1 and
                     ip.pid = ins.pid and
                     ins.idinstprod = cr.idinstprod and
                     cr.idbilfac = b.idbilfac and
--                      i.estinssrv = 1 and
                      ip.estinsprd = 1 and
                      i.codcli = c.codcli and
                      c.codcli = v.codcli and
                      ca.idcategoria(+) = v.idcategoria
    ;
*/
  END;


----------------------------------------------------------------------------------------------------------
--************************************ PROCEDIMIENTO AGREGADO 01-08-2008 *********************************

/*********************************************************************
Genera las sots para cortes de triple play con servicio de voz
*********************************************************************/

  PROCEDURE p_genera_corte_CABLE
  IS
  l_codsolot solot.codsolot%type;
  l_flgenviar number;
  cursor cur_tra is
  select *
  from transacciones_cable
  where transaccion = 'CORTE'
  and fecini is null
  --ini 24.0
  and 1 = 2 --Para que no devuelva ningun dato
  --fin 24.0
  and tipo in (15); -- Se incluye el tipo 3 para TPI

/*  cRutaArchivo constant varchar2(100) := '/u03/oracle/PESGAPRD/UTL_FILE';
  ls_enter constant varchar2(4) := chr(10) || chr(13);*/
  hArch UTL_FILE.FILE_TYPE;
  vNomArch varchar2(100);
    l_nomcli vtatabcli.nomcli%type;

  BEGIN

  vNomArch := 'CORTTELFIJA.htm';
  hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'w');
  l_flgenviar := 0;

  UTL_FILE.PUT_LINE(hArch,'<html>');
  UTL_FILE.PUT_LINE(hArch,'<head>');
  UTL_FILE.PUT_LINE(hArch,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
  UTL_FILE.PUT_LINE(hArch,'<title>Corte por falta de pago - Triple Play</title>');
  UTL_FILE.PUT_LINE(hArch,'</head>');
  UTL_FILE.PUT_LINE(hArch,'<body>');
  UTL_FILE.PUT_LINE(hArch,'<p><font color="#3366FF">CORTES POR FALTA DE PAGO: - '||to_char(sysdate,'dd/mm/yyyy hh24:mi') ||  '</font> </p>');

  UTL_FILE.FCLOSE(hArch);

   for c_tra in cur_tra loop
     begin
          --<10.0
          --if (f_verdocpendiente(c_tra.idfac) = 0 ) then --verifico no haya cancelado todos sus documentos.
          if (collections.f_get_cxtabfac_adeudados(c_tra.codcli,c_tra.nomabr) = 0 ) then
          --10.0>
        begin
         update transacciones_cable set fecini = sysdate, fecfin = sysdate where idtrans = c_tra.idtrans ;
         -- inserta la reconexión a la que se le asignará una SOT con el procedimiento que corre con el JOB (a partir de la suspensión obtenida)
          INSERT INTO OPERACION.TRANSACCIONES_CABLE (IDFAC, NOMABR, CODCLI, TRANSACCION, CODUSU, IDTRANSORI, TIPO)
          VALUES (c_tra.idfac,c_tra.nomabr,c_tra.codcli, 'ACTIVACION', user,c_tra.idtransori,c_tra.tipo);
        end;
        else
            if f_cuenta_puntos_cable(c_tra.idfac) > 0 then
              p_insert_sot(c_tra.codcli,442,'0061',1,13,l_codsolot);
              p_insert_solotpto_cable(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac/*,c_inspaq.idinsxpaq*/);
              update transacciones_cable set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
              p_enviar_notificaciones(c_tra.idtrans,'CORTTELFIJA.htm');
              l_flgenviar := 1;
              OPERACION.PQ_SOLOT.p_ejecutar_solot(l_codsolot);
            --else
              --p_envia_correo_c_attach('Corte por Falta de Pago - Servicio de Cable - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno@claro.com.pe','SOT sin puntos activos, no generada - Cable. (IDFAC,NOMABR,CODCLI) = ('|| c_tra.idfac ||','||c_tra.nomabr||','||c_tra.codcli ||') ' ||to_char(sysdate,'dd/mm/yyyy hh24:mi'),null,'SGA');
            end if;
        end if;
     end;
   end loop;

     if l_flgenviar > 0 then
       hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'a');
       UTL_FILE.PUT_LINE(hArch,'</body>');
       UTL_FILE.PUT_LINE(hArch,'</html>');
       UTL_FILE.FCLOSE(hArch);
--       p_envia_correo_c_attach('Cortes - Triple Play - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno@claro.com.pe','Cortes - Triple Play - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
     end if;

END;

----------------------------------------------------------------------------------------------------------

/**********************************************************************
Funcion que verifica si el servicio del cliente aún sigue en deuda
**********************************************************************/

   FUNCTION f_verdocpendiente(v_idfac in OPERACION.TRANSACCIONES_CABLE.idfac%type) return number
  IS
  l_pendiente number;
  l_estfac cxctabfac.estfac%type;
  l_recfac cxctabfac.estfacrec%type;

  BEGIN
  l_pendiente := 1;

  select c.estfac, c.estfacrec
  into l_estfac, l_recfac
  from cxctabfac c
  where c.idfac = v_idfac;

  if l_estfac in ('01','06','11','05') or l_recfac = 1 then  --documento cancelado o anulado
     begin
          l_pendiente := 0;
     end;
  end if;



     RETURN l_pendiente;

  END;

/**********************************************************************
Funcion que calcula la cantidad de días que tiene el servicio del cliente
**********************************************************************/

FUNCTION f_dias_servicio(v_idfac in cxctabfac.idfac%type) return number
  IS

  l_num_dias number;

  BEGIN
  l_num_dias := 0;

    select min(trunc(MONTHS_BETWEEN(sysdate, so.fecini)))
      into l_num_dias
      from /*vtadetptoenl vs, */ inssrv so, insprd i
     where so.codinssrv in
           (select codinssrv
              from inssrv
             where codinssrv in
                   (select codinssrv
                      from insprd
                     where pid in
                           (select pid
                              from instxproducto
                             where idinstprod in
                                   (select idinstprod
                                      from cr
                                     where idbilfac in
                                           (select idbilfac
                                              from bilfac
                                             where idfaccxc = v_idfac)))) -- nuevos
            )
       and so.codinssrv = i.codinssrv(+)
       and i.flgprinc = 1;

  if (l_num_dias < 0) then l_num_dias := 0; end if;

     RETURN l_num_dias;

  END;

--------------------------------------------------------------------------------------------------
--************************************* NUEVA FUNCION 01-08-2008 *********************************
/*********************************************************************
Funcion que verifica si el servicio contiene un producto de voz
*********************************************************************/

  FUNCTION f_verificaVoz(v_nomabr in inssrv.numero%type) return number
  IS
  l_hayVoz number;

  BEGIN

   select count(*) into l_hayVoz
   from inssrv i1, inssrv i2
   where i1.numero = v_nomabr
   and i2.numslc = i1.numslc
   and i2.tipinssrv = 3;

   RETURN l_hayVoz;

  END;

/*********************************************************************
Funcion que verifica si se generarán puntos para la SOT
*********************************************************************/
function f_cuenta_puntos_cable(v_idfac cxctabfac.idfac%type) return number
IS

n_cant_puntos number;

begin
  select count(*) into n_cant_puntos
  from /*vtadetptoenl vs, */inssrv so--, insprd i
  where so.codinssrv in (
        select codinssrv from inssrv where codinssrv in (
        select codinssrv from insprd where pid in (
        select pid from instxproducto where idinstprod in (
        select idinstprod from cr where idbilfac in (
        select idbilfac from bilfac where idfaccxc = v_idfac)))) -- nuevos
  )
  and so.estinssrv not in (4,3)
--  and so.codinssrv = i.codinssrv(+) and i.flgprinc = 1
;

return n_cant_puntos;

end;

/**********************************************************************
Funcion que verifica si un numero es analogico y pertenece a una paquete triple play
**********************************************************************/

FUNCTION f_verificanumero(v_numero in numtel.numero%type) return number
  IS
  l_tipo number;
  l_analogica number;
  l_pri number;
  BEGIN
  l_tipo := 0;
  l_analogica := 0;
  l_pri := 0;

  select count(*)
  into l_analogica
  from numtel n,inssrv i, instanciaservicio sb, instxproducto pb
            where n.numero= v_numero and
            n.codinssrv = i.codinssrv and
            i.codinssrv = sb.codinssrv and
            i.codcli = sb.codcli and
            sb.idinstserv = pb.idcod and
            pb.idproducto in (766, 783) and
            pb.fecfin is null;

/*  SELECT count(*)
  into l_pri
  FROM NUMTEL N , INSSRV I, INSTANCIASERVICIO SB, INSTANCIASERVICIO SB2, INSTXPRODUCTO PB
  WHERE N.NUMERO =v_numero AND
        N.CODINSSRV = I.CODINSSRV AND
        I.CODINSSRV = SB.CODINSSRV AND
        I.CODCLI = SB.CODCLI AND
        SB.ISPADRE = SB2.ISPADRE AND
        SB2.IDINSTSERV = PB.IDCOD AND
        SB2.CODCLI = PB.CODCLI AND
        PB.IDPRODUCTO = 504 AND
        PB.FECFIN IS NULL;


*/
    if (( l_analogica > 0 ) and (l_pri <1))
    then l_tipo := 1 ;--es analogica
    end if;

/*    if (( l_analogica < 1 ) and (l_pri > 0))
    then l_tipo := 2 ;--es pri
    end if;

    if (( l_analogica > 0 ) and (l_pri > 0))
    then l_tipo := 3 ;
    end if;*/

     RETURN l_tipo;

END;

PROCEDURE p_depura__transacciones_cable
  IS


  l_codcli vtatabcli.codcli%type;
  l_nomabr transacciones.nomabr%type;

  min_idtrans transacciones.idtrans%type;

  cursor cur_trans is
    select distinct t.codcli, t.nomabr, t.transaccion, t.tipo
      from transacciones_cable t,
           (select count(*), nomabr, codcli, transaccion, tipo
              from transacciones_cable
             where codsolot is null
               and fecini is null
               and fecfin is null
             group by nomabr, codcli, transaccion, tipo
            having count(*) > 1
             order by 2, 1, 3) tr
     where t.codcli = tr.codcli
       and t.nomabr = tr.nomabr
       and t.transaccion=tr.transaccion
       and t.tipo=tr.tipo
       and t.codsolot is null
       and t.fecini is null
       and t.fecfin is null
    order by 1,2;

  BEGIN

      for all_trans in cur_trans loop
           l_codcli:=all_trans.codcli;
           l_nomabr:=all_trans.nomabr;
          select min(t.idtrans)
            into min_idtrans
            from transacciones_cable t
           where t.codcli = all_trans.codcli
             and t.nomabr = all_trans.nomabr
             and t.transaccion = all_trans.transaccion
             and t.tipo=all_trans.tipo
             and t.codsolot is null
             and t.fecini is null
             and t.fecfin is null
           group by t.codcli, t.nomabr, t.transaccion, t.tipo;

             BEGIN
               update transacciones_cable
                  set fecini = sysdate, fecfin = sysdate
                where codcli = all_trans.codcli
                  and nomabr = all_trans.nomabr
                  and tipo = all_trans.tipo
                  and transaccion = all_trans.transaccion
                  and idtrans <> min_idtrans;
            END;
      end loop;
      commit;

      EXCEPTION
      WHEN OTHERS THEN
      p_envia_correo_c_attach('Cortes y Reconexiones Cable',
                                              'DL-PE-ITSoportealNegocio@claro.com.pe',--23.0
                                              'Ocurrió un error en el proceso de depuración de transacciones cable(operacion.pq_corteservicio_cable.p_depura__transacciones)' ||
                                              ', CODCLI: ' || l_codcli ||
                                              ', NUMERO: ' || l_nomabr,
                                              null,
                                              'SGA');
  END;

/****************************************************************************************
Inserta registros de cancelaciones por nota de crédito, para la reconexión del servicio  13.0
****************************************************************************************/

PROCEDURE p_insert_cancelacion_nc_cable IS

  cursor cur_cancel_nc is
    SELECT DISTINCT IDFAC, CODCLI, NOMABR
      FROM TRANSACCIONES_CABLE
     WHERE IDFAC IN (select IDFACCAN
                       from faccanfac
                      where fecusu > to_date('06/08/2008', 'dd/mm/yyyy') -- INICIO CORTE DE AUTOMATIZACION CORTES Y RECONEXIONES TRIPLE PLAY
                        AND idfaccan in (select idfac
                                           from transacciones_cable
                                          where TIPO = 15
                                            AND transaccion = 'SUSPENSION' -- POR EL MOMENTO SOLO TIPO 15, TRIPLE PLAY
                                            AND FECFIN IS NULL));

BEGIN

  for c_1 in cur_cancel_nc loop
    if (collections.f_get_cxtabfac_adeudados(c_1.codcli, c_1.nomabr) = 0) then

      insert into operacion.reconexionporpago_boga
        (idfac,
         codcli,
         nomabr,
         fecreg,
         usureg,
         flgleido,
         flgreconectado,
         obs,
         flgcable)
      values
        (c_1.idfac, c_1.codcli, c_1.nomabr, sysdate, user, 0, 0, '', 1);

    end if;
  end loop;
   commit;
END;

END PQ_CORTESERVICIO_CABLE;
/


