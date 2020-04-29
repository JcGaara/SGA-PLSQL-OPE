CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_SIAC_POSTVENTA is
  /************************************************************************************************
  NOMBRE:     OPERACION.PKG_SIAC_POSTVENTA
  PROPOSITO:  Generacion de Post Venta Automatica PARA LOS DIFERENTES TIPOS DE TRANSACCION
              1 - CAMBIO NUMERO

  REVISIONES:
  Version  Fecha       Autor             Solicitado por     Descripcion
  -------  ----------  ----------------  ----------------   -----------
    1.0    16/05/2017  Juan Gonzales      Alfredo YI       Cambio de numero SIAC UNICO
                       Lidia Quispe
  *******************************************************************************/
  PROCEDURE SIACSI_GENERAR_TRANS(K_ID_TRANS      IN NUMBER,
                                 K_CODSOLOT      OUT SOLOT.CODSOLOT%TYPE,
                                 K_ERROR_CODE    OUT NUMBER,
                                 K_ERROR_MSG     OUT VARCHAR2) IS

  V_TIPOTRANS     VARCHAR2(100);
  C_TRAMA         sales.siact_util_trama.tramv_trama%TYPE;
  C_CO_ID         sales.sot_sisact.cod_id%TYPE;
  C_CUSTOMER_ID   sales.cliente_sisact.customer_id%TYPE;
  ln_customer_id  number;
  V_TIPO          VARCHAR2(100);
  V_RESULTADO     CONSTANT VARCHAR2(500) := 'Error al realizar transaccion';
  V_NUMERO_NEW    NUMTEL.NUMERO%TYPE;

  BEGIN
    K_ERROR_CODE := 0;
    K_ERROR_MSG  := 'OK';
    BEGIN
      SELECT TRAMV_TRAMA, TRAMN_IDINTERACCION, TRAMN_CO_ID, TRAMN_CUSTOMER_ID, tramn_customer_id
        INTO C_TRAMA, G_P_ID, C_CO_ID, C_CUSTOMER_ID, ln_customer_id
        FROM sales.siact_util_trama
       WHERE TRAMN_IDTRANSACCION =K_ID_TRANS ;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20000,
                                  'No Existe Datos para el TRAMN_IDTRANSACCION: ' ||
                                  K_ID_TRANS ||
                                  ' Table: sales.siact_util_trama');
        WHEN TOO_MANY_ROWS THEN
          RAISE_APPLICATION_ERROR(-20000,
                                  'Existe mas de un Regsitro para el TRAMN_IDTRANSACCION: ' ||
                                  K_ID_TRANS || ' Table: sales.siact_util_trama');
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20000,
                                  $$PLSQL_UNIT || '.' || 'TRAMN_IDTRANSACCION' || ' -- ' ||
                                  SQLERRM);
    END;
    /** REALIZAMOS LAS VALIDACIONES LTE / HFC **/
    V_TIPOTRANS := SIACFUN_GET_PARAMETER('TIPO_TRANSACCION:',C_TRAMA);
    G_TIPOTRANS := V_TIPOTRANS;
    G_ID_TRANS  := K_ID_TRANS;

    /** VALIDAMOS SI LA LINEA SE ENCUENTRA RESERVADA EN SGA Y ASIGNADA EN BSCS**/
    v_numero_new := SIACFUN_GET_PARAMETER('NRO_TELEFNUEV:',C_TRAMA);
    OPERACION.PKG_SIAC_CAMBIO_NUMERO.SIACSU_VALIDA_NUMERO(v_numero_new);

    SIACSS_validad_transaccion(ln_customer_id,
                                K_ERROR_CODE,
                                K_ERROR_MSG);

    if K_ERROR_CODE = 0 then
      IF V_TIPOTRANS = 'CAMBIONUMERO' THEN
        /** OBTENGO LOS VALORES DE LA TRAMA CON LA FUNCION SIACFUN_GET_PARAMETER **/
        V_TIPO := SIACFUN_GET_PARAMETER('TIPO_NUMERO:',C_TRAMA);
        OPERACION.PKG_SIAC_CAMBIO_NUMERO.SIACSI_CAMBIO_NUMERO(K_ID_TRANS,
                                                              C_CO_ID,
                                                              C_CUSTOMER_ID,
                                                              V_TIPO,
                                                              K_CODSOLOT,
                                                              K_ERROR_CODE,
                                                              K_ERROR_MSG);


      ELSE
        RAISE_APPLICATION_ERROR(-20000,
                                'Tipo de Transaccion no definida: ' ||
                                 V_TIPOTRANS);
      END IF;
    END IF;

  EXCEPTION
    when others then
      K_ERROR_CODE := -1;
      K_ERROR_MSG  := $$PLSQL_UNIT || '.' ||'SIACSI_GENERAR_TRANS: '||
                     sqlcode || ' ' || sqlerrm || ' (' ||
                     dbms_utility.format_error_backtrace || ')';

      SIACSI_TRAZABILIDAD_LOG(K_ID_TRANS,
                              G_P_ID,
                              V_TIPOTRANS,
                              null,
                              NULL,
                              K_ERROR_MSG,
                              v_resultado);
  END;
  /* ******************************************************************************** */
  FUNCTION SIACFUN_GET_PARAMETER(K_CAMPO VARCHAR2,
                                 K_TRAMA SALES.SIACT_UTIL_TRAMA.TRAMV_TRAMA%TYPE)
                                 RETURN VARCHAR2 IS
    v_trama2 sales.siact_util_trama.TRAMV_TRAMA%TYPE;
    V_VALUE  VARCHAR2(100);
  begin
      if substr(k_campo,LENgth(k_campo))=':' AND INSTR(k_trama,k_campo) > 0 THEN

          SELECT SUBSTR(k_trama,INSTR(k_trama,k_campo)+length(k_campo)) INTO v_trama2 FROM DUAL;

          SELECT  SUBSTR(k_trama,INSTR(k_trama,k_campo)+length(k_campo),INSTR(v_trama2,'|')-1)
           INTO V_VALUE  FROM DUAL;
      else
        RAISE_APPLICATION_ERROR(-20000,
                                  'Error en formato o no existe el campo de la trama: ' ||
                                   k_campo);
      END IF;
    RETURN V_VALUE;
  END;
  /* ******************************************************************************** */
  FUNCTION SIACFUN_SET_PARAMETER(K_CAMPO    VARCHAR2,
                                 K_VALUE    VARCHAR2,
                                 K_ID_TRANS SALES.SIACT_UTIL_TRAMA.TRAMN_IDTRANSACCION%TYPE)
  RETURN VARCHAR2 IS
  C_TRAMA      sales.siact_util_trama.TRAMV_TRAMA%TYPE;
  V_TRAMA_NEW  sales.siact_util_trama.TRAMV_TRAMA%TYPE;
  V_TRAMA_ANT  VARCHAR2(4000);
  V_TRAMA_D    VARCHAR2(4000);
  V_TRAMA_DES  VARCHAR2(4000);

  BEGIN
      if substr(K_campo,LENgth(K_campo))=':' then
        BEGIN
          SELECT TRAMV_TRAMA INTO C_TRAMA
            FROM sales.siact_util_trama
           WHERE TRAMN_idTRANSACCION = K_ID_TRANS;
        EXCEPTION
          when no_data_found then
          RAISE_APPLICATION_ERROR(-20000,
                                  'No Existe Datos para el TRAMN_IDTRANSACCION: ' ||
                                  K_ID_TRANS ||
                                  ' Table: sales.siact_util_trama');
          WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20000,
                                  $$PLSQL_UNIT || '.' || 'TRAMN_IDTRANSACCION' || ' -- ' ||
                                  SQLERRM);
        end;

        SELECT SUBSTR(C_TRAMA,1,INSTR(C_TRAMA,K_campo)+length(K_campo)-1) INTO V_TRAMA_ANT FROM DUAL;

        SELECT SUBSTR(C_TRAMA,length(V_TRAMA_ANT)+1) INTO V_TRAMA_D FROM DUAL;

        SELECT SUBSTR(V_TRAMA_D,INSTR(V_TRAMA_D,'|')) INTO V_TRAMA_DES FROM DUAL;

        SELECT V_TRAMA_ANT||TRIM(K_VALUE)||V_TRAMA_DES INTO V_TRAMA_NEW FROM DUAL;

      ELSE
        RAISE_APPLICATION_ERROR(-20000,
                                  'Error en formato de K_campo: ' ||
                                   K_campo);
      END IF;

  RETURN V_TRAMA_NEW;
  END;

  /* ******************************************************************************** */
  PROCEDURE SIACSI_UTIL_TRAMA( K_ID_INTERACCION VARCHAR2,
                               K_ID_TRANS       VARCHAR2,
                               K_CO_ID          VARCHAR2,
                               K_CUSTOMER_ID    VARCHAR2,
                               K_CODSOLOT       VARCHAR2,
                               K_TRAMA          VARCHAR2) IS
  begin
    insert into sales.siact_util_trama
      (tramn_idinteraccion, tramn_idtransaccion, tramn_co_id, tramn_customer_id, tramn_codsolot, tramv_trama)
    values
      (to_number(k_id_interaccion),
       to_number(k_id_trans),
       to_number(k_co_id),
       to_number(k_customer_id),
       to_number(k_codsolot),
       k_trama);

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.' ||
                              'SIACSI_UTIL_TRAMA' || sqlerrm);
  end;
  /* ******************************************************************************** */
  PROCEDURE SIACSU_UTIL_TRAMA(K_ID_TRANS VARCHAR2,
                              K_TRAMA_NEW SALES.SIACT_UTIL_TRAMA.TRAMV_TRAMA%TYPE) IS
  BEGIN
    UPDATE sales.siact_util_trama
      SET tramv_trama = k_trama_new
      WHERE tramn_idtransaccion = k_id_trans ;
  EXCEPTION
    WHEN others then
    raise_application_error(-20000,
                            $$plsql_unit || '.' ||
                            'SIACSU_UTIL_TRAMA' || sqlerrm);
  END;
 /* ******************************************************************************** */
 PROCEDURE SIACSI_TRAZABILIDAD_LOG(K_ID_TRANSACCION     NUMBER,
                                   K_ID_INTERACCION     NUMBER,
                                   K_TIPO_TRANSACCION   VARCHAR2,
                                   K_CODSOLOT           NUMBER,
                                   K_ID_TAREA           NUMBER,
                                   K_MSG_ERR            OPERACION.SIAC_NEGOCIO_ERR.ORA_TEXT%TYPE,
                                   K_RESULTADO          VARCHAR2) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    c_TAREA_DESC    OPEWF.tareawfdef.DESCRIPCION%TYPE;
    v_cant        NUMBER;
  BEGIN
    IF K_ID_TAREA IS NOT NULL THEN
      SELECT DESCRIPCION INTO C_TAREA_DESC
       FROM tareawfdef
       WHERE TAREA = K_ID_TAREA;
    ELSE
      C_TAREA_DESC := NULL;
    END IF;

    SELECT count(1)
      INTO v_cant
      FROM operacion.sga_trazabilidad_log
     WHERE id_transaccion = K_id_transaccion
       AND id_interaccion = K_id_interaccion;

    IF v_cant > 0 THEN
      UPDATE operacion.sga_trazabilidad_log
         SET id_tarea  = K_id_tarea,
             tarea     = c_tarea_desc,
             error_msg = K_msg_err,
             resultado = K_resultado,
             codsolot  = k_codsolot
       WHERE id_transaccion = K_id_transaccion
         AND id_interaccion = K_id_interaccion;
    ELSE
      INSERT INTO operacion.sga_trazabilidad_log
      (id_transaccion,id_interaccion,tipo_transaccion,codsolot,id_tarea,tarea,error_msg,resultado)
      VALUES
      (K_id_transaccion,K_id_interaccion,K_tipo_transaccion, K_codsolot,K_id_tarea,c_tarea_desc,K_msg_err,K_resultado);
    END IF;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'SIACSI_TRAZABILIDAD_LOG' ||
                              ' -- ' || SQLERRM);

  END;
  /* ******************************************************************************** */
  PROCEDURE SIACSI_SOT_SIAC (K_COD_ID       SALES.SOT_SISACT.COD_ID%TYPE,
                             K_CODSOLOT     OPERACION.SOLOT.CODSOLOT%TYPE,
                             K_CUSTOMER_ID  OPERACION.SOLOT.CUSTOMER_ID%TYPE) IS

  begin
    insert into sales.sot_siac
      (cod_id, codsolot, cod_error, msg_error, customer_id)
    values
      (k_cod_id,
       k_codsolot,
       0,
       'Transaccion ejecutada correctamente.',
       k_customer_id);
  EXCEPTION
    WHEN OTHERS THEN
    update sales.sot_siac
    set cod_id = k_cod_id,
        customer_id = k_customer_id,
        cod_error = 0, msg_error = 'Transaccion ejecutada correctamente.'
    where codsolot    = k_codsolot;
  end;
  /* ******************************************************************************** */
  FUNCTION SIACFUN_VALIDA_SGA( K_COD_ID OPERACION.SOLOT.COD_ID%TYPE,
                               K_NUMERO OPERACION.INSSRV.NUMERO%TYPE)
                               RETURN NUMBER IS
  v_Error           NUMBER;
  c_numero          telefonia.numtel.numero%type;
  c_codinssrv       numtel.codinssrv%TYPE;
  c_estnumtel       numtel.estnumtel%TYPE;
  c_codinssrv_new   numtel.codinssrv%TYPE;
  c_codcli          solot.codcli%type;
  v_codcli          solot.codcli%type;
  c_customer_id     solot.customer_id%TYPE;
  
  BEGIN
   BEGIN
     SELECT c.numero into  c_numero
       FROM SOLOT A,SOLOTPTO B, NUMTEL C, inssrv d
      WHERE A.CODSOLOT=B.CODSOLOT
        AND d.codinssrv=b.codinssrv
        and c.codinssrv=b.codinssrv and d.tipsrv='0004'
        and c.numero = d.numero
        and a.cod_id = k_cod_id
        and d.estinssrv in (1,2)
        and c.estnumtel = 2
      GROUP BY c.numero;
   
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       
       SELECT codinssrv, codcli INTO c_codinssrv, c_codcli FROM inssrv WHERE numero = k_numero AND estinssrv in (1,2) AND tipsrv='0004';
            
       SELECT estnumtel, codinssrv  INTO c_estnumtel, c_codinssrv_new FROM numtel WHERE numero = k_numero;
       
       SELECT customer_id INTO c_customer_id FROM solot WHERE cod_id = k_cod_id group by customer_id;
       
       v_codcli := operacion.pq_siac_postventa.get_codcli(c_customer_id);
        
       IF c_codinssrv_new IS NULL AND c_estnumtel <> 2 AND c_codcli = v_codcli  THEN
          UPDATE numtel SET estnumtel = 2, codinssrv = c_codinssrv WHERE numero = k_numero;
       ELSE
          v_error:= -1;
          RETURN v_error;
       END IF;  
       
       SELECT c.numero into  c_numero
         FROM SOLOT A,SOLOTPTO B, NUMTEL C, inssrv d
        WHERE A.CODSOLOT=B.CODSOLOT
          AND d.codinssrv=b.codinssrv
          and c.codinssrv=b.codinssrv and d.tipsrv='0004'
          and c.numero = d.numero
          and a.cod_id = k_cod_id
          and d.estinssrv in (1,2)
          and c.estnumtel = 2
        GROUP BY c.numero;
   END;

    IF c_numero = k_numero THEN
       v_error:= 1;
    ELSE
       v_error:= -1;
    END IF;

    RETURN v_error;

    EXCEPTION
      WHEN OTHERS THEN
        v_error :=-1;
        RETURN v_error;
  END;
  /* ******************************************************************************** */
  PROCEDURE SIACSS_VALIDAD_TRANSACCION(v_customer_id in NUMBER,
                                       v_error_code  out number,
                                       v_error_msg   out varchar2) is
    ls_codcli vtatabcli.codcli%type;
    lv_valida number;

  begin
    v_error_code := 0;
    v_error_msg  := null;
    begin
      select max(codcli)
        into ls_codcli
        from sales.cliente_sisact
       where customer_id = to_char(v_customer_id);

    exception
      when others then
        v_error_code := 1;
        v_error_msg  := 'El cliente no existe';
    end;

    select count(*)
      into lv_valida
      from solot s, estsol e
     where s.codcli = ls_codcli
       and s.customer_id = v_customer_id
       and s.tiptra in (select o.codigon
                          from opedd o, tipopedd t
                         where o.tipopedd = t.tipopedd
                           and t.abrev = 'TIPO_TRANS_SIAC'
                           and o.codigoc = '1')
       and s.estsol = e.estsol
       and e.estsol not in (select d.codigon
                              from tipopedd c, opedd d
                             where c.abrev = 'ESTADO_SOT'
                               and c.tipopedd = d.tipopedd);

    if lv_valida > 0 then
      v_error_code := 3;
      v_error_msg  := 'Ya existe una transacción en proceso, SOT';
    end if;

  end;
 /* **********************************************************************************************/
procedure SIACSS_PLANOS(po_lstplano out sys_refcursor,
                        po_coderror out integer,
                        po_msgerror out varchar2) is

begin

  open po_lstplano for
    select a.idplano,
           a.descripcion,
           a.codubi,
           a.canthp,
           a.idhub,
           a.idcmts,
           a.estado,
           b.nomdst,
           c.desccmts CMTSDescripcion,
           d.abrevhub,
           a.codusu,
           a.fecusu,
           A.FECALTA,
           a.usualta
      from marketing.vtatabgeoref a, produccion.v_ubicaciones b, intraway.ope_cmts c, intraway.ope_hub d
     where a.codubi = b.codubi
       and a.idhub = c.idhub
       and a.idcmts = c.idcmts
       and a.idhub = d.idhub
       and a.estado = 1
     order by idplano;

  po_coderror := 0;
  po_msgerror := 'OK';

exception
  when others then
    po_coderror := -1;
    po_msgerror := sqlerrm;
end;
END;
/