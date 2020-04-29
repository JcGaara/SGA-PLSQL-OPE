CREATE OR REPLACE PACKAGE OPERACION.PKG_ACTIVACION_SERVICIOS IS
  /****************************************************************
  '* Nombre Package : OPERACION.PKG_ACTIVACION_SERVICIOS
  '* Proposito : Agrupar funcionalidades para los procesos de Activacion de servicios para Postventa Masivo y CE
  '* Input : --
  '* Output : --
  '* Creado por : Equipo de proyecto TOA
  '* Fec. Creacion : 27/08/2018
  '* Fec. Actualizacion : 18/12/2018
  '* Versión      Fecha       Autor            Solicitado por      Descripción
  '* ---------  ----------  ---------------    ------------------  ------------------------------------------
  '* 1.0         12-12-2018  Abel Ojeda        Abel Ojeda          Correccion para la baja automatica en Cambio de Plan y Traslado Externo
  '* 2.0         18-12-2018  Abel Ojeda        Javier Cornejo      Actualizacion de registros multiples y solo validacion por numero de proyecto
  '****************************************************************/
  c_activo              CONSTANT inssrv.estinssrv%TYPE := 1;
  c_suspendido          CONSTANT inssrv.estinssrv%TYPE := 2;
  c_pendiente_x_activar CONSTANT inssrv.estinssrv%TYPE := 4;
  cv_desc_trx_postv     CONSTANT VARCHAR(40) := 'HFC CE Transacciones Postventa'; --v2.0
  cv_abrv_trx_postv     CONSTANT VARCHAR(20) := 'CEHFCPOST'; --v2.0

  TYPE lc_salida IS REF CURSOR;

  TYPE lr_valores_srv IS RECORD(
    ln_serviceid           NUMBER,
    ls_serviceidentifier   VARCHAR2(100),
    ls_servicename         VARCHAR2(100),
    ls_servicetype         VARCHAR2(100),
    ls_servicestatus       VARCHAR2(100),
    ls_equipmentid         VARCHAR2(100),
    ls_equipmentidentifier VARCHAR2(100),
    ls_equipmentname       VARCHAR2(100),
    ls_equipmenttype       VARCHAR2(100),
    ls_tag                 VARCHAR2(100),
    ln_idproducto          NUMBER,
    ln_idproductopadre     NUMBER,
    ln_idventa             NUMBER,
    ln_idventapadre        NUMBER);

  TYPE lr_qty_srv IS RECORD(
    ln_tlf NUMBER,
    ln_vod NUMBER,
    ln_dtv NUMBER,
    ln_mta NUMBER,
    ln_cm  NUMBER);

  PROCEDURE sgass_servact_sot(pi_codsolot_alta operacion.solot.codsolot%TYPE,
                              pi_codsolot_baja operacion.solot.codsolot%TYPE,
                              pi_co_id_old     NUMBER,
                              pi_customer_id   NUMBER,
                              pi_codcli        VARCHAR2,
                              po_dato          OUT SYS_REFCURSOR);

  PROCEDURE sgass_equact_sot(pi_codsolot_alta operacion.solot.codsolot%TYPE,
                             pi_codsolot_baja operacion.solot.codsolot%TYPE,
                             pi_co_id_old     NUMBER,
                             pi_customer_id   NUMBER,
                             pi_codcli        VARCHAR2,
                             po_dato          OUT SYS_REFCURSOR);

  PROCEDURE sgass_servnew_sot(pi_codsolot_alta operacion.solot.codsolot%TYPE,
                              pi_co_id_old     NUMBER,
                              pi_customer_id   NUMBER,
                              pi_codcli        VARCHAR2,
                              po_dato          OUT SYS_REFCURSOR);

  PROCEDURE sgass_equnew_sot(pi_codsolot_alta operacion.solot.codsolot%TYPE,
                             pi_co_id_old     NUMBER,
                             pi_customer_id   NUMBER,
                             pi_codcli        VARCHAR2,
                             po_dato          OUT SYS_REFCURSOR);

  PROCEDURE sgasi_baja_eqsrv_inc(pi_codsolot operacion.solot.codsolot%TYPE,
                                 pi_envio    NUMBER,
                                 po_iderr    OUT NUMBER,
                                 po_mserr    OUT VARCHAR2);

  FUNCTION sgafun_atributo_valor(n_idtrs NUMBER, v_atributo VARCHAR2)
    RETURN VARCHAR2;

  PROCEDURE sgass_productos_reserva(pi_codsolot operacion.solot.codsolot%TYPE,
                                    po_dato     OUT SYS_REFCURSOR);

  PROCEDURE sgasi_prepa_baja_auto(a_idtareawf IN NUMBER,
                                  a_idwf      IN NUMBER,
                                  a_tarea     IN NUMBER,
                                  a_tareadef  IN NUMBER);

END pkg_activacion_servicios;
/