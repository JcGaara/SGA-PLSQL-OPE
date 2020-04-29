CREATE OR REPLACE PACKAGE OPERACION.pq_janus_alta IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/02/2014  Mauro Zegarra    Christian Riquelme  version inicial
     2.0      08/07/2014  Juan Gonzales    Christian Riquelme  agregar validacion de envio de sucursal
  /* ***************************************************************************/
  PROCEDURE alta;

  PROCEDURE crear_int_telefonia_log;

  PROCEDURE crear_int_plataforma_bscs;

  TYPE linea IS RECORD(
    codcli    inssrv.codcli%TYPE,
    numslc    inssrv.numslc%TYPE,
    idplan    plan_redint.idplan%TYPE,
    codinssrv inssrv.codinssrv%TYPE,
    numero    inssrv.numero%TYPE,
    codsolot  solot.codsolot%TYPE,
    pid       insprd.pid%TYPE);

  FUNCTION get_linea RETURN linea;

  TYPE cliente IS RECORD(
    tipdide   vtatabcli.tipdide%TYPE,
    ntdide    vtatabcli.ntdide%TYPE,
    apellidos int_plataforma_bscs.apellidos%TYPE,
    nomclires vtatabcli.nomclires%TYPE,
    ruc       vtatabcli.ntdide%TYPE,
    razon     vtatabcli.nomcli%TYPE,
    telefono1 vtatabcli.telefono1%TYPE,
    telefono2 vtatabcli.telefono2%TYPE);

  FUNCTION get_cliente RETURN cliente;

  CURSOR sucursal IS
    SELECT v.dirsuc, v.referencia, u.nomdst, u.nompvc, u.nomest
      FROM vtasuccli v, v_ubicaciones u;

  FUNCTION get_sucursal RETURN sucursal%ROWTYPE;

  CURSOR plan IS
    SELECT t.plan, t.plan_opcional FROM plan_redint t;

  FUNCTION get_plan RETURN plan%ROWTYPE;

  FUNCTION get_nomemail RETURN vtaafilrecemail.nomemail%TYPE;

  FUNCTION get_fecini(p_numslc vtatabslcfac.numslc%TYPE) RETURN VARCHAR2;

  FUNCTION get_fecini(p_cicfac fechaxciclo.cicfac%TYPE) RETURN VARCHAR2;

  FUNCTION armar_trama RETURN VARCHAR2;
  --ini 2.0
  FUNCTION trim_dato(p_dato VARCHAR2, p_string VARCHAR2) RETURN VARCHAR2;

  PROCEDURE encode(p_string IN OUT VARCHAR2);
  --fin 2.0
END;
/
