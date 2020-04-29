CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_CORTESERVICIO AS
/******************************************************************************
   NAME:       PQ_CORTESERVICIO
   PURPOSE:

   REVISIONS:
   Ver        Date        Author          Solicitado por  Description
   ---------  ----------  --------------- --------------  ------------------------------------
   1.0        08/01/2006  Luis Olarte                      1. Created this package.
   1.1        20/04/2007  Gustavo Ormeño                   1. Para que genere CLC también días Viernes
   1.2        20/04/2007  Gustavo Ormeño                   1. Para que se consideren líneas que correponden a inssrv en estado suspendido
   1.3        20/04/2007  Gustavo Ormeño                   1. Se añade procedimiento para generar transascionoes para reconexiones automàticas.
   1.4        01/05/2007  Gustavo Ormeño                   1. Creación de procedimientos: lee de la tabla reconexionporpago
                                                           los cxctabfac cancelados para generar la reconexión automática
                                                           2. Cración de procedimiento: p_genera_rec_por_fac_cancelada para
                                                           generación de reconexiones por cancelación de pago. Invocada por un JOB.
                                                           3. Modificación en los procedimientos: p_generaRECCLC, p_generareconexion y p_generareconexion_explora
                                                           para que se verifique una SOT de suspensión o corte previa y sin ejecutar. Antes de generar la SOT de
                                                           reconexión.
                                                           4. Cambio en el query de p_genera_transaccionCLC para que solo considere inssrv en estado activo.
   1.5        12/06/2007  Gustavo Ormeño                   1. Creación de los procedimientos: p_genera_transaccion_RECONEX y p_genera_transaccion_RECXPLORA
                                                           para las reconexiones automáticas.
                                                           2. Modificación del procedimiento p_genera_rec_por_fac_cancelada para invocar las funciones de
                                                           corte automático para telefonía fija y xplora.
   1.6        19/07/2007  Gustavo Ormeño/ G Salcedo
                                                           1. Modificación en la función f_verifica_recibo, para que los O800, 0801 ( isr.idproductoprincipal IN (688,689,721,4,725,8)) sean consideradas como analógicas.
                                                           2. Modificación en el cursor cur_analogicas del procedimiento p_insert_solotpto_analogica
                                                           para que obtenga los puntos de las líneas 0800, 0801. ( isr.idproductoprincipal IN (688,689,721,4,725,8))
                                                           3. Se modifica procedimiento f_verificanumero, corrección en la consulta
                                                           que verifica si es analógica (  PB.FECFIN IS NULL;)
                                                           4. Correcion en el cursor que obtiene los numeros de una pri en el procedimiento p_genera_transaccionCLC
                                                           para (  PB.FECFIN IS NULL;)
  1.7         25/07/2007 Gustavo Ormeño                    1. Corrección en las condicionales de los procedimientos: p_genra_suspension y p_genera_suspension_xplora
                                                           para que pongan el valor sysdate también al campo fecfin en la transaccion de suspensión, para que adenás de
                                                           NO generarse SOT la suspensión quede anulada al tener fechafin <> null.
1.8           02/08/2007 Gustavo Ormeño
                                                           1. Cambio en el query que obtiene los numeros para los puntos de las pri, para que considere los puntos con prefijo CID
1.9           11/09/2007 Gustavo Ormeño
                                                           1. Creación del procedimiento  PROCEDURE p_genera_corte_xplora;, para generar las SOTs de corte de Xplora
1.10          03/10/2007 Gustavo Ormeño.
                                                           1. Modificación del query que extrae los explora para suspensión por falta de pago. Para que se considere explora cuyas líneas telefónicas se encuentra en CLC
1.10          19/10/2007 Gustavo Ormeño.
                                                           1. Modificación del query que extrae los servicios de telefonía fija para suspensión por falta de pago. Para que se considere servicios cuyas líneas telefónicas se encuentra en CLC
1.11         21/01/2008 Gustavo Ormeño.
                                                           1. Modificación para que no genere transacciones CLC repetidas
                                                           2. Para que sólo se genere anulación de SOT pendiente en reconexión de suspensiones.
                                                           3. Se habilita envío de mails.
1.12       06/02/2008 Gustavo Ormeño.
                                                           1. Suspensiones, cortes y reconexiones TPI.
1.13       27/03/2008  Gustavo Ormeño.
                                                           1. Se incluye lógica de control para que no genere suspensiones CLC repetidos.
                                                           2. Generacion de cortes automáticos TPI.
                                                           3. Modificación de días por problemas en NLS_LANG. Se considera Domingo = 1
1.14       30/06/2008                                      1. Se incluye condición para que no genere SOT de telefonía fija si no se ubican puntos activos.

1.15       27/08/2008                                      1. Se incluye fecha de compromiso req. 68693
                                                           2. Condición al obtere el idpaq para que no se consideren servicios cancelados o sin activar
                                                           3. Condición en p_insert_solot_paquete para que no se consideren servicios cancelados o sin activar
1.16       28/10/2007 Gustavo Ormeño/ José Ramos           1. Se agrega if para que verifique suspensiones previas no generadas, y anule las transacciones de suspension y reconexión en p_genera_reconexion
                                                           2. Se inluye group by pra que solo genere un suspension tpi por numero de servicio nomabr, en p_genera_trans_susp

2.0        11/03/2009  Hector Huaman                       REQ-85754:Se se modifico los procedimientos p_genera_trans_SUSP y p_genera_trans_CORTE para contemplar suspensiones automaticas para telefonia y telmex negocio

3.0        19/03/2009  Hector Huaman                       REQ-87362: Se creo el procedmiento p_depura__transacciones que depura los registros que fueron ingresados duplicados para una misma línea, cliente, transaccion y tipo de servicio.

4.0        20/03/2009  Hector Huaman                       REQ-87416: se inicializaron las variables de fecha en los procedimientos: p_genera_reconexion ,p_genera_reconexion_datos,p_genera_reconexion_xplora

5.0        24/03/2009  Hector Huaman                       REQ-87291:Se se modifico los procedimientos p_genera_trans_SUSP( vericar si tiene una baja previa) y p_genera_trans_CORTE( se corrigio el cursor) para contemplar suspensiones automaticas para telefonia y telmex negocio

6.0        19/05/2009  Hector Huaman                       REQ-93065:Se se modifico el procedimiento p_genera_corte_xplora , se cambio el procedimiento que verifica la deuda

7.0        15/06/2009  Gustavo Ormeño                      REQ-95373:Se creo la funcion f_verifica_baja,Función que verifica si el servicio posee una baja total de servicio, atendida o cerrada, o con un fecha de compromiso menor a la del día

8.0        16/06/2009  Hector Huaman                       REQ-95524:Se modifico el procedimiento  p_genera_rec_por_fac_cancelada, para que considere reconectar el servicio cuando se cancela la deuda

9.0        23/06/2009  Hector Huaman                       REQ-96092:Se modifico el funcion f_verifica_baja, considere fechas de compromisos menor a la fecha actual

10.0       26/06/2009   Hector Huaman                      REQ-85209:Se creo el proceso(p_genera_trans_BAJA) que genera las transacciones para las BAJAS de servivios de Telefonía, Telmex Negocio y Datos, este método es invocado por UN JOB.
                                                           Se creo el proceso(p_genera_baja) que genera las sots para BAJAS de telefonia todos los servicios excepto TPI

11.0       22/07/2009   Jose Ramos                         REQ-98028:Se comenta para la generación de SOTs de Baja de manera masiva

12.0       23/07/2009   Gustavo Ormeño                     REQ-98551:Valida que el cliente no tenga ninguna factura pendiente

13.0       03/08/2009   Hector Huaman                      REQ-99125:Verifica si el servicio tiene baja.

14.0       06/08/2009  Joseph Asencios                     REQ-99173:Asignación de WF Configurable para Shared Server Hosting

15.0       11/08/2009  Hector Huaman                       REQ-99721:se creo el procedimiento p_insert_cancelacion_nc para insertar en la tabla operación.reconexionporpago

16.0       26/08/2009  Hector Huaman                       REQ-100447:se crea procedimiento p_insert_cancelacion_nc  para generar suspensiones por retrasos de pago.

17.0       07/09/2009  Hector Huaman                       REQ-101596:Se modifico el procedimiento  p_genera_trans_BAJA, se corrigio el cursor que consigue los servicios que se van a dar de baja

18.0       03/11/2009  Joseph Asencios                     REQ-107653: Se agregó el uso de la función f_get_fechas_corte al procedimiento p_genera_transaccion, que determina si la fecha actual esta disponible para realizar corte.

19.0       24/11/2009  Hector Huamán                       REQ-107806: Se modificó consulta que obtiene los servicios que se van a dar de baja.

20.0       12/11/2009  Alfonso Perez                       REQ-109286:Se modifica el cursor de la generación de cortes y bajas del procedimiento p_genera_trans_CORTE; para TPI no se debe validar el ingreso de la fecha de entrega de carta

21.0       04/01/2010  Alfonso Perez                       REQ-114405: Se modifica la sentencia de fechas en 3 procedimientos: reconexion, reconexion_datos,reconexion_xplora

22.0       21/01/2010  Alfonso Perez                       REQ-116887: Se modifica el procedimiento p_cargapretransaccion, para que se considere para TPI un plazo de 5 días útiles para la generación de la suspensión.

23.0       01/03/2010  Marcos Echevarria                   REQ-119327: Se modifica f_verifica_baja,  No se consideran SIDs de venta de equipos (para el mismo CID y CODCLI de la instalación).

24.0       20/04/2010  Marcos Echevarria                   REQ-126582: Se crea nueva funcion que verifica los aquileres para no suspenderlos y relizar cortes

25.0       30/04/2010  Marcos Echevarria César Rosciano    REQ-125874: se modifica P_genera_reconexion_datos para que el wf se asigne automaticamente.
26.0       26/06/2010  Edson Caqui       Jose Ramos        REQ-131674: validacion para reconexion por lc
27.0       13/07/2010  Edson Caqui       Jose Ramos        REQ-134374: versionar
28.0       15/07/2010  Edson Caqui       Jose Ramos        REQ-136209: versionar
29.0       12/08/2010  Antonio Lagos     Jose Ramos        REQ-137419: correccion para obtencion de pendiente de baja
30.0       06/10/2010                                      REQ.139588 Cambio de Marca
31.0       03/11/2010  Alexander Yong    José Ramos        REQ-147526: Caso Universidad Nacional del Callao CID 31191 por SID 1188436
32.0       06/12/2010  Alexander Yong    Rolando Martinez  REQ-150660: envio de correo en cortes y reconexiones
33.0       04/01/2010  Alex Alamo        Jose Ramos        REQ-151682: correccion de generacion de baja - claro_xplore
34.0       28/03/2011  Miguel Aroñe                        REQ-101786: Cortes y Reconexiones - Bloqueo del proceso para Telefonia Fija, TPI y Telmex Negocio.
                                                           Los mismos se han migrado al nuevo proceso de cortes
35.0       07/07/2011  Raul Mendoza                        REQ-159618 Modificar logica de generacion de SOTs para evitar cortes por cobros de decimos de Soles
36.0       20/01/2012  Edilberto Astulle Luis Rojas        SD38985 Problemas en suspensión de Servicios de Datos
37.0       27/01/2012  Alberto Miranda   Luis Rojas        WEB Cortes Reconexiones de Servicios Datos
38.0       16/04/2012  Edilberto Astulle                   PROY-2787 - SD-45946
39.0       07/05/2012  Miguel Londoña                      Ampliación de caracteres del número de serie
40.0       01/07/2012  Edilberto Astulle                   PQT-63694-TSK-3653
******************************************************************************/


/**********************************************************************
Genara las sots para suspnciones, corte, reconexiones de telefoni FIJA
**********************************************************************/

  PROCEDURE p_genera_transaccion
  IS

  ------------------------------------
  --VARIABLES PARA EL ENVIO DE CORREOS
  /*c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.PQ_CORTESERVICIO.P_GENERA_TRANSACCION';
  c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='241';
  c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );*/
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
      --verifica q no se ejecute en fin de semana
      --<REQ ID=107653 OBS=COMENTADO POR USO DE FUNCIÓN f_get_fechas_corte>
      /*select to_char(sysdate,'d')
      into l_dia
      from dual;
      --verifica q no se ejecute feriado
      select count(*)
      into l_tmp
      from tlftabfer
      where trunc(FECINI) = trunc(sysdate);*/
      --<REQ>

       p_depura__transacciones;    --REQ 87362:Para depurar los registros ingresados duplicados a transacciones
       p_genera_transaccionCLC();  --genera las transacciones de CLC
       p_genera_reconexion();      --ejecucion de reconexion Tf
       p_genera_RECCLC();          --genera reconexiones de lineas cortadas por CLC TF
       p_genera_reconexion_xplora();  --ejecucion de reconexion xplora
       p_genera_reconexion_datos();


      -- modificacion por Gustavo Ormeño 20/04/2007, para que genere CLC también días Viernes
      --<REQ ID=107653 OBS=COMENTADO POR USO DE FUNCIÓN f_get_fechas_corte>
      /*if( (l_dia in (6) and (l_tmp = 0) )) then
          p_genera_CLC();             --genera CLC Tf
          p_genera_suspencion;        --ejecucion de suspenciones TF
          p_genera_corte();           --ejecucion de cortes TF
          p_genera_suspencion_xplora(); --suspensio xplora
          p_genera_corte_xplora(); --corte xplora, G. ORMENO, 11/09/2007
      end if;*/
      --<REQ>

      /*if ( (l_dia in (2,3,4,5)) and (l_tmp = 0) )  then*/ --<REQ ID=107653 OBS=COMENTADO POR USO DE FUNCIÓN f_get_fechas_corte>
      if ( f_get_fechas_corte = 1 ) then  --REQ 107653
--       if ( (l_dia in (1,2,3,4)) and (l_tmp = 0) )  then
         begin
            p_genera_suspencion;        --ejecucion de suspenciones TF
            p_genera_corte();           --ejecucion de cortes TF
            p_genera_CLC();             --genera CLC Tf
            p_genera_suspencion_xplora(); --suspensio xplora
            p_genera_corte_xplora(); --corte xplora, G. ORMENO, 11/09/2007
            p_genera_suspencion_datos;        --ejecucion de suspenciones TF
            p_genera_corte_datos();           --ejecucion de cortes TF

          end;
       end if;


  --------------------------------------------------
  ---ester codigo se debe poner en todos los stores
  ---que se llaman con un job
  --para ver si termino satisfactoriamente
  /*sp_rep_registra_error
     (c_nom_proceso, c_id_proceso,
      sqlerrm , '0', c_sec_grabacion);

  ------------------------
  exception
    when others then
        sp_rep_registra_error
           (c_nom_proceso, c_id_proceso,
            sqlerrm , '1',c_sec_grabacion );
        raise_application_error(-20000,sqlerrm);*/

  END;

/**********************************************************************
Genera las sots para suspenciones de telefonia FIJA Analogicas y Pris
**********************************************************************/

PROCEDURE p_genera_suspencion
  IS
  l_codsolot solot.codsolot%type;
  l_flgenviar number;
  cursor cur_tra is
  select *
  from transacciones
  where transaccion = 'SUSPENSION'
  and fecini is null
  --<7.0
  and fecfin is null
  --7.0>
--  and tipo = 1;
  and tipo in (/*1,*/3);   --se incluyen los TPI --34.0 (solo tpi)

  /*cRutaArchivo constant varchar2(100) := '/u03/oracle/PESGAPRD/UTL_FILE';*/
  --ls_enter constant varchar2(4) := chr(10) || chr(13);
  hArch UTL_FILE.FILE_TYPE;
  vNomArch varchar2(100);
  l_verifREc number;
  l_nomcli vtatabcli.nomcli%type;
  tienebaja number;
  l_cont_val_tpi number;--40.0
  BEGIN

  vNomArch := 'SUSPTELFIJA.htm';
  hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'w');
  l_flgenviar := 0;


  UTL_FILE.PUT_LINE(hArch,'<html>');
  UTL_FILE.PUT_LINE(hArch,'<head>');
  UTL_FILE.PUT_LINE(hArch,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
  UTL_FILE.PUT_LINE(hArch,'<title>Suspensiones por falta de pago - Telefonia Fija</title>');
  UTL_FILE.PUT_LINE(hArch,'</head>');
  UTL_FILE.PUT_LINE(hArch,'<body>');
  UTL_FILE.PUT_LINE(hArch,'<p><font color="#3366FF">SUSPENSIONES POR FALTA DE PAGO: - '||to_char(sysdate,'dd/mm/yyyy hh24:mi') ||  '</font> </p>');

  UTL_FILE.FCLOSE(hArch);

   for c_tra in cur_tra loop
     begin

/*     select count(*) into tienebaja
                    from solot S1, SOLOTPTO SP, INSSRV I
                    where S1.codcli = c_tra.codcli
                    and c_tra.nomabr = I.NUMERO
                    and I.CODINSSRV = SP.CODINSSRV
                    and SP.CODSOLOT = S1.CODSOLOT
                    and S1.tiptra in (5)
                    and S1.estsol in (12,29);*/
        -- se modifica incluyendo en la condición la función que verifica si tiene baja, si tiene, so anula la transacción
        -- y no genera SOT, si no tiene baja, si genera SOT.
        --<7.0
        --if (f_verdocpendiente(c_tra.idfac) = 0 or tienebaja > 0 ) then
        if (f_verdocpendiente(c_tra.idfac) = 0 or f_verifica_baja( c_tra.codcli, c_tra.nomabr) > 0 ) then
        --7.0>
        begin
--              update transacciones set fecini = sysdate where idtrans = c_tra.idtrans ;
              update transacciones set fecini = sysdate, fecfin = sysdate where idtrans = c_tra.idtrans ; -- modificación para que la suspension quede anulada y no genere activación posterior
        end;
        else

            l_verifREc :=   F_VERIFICARECIBO(c_tra.idfac);

            if (l_verifREc = 0) then --es analogica
            -- No se genera la SOT, se indica al usuario que genere la SOT manual.
                  update transacciones set esttrans = 'PENDIENTE' --fecini = sysdate, codsolot = l_codsolot
                  where idtrans = c_tra.idtrans ;
                  select nomcli into l_nomcli
                  from vtatabcli
                  where codcli = c_tra.codcli;

--                  p_envia_correo_c_attach('Suspensiones - Telefonía fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'augusto.carrillo@claro.com.pe','No se genero la SOT de suspensión por no encontrarse SIDs activos, Es necesario generar una SOT de suspensión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
                  --p_envia_correo_c_attach('Suspensiones - Telefonía fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'ysabel.marquez@claro.com.pe','No se genero la SOT de suspensión por no encontrarse SIDs activos, Es necesario generar una SOT de suspensión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');--30.0
                  --p_envia_correo_c_attach('Suspensiones - Telefonía fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'juan.garcia@claro.com.pe','No se genero la SOT de suspensión por no encontrarse SIDs activos, Es necesario generar una SOT de suspensión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');--30.0
                  p_envia_correo_c_attach('Suspensiones - Telefonía fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CortesyReconexiones@claro.com.pe','No se genero la SOT de suspensión por no encontrarse SIDs activos, Es necesario generar una SOT de suspensión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');--32.0
           end if;
            if (l_verifREc = 1) then --es analogica
             p_insert_sot(c_tra.codcli,3,'0004',1,13,l_codsolot);
            p_insert_solotpto_analogica(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac);
            pq_solot.p_asig_wf(l_codsolot,48);
            update transacciones set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
            p_enviar_notificaciones(c_tra.idtrans,'SUSPTELFIJA.htm');
            l_flgenviar := 1;
            end if;
            if(l_verifREc = 2) then--es pri
            p_insert_sot(c_tra.codcli,3,'0004',1,13,l_codsolot);
            p_insert_solotpto_pri(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac);
            pq_solot.p_asig_wf(l_codsolot,48);
            update transacciones set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
            p_enviar_notificaciones(c_tra.idtrans,'SUSPTELFIJA.htm');
            l_flgenviar := 1;
            end if;

            if(l_verifREc = 4) then--es TPI
                select count(1) into l_cont_val_tpi from tipopedd where abrev='VALTPISUSANT';--40.0
                if l_cont_val_tpi = 0 then--40.0
                    p_insert_sot(c_tra.codcli,3,'0059',1,13,l_codsolot); -- falta definir el tipo de trabajo
                    p_insert_solotpto_tpi(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac);
                    pq_solot.p_asig_wf(l_codsolot,48);
                    update transacciones set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
                    p_enviar_notificaciones(c_tra.idtrans,'SUSPTELFIJA.htm');
                    l_flgenviar := 1;
                 end if;--40.0
            end if;

/*        if(F_VERIFICARECIBO(c_tra.idfac) = 3) then--es pri y analogica
        p_insert_sot(c_tra.codcli,3,1,13,l_codsolot);
       -- p_insert_solotpto(l_codsolot,c_tra.codcli,c_tra.idfac);
        end if;*/
        end if;
     end;
      end loop;


     if l_flgenviar > 0 then
       hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'a');
       UTL_FILE.PUT_LINE(hArch,'</body>');
       UTL_FILE.PUT_LINE(hArch,'</html>');
       UTL_FILE.FCLOSE(hArch);
--03/03/2008       p_envia_correo_c_attach('Suspensiones - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-GestoresdeCreditosyCobranzas','Suspensiones - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA);
       p_envia_correo_c_attach('Suspensiones - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CONMUTACION@claro.com.pe','Suspensiones - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');--30.0
       if(l_verifREc = 4) then
              p_envia_correo_c_attach('Suspensiones - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-TelefoniaPublica@claro.com.pe','Suspensiones - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');--30.0
--03/03/2008              p_envia_correo_c_attach('Suspensiones - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno','Suspensiones - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
       end if;
     end if;

  END;


/**********************************************************************
Genara las sots para suspenciones de servicios de datos
**********************************************************************/

PROCEDURE p_genera_suspencion_datos
  IS
  l_codsolot solot.codsolot%type;
  l_flgenviar number;
  cursor cur_tra is
  select *
  from transacciones
  where transaccion = 'SUSPENSION'
  and fecini is null
  --<7.0
  and fecfin is null
  --7.0>
  and tipo in (5,6,7,8,9,11);   --TODOS LOS SERVICIOS DE DATOS

  /*cRutaArchivo constant varchar2(100) := '/u03/oracle/PESGAPRD/UTL_FILE';*/
  --ls_enter constant varchar2(4) := chr(10) || chr(13);
  hArch UTL_FILE.FILE_TYPE;
  vNomArch varchar2(100);
  l_verifREc number;
  n_tipsrv tystipsrv.tipsrv%type;
  n_hayTipsr number;
 -- tienebaja number; <7.0>

  BEGIN

  vNomArch := 'SUSPDATOS.htm';
  hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'w');
  l_flgenviar := 0;


  UTL_FILE.PUT_LINE(hArch,'<html>');
  UTL_FILE.PUT_LINE(hArch,'<head>');
  UTL_FILE.PUT_LINE(hArch,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
  UTL_FILE.PUT_LINE(hArch,'<title>Suspensiones por falta de pago - Datos</title>');
  UTL_FILE.PUT_LINE(hArch,'</head>');
  UTL_FILE.PUT_LINE(hArch,'<body>');
  UTL_FILE.PUT_LINE(hArch,'<p><font color="#3366FF">SUSPENSIONES POR FALTA DE PAGO: - '||to_char(sysdate,'dd/mm/yyyy hh24:mi') ||  '</font> </p>');

  UTL_FILE.FCLOSE(hArch);

   for c_tra in cur_tra loop
     begin

     --<7.0
/*     select count(*) into tienebaja
                    from solot S1, SOLOTPTO SP, INSSRV I
                    where S1.codcli = c_tra.codcli
                    and c_tra.nomabr = I.NUMERO
                    and I.CODINSSRV = SP.CODINSSRV
                    and SP.CODSOLOT = S1.CODSOLOT
                    and S1.tiptra in (5)
                    and S1.estsol in (12,29);*/

        --if (f_verdocpendiente(c_tra.idfac) = 0 or tienebaja > 0 ) then
        if (f_verdocpendiente(c_tra.idfac) = 0 or f_verifica_baja( c_tra.codcli, c_tra.nomabr) > 0 ) then
     --7.0>
        begin
--              update transacciones set fecini = sysdate where idtrans = c_tra.idtrans ;
              update transacciones set fecini = sysdate, fecfin = sysdate where idtrans = c_tra.idtrans ; -- modificación para que la suspension quede anulada y no genere activación posterior
        end;
        else

            --Ini 28.0
            FOR C_SOT IN ( select distinct i.tipsrv, i.codsuc
                            from cr, instxproducto ip, instanciaservicio isr, bilfac b, cxctabfac c, inssrv i
                              where c.idfac = c_tra.idfac and
                                  b.idfaccxc = c.idfac and
                                  cr.idinstprod = ip.idinstprod and
                                  ip.idcod = isr.idinstserv and
                                  ip.codcli = isr.codcli and
                                  cr.idbilfac = b.idbilfac and
                                  isr.codinssrv = i.codinssrv and
                                  isr.codcli = c_tra.codcli  and
                                  i.estinssrv not in (3,4))  -- Para que no se considere servicios de baja o sin activar
            --Fin 28.0
            LOOP

                p_insert_sot(c_tra.codcli,3,C_SOT.tipsrv,1,13,l_codsolot);
                p_insert_solotpto_datos(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac,C_SOT.TIPSRV,C_SOT.CODSUC);

                --<REQ ID = 99173>
                --pq_solot.p_asig_wf(l_codsolot,58); --Se comenta, ya que el WF que se va a asignar depende de la configuración
                OPERACION.PQ_SOLOT.P_EJECUTAR_SOLOT(l_codsolot);
                --</REQ>
            END LOOP;

            update transacciones set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
            p_enviar_notificaciones(c_tra.idtrans,'SUSPDATOS.htm');
            l_flgenviar := 1;


        end if;
     end;
      end loop;


     if l_flgenviar > 0 then
       hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'a');
       UTL_FILE.PUT_LINE(hArch,'</body>');
       UTL_FILE.PUT_LINE(hArch,'</html>');
       UTL_FILE.FCLOSE(hArch);
--       p_envia_correo_c_attach('Suspensiones - Datos - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno','Suspensiones - Datos - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
--03/03/2008       p_envia_correo_c_attach('Suspensiones - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-GestoresdeCreditosyCobranzas','Suspensiones - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
--       p_envia_correo_c_attach('Suspensiones - Datos - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CONMUTACION','Suspensiones - Datos - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');

--       p_envia_correo_c_attach('Suspensiones - Datos - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'augusto.carrillo','Suspensiones - Datos - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
       --p_envia_correo_c_attach('Suspensiones - Datos - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'ysabel.marquez@claro.com.pe','Suspensiones - Datos - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');--30.0
       --p_envia_correo_c_attach('Suspensiones - Datos - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'juanc.garcia@claro.com.pe','Suspensiones - Datos - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');--30.0
       p_envia_correo_c_attach('Suspensiones - Datos - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CortesyReconexiones@claro.com.pe','Suspensiones - Datos - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');--32.0


     end if;

  END;


/**********************************************************************
Genara las sots para suspenciones de paquetes xplora
**********************************************************************/

PROCEDURE p_genera_suspencion_xplora
  IS
  l_codsolot solot.codsolot%type;
  l_flgenviar number;
  l_numpuntos number; --variable util para ubicar la instancia de paquete
  l_inspaq vtadetptoenl.idinsxpaq%type;
  l_nomcli vtatabcli.nomcli%type;
  l_cant_puntos number;
  l_cant_ptos_locut number;
--  tienebaja number;--<7.0>

  cursor cur_tra is
  select *
  from transacciones
  where transaccion = 'SUSPENSION'
  and fecini is null
  --<7.0
  and fecfin is null
  --7.0>
  and tipo = 2 and (esttrans <> 'RECONECTADA' OR esttrans IS NULL)
  and 1 = 2;--34.0

  cursor cur_inspaq(c_idfac cxctabfac.idfac%type) is
  select distinct vs.idinsxpaq
  from  bilfac b, cr, instanciaservicio sb,inssrv so, vtadetptoenl vs
  where b.idfaccxc = c_idfac and
        b.idbilfac = cr.idbilfac and
        cr.nivel = 2 and
        cr.idcod = sb.idinstserv and
        sb.codinssrv = so.codinssrv and
        so.numslc = vs.numslc
        --and so.estinssrv = 1    -- solo los servicios activos
        and ( so.estinssrv = 1 or (so.estinssrv = 2 and  'CLC' IN (select instanciaservicio.esttlfcli from instanciaservicio  where instanciaservicio.codinssrv = so.codinssrv and instanciaservicio.codcli = b.codcli)) )
        -- se adiciona condición para que sea posible ubicar el inspaq que pertenece en servicios suspendidos por límite de crédito.
   union
   select distinct vs.idinsxpaq
   from  bilfac b, instanciaservicio sb,inssrv so, vtadetptoenl vs
   where b.idfaccxc = c_idfac and
          b.idisprincipal = sb.idinstserv and
          sb.codinssrv = so.codinssrv and
          so.numslc = vs.numslc
        --and so.estinssrv = 1    -- solo los servicios activos
          and ( so.estinssrv = 1 or (so.estinssrv = 2 and  'CLC' IN (select instanciaservicio.esttlfcli from instanciaservicio  where instanciaservicio.codinssrv = so.codinssrv and instanciaservicio.codcli = b.codcli)) ) ;
        -- se adiciona condición para que sea posible ubicar el inspaq que pertenece en servicios suspendidos por límite de crédito.

  hArch UTL_FILE.FILE_TYPE;
  vNomArch varchar2(100);

  BEGIN
  vNomArch := 'SUSPXPLORA.htm';
  hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'w');
  l_flgenviar := 0;

  UTL_FILE.PUT_LINE(hArch,'<html>');
  UTL_FILE.PUT_LINE(hArch,'<head>');
  UTL_FILE.PUT_LINE(hArch,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
  UTL_FILE.PUT_LINE(hArch,'<title>Suspensiones por falta de pago - Xplora</title>');
  UTL_FILE.PUT_LINE(hArch,'</head>');
  UTL_FILE.PUT_LINE(hArch,'<body>');
  UTL_FILE.PUT_LINE(hArch,'<p><font color="#3366FF">SUSPENSIONES POR FALTA DE PAGO: - XPLORA '||to_char(sysdate,'dd/mm/yyyy hh24:mi') ||  '</font> </p>');

  UTL_FILE.FCLOSE(hArch);


  for c_tra in cur_tra loop
     begin
          l_inspaq := 0;
          --<7.0
/*          select count(*) into tienebaja
                    from solot S1, SOLOTPTO SP, INSSRV I
                    where S1.codcli = c_tra.codcli
                    and c_tra.nomabr = I.NUMERO
                    and I.CODINSSRV = SP.CODINSSRV
                    and SP.CODSOLOT = S1.CODSOLOT
                    and S1.tiptra in (5)
                    and S1.estsol in (12,29);*/
     -- se modifica incluyendo en la condición la función que verifica si tiene baja, si tiene, so anula la transacción
     -- y no genera SOT, si no tiene baja, si genera SOT.
          --if (f_verdocpendiente(c_tra.idfac) = 0 or tienebaja > 0) then --verifico q el documento no este cancelado
          if (f_verdocpendiente(c_tra.idfac) = 0 or f_verifica_baja( c_tra.codcli, c_tra.nomabr) > 0) then --verifico q el documento no este cancelado
          --7.0>
              begin
--              update transacciones set fecini = sysdate where idtrans = c_tra.idtrans ;
              update transacciones set fecini = sysdate, fecfin = sysdate where idtrans = c_tra.idtrans ; -- modificación para que la suspension quede anulada y no genere activación posterior
              end;
          else
              begin
                    for c_inspaq in cur_inspaq(c_tra.idfac) loop
                      begin
                        l_inspaq := c_inspaq.idinsxpaq;
                      end;
                    end loop;

                    --Ini 27.0
                    --if l_inspaq > 0 then
                    if l_inspaq > 0 and f_cuenta_ptos_paq( c_tra.codcli, l_inspaq) > 0 then
                    --Fin 27.0

                          p_insert_sot(c_tra.codcli,3,'0058',1,892,l_codsolot);
                          p_insert_solotpto_paquete(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac,l_inspaq);

                          -- Inicio Asignar WF de telefonia a servicios de locutorio GORMENO 05/02/2008

                          select count(1) INTO l_cant_puntos
                          from inssrv
                          where codinssrv in (select codinssrv from solotpto where codsolot = l_codsolot );

                          select count(1) into l_cant_ptos_locut
                          from inssrv
                          where codinssrv in (select codinssrv from solotpto where codsolot = l_codsolot ) AND CODSRV = 4385; --servicio locutorio

                          if l_cant_puntos = l_cant_ptos_locut then
                              pq_solot.p_asig_wf(l_codsolot,48);
                          else
                              pq_solot.p_asig_wf(l_codsolot,712);
                          end if;

                          -- Fin Asignar WF de telefonia a servicios de locutorio GORMENO

                        update transacciones set fecini = sysdate, codsolot = l_codsolot, esttrans = 'GENERADA'
                        where idtrans = c_tra.idtrans ;
                        p_enviar_notificaciones(c_tra.idtrans,'SUSPXPLORA.htm');
                        l_flgenviar := 1;
                    else
                        update transacciones set esttrans = 'PENDIENTE' --fecini = sysdate, codsolot = l_codsolot
                        where idtrans = c_tra.idtrans ;
                        select nomcli into l_nomcli
                        from vtatabcli
                        where codcli = c_tra.codcli;

--                        p_envia_correo_c_attach('Suspensiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-GestoresdeCreditosyCobranzas','No se genero la SOT de suspensión por no encontrarse SIDs activos, Es necesario generar una SOT de suspensión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');

--                        p_envia_correo_c_attach('Suspensiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'augusto.carrillo@claro.com.pe','No se genero la SOT de suspensión por no encontrarse SIDs activos, Es necesario generar una SOT de suspensión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
                        --p_envia_correo_c_attach('Suspensiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'ysabel.marquez@claro.com.pe','No se genero la SOT de suspensión por no encontrarse SIDs activos, Es necesario generar una SOT de suspensión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');--30.0
                        --p_envia_correo_c_attach('Suspensiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'juanc.garcia@claro.com.pe','No se genero la SOT de suspensión por no encontrarse SIDs activos, Es necesario generar una SOT de suspensión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');--30.0
                        p_envia_correo_c_attach('Suspensiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CortesyReconexiones@claro.com.pe','No se genero la SOT de suspensión por no encontrarse SIDs activos, Es necesario generar una SOT de suspensión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');--32.0
--p_envia_correo_c_attach('Suspensiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno@claro.com.pe','No se genero la SOT de suspensión por no encontrarse SIDs activos, Es necesario generar una SOT de suspensión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
                    end if;
              end;
           end if;
        end;
      end loop;


     if l_flgenviar > 0 then
       hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'a');
       UTL_FILE.PUT_LINE(hArch,'</body>');
       UTL_FILE.PUT_LINE(hArch,'</html>');
       UTL_FILE.FCLOSE(hArch);
--       p_envia_correo_c_attach('Suspensiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno','Suspensiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
--03/03/2008       p_envia_correo_c_attach('Suspensiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-GestoresdeCreditosyCobranzas','Suspensiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
--       p_envia_correo_c_attach('Suspensiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CONMUTACION','Suspensiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
--       p_envia_correo_c_attach('Suspensiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'augusto.carrillo','Suspensiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
       --p_envia_correo_c_attach('Suspensiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'ysabel.marquez@claro.com.pe','Suspensiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');--30.0
       --p_envia_correo_c_attach('Suspensiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'juanc.garcia@claro.com.pe','Suspensiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');--30.0
       p_envia_correo_c_attach('Suspensiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CortesyReconexiones@claro.com.pe','Suspensiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');--32.0
     end if;

  END;

/**********************************************************************
Genara las sots para cortes de paquetes xplora
**********************************************************************/

PROCEDURE p_genera_corte_xplora
  IS
  l_codsolot solot.codsolot%type;
  l_flgenviar number;
  l_numpuntos number; --variable util para ubicar la instancia de paquete
  l_inspaq vtadetptoenl.idinsxpaq%type;
  l_nomcli vtatabcli.nomcli%type;
  l_cant_puntos number;
  l_cant_ptos_locut number;

  cursor cur_tra is
  select *
  from transacciones
  where transaccion = 'CORTE'
  and fecini is null
  and tipo = 2
  and 1 = 2;--34.0

 cursor cur_inspaq(c_idfac cxctabfac.idfac%type) is
  select distinct vs.idinsxpaq
  from  bilfac b, cr, instanciaservicio sb,inssrv so, vtadetptoenl vs
  where b.idfaccxc = c_idfac and
        b.idbilfac = cr.idbilfac and
        cr.nivel = 2 and
        cr.idcod = sb.idinstserv and
        sb.codinssrv = so.codinssrv and
        so.numslc = vs.numslc
        and so.estinssrv <> 3    -- solo los servicios suspendisos pues existe una suspension previa
   union
   select distinct vs.idinsxpaq
   from  bilfac b, instanciaservicio sb,inssrv so, vtadetptoenl vs
   where b.idfaccxc = c_idfac and
          b.idisprincipal = sb.idinstserv and
          sb.codinssrv = so.codinssrv and
          so.numslc = vs.numslc
          and so.estinssrv <> 3  ;  -- solo los servicios suspendisos pues existe una suspension previa


  hArch UTL_FILE.FILE_TYPE;
  vNomArch varchar2(100);
 -- tienebaja number;--<7.0>

  BEGIN
  vNomArch := 'CORTEXPLORA.htm';
  hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'w');
  l_flgenviar := 0;

  UTL_FILE.PUT_LINE(hArch,'<html>');
  UTL_FILE.PUT_LINE(hArch,'<head>');
  UTL_FILE.PUT_LINE(hArch,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
  UTL_FILE.PUT_LINE(hArch,'<title>Cortes por falta de pago - Xplora</title>');
  UTL_FILE.PUT_LINE(hArch,'</head>');
  UTL_FILE.PUT_LINE(hArch,'<body>');
  UTL_FILE.PUT_LINE(hArch,'<p><font color="#3366FF">CORTES POR FALTA DE PAGO: - XPLORA '||to_char(sysdate,'dd/mm/yyyy hh24:mi') ||  '</font> </p>');

  UTL_FILE.FCLOSE(hArch);

   for c_tra in cur_tra loop
     begin
          l_inspaq := 0;
          --<7.0
         /* select count(*) into tienebaja
                    from solot S1, SOLOTPTO SP, INSSRV I
                    where S1.codcli = c_tra.codcli
                    and c_tra.nomabr = I.NUMERO
                    and I.CODINSSRV = SP.CODINSSRV
                    and SP.CODSOLOT = S1.CODSOLOT
                    and S1.tiptra in (5)
                    and S1.estsol in (12,29);*/
           --7.0>
  -- se modifica incluyendo en la condición la función que verifica si tiene baja, si tiene, so anula la transacción
  -- y no genera SOT, si no tiene baja, si genera SOT.

         --<6.0
          --if (f_verdocpendiente(c_tra.idfac) = 0 or tienebaja > 0) then --verifico q el documento no este cancelado -<6.0>
          --if (collections.f_get_cxtabfac_adeudados(c_tra.codcli,c_tra.nomabr) = 0 or tienebaja > 0) then--<7.0>
          if (collections.f_get_cxtabfac_adeudados(c_tra.codcli,c_tra.nomabr) = 0 or f_verifica_baja( c_tra.codcli, c_tra.nomabr) > 0) then--<7.0>
          --6.0>
              begin
--              update transacciones set fecini = sysdate where idtrans = c_tra.idtrans ;
                update transacciones set fecini = sysdate, fecfin = sysdate where idtrans = c_tra.idtrans ; -- modificación para que la suspension quede anulada y no genere activación posterior
               -- inserta la reconexión a la que se le asignará una SOT con el procedimiento que corre con el JOB (a partir de la suspensión obtenida)
                  --<7.0
                  --if (tienebaja = 0) then
                  if (f_verifica_baja( c_tra.codcli, c_tra.nomabr) = 0) then
                  --7.0>
                      INSERT INTO OPERACION.TRANSACCIONES (IDFAC, NOMABR, CODCLI, TRANSACCION, CODUSU, IDTRANSORI, TIPO)
                      VALUES (c_tra.IDFAC,c_tra.NOMABR,c_tra.CODCLI, 'ACTIVACION', user,c_tra.idtransori,2);
                  end if;
              end;
          else
              begin

                    for c_inspaq in cur_inspaq(c_tra.idfac) loop
                      begin
                        l_inspaq := c_inspaq.idinsxpaq;
                      end;
                    end loop;

                    --Ini 27.0
                    --if l_inspaq > 0 then
                    if l_inspaq > 0 and f_cuenta_ptos_paq( c_tra.codcli, l_inspaq) > 0 then
                    --Fin 27.0
                       p_insert_sot(c_tra.codcli,349,'0058',1,892,l_codsolot);
                       p_insert_solotpto_paquete(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac,l_inspaq);

                          -- Inicio Asignar WF de telefonia a servicios de locutorio GORMENO 05/02/2008

                          select count(1) INTO l_cant_puntos
                          from inssrv
                          where codinssrv in (select codinssrv from solotpto where codsolot = l_codsolot );

                          select count(1) into l_cant_ptos_locut
                          from inssrv
                          where codinssrv in (select codinssrv from solotpto where codsolot = l_codsolot ) AND CODSRV = 4385; --servicio locutorio

                          if l_cant_puntos = l_cant_ptos_locut then
                               pq_solot.p_asig_wf(l_codsolot,268); -- es locutorio
                          else
                              pq_solot.p_asig_wf(l_codsolot,714);
                          end if;

                          -- Fin Asignar WF de telefonia a servicios de locutorio GORMENO


                        update transacciones set fecini = sysdate, codsolot = l_codsolot, esttrans = 'GENERADA'
                        where idtrans = c_tra.idtrans ;
                        p_enviar_notificaciones(c_tra.idtrans,'CORTEXPLORA.htm');
                        l_flgenviar := 1;
                    else
                        update transacciones set esttrans = 'PENDIENTE' --fecini = sysdate, codsolot = l_codsolot
                        where idtrans = c_tra.idtrans ;
                        select nomcli into l_nomcli
                        from vtatabcli
                        where codcli = c_tra.codcli;

--                      p_envia_correo_c_attach('Cortes - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno','No se genero la SOT de corte por no encontrarse SIDs activos, Es necesario generar una SOT de corte manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
--                      p_envia_correo_c_attach('Cortes - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-GestoresdeCreditosyCobranzas','No se genero la SOT de corte por no encontrarse SIDs activos, Es necesario generar una SOT de corte manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
--                      p_envia_correo_c_attach('Cortes - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'augusto.carrillo','No se genero la SOT de corte por no encontrarse SIDs activos, Es necesario generar una SOT de corte manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
                      --p_envia_correo_c_attach('Cortes - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'ysabel.marquez@claro.com.pe','No se genero la SOT de corte por no encontrarse SIDs activos, Es necesario generar una SOT de corte manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');--30.0
                      --p_envia_correo_c_attach('Cortes - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'juanc.garcia@claro.com.pe','No se genero la SOT de corte por no encontrarse SIDs activos, Es necesario generar una SOT de corte manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');--30.0
                      p_envia_correo_c_attach('Cortes - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CortesyReconexiones@claro.com.pe','No se genero la SOT de corte por no encontrarse SIDs activos, Es necesario generar una SOT de corte manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');--32.0

                    end if;

               end;
           end if;
        end;
      end loop;


     if l_flgenviar > 0 then
       hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'a');
       UTL_FILE.PUT_LINE(hArch,'</body>');
       UTL_FILE.PUT_LINE(hArch,'</html>');
       UTL_FILE.FCLOSE(hArch);

--       p_envia_correo_c_attach('Cortes - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno','Cortes - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
--03/03/2008       p_envia_correo_c_attach('Cortes - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-GestoresdeCreditosyCobranzas','Cortes - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
       p_envia_correo_c_attach('Cortes - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CONMUTACION@claro.com.pe','Cortes - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');

     end if;

  END;

/**********************************************************************
Genara las sots para cortes de telefonia FIJA Analogicas y Pris
**********************************************************************/

  PROCEDURE p_genera_corte
  IS
  l_codsolot solot.codsolot%type;
  l_flgenviar number;
  cursor cur_tra is
  select *
  from transacciones
  where transaccion in('BAJA','CORTE')
  and fecini is null
  and tipo in (/*1,*/3); -- Se incluye el tipo 3 para TPI--34.0 (solo tpi)

/*  cRutaArchivo constant varchar2(100) := '/u03/oracle/PESGAPRD/UTL_FILE';
  ls_enter constant varchar2(4) := chr(10) || chr(13);*/
  hArch UTL_FILE.FILE_TYPE;
  vNomArch varchar2(100);
    l_verifREc number;
    l_nomcli vtatabcli.nomcli%type;
    tienebaja number;

  BEGIN

  vNomArch := 'CORTTELFIJA.htm';
  hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'w');
  l_flgenviar := 0;

  UTL_FILE.PUT_LINE(hArch,'<html>');
  UTL_FILE.PUT_LINE(hArch,'<head>');
  UTL_FILE.PUT_LINE(hArch,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
  UTL_FILE.PUT_LINE(hArch,'<title>Corte por falta de pago - Telefonia Fija</title>');
  UTL_FILE.PUT_LINE(hArch,'</head>');
  UTL_FILE.PUT_LINE(hArch,'<body>');
  UTL_FILE.PUT_LINE(hArch,'<p><font color="#3366FF">CORTES POR FALTA DE PAGO: - '||to_char(sysdate,'dd/mm/yyyy hh24:mi') ||  '</font> </p>');

  UTL_FILE.FCLOSE(hArch);

   for c_tra in cur_tra loop
     begin
     --<7.0
/*     select count(*) into tienebaja
                    from solot S1, SOLOTPTO SP, INSSRV I
                    where S1.codcli = c_tra.codcli
                    and c_tra.nomabr = I.NUMERO
                    and I.CODINSSRV = SP.CODINSSRV
                    and SP.CODSOLOT = S1.CODSOLOT
                    and S1.tiptra in (5)
                    and S1.estsol in (12,29);*/
      --7.0>
      -- se modifica incluyendo en la condición la función que verifica si tiene baja, si tiene, so anula la transacción
      -- y no genera SOT, si no tiene baja, si genera SOT.
         --<6.0
          --if (f_verdocpendiente(c_tra.idfac) = 0 or tienebaja > 0) then --verifico q el documento no este cancelado -<6.0>
          --if (collections.f_get_cxtabfac_adeudados(c_tra.codcli,c_tra.nomabr) = 0 or tienebaja > 0) then--<7.0>
          if (collections.f_get_cxtabfac_adeudados(c_tra.codcli,c_tra.nomabr) = 0 or f_verifica_baja( c_tra.codcli, c_tra.nomabr) > 0) then--<7.0>
          --6.0>
        begin
             update transacciones set fecini = sysdate, fecfin = sysdate where idtrans = c_tra.idtrans ;
             -- inserta la reconexión a la que se le asignará una SOT con el procedimiento que corre con el JOB (a partir de la suspensión obtenida)
            --<7.0
            --if (tienebaja = 0) then
            if (f_verifica_baja( c_tra.codcli, c_tra.nomabr) = 0) then
            --7.0>
                 INSERT INTO OPERACION.TRANSACCIONES (IDFAC, NOMABR, CODCLI, TRANSACCION, CODUSU, IDTRANSORI, TIPO)
                 VALUES (c_tra.idfac,c_tra.nomabr,c_tra.codcli, 'ACTIVACION', user,c_tra.idtransori,c_tra.tipo);
            end if;

        end;
        else

               l_verifREc := F_VERIFICARECIBO(c_tra.idfac);
              if (l_verifREc = 0) then --es analogica
                  -- No se genera la SOT, se indica al usuario que genere la SOT manual.
                        update transacciones set esttrans = 'PENDIENTE' --fecini = sysdate, codsolot = l_codsolot
                        where idtrans = c_tra.idtrans ;
                        select nomcli into l_nomcli
                        from vtatabcli
                        where codcli = c_tra.codcli;

--                        p_envia_correo_c_attach('Suspensiones - Telefonía fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno@claro.com.pe','No se genero la SOT de corte por no encontrarse SIDs activos, Es necesario generar una SOT de corte manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
--                        p_envia_correo_c_attach('Suspensiones - Telefonía fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-GestoresdeCreditosyCobranzas@claro.com.pe','No se genero la SOT de corte por no encontrarse SIDs activos, Es necesario generar una SOT de corte manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
--                        p_envia_correo_c_attach('Suspensiones - Telefonía fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'augusto.carrillo@claro.com.pe','No se genero la SOT de corte por no encontrarse SIDs activos, Es necesario generar una SOT de corte manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
                        --p_envia_correo_c_attach('Suspensiones - Telefonía fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'ysabel.marquez@claro.com.pe','No se genero la SOT de corte por no encontrarse SIDs activos, Es necesario generar una SOT de corte manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');--30.0
                        --p_envia_correo_c_attach('Suspensiones - Telefonía fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'juanc.garcia@claro.com.pe','No se genero la SOT de corte por no encontrarse SIDs activos, Es necesario generar una SOT de corte manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');--30.0
                        p_envia_correo_c_attach('Suspensiones - Telefonía fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CortesyReconexiones@claro.com.pe','No se genero la SOT de corte por no encontrarse SIDs activos, Es necesario generar una SOT de corte manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');--32.0

                 end if;
                if (l_verifREc = 1) then --es analogica
                 p_insert_sot(c_tra.codcli,349,'0004',1,13,l_codsolot);
                p_insert_solotpto_analogica(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac);
                pq_solot.p_asig_wf(l_codsolot,268);
                update transacciones set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
                p_enviar_notificaciones(c_tra.idtrans,'CORTTELFIJA.htm');
                l_flgenviar := 1;
                --update transacciones set fecfin = sysdate where idtrans = c_tra.idtransori ;
                end if;
                if(l_verifREc = 2) then--es pri
                p_insert_sot(c_tra.codcli,349,'0004',1,13,l_codsolot);
                p_insert_solotpto_pri(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac);
                pq_solot.p_asig_wf(l_codsolot,268);
                update transacciones set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
                p_enviar_notificaciones(c_tra.idtrans,'CORTTELFIJA.htm');
                l_flgenviar := 1;
                --update transacciones set fecfin = sysdate where idtrans = c_tra.idtransori ;
                end if;

                if(l_verifREc = 4) then--es TPI
                p_insert_sot(c_tra.codcli,5,'0059',1,37,l_codsolot);
                p_insert_solotpto_tpi(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac);
                pq_solot.p_asig_wf(l_codsolot,697);
                update transacciones set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
                p_enviar_notificaciones(c_tra.idtrans,'CORTTELFIJA.htm');
                -- se incluye fecha de compromiso req. 68693
                update solot set feccom = sysdate + 7 where codsolot = l_codsolot;

                l_flgenviar := 1;
                --update transacciones set fecfin = sysdate where idtrans = c_tra.idtransori ;
                end if;


        /*        if(F_VERIFICARECIBO(c_tra.idfac) = 3) then--es pri y analogica
                p_insert_sot(c_tra.codcli,3,1,13,l_codsolot);
               -- p_insert_solotpto(l_codsolot,c_tra.codcli,c_tra.idfac);
                end if;*/
            end if;
     end;
      end loop;

     if l_flgenviar > 0 then
       hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'a');
       UTL_FILE.PUT_LINE(hArch,'</body>');
       UTL_FILE.PUT_LINE(hArch,'</html>');
       UTL_FILE.FCLOSE(hArch);
--       p_envia_correo_c_attach('Cortes - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno@claro.com.pe','Cortes - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
--03/03/2008       p_envia_correo_c_attach('Cortes - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-GestoresdeCreditosyCobranzas@claro.com.pe','Cortes - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
       p_envia_correo_c_attach('Cortes - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CONMUTACION@claro.com.pe','Cortes - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
      if l_verifREc = 4 then
             p_envia_correo_c_attach('Cortes - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-TelefoniaPublica@claro.com.pe','Cortes - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
--             p_envia_correo_c_attach('Cortes - Telefonia TPI - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno@claro.com.pe','Cortes - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
      END IF;
    end if;

  END;

/**********************************************************************
Genara las sots para cortes de telefonia FIJA Analogicas y Pris
**********************************************************************/

  PROCEDURE p_genera_corte_datos
  IS
  l_codsolot solot.codsolot%type;
  l_flgenviar number;
  cursor cur_tra is
  select *
  from transacciones
  where transaccion = 'CORTE'
  and fecini is null
  and tipo in (5,6,7,8,9,11); -- Servicios de datos

/*  cRutaArchivo constant varchar2(100) := '/u03/oracle/PESGAPRD/UTL_FILE';
  ls_enter constant varchar2(4) := chr(10) || chr(13);*/
  hArch UTL_FILE.FILE_TYPE;
  vNomArch varchar2(100);
    l_verifREc number;
n_tipsrv tystipsrv.tipsrv%type;
  n_hayTipsr number;
  tienebaja number;

  BEGIN

  vNomArch := 'CORTEDATOS.htm';
  hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'w');
  l_flgenviar := 0;

  UTL_FILE.PUT_LINE(hArch,'<html>');
  UTL_FILE.PUT_LINE(hArch,'<head>');
  UTL_FILE.PUT_LINE(hArch,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
  UTL_FILE.PUT_LINE(hArch,'<title>Corte por falta de pago - Datos</title>');
  UTL_FILE.PUT_LINE(hArch,'</head>');
  UTL_FILE.PUT_LINE(hArch,'<body>');
  UTL_FILE.PUT_LINE(hArch,'<p><font color="#3366FF">CORTES POR FALTA DE PAGO: - '||to_char(sysdate,'dd/mm/yyyy hh24:mi') ||  '</font> </p>');

  UTL_FILE.FCLOSE(hArch);

   for c_tra in cur_tra loop

 /*  select count(*) into tienebaja
                    from solot S1, SOLOTPTO SP, INSSRV I
                    where S1.codcli = c_tra.codcli
                    and c_tra.nomabr = I.NUMERO
                    and I.CODINSSRV = SP.CODINSSRV
                    and SP.CODSOLOT = S1.CODSOLOT
                    and S1.tiptra in (5)
                    and S1.estsol in (12,29);*/

     begin
    -- se modifica incluyendo en la condición la función que verifica si tiene baja, si tiene, so anula la transacción
    -- y no genera SOT, si no tiene baja, si genera SOT.
       --<6.0
          --if (f_verdocpendiente(c_tra.idfac) = 0 or tienebaja > 0) then --verifico q el documento no este cancelado -<6.0>
          --if (collections.f_get_cxtabfac_adeudados(c_tra.codcli,c_tra.nomabr) = 0 or tienebaja > 0) then--<7.0>
          if (collections.f_get_cxtabfac_adeudados(c_tra.codcli,c_tra.nomabr) = 0 or f_verifica_baja( c_tra.codcli, c_tra.nomabr) > 0) then--<7.0>
          --6.0>
      begin
           update transacciones set fecini = sysdate, fecfin = sysdate where idtrans = c_tra.idtrans ;
           -- inserta la reconexión a la que se le asignará una SOT con el procedimiento que corre con el JOB (a partir de la suspensión obtenida)
           --<7.0
           --if (tienebaja = 0) then
           if (f_verifica_baja( c_tra.codcli, c_tra.nomabr) = 0) then
           --7.0>
             INSERT INTO OPERACION.TRANSACCIONES (IDFAC, NOMABR, CODCLI, TRANSACCION, CODUSU, IDTRANSORI, TIPO)
             VALUES (c_tra.idfac,c_tra.nomabr,c_tra.codcli, 'ACTIVACION', user,c_tra.idtransori,c_tra.TIPO);
            end if;
       end;
        else
              -- obtengo el tipo de servicio para la SOT
              select count(tipsrv) into n_hayTipsr
                from solot
               where codsolot in
                     (select max(s.codsolot)
                        from inssrv i, cxctabfac c, solot s, solotpto sp
                       where i.numero = c.nomabr
                         and c.idfac = c_tra.idfac
                         and sp.codinssrv = i.codinssrv
                         and s.codsolot = sp.codsolot
                         and s.tiptra = 1
                      /* and s.estsol = 12*/
                      );
               if (n_hayTipsr > 0) then
               -- obtengo el tipo de servicio para la SOT
                 select tipsrv into n_tipsrv
                  from solot
                 where codsolot in
                       (select max(s.codsolot)
                          from inssrv i, cxctabfac c, solot s, solotpto sp
                         where i.numero = c.nomabr
                           and c.idfac = c_tra.idfac
                           and sp.codinssrv = i.codinssrv
                           and s.codsolot = sp.codsolot
                           and s.tiptra = 1
                        /* and s.estsol = 12*/
                        );
                end if;

            --Ini 28.0
            FOR C_SOT IN ( select distinct i.tipsrv, i.codsuc
                            from cr, instxproducto ip, instanciaservicio isr, bilfac b, cxctabfac c, inssrv i
                              where c.idfac = c_tra.idfac and
                                  b.idfaccxc = c.idfac and
                                  cr.idinstprod = ip.idinstprod and
                                  ip.idcod = isr.idinstserv and
                                  ip.codcli = isr.codcli and
                                  cr.idbilfac = b.idbilfac and
                                  isr.codinssrv = i.codinssrv and
                                  isr.codcli = c_tra.codcli and
                                  i.estinssrv not in (3,4))  -- Para que no se considere servicios de baja o sin activar
            --Fin 28.0
            LOOP

                p_insert_sot(c_tra.codcli,349,C_SOT.tipsrv,1,13,l_codsolot);
                p_insert_solotpto_datos(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac,C_SOT.TIPSRV,C_SOT.CODSUC);
                pq_solot.p_asig_wf(l_codsolot,263);

            END LOOP;

                update transacciones set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
                p_enviar_notificaciones(c_tra.idtrans,'CORTEDATOS.htm');
                l_flgenviar := 1;
                --update transacciones set fecfin = sysdate where idtrans = c_tra.idtransori ;

            end if;
     end;
      end loop;

     if l_flgenviar > 0 then
       hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'a');
       UTL_FILE.PUT_LINE(hArch,'</body>');
       UTL_FILE.PUT_LINE(hArch,'</html>');
       UTL_FILE.FCLOSE(hArch);
--       p_envia_correo_c_attach('Cortes - Datos - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno@claro.com.pe','Cortes - Datos - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
--03/03/2008       p_envia_correo_c_attach('Cortes - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-GestoresdeCreditosyCobranzas@claro.com.pe','Cortes - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');

       p_envia_correo_c_attach('Cortes - Datos - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CONMUTACION@claro.com.pe','Cortes - Datos - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');

--       p_envia_correo_c_attach('Cortes - Datos - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno@claro.com.pe','Cortes - Datos - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');

    end if;

  END;

/**********************************************************************
Genara las sots para reconexiones de telefonia FIJA Analogicas y Pris
**********************************************************************/

  PROCEDURE p_genera_reconexion
  IS
  l_codsolot solot.codsolot%type;
  l_flgenviar number;
  cursor cur_tra is
  select *
  from transacciones
  where transaccion = 'ACTIVACION'
  and fecini is null
  and tipo in (/*1,*/3); -- Se incluye el tipo 3 para TPI --34.0 (solo tpi)

/*  cRutaArchivo constant varchar2(100) := '/u03/oracle/PESGAPRD/UTL_FILE';
  ls_enter constant varchar2(4) := chr(10) || chr(13);*/
  hArch UTL_FILE.FILE_TYPE;
  vNomArch varchar2(100);

  -- variable para verificar si existe SOT de CLC aún no aprobada
  estadoSot number;
  sotCFP number;
  sotBaja number;
  l_verifREc NUMBER;
  l_nomcli vtatabcli.nomcli%type;
  sot_susp number;
  sid_actual INSSRV.CODINSSRV%TYPE;
  hay_sid_actual number;
  -- Variable para verificar si existe SOT de suspension a pedido del cliente
  sotSPC number;
  ld_fecrec solot.fecrec%type;
  l_verifSPC number;
  ld_fecactual date;

  BEGIN

  vNomArch := 'RCNXTELFIJA.htm';
  hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'w');
  l_flgenviar := 0;

  UTL_FILE.PUT_LINE(hArch,'<html>');
  UTL_FILE.PUT_LINE(hArch,'<head>');
  UTL_FILE.PUT_LINE(hArch,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
  UTL_FILE.PUT_LINE(hArch,'<title>Reconexion por falta de pago - Telefonia Fija</title>');
  UTL_FILE.PUT_LINE(hArch,'</head>');
  UTL_FILE.PUT_LINE(hArch,'<body>');
  UTL_FILE.PUT_LINE(hArch,'<p><font color="#3366FF">RECONEXION POR FALTA DE PAGO: - '||to_char(sysdate,'dd/mm/yyyy hh24:mi') ||  '</font> </p>');

  UTL_FILE.FCLOSE(hArch);

   for c_tra in cur_tra loop
     begin
   --Verifico si existe una Suspension a Pedido del cliente
     sotSPC:=0;
     l_verifSPC:=0;
     ld_fecrec:=null;
     ld_fecactual:=null;
     select Nvl(max(s.codsolot), 0)
       into sotSPC
       from solotpto p, solot s, inssrv i
      where s.codsolot = p.codsolot
        and p.codinssrv = i.codinssrv
        and s.tiptra in (3)
        and s.fecrec is not null
        and s.estsol in (12, 29)
        and s.codcli = c_tra.codcli
        and i.numero = c_tra.nomabr;

     if sotSPC > 0 then
       --select TO_DATE(fecrec,'dd/mm/yy') into ld_fecrec REQ 114405
       select TRUNC(fecrec) into ld_fecrec
       from solot
       where codsolot=sotSPC;
       --select  TO_DATE(sysdate ,'dd/mm/yy') into ld_fecactual from dual; REQ 114405
       select  TRUNC(sysdate) into ld_fecactual from dummy_ope;
      else
     l_verifSPC:=1;
     end if;

      if ld_fecrec > ld_fecactual then
       l_verifSPC:=0;
      else
       l_verifSPC:=1;
      end if;

     if l_verifSPC =1 then
      --verifico si existe una SOT de Corte por Falta de Pago aún no ejecutada para la línea y el cliente
          estadoSot := 0;
          sotCFP := 0;

          select Nvl(max(codsolot), 0) into sotCFP
          from transacciones
          where transaccion in ('SUSPENSION'/*,'CORTE'*/) and codcli = c_tra.codcli and nomabr = c_tra.nomabr and tipo = 1 ;

          if(sotCFP > 0) then
            select Nvl(estsol, 0) into estadoSot
            from solot
            where codsolot = sotCFP ;
          end if;
--<7.0
/*   G.ORMENO. Modificación para que se valide si existe una baja previa
  antes de la gneración de una transacción de suspensión, corte o reconexión

        select count(codinssrv) into hay_sid_actual from INSSRV WHERE numero = c_tra.nomabr and codcli = c_tra.codcli and estinssrv not in (3,4);
        if hay_sid_actual > 0 then

            select max(codinssrv) into sid_actual from INSSRV WHERE numero = c_tra.nomabr and codcli = c_tra.codcli and estinssrv not in (3,4);

            SELECT COUNT(*) INTO sotBaja
            FROM SOLOT S, SOLOTPTO SP, INSSRV I
            WHERE I.NUMERO = c_tra.nomabr
            AND I.CODINSSRV = SP.CODINSSRV
            AND SP.CODSOLOT = S.CODSOLOT
            AND S.TIPTRA = 5
            AND S.CODCLI = c_tra.codcli
            AND S.ESTSOL IN (29,12)
            AND TRUNC(S.FECCOM) <= TRUNC(SYSDATE)
            and I.CODINSSRV = sid_actual;

         end if;*/
--7.0>
          if ( sotCFP > 0 ) and ( estadoSot = 11 ) then
            begin
             -- Se anula SOT CLC y se inserta observación
             update solot set estsol = 13, observacion = 'SOT anulada antes de entrar en ejecución, por activación de servicio por pago de deuda de cliente (proceso automático)' where codsolot = sotCFP ;
             -- Se registra LOG de cambio de estado
             insert into solotchgest (codsolot, tipo, estado, fecha, codusu) values (sotCFP,1,13,sysdate,user);
--             sotAnulada:= 'SOT '|| sotCLC || ' de Suspensión o corte por Falta de Pago, fue anulada' ;
--             l_flgenviar := 1;
             -- SE COLOCA EL NÚMERO DE LA SOT ANULADA EN EL REGISTRO DE LA TRANSACCIÓN DE RECONEXIÓN
             update transacciones set fecini = sysdate, codsolot = sotCFP where idtrans = c_tra.idtrans ;
             -- SE ENVÍA CORREO INFORMANDO SOBRE LA SOT ANULADA Y LA CONTINUIDAD DEL SERVICIO
--03/03/2008             p_envia_correo_c_attach('Reconexion CLC - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi')||' ANULACIÓN DE SOT '||sotCFP||' (CFP) POR PAGO DE DEUDA','gustavo.ormeno@claro.com.pe','Reconexiones CFP - Telefonia Fija - Anulación de SOT '|| sotCFP || 'por pago de deuda, ' ||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
--03/03/2008             p_envia_correo_c_attach('Reconexion CLC - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi')||' ANULACIÓN DE SOT '||sotCFP||' (CFP) POR PAGO DE DEUDA','DL-PE-GestoresdeCreditosyCobranzas@claro.com.pe','Reconexiones CFP - Telefonia Fija - Anulación de SOT '|| sotCFP || 'por pago de deuda, ' ||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
             p_envia_correo_c_attach('Reconexion - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi')||' ANULACIÓN DE SOT '||sotCFP||' (CFP) POR PAGO DE DEUDA','DL-PE-CONMUTACION@claro.com.pe','Reconexiones CFP - Telefonia Fija - Anulación de SOT '|| sotCFP || 'por pago de deuda, ' ||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');

            end;
          else
    --<7.0
    --if ( sotBaja = 0 ) then
    if f_verifica_baja( c_tra.codcli, c_tra.nomabr) = 0 then
    --7.0>
                 begin

                    l_verifREc :=  F_VERIFICARECIBO(c_tra.idfac);

                    if (l_verifREc = 0) then --es analogica
                       select count(1) into sot_susp from transacciones where idtrans = c_tra.idtransori and codsolot is null;

                       if sot_susp > 0 then -- verifica si la SOT previa de suspensión fue generada, anula l atransaccion si no lo fue

                          update transacciones set esttrans = 'ANULADA' where idtrans = c_tra.idtransori;
                          update transacciones set fecini = sysdate, esttrans = 'ANULADA' where idtrans = c_tra.idtrans;

                       else
                        -- No se genera la SOT, se indica al usuario que genere la SOT manual.
                              update transacciones set esttrans = 'PENDIENTE' --fecini = sysdate, codsolot = l_codsolot
                              where idtrans = c_tra.idtrans ;
                              select nomcli into l_nomcli
                              from vtatabcli
                              where codcli = c_tra.codcli;

      --                        p_envia_correo_c_attach('Reconexiones - Telefonía fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno@claro.com.pe','No se generó la SOT de reconexión  por no encontrarse SIDs activos, Es necesario generar una SOT de reconexión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
--                              p_envia_correo_c_attach('Reconexiones - Telefonía fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-GestoresdeCreditosyCobranzas@claro.com.pe','No se generó la SOT de reconexión por no encontrarse SIDs activos, Es necesario generar una SOT de reconexión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
--                              p_envia_correo_c_attach('Reconexiones - Telefonía fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'augusto.carrillo@claro.com.pe','No se generó la SOT de reconexión por no encontrarse SIDs activos, Es necesario generar una SOT de reconexión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
                              --p_envia_correo_c_attach('Reconexiones - Telefonía fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'ysabel.marquez@claro.com.pe','No se generó la SOT de reconexión por no encontrarse SIDs activos, Es necesario generar una SOT de reconexión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
                              --p_envia_correo_c_attach('Reconexiones - Telefonía fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'juan.garcia@claro.com.pe','No se generó la SOT de reconexión por no encontrarse SIDs activos, Es necesario generar una SOT de reconexión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
                              p_envia_correo_c_attach('Reconexiones - Telefonía fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CortesyReconexiones@claro.com.pe','No se generó la SOT de reconexión por no encontrarse SIDs activos, Es necesario generar una SOT de reconexión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');--32.0

                       end if;
                    end if;

                    if (l_verifREc = 1) then --es analogica
                       p_insert_sot(c_tra.codcli,4,'0004',1,126,l_codsolot);
                      p_insert_solotpto_analogica(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac);
                      pq_solot.p_asig_wf(l_codsolot,50);
                      update transacciones set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
                      p_enviar_notificaciones(c_tra.idtrans,'RCNXTELFIJA.htm');
                      l_flgenviar := 1;
                      --update transacciones set fecfin = sysdate where idtrans = c_tra.idtransori ;
                    end if;
                    if(l_verifREc = 2) then--es pri
                      p_insert_sot(c_tra.codcli,4,'0004',1,126,l_codsolot);
                      p_insert_solotpto_pri(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac);
                      pq_solot.p_asig_wf(l_codsolot,50);
                      update transacciones set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
                      p_enviar_notificaciones(c_tra.idtrans,'RCNXTELFIJA.htm');
                      l_flgenviar := 1;
                      --update transacciones set fecfin = sysdate where idtrans = c_tra.idtransori ;
                    end if;

                     if(l_verifREc = 4) then--es TPI
                      p_insert_sot(c_tra.codcli,4,'0059',1,126,l_codsolot);
                      p_insert_solotpto_tpi(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac);
                      pq_solot.p_asig_wf(l_codsolot,50);
                      update transacciones set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
                      p_enviar_notificaciones(c_tra.idtrans,'RCNXTELFIJA.htm');
                      l_flgenviar := 1;
                      --update transacciones set fecfin = sysdate where idtrans = c_tra.idtransori ;
                    end if;

            /*        if(F_VERIFICARECIBO(c_tra.idfac) = 3) then--es pri y analogica
                    p_insert_sot(c_tra.codcli,3,1,13,l_codsolot);
                   -- p_insert_solotpto(l_codsolot,c_tra.codcli,c_tra.idfac);
                    end if;*/
                  end;
            else
                  update transacciones set fecini = sysdate, fecfin = sysdate, esttrans = 'DE BAJA' where idtrans = c_tra.idtrans;
            end if;
          end if;
        end if;  -- if l_verifSPC =1 then
     end;
      end loop;

     if l_flgenviar > 0 then
       hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'a');
       UTL_FILE.PUT_LINE(hArch,'</body>');
       UTL_FILE.PUT_LINE(hArch,'</html>');
       UTL_FILE.FCLOSE(hArch);
--       p_envia_correo_c_attach('Reconexion - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno@claro.com.pe','Reconexion - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
--03/03/2008       p_envia_correo_c_attach('Reconexion - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-GestoresdeCreditosyCobranzas@claro.com.pe','Reconexion - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
       p_envia_correo_c_attach('Reconexion - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CONMUTACION@claro.com.pe','Reconexion - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
      IF l_verifREc = 4 THEN
--03/03/2008         p_envia_correo_c_attach('Reconexion - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno@claro.com.pe','Reconexion - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
         p_envia_correo_c_attach('Reconexion - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-TelefoniaPublica@claro.com.pe','Reconexion - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
      END IF;

     end if;
  END;


/**********************************************************************
Genara las sots para reconexiones de telefonia FIJA Analogicas y Pris
**********************************************************************/

  PROCEDURE p_genera_reconexion_datos
  IS
  l_codsolot solot.codsolot%type;
  l_flgenviar number;
  cursor cur_tra is
  select *
  from transacciones
  where transaccion = 'ACTIVACION'
  and fecini is null
  and tipo in (5,6,7,8,9,11); -- Servicios de datos

/*  cRutaArchivo constant varchar2(100) := '/u03/oracle/PESGAPRD/UTL_FILE';
  ls_enter constant varchar2(4) := chr(10) || chr(13);*/
  hArch UTL_FILE.FILE_TYPE;
  vNomArch varchar2(100);

  -- variable para verificar si existe SOT de CLC aún no aprobada
  estadoSot number;
  sotCFP number;
  l_verifREc NUMBER;
  n_tipsrv tystipsrv.tipsrv%type;
  n_hayTipsr number;
  -- Variable para verificar si existe SOT de suspension a pedido del cliente
  sotSPC number;
  ld_fecrec solot.fecrec%type;
  l_verifSPC number;
  ld_fecactual date;

  BEGIN

  vNomArch := 'RCNXDATOS.htm';
  hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'w');
  l_flgenviar := 0;

  UTL_FILE.PUT_LINE(hArch,'<html>');
  UTL_FILE.PUT_LINE(hArch,'<head>');
  UTL_FILE.PUT_LINE(hArch,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
  UTL_FILE.PUT_LINE(hArch,'<title>Reconexion por falta de pago - Datos</title>');
  UTL_FILE.PUT_LINE(hArch,'</head>');
  UTL_FILE.PUT_LINE(hArch,'<body>');
  UTL_FILE.PUT_LINE(hArch,'<p><font color="#3366FF">RECONEXION POR FALTA DE PAGO: - '||to_char(sysdate,'dd/mm/yyyy hh24:mi') ||  '</font> </p>');

  UTL_FILE.FCLOSE(hArch);

   for c_tra in cur_tra loop
     begin
     --Verifico si existe una Suspension a Pedido del cliente
     sotSPC:=0;
     l_verifSPC:=0;
     ld_fecrec:=null;
     ld_fecactual:=null;
     select Nvl(max(s.codsolot), 0)
       into sotSPC
       from solotpto p, solot s, inssrv i
      where s.codsolot = p.codsolot
        and p.codinssrv = i.codinssrv
        and s.tiptra in (3)
        and s.fecrec is not null
        and s.estsol in (12, 29)
        and s.codcli = c_tra.codcli
        and i.numero = c_tra.nomabr;

     if sotSPC > 0 then
       --select TO_DATE(fecrec,'dd/mm/yy') into ld_fecrec REQ 114405
       select TRUNC(fecrec) into ld_fecrec
       from solot
       where codsolot=sotSPC;
       --select  TO_DATE(sysdate ,'dd/mm/yy') into ld_fecactual from dual; req 114405
       select  TRUNC(sysdate) into ld_fecactual from dummy_ope;
      else
     l_verifSPC:=1;
     end if;

      if ld_fecrec > ld_fecactual then
       l_verifSPC:=0;
      else
       l_verifSPC:=1;
      end if;

      if l_verifSPC=1 then
      --verifico si existe una SOT de Corte por Falta de Pago aún no ejecutada para la línea y el cliente
          estadoSot := 0;
          sotCFP := 0;

          select Nvl(max(codsolot), 0) into sotCFP
          from transacciones
          where transaccion in ('SUSPENSION'/*,'CORTE'*/) and codcli = c_tra.codcli and nomabr = c_tra.nomabr and tipo = 1 ;

          if(sotCFP > 0) then
            select Nvl(estsol, 0) into estadoSot
            from solot
            where codsolot = sotCFP ;
          end if;

          if ( sotCFP > 0 ) and ( estadoSot = 11 ) then
            begin
             -- Se anula SOT CLC y se inserta observación
             update solot set estsol = 13, observacion = 'SOT anulada antes de entrar en ejecución, por activación de servicio por pago de deuda de cliente (proceso automático)' where codsolot = sotCFP ;
             -- Se registra LOG de cambio de estado
             insert into solotchgest (codsolot, tipo, estado, fecha, codusu) values (sotCFP,1,13,sysdate,user);
--             sotAnulada:= 'SOT '|| sotCLC || ' de Suspensión o corte por Falta de Pago, fue anulada' ;
--             l_flgenviar := 1;
             -- SE COLOCA EL NÚMERO DE LA SOT ANULADA EN EL REGISTRO DE LA TRANSACCIÓN DE RECONEXIÓN
             update transacciones set fecini = sysdate, codsolot = sotCFP where idtrans = c_tra.idtrans ;
             -- SE ENVÍA CORREO INFORMANDO SOBRE LA SOT ANULADA Y LA CONTINUIDAD DEL SERVICIO
--03/03/2008             p_envia_correo_c_attach('Reconexion CLC - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi')||' ANULACIÓN DE SOT '||sotCFP||' (CFP) POR PAGO DE DEUDA','gustavo.ormeno@claro.com.pe','Reconexiones CFP - Telefonia Fija - Anulación de SOT '|| sotCFP || 'por pago de deuda, ' ||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
--03/03/2008             p_envia_correo_c_attach('Reconexion CLC - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi')||' ANULACIÓN DE SOT '||sotCFP||' (CFP) POR PAGO DE DEUDA','DL-PE-GestoresdeCreditosyCobranzas@claro.com.pe','Reconexiones CFP - Telefonia Fija - Anulación de SOT '|| sotCFP || 'por pago de deuda, ' ||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
             p_envia_correo_c_attach('Reconexion - Datos - '||to_char(sysdate,'dd/mm/yyyy hh24:mi')||' ANULACIÓN DE SOT '||sotCFP||' (CFP) POR PAGO DE DEUDA','DL-PE-CONMUTACION@claro.com.pe','Reconexiones CFP - Datos - Anulación de SOT '|| sotCFP || 'por pago de deuda, ' ||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');

            end;
          else
          if f_verifica_baja( c_tra.codcli, c_tra.nomabr) = 0 then--<7.0>
            begin
              -- obtengo el tipo de servicio para la SOT
              select count(tipsrv) into n_hayTipsr
                from solot
               where codsolot in
                     (select max(s.codsolot)
                        from inssrv i, cxctabfac c, solot s, solotpto sp
                       where i.numero = c.nomabr
                         and c.idfac = c_tra.idfac
                         and sp.codinssrv = i.codinssrv
                         and s.codsolot = sp.codsolot
                         and s.tiptra in (1,368)
                      /* and s.estsol = 12*/
                      );
               if (n_hayTipsr > 0) then
                    -- obtengo el tipo de servicio para la SOT
                    select tipsrv into n_tipsrv
                      from solot
                     where codsolot in
                           (select max(s.codsolot)
                              from inssrv i, cxctabfac c, solot s, solotpto sp
                             where i.numero = c.nomabr
                               and c.idfac = c_tra.idfac
                               and sp.codinssrv = i.codinssrv
                               and s.codsolot = sp.codsolot
                               and s.tiptra in (1,368)
                            /* and s.estsol = 12*/
                            );
                end if;

            --Ini 28.0
            FOR C_SOT IN ( select distinct i.tipsrv, i.codsuc
                            from cr, instxproducto ip, instanciaservicio isr, bilfac b, cxctabfac c, inssrv i
                              where c.idfac = c_tra.idfac and
                                  b.idfaccxc = c.idfac and
                                  cr.idinstprod = ip.idinstprod and
                                  ip.idcod = isr.idinstserv and
                                  ip.codcli = isr.codcli and
                                  cr.idbilfac = b.idbilfac and
                                  isr.codinssrv = i.codinssrv and
                                  isr.codcli = c_tra.codcli and
                                  i.estinssrv not in (3,4))  -- Para que no se considere servicios de baja o sin activar
            --Fin 28.0
            LOOP

                p_insert_sot(c_tra.codcli,4,C_SOT.tipsrv,1,126,l_codsolot);
                p_insert_solotpto_datos(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac,C_SOT.TIPSRV,C_SOT.CODSUC);
                /*pq_solot.p_asig_wf(l_codsolot,61);*/ --<25.0> Se comenta, ya que el WF que se va a asignar depende de la configuración
                PQ_SOLOT.P_EJECUTAR_SOLOT(l_codsolot); --<25.0>


            END LOOP;

                  update transacciones set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
                  p_enviar_notificaciones(c_tra.idtrans,'RCNXDATOS.htm');
                  l_flgenviar := 1;

            end;
          else--<7.0>
                update transacciones set fecini = sysdate, fecfin = sysdate, esttrans = 'DE BAJA' where idtrans = c_tra.idtrans;
          end if;--<7.0>
          end if;
        end if;  -- if l_verifSPC=1
     end;
      end loop;

     if l_flgenviar > 0 then
       hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'a');
       UTL_FILE.PUT_LINE(hArch,'</body>');
       UTL_FILE.PUT_LINE(hArch,'</html>');
       UTL_FILE.FCLOSE(hArch);
--       p_envia_correo_c_attach('Reconexion - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno@claro.com.pe','Reconexion - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
--03/03/2008       p_envia_correo_c_attach('Reconexion - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-GestoresdeCreditosyCobranzas@claro.com.pe','Reconexion - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
       p_envia_correo_c_attach('Reconexion - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CONMUTACION@claro.com.pe','Reconexion - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');

     end if;
  END;



/**********************************************************************
Genara las sots para reconexiones de telefonia paquetes xplora
**********************************************************************/

 PROCEDURE p_genera_reconexion_xplora
  IS
  l_codsolot solot.codsolot%type;
  l_flgenviar number;
  l_numpuntos number; --variable util para ubicar la instancia de paquete
  l_inspaq vtadetptoenl.idinsxpaq%type;
  l_nomcli vtatabcli.nomcli%type;
  l_estTransOri varchar2(100);
  l_sotTransOri number(8);
  l_transOri CHAR(10);
  l_cant_puntos number;
  l_cant_ptos_locut number;

  cursor cur_tra is
  select *
  from transacciones
  where transaccion = 'ACTIVACION'
  and fecini is null
  and tipo = 2
  AND (ESTTRANS IS NULL
  OR ESTTRANS <> 'PENDIENTE') -- PARA QUE NO ENVÌE NUEVAMENTE EL AVISO DE SOT NO CREADA
  and 1 = 2;--34.0

  cursor cur_inspaq(c_idfac cxctabfac.idfac%type) is
  select distinct vs.idinsxpaq
  from  bilfac b, cr, instanciaservicio sb,inssrv so, vtadetptoenl vs
  where b.idfaccxc = c_idfac and
        b.idbilfac = cr.idbilfac and
        cr.nivel = 2 and
        cr.idcod = sb.idinstserv and
        sb.codinssrv = so.codinssrv and
        so.numslc = vs.numslc
        and so.estinssrv NOT IN (3,4)    -- solo los servicios suspendisos pues existe una suspension o corte previo
   union
   select distinct vs.idinsxpaq
   from  bilfac b, instanciaservicio sb,inssrv so, vtadetptoenl vs
   where b.idfaccxc = c_idfac and
          b.idisprincipal = sb.idinstserv and
          sb.codinssrv = so.codinssrv and
          so.numslc = vs.numslc
          and so.estinssrv NOT IN (3,4)  ;  -- solo los servicios suspendisos pues existe una suspension o corte previo


/*  cRutaArchivo constant varchar2(100) := '/u03/oracle/PESGAPRD/UTL_FILE';
  ls_enter constant varchar2(4) := chr(10) || chr(13);*/
  hArch UTL_FILE.FILE_TYPE;
  vNomArch varchar2(100);

  -- variable para verificar si existe SOT de corte Explora aún no ejecutada
  estadoSot number;
  sotCXPL number;
  -- Variable para verificar si existe SOT de suspension a pedido del cliente
  sotSPC number;
  ld_fecrec solot.fecrec%type;
  l_verifSPC number;
  ld_fecactual date;

  BEGIN

  vNomArch := 'RCNXPLORA.htm';
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
   --Verifico si existe una Suspension a Pedido del cliente
     sotSPC:=0;
     l_verifSPC:=0;
     ld_fecrec:=null;
     ld_fecactual:=null;
     select Nvl(max(s.codsolot), 0)
       into sotSPC
       from solotpto p, solot s, inssrv i
      where s.codsolot = p.codsolot
        and p.codinssrv = i.codinssrv
        and s.tiptra in (3)
        and s.fecrec is not null
        and s.estsol in (12, 29)
        and s.codcli = c_tra.codcli
        and i.numero = c_tra.nomabr;

     if sotSPC > 0 then
       --select TO_DATE(fecrec,'dd/mm/yy') into ld_fecrec REQ_114405
       select TRUNC(fecrec) into ld_fecrec
       from solot
       where codsolot=sotSPC;
       --select  TO_DATE(sysdate ,'dd/mm/yy') into ld_fecactual REQ 114405
       select  TRUNC(sysdate) into ld_fecactual from dummy_ope;
      else
     l_verifSPC:=1;
     end if;

      if ld_fecrec > ld_fecactual then
       l_verifSPC:=0;
      else
       l_verifSPC:=1;
      end if;

     if l_verifSPC=1 then
         l_inspaq := 0;
        --verifico si existe una SOT de corte Explora para la línea y el cliente
          estadoSot := 0;
          sotCXPL := 0;

          select Nvl(max(codsolot), 0) into sotCXPL
          from transacciones
          where transaccion in ('SUSPENSION'/*,'CORTE'*/) and codcli = c_tra.codcli and nomabr = c_tra.nomabr and tipo = 2 ;

          if(sotCXPL > 0) then
            select Nvl(estsol, 0) into estadoSot
            from solot
            where codsolot = sotCXPL ;
          end if;

          if ( sotCXPL > 0 ) and ( estadoSot = 11 ) then
            begin
             -- Se anula SOT CLC y se inserta observación
             update solot set estsol = 13, observacion = 'SOT anulada antes de entrar en ejecución, por activación de servicio por pago de deuda de cliente (proceso automático)' where codsolot = sotCXPL ;
             -- Se registra LOG de cambio de estado
             insert into solotchgest (codsolot, tipo, estado, fecha, codusu) values (sotCXPL,1,13,sysdate,user);
             -- SE COLOCA EL NÚMERO DE LA SOT ANULADA EN EL REGISTRO DE LA TRANSACCIÓN DE RECONEXIÓN
             update transacciones set fecini = sysdate, codsolot = sotCXPL where idtrans = c_tra.idtrans ;
             -- SE ENVÍA CORREO INFORMANDO SOBRE LA SOT ANULADA Y LA CONTINUIDAD DEL SERVICIO
--03/03/2008             p_envia_correo_c_attach('Reconexion Xplora - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi')||' ANULACIÓN DE SOT '||sotCXPL||' (CORTE XPLORA FALTA DE PAGO) POR PAGO DE DEUDA','gustavo.ormeno@claro.com.pe','Reconexiones CFP - Xplora - Anulación de SOT '|| sotCXPL || 'por pago de deuda, ' ||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
--03/03/2008             p_envia_correo_c_attach('Reconexion Xplora - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi')||' ANULACIÓN DE SOT '||sotCXPL||' (CORTE XPLORA FALTA DE PAGO) POR PAGO DE DEUDA','DL-PE-GestoresdeCreditosyCobranzas@claro.com.pe','Reconexiones CFP - Xplora - Anulación de SOT '|| sotCXPL || 'por pago de deuda, ' ||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');

            end;
          else
          if f_verifica_baja( c_tra.codcli, c_tra.nomabr) = 0 then--<7.0>
            begin
                 select codsolot, esttrans, transaccion into l_sotTransOri, l_estTransOri, l_transOri
                 from transacciones
                 where idtrans = c_tra.idtransori;

                 IF (l_estTransOri is not null and l_estTransOri = 'RECONECTADA' and (l_sotTransOri is  null) and l_transOri = 'SUSPENSION') THEN
                       update transacciones set fecini = sysdate, esttrans = 'CANCELADA' where idtrans = c_tra.idtrans ;
                 ELSE
                       for c_inspaq in cur_inspaq(c_tra.idfac) loop
                          begin
                            l_inspaq := c_inspaq.idinsxpaq;
                          end;
                        end loop;

                        if l_inspaq > 0 and f_cuenta_ptos_paq( c_tra.codcli, l_inspaq) > 0 then

                           p_insert_sot(c_tra.codcli,4,'0058',1,892,l_codsolot);
                           p_insert_solotpto_paquete(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac,l_inspaq);

                          -- Inicio Asignar WF de telefonia a servicios de locutorio GORMENO 05/02/2008

                          select count(1) INTO l_cant_puntos
                          from inssrv
                          where codinssrv in (select codinssrv from solotpto where codsolot = l_codsolot );

                          select count(1) into l_cant_ptos_locut
                          from inssrv
                          where codinssrv in (select codinssrv from solotpto where codsolot = l_codsolot ) AND CODSRV = 4385; --servicio locutorio

                          if l_cant_puntos = l_cant_ptos_locut then
                                pq_solot.p_asig_wf(l_codsolot,50); -- es locutorio
                          else
                               pq_solot.p_asig_wf(l_codsolot,713);
                          end if;

                          -- Fin Asignar WF de telefonia a servicios de locutorio GORMENO

                            update transacciones set fecini = sysdate, codsolot = l_codsolot, esttrans = 'GENERADA'
                            where idtrans = c_tra.idtrans ;
                            p_enviar_notificaciones(c_tra.idtrans,'RCNXPLORA.htm');
                            l_flgenviar := 1;
                        else
                            update transacciones set esttrans = 'PENDIENTE' --fecini = sysdate, codsolot = l_codsolot
                            where idtrans = c_tra.idtrans ;
                            select nomcli into l_nomcli
                            from vtatabcli
                            where codcli = c_tra.codcli;

--                            p_envia_correo_c_attach('Reconexiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno@claro.com.pe','No se genero la SOT de reconexión por no encontrarse SIDs activos, Es necesario generar una SOT de reconexión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
--                            p_envia_correo_c_attach('Reconexiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-GestoresdeCreditosyCobranzas@claro.com.pe','No se genero la SOT de reconexión por no encontrarse SIDs activos, Es necesario generar una SOT de reconexión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
--                            p_envia_correo_c_attach('Reconexiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'augusto.carrillo@claro.com.pe','No se genero la SOT de reconexión por no encontrarse SIDs activos, Es necesario generar una SOT de reconexión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
                            --p_envia_correo_c_attach('Reconexiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'ysabel.marquez@claro.com.pe','No se genero la SOT de reconexión por no encontrarse SIDs activos, Es necesario generar una SOT de reconexión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
                            --p_envia_correo_c_attach('Reconexiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'juan.garcia@claro.com.pe','No se genero la SOT de reconexión por no encontrarse SIDs activos, Es necesario generar una SOT de reconexión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
                            p_envia_correo_c_attach('Reconexiones - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CortesyReconexiones@claro.com.pe','No se genero la SOT de reconexión por no encontrarse SIDs activos, Es necesario generar una SOT de reconexión manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');--32.0

                        end if;
                  END IF;
            end  ;
          else--<7.0>
                update transacciones set fecini = sysdate, fecfin = sysdate, esttrans = 'DE BAJA' where idtrans = c_tra.idtrans;
          end if;--<7.0>
          end if;
        end if; -- if l_verifSPC=1
     end;
      end loop;

     if l_flgenviar > 0 then
       hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'a');
       UTL_FILE.PUT_LINE(hArch,'</body>');
       UTL_FILE.PUT_LINE(hArch,'</html>');
       UTL_FILE.FCLOSE(hArch);

--         p_envia_correo_c_attach('Reconexion - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno@claro.com.pe','Reconexion - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
--03/03/2008         p_envia_correo_c_attach('Reconexion - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-GestoresdeCreditosyCobranzas@claro.com.pe','Reconexion - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
         p_envia_correo_c_attach('Reconexion - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CONMUTACION@claro.com.pe','Reconexion - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
     end if;
  END;


/**********************************************************************
Funcion que verifica si un recibo aun esta como pendiente de cancelar
**********************************************************************/

  FUNCTION f_verdocpendiente(v_idfac in transacciones.idfac%type) return number
  IS
  l_pendiente number;
  l_estfac cxctabfac.estfac%type;

  BEGIN
  l_pendiente := 1;

  select c.estfac
  into l_estfac
  from cxctabfac c
  where c.idfac = v_idfac;

  if l_estfac in ('01','06','11','05') then  --documento cancelado o anulado
     begin
          l_pendiente := 0;
     end;
  end if;



     RETURN l_pendiente;

  END;


/**********************************************************************
Funcion que verifica si un recibo contiene lineas analogicas, pri o ambas
**********************************************************************/

  FUNCTION f_verificarecibo(v_idfac in transacciones.idfac%type) return number
  IS
  l_tipo number;
  l_analogica number;
  l_pri number;
  l_tpi number;

  BEGIN
  l_tipo := 0;
  l_analogica := 0;
  l_pri := 0;
  l_tpi := 0;

  select count(1)
  into l_analogica
  from cr, instxproducto ip, instanciaservicio isr, bilfac b, numtel n, cxctabfac c
  where c.idfac = v_idfac and
      b.idfaccxc = c.idfac and
      cr.idinstprod = ip.idinstprod and
      ip.idcod = isr.idinstserv and
      ip.codcli = isr.codcli and
      ip.nivel = 2 and
      cr.idbilfac = b.idbilfac and
      (isr.idproductoprincipal = 503 OR isr.idproductoprincipal IN (688,689,721,4,725,8)) and
      isr.nomabr = n.numero;

  select count(1)
  into l_pri
  from cxctabfac c, bilfac b, cr
  where c.idfac = v_idfac and
      c.idfac = b.idfaccxc and
      b.idbilfac = cr.idbilfac and
      cr.idproducto = 504;

    SELECT count(1) INTO l_tpi
    FROM CXCTABFAC
    WHERE TIPDOC = 'HRE'
    AND idfac = v_idfac;

    if (( l_analogica > 0 ) and (l_pri <1))
    then l_tipo := 1 ;
    end if;

    if (( l_analogica < 1 ) and (l_pri > 0))
    then l_tipo := 2 ;
    end if;

    if (( l_analogica > 0 ) and (l_pri > 0))
    then l_tipo := 3 ;
    end if;

    if ( l_tpi > 0 )
    then l_tipo := 4 ; -- es un servicio TPI
    end if;

     RETURN l_tipo;

  END;

/**********************************************************************
Funcion que verifica si un numero es analogico o pri
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

  select count(1)
  into l_analogica
  from numtel n,inssrv i, instanciaservicio sb, instxproducto pb
            where n.numero= v_numero and
            n.codinssrv = i.codinssrv and
            i.codinssrv = sb.codinssrv and
            i.codcli = sb.codcli and
            sb.idinstserv = pb.idcod and
            pb.idproducto in (503, 764) and
            pb.fecfin is null;

  SELECT count(1)
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



    if (( l_analogica > 0 ) and (l_pri <1))
    then l_tipo := 1 ;--es analogica
    end if;

    if (( l_analogica < 1 ) and (l_pri > 0))
    then l_tipo := 2 ;--es pri
    end if;

    if (( l_analogica > 0 ) and (l_pri > 0))
    then l_tipo := 3 ;
    end if;

     RETURN l_tipo;

  END;
/**********************************************************************
Insertar la cabecera del recibo como punto de la sot
**********************************************************************/

  PROCEDURE p_insert_solotpto_cab(v_idtrans transacciones.idtrans%type,
                                        v_codsolot solot.codsolot%type,
                                        v_codcli solot.codcli%type,
                                        v_idfac cxctabfac.idfac%type) IS
  cursor cur_analogicas is
  select distinct i.codsrv codsrvnue,i.bw bwnue,i.numero,i.codinssrv,i.cid,i.descripcion,i.direccion,2 tipo, 1 estado, 1 visible, i.codubi,1 flgmt
  from cxctabfac c,bilfac b, instanciaservicio isr, instxproducto ip,   numtel n,  inssrv i
  where c.idfac = v_idfac and
        b.idfaccxc = c.idfac and
        b.idisprincipal = isr.idinstserv and
        isr.idinstserv = ip.idcod and
        ip.idproducto = 503 and
        ip.nivel = 2 and
        ip.codcli = isr.codcli and
        isr.nomabr = n.numero and
        isr.codinssrv = i.codinssrv and
        isr.codcli = v_codcli;
  l_cont number;

  BEGIN
  l_cont := 1;
     for c_ana in cur_analogicas loop
        begin
         insert into solotpto(codsolot, punto,codsrvnue,bwnue,codinssrv,cid,descripcion,direccion,tipo,estado,visible,codubi,flgmt)
        values(v_codsolot,l_cont,c_ana.codsrvnue,c_ana.bwnue,c_ana.codinssrv,c_ana.cid,c_ana.descripcion,c_ana.direccion,c_ana.tipo,c_ana.estado,c_ana.visible,c_ana.codubi,c_ana.flgmt);
       --cancela CLC
      update operacion.dettransacciones d set estado = 0
      where d.nomabr =c_ana.numero and
            d.identificadorclc is not null and
            d.estado in (3,4);

        insert into dettransacciones(idtrans,nomabr,codinssrv)
        values(v_idtrans,c_ana.numero,c_ana.codinssrv);
        l_cont := l_cont + 1;

        end;
      end loop;
  END;
/**********************************************************************
Insertar los puntos de lineas analogicas a la sot
**********************************************************************/

  PROCEDURE p_insert_solotpto_analogica(v_idtrans transacciones.idtrans%type,
                                        v_codsolot solot.codsolot%type,
                                        v_codcli solot.codcli%type,
                                        v_idfac cxctabfac.idfac%type) IS
  cursor cur_analogicas is
  select distinct i.codsrv codsrvnue,i.bw bwnue,i.numero,i.codinssrv,i.cid,i.descripcion,i.direccion,2 tipo, 1 estado, 1 visible, i.codubi,1 flgmt
  from cr, instxproducto ip, instanciaservicio isr, bilfac b, numtel n, cxctabfac c, inssrv i
  where c.idfac = v_idfac and
      (isr.idproductoprincipal = 503 OR isr.idproductoprincipal IN (688,689,721,4,725,8)) and
      ip.nivel = 2 and
      b.idfaccxc = c.idfac and
      cr.idinstprod = ip.idinstprod and
      ip.idcod = isr.idinstserv and
      ip.codcli = isr.codcli and
      cr.idbilfac = b.idbilfac and
      isr.nomabr = n.numero and
      isr.codinssrv = i.codinssrv and
      isr.codcli = v_codcli;
  l_cont number;

  BEGIN
  l_cont := 1;
     for c_ana in cur_analogicas loop
        begin
         insert into solotpto(codsolot, punto,codsrvnue,bwnue,codinssrv,cid,descripcion,direccion,tipo,estado,visible,codubi,flgmt)
        values(v_codsolot,l_cont,c_ana.codsrvnue,c_ana.bwnue,c_ana.codinssrv,c_ana.cid,c_ana.descripcion,c_ana.direccion,c_ana.tipo,c_ana.estado,c_ana.visible,c_ana.codubi,c_ana.flgmt);

        --cancela CLC
        update operacion.dettransacciones d set estado = 0
        where d.nomabr =c_ana.numero and
            d.identificadorclc is not null and
            d.estado in (3,4);


        insert into dettransacciones(idtrans,nomabr,codinssrv)
        values(v_idtrans,c_ana.numero,c_ana.codinssrv);
        l_cont := l_cont + 1;
        end;
      end loop;
  END;

/**********************************************************************
Insertar los puntos de servicios de datos
**********************************************************************/

  PROCEDURE p_insert_solotpto_datos(v_idtrans transacciones.idtrans%type,
                                        v_codsolot solot.codsolot%type,
                                        v_codcli solot.codcli%type,
                                        v_idfac cxctabfac.idfac%type,
                                        V_TIPSRV INSSRV.TIPSRV%TYPE,
                                        V_CODSUC INSSRV.CODSUC%TYPE) IS
  cursor cur_analogicas is
  select distinct i.codsrv codsrvnue,i.bw bwnue,i.numero,i.codinssrv,i.cid,i.descripcion,i.direccion,2 tipo, 1 estado, 1 visible, i.codubi,1 flgmt
  from cr, instxproducto ip, instanciaservicio isr, bilfac b, cxctabfac c, inssrv i
  where c.idfac = v_idfac and
      b.idfaccxc = c.idfac and
      cr.idinstprod = ip.idinstprod and
      ip.idcod = isr.idinstserv and
      ip.codcli = isr.codcli and
      cr.idbilfac = b.idbilfac and
      isr.codinssrv = i.codinssrv and
      isr.codcli = v_codcli
      AND i.TIPSRV = V_TIPSRV
      AND i.CODSUC = V_CODSUC;

  l_cont number;

  BEGIN
  l_cont := 1;
     for c_ana in cur_analogicas loop
        begin
         insert into solotpto(codsolot, punto,codsrvnue,bwnue,codinssrv,cid,descripcion,direccion,tipo,estado,visible,codubi,flgmt)
        values(v_codsolot,l_cont,c_ana.codsrvnue,c_ana.bwnue,c_ana.codinssrv,c_ana.cid,c_ana.descripcion,c_ana.direccion,c_ana.tipo,c_ana.estado,c_ana.visible,c_ana.codubi,c_ana.flgmt);

        --cancela CLC
        update operacion.dettransacciones d set estado = 0
        where d.nomabr =c_ana.numero and
            d.identificadorclc is not null and
            d.estado in (3,4);


        insert into dettransacciones(idtrans,nomabr,codinssrv)
        values(v_idtrans,c_ana.numero,c_ana.codinssrv);
        l_cont := l_cont + 1;
        end;
      end loop;
  END;


/**********************************************************************
Insertar los puntos de lineas PRI a la sot
**********************************************************************/

  PROCEDURE p_insert_solotpto_pri(v_idtrans transacciones.idtrans%type,
                                  v_codsolot solot.codsolot%type,
                                  v_codcli solot.codcli%type,
                                  v_idfac cxctabfac.idfac%type) IS
  cursor cur_pri is
  select  distinct i.codsrv codsrvnue,i.bw bwnue,i.numero,i.codinssrv,i.cid,i.descripcion,i.direccion,2 tipo, 1 estado, 1 visible, i.codubi,1 flgmt
  from instanciaservicio isb, inssrv i
  where ispadre in (
                  select ispadre
                  from cxctabfac c, bilfac b, cr, instxproducto ip, instanciaservicio isr
                  where c.idfac = v_idfac and
                        c.idfac = b.idfaccxc and
                        b.idbilfac = cr.idbilfac and
                        cr.idproducto = 504 and
                        cr.idinstprod = ip.idinstprod and
                        ip.idcod = isr.idinstserv) and
        i.codinssrv = isb.codinssrv and
        isb.codcli =  v_codcli
--<7.0
  UNION
  select distinct i.codsrv codsrvnue,i.bw bwnue,i.numero,i.codinssrv,i.cid,i.descripcion,i.direccion,2 tipo, 1 estado, 1 visible, i.codubi,1 flgmt
  from instanciaservicio isb, inssrv i
  where ispadre in (
                  select ispadre
                  from cxctabfac c, bilfac b, cr, instxproducto ip, instanciaservicio isr
                  where c.idfac = v_idfac and
                        c.idfac = b.idfaccxc and
                        b.idbilfac = cr.idbilfac and
                        cr.idproducto = 504 and
                        cr.idinstprod = ip.idinstprodant and
                        ip.idcod = isr.idinstserv) and
        i.codinssrv = isb.codinssrv and
        isb.codcli =  v_codcli;
--7.0>
  l_cont number;

  BEGIN
  l_cont := 1;
     for c_pri in cur_pri loop
        begin
         insert into solotpto(codsolot, punto,codsrvnue,bwnue,codinssrv,cid,descripcion,direccion,tipo,estado,visible,codubi,flgmt)
        values(v_codsolot,l_cont,c_pri.codsrvnue,c_pri.bwnue,c_pri.codinssrv,c_pri.cid,c_pri.descripcion,c_pri.direccion,c_pri.tipo,c_pri.estado,c_pri.visible,c_pri.codubi,c_pri.flgmt);

                --cancela CLC
        update operacion.dettransacciones d set estado = 0
        where d.nomabr = c_pri.numero and
            d.identificadorclc is not null and
            d.estado in (3,4);


        insert into dettransacciones(idtrans,nomabr,codinssrv)
        values(v_idtrans,c_pri.numero,c_pri.codinssrv);
        l_cont := l_cont + 1;
        end;
      end loop;
  END;

/**********************************************************************
Insertar el detalle de un paquete
**********************************************************************/

  PROCEDURE p_insert_solotpto_paquete(v_idtrans transacciones.idtrans%type,
                                        v_codsolot solot.codsolot%type,
                                        v_codcli solot.codcli%type,
                                        v_idfac cxctabfac.idfac%type,
                                        v_idpaq number) IS
  cursor cur_servicios is
  select so.codsrv codsrvnue,so.numero,so.bw bwnue,so.codinssrv,so.cid,so.descripcion,so.direccion,2 tipo,1 estado,1 visible, so.codubi, 1 flgmt
  from vtadetptoenl vs, inssrv so
  where vs.idinsxpaq = v_idpaq and
        vs.numslc = so.numslc and
        vs.numpto = so.numpto and
       -- so.estinssrv = 1 and --solo activas
        so.codcli = v_codcli
        and so.estinssrv not in (3,4); -- condición para que no se consideren servicios cancelados o sin activar

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
        values(v_codsolot,l_cont,c_servicios.codsrvnue,c_servicios.bwnue,c_servicios.codinssrv,c_servicios.cid,c_servicios.descripcion,c_servicios.direccion,c_servicios.tipo,c_servicios.estado,c_servicios.visible,c_servicios.codubi,c_servicios.flgmt);

        insert into dettransacciones(idtrans,nomabr,codinssrv)
        values(v_idtrans,c_servicios.numero,c_servicios.codinssrv);
        l_cont := l_cont + 1;

        end;
      end loop;
  END;


/**********************************************************************
Insertar los puntos de lineas TPI a la sot
**********************************************************************/

  PROCEDURE p_insert_solotpto_tpi(v_idtrans transacciones.idtrans%type,
                                        v_codsolot solot.codsolot%type,
                                        v_codcli solot.codcli%type,
                                        v_idfac cxctabfac.idfac%type) IS
  cursor cur_analogicas is
  select  i.codsrv codsrvnue,i.bw bwnue,i.numero,i.codinssrv,i.cid,i.descripcion,i.direccion,2 tipo, 1 estado, 1 visible, i.codubi,1 flgmt
  from inssrv i
  where codinssrv in
    (select distinct codinssrv
      from insprd
     where pid in (select pid
                     from instxproducto
                    where (codcli, grupo) in
                          (select codcli, grupo
                             from bilfac
                            where idfaccxc = v_idfac))
     )
    ;

  l_cont number;

  BEGIN
  l_cont := 1;
     for c_ana in cur_analogicas loop
        begin
         insert into solotpto(codsolot, punto,codsrvnue,bwnue,codinssrv,cid,descripcion,direccion,tipo,estado,visible,codubi,flgmt)
        values(v_codsolot,l_cont,c_ana.codsrvnue,c_ana.bwnue,c_ana.codinssrv,c_ana.cid,c_ana.descripcion,c_ana.direccion,c_ana.tipo,c_ana.estado,c_ana.visible,c_ana.codubi,c_ana.flgmt);

        --cancela CLC
        update operacion.dettransacciones d set estado = 0
        where d.nomabr =c_ana.numero and
            d.identificadorclc is not null and
            d.estado in (3,4);


        insert into dettransacciones(idtrans,nomabr,codinssrv)
        values(v_idtrans,c_ana.numero,c_ana.codinssrv);
        l_cont := l_cont + 1;
        end;
      end loop;
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
  values (v_codsolot, v_codcli, 11, v_tiptra,v_tipsrv,v_grado,v_motivo,119);-- 'S', sysdate, sysdate, sysdate, sysdate);

  END;

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
         from dettransacciones t,
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
  from transacciones t, cxctabfac c, vtatabcli v
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
         from dettransacciones t,
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
  from transacciones t,  vtatabcli v
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

/***********************************************************************
Inserta las transacciones previas
**********************************************************************  */

  PROCEDURE p_cargapretransaccion
  IS

/*------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.PQ_CORTE_SERVICIO.P_CARGAPRETRANSACCION';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='283-I';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
--------------------------------------------------*/


  BEGIN

  dbms_utility.exec_ddl_statement('truncate table pretransacciones');



  /*"transacciones tipo 1 para telefonia fija"*/
  insert into pretransacciones(nomabr,sldact,codcli,nomcli,categoria,idfac, numdoc, fecemi, fecven,idcategoria, tipo )
   select distinct a.nomabr nomabr,a.sldact,a.codcli,a.nomcli,c.dscsegmark categoria,a.idfac,a.sersut||'-'||a.numsut numdoc, a.fecemi, a.fecven, c.codsegmark , decode(a.tipdoc,'REC',1,3)
  from cxctabfac a,collector.v_plannumeracion b, VTATABSEGMARK c, vtatabcli v/*, transacciones t*/,numtel n, inssrv i, bilfac bi
  where a.sersut in ('0050','0080') -- 39.0 ('050','080')
  and a.numsut is not null
  and a.tipdoc in (/*'REC',*/'HRE')--34.0
  and a.sldact>(select to_number(valorparametro) from ope_parametros_globales_aux where nombre_parametro = 'cortesyreconexiones.montominimosuspension2')--35.0
  and a.estfacrec=0
  and a.flgcarcomp=0 -- se incluye condición para que no se envíen a suspensión servicios con refinanciamiento 05/09/2008
  and a.estfac not in ('01','06','11','05')
  and a.nomabr not like 'CI%'
  and a.nomabr not like 'SI%'
  and a.nomabr not like '%-%'
  and a.nomabr between b.rangoinicio and b.rangofin
  and b.idcarrier=5
  and b.estadoplan in (2,9)
  -- and trunc(sysdate) > OPERACION.F_GET_FECHA_UTIL(a.fecven,15) <22.0 se comenta linea>
  and trunc(sysdate) > OPERACION.F_GET_FECHA_UTIL(a.fecven,decode(a.tipdoc,'REC',15,5)) -- 22.0>
  and c.codsegmark(+) = v.codsegmark
  and v.codcli = a.codcli
  and a.idfac = bi.idfaccxc
--  and bi.cicfac <> 11 -- para que no considere xplora.
  and bi.cicfac not in (11,14, 15, 24, 25, 21, 26) -- se adicionan para que no considere telefonía triple play. (29/10/2008) g. ormeño/ j. ramos
  and not exists (
             select 1 from transacciones t where t.idfac = a.idfac and transaccion IN ('SUSPENSION','CORTE') and fecfin is null ) and
  a.nomabr = n.numero and
  n.codinssrv = i.codinssrv and
  a.codcli = i.codcli and
  (i.estinssrv = 1 or (i.estinssrv = 2 and  'CLC' IN (select instanciaservicio.esttlfcli from instanciaservicio  where instanciaservicio.codinssrv = i.codinssrv and instanciaservicio.codcli = a.codcli))) ;

  /*"transacciones tipo 2 para servicios XPLOR@"*/
  insert into pretransacciones(nomabr,sldact,codcli,nomcli,categoria,idfac, numdoc, fecemi, fecven,idcategoria, tipo )
    select distinct b.nomabr nomabr,c.sldact,c.codcli,v.nomcli,  ca.dscsegmark categoria,c.idfac,c.sersut||'-'||c.numsut numdoc,
             c.fecemi, c.fecven, ca.codsegmark, 2
      from  cxctabfac c,bilfac b,numtel n, inssrv i, vtatabcli v, VTATABSEGMARK ca
      where 1 = 2--34.0
            and c.estfacrec =0
            and c.flgcarcomp=0 -- se incluye condición para que no se envíen a suspensión servicios con refinanciamiento 05/09/2008
            and
            c.estfac not in ('01','06','11','05') and
            c.sldact>0 and
            trunc(sysdate) > OPERACION.F_GET_FECHA_UTIL(c.fecven,15) and
            b.idfaccxc = c.idfac and
            b.cicfac = 11 and
            b.nomabr = n.numero and
            n.codinssrv = i.codinssrv and
            (i.estinssrv = 1 or (i.estinssrv = 2 and  'CLC' IN (select instanciaservicio.esttlfcli from instanciaservicio  where instanciaservicio.codinssrv = i.codinssrv and instanciaservicio.codcli = c.codcli))) AND
            i.codcli = c.codcli and
            c.codcli = v.codcli and
            ca.codsegmark(+) = v.codsegmark
            and not exists (
                     select 1 from transacciones t where t.idfac = c.idfac and transaccion IN ('SUSPENSION','CORTE') and fecfin is null );

  /* Transacciones para servicios de Datos, tipos 5,6,7,9*/
  insert into pretransacciones(nomabr,sldact,codcli,nomcli,categoria,idfac, numdoc, fecemi, fecven,idcategoria, tipo )
  select distinct fac.nomabr nomabr,fac.sldact,fac.codcli,fac.nomcli,c.dscsegmark categoria, fac.idfac,fac.sersut||'-'||fac.numsut numdoc, fac.fecemi, fac.fecven, c.codsegmark ,
         decode(
                  pro.CODSERCOR
                             ,'ALAI101000',5 ------ iNTERNET
                             ,'ALAI100000',5 ------ iNTERNET
                             ,'ALAI104000',5 ------ iNTERNET
                             ,'ALAI105000',5 ------ iNTERNET
                             ,'ALAI200000',5 ------ iNTERNET
                             ,'ALAI102000',5 ------ iNTERNET
                             ,'ALAD604000',6 ---- RPV
                             ,'ALAD601000',6 ---- RPV
                             ,'ALAD602000',6 ---- RPV
                             ,'ALAD603000',6 ---- RPV
                             ,'ALAD60000',6 ---- RPV
                             ,'ALAE101000',7 ------ Hosting
                             ,'ALAE103000',7 ------ Hosting
                             ,'ALAE102000',8 ------ Housing
                             ,'ALAD101000',9 ----- IP DATA LOCAL
                             ,'ALAD102000',11  ----- IP DATA DOMESTIC
                  ,5
                  )
    from cxctabfac fac,cxcdetfac detfac,conceptofac cpto,product pro, VTATABSEGMARK c, vtatabcli v, inssrv i,
	     controlfacturacion con --<37.0>
                   where fac.idfac=detfac.idfac
				             and fac.idcon=con.idcon  --<37.0>
                     and detfac.idcpto=cpto.idcpto
                     and cpto.codsercor=pro.codsercor
                     and fac.sldact>0
                     and fac.estfacrec=0
                     and fac.flgcarcomp=0 -- se incluye condición para que no se envíen a suspensión servicios con refinanciamiento 05/09/2008
                     and fac.estfac not in ('01','06','11','05')
                     and fac.tipdoc in ('FAC','B/V','REC')-- 36.0 Se agregó el tipo 'REC'
                     and trunc(sysdate) > trunc(fac.fecven) + 15 --OPERACION.F_GET_FECHA_UTIL(fac.fecven,15)
                     and f_valida_concepto(fac.idfac) = 1 --<24.0> validamos concepto
                     and c.codsegmark(+) = v.codsegmark
                     and v.codcli = fac.codcli
                     and not exists (
                              select 1 from transacciones t where t.idfac = fac.idfac and transaccion IN ('SUSPENSION','CORTE') and fecfin is null ) --<24.0> SUSPENSION por SUSENSION
                     and fac.nomabr = i.numero
                     and fac.codcli = i.codcli
                     and i.estinssrv = 1
					           and con.cicfac in (6, 29) --<37.0>
                     AND pro.CODSERCOR IN (
                     'ALAI101000','ALAI100000' ,'ALAI104000' ,'ALAI105000' ,'ALAI200000' ,'ALAI102000'   ---- iNTERNET
                     ,'ALAD604000','ALAD601000','ALAD602000','ALAD603000','ALAD60000'  ---- RPV
                     ,'ALAE101000','ALAE103000'   ------ Hosting
                     ,'ALAE102000'   ------ Housing
                     ,'ALAD101000'   ----- IP DATA LOCAL
                     ,'ALAD102000'   ----- IP DATA DOMESTIC
                     );

--------------------------------------------------
---ester codigo se debe poner en todos los stores
---que se llaman con un job
--para ver si termino satisfactoriamente
/*sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);

------------------------
exception
  when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);*/

END;

/**********************************************************************
Genara las transacciones CLC
**********************************************************************/

  PROCEDURE p_genera_transaccionCLC
  IS

  l_idtrans number;
  l_codsolot solot.codsolot%type;
  l_minnomabr transacciones.nomabr%type;
  pendientes number;
  --Ini 26.0
  l_cuenta   number;
  --Fin 26.0

  ---cursor transacciones analogicas
  cursor cur_traana is
  select distinct c.codcli--, c.nomabr se comenta el nomabr, ya que no es necesario para verificar si existe ya transaccion 23/06/2008
  from collections.cxccorlimcredlog  c, numtel n, inssrv i
  where 1 = 2 and --34.0
      c.tipo ='F' and
      c.flgtra = 0 and
      pq_corteservicio.f_verificanumero(c.nomabr) = 1 and
      c.nomabr = n.numero and
      n.codinssrv = i.codinssrv and
      i.codcli = c.codcli and
      -- cambio en la condición para que considere sólo inssrv en estado activo
      i.estinssrv in (1)
            -- para que no genere un nuevo registro de CLC sobre los mismo servicios -- 18/01/2008
            and (c.codcli, i.numero) not in (select t.codcli, d.nomabr
                                                           from transacciones t, dettransacciones d
                                                           where d.idtrans = t.idtrans
                                                           and t.fecini is null
                                                           and t.codcli = c.codcli
                                                           ) ;

  ---cursor transacciones pri
  cursor cur_trapri is
  select distinct c.codcli--, c.nomabr se comenta el nomabr, ya que no es necesario para verificar si existe ya transaccion 23/06/2008
  from collections.cxccorlimcredlog  c, numtel n, inssrv i
  where 1 = 2 and--34.0
      c.tipo ='F' and
      c.flgtra = 0 and
      pq_corteservicio.f_verificanumero(c.nomabr) = 2 and
      c.nomabr = n.numero and
      n.codinssrv = i.codinssrv and
      i.codcli = c.codcli and
      i.estinssrv = 1
            -- para que no genere un nuevo registro de CLC sobre los mismo servicios -- 18/01/2008
            and (c.codcli, i.numero) not in (select t.codcli, d.nomabr
                                                           from transacciones t, dettransacciones d
                                                           where d.idtrans = t.idtrans
                                                           and t.fecini is null
                                                           and t.codcli = c.codcli
                                                           );

  ---cursor detalle de transacciones analogicas
  cursor cur_detana(c_codcli vtatabcli.codcli%type) is
  select c.identificador, c.codcli,n.numero,i.codinssrv
  from collections.cxccorlimcredlog  c, numtel n, inssrv i
  where c.tipo ='F' and
        c.flgtra = 0 and
        pq_corteservicio.f_verificanumero(c.nomabr) = 1 and
        n.numero = c.nomabr and
        n.codinssrv = i.codinssrv and
        i.codcli = c.codcli and
        c.codcli = c_codcli and
        -- cambio en la condición para que considere sólo inssrv en estado activo
        i.estinssrv in (1)
            -- para que no genere un nuevo registro de CLC sobre los mismo servicios -- 18/01/2008
              and (c.codcli, i.numero) not in (select t.codcli, d.nomabr
                                                           from transacciones t, dettransacciones d
                                                           where d.idtrans = t.idtrans
                                                           and t.fecini is null
                                                           and t.codcli = c.codcli
                                                           );

  ---cursor detalle de transacciones pri
  cursor cur_detpri(c_codcli vtatabcli.codcli%type) is
  select c.identificador, c.codcli,n.numero,i.codinssrv
  from collections.cxccorlimcredlog  c, numtel n, inssrv i
  where c.tipo ='F' and
        c.flgtra = 0 and
        pq_corteservicio.f_verificanumero(c.nomabr) = 2 and
        n.numero = c.nomabr and
        n.codinssrv = i.codinssrv and
        i.codcli = c.codcli and
        c.codcli = c_codcli and
        i.estinssrv = 1
            -- para que no genere un nuevo registro de CLC sobre los mismo servicios -- 18/01/2008
              and (c.codcli, i.numero) not in (select t.codcli, d.nomabr
                                                           from transacciones t, dettransacciones d
                                                           where d.idtrans = t.idtrans
                                                           and t.fecini is null
                                                           and t.codcli = c.codcli
                                                           );

   ---cursor numeros pri
  cursor cur_numpri(c_numero numtel.numero%type) is
/*  select  distinct i.codsrv codsrvnue,i.bw bwnue,i.numero,i.codinssrv,i.cid,i.descripcion,i.direccion,2 tipo, 1 estado, 1 visible, i.codubi,1 flgmt
  from instanciaservicio isb, inssrv i
  where ispadre in (select sb.ispadre
  FROM NUMTEL N , INSSRV I, INSTANCIASERVICIO SB, INSTANCIASERVICIO SB2, INSTXPRODUCTO PB
  WHERE N.NUMERO = c_numero AND
        N.CODINSSRV = I.CODINSSRV AND
        I.CODINSSRV = SB.CODINSSRV AND
        I.CODCLI = SB.CODCLI AND
        SB.ISPADRE = SB2.ISPADRE AND
        SB2.IDINSTSERV = PB.IDCOD AND
        SB2.CODCLI = PB.CODCLI AND
        PB.IDPRODUCTO = 504 AND
        PB.FECFIN IS NULL)
  and isb.codinssrv = i.codinssrv;*/
  select  distinct i.codsrv codsrvnue,i.bw bwnue,i.numero,i.codinssrv,i.cid,i.descripcion,i.direccion,2 tipo, 1 estado, 1 visible, i.codubi,1 flgmt
  from instanciaservicio isb, inssrv i
  where ispadre in (select sb.ispadre
  FROM INSSRV I, INSTANCIASERVICIO SB, INSTANCIASERVICIO SB2, INSTXPRODUCTO PB
  WHERE I.NUMERO = c_numero AND
        I.CODINSSRV = SB.CODINSSRV AND
        I.CODCLI = SB.CODCLI AND
        SB.ISPADRE = SB2.ISPADRE AND
        SB2.IDINSTSERV = PB.IDCOD AND
        SB2.CODCLI = PB.CODCLI AND
        PB.IDPRODUCTO = 504 AND
        PB.FECFIN IS NULL)
  and isb.codinssrv = i.codinssrv;



  ---reconexion CLIENTES CLC  analogicas
  cursor cur_recclcana is
  select distinct i.codcli
  from dettransacciones d, inssrv  i
  where d.idtrans is null and
      d.estado = 3 and
      d.codinssrv = i.codinssrv and
      1 = 2;--34.0

   ---reconexion CLIENTES CLC  analogicas detalle
  cursor cur_detrecclcana (c_codcli vtatabcli.codcli%type) is
  select d.nomabr,d.codinssrv,d.idtrans,d.estado,i.codcli
  from dettransacciones d, inssrv  i
  where d.idtrans is null and
        d.estado = 3 and
        i.codcli =c_codcli and
        d.codinssrv = i.codinssrv;

       ---reconexion CLIENTES CLC  pri
  cursor cur_recclcpri is
  select distinct i.codcli
  from dettransacciones d, inssrv  i
  where d.idtrans is null and
      d.estado = 4 and
      d.codinssrv = i.codinssrv and
      1 = 2;--34.0

  --reconexion CLIENTES CLC  pri detalle
  cursor cur_detrecclcpri (c_codcli vtatabcli.codcli%type) is
  select d.nomabr,d.codinssrv,d.idtrans,d.estado,i.codcli,d.identificadorclc
  from dettransacciones d, inssrv  i
  where d.idtrans is null and
        d.estado = 4 and
        i.codcli =c_codcli and
        d.codinssrv = i.codinssrv;

  BEGIN




   for r_traana in cur_traana loop
     begin
       -- se verica primero que no exista ya un registro de CLC para ese clioente y numero
            begin

             select count(1)
                into pendientes
              from operacion.transacciones t, operacion.solot s
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
                    SELECT SEQ_TRANSACCIONES.NEXTVAL
                    INTO l_idtrans
                    FROM dummy_ope;

                    insert into operacion.transacciones(idtrans,codcli,transaccion,tipo)
                    values(l_idtrans,r_traana.codcli,'CLC',3);


                     --inserto detalle de transaccion
                     for r_detana in cur_detana(r_traana.codcli) loop
                           begin
                           insert into dettransacciones(nomabr,codinssrv,idtrans,identificadorclc)
                           values (r_detana.numero,r_detana.codinssrv, l_idtrans,  r_detana.identificador);

                           update collections.cxccorlimcredlog set flgtra = 1 where  identificador = r_detana.identificador;
                           end;
                      end loop;

                      --actualizo cabecera de transaccion
                      select min(nomabr)
                      into l_minnomabr
                      from dettransacciones
                      where idtrans = l_idtrans;

                      update operacion.transacciones set nomabr = l_minnomabr where idtrans = l_idtrans;

                      commit;

             end if;

        end;
      end loop;--fin de cursor analogica


   for r_trapri in cur_trapri loop
     begin

   -- se verica primero que no exista ya un registro de CLC para ese clioente y numero
            begin
            select count(1)
                into pendientes
              from operacion.transacciones t, operacion.solot s
             where t.codcli = r_trapri.codcli
--               and t.nomabr = r_trapri.nomabr
               and t.codsolot = s.codsolot(+)
               and (t.fecini is null or  s.estsol in (11,17,10))
               and transaccion = 'CLC'
                 ;

               exception WHEN NO_DATA_FOUND THEN pendientes := 0;
            end;

           if pendientes = 0 then

                  --genero la transaccion
                  SELECT SEQ_TRANSACCIONES.NEXTVAL
                  INTO l_idtrans
                  FROM dummy_ope;

                  insert into operacion.transacciones(idtrans,codcli,transaccion,tipo)
                  values(l_idtrans,r_trapri.codcli,'CLC',4);


                   --inserto detalle de transaccion
                   for r_detpri in cur_detpri(r_trapri.codcli) loop
                         begin

                         for r_numpri in cur_numpri(r_detpri.numero) loop

                           insert into dettransacciones(nomabr,codinssrv,idtrans,identificadorclc)
                           values (r_numpri.numero,r_numpri.codinssrv, l_idtrans,  r_detpri.identificador);
                         end loop;

                         update collections.cxccorlimcredlog set flgtra = 1 where  identificador = r_detpri.identificador;
                         end;
                    end loop;

                    --Ini 26.0
                    --actualizo cabecera de transaccion
                    select count(1)
                    into l_cuenta
                    from dettransacciones
                    where idtrans = l_idtrans;

                    if ( l_cuenta = 0 ) then   -- Si no existe detalle para la SOT de RCCLC, se debe cancelar la transacción para no generar SOT sin puntos
                       update operacion.transacciones set fecini=sysdate,fecfin=sysdate where idtrans = l_idtrans;
                     else

                        select min(nomabr)
                        into l_minnomabr
                        from dettransacciones
                        where idtrans = l_idtrans;

                       update operacion.transacciones set nomabr = l_minnomabr where idtrans = l_idtrans;
                    end if;
                    --Fin 26.0
           end if;

        end;
      end loop;--fin de cursor PRI

------------
     -----------------------------------cursor reconexion CLC analogicas

       for r_recclcana in cur_recclcana loop
     begin

        --genero la transaccion
        SELECT SEQ_TRANSACCIONES.NEXTVAL
        INTO l_idtrans
        FROM dummy_ope;

        insert into operacion.transacciones(idtrans,codcli,transaccion,tipo)
        values(l_idtrans,r_recclcana.codcli,'RECCLC',3);


          --inserto detalle de transaccion
         for r_detrecclcana in cur_detrecclcana(r_recclcana.codcli) loop
               begin
               update dettransacciones
               set idtrans = l_idtrans,
                   estado = 0
               where nomabr = r_detrecclcana.nomabr and
                     estado = 3;

               end;
          end loop;

          --Ini 26.0
          --actualizo cabecera de transaccion
          select count(1)
          into l_cuenta
          from dettransacciones
          where idtrans = l_idtrans;

          if ( l_cuenta = 0 ) then   -- Si no existe detalle para la SOT de RCCLC, se debe cancelar la transacción para no generar SOT sin puntos
             update operacion.transacciones set fecini=sysdate,fecfin=sysdate where idtrans = l_idtrans;
           else

              select min(nomabr)
              into l_minnomabr
              from dettransacciones
              where idtrans = l_idtrans;

             update operacion.transacciones set nomabr = l_minnomabr where idtrans = l_idtrans;
          end if;
          --Fin 26.0

        end;
      end loop;--fin de cursor RECCLCANA


          -----------------------------------cursor reconexion CLC pri

       for r_recclcpri in cur_recclcpri loop
     begin

        --genero la transaccion
        SELECT SEQ_TRANSACCIONES.NEXTVAL
        INTO l_idtrans
        FROM dummy_ope;

        insert into operacion.transacciones(idtrans,codcli,transaccion,tipo)
        values(l_idtrans,r_recclcpri.codcli,'RECCLC',4);

        --inserto detalle de transaccion de pri

          --inserto detalle de transaccion
         for r_detrecclcpri in cur_detrecclcpri(r_recclcpri.codcli) loop
               begin
               for r_numpri in cur_numpri(r_detrecclcpri.nomabr) loop
                   begin
                        if (r_detrecclcpri.nomabr <> r_numpri.numero ) then
                              begin
                                  insert into dettransacciones(nomabr,codinssrv,idtrans,estado)
                                  values (r_numpri.numero,r_numpri.codinssrv, l_idtrans, 0);
                              end;
                         end if ;
                         if(r_detrecclcpri.nomabr = r_numpri.numero )  then
                              begin
                                   update dettransacciones
                                   set idtrans = l_idtrans,
                                       estado = 0
                                   where nomabr = r_detrecclcpri.nomabr and
                                         estado = 4;

                              end;
                         end if;
                    end;
             end loop;
           end;
          end loop;

          --actualizo cabecera de transaccion
          select min(nomabr)
          into l_minnomabr
          from dettransacciones
          where idtrans = l_idtrans;

          update operacion.transacciones set nomabr = l_minnomabr where idtrans = l_idtrans;

        end;
      end loop;--fin de cursor RECCLCPRI


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
  from transacciones
  where transaccion = 'CLC'
  and fecini is null
  and tipo in (3/*,4*/);--34.0
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
        p_insert_sot(c_tra.codcli,365,'0004',1,891,l_codsolot);
        p_insert_solotpto_CLC(c_tra.idtrans,l_codsolot,c_tra.codcli);
        pq_solot.p_asig_wf(l_codsolot,516);

        update transacciones set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
        p_enviar_notificacionesxnumero(c_tra.idtrans,'CLCPTELFIJA.htm');
        l_flgenviar := 1;


     end;
      end loop;


     if l_flgenviar > 0 then
       hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'a');
       UTL_FILE.PUT_LINE(hArch,'</body>');
       UTL_FILE.PUT_LINE(hArch,'</html>');
       UTL_FILE.FCLOSE(hArch);
--       p_envia_correo_c_attach('Corte límite de Crédito - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno@claro.com.pe','Corte Límite de Crédito - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
--03/03/2008       p_envia_correo_c_attach('Corte límite de Crédito - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-GestoresdeCreditosyCobranzas@claro.com.pe','Corte Límite de Crédito - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
       p_envia_correo_c_attach('Corte límite de Crédito - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CONMUTACION@claro.com.pe','Corte Límite de Crédito - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');

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
  from transacciones
  where transaccion = 'RECCLC'
  and fecini is null
-- se realiza cambio para que no considere
  and tipo in (3/*,4*/);--34.0 (solo de deja tpi)
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
          from transacciones
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
             update transacciones set fecini = sysdate, codsolot = sotCLC where idtrans = c_tra.idtrans ;
             -- SE ENVÍA CORREO INFORMANDO SOBRE LA SOT ANULADA Y LA CONTINUIDAD DEL SERVICIO
--03/03/2008             p_envia_correo_c_attach('Reconexion CLC - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi')||' ANULACIÓN DE SOT '||sotCLC||' (CLC) POR PAGO DE DEUDA','gustavo.ormeno@claro.com.pe','Reconexiones CLC - Telefonia Fija - Anulación de SOT '|| sotCLC || 'por pago de deuda, ' ||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
--03/03/2008             p_envia_correo_c_attach('Reconexion CLC - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi')||' ANULACIÓN DE SOT '||sotCLC||' (CLC) POR PAGO DE DEUDA','DL-PE-GestoresdeCreditosyCobranzas@claro.com.pe','Reconexiones CLC - Telefonia Fija - Anulación de SOT '|| sotCLC || 'por pago de deuda, ' ||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
             p_envia_correo_c_attach('Reconexion CLC - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi')||' ANULACIÓN DE SOT '||sotCLC||' (CLC) POR PAGO DE DEUDA','DL-PE-CONMUTACION@claro.com.pe','Reconexiones CLC - Telefonia Fija - Anulación de SOT '|| sotCLC || 'por pago de deuda, ' ||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');

            end;
          else
            begin
              --inserta sot
               p_insert_sot(c_tra.codcli,366,'0004',1,891,l_codsolot);
              p_insert_solotpto_CLC(c_tra.idtrans,l_codsolot,c_tra.codcli);
              pq_solot.p_asig_wf(l_codsolot,518);

              update transacciones set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
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
 --      p_envia_correo_c_attach('Reconexion CLC - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'gustavo.ormeno@claro.com.pe','Reconexiones CLC - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
--03/03/2008       p_envia_correo_c_attach('Reconexion CLC - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-GestoresdeCreditosyCobranzas@claro.com.pe','Reconexiones CLC - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
       p_envia_correo_c_attach('Reconexion CLC - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CONMUTACION@claro.com.pe','Reconexiones CLC - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
     end if;

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
  from inssrv i, dettransacciones d
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

/**********************************************************************
Insertar los puntos de lineas analogicas a la sot CLC
**********************************************************************/

  PROCEDURE p_actestadofac(v_codsolot solot.codsolot%type) IS
  cursor cur_numeros is
    select si.idinstserv
    from solotpto s, inssrv i, instanciaservicio si
    where s.codsolot  = v_codsolot and
          s.codinssrv = i.codinssrv and
          i.tipinssrv = 3 and
          i.codinssrv = si.codinssrv and
          i.codcli = si.codcli;

  /*<16.0 l_tiptrs tiptrabajo.tiptrs%type;
  l_tiptra solot.tiptra%type;
  l_codmotot solot.codmotot%type;16.0>*/
  l_codmottip number;--<16.0>

  BEGIN

    --verifico el tipotrabajo y el motivo
   --<16.0
   /* select tt.tiptrs,s.codmotot , s.tiptra
    into l_tiptrs, l_codmotot , l_tiptra
    from solot s, tiptrabajo tt
    where s.codsolot = v_codsolot and
          s.tiptra = tt.tiptra;*/
    begin
    select distinct mt.codmottip
    into l_codmottip
    from solot s, tiptrabajo tt,MOTIVO_TIPTRABAJO mt
    where s.codsolot = v_codsolot
    and s.tiptra = tt.tiptra
    and s.tiptra=mt.tiptra
    and tt.tiptrs=mt.tiptrs
    and s.codmotot=mt.codmotot;
    exception
    when others  then
        l_codmottip :=null;
    end;
   --16.0>

   --Corte por limite de credito
   --if ( ( l_tiptrs = 7 ) and  ( l_codmotot = 891 ) and ( l_tiptra = 365) ) then -- modificación de l_tiptrs = 3 (g.ormeno 13/11/2008) --<16.0>
   --<16.0
   -- Cambio de estado a CORTE LIMITE DE CREDITO en la Instanciaservicio
   if ( l_codmottip in (1,8) ) then
   --16.0>
      begin
             for r_numeros in cur_numeros loop
                begin
                 update billcolper.instanciaservicio
                set esttlfcli ='CLC'
                where idinstserv= r_numeros.idinstserv;

                end;
             end loop;
      end;
   end if;

       --Reconexion CLC
    --if ( ( l_tiptrs = 8 ) and  ( l_codmotot = 891 )and ( l_tiptra = 366) ) then -- modificación de l_tiptrs = 1 (g.ormeno 13/11/2008)--<16.0>
   --<16.0
   -- Cambio de estado a CORTE LIMITE DE CREDITO en la Instanciaservicio
   if (l_codmottip in (2,5,7,9)) then
   --16.0>
      begin
             for r_numeros in cur_numeros loop
                begin
                 update billcolper.instanciaservicio
                set esttlfcli ='ACT'
                where idinstserv= r_numeros.idinstserv;

                end;
             end loop;
      end;
    end if;

   --Suspension por falta de pago
      -- if ( ( l_tiptrs = 3 ) and  ( l_codmotot = 13 ) and ( l_tiptra = 3)) then--<16.0>
   --<16.0
   -- Cambio de estado a CORTE LIMITE DE CREDITO en la Instanciaservicio
    if ( l_codmottip in (3,4,6) ) then
   --16.0>
      begin
             for r_numeros in cur_numeros loop
                begin
                 update billcolper.instanciaservicio
                set esttlfcli ='CFP'
                where idinstserv= r_numeros.idinstserv;

                end;
             end loop;
      end;
   end if;
   --Corte por falta de pago
    /*<16.0   --Corte por falta de pago
      if ( ( l_tiptrs = 3 ) and  ( l_codmotot = 13 ) and ( l_tiptra = 349)) then
      begin
             for r_numeros in cur_numeros loop
                begin
                 update billcolper.instanciaservicio
                set esttlfcli ='CFP'
                where idinstserv= r_numeros.idinstserv;

                end;
             end loop;
      end;
   end if;
    --Reconexion
    if ( ( l_tiptrs = 4 ) and  ( l_codmotot = 126 )and ( l_tiptra = 4) ) then
      begin
             for r_numeros in cur_numeros loop
                begin
                 update billcolper.instanciaservicio
                set esttlfcli ='ACT'
                where idinstserv= r_numeros.idinstserv;

                end;
             end loop;
      end;
   end if;


      --Suspension por falta de pago XPlora
      if ( ( l_tiptrs = 3 ) and  ( l_codmotot = 892 ) and ( l_tiptra = 3)) then
      begin
             for r_numeros in cur_numeros loop
                begin
                 update billcolper.instanciaservicio
                set esttlfcli ='CFP'
                where idinstserv= r_numeros.idinstserv;

                end;
             end loop;
      end;
   end if;

       --Reconexion Xplora
    if ( ( l_tiptrs = 4 ) and  ( l_codmotot = 892 )and ( l_tiptra = 4) ) then
      begin
             for r_numeros in cur_numeros loop
                begin
                 update billcolper.instanciaservicio
                set esttlfcli ='ACT'
                where idinstserv= r_numeros.idinstserv;

                end;
             end loop;
      end;
   end if;16.0>*/


  END;


/**********************************************************************
Genara las transacciones para las reconexionesLC este método es invocado por el trigger COLLECTIONS.T_CXCTABFAC_AU
**********************************************************************/

  PROCEDURE p_genera_transaccion_RECCLC(v_idfac COLLECTIONS.CXCTABFAC.IDFAC%type, v_codcli COLLECTIONS.CXCTABFAC.CODCLI%type, v_nomabr COLLECTIONS.CXCTABFAC.NOMABR%type)
  IS

  cursor cur_suspension(c_idfac COLLECTIONS.CXCTABFAC.IDFAC%type,  l_codcli COLLECTIONS.CXCTABFAC.CODCLI%type, l_nomabr COLLECTIONS.CXCTABFAC.NOMABR%type) is
    select
    distinct t.codcli,--<13.0>
    d.*, t.tipo
    from OPERACION.DETTRANSACCIONES d, OPERACION.TRANSACCIONES t, marketing.vtatabcli v
    where t.tipo not in(1,2,4) and--34.0 (solo se deja activo tpi)
    t.transaccion = 'CLC' and
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
   if f_verifica_baja( c_sus.codcli, c_sus.nomabr) = 0 then --<13.0>
     begin
         -- verifico que no existan otros documentos, para el cliente y la lìnea, que estèn pendientes de cancelar
         --if collections.f_get_cxtabfac_adeudados(v_codcli, v_nomabr) = 0 then

           -- inserta la reconexión a la que se le asignará una SOT con el procedimiento que corre con la SOT (a partir de la suspensión obtenida)
           INSERT INTO OPERACION.DETTRANSACCIONES (NOMABR, CODINSSRV, IDENTIFICADORCLC, ESTADO, CODUSU)
              VALUES (c_sus.nomabr,c_sus.codinssrv,c_sus.IDENTIFICADORCLC,c_sus.tipo,'TRIGGER');
           -- actualiza el registro de la suspensión sobre la que se reconectó, se coloca el estado a cero para que ya no se considere en proximas reconexiones (a partir de la suspensión obtenida)
           UPDATE DETTRANSACCIONES
              SET ESTADO = 0
              WHERE NOMABR = c_sus.nomabr AND CODINSSRV = c_sus.codinssrv AND IDTRANS = c_sus.idtrans AND IDENTIFICADORCLC = c_sus.IDENTIFICADORCLC AND ESTADO = c_sus.estado;
           -- activo el flag flgreconectado de la tabla operacion.reconexionporpago para indicar que se llevo a cabo la reconexión
           select max(idrecpago) into l_idrecpago
           from operacion.reconexionporpago
           where idfac = v_idfac and codcli = v_codcli and nomabr = v_nomabr;
           update operacion.reconexionporpago set flgreconectado = 1, obs='Con suspensión previa, Reconexión CLC efectuada' where idrecpago = l_idrecpago and flgreconectado = 0;
         --end if;
     end;
   end if; --<13.0>
  end loop;
  END;

/**********************************************************************
Genera las transacciones para las RECONEXIONES PARA TELEFONIA FIJA este método es invocado por el trigger COLLECTIONS.T_CXCTABFAC_AU
**********************************************************************/

  PROCEDURE p_genera_transaccion_RECONEX(v_idfac COLLECTIONS.CXCTABFAC.IDFAC%type, v_codcli COLLECTIONS.CXCTABFAC.CODCLI%type, v_nomabr COLLECTIONS.CXCTABFAC.NOMABR%type)
  IS
  -- obtiene el registro de la suspensión sobre la que se va areconectar la línea por medio del número de teléfono y el nombre del cliente
  cursor cur_suspension(c_idfac COLLECTIONS.CXCTABFAC.IDFAC%type,  l_codcli COLLECTIONS.CXCTABFAC.CODCLI%type, l_nomabr COLLECTIONS.CXCTABFAC.NOMABR%type) is

    select max(t.idtrans) idtransmax, t.nomabr, t.codcli,  t.tipo--*
    from OPERACION.transacciones t
    --<10. where TRANSACCION in ('SUSPENSION','CORTE','BAJA')
    where TRANSACCION in ('SUSPENSION','CORTE','BAJA','BAJATOTAL') -- se adiciona 'BAJATOTAL' Req. 76031 10.0>
    and FECFIN IS NULL
    AND TIPO IN (/*1,*/3) -- Se incluye el tipo 3 para TPI --34.0 (solo de deja tpi)
--    AND idfac = c_idfac -- "DESCOMENTO", PARA SOLO REGISTRAR RECONEXIÓN DE LA SUPENSIÓN ASOCIADA AL DOCUMENTO
    AND CODCLI = l_codcli
    AND NOMABR = l_nomabr
    group by t.nomabr, t.codcli, t.tipo;

    l_idrecpago number;
    l_sotPrevia number;
    l_transaccion transacciones.transaccion%type;
    l_idfac transacciones.idfac%type;

  --<10. ES_BAJA_TPI number;
  ES_BAJA number;  --10.0>
  TAREAS_CERRADAS number;

  BEGIN
  for c_sus in cur_suspension(v_idfac, v_codcli, v_nomabr) loop
     begin
         --<10.0 ES_BAJA_TPI := 0;
         ES_BAJA := 0; --10.0>
         SELECT transaccion, nvl(codsolot,0), idfac into l_transaccion, l_sotPrevia, l_idfac from transacciones where idtrans = c_sus.idtransmax;

--         select nvl(codsolot,0) into l_sotPrevia from transacciones where idtrans = c_sus.idtransmax;

--         if l_sotPrevia = 0 and c_sus.transaccion <> 'CORTE' then
         --<10.0
         --if l_sotPrevia = 0 and l_transaccion <> 'CORTE' then
         if l_sotPrevia = 0 and l_transaccion = 'SUSPENSION' then
         --10.0>
            UPDATE OPERACION.TRANSACCIONES
             SET FECFIN = sysdate, fecini = sysdate, esttrans = 'CANCELADA'
--             WHERE IDTRANS = c_sus.IDTRANS ;
               WHERE IDTRANS = c_sus.idtransmax ;
         else
            --<10.0
            --if (l_transaccion = 'BAJA' AND c_sus.tipo = 3 ) THEN
            if (l_transaccion in('BAJA', 'BAJATOTAL') AND c_sus.tipo = 3 ) THEN
            --10.0>


                --<10.0> SELECT 1, count(1) INTO ES_BAJA_TPI, TAREAS_CERRADAS
                SELECT 1, count(1) INTO ES_BAJA, TAREAS_CERRADAS -- se verifica si la SOT de baja es posible de anular--<10.0>
                FROM TAREAWF T, WF
                WHERE WF.CODSOLOT = l_sotPrevia
                AND WF.VALIDO = 1
                AND T.IDWF = WF.IDWF
                --AND T.TAREADEF IN (150,299)--<10.0>
                AND T.TAREADEF NOT IN (679,334,298) --<10.0>
                AND T.ESTTAREA = 4   ;
             END IF;
            --<10.0> if (ES_BAJA_TPI = 1 AND TAREAS_CERRADAS = 0 ) OR (ES_BAJA_TPI = 0 )then -- validación de estado de la tarea en el caso de que sea BAJA tpi
            if (ES_BAJA = 1 AND TAREAS_CERRADAS = 0 ) OR (ES_BAJA = 0 )then -- validación de estado de la tarea en el caso de que sea BAJA tpi--<10.0>
               -- ANULO LA SOT PREVIA DE BAJA TPI
               --<10.0> -IF ES_BAJA_TPI = 1 THEN
               IF ES_BAJA = 1 and l_sotPrevia <> 0 THEN--<10.0>
                  operacion.pq_solot.p_chg_estado_solot(l_sotPrevia,13,null,'SOT anulada por pago de deuda, tareas de Activacion/Desactivacion de servicio y Retiro de equipos aún no cerradas');
               END IF;

               -- inserta la reconexión a la que se le asignará una SOT con el procedimiento que corre con el JOB (a partir de la suspensión obtenida)
               INSERT INTO OPERACION.TRANSACCIONES (IDFAC, NOMABR, CODCLI, TRANSACCION, CODUSU, IDTRANSORI, TIPO)
  --             VALUES (c_sus.IDFAC,c_sus.NOMABR,c_sus.CODCLI, 'ACTIVACION', user,c_sus.IDTRANS,c_sus.TIPO);
                 VALUES (l_idfac,c_sus.NOMABR,c_sus.CODCLI, 'ACTIVACION', user,c_sus.idtransmax,c_sus.TIPO);
               -- actualiza el registro de la suspensión sobre la que se reconectó, se coloca la fech fin para que ya no se considere en proximas reconexiones (a partir de la suspensión obtenida)
               UPDATE OPERACION.TRANSACCIONES
               SET FECFIN = sysdate
  --             WHERE IDTRANS = c_sus.IDTRANS ;
                 --<10.0> WHERE nomabr = c_sus.NOMABR and codcli = c_sus.CODCLI and transaccion in ('SUSPENSION','CORTE','BAJA');
                 WHERE nomabr = c_sus.NOMABR and codcli = c_sus.CODCLI and transaccion in ('SUSPENSION','CORTE','BAJA','BAJATOTAL');  --<10.0>
               -- activo el flag flgreconectado de la tabla operacion.reconexionporpago para indicar que se llevo a cabo la reconexión
               select max(idrecpago) into l_idrecpago
               from operacion.reconexionporpago
               where idfac = v_idfac and codcli = v_codcli and nomabr = v_nomabr;
               update operacion.reconexionporpago set flgreconectado = 1, obs='Con suspensión previa, Reconexión TF efectuada' where idrecpago = l_idrecpago and flgreconectado = 0;
             end if;
         end if;
     end;
  end loop;

  END;

/**********************************************************************
Genera las transacciones para las RECONEXIONES XPLORA este método es invocado por el trigger COLLECTIONS.T_CXCTABFAC_AU
**********************************************************************/

  PROCEDURE p_genera_transaccion_RECXPLORA(v_idfac COLLECTIONS.CXCTABFAC.IDFAC%type, v_codcli COLLECTIONS.CXCTABFAC.CODCLI%type, v_nomabr COLLECTIONS.CXCTABFAC.NOMABR%type)
  IS
  -- obtiene el registro de la suspensión sobre la que se va areconectar la línea por medio del número de teléfono y el nombre del cliente
  cursor cur_suspension(c_idfac COLLECTIONS.CXCTABFAC.IDFAC%type,  l_codcli COLLECTIONS.CXCTABFAC.CODCLI%type, l_nomabr COLLECTIONS.CXCTABFAC.NOMABR%type) is

    select max(t.idtrans) idtransmax, t.nomabr, t.codcli,  t.tipo--*
    from OPERACION.transacciones t
    --<10.0
--    where TRANSACCION in ('SUSPENSION','CORTE')
    where TRANSACCION in ('SUSPENSION','CORTE','BAJATOTAL')
    --10.0>
    and 1 = 2 --34.0
    AND FECFIN IS NULL
    AND TIPO = 2
--    AND idfac = c_idfac -- "DESCOMENTO", PARA SOLO REGISTRAR RECONEXIÓN DE LA SUPENSIÓN ASOCIADA AL DOCUMENTO
    AND CODCLI = l_codcli
    AND NOMABR = l_nomabr
    group by t.nomabr, t.codcli, t.tipo; --<10.0>

    l_idrecpago number;
    l_sotPrevia number;
    l_transaccion transacciones.transaccion%type;--<10.0>
    l_idfac transacciones.idfac%type;--<10.0>

    ES_BAJA number;--<10.0>
    TAREAS_CERRADAS number;--<10.0>

  BEGIN
  for c_sus in cur_suspension(v_idfac, v_codcli, v_nomabr) loop
     begin

         ES_BAJA := 0;--<10.0>
         --<10.0
         --SELECT transaccion, nvl(codsolot,0), idfac into l_transaccion, l_sotPrevia, l_idfac from transacciones where idtrans = c_sus.idtransmax;
         SELECT transaccion, nvl(codsolot,0), idfac into l_transaccion, l_sotPrevia, l_idfac from transacciones where idtrans = c_sus.idtransmax;
        --if l_sotPrevia = 0 and l_transaccion <> 'CORTE' then
       --10.0>
         if l_sotPrevia = 0 and l_transaccion = 'SUSPENSION' then
            UPDATE OPERACION.TRANSACCIONES
             SET FECFIN = sysdate, fecini = sysdate, esttrans = 'CANCELADA'
             WHERE IDTRANS = c_sus.idtransmax;
         else
           --<10.0
            if (l_transaccion = 'BAJATOTAL') THEN -- si es una BAJA
                SELECT 1, count(1) INTO ES_BAJA, TAREAS_CERRADAS -- se verifica si la SOT de baja es posible de anular
                FROM TAREAWF T, WF
                WHERE WF.CODSOLOT = l_sotPrevia
                AND WF.VALIDO = 1
                AND T.IDWF = WF.IDWF
                AND T.TAREADEF NOT IN (679,334,298)
                AND T.ESTTAREA = 4   ;
           END IF;

           if (ES_BAJA = 1 AND TAREAS_CERRADAS = 0 ) OR (ES_BAJA = 0 )then -- validación de estado de la tarea en el caso de que sea BAJA tpi

               IF ES_BAJA = 1 and l_sotPrevia <> 0 THEN
                  operacion.pq_solot.p_chg_estado_solot(l_sotPrevia,13,null,'SOT anulada por pago de deuda, tareas de Activacion/Desactivacion de servicio y Retiro de equipos aún no cerradas');
               END IF;
            --10.0>
               -- inserta la reconexión a la que se le asignará una SOT con el procedimiento que corre con el JOB (a partir de la suspensión obtenida)
               INSERT INTO OPERACION.TRANSACCIONES (IDFAC, NOMABR, CODCLI, TRANSACCION, CODUSU, IDTRANSORI, TIPO)
               VALUES (l_idfac,c_sus.NOMABR,c_sus.CODCLI, 'ACTIVACION', user,c_sus.idtransmax,2);

               -- actualiza el registro de la suspensión sobre la que se reconectó, se coloca la fech fin para que ya no se considere en proximas reconexiones (a partir de la suspensión obtenida)
               UPDATE OPERACION.TRANSACCIONES
               SET FECFIN = sysdate, ESTTRANS = 'RECONECTADA'
                 WHERE nomabr = c_sus.NOMABR and codcli = c_sus.CODCLI and transaccion in ('SUSPENSION','CORTE','BAJA','BAJATOTAL');

               -- activo el flag flgreconectado de la tabla operacion.reconexionporpago para indicar que se llevo a cabo la reconexión
               select max(idrecpago) into l_idrecpago
               from operacion.reconexionporpago
               where idfac = v_idfac and codcli = v_codcli and nomabr = v_nomabr;
               update operacion.reconexionporpago set flgreconectado = 1, obs='Con suspensión previa, Reconexión XPLORA efectuada' where idrecpago = l_idrecpago and flgreconectado = 0;
             --end if;
            end if;
          end if;
     end;
  end loop;

  END;


/**********************************************************************
Genera las transacciones para las RECONEXIONES DE SERVICIOS DE DATOS, este método es invocado por el trigger COLLECTIONS.T_CXCTABFAC_AU
**********************************************************************/

  PROCEDURE p_genera_transaccion_RECDATOS(v_idfac COLLECTIONS.CXCTABFAC.IDFAC%type, v_codcli COLLECTIONS.CXCTABFAC.CODCLI%type, v_nomabr COLLECTIONS.CXCTABFAC.NOMABR%type)
  IS
  -- obtiene el registro de la suspensión sobre la que se va areconectar la línea por medio del número de teléfono y el nombre del cliente
  cursor cur_suspension(c_idfac COLLECTIONS.CXCTABFAC.IDFAC%type,  l_codcli COLLECTIONS.CXCTABFAC.CODCLI%type, l_nomabr COLLECTIONS.CXCTABFAC.NOMABR%type) is
    --select *
    select max(t.idtrans) idtransmax, t.nomabr, t.codcli,  t.tipo--*
    from OPERACION.transacciones t
    where TRANSACCION in ('SUSPENSION','CORTE','BAJATOTAL')
    AND FECFIN IS NULL
    AND TIPO IN (5,6,7,8,9,11) -- SERVICIOS DE DATOS
--    AND idfac = c_idfac -- "DESCOMENTO", PARA SOLO REGISTRAR RECONEXIÓN DE LA SUPENSIÓN ASOCIADA AL DOCUMENTO
    AND CODCLI = l_codcli
    AND NOMABR = l_nomabr
    --<10.0
    group by t.nomabr, t.codcli, t.tipo;

    l_idrecpago number;
    l_sotPrevia number;
    l_transaccion transacciones.transaccion%type;
    l_idfac transacciones.idfac%type;

    ES_BAJA number;
    TAREAS_CERRADAS number;
    --10.0>
    BEGIN
  for c_sus in cur_suspension(v_idfac, v_codcli, v_nomabr) loop
     begin

         ES_BAJA := 0;
         SELECT transaccion, nvl(codsolot,0), idfac into l_transaccion, l_sotPrevia, l_idfac from transacciones where idtrans = c_sus.idtransmax;
         --if l_sotPrevia = 0 and c_sus.transaccion <> 'CORTE' then <6.0>
         if l_sotPrevia = 0 and l_transaccion = 'SUSPENSION' then
            UPDATE OPERACION.TRANSACCIONES
             SET FECFIN = sysdate, fecini = sysdate, esttrans = 'CANCELADA'
             WHERE IDTRANS = c_sus.idtransmax ;
         else
           --<10.0
            if (l_transaccion = 'BAJATOTAL') THEN -- si es una BAJA
                  SELECT 1, count(1) INTO ES_BAJA, TAREAS_CERRADAS -- se verifica si la SOT de baja es posible de anular
                  FROM TAREAWF T, WF
                  WHERE WF.CODSOLOT = l_sotPrevia
                  AND WF.VALIDO = 1
                  AND T.IDWF = WF.IDWF
                  AND T.TAREADEF NOT IN (679,334,298)
                  AND T.ESTTAREA = 4   ;
             END IF;
           if (ES_BAJA = 1 AND TAREAS_CERRADAS = 0 ) OR (ES_BAJA = 0 )then -- validación de estado de la tarea en el caso de que sea BAJA tpi
               IF ES_BAJA = 1 and l_sotPrevia <> 0 THEN
                  operacion.pq_solot.p_chg_estado_solot(l_sotPrevia,13,null,'SOT anulada por pago de deuda, tareas de Activacion/Desactivacion de servicio y Retiro de equipos aún no cerradas');
               END IF;
              --10.0>
             -- inserta la reconexión a la que se le asignará una SOT con el procedimiento que corre con el JOB (a partir de la suspensión obtenida)
             INSERT INTO OPERACION.TRANSACCIONES (IDFAC, NOMABR, CODCLI, TRANSACCION, CODUSU, IDTRANSORI, TIPO)
             VALUES (l_idfac,c_sus.NOMABR,c_sus.CODCLI, 'ACTIVACION', user,c_sus.idtransmax,c_sus.TIPO);

             -- actualiza el registro de la suspensión sobre la que se reconectó, se coloca la fech fin para que ya no se considere en proximas reconexiones (a partir de la suspensión obtenida)
             UPDATE OPERACION.TRANSACCIONES
             SET FECFIN = sysdate, ESTTRANS = 'RECONECTADA'
               WHERE nomabr = c_sus.NOMABR and codcli = c_sus.CODCLI and transaccion in ('SUSPENSION','CORTE','BAJA','BAJATOTAL');

             -- activo el flag flgreconectado de la tabla operacion.reconexionporpago para indicar que se llevo a cabo la reconexión
             select max(idrecpago) into l_idrecpago
             from operacion.reconexionporpago
             where idfac = v_idfac and codcli = v_codcli and nomabr = v_nomabr;
             update operacion.reconexionporpago set flgreconectado = 1, obs='Con suspensión previa, Reconexión TF efectuada' where idrecpago = l_idrecpago and flgreconectado = 0;
           end if;

         end if;
     end;
  end loop;

  END;


/**********************************************************************
Función invocada por un job, lee los cxctabfac cancelados para generar la reconexión automática
**********************************************************************/

  PROCEDURE p_genera_rec_por_fac_cancelada IS

  ------------------------------------
  --VARIABLES PARA EL ENVIO DE CORREOS
 /* c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.PQ_CORTESERVICIO_CABLE.P_GENERA_REC_POR_FAC_CANCELADA';
  c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='682';
  c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );*/
  --------------------------------------------------

  cursor cur_fac is
    select idrecpago, idfac, codcli, nomabr
    from operacion.reconexionporpago
    where flgleido = 0;

  tieneCorte number;
  id_error operacion.reconexionporpago.idrecpago%type;

  BEGIN
     for c_fac in cur_fac loop
        begin

             id_error := c_fac.idrecpago;

             update operacion.reconexionporpago set flgleido = 1, obs = 'Leído' where idrecpago = c_fac.idrecpago;

             select count(1) into tieneCorte
             from transacciones
             where codcli = c_fac.codcli
             and nomabr = c_fac.nomabr
             --<10.0 and transaccion in ('SUSPENSION', 'CLC', 'CORTE','BAJA')
             and transaccion in ('SUSPENSION', 'CLC', 'CORTE','BAJA','BAJATOTAL') --10.0>
             and fecfin is null;

             if tieneCorte > 0 then

             --verifico que no existan otros documentos, para el cliente y la lìnea, que estèn pendientes de cancelar
               if collections.f_get_cxtabfac_adeudados(c_fac.codcli, c_fac.nomabr) = 0 then
                 BEGIN
                  p_genera_transaccion_RECCLC(c_fac.idfac , c_fac.codcli , c_fac.nomabr );
  -- AQUÍ SE COLOCARÁN LAS LLAMADAS A LAS FUNCIONES PARA LAS RECONEXIONES AUTOMÁTICAS DE TELEFONÍA FIJA Y EXPLORA
                  p_genera_transaccion_RECONEX(c_fac.idfac , c_fac.codcli , c_fac.nomabr );
                  p_genera_transaccion_RECXPLORA(c_fac.idfac , c_fac.codcli , c_fac.nomabr );
                  p_genera_transaccion_RECDATOS(c_fac.idfac , c_fac.codcli , c_fac.nomabr );
                 END;
               else
                  update operacion.reconexionporpago set obs = 'Otros documentos adeudados' where idrecpago = c_fac.idrecpago;
               end if;
             end if;
        end;
      commit;
      end loop;
      operacion.pq_corteservicio.p_genera_transaccionclc;
      operacion.pq_corteservicio.p_genera_recclc;
      operacion.pq_corteservicio.p_genera_reconexion;
      operacion.pq_corteservicio.p_genera_reconexion_xplora;
      operacion.pq_corteservicio.p_genera_reconexion_datos;
      operacion.pq_corteservicio.p_insert_cancelacion_nc;--<15.0>

--<16.0
/*--<8.0
   insert into operacion.reconexionporpago
        SELECT DISTINCT NULL,IDFAC,CODCLI,NOMABR,SYSDATE,USER,0,0,''
          FROM TRANSACCIONES
         WHERE IDFAC IN
               (select IDFACCAN
                  from faccanfac
                 where fecusu > to_date('06/08/2008','dd/mm/yyyy') -- INICIO CORTE DE AUTOMATIZACION CORTES Y RECONEXIONES
                   AND idfaccan in (select idfac
                                      from transacciones
                                     where transaccion = 'SUSPENSION' -- POR EL MOMENTO SOLO TIPO 15, TRIPLE PLAY
                                       AND FECFIN IS NULL));
--8.0>*/
--16.0>
  --------------------------------------------------
  ---ester codigo se debe poner en todos los stores
  ---que se llaman con un job
  --para ver si termino satisfactoriamente
/*  sp_rep_registra_error
     (c_nom_proceso || 'Id de error: ' ||id_error, c_id_proceso,
      sqlerrm , '0', c_sec_grabacion);

  exception
     when others then
        sp_rep_registra_error
           (c_nom_proceso || 'Id de error: ' ||id_error, c_id_proceso,
            sqlerrm , '1',c_sec_grabacion );
        raise_application_error(-20000,sqlerrm);*/

  END;

/**********************************************************************
Genera las transacciones para las SUSPENSIONES DE TPI, este método es invocado por UN JOB
**********************************************************************/

PROCEDURE  p_genera_trans_SUSP
  IS


/*------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.PQ_CORTESERVICIO.P_GENERA_TRANS_SUSP';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='283-II';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
--------------------------------------------------*/
l_codcli vtatabcli.codcli%type;
l_idrecpago number;
l_tienebaja number;
l_validar  number;
l_idfac transacciones.idfac%type;
  -- obtiene el registro de la suspensión sobre la que se va a reconectar la línea por medio del nombre del cliente
  cursor cur_suspension is
-- se modifica esta condición para que no se corte a TPIs que fueron refinanciados, hasta que KHOLGADO indique el cambio
select MIN(IDFAC) IDFACMIN, nomabr, codcli, tipo -- obtengo el idfac minimo de los recibos vencidos
  from pretransacciones
 where (NOMABR, CODCLI) in (SELECT NOMABR, CODCLI
                              FROM pretransacciones
                            MINUS
                            select NOMABR, CODCLI
                              from transacciones t
                             -- where transaccion in ('SUSPENSION', 'CORTE') <10.0>
                             where transaccion in ('SUSPENSION', 'CORTE','BAJATOTAL')--<10.0>
                               and fecfin is null)
   and tipo in (/*1, 2, */3)       --REQ 85754 Se agrego Telefonia y Claro Empresa --34.0 (solo de deja tpi)
--20.0> Se guarda clientes en la tabla clientes_financiados
/*   and codcli not in
       ('00014821', '00034702', '00039594', '00046727', '00059154',
        '00066673', '00073973', '00080605', '00100142', '00101775',
        '00102131', '00286676', '00287400', '00338964', '00343789',
        '00366579', '00367350', '00369303', '00370202', '00372672',
        '00372782', '00372796', '00373016', '00373118', '00373207',
        '00375215', '00375466', '00375711', '00376393', '00376846',
        '00376887', '00377034', '00377046', '00377103', '00377672',
        '00378113', '00378115', '00378903', '00379397', '00379489',
        '00379911', '00380151', '00380211', '00380329', '00380335',
        '00380509', '00380682', '00380828', '00380834', '00380901',
        '00380905', '00380907', '00380912', '00381137', '00381158',
        '00381225', '00381281', '00381281', '00381293', '00381313',
        '00381315', '00381332', '00381333', '00381337', '00381375',
        '00381422', '00381423', '00381528', '00381530', '00381537',
        '00381604', '00381725', '00381729', '00381730', '00382092',
        '00382148', '00382151', '00382160', '00382185', '00382190',
        '00382203', '00382257', '00382428', '00382434', '00383148',
        '00383255', '00383263', '00383271', '00383277', '00383309',
        '00383314', '00383329', '00383330', '00383369', '00383371',
        '00384334', '00384526', '00384600', '00384607', '00385311',
        '00385327', '00385485', '00385486', '00385526', '00385553',
        '00385592', '00385597', '00385813', '00385817', '00385824',
        '00385826', '00385831', '00385918', '00387065', '00387066',
        '00387349', '00387431', '00387432', '00388514', '00389050',
        '00389545', '00389549', '00389594', '00390124', '00390199',
        '00390201', '00390523', '00390960', '00391436', '00391781',
        '00391786', '00392336', '00393007', '00393018', '00393019',
        '00393519', '00393533', '00393602', '00393604', '00393620',
        '00393705', '00393732', '00393760', '00394682', '00394868',
        '00394876', '00394881', '00394889', '00394897', '00394911',
        '00394924', '00394925', '00396615', '00396616', '00396639',
        '00396651', '00396653', '00396654', '00396666', '00396675',
        '00396676', '00396677', '00396704', '00397214', '00398679',
        '00398700', '00398701', '00399602', '00399738', '00401497',
        '00401707', '00401752', '00401755', '00402148', '00402186',
        '00402190', '00402192', '00402196', '00403012', '00407100',
        '00381155', '00287400', '00382203', '00343789', '00376887',
        '00373118', '00372672', '00369303', '00372796', '00375215',
        '00366579', '00374716', '00381281','00377753')
     group by nomabr, codcli, tipo;*/
and codcli not in
     (select codcli from clientes_financiados where flg_activo = 1)
group by nomabr, codcli, tipo;
--20.0> se agrego estas tres lineas siguientes

  cursor cur_segmark is
  select *  from vtatabcli where codcli=l_codcli;

  cursor cu_inssrv is
  -- 87291   select so.codinssrv
  select so.codinssrv, so.numero
  from  inssrv so
  where so.codinssrv in (
        select codinssrv from inssrv where codinssrv in (
        select codinssrv from insprd where pid in (
        select pid from instxproducto where idinstprod in (
        select idinstprod from cr where idbilfac in (
        select idbilfac from bilfac where idfaccxc = l_idfac))) and flgprinc=1 ) -- nuevos
  )
  and so.codcli=l_codcli
;

  BEGIN
  for c_sus in cur_suspension loop
    l_validar:=0;
     begin
       if c_sus.tipo=3 then
           -- inserta la suspensión a la que se le asignará una SOT con el procedimiento que corre con el JOB
           INSERT INTO OPERACION.TRANSACCIONES (IDFAC, NOMABR, CODCLI, TRANSACCION, CODUSU, IDTRANSORI, TIPO)
           VALUES (c_sus.idfacmin,c_sus.nomabr,c_sus.codcli, 'SUSPENSION', user,null,c_sus.tipo);
       elsif c_sus.tipo in(1,2) then
            l_codcli:=c_sus.codcli;
            l_idfac:=c_sus.idfacmin;
               for c_ins in cu_inssrv loop
                 if l_validar=0 then
                --Verificar  que para el servicio existe una SOT de BAJA REQ 87291
                    select count(1) into l_tienebaja
                    from solot S1, SOLOTPTO SP, INSSRV I
                    where S1.codcli =l_codcli
                    -- 87291 and c_sus.nomabr = I.NUMERO
                    and c_ins.numero = I.NUMERO
                    and I.CODINSSRV =  SP.CODINSSRV
                    and I.CODINSSRV=c_ins.codinssrv
                    and SP.CODSOLOT = S1.CODSOLOT
                    and S1.tiptra in (5)
                    and S1.estsol in (12,29);

                if l_tienebaja=0 then
                      for c_seg in cur_segmark loop
                        -- REQ 85754 Para  segmento CLIENTE A - PREFERENTE y   CLIENTE B
                          -- 87291 if c_seg.codsegmark in(28,29) then
                          if c_seg.codsegmark in(28,29,24,15) then
                         -- inserta la suspensión a la que se le asignará una SOT con el procedimiento que corre con el JOB
                             INSERT INTO OPERACION.TRANSACCIONES (IDFAC, NOMABR, CODCLI, TRANSACCION, CODUSU, IDTRANSORI, TIPO)
                             VALUES (c_sus.idfacmin,c_sus.nomabr,c_sus.codcli, 'SUSPENSION', user,null,c_sus.tipo);
                             l_validar:=1;
                          end if;
                      end loop;
                 end if;
                 end if;
               end loop;
       end if;

     end;
  end loop;


--------------------------------------------------
---ester codigo se debe poner en todos los stores
---que se llaman con un job
--para ver si termino satisfactoriamente
/*sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);

------------------------
exception
  when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);*/

  END;


/**********************************************************************
Genera las transacciones para llos cortes DE TPI, este método es invocado por UN JOB
**********************************************************************/

PROCEDURE  p_genera_trans_CORTE
  IS

/*------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.PQ_CORTESERVICIO.P_GENERA_TRANS_CORTE';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='283-III';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
--------------------------------------------------*/


  -- obtiene el registro de la suspensión sobre la que se va a reconectar la línea por medio del nombre del cliente
  cursor cur_corte is

    --<20.0 se comenta este tipo del cursor y se remplaza por otro
/*    SELECT T.idtrans, T.idfac, T.nomabr, T.codcli, T.transaccion, T.tipo, a.sldact, v.nomcli, c.descripcion, a.sersut||'-'||a.numsut, a.fecemi, a.fecven, T.FECREGAVISUSP
    FROM OPERACION.TRANSACCIONES T, cxctabfac a, categoria c, vtatabcli v, solot s, estsol e
    WHERE tipo in(1,2,3) and TRANSACCION = 'SUSPENSION' AND T.FECFIN IS NULL --REQ 85754 Se agrego Telefonia y Claro Empresa
    AND T.IDFAC = a.IDFAC AND T.CODCLI = TO_NUMBER(v.codcli)
    AND v.idcategoria = c.idcategoria (+) and s.codsolot = t.codsolot
    and s.fecfin + 20 < sysdate and s.estsol = e.estsol and e.estsol = 12
    AND a.estfacrec = 0
    and a.flgcarcomp = 0 -- se incluye condicion para que no se consideren clientes refinanciados 05/09/2008
    and ( T.fecregavisusp is not null and trunc(sysdate) > OPERACION.F_GET_FECHA_UTIL(T.fecregavisusp,7) ) -- REQ 87291
    and t.codcli not in
       ('00014821', '00034702', '00039594', '00046727', '00059154',
        '00066673', '00073973', '00080605', '00100142', '00101775',
        '00102131', '00286676', '00287400', '00338964', '00343789',
        '00366579', '00367350', '00369303', '00370202', '00372672',
        '00372782', '00372796', '00373016', '00373118', '00373207',
        '00375215', '00375466', '00375711', '00376393', '00376846',
        '00376887', '00377034', '00377046', '00377103', '00377672',
        '00378113', '00378115', '00378903', '00379397', '00379489',
        '00379911', '00380151', '00380211', '00380329', '00380335',
        '00380509', '00380682', '00380828', '00380834', '00380901',
        '00380905', '00380907', '00380912', '00381137', '00381158',
        '00381225', '00381281', '00381281', '00381293', '00381313',
        '00381315', '00381332', '00381333', '00381337', '00381375',
        '00381422', '00381423', '00381528', '00381530', '00381537',
        '00381604', '00381725', '00381729', '00381730', '00382092',
        '00382148', '00382151', '00382160', '00382185', '00382190',
        '00382203', '00382257', '00382428', '00382434', '00383148',
        '00383255', '00383263', '00383271', '00383277', '00383309',
        '00383314', '00383329', '00383330', '00383369', '00383371',
        '00384334', '00384526', '00384600', '00384607', '00385311',
        '00385327', '00385485', '00385486', '00385526', '00385553',
        '00385592', '00385597', '00385813', '00385817', '00385824',
        '00385826', '00385831', '00385918', '00387065', '00387066',
        '00387349', '00387431', '00387432', '00388514', '00389050',
        '00389545', '00389549', '00389594', '00390124', '00390199',
        '00390201', '00390523', '00390960', '00391436', '00391781',
        '00391786', '00392336', '00393007', '00393018', '00393019',
        '00393519', '00393533', '00393602', '00393604', '00393620',
        '00393705', '00393732', '00393760', '00394682', '00394868',
        '00394876', '00394881', '00394889', '00394897', '00394911',
        '00394924', '00394925', '00396615', '00396616', '00396639',
        '00396651', '00396653', '00396654', '00396666', '00396675',
        '00396676', '00396677', '00396704', '00397214', '00398679',
        '00398700', '00398701', '00399602', '00399738', '00401497',
        '00401707', '00401752', '00401755', '00402148', '00402186',
        '00402190', '00402192', '00402196', '00403012', '00407100',
        '00381155', '00287400', '00382203', '00343789', '00376887',
        '00373118', '00372672', '00369303', '00372796', '00375215',
        '00366579', '00374716', '00381281','00377753'); -- se cortan sòlo recibos que no estèn en reclamo. */
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
           a.fecven,
           T.FECREGAVISUSP
      FROM OPERACION.TRANSACCIONES T,
           cxctabfac               a,
           categoria               c,
           vtatabcli               v,
           solot                   s,
           estsol                  e
     WHERE TRANSACCION = 'SUSPENSION'
       AND T.FECFIN IS NULL
       AND T.IDFAC = a.IDFAC
       AND T.CODCLI = TO_NUMBER(v.codcli)
       AND v.idcategoria = c.idcategoria(+)
       and s.codsolot = t.codsolot
       and s.fecfin + 20 < sysdate
       and s.estsol = e.estsol
       and e.estsol = 12
       AND a.estfacrec = 0
       and a.flgcarcomp = 0
       --ini 34.0
       and (/*((T.fecregavisusp is not null) and
           (trunc(sysdate) > OPERACION.F_GET_FECHA_UTIL(T.fecregavisusp, 7)) and
           (tipo in (1, 2))) or*/ (tipo in (3)))
       --fin 34.0
       and t.codcli not in
           (select codcli from clientes_financiados where flg_activo = 1);
--20.0>  se adiciono estas lineas de codigo de consulta
    l_idrecpago number;

  BEGIN
  for c_cor in cur_corte loop
     begin
       if c_cor.tipo=3 then
           -- inserta el corte a la que se le asignará una SOT con el procedimiento que corre con el JOB
             INSERT INTO OPERACION.TRANSACCIONES (IDFAC, NOMABR, CODCLI, TRANSACCION, CODUSU, IDTRANSORI, TIPO)
            VALUES (c_cor.idfac,c_cor.nomabr,c_cor.codcli, 'BAJA', user,c_cor.idtrans,c_cor.tipo);
              -- cierra la suspensión correspondiente, no volverá a ser considerada en la siguiente corrida del job.
              UPDATE OPERACION.TRANSACCIONES
              SET FECFIN = sysdate
              WHERE IDFAC = c_cor.idfac AND (FECFIN IS NULL) AND (TRANSACCION IN ('SUSPENSION'));

       --REQ 85754  Considerar Telefonia  y Claro Empresa
       elsif c_cor.tipo in(1,2) then
             -- inserta el corte a la que se le asignará una SOT con el procedimiento que corre con el JOB
               INSERT INTO OPERACION.TRANSACCIONES (IDFAC, NOMABR, CODCLI, TRANSACCION, CODUSU, IDTRANSORI, TIPO)
              VALUES (c_cor.idfac,c_cor.nomabr,c_cor.codcli, 'CORTE', user,c_cor.idtrans,c_cor.tipo);
              -- cierra la suspensión correspondiente, no volverá a ser considerada en la siguiente corrida del job.
              UPDATE OPERACION.TRANSACCIONES
              SET FECFIN = sysdate
              WHERE IDFAC = c_cor.idfac AND (FECFIN IS NULL) AND (TRANSACCION IN ('SUSPENSION'));

       end if;

     end;
  end loop;
--------------------------------------------------
---ester codigo se debe poner en todos los stores
---que se llaman con un job
--para ver si termino satisfactoriamente
/*sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);

------------------------
exception
  when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);*/

  END;



/**********************************************************************
Genera las sots para clc
**********************************************************************/

  PROCEDURE p_enviamailcentral(v_codsolot solot.codsolot%type,v_idwf wf.idwf%type)
  IS
  l_flgenviar number;
  l_codcli vtatabcli.codcli%type;
  l_nomcli vtatabcli.nomcli%type;
  l_codsolot solot.codsolot%type;
  l_tiptra tiptrabajo.descripcion%type;
  l_motivo motot.descripcion%type;
  ls_titulo varchar2(100);
  ls_texto varchar2(4000);

  cursor cur_det is
/*  select ltrim(t.nomabr) nomabr,ltrim(ts.DSCSRV) servicio,i.direccion||' - '|| NOMDST||'/'||NOMPVC||'/'||NOMEST direccion, i.descripcion sucursal
         from dettransacciones t,
           inssrv i,
           V_UBICACIONES d,
           tystabsrv ts
      where t.idtrans = v_idtrans and
            t.codinssrv = i.codinssrv and
            i.codubi = d.codubi(+) and
            i.codsrv = ts.codsrv (+)
            order by nomabr;*/
   select it.clg_num nomabr, si.codinssrv servicio, si.descripcion sucursal, si.direccion,it.descripcion resultado,it.command comando, decode (it.abrirtarea,0,'NO',1,'SI') error
   from interftelefonialog it, solotpto sp, inssrv si
   where it.idwf = v_idwf and
      sp.codsolot = v_codsolot and
      sp.codinssrv = si.codinssrv and
      it.clg_num = si.numero
      order by 1 ;


 -- cRutaArchivo constant varchar2(100) := '/u03/oracle/PESGAPRD/UTL_FILE';
--  ls_enter constant varchar2(4) := chr(10) || chr(13);
  hArch UTL_FILE.FILE_TYPE;
  vNomArch varchar2(100);

  BEGIN

  vNomArch := 'CORCENTRAL.htm';
  hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'w');
  l_flgenviar := 0;


  UTL_FILE.PUT_LINE(hArch,'<html>');
  UTL_FILE.PUT_LINE(hArch,'<head>');
  UTL_FILE.PUT_LINE(hArch,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
  UTL_FILE.PUT_LINE(hArch,'<title>Transaccion Central - Telefonia Fija</title>');
  UTL_FILE.PUT_LINE(hArch,'</head>');
  UTL_FILE.PUT_LINE(hArch,'<body>');
  UTL_FILE.PUT_LINE(hArch,'<p><font color="#3366FF">TRANSACCION: - '||to_char(sysdate,'dd/mm/yyyy hh24:mi') ||  '</font> </p>');

  --UTL_FILE.FCLOSE(hArch);

  select v.codcli,v.nomcli,s.codsolot, t.descripcion,m.descripcion
  into l_codcli,l_nomcli,l_codsolot,l_tiptra,l_motivo
  from vtatabcli v, solot s, tiptrabajo t, motot m
  where s.codsolot =v_codsolot  and
        s.codcli = v.codcli and
        s.tiptra = t.tiptra and
        s.codmotot = m.codmotot;

   -----------------cabecera--------------------------------------
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
  ls_texto := ls_texto ||'    Tipo</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="2">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    '|| l_tiptra||'</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||' </tr>'|| chr(13) || chr(10);
  UTL_FILE.PUT_LINE(hArch,ls_texto);

  ls_texto := '  <tr>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="3" bgcolor="#3366FF" width="20%">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Motivo</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <td colspan="2">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    '|| l_motivo||'</span></td>'|| chr(13) || chr(10);
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

  ls_texto := ls_texto ||'    <td align="center" width="12%" bgcolor="#3366FF">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Resultado</span></td>'|| chr(13) || chr(10);

  ls_texto := ls_texto ||'    <td align="center" width="12%" bgcolor="#3366FF">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Comando</span></td>'|| chr(13) || chr(10);

  ls_texto := ls_texto ||'    <td align="center" width="12%" bgcolor="#3366FF">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black; font-weight: 700">'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'    Error</span></td>'|| chr(13) || chr(10);
  ls_texto := ls_texto ||'  </tr>'|| chr(13) || chr(10);
  UTL_FILE.PUT_LINE(hArch,ls_texto);
   ---------------------------------------------------------------
   ----------------detalle --------------------------------------
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

          ls_texto := ls_texto ||'    <td width="41%">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    '|| c_det.resultado||'</span></td>'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <td width="41%">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    '|| c_det.comando||'</span></td>'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <td width="41%">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    <span style="font-size: 8.0pt; font-family: Courier New; color: black">'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'    '|| c_det.error||'</span></td>'|| chr(13) || chr(10);
          ls_texto := ls_texto ||'  </tr>'|| chr(13) || chr(10);
          UTL_FILE.PUT_LINE(hArch,ls_texto);

        end;
      end loop;



   ls_texto := '</table>';
   ls_texto := '<hr>';
   UTL_FILE.PUT_LINE(hArch,ls_texto);

   --------------------------------------------------------------







/*
   for c_tra in cur_tra loop
     begin

        p_enviar_notificacionesxnumero(c_tra.idtrans,'CORCENTRAL.htm');
        l_flgenviar := 1;


     end;
      end loop;*/



      -- hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'a');
       UTL_FILE.PUT_LINE(hArch,'</body>');
       UTL_FILE.PUT_LINE(hArch,'</html>');
       UTL_FILE.FCLOSE(hArch);
 /*      p_envia_correo_c_attach('Transacciones - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'luis.olarte','Transacciones - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
       p_envia_correo_c_attach('Transacciones - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CONMUTACION','Transacciones - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
*/

  END;

procedure p_aviso_reportes
is

/*------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.PQ_CORTESERVICIO.P_AVISO_REPORTES';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='283-IV';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
--------------------------------------------------*/


noRec number;
sotVen number;
begin

-- SOTs canceladas pero no reconectadas
select count(1) into noRec   --distinct t.codcli, v.nomcli, vs.dscsegmark, t.nomabr, c.feccan, c.sersut||'-'||c.numsut numdoc, c.fecven, c2.codtipcan
  from transacciones t, solot s, cxctabfac c, vtatabcli v, vtatabsegmark vs, cxcctacte c1, cxccanfac c2
 where t.transaccion = 'ACTIVACION'
   and t.tipo not in(1,2,4)--34.0 (solo se deja tpi)
   and t.codsolot = s.codsolot(+)
   and (t.codsolot is null or s.estsol not in (12))
   and ESTTRANS <> 'CANCELADA' -- 108
   and t.idfac = c.idfac
   and t.codcli = v.codcli
   and v.codsegmark = vs.codsegmark
   and c.idfac = c1.idfac (+)
   and c1.iddoc = c2.iddoc (+);

    if noRec > 0 then
--       p_envia_correo_c_attach('No Reconectados - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-GestoresdeCreditosyCobranzas@claro.com.pe','No se generaron SOTs de reconexión para clientes que cancelaron su deuda o fueron enviados a corte por web. Por favor verificar el reporte en la web (Ruta: Claro WEB\ Reportes y Consultas\ Reporte de Clientes no Reconectados)',null,'SGA');
--       p_envia_correo_c_attach('No Reconectados - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'augusto.carrillo@claro.com.pe','No se generaron SOTs de reconexión para clientes que cancelaron su deuda o fueron enviados a corte por web. Por favor verificar el reporte en la web (Ruta: Claro WEB\ Reportes y Consultas\ Reporte de Clientes no Reconectados)',null,'SGA');
       --p_envia_correo_c_attach('No Reconectados - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'ysabel.marquez@claro.com.pe','No se generaron SOTs de reconexión para clientes que cancelaron su deuda o fueron enviados a corte por web. Por favor verificar el reporte en la web (Ruta: CLARO WEB\ Reportes y Consultas\ Reporte de Clientes no Reconectados)',null,'SGA');
       --p_envia_correo_c_attach('No Reconectados - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'juan.garcia@claro.com.pe','No se generaron SOTs de reconexión para clientes que cancelaron su deuda o fueron enviados a corte por web. Por favor verificar el reporte en la web (Ruta: CLARO WEB\ Reportes y Consultas\ Reporte de Clientes no Reconectados)',null,'SGA');
       p_envia_correo_c_attach('No Reconectados - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CortesyReconexiones@claro.com.pe','No se generaron SOTs de reconexión para clientes que cancelaron su deuda o fueron enviados a corte por web. Por favor verificar el reporte en la web (Ruta: CLARO WEB\ Reportes y Consultas\ Reporte de Clientes no Reconectados)',null,'SGA');--32.0

    end if;

-- SOTs no ejecutadas en los dos días permitidos -- 26
select count(1) into sotVen  --s.codsolot, s.fecapr, s.codusu, s.codcli, v.nomcli, vs.dscsegmark, t.nomabr, c.feccan, c2.codtipcan
from solot s, transacciones t, cxctabfac c, cxcctacte c1, cxccanfac c2, vtatabcli v, vtatabsegmark vs
where tiptra = 4
and t.tipo not in(1,2,3,4)--34.0
and codmotot = 126
and estsol not in (12,13,15,29)
and trunc(s.fecusu) + 1 <= trunc(sysdate)
and s.codsolot = t.codsolot (+)
and t.idfac = c.idfac (+)
and c.idfac = c1.idfac (+)
and c1.iddoc = c2.iddoc (+)
and s.codcli = v.codcli
and v.codsegmark = vs.codsegmark;

    if sotVen > 0 then
--       p_envia_correo_c_attach('No Reconectados - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-GestoresdeCreditosyCobranzas@claro.com.pe','Existen SOTs de Reconexión aún no atendidaas y próximas a cumplir el límite de días permitidas. Por favor verificar el reporte en la web (Ruta: CLARO WEB\ Reportes y Consultas\ Reporte de SOTs No Atendidas)',null,'SGA');
--       p_envia_correo_c_attach('No Reconectados - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'augusto.carrillo@claro.com.pe','Existen SOTs de Reconexión aún no atendidaas y próximas a cumplir el límite de días permitidas. Por favor verificar el reporte en la web (Ruta: CLARO WEB\ Reportes y Consultas\ Reporte de SOTs No Atendidas)',null,'SGA');
       --p_envia_correo_c_attach('No Reconectados - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'ysabel.marquez@claro.com.pe','Existen SOTs de Reconexión aún no atendidaas y próximas a cumplir el límite de días permitidas. Por favor verificar el reporte en la web (Ruta: CLARO WEB\ Reportes y Consultas\ Reporte de SOTs No Atendidas)',null,'SGA');
       --p_envia_correo_c_attach('No Reconectados - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'juan.garcia@claro.com.pe','Existen SOTs de Reconexión aún no atendidaas y próximas a cumplir el límite de días permitidas. Por favor verificar el reporte en la web (Ruta: CLARO WEB\ Reportes y Consultas\ Reporte de SOTs No Atendidas)',null,'SGA');
       p_envia_correo_c_attach('No Reconectados - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CortesyReconexiones@claro.com.pe','Existen SOTs de Reconexión aún no atendidaas y próximas a cumplir el límite de días permitidas. Por favor verificar el reporte en la web (Ruta: CLARO WEB\ Reportes y Consultas\ Reporte de SOTs No Atendidas)',null,'SGA');--32.0

    end if;

--------------------------------------------------
---ester codigo se debe poner en todos los stores
---que se llaman con un job
--para ver si termino satisfactoriamente
/*sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);

------------------------
exception
  when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);*/

end;

FUNCTION f_cuenta_ptos_paq( v_codcli solot.codcli%type, v_idpaq number) return number
IS

  l_cont number;

  BEGIN

  select count(1) into l_cont
  from vtadetptoenl vs, inssrv so
  where vs.idinsxpaq = v_idpaq and
        vs.numslc = so.numslc and
        vs.numpto = so.numpto and
       -- so.estinssrv = 1 and --solo activas
        so.codcli = v_codcli
        and so.estinssrv not in (3,4); -- condición para que no se consideren servicios cancelados o sin activar

  return l_cont;

  END;

PROCEDURE p_depura__transacciones
  IS


  l_codcli vtatabcli.codcli%type;
  l_nomabr transacciones.nomabr%type;

  min_idtrans transacciones.idtrans%type;

  cursor cur_trans is
    select distinct t.codcli, t.nomabr, t.transaccion, t.tipo
      from transacciones t,
           (select count(1), nomabr, codcli, transaccion, tipo
              from transacciones
             where codsolot is null
               and fecini is null
               and fecfin is null
             group by nomabr, codcli, transaccion, tipo
            having count(1) > 1
             order by 2, 1, 3) tr
     where t.codcli = tr.codcli
       and t.tipo not in(1,2,3,4)--34.0
       and t.nomabr = tr.nomabr
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
            from transacciones t
           where t.codcli = all_trans.codcli
             and t.nomabr = all_trans.nomabr
             and t.transaccion = all_trans.transaccion
             and t.tipo=all_trans.tipo
             and t.codsolot is null
             and t.fecini is null
             and t.fecfin is null
           group by t.codcli, t.nomabr, t.transaccion, t.tipo;

             BEGIN
               update transacciones
                  set fecini = sysdate, fecfin = sysdate, esttrans = 'CANCELADA'
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
      p_envia_correo_c_attach('Cortes y Reconexiones',
                                              'DL-PE-ITSoportealNegocio@claro.com.pe',--30.0
                                              'Ocurrió un error en el proceso de depuración de transacciones (operacion.pq_corteservicio.p_depura__transacciones)' ||
                                              ', CODCLI: ' || l_codcli ||
                                              ', NUMERO: ' || l_nomabr,
                                              null,
                                              'SGA');--30.0
  END;


FUNCTION f_verifica_baja( v_codcli transacciones.codcli%type, v_nomabr transacciones.nomabr%type ) return number
  IS

    l_tiene_baja number;
    sid_actual INSSRV.CODINSSRV%TYPE;
    hay_sid_actual number;

  BEGIN
        /*Se identifica el último servicio asociado al número de teléfono y al cliente. No se consideran servicios sin activar (estado = 4)*/
 --       select count(codinssrv) into hay_sid_actual from INSSRV WHERE numero = v_nomabr and codcli = v_codcli and estinssrv not in (4); --<23.0>
          --Ini 31.0
          l_tiene_baja:= 0;
          --Fin 31.0
          select count(i.codinssrv)
            into hay_sid_actual
            from INSSRV i, tystabsrv tys
           WHERE i.codsrv = tys.codsrv
             and i.numero = v_nomabr
             and i.codcli = v_codcli
             and i.estinssrv not in (4)
             and tys.idproducto not in (522);  --<23.0> No se consideran SIDs de venta de equipos (para el mismo CID y CODCLI de la instalación)

        if hay_sid_actual > 0 then

           -- select max(codinssrv) into sid_actual from INSSRV WHERE numero = v_nomabr and codcli = v_codcli and estinssrv not in (4); --<23.0>

            select max(codinssrv)
              into sid_actual
              from INSSRV i, tystabsrv tys
             WHERE i.codsrv = tys.codsrv
               and i.numero = v_nomabr
               and i.codcli = v_codcli
               and i.estinssrv not in (4)
               and tys.idproducto not in (522);  --<23.0> No se consideran SIDs de venta de equipos (para el mismo CID y CODCLI de la instalación)

            /*Se verifica si existe una baja atendida, cerrada o pendiente por fecha de compromiso*/
            SELECT count(1) INTO l_tiene_baja
            FROM SOLOT S, SOLOTPTO SP, INSSRV I
            , opedd O--38.0
            WHERE I.NUMERO = v_nomabr
            AND I.CODINSSRV = SP.CODINSSRV
            AND SP.CODSOLOT = S.CODSOLOT
            --Ini 27.0
            --AND S.TIPTRA = 5
            --AND S.TIPTRA IN (5,403,374)  38.0
            --Fin 27.0
            AND S.CODCLI = v_codcli
            AND (S.ESTSOL IN (29,12) )
            --<9.0 /*or TRUNC(S.FECCOM) <= TRUNC(SYSDATE)*/) --Para que se considere SOTs atendidas y cerradas  9.0>
            and I.CODINSSRV = sid_actual
            and o.tipopedd =562 and s.tiptra = o.codigon;--38.0
         end if;

         return l_tiene_baja; -- 0 si no existe baja, 1 si existe una baja.
  END;
 PROCEDURE  p_genera_trans_BAJA
  IS

/*------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.PQ_CORTESERVICIO.P_GENERA_TRANS_BAJA';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='283-III';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
--------------------------------------------------*/

  -- obtiene el registro de la suspensión sobre la que se va a reconectar la línea por medio del nombre del cliente
  cursor cur_baja is

  SELECT T.idtrans, T.idfac, T.nomabr, T.codcli, T.transaccion, T.tipo, a.sldact, v.nomcli, c.descripcion, a.sersut||'-'||a.numsut, a.fecemi, a.fecven
  FROM OPERACION.TRANSACCIONES T, cxctabfac a, categoria c, vtatabcli v, solot s, estsol e
  WHERE tipo <> 3 and TRANSACCION = 'CORTE' AND T.FECFIN IS NULL -- 1692
  and t.tipo not in(1,2,3,4)--34.0
  AND T.IDFAC = a.IDFAC AND T.CODCLI = TO_NUMBER(v.codcli)
  AND v.idcategoria = c.idcategoria (+) and s.codsolot = t.codsolot
  and s.fecfin + 30 < sysdate and s.estsol = e.estsol and e.estsol = 12
  AND a.estfacrec = 0
  and a.flgcarcomp = 0 -- se incluye condicion para que no se consideren clientes refinanciados 05/09/2008
 /*< se comenta para la generación de SOTs de Baja de manera masiva REQ. 98028
  and ( T.fecregavisusp is not null and trunc(sysdate) > OPERACION.F_GET_FECHA_UTIL(T.fecregavisusp,7) ) -- REQ 87291
 >*/
 -- and s.codsolot=617345
  /*--<17.0 and (T.Codcli,T.Nomabr) not in (
      select i.codcli, i.numero
      from solotpto sp, inssrv i, solot s
      where sp.codinssrv = i.codinssrv
      and sp.codsolot = s.codsolot
      and s.tiptra in  (5)
      and s.estsol in (12,29)
  )*/
  --ini 29.0
 /*and not exists
     (select 1
      from solotpto sp, inssrv i, solot s
      where sp.codinssrv = i.codinssrv
      and sp.codsolot = s.codsolot
      and i.numero=t.nomabr
      and i.codcli=t.codcli
      and s.tiptra in  (5)
      --and s.estsol in (12,29) )--17.0>
      and s.estsol in(12,27,28,29));*/ --<19.0> No se consideran los estados en transferido ATC o Legal.
  and f_verifica_baja( t.codcli, t.nomabr) = 0;
 --fin 29.0
BEGIN
  for c_cor in cur_baja loop
     begin
           -- inserta el corte a la que se le asignará una SOT con el procedimiento que corre con el JOB
            INSERT INTO OPERACION.TRANSACCIONES (IDFAC, NOMABR, CODCLI, TRANSACCION, CODUSU, IDTRANSORI, TIPO)
            VALUES (c_cor.idfac,c_cor.nomabr,c_cor.codcli, 'BAJATOTAL', user,c_cor.idtrans,c_cor.tipo);
            -- cierra la suspensión correspondiente, no volverá a ser considerada en la siguiente corrida del job.
            UPDATE OPERACION.TRANSACCIONES
            SET FECFIN = sysdate
            WHERE IDFAC = c_cor.idfac AND (FECFIN IS NULL) AND (TRANSACCION IN ('CORTE'));
     end;
  end loop;

--------------------------------------------------
---ester codigo se debe poner en todos los stores
---que se llaman con un job
--para ver si termino satisfactoriamente
/*sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);

------------------------
exception
  when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);*/

END;

PROCEDURE p_genera_baja
  IS
  l_codsolot solot.codsolot%type;
  l_flgenviar number;
  l_inspaq vtadetptoenl.idinsxpaq%type;
  l_cant_puntos number;
  l_cant_ptos_locut number;
  n_hayTipsr number;
  n_tipsrv tystipsrv.tipsrv%type;

  cursor cur_tra is
  select *
  from transacciones
  where transaccion in('BAJATOTAL')
  and fecini is null
  --ini 34.0
  --and tipo not in (3); -- Se incluye el tipo 3 para TPI
  and tipo not in(1,2,4); --Solo se deja tpi
  --fin 34.0

/*  cRutaArchivo constant varchar2(100) := '/u03/oracle/PESGAPRD/UTL_FILE';
  ls_enter constant varchar2(4) := chr(10) || chr(13);*/
  hArch UTL_FILE.FILE_TYPE;
  vNomArch varchar2(100);
    l_verifREc number;
    l_nomcli vtatabcli.nomcli%type;
    --tienebaja number;-- 33.0

  cursor cur_inspaq(c_idfac cxctabfac.idfac%type) is
    select distinct vs.idinsxpaq
    from  bilfac b, cr, instanciaservicio sb,inssrv so, vtadetptoenl vs
    where b.idfaccxc = c_idfac and
          b.idbilfac = cr.idbilfac and
          cr.nivel = 2 and
          cr.idcod = sb.idinstserv and
          sb.codinssrv = so.codinssrv and
          so.numslc = vs.numslc
          and so.estinssrv <> 3    -- solo los servicios suspendisos pues existe una suspension previa
     union
     select distinct vs.idinsxpaq
     from  bilfac b, instanciaservicio sb,inssrv so, vtadetptoenl vs
     where b.idfaccxc = c_idfac and
            b.idisprincipal = sb.idinstserv and
            sb.codinssrv = so.codinssrv and
            so.numslc = vs.numslc
            and so.estinssrv <> 3  ;  -- solo los servicios suspendisos pues existe una suspension previa

  BEGIN

  vNomArch := 'BAJA.htm';
  hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'w');
  l_flgenviar := 0;

  UTL_FILE.PUT_LINE(hArch,'<html>');
  UTL_FILE.PUT_LINE(hArch,'<head>');
  UTL_FILE.PUT_LINE(hArch,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
  UTL_FILE.PUT_LINE(hArch,'<title>Baja por falta de pago - Todos los servicios</title>');
  UTL_FILE.PUT_LINE(hArch,'</head>');
  UTL_FILE.PUT_LINE(hArch,'<body>');
  UTL_FILE.PUT_LINE(hArch,'<p><font color="#3366FF">BAJAS POR FALTA DE PAGO: - '||to_char(sysdate,'dd/mm/yyyy hh24:mi') ||  '</font> </p>');

  UTL_FILE.FCLOSE(hArch);

   for c_tra in cur_tra loop
     begin

     --ini 33.0
     /*select count(1) into tienebaja
                    from solot S1, SOLOTPTO SP, INSSRV I
                    where S1.codcli = c_tra.codcli
                    and c_tra.nomabr = I.NUMERO
                    and I.CODINSSRV = SP.CODINSSRV
                    and SP.CODSOLOT = S1.CODSOLOT
                    and S1.tiptra in (5)
                    and S1.estsol in (12,29);*/
      --fin 33.0

        --if (f_verdocpendiente(c_tra.idfac) = 0 or tienebaja > 0 ) then
        /*-- Req.98551 --*/
        --ini 33.0
        --if (collections.f_get_cxtabfac_adeudados(c_tra.codcli,c_tra.nomabr) = 0 or tienebaja > 0 ) then
         if (collections.f_get_cxtabfac_adeudados(c_tra.codcli,c_tra.nomabr) = 0 or f_verifica_baja( c_tra.codcli, c_tra.nomabr) > 0 ) then
        --fin 33.0
        /*-- Fin Req.98551 --*/
        begin
            update transacciones set fecini = sysdate, fecfin = sysdate where idtrans = c_tra.idtrans ;
             -- inserta la reconexión a la que se le asignará una SOT con el procedimiento que corre con el JOB (a partir del corte obtenido)
             --ini 33.0
            --if (tienebaja = 0) then
            if (f_verifica_baja( c_tra.codcli, c_tra.nomabr) = 0) then
            --fin 33.0
                 INSERT INTO OPERACION.TRANSACCIONES (IDFAC, NOMABR, CODCLI, TRANSACCION, CODUSU, IDTRANSORI, TIPO)
                 VALUES (c_tra.idfac,c_tra.nomabr,c_tra.codcli, 'ACTIVACION', user,c_tra.idtransori,c_tra.tipo);
            end if;

        end;
        else
            if c_tra.tipo = 1 then -- inicio telefonía analógica
              l_verifREc := F_VERIFICARECIBO(c_tra.idfac);
              if (l_verifREc = 0) then --es analogica
                  -- No se genera la SOT, se indica al usuario que genere la SOT manual.
                        update transacciones set esttrans = 'PENDIENTE' --fecini = sysdate, codsolot = l_codsolot
                        where idtrans = c_tra.idtrans ;
                        select nomcli into l_nomcli
                        from vtatabcli
                        where codcli = c_tra.codcli;

                        --p_envia_correo_c_attach('Baja del servicio - Telefonía fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'ysabel.marquez@claro.com.pe','No se genero la SOT de baja  por no encontrarse SIDs activos, Es necesario generar una SOT de corte manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
                        --p_envia_correo_c_attach('Baja del servicio - Telefonía fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'juan.garcia@claro.com.pe','No se genero la SOT de baja por no encontrarse SIDs activos, Es necesario generar una SOT de corte manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
                        p_envia_correo_c_attach('Baja del servicio - Telefonía fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CortesyReconexiones@claro.com.pe','No se genero la SOT de baja por no encontrarse SIDs activos, Es necesario generar una SOT de corte manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');--32.0

                end if;
                if (l_verifREc = 1) then --es analogica
                  p_insert_sot(c_tra.codcli,5,'0004',1,37,l_codsolot);
                  p_insert_solotpto_analogica(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac);
                  operacion.pq_solot.p_aprobar_solot(l_codsolot,11);
                  --pq_solot.p_asig_wf(l_codsolot,268);
                  update transacciones set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
                  p_enviar_notificaciones(c_tra.idtrans,'BAJA.htm');
                  l_flgenviar := 1;
                end if;

                if(l_verifREc = 2) then--es pri
                  p_insert_sot(c_tra.codcli,5,'0004',1,37,l_codsolot);
                  p_insert_solotpto_pri(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac);
                  operacion.pq_solot.p_aprobar_solot(l_codsolot,11);
                  --pq_solot.p_asig_wf(l_codsolot,268);
                  update transacciones set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
                  p_enviar_notificaciones(c_tra.idtrans,'BAJA.htm');
                  l_flgenviar := 1;
                end if;

              -- fin telefonía analógica
              elsif c_tra.tipo = 2 then  -- inicio Claro Empresa
                    for c_inspaq in cur_inspaq(c_tra.idfac) loop
                      begin
                        l_inspaq := c_inspaq.idinsxpaq;
                      end;
                    end loop;

                    if l_inspaq > 0 then

                       p_insert_sot(c_tra.codcli,5,'0058',1,37,l_codsolot); -- datos de SOT de baja
                       p_insert_solotpto_paquete(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac,l_inspaq);
                operacion.pq_solot.p_aprobar_solot(l_codsolot,11);

                          -- Fin Asignar WF de telefonia a servicios de locutorio GORMENO


                        update transacciones set fecini = sysdate, codsolot = l_codsolot, esttrans = 'GENERADA'
                        where idtrans = c_tra.idtrans ;
                        p_enviar_notificaciones(c_tra.idtrans,'BAJA.htm');
                        l_flgenviar := 1;
                    else
                        update transacciones set esttrans = 'PENDIENTE' --fecini = sysdate, codsolot = l_codsolot
                        where idtrans = c_tra.idtrans ;
                        select nomcli into l_nomcli
                        from vtatabcli
                        where codcli = c_tra.codcli;

                      --p_envia_correo_c_attach('Bajas - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'ysabel.marquez@claro.com.pe','No se genero la SOT de baja por no encontrarse SIDs activos, Es necesario generar una SOT de corte manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
                      --p_envia_correo_c_attach('Bajas - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'juan.garcia@claro.com.pe','No se genero la SOT de baja por no encontrarse SIDs activos, Es necesario generar una SOT de corte manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');
                      p_envia_correo_c_attach('Bajas - Xplora - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CortesyReconexiones@claro.com.pe','No se genero la SOT de baja por no encontrarse SIDs activos, Es necesario generar una SOT de corte manual, nro. de servicio: '||c_tra.nomabr||', cliente: '||l_nomcli,null,'SGA');--32.0


                    end if; -- fin Claro Empresa
              elsif c_tra.tipo in (5,6,7,8,9,11) then
                  -- obtengo el tipo de servicio para la SOT
                  select count(tipsrv) into n_hayTipsr
                    from solot
                   where codsolot in
                         (select max(s.codsolot)
                            from inssrv i, cxctabfac c, solot s, solotpto sp
                           where i.numero = c.nomabr
                             and c.idfac = c_tra.idfac
                             and sp.codinssrv = i.codinssrv
                             and s.codsolot = sp.codsolot
                             and s.tiptra = 1
                          /* and s.estsol = 12*/
                          );
                   if (n_hayTipsr > 0) then
                   -- obtengo el tipo de servicio para la SOT
                     select tipsrv into n_tipsrv
                      from solot
                     where codsolot in
                           (select max(s.codsolot)
                              from inssrv i, cxctabfac c, solot s, solotpto sp
                             where i.numero = c.nomabr
                               and c.idfac = c_tra.idfac
                               and sp.codinssrv = i.codinssrv
                               and s.codsolot = sp.codsolot
                               and s.tiptra = 1
                            /* and s.estsol = 12*/
                            );
                    end if;


                FOR C_SOT IN ( select distinct i.tipsrv, i.codsuc
                                from cr, instxproducto ip, instanciaservicio isr, bilfac b, cxctabfac c, inssrv i
                                  where c.idfac = c_tra.idfac and
                                      b.idfaccxc = c.idfac and
                                      cr.idinstprod = ip.idinstprod and
                                      ip.idcod = isr.idinstserv and
                                      ip.codcli = isr.codcli and
                                      cr.idbilfac = b.idbilfac and
                                      isr.codinssrv = i.codinssrv and
                                      isr.codcli = c_tra.codcli)
                LOOP

                    p_insert_sot(c_tra.codcli,5,C_SOT.tipsrv,1,37,l_codsolot);
                    p_insert_solotpto_datos(c_tra.idtrans,l_codsolot,c_tra.codcli,c_tra.idfac,C_SOT.TIPSRV,C_SOT.CODSUC);
                    operacion.pq_solot.p_aprobar_solot(l_codsolot,11);

                END LOOP;

                    update transacciones set fecini = sysdate, codsolot = l_codsolot where idtrans = c_tra.idtrans ;
                    p_enviar_notificaciones(c_tra.idtrans,'BAJA.htm');
                    l_flgenviar := 1;

              end if;

          end if;
     end;
      end loop;

     if l_flgenviar > 0 then
       hArch := UTL_FILE.FOPEN(cRutaArchivo,vNomArch,'a');
       UTL_FILE.PUT_LINE(hArch,'</body>');
       UTL_FILE.PUT_LINE(hArch,'</html>');
       UTL_FILE.FCLOSE(hArch);
  ---     p_envia_correo_c_attach('Bajas - Todos los servicios - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-CONMUTACION@claro.com.pe','Cortes - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
      if l_verifREc = 4 then
            p_envia_correo_c_attach('Bajas - Todos los servicios - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),'DL-PE-TelefoniaPublica@claro.com.pe','Cortes - Telefonia Fija - '||to_char(sysdate,'dd/mm/yyyy hh24:mi'),SendMailJPkg.ATTACHMENTS_LIST(cRutaArchivo||'/'||vNomArch),'SGA');
     END IF;
    end if;

  END;

/****************************************************************************************
Inserta registros de cancelaciones por nota de crédito, para la reconexión del servicio
****************************************************************************************/

PROCEDURE p_insert_cancelacion_nc IS

  cursor cur_cancel_nc is
    SELECT DISTINCT IDFAC, CODCLI, NOMABR
      FROM TRANSACCIONES
     WHERE IDFAC IN (select IDFACCAN
                       from faccanfac
                      where fecusu > to_date('06/08/2008', 'dd/mm/yyyy')
                        AND idfaccan in (select idfac
                                           from transacciones
                                          where transaccion = 'SUSPENSION'
                                            AND FECFIN IS NULL));

BEGIN

  for c_1 in cur_cancel_nc loop
    if (collections.f_get_cxtabfac_adeudados(c_1.codcli, c_1.nomabr) = 0) then

      insert into operacion.reconexionporpago
        (idfac,
         codcli,
         nomabr,
         fecreg,
         usureg,
         flgleido,
         flgreconectado,
         obs)
      values
        (c_1.idfac, c_1.codcli, c_1.nomabr, sysdate, user, 0, 0, '');

    end if;
  end loop;
   commit;
END;
--<24.0>
/*Validación para que tipo de servicios no se les realiza ningún tipo de suspensión.*/
FUNCTION f_valida_concepto(v_idfac in transacciones.idfac%type) return number
  IS
  ln_cpto_valido    number;
  ln_cpto_alquiler  number;
  ln_cpto_total     number;

  BEGIN
  ln_cpto_valido := 1;

   select count(distinct det.idcpto) into ln_cpto_alquiler
   from cxcdetfac det, ope_concepto_alquiler_mae a
   where det.idcpto=a.idcpto
   and a.flg_activo=1
   and det.idfac=v_idfac;

   select count(distinct idcpto) into ln_cpto_total
   from cxcdetfac
   where idfac=v_idfac;

  if ( (ln_cpto_alquiler > 0) and (ln_cpto_total = ln_cpto_alquiler) ) then  --documento cancelado o anulado
     ln_cpto_valido:=0;
  end if;



     RETURN ln_cpto_valido;

  END;
--</24.0>
END PQ_CORTESERVICIO;
/