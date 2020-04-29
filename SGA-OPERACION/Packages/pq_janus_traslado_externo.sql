CREATE OR REPLACE PACKAGE OPERACION.PQ_JANUS_TRASLADO_EXTERNO IS
  /****************************************************************************************************
     NAME:       PQ_JANUS_SOT_TRASLADO_EXTERNO
     PURPOSE:    Ejecutar proceso traslado externo en plataforma JANUS

     REVISIONS:
     Ver        Date        Author            Solicitado por      Description
     ---------  ----------  ---------------   --------------      -----------
     1.0        20/02/2014  Eustaquio Gibaja  Christian Riquelme  Version inicial
     2.0        18/05/2014  Eustaquio Gibaja  Christian Riquelme  Mejoras
     3.0        11/07/2014  Juan Gonzales     Christian Riquelme  Cambio de Orden de transacciones 1 - Baja / 2 - Alta
     4.0        28/01/2015  Eustaquio Giabaja Christian Riquelme  Mejoras en la obtencion del WF de origen
  ***************************************************************************************************/

  TYPE linea IS RECORD(
    codsolot  wf.codsolot%TYPE,
    codinssrv insprd.codinssrv%TYPE,
    pid       insprd.pid%TYPE,
    idplan    tystabsrv.idplan%TYPE,
    codsrv    tystabsrv.codsrv%TYPE,
    codcli    inssrv.codcli%TYPE,
    numslc    inssrv.numslc%TYPE,
    numero    inssrv.numero%TYPE);

  TYPE respuesta IS RECORD(
    codigo  VARCHAR2(3),
    mensaje VARCHAR2(30));

  PROCEDURE EXECUTE(p_idtareawf IN NUMBER,
                    p_idwf      IN NUMBER,
                    p_tarea     IN NUMBER,
                    p_tareadef  IN NUMBER);

  FUNCTION get_timer RETURN opedd.codigon%TYPE; --3.0

  PROCEDURE alta_telefonia;

  PROCEDURE alta;

  PROCEDURE baja;

  FUNCTION get_idwf_origen RETURN tareawfcpy.idwf%TYPE;

  PROCEDURE crear_int_telefonia_log;

  FUNCTION get_id_telefonia RETURN operacion.int_telefonia.id%TYPE;

  PROCEDURE update_int_telefonia;

  PROCEDURE cambio_status_tarea_error;

END;
/
