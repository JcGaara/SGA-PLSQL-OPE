create or replace package operacion.pq_masivasot is

  /*******************************************************************************************************
   NOMBRE:     PQ_MASIVA_SOT
   PROPOSITO:  Agrupacion de funcionalidades adicionales de administracion de Proyectos para procesos masivos
  
   REVISIONES:
   Version      Fecha        Autor           Descripcion
   ---------  ----------  ---------------  ------------------------
   1.0        02/11/2011  Keila Carpio     Req 160732 Gestión de SOTs
  *******************************************************************************************************/
  /*********************************************************************************
    PROCESO QUE INSERTA DATOS TEMPORALES PARA FILTRO OPE_LISTA_FILTROS_TMP
    p_insert_ope_lista_filtros_tmp
    IN  as_dw     Datawindow Principal del Filtro
        ai_tipo   Tipo de Filtro 3 EstSol, 4 TipTra
        as_valor  Valor seleccionado
        as_usureg Usuario de Consulta
    OUT an_resp   Tipo de Respuesta 0 sin error, -1 con error
  *********************************************************************************/

  procedure p_insert_ope_lista_filtros_tmp(as_dw     in OPE_LISTA_FILTROS_TMP.dw%type,
                                           ai_tipo   in OPE_LISTA_FILTROS_TMP.tipo%type,
                                           as_valor  in OPE_LISTA_FILTROS_TMP.valor%type,
                                           as_usureg in OPE_LISTA_FILTROS_TMP.usureg%type,
                                           an_resp   out number);

  /*********************************************************************************
    PROCESO QUE INSERTA o ACTUALIZA REGISTRO en OPERACION.OPE_MASIVASOT_CAB
    p_gestion_masiva_cab
    IN   as_accion Identificador de Acción 'I' Insert, 'U' Update, 'D' Delete
         an_idtipo Identificador de Tipo de Operación Masiva de SOT 
         an_total  Cantidad de SOTs
         an_toterr Cantidad de SOTs con Error             
    OUT  an_resp   Si es un Insert regresa el Identificador de Gestión Masiva de SOT 
         y si es un update cuantos registros se actualizaron.
  *********************************************************************************/

  procedure p_gestion_masivasot_cab(an_accion   in number,
                                    an_idmasiva in OPERACION.OPE_MASIVASOT_CAB.IDMASIVA%type,
                                    an_idtipo   in OPERACION.OPE_MASIVASOT_CAB.IDTIPO%type,
                                    an_total    in OPERACION.OPE_MASIVASOT_CAB.TOTAL%type,
                                    an_toterr   in OPERACION.OPE_MASIVASOT_CAB.TOTERR%type,
                                    an_resp     out number);

  /*********************************************************************************
    PROCESO QUE INSERTA o ACTUALIZA REGISTRO en OPERACION.OPE_MASIVASOT_DET y GENERA IDENTIFICADOR CORRELATIVO
    p_gestion_masivasot_det
    IN   as_accion Identificador de Acción 'I' Insert, 'U' Update, 'D' Delete
         an_idtipo Identificador de Tipo de Operación Masiva de SOT 
         an_total  Cantidad de SOTs
         an_toterr Cantidad de SOTs con Error             
    OUT  an_resp   Si es un Insert regresa el Identificador de Gestión Masiva de SOT 
         y si es un update cuantos registros se actualizaron.
  *********************************************************************************/

  procedure p_gestion_masivasot_det(an_accion      in number,
                                    an_iddetmasiva in OPERACION.OPE_MASIVASOT_DET.IDDETMASIVA%type,
                                    an_idmasiva    in OPERACION.OPE_MASIVASOT_DET.IDMASIVA%type,
                                    an_codsolot    in OPERACION.OPE_MASIVASOT_DET.CODSOLOT%type,
                                    an_dato        in OPERACION.OPE_MASIVASOT_DET.DATO%type,
                                    an_flg_err     in OPERACION.OPE_MASIVASOT_DET.FLG_ERR%type,
                                    as_obs         in OPERACION.OPE_MASIVASOT_DET.OBSERVACION%type,
                                    an_resp        out number);

END pq_masivasot;
/