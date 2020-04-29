create or replace package body operacion.pq_masivasot is

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
                                           an_resp   out number) is
  begin
    an_resp := 0;
    /* inserta registro OPE_LISTA_FILTROS_TMP*/
    insert into OPE_LISTA_FILTROS_TMP
      (DW, TIPO, VALOR, USUREG)
    values
      (as_dw, ai_tipo, as_valor, as_usureg);
  
  exception
    when others then
      an_resp := -1;
  end;

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
                                    an_resp     out number) is
  begin
  
    an_resp := 0;
  
    if an_accion = 1 then
      /* inserta registro OPERACION.OPE_MASIVASOT_CAB*/
      
      insert into OPERACION.OPE_MASIVASOT_CAB
        (IDTIPO, TOTAL)
      values
        (an_idtipo, an_total);
	
	select OPERACION.SQ_OPE_MASIVASOT_CAB.CURRVAL
        into an_resp
        from OPERACION.dummy_ope;
        
    else
      if an_accion = 2 then
        /* actualiza registro OPERACION.OPE_MASIVASOT_CAB*/
        update OPERACION.OPE_MASIVASOT_CAB
           set TOTERR = an_toterr
         where IDMASIVA = an_idmasiva;
        an_resp := 1;
      end if;
    end if;
    commit;
  exception
    when others then
      an_resp := -1;
  end;

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
                                    an_resp        out number) is

  begin
  

  
    an_resp := 0;
  
    if an_accion = 1 then --insert
      /* inserta registro OPE_MASIVASOT_DET*/
            
      insert into OPERACION.OPE_MASIVASOT_DET
        (IDMASIVA, CODSOLOT, DATO, FLG_ERR, OBSERVACION)
      values
        (an_idmasiva, an_codsolot, an_dato, an_flg_err, as_obs);
    
      select OPERACION.SQ_OPE_MASIVASOT_DET.CURRVAL
        into an_resp
        from OPERACION.dummy_ope;
    
    else
      if an_accion = 2 then --update
        /* actualiza registro OPE_MASIVASOT_DET*/
        update OPERACION.OPE_MASIVASOT_DET
           set FLG_ERR = an_flg_err, OBSERVACION = as_obs
         where IDDETMASIVA = an_iddetmasiva;
        an_resp := 1;
      end if;
    end if;
    commit;
  exception
    when others then
      an_resp := -1;
  end;
END pq_masivasot;
/