create or replace package operacion.PKG_SGA_ALINEACION_HFC is
  /****************************************************************************************************
     NOMBRE:        PKG_SGA_ALINEACION_HFC
     DESCRIPCION:   Manejo de SOLOT y Servicios HFC

     Ver        Date        Author              Solicitado por       Descripcion
     ---------  ----------  ------------------- ----------------   ------------------------------------
     1.0        27/04/2017  Danny Sánchez         Sergio Atoche      PROY 28710
  ****************************************************************************************************/

  TYPE t_cursor IS REF CURSOR;
  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        27/04/2017  Danny Sánchez    Alinea los contratos de HFC
  ******************************************************************************/
  procedure SGASU_ALINEAR_CONTRATO(p_estbscs varchar2, p_cod_id operacion.solot.cod_id%type,
    p_resp OUT number, p_mensaje OUT varchar2);

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        27/04/2017  Danny Sánchez       Alineacion de servicios
  ******************************************************************************/
  procedure SGASU_ALINEAR_SERVICIOS(p_codsolot operacion.solot.codsolot%type,
                                   p_estado   number);

/******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        02/05/2017  Danny Sánchez    Obtener datos de la Ultima SOT
  ******************************************************************************/
  procedure SGASS_DATOS_SOT(p_co_id operacion.solot.cod_id%type, p_estbscs varchar2, 
    p_codsolot OUT number, p_estsol OUT number, p_estsolnew OUT number, p_estsrvnew OUT number, 
    p_dias OUT number, p_sotant OUT number);

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        27/04/2017  Danny Sánchez       Cerrar SOT
  ******************************************************************************/
  procedure SGASU_CERRAR_SOT(p_codsolot operacion.solot.codsolot%type);

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        27/04/2017  Danny Sánchez       Anular SOT
  ******************************************************************************/
  procedure SGASU_ANULAR_SOT(p_codsolot operacion.solot.codsolot%type);

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        02/05/2017  Danny Sánchez    Listar errores de EAI
  ******************************************************************************/
  procedure SGASU_CONTRATOS_ERR_EAI(p_resultado OUT t_cursor);

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        02/05/2017  Danny Sánchez    Listar de BSCS
  ******************************************************************************/
   procedure SGASS_CONTRATOS_ERR_BSCS(p_resultado OUT t_cursor);

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        02/05/2017  Danny Sánchez    Cambiar estado en EAI
  ******************************************************************************/
   procedure SGASU_ESTADO_PGR_EAI(p_co_id number, p_servi_cod number,
    p_fecha_reg date, p_estado number, p_mensaje varchar2, p_result OUT VARCHAR2);

  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        02/05/2017  Danny Sánchez    Desactivar contrato en HFC
  ******************************************************************************/
  PROCEDURE SGASU_DESACTIVAR_CONTRATO(p_co_id number, p_servi_cod number,
    p_fecha_reg date, p_resp OUT number);


  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        03/05/2017  Conrad Agüero    Obtener Tickler Siac
  ******************************************************************************/
    procedure SGASS_TICKLER_SIAC(p_cod_id number, p_servi_cod number,
    p_fecha_reg date, p_result OUT VARCHAR2, p_mensaje OUT VARCHAR2);


  /******************************************************************************
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  2.0        21/06/2017  Danny Sánchez    Procesos de BSCS para alineación
  ******************************************************************************/
  PROCEDURE SGASU_ALINEAR_CONTRATO_BSCS(PI_CO_ID IN NUMBER, PI_TIPO_ACCION IN VARCHAR2, 
  PO_COD_RPTA OUT NUMBER, PO_MSJ_RPTA OUT VARCHAR2);
    
  PROCEDURE SGASU_ESTADO_CONTRATO_BSCS(PI_COD_ID IN NUMBER, PI_CH_STATUS OUT VARCHAR2,
    PO_COD_RPTA OUT NUMBER, PO_MSJ_RPTA OUT VARCHAR2);
    
  FUNCTION SGAFUN_CONTRACTHIST(PI_CO_ID IN NUMBER) RETURN NUMBER;
  
end PKG_SGA_ALINEACION_HFC;
/