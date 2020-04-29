create or replace package operacion.pq_solicitud_pedido is

 /********************************************************************************************
  NOMBRE:       PQ_SOLICITUD_PEDIDO
  PROPOSITO:    Gestión de la solitud de Pedidos para Materiales y Equipos.
  REVISIONES:
  Versión    Fecha       Autor         Solicitado por    Descripción
  -------  ----------  --------------  --------------  ---------------------------------------
           31/08/2011    Tommy Arakaki       Comienza con:
   2.0     13/06/2012    Edilberto Astulle   PROY-3884_Agendamiento PEXT
   3.0     20/03/2017    Servicio Fallas-HITSS  INC000000723013 - Módulo de requisiciones - Tipo Móvil 
   4.0     22/06/2017    Lidia Quispe        PROY-29358 - Cambio de Estados
  *********************************************************************************************/

  procedure p_inserta_sol_ped_cab(ll_estado         number,ls_responsable    varchar2,
                                  ls_descripcion    varchar2,
                                  ls_complementario varchar2,
                                  o_idspcab     out number );

  procedure p_inserta_sol_ped_det(av_tipo varchar2, an_idspcab number,an_codsolot number,an_codef number,
  an_punto number, an_orden number,an_codeta number, an_ordencmp_idmat number, av_codmat varchar2);

    procedure p_inserta_sol_ped_det(
                                  L_IDSPCAB  NUMBER,
                                  L_SOT      NUMBER,
                                  L_EF       NUMBER,
                                  L_IDENTIFICA_SP  NUMBER,
                                  L_COD_SAP  CHAR,
                                  L_LINEA  NUMBER,
                                  L_PEDIDO  NUMBER,
                                  L_CONTRATA  VARCHAR2,
                                  L_CODMAT  CHAR,
                                  L_CANTIDAD  NUMBER,
                                  L_IMPUTACION  VARCHAR2,
                                  L_VALOR_INPUT  NUMBER,
                                  L_PRECIO_UNI  NUMBER,
                                  L_OBSERVACION1  VARCHAR2,
                                  L_OBSERVACION2  VARCHAR2,
                                  L_FEC_INGRESO  DATE,
                                  L_FEC_ENTREGA  DATE,
                                  L_FEC_GEN_SP  DATE,
                                  L_FEC_APR_SP  DATE,
                                  L_EST_APR_SP  NUMBER,
                                  L_NRO_SOLPED  NUMBER,
                                  L_NRO_PEDIDO  NUMBER,
                                  L_FEC_GEN_PC  DATE,
                                  L_FEC_APR_PC  DATE,
                                  L_EST_APR_PC  NUMBER,
                                  L_FEC_ENVIO  DATE,
                                  L_DESCRIPCION  VARCHAR2,
                                  L_MONEDA_ID  NUMBER,
                                  L_CODUND  string,
                                  o_mensaje2   OUT varchar2,
                                  o_resultado2 OUT number,
                                  l_tecnologia  VARCHAR2,  -- 3.0
                                  l_cod_sitio  VARCHAR2,   -- 3.0
                                  l_name_sitio VARCHAR2);  -- 3.0

  procedure p_importar_sol_ped(ac_resultado out varchar2,
                                ac_mensaje out varchar2);

  procedure p_inserta_sol_ped_det_imp(l_IDSPDET   NUMBER,
                                  l_IDSPCAB  NUMBER,
                                  v_ele_pep   VARCHAR2,
                                  v_cod_cen_costo  VARCHAR2,
                                  v_nro_activo  VARCHAR2,
                                  v_cuenta_mayor  VARCHAR2,
                                  v_concepto_capex  VARCHAR2,
                                  v_nro_orden  VARCHAR2,
                                  v_cen_costo  VARCHAR2,
                                  o_mensaje2   OUT varchar2,
                                  o_resultado2 OUT number);

   procedure p_insertar_valor_input( l_IDSPDET  NUMBER,
                                  l_IDSPCAB  NUMBER,
                                  v_imputacion  VARCHAR2,
                                  v_ele_pep    VARCHAR2,
                                  v_cod_cen_costo   VARCHAR2,
                                  v_nro_activo VARCHAR2,
                                  v_cuenta_mayor  VARCHAR2,
                                  v_concepto_capex  VARCHAR2,
                                  v_nro_orden  VARCHAR2,
                                  v_cen_costo  VARCHAR2,
                                    o_mensaje2  out  varchar2,
                                  o_resultado2 out number);

  function f_retorna_permiso_ele_pep(vi_codigog varchar2)
  return int;

  function f_retorna_permiso_con_cap(vi_codigog varchar2)
  return int;

  function f_retorna_permiso_CCC(vi_codigog varchar2)
  return int;

  function f_retorna_permiso_CM(vi_codigog varchar2)
  return int;

   function f_retorna_permiso_NAC(vi_codigog varchar2)
  return int;

      function f_retorna_permiso_NOR(vi_codigog varchar2)
  return int;

  function f_retorna_permiso_CC(vi_codigog varchar2)
  return int;
  --INI 4.0
  procedure sgasi_actualiza_estado_UBID (p_idrequisicion operacion.ope_sp_mat_equ_cab.idspcab%type,
                                         o_mensaje2   OUT varchar2,
                                         o_resultado2 OUT number);
  --FIN 4.0
end pq_solicitud_pedido;
/
