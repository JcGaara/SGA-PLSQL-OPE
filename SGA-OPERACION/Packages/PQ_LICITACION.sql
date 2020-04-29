CREATE OR REPLACE PACKAGE OPERACION.PQ_LICITACION IS
  /*******************************************************************************************************
    NOMBRE:       OPERACION.PQ_LICITACION
    PROPOSITO:    Paquete de objetos necesarios para la Conexion del SGA - BSCS
    REVISIONES:
    Version    Fecha       Autor            Solicitado por    Descripcion
    ---------  ----------  ---------------  --------------    -----------------------------------------
     1.0       26/10/2015  Edilberto Astulle
     2.0       14/03/2017  Felipe Maguiña   PROY-19296        Visualización de Solución a la Medida
  *******************************************************************************************************/
procedure p_crear_licitacion(an_tipo in number,
                           av_proceso in varchar2 default null,
                           av_contrato in varchar2 default null);
procedure p_cambio_est_licitacion(an_idlicitacion in number,
                           an_estlic in number,
                           av_observacion in varchar2 default null);
procedure p_asociar_sot_licitacion(an_idlicitacion in number,
                           an_codsolot in number);
procedure p_desasociar_sot_licitacion(an_idlicitacion in number,
                           an_codsolot in number);
-- Ini 2.0
 /*****************************************************************/
  PROCEDURE SGASU_ACT_FEC_SOT(K_CODSOLOT     operacion.solot.codsolot%TYPE,
                              K_IDLICITACION operacion.licitacion.idlicitacion%TYPE,
                              K_RESULTADO    OUT NUMBER,
                              K_MENSAJE      OUT VARCHAR2);

  /****************************************************************
  * Nombre SP : SGASI_ASOC_LICITACION
  * Propósito : Registra la asociacion entre SOT y Licitacion
  * Input     : K_CODSOLOT,K_IDLICITACION
  * Output    : K_RESULTADO: 0= OK <> 0= ERROR
                K_MENSAJE: Mensaje de Operacion
  * Creado por : Felipe Maguiña
  * Fec Creación : 14/03/2017
  * Fec Actualización : --/--/----
  '****************************************************************/
  PROCEDURE SGASI_ASOC_LICITACION(K_CODCLI         marketing.vtatabcli.codcli%TYPE,
                                  k_nro_licitacion SALES.vtatabslcfac.nro_licitacion%type,
                                  k_idlicitacion   operacion.licitacion.idlicitacion%type,
                                  K_RESULTADO      OUT NUMBER,
                                  K_MENSAJE        OUT VARCHAR2);
    /****************************************************************
  * Nombre SP : SGASU_ACT_INSSRV
  * Propósito : Actualizar flag de Solucion a Medida en INSSRV
  * Input     : K_CODINSSRV
  * Output    : K_RESULTADO: 0= OK <> 0= ERROR
                K_MENSAJE: Mensaje de Operacion
  * Creado por : Felipe Maguiña     
  * Fec Creación : 14/03/2017
  * Fec Actualización : --/--/----
  '****************************************************************/
  PROCEDURE SGASU_ACT_INSSRV(K_CODINSSRV operacion.inssrv.codinssrv%TYPE,
                             K_RESULTADO OUT NUMBER,
                             K_MENSAJE   OUT VARCHAR2);

  /****************************************************************
  * Nombre SP : SGASS_VAL_GESTION
  * Propósito : Valida si un proyecto pertenece a la lista de Gestion de Gobierno
  * Input     : K_BACKLOG
  * Output    : K_RESULTADO: 0= OK <> 0= ERROR
                K_MENSAJE: Mensaje de Operacion
  * Creado por : Felipe Maguiña
  * Fec Creación : 14/03/2017
  * Fec Actualización : --/--/----
  '****************************************************************/
                            
     PROCEDURE SGASS_VAL_GESTION( K_BACKLOG   NUMBER,
                              K_RESULTADO OUT NUMBER,
                              K_MENSAJE   OUT VARCHAR2);
  /****************************************************************
  * Nombre SP : SGAFUN_PROVEEDOR
  * Propósito : Concatena proveedores de instalación o mantenimiento.
  * Input     : K_NUM
  * Output    : K_RESULTADO: 0= OK <> 0= ERROR
                K_MENSAJE: Mensaje de Operacion
  * Creado por : Conrad Aguero
  * Fec Creación : 14/03/2017
  * Fec Actualización : --/--/----
  '****************************************************************/
  FUNCTION SGAFUN_PROVEEDOR(k_num ef.numslc%TYPE, k_tip number)
    return VARCHAR2;
  -- Fin 2.0             


END PQ_LICITACION;
/