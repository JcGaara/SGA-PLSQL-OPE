CREATE OR REPLACE PACKAGE OPERACION.PQ_OPE_SIAC_BSCS AS
  /* **********************************************************************************************
  NOMBRE:     PQ_OPE_BSCS
  PROPOSITO:  Interface SIAC_OPERACION BSCS
  PROGRAMADO EN JOB:  NO
  
  REVISIONES:
  Version      Fecha        Autor            Solicitado Por      Descripcion
  ---------  ----------  -----------------   ----------------    ------------------------
  1.0        20/05/2014  Carlos Chamache     Hector Huaman       REQ 164992  Proyecto EVUFC - Traslado Externo
  /* **********************************************************************************************/
  TYPE enviar_direccion_type IS RECORD(
    codsolot solot.codsolot%TYPE,
    codcli   vtatabcli.codcli%TYPE,
    codsuc   vtasuccli.codsuc%TYPE,
    --DIRECCION
    customer_id sales.cliente_sisact.customer_id%TYPE,
    referencia  vtasuccli.referencia%TYPE,
    dirsuc      vtasuccli.dirsuc%TYPE,
    --DIRECCION_INSTALACION
    idplano vtasuccli.idplano%TYPE,
    ubigeo  vtatabdst.ubigeo%TYPE,
    --DIRECCION_FACTURACION
    nomdst v_ubicaciones.nomdst%TYPE,
    nompvc v_ubicaciones.nompvc%TYPE,
    codpos v_ubicaciones.codpos%TYPE,
    nomest v_ubicaciones.nomest%TYPE,
    nompai v_ubicaciones.nompai%TYPE);

  PROCEDURE enviar_direccion_bscs(p_idtareawf NUMBER,
                                  p_idwf      NUMBER,
                                  p_tarea     NUMBER,
                                  p_tareadef  NUMBER);

  PROCEDURE enviar_dir_instalacion(p_idtareawf NUMBER,
                                   p_idwf      NUMBER,
                                   p_error     OUT NUMBER,
                                   p_mensaje   OUT VARCHAR2);

  PROCEDURE enviar_dir_facturacion(p_idtareawf NUMBER,
                                   p_idwf      NUMBER,
                                   p_error     OUT NUMBER,
                                   p_mensaje   OUT VARCHAR2);

  FUNCTION obtener_dir_instalacion(p_idwf NUMBER) RETURN enviar_direccion_type;

  FUNCTION obtener_dir_facturacion(p_idwf NUMBER) RETURN enviar_direccion_type;

  FUNCTION obtener_instancia_siac(p_idprocess      operacion.siac_instancia.idprocess%TYPE,
                                  p_tipo_instancia operacion.siac_instancia.tipo_instancia%TYPE)
    RETURN operacion.siac_instancia.instancia%TYPE;

  FUNCTION obtener_idprocess(p_codsolot solot.codsolot%TYPE)
    RETURN operacion.siac_instancia.idprocess%TYPE;

  FUNCTION llenar_tareawfseg(pp_idtareawf  NUMBER,
                             p_observacion tareawfseg.observacion%TYPE,
                             p_idobserv    tareawfseg.idobserv%TYPE)
    RETURN tareawfseg%ROWTYPE;

  PROCEDURE insertar_tareawfseg(p_tareawfseg tareawfseg%ROWTYPE);

  FUNCTION llenar_int_send_dir_bscs_log(p_tipo       VARCHAR2,
                                        pp_idtareawf NUMBER,
                                        p_direccion  enviar_direccion_type,
                                        p_result     VARCHAR2,
                                        pp_mensaje   VARCHAR2)
    RETURN operacion.int_send_dir_bscs_log%ROWTYPE;

  PROCEDURE insertar_int_send_dir_bscs_log(p_int_send_dir_bscs_log operacion.int_send_dir_bscs_log%ROWTYPE);

  PROCEDURE validar_rpta_dir_envio(p_result VARCHAR2, p_tipo VARCHAR2);

  FUNCTION obtener_solot(p_idwf NUMBER) RETURN solot%ROWTYPE;

  FUNCTION obtener_customer_id(p_codcli sales.vtatabslcfac.codcli%TYPE)
    RETURN sales.cliente_sisact.customer_id%TYPE;

  FUNCTION obtener_tipesttar(p_esttarea esttarea.esttarea%TYPE)
    RETURN esttarea.tipesttar%TYPE;

  FUNCTION llamar_webservice(p_xml VARCHAR2, p_url VARCHAR2) RETURN VARCHAR2;

  FUNCTION extraer_ws_atributo(p_xml VARCHAR2, p_atributo VARCHAR2)
    RETURN VARCHAR2;

  PROCEDURE error_por_envio_direccion(p_idtareawf_padre IN NUMBER, p_result OUT NUMBER);
  
END PQ_OPE_SIAC_BSCS;
/