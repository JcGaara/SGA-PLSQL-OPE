CREATE OR REPLACE PACKAGE OPERACION.pq_janus_ce_alta IS
  /************************************************************************************************
   PROPOSITO: Centralizar los procesos de tipo interfaz con las plataformas
              telefonicas
   REVISIONES:
     Version  Fecha       Autor            Solicitado por      Descripcion
     -------  -----       -----             --------------      -----------
     1.0    2014-06-26    Eustaquio Gibaja  Christian Riquelme  version inicial
     2.0    2014-10-20    Jimmy Calle       Christian Riquelme  Asignacion de Ciclo CE
     3.0    2014-09-29    César Quispe      Christian Riquelme  Req. 165094 Configuración Janus Multi Proyecto
     4.0    2014-10-23    Edwin Vasquez     Christian Riquelme  Claro Empresas WiMAX
  /* **********************************************************************************************/
  PROCEDURE alta(p_idtareawf tareawf.idtareawf%type,
                 p_idwf      tareawf.idwf%type,
                 p_tarea     tareawf.tarea%type,
                 p_tareadef  tareawf.tareadef%type);

  PROCEDURE set_variables_genericas;

  PROCEDURE set_linea_x_servicio(p_pid       insprd.pid%TYPE,
                                 p_numslc    insprd.numslc%TYPE, --3.0
                                 p_codinssrv inssrv.codinssrv%TYPE,
                                 p_numero    inssrv.numero%TYPE);

  PROCEDURE set_instancias_x_linea(p_id      telefonia_ce_det.id_telefonia_ce_det%TYPE,
                                   p_idtrans telefonia_ce_det.idtrans%TYPE,
                                   p_trama   int_plataforma_bscs.trama%TYPE);

  PROCEDURE crear_telefonia_ce_det;

  PROCEDURE crear_int_plataforma_bscs;

  function crear_telefonia_ce_det(p_telefonia_ce operacion.telefonia_ce%rowtype,
                                  p_codinssrv    inssrv.codinssrv%type,
                                  p_numero       numtel.numero%type,
                                  p_pid          insprd.pid%type,
                                  p_idtrans      operacion.int_plataforma_bscs.idtrans%type)
    return operacion.telefonia_ce_det.id_telefonia_ce_det%type;

  function crear_int_plataforma_bscs(p_idwf      tareawf.idwf%type,
                                     p_numslc    vtatabslcfac.numslc%type,
                                     p_codinssrv inssrv.codinssrv%type,
                                     p_numero    numtel.numero%type)
    return operacion.int_plataforma_bscs.idtrans%type;

  FUNCTION get_ciclo RETURN opedd.codigoc%type;

  TYPE linea IS RECORD(
    codcli   inssrv.codcli%TYPE,
    numslc   inssrv.numslc%TYPE,
    idplan   plan_redint.idplan%TYPE,
    codsolot solot.codsolot%TYPE);

  FUNCTION get_linea(p_idwf tareawf.idwf%type)  RETURN linea;

  TYPE cliente IS RECORD(
    tipdide   vtatabcli.tipdide%TYPE,
    ntdide    vtatabcli.ntdide%TYPE,
    apellidos int_plataforma_bscs.apellidos%TYPE,
    nomclires vtatabcli.nomclires%TYPE,
    ruc       vtatabcli.ntdide%TYPE,
    razon     vtatabcli.nomcli%TYPE,
    telefono1 vtatabcli.telefono1%TYPE,
    telefono2 vtatabcli.telefono2%TYPE);

  FUNCTION get_cliente(p_codcli vtatabcli.codcli%type) RETURN cliente;

  CURSOR sucursal IS
    SELECT v.dirsuc, v.referencia, u.nomdst, u.nompvc, u.nomest
      FROM vtasuccli v, v_ubicaciones u;

  FUNCTION get_sucursal(p_numslc vtatabslcfac.numslc%type) 
    RETURN sucursal%ROWTYPE;

  CURSOR plan IS
    SELECT t.plan, t.plan_opcional FROM plan_redint t;

  FUNCTION get_plan(p_idplan plan_redint.idplan%type) RETURN plan%ROWTYPE;

  FUNCTION get_nomemail(p_codcli vtatabcli.codcli%type) 
    RETURN vtaafilrecemail.nomemail%TYPE;

  FUNCTION get_fecini(p_numslc vtatabslcfac.numslc%TYPE) RETURN VARCHAR2;

  FUNCTION get_fecini(p_cicfac fechaxciclo.cicfac%TYPE) RETURN VARCHAR2;

  FUNCTION armar_trama(p_linea     linea,
                       p_cliente   cliente,
                       p_sucursal  sucursal%rowtype,
                       p_plan      plan%rowtype,
                       p_codinssrv inssrv.codinssrv%type,
                       p_numero    numtel.numero%type) RETURN VARCHAR2;

 function get_telefonia_ce(p_id_telefonia_ce operacion.telefonia_ce.id_telefonia_ce%type)
    return operacion.telefonia_ce%rowtype;
 
  FUNCTION trim_dato(p_dato VARCHAR2, p_string VARCHAR2) RETURN VARCHAR2;

  PROCEDURE encode(p_string IN OUT VARCHAR2);

END;
/