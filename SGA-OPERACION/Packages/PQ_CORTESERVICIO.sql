CREATE OR REPLACE PACKAGE OPERACION.PQ_CORTESERVICIO AS
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
40.0       01/07/2012  Edilberto Astulle                   PROY-3884_Agendamiento PEXT
******************************************************************************/

cRutaArchivo constant varchar2(100) := '/u03/oracle/PESGAPRD/UTL_FILE';
-- cRutaArchivo constant varchar2(100) := '/u02/oracle/PESGAUAT/UTL_FILE';

 PROCEDURE p_genera_transaccion;

 PROCEDURE p_genera_suspencion;

 PROCEDURE p_genera_suspencion_datos;

 PROCEDURE p_genera_suspencion_xplora;

 PROCEDURE p_genera_corte_xplora;

 PROCEDURE p_genera_corte;

 PROCEDURE p_genera_corte_datos;

 PROCEDURE p_genera_reconexion;

 PROCEDURE p_genera_reconexion_datos;

 PROCEDURE p_genera_reconexion_xplora;

 PROCEDURE p_insert_sot(v_codcli in solot.codcli%type,
                        v_tiptra in solot.tiptra%type,
                        v_tipsrv in solot.tipsrv%type,
                        v_grado in solot.grado%type,
                        v_motivo in solot.codmotot%type,
                        v_codsolot out number );

FUNCTION f_verdocpendiente(v_idfac in transacciones.idfac%type) return number;

FUNCTION F_VERIFICARECIBO(v_idfac in transacciones.idfac%type) return number;

FUNCTION F_VERIFICANUMERO(v_numero in numtel.numero%type) return number;

PROCEDURE p_insert_solotpto_cab(v_idtrans transacciones.idtrans%type,
                                       v_codsolot solot.codsolot%type,
                                       v_codcli solot.codcli%type,
                                       v_idfac cxctabfac.idfac%type);

PROCEDURE p_insert_solotpto_analogica(v_idtrans transacciones.idtrans%type,
                                       v_codsolot solot.codsolot%type,
                                       v_codcli solot.codcli%type,
                                       v_idfac cxctabfac.idfac%type);

PROCEDURE p_insert_solotpto_datos(v_idtrans transacciones.idtrans%type,
                                        v_codsolot solot.codsolot%type,
                                        v_codcli solot.codcli%type,
                                        v_idfac cxctabfac.idfac%type,
                                        V_TIPSRV INSSRV.TIPSRV%TYPE,
                                        V_CODSUC INSSRV.CODSUC%TYPE);

PROCEDURE p_insert_solotpto_pri(v_idtrans transacciones.idtrans%type,
                                 v_codsolot solot.codsolot%type,
                                 v_codcli solot.codcli%type,
                                 v_idfac cxctabfac.idfac%type);

PROCEDURE p_insert_solotpto_paquete(v_idtrans transacciones.idtrans%type,
                                        v_codsolot solot.codsolot%type,
                                        v_codcli solot.codcli%type,
                                        v_idfac cxctabfac.idfac%type,
                                        v_idpaq number);

PROCEDURE p_insert_solotpto_tpi(v_idtrans transacciones.idtrans%type,
                                        v_codsolot solot.codsolot%type,
                                        v_codcli solot.codcli%type,
                                        v_idfac cxctabfac.idfac%type);

PROCEDURE p_cargapretransaccion;

PROCEDURE p_enviar_notificaciones(v_idtrans transacciones.idtrans%type,
                                     v_archivo varchar2          );

PROCEDURE p_enviar_notificacionesxnumero(v_idtrans transacciones.idtrans%type,
                                    v_archivo varchar2          );

PROCEDURE p_genera_transaccionCLC;

PROCEDURE p_genera_CLC;

PROCEDURE p_genera_RECCLC;

PROCEDURE p_insert_solotpto_CLC(v_idtrans transacciones.idtrans%type,
                                        v_codsolot solot.codsolot%type,
                                        v_codcli solot.codcli%type);

PROCEDURE p_actestadofac(v_codsolot solot.codsolot%type);

PROCEDURE p_genera_transaccion_RECCLC(v_idfac COLLECTIONS.CXCTABFAC.IDFAC%type,
                                       v_codcli COLLECTIONS.CXCTABFAC.CODCLI%type,
                                       v_nomabr COLLECTIONS.CXCTABFAC.NOMABR%type);

PROCEDURE p_genera_transaccion_RECONEX(v_idfac COLLECTIONS.CXCTABFAC.IDFAC%type,
                                        v_codcli COLLECTIONS.CXCTABFAC.CODCLI%type,
                                        v_nomabr COLLECTIONS.CXCTABFAC.NOMABR%type);

PROCEDURE p_genera_transaccion_RECXPLORA(v_idfac COLLECTIONS.CXCTABFAC.IDFAC%type,
                                          v_codcli COLLECTIONS.CXCTABFAC.CODCLI%type,
                                          v_nomabr COLLECTIONS.CXCTABFAC.NOMABR%type);

PROCEDURE p_genera_rec_por_fac_cancelada;

PROCEDURE p_enviamailcentral(v_codsolot solot.codsolot%type,
                                         v_idwf wf.idwf%type);

PROCEDURE  p_genera_trans_SUSP;

PROCEDURE  p_genera_trans_CORTE;

procedure p_aviso_reportes;

FUNCTION f_cuenta_ptos_paq( v_codcli solot.codcli%type, v_idpaq number) return number;

PROCEDURE p_depura__transacciones;


FUNCTION f_verifica_baja( v_codcli transacciones.codcli%type, v_nomabr transacciones.nomabr%type ) return number;

PROCEDURE p_genera_trans_baja;

PROCEDURE p_genera_baja;

PROCEDURE p_insert_cancelacion_nc;

FUNCTION f_valida_concepto(v_idfac in transacciones.idfac%type) return number;

END PQ_CORTESERVICIO;
/