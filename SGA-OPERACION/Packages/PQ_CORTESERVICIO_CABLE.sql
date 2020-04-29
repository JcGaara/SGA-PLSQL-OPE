CREATE OR REPLACE PACKAGE OPERACION.PQ_CORTESERVICIO_CABLE AS

/******************************************************************************
   NAME:       PQ_CORTESERVICIO_CABLE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        01/01/2006  Gustavo Ormeño.     1. Created this package.
   2.0        03/01/2006  Gustavo Ormeño.     1. Lógica de suspensiones.
   3.0        02/02/2008  Gustavo Ormeño.     1. Cambio en condicion para generar un corte automático.
   4.0        10/03/2008  Gustavo Ormeño.     1. Nuevas condiciones para suspender
   5.0        06/08/2008  Gustavo Ormeño.     1. Se adicionan suspensiones, cortes y reconexiones Triple Play.
   6.0        22/04/2009  Hector Huaman       REQ-90111: Se creo el procedmiento p_depura__transacciones_cable que depura los registros que fueron ingresados duplicados para una misma línea, cliente, transaccion y tipo de servicio.
   7.0        22/04/2009  Hector Huaman       REQ-90566: se modifico la funcion f_servicio_cablesat, que envie alertas cuando tenga dos PID activos en la tabla reginsdth
   8.0        24/04/2009  Hector Huaman       REQ-90757: cambio del correo eduardo.rojas@telmex.com por el de carlos.teran@telmex.com
   9.0        08/05/2009  Joseph Asencios     REQ-84617:Se agregó lógica para envio de archivos de activación de bouquets adicionales en cancelación de recibos.
  10.0        19/05/2009  Hector Huaman       REQ-93065:Se se modifico el procedimiento p_genera_corte_CABLE , se cambio el procedimiento que verifica la deuda
  11.0        19/05/2009  Hector Huaman       REQ-93810:Se se modifico el procedimiento p_cargapretransaccion , para cuando el cliente deba más de 15 soles que se genere suspensión
  12.0        25/05/2009  José Ramos          REQ-100649:Se modifica el procedimiento para agregar una observación de auditoria en el procedimiento operacion.pq_corteservicio_cable.p_genera_rec_fac_cancelada
  13.0        11/08/2009  Hector Huaman       REQ-99721:se creo el procedimiento p_insert_cancelacion_nc_cable para insertar en la tabla operación.reconexionporpago_boga
  14.0        26/08/2009  Hector Huaman       REQ-100447:se crea procedimiento p_insert_cancelacion_nc_cable  para generar suspensiones por retrasos de pago.
  15.0        03/09/2009  José Ramos          REQ-101931:se agrega condición para los estado que no tienen tipo de estado.
  16.0        14/09/2009  José Ramos          REQ-102897:se optimiza query del procedimiento p_cargapretransaccion
  17.0        05/10/2009  José Ramos          REQ-102513:se modifica procedimiento que genera transacciones de susopensiones, para que valida también cortes pendientes
  18.0        14/10/2009  Hector Huaman       REQ-105752:se modifico cursor del procedimiento p_genera_rec_por_fac_cancelada
  19.0        03/11/2009  Joseph Asencios     REQ-107653:Se agregó el uso de la función f_get_fechas_corte al procedimiento p_genera_transaccion, que determina si la fecha actual esta disponible para realizar corte.
  20.0        21/07/2010  Alexander Yong      REQ-134864: TIEMPO SUSPENSION SERVICIO DE CABLE ANALOGICO (SINGLE PLAY ANALOGICO-CATV)
  21.0        11/08/2010  Miguel Aroñe        REQ-114326: Desabilitacion funcionalidad reconexiones DTH Facturable
  22.0        24/09/2010  Antonio Lagos       REQ-142338, Migracion DTH
  23.0        06/10/2010                      REQ.139588 Cambio de Marca
  24.0        08/09/2010  Miguel Aroñe        REQ-129858: Desabilitacion funcionalidad de reconexiones Cable Analogico - single play y Triple Play
 ******************************************************************************/



 cRutaArchivo constant varchar2(100) := '/u03/oracle/PESGAPRD/UTL_FILE';

PROCEDURE p_genera_transaccion;

PROCEDURE p_genera_suspencion_CABLE;

PROCEDURE p_genera_transaccionCLC;

PROCEDURE p_genera_CLC;

PROCEDURE p_genera_RECCLC;

PROCEDURE p_insert_solotpto_CLC(v_idtrans transacciones.idtrans%type,
                                        v_codsolot solot.codsolot%type,
                                        v_codcli solot.codcli%type
                                        ) ;

PROCEDURE p_genera_rec_por_fac_cancelada;

function f_servicio_cablesat(pidfac char, pnumregistro out char, pflg_recarga out number) return number;

PROCEDURE p_genera_transaccion_RECCLC(v_idfac  COLLECTIONS.CXCTABFAC.IDFAC%type,
                                      v_codcli COLLECTIONS.CXCTABFAC.CODCLI%type,
                                      v_nomabr COLLECTIONS.CXCTABFAC.NOMABR%type);


PROCEDURE  p_genera_transaccion_REC_CABLE(v_idfac COLLECTIONS.CXCTABFAC.IDFAC%type,
                                          v_codcli COLLECTIONS.CXCTABFAC.CODCLI%type,
                                          v_nomabr COLLECTIONS.CXCTABFAC.NOMABR%type);

PROCEDURE  p_genera_trans_CORTE_CABLE;

 PROCEDURE p_genera_reconexion_CABLE;

 PROCEDURE p_insert_sot(v_codcli in solot.codcli%type,
                        v_tiptra in solot.tiptra%type,
                        v_tipsrv in solot.tipsrv%type,
                        v_grado in solot.grado%type,
                        v_motivo in solot.codmotot%type,
                        v_codsolot out number );

  PROCEDURE p_insert_solotpto_cable(v_idtrans transacciones.idtrans%type,
                                        v_codsolot solot.codsolot%type,
                                        v_codcli solot.codcli%type,
                                        v_idfac cxctabfac.idfac%type/*,
                                        v_idpaq number*/) ;

  PROCEDURE p_insert_solotpto_cable_dig(v_idtrans transacciones.idtrans%type,
                                        v_codsolot solot.codsolot%type,
                                        v_codcli solot.codcli%type,
                                        v_idfac cxctabfac.idfac%type/*,
                                        v_idpaq number*/) ;

/*  PROCEDURE p_insert_solotpto_cable_DTH(v_idtrans transacciones.idtrans%type,
                                        v_codsolot solot.codsolot%type,
                                        v_codcli solot.codcli%type,
                                        v_idfac cxctabfac.idfac%type) ;
*/
 PROCEDURE p_enviar_notificaciones(v_idtrans transacciones.idtrans%type,
                                     v_archivo varchar2          );

PROCEDURE p_enviar_notificacionesxnumero(v_idtrans transacciones.idtrans%type,
                                    v_archivo varchar2          );

FUNCTION f_verifica_documentos(v_idfac1 in OPERACION.TRANSACCIONES_CABLE.idfac%type, v_idfac2 OPERACION.TRANSACCIONES_CABLE.idfac%type) return number;

PROCEDURE p_cargapretransaccion;

PROCEDURE p_genera_corte_CABLE;

FUNCTION f_verdocpendiente(v_idfac in OPERACION.TRANSACCIONES_CABLE.idfac%type) return number;

FUNCTION f_dias_servicio(v_idfac in cxctabfac.idfac%type) return number;

--FUNCTION f_cuenta_puntos(v_idfac in cxctabfac.idfac%type) return number;

FUNCTION f_verificaVoz(v_nomabr in inssrv.numero%type) return number;

function f_cuenta_puntos_cable(v_idfac cxctabfac.idfac%type) return number;

FUNCTION f_verificanumero(v_numero in numtel.numero%type) return number;

PROCEDURE p_depura__transacciones_cable;

PROCEDURE p_insert_cancelacion_nc_cable; --13.0

END PQ_CORTESERVICIO_CABLE;
/


