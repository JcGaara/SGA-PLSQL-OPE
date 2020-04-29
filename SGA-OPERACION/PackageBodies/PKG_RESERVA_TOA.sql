CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_RESERVA_TOA IS
  /****************************************************************
  '* Nombre Package : OPERACION.PKG_RESERVA_TOA
  '* PropÃ³sito : FUNCIONALIDAD PARA EFECTUAR LAS RESERVAS EN TOA
  '* Input : --
  '* Output : --
  '* Creado por : Equipo de proyecto TOA
  '* FÃ©c. CreaciÃ³n : 18/09/2018
  '* FÃ©c. ActualizaciÃ³n : --
     Ver        Date        Author                  Solicitado por              Descripcion
     ---------  ----------  -------------------     ----------------------      ------------------------------------
     1.0        18/09/2018  Equipo de proyecto TOA                              FUNCIONALIDAD PARA EFECTUAR LAS RESERVAS EN TOA
     2.0        23/01/2020  Jorge Benites                                       INICIATIVA-195.SGA_2.AG IDEA-141141 - Nuevas Funcionalidades II
	 3.0        07/02/2020  Lizbeth Portella                                    INICIATIVA-435.SGA.AG Nuevas Funcionalidades II
     4.0        13/03/2020  Lizbeth Portella                                    INICIATIVA-435.SGA.AG Nuevas Funcionalidades II reserva sisact
  '****************************************************************/
  /**************************************************
  '* Nombre SP : SGASI_HISTORIAL_RESERVA_TOA
  '* PropÃ³sito : Registrar las ordenes reservadas en TOA.
  '* Input: <pi_nro_orden>           - Nro Orden
  '* Input: <pi_id_consulta>         - ID Consulta
  '* Input: <pi_franja>              - Franja Horaria
  '* Input: <pi_dia_reserva>         - Dia de reserva
  '* Input: <pi_id_bucket>           - Id Bucket
  '* Input: <pi_cod_zona>            - ID Zona
  '* Input: <pi_cod_plano>           - ID Plano o Ubigeo
  '* Input: <pi_tipo_orden>          - Tipo de orden
  '* Input: <pi_sub_tipo_orden>      - Sub tipo de orden
  '* Output: <po_msj_result>         - mensaje de respuesta
  '* Output: <po_cod_result>         - codigo de respuesta
  '* Creado por : Equipo de proyecto Equipo de TOA
  '* Fec CreaciÃ³n : 18/09/2018
  '* Fec ActualizaciÃ³n : -
  *********************************************/
  procedure SGASI_HIS_RESER_TOA(pi_nro_orden      VARCHAR2,
                                pi_id_consulta    NUMBER,
                                pi_franja         VARCHAR2,
                                pi_dia_reserva    date,
                                pi_id_bucket      VARCHAR2,
                                pi_cod_zona       VARCHAR2,
                                pi_cod_plano      VARCHAR2,
                                pi_tipo_orden     VARCHAR2,
                                pi_sub_tipo_orden VARCHAR2,
                                po_cod_result     OUT NUMBER,
                                po_msj_result     OUT VARCHAR2,
                                po_nro_orden      OUT VARCHAR2) IS
    l_nro_Orden       number;
    l_secuencia       number(20);
    l_count_secuencia number(20);
    l_nro_orden_toa   VARCHAR2(20);
  BEGIN
    IF pi_nro_orden IS NULL THEN
      l_nro_Orden     := OPERACION.SGAFUN_GET_NRO_ORDEN_TOA();
      l_nro_orden_toa := CONCAT('RT', l_nro_Orden);
    
      INSERT INTO OPERACION.SGAT_RESERVA_TOA
        (RESTV_NRO_ORDEN,
         RESTN_ID_CONSULTA,
         RESTV_FRANJA,
         RESTD_DIA_RESERVA,
         RESTV_ID_BUCKET,
         RESTV_COD_ZONA,
         RESTV_COD_PLANO,
         RESTV_TIPO_ORDEN,
         RESTV_SUB_TIPO_ORDEN,
         RESTN_ESTADO,
         RESTN_SECUENCIA)
      VALUES
        (l_nro_orden_toa,
         pi_id_consulta,
         pi_franja,
         pi_dia_reserva,
         pi_id_bucket,
         pi_cod_zona,
         pi_cod_plano,
         pi_tipo_orden,
         pi_sub_tipo_orden,
         1,
         l_nro_Orden);
    ELSE
      UPDATE OPERACION.SGAT_RESERVA_TOA
         SET RESTN_ESTADO = 0, RESTV_usumod = user, RESTD_fecmod = sysdate
       WHERE RESTV_NRO_ORDEN = pi_nro_orden;
      l_nro_orden_toa   := pi_nro_orden;
      l_count_secuencia := length(l_nro_orden_toa) - 2;
      l_secuencia       := SUBSTR(pi_nro_orden, 3, l_count_secuencia);
      INSERT INTO OPERACION.SGAT_RESERVA_TOA
        (RESTV_NRO_ORDEN,
         RESTN_ID_CONSULTA,
         RESTV_FRANJA,
         RESTD_DIA_RESERVA,
         RESTV_ID_BUCKET,
         RESTV_COD_ZONA,
         RESTV_COD_PLANO,
         RESTV_TIPO_ORDEN,
         RESTV_SUB_TIPO_ORDEN,
         RESTN_ESTADO,
         RESTN_SECUENCIA)
      VALUES
        (l_nro_orden_toa,
         pi_id_consulta,
         pi_franja,
         pi_dia_reserva,
         pi_id_bucket,
         pi_cod_zona,
         pi_cod_plano,
         pi_tipo_orden,
         pi_sub_tipo_orden,
         1,
         l_secuencia);
    END IF;
    po_cod_result := 0;
    po_msj_result := 'OK';
    po_nro_orden  := l_nro_orden_toa;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      po_cod_result := -1;
      po_msj_result := 'ERROR ' || SQLERRM;
  END SGASI_HIS_RESER_TOA;

  /**************************************************
  '* Nombre SP : SGASU_UPDATE_RESERVA_TOA
  '* PropÃ³sito : Registrar las ordenes reservadas en TOA.
  '* Input: <pi_nro_orden>           - Nro Orden
  '* Input: <pi_value>               - Valor a modificar
  '* Input: <pi_tipo_transaccion>    - Tipo de transaccion
  '* Output: <po_msj_result>         - mensaje de respuesta
  '* Output: <po_cod_result>         - codigo de respuesta
  '* Creado por : Equipo de proyecto Equipo de TOA
  '* Fec CreaciÃ³n : 18/09/2018
  '* Fec ActualizaciÃ³n : -
  *********************************************/
  procedure SGASU_UD_RESER_TOA(pi_nro_orden        VARCHAR2,
                               pi_value            VARCHAR2,
                               pi_tipo_transaccion NUMBER,
                               po_cod_result       OUT NUMBER,
                               po_msj_result       OUT VARCHAR2) IS
  BEGIN
    IF pi_tipo_transaccion = 1 THEN
      UPDATE OPERACION.SGAT_RESERVA_TOA
         SET RESTN_ESTADO = pi_value,
             RESTV_usumod = user,
             RESTD_fecmod = sysdate
       WHERE RESTV_NRO_ORDEN = pi_nro_orden
         AND RESTN_ESTADO = 1;
    ELSIF pi_tipo_transaccion = 2 THEN
      UPDATE OPERACION.SGAT_RESERVA_TOA
         SET RESTN_ID_ETA = pi_value,
             RESTV_usumod = user,
             RESTD_fecmod = sysdate
       WHERE RESTV_NRO_ORDEN = pi_nro_orden;
    ELSIF pi_tipo_transaccion = 3 THEN
      UPDATE OPERACION.SGAT_RESERVA_TOA
         SET RESTN_NRO_SOLOT = pi_value,
             RESTV_usumod    = user,
             RESTD_fecmod    = sysdate
       WHERE RESTV_NRO_ORDEN = pi_nro_orden 
       AND RESTN_ESTADO = 1;-- 3.0
    --INI 2.0
    ELSIF pi_tipo_transaccion = 4 THEN
      UPDATE OPERACION.SGAT_RESERVA_TOA
         SET RESTN_NUM_SEC = pi_value,
             RESTV_usumod    = user,
             RESTD_fecmod    = sysdate
      WHERE RESTV_NRO_ORDEN = pi_nro_orden
      AND RESTN_ESTADO = 1;-- 3.0
    --FIN 2.0
    END IF;
    po_cod_result := 0;
    po_msj_result := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      po_cod_result := -1;
      po_msj_result := 'ERROR';
  END SGASU_UD_RESER_TOA;

  /**************************************************
  '* Nombre SP : SGASS_GET_FLAG_VALIDACION
  '* PropÃ³sito : Registrar las ordenes reservadas en TOA.
  '* Input: <pi_tiptra>              - Codigo tipo trabajo
  '* Input: <pi_tipsrv>              - Codigo tipo servicio
  '* Output: <po_flag_result>        - Flag de resultado para reservas
  '* Output: <po_msj_result>         - mensaje de respuesta
  '* Output: <po_cod_result>         - codigo de respuesta
  '* Creado por : Equipo de proyecto Equipo de TOA
  '* Fec CreaciÃ³n : 21/09/2018
  '* Fec ActualizaciÃ³n : -
  *********************************************/
  procedure SGASS_GET_FLAG_VAL(pi_tiptra      IN operacion.matriz_tystipsrv_tiptra_adc.tiptra%TYPE,
                               pi_tipsrv      IN operacion.matriz_tystipsrv_tiptra_adc.tipsrv%TYPE,
                               po_flag_result OUT operacion.matriz_tystipsrv_tiptra_adc.FLAG_RESERVA%TYPE,
                               po_cod_result  OUT NUMBER,
                               po_msj_result  OUT VARCHAR2) IS
    l_flag_reserva number := 0;
  BEGIN
    SELECT FLAG_RESERVA
      INTO l_flag_reserva
      FROM OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC
     WHERE TIPTRA = pi_tiptra
       AND TIPSRV = pi_tipsrv
       AND ESTADO = 1;
  
    po_flag_result := l_flag_reserva;
    po_cod_result  := 0;
    po_msj_result  := 'OK';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      po_cod_result  := -1;
      po_msj_result  := 'No se encontro resultado';
      po_flag_result := 0;
    WHEN OTHERS THEN
      po_cod_result  := -2;
      po_msj_result  := 'Se genero el error: ' || sqlerrm || '.';
      po_flag_result := 0;
  END SGASS_GET_FLAG_VAL;

  /**************************************************
  '* Nombre SP : SGASS_FLAG_VAL_X_AGEN
  '* PropÃ³sito : Validar el flag de reserva para TOA con el id de agenda.
  '* Input: <pi_idagenda>              - Id de agenda
  '* Output: <po_cod_result>           - codigo de respuesta
  '* Creado por : Equipo de proyecto Equipo de TOA
  '* Fec CreaciÃ³n : 26/09/2018
  '* Fec ActualizaciÃ³n : -
  *********************************************/
  procedure SGASS_FLAG_VAL_X_AGEN(pi_idagenda   IN agendamiento.idagenda%TYPE,
                                  po_cod_result OUT NUMBER) IS
    l_flag_reserva number := 0;
    l_codsolot     number;
    l_tiptra       number;
    l_tipsrv       varchar2(10);
  BEGIN
    begin
      select a.codsolot
        into l_codsolot
        from agendamiento a
       where a.idagenda = pi_idagenda;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        l_flag_reserva := 0;
        RETURN;
    END;
  
    begin
      SELECT tiptra, s.tipsrv
        INTO l_tiptra, l_tipsrv
        FROM solot s
       WHERE codsolot = l_codsolot;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        l_flag_reserva := 0;
        RETURN;
    END;
  
    BEGIN
      SELECT a.FLAG_RESERVA
        INTO l_flag_reserva
        FROM OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC a
       WHERE a.TIPTRA = l_tiptra
         AND a.TIPSRV = l_tipsrv
         AND ESTADO = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        l_flag_reserva := 0;
      WHEN OTHERS THEN
        l_flag_reserva := 0;
    END;
  
    po_cod_result := l_flag_reserva;
  
  END SGASS_FLAG_VAL_X_AGEN;

  /**************************************************
  '* Nombre SP : SGASS_RESERVAS_A_CANC
  '* PropÃ³sito : Listar todas las cuotas reservadas que superen el tiempo mÃ¡ximo permitido
  '* Output: <PO_CURSOR>        - Lista de cuotas reservadas
  '* Output: <po_msj_result>         - mensaje de respuesta
  '* Output: <po_cod_result>         - codigo de respuesta
  '* Creado por : Equipo de proyecto Equipo de TOA
  '* Fec CreaciÃ³n : 21/09/2018
  '* Fec ActualizaciÃ³n : -
  *********************************************/
  procedure SGASS_RESERVAS_A_CANC(PO_CURSOR     OUT sys_refcursor,
                                  po_cod_result OUT NUMBER,
                                  po_msj_result OUT VARCHAR2) IS
  
    ln_codigon opedd.codigon%TYPE;
    ln_codigoc opedd.codigoc%TYPE;
    error_cod_aux EXCEPTION;
  
  BEGIN
  
    BEGIN
      select op.codigoN, op.codigoc
        INTO ln_codigon, ln_codigoc
        from operacion.opedd op
       inner join operacion.tipopedd tp
          on (op.tipopedd = tp.tipopedd)
       where tp.descripcion = CV_DESC_TIEMPO_RESERVA
         and tp.abrev = CV_ABRV_TIEMPO_RESERVA;
    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE error_cod_aux;
    END;
  
    OPEN PO_CURSOR FOR
      SELECT R.RESTV_NRO_ORDEN,
             R.RESTN_ID_ETA,
             R.RESTN_NRO_SOLOT,
             R.RESTN_ID_CONSULTA,
             R.RESTV_FRANJA,
             R.RESTD_DIA_RESERVA,
             R.RESTV_ID_BUCKET,
             R.RESTV_COD_ZONA,
             R.RESTV_COD_PLANO,
             R.RESTV_TIPO_ORDEN,
             R.RESTV_SUB_TIPO_ORDEN
        FROM OPERACION.SGAT_RESERVA_TOA R
       WHERE R.RESTN_ESTADO = CN_ABRV_ESTADO_RESERVADO
         AND TO_NUMBER((SYSDATE - R.RESTD_FECHA_GENERADA) * 24 * 60) >
             ln_codigon;
  
    po_cod_result := 0;
    po_msj_result := 'OK';
  
    RETURN;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      OPEN PO_CURSOR FOR
        SELECT NULL, NULL, NULL, NULL FROM DUAL;
    
      po_cod_result := -1;
      po_msj_result := 'No se encontro resultado';
    
  END SGASS_RESERVAS_A_CANC;

 /**************************************************
  '* Nombre SP : SGASS_GET_RESERVA
  '* Propósito : validar numsec asociado a reserva 4.0
  '* Input: <ps_numsec>              - numero de sec venta
  '* Input: <pi_valor>               - estado
  '* Output: <po_msj_result>         - mensaje de respuesta
  '* Output: <po_cod_result>         - codigo de respuesta
  '* Creado por : Equipo de proyecto Equipo de TOA
  '* Fec Creación : 21/02/2020  
  '* Fec Actualización : -
  *********************************************/
   procedure SGASS_GET_RESERVA(ps_numsec      IN VARCHAR2,
                               pi_valor       IN NUMBER,
                               po_cod_result  OUT NUMBER,
                               po_msj_result  OUT VARCHAR2,
                               ps_nro_reserva OUT VARCHAR2) IS
                               
  LS_NRO_RESERVA VARCHAR2(30);
   
  BEGIN
    SELECT RESTV_NRO_ORDEN
      INTO LS_NRO_RESERVA
      FROM OPERACION.SGAT_RESERVA_TOA
     WHERE RESTN_NUM_SEC = ps_numsec
      AND RESTN_ESTADO = pi_valor;
  
     
    if LS_NRO_RESERVA is not null then 
          po_cod_result  := 1;
          po_msj_result  := 'OK';
          ps_nro_reserva:= LS_NRO_RESERVA;
    end if; 
   
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      po_cod_result  := 0;
      po_msj_result  := 'No se encontro resultado';
   
    WHEN OTHERS THEN
      po_cod_result  := 0;
      po_msj_result  := 'Se genero el error: ' || sqlerrm || '.';
  
  END SGASS_GET_RESERVA;
   

  
   FUNCTION f_obtener_tag_ipc(av_tag VARCHAR2, av_trama CLOB) RETURN VARCHAR2 IS
    lv_rpta CLOB;
    lv_retn VARCHAR2(1000);
  BEGIN
    IF INSTR(av_trama, av_tag) = 0 THEN
      RETURN '';
    END IF;
   
    lv_rpta := TRIM(substr(av_trama,INSTR(av_trama, av_tag)+length(av_tag)+1));
    lv_rpta := TRIM(substr(lv_rpta,1,instr(lv_rpta,'<')-1));
    lv_retn := lv_rpta;

    RETURN lv_retn;
  END f_obtener_tag_ipc;
  
  /**************************************************
  '* Nombre SP : SGASS_ENV_DUP_AGE
  '* Propósito : Controlar desalineaciones en Reserva de Agendamiento.
  '* Output: <PO_CURSOR_CAB>        - Cursor que envia cantidad de desalineaciones
  '* Output: <PO_CURSOR_DET>        - Cursor que envia detalle de desalineaciones
  '* Output: <PO_CODIGO_ERROR>         - codigo de respuesta
  '* Output: <PO_DESC_ERROR>         - mensaje de respuesta
  '* Creado por : Equipo de Fallas y Urgencias
  '* Fec Creación : 11/03/2020
  '* Fec Actualización : -
  *********************************************/
  
PROCEDURE SGASS_ENV_DUP_AGE(PO_CURSOR_CAB OUT SYS_REFCURSOR,
                            PO_CURSOR_DET OUT SYS_REFCURSOR,
                            PO_CODIGO_ERROR OUT NUMBER,
                            PO_DESC_ERROR OUT VARCHAR2) IS
  
    LD_TODAY DATE := SYSDATE;   
    cod_metodo integer;
    desc_metodo varchar2(100);   
    cod_metodo1 integer;
    desc_metodo1 varchar2(100);    
    cod_metodo2 integer;
    desc_metodo2 varchar2(100);
    correl number;
   
  
     
  BEGIN
    
          select OPERACION.SGASEQ_RESV_AGE.nextval into correl from dual;
          select codigon, descripcion into cod_metodo, desc_metodo from OPERACION.opedd where UPPER(ABREVIACION) = 'CTRL_CANCELACION';
          select codigon, descripcion into cod_metodo1, desc_metodo1 from OPERACION.opedd where UPPER(ABREVIACION) = 'CTRL_DUP_TOA';
          select codigon, descripcion into cod_metodo2, desc_metodo2 from OPERACION.opedd where UPPER(ABREVIACION) = 'CTRL_DUP_RESERVA';

  
   
     OPEN PO_CURSOR_CAB FOR
     select correl COD_CTRL,
            cod_metodo AS COD_METODO,
            desc_metodo DESC_METODO,
            COUNT(DISTINCT TOA.RESTN_NRO_SOLOT) CANTIDAD,
            to_char(SYSDATE-1,'dd/mm/yyyy') FEC_RESERVA,
            USER USUARIO,
            to_char(sysdate,'dd/mm/yyyy  hh24:mi:ss') FEC_EJEC
         from OPERACION.SGAT_RESERVA_TOA TOA
      INNER JOIN operacion.transaccion_ws_Adc ADC
         ON ADC.CODSOLOT = TOA.RESTN_NRO_SOLOT
      INNER JOIN OPERACION.SOLOT SO
         ON SO.CODSOLOT = TOA.RESTN_NRO_SOLOT
      INNER JOIN operacion.tipo_orden_adc ORD
         ON ORD.COD_TIPO_ORDEN = TOA.RESTV_TIPO_ORDEN
      where upper(ADC.METODO) like '%CANCELARORDENSGA%'
        AND ADC.IDERROR = 0
        AND TOA.RESTN_ESTADO IN ('1', '2')
        AND TRUNC(TOA.RESTD_FECHA_GENERADA) = TRUNC(LD_TODAY) -1
        HAVING   COUNT(DISTINCT TOA.RESTN_NRO_SOLOT)>0
        
        UNION
        
         
        select correl COD_CTRL,
            cod_metodo1 COD_METODO,
            desc_metodo1 DESC_METODO,
            COUNT(DISTINCT TOA.RESTN_NRO_SOLOT) CANTIDAD,
            to_char(SYSDATE-1,'dd/mm/yyyy') FEC_RESERVA,
            USER USUARIO,
            to_char(sysdate,'dd/mm/yyyy  hh24:mi:ss') FEC_EJEC
          from OPERACION.SGAT_RESERVA_TOA TOA
    INNER JOIN (select distinct CC.codsolot,
                                BB.IDTRANSACCION,
                                bb.ideta,
                                case
                                  when CC.cant > 1 then
                                   0
                                  else
                                   1
                                END val
                  FROM (select aa.codsolot, count(1) cant
                          from (select distinct codsolot,
                                                TO_NUMBER(f_obtener_tag_ipc('idETA',
                                                                            xmlrespuesta)) idETA
                                  from operacion.transaccion_ws_Adc
                                 where trim(metodo) = 'gestionarOrdenSGA'
                                   and xmlenvio like '%|update|%'
                                   and iderror = '0') aa
                         group by aa.codsolot) CC
                 INNER JOIN (select distinct AC.CODSOLOT,
                                            AC.IDTRANSACCION,
                                            TO_NUMBER(f_obtener_tag_ipc('idETA',
                                                                        AC.xmlrespuesta)) idETA
                              from operacion.transaccion_ws_Adc AC
                             where trim(AC.metodo) = 'gestionarOrdenSGA'
                               and AC.xmlenvio like '%|update|%'
                               and AC.iderror = '0') BB
                    ON BB.CODSOLOT = CC.CODSOLOT) ad
       ON AD.CODSOLOT = TOA.RESTN_NRO_SOLOT
    inner join (select distinct A.CODSOLOT,
                                A.IDTRANSACCION,
                                f_obtener_tag_ipc('idETA', a.xmlrespuesta) idETA
                  from operacion.transaccion_ws_Adc a
                 where trim(metodo) = 'gestionarOrdenSGA'
                   and iderror = '0') adc
       on adc.codsolot = ad.codsolot
    INNER JOIN OPERACION.SOLOT SO
       ON SO.CODSOLOT = TOA.RESTN_NRO_SOLOT
    INNER JOIN operacion.tipo_orden_adc ORD
       ON ORD.COD_TIPO_ORDEN = TOA.RESTV_TIPO_ORDEN
    where AD.idETA != ADC.idETA
      AND TRUNC(TOA.RESTD_FECHA_GENERADA) = TRUNC(LD_TODAY) - 1      
   HAVING   COUNT(DISTINCT TOA.RESTN_NRO_SOLOT)>0
   
    UNION
        
     SELECT correl COD_CTRL,
            cod_metodo2 COD_METODO,
            desc_metodo2 DESC_METODO,
            COUNT(DISTINCT B.RESTN_NRO_SOLOT) CANTIDAD,
            to_char(SYSDATE-1,'dd/mm/yyyy') FEC_RESERVA,
            USER USUARIO,
            to_char(sysdate,'dd/mm/yyyy  hh24:mi:ss') FEC_EJEC
       FROM (SELECT RESTV_NRO_ORDEN
               FROM (SELECT distinct RESTV_NRO_ORDEN, RESTN_NRO_SOLOT
                       FROM OPERACION.SGAT_RESERVA_TOA)
              GROUP BY RESTV_NRO_ORDEN
             HAVING COUNT(RESTN_NRO_SOLOT) > 1) A
      INNER JOIN OPERACION.SGAT_RESERVA_TOA B
         ON A.RESTV_NRO_ORDEN = B.RESTV_NRO_ORDEN
      INNER JOIN OPERACION.SOLOT SO
         ON SO.CODSOLOT = B.RESTN_NRO_SOLOT
      INNER JOIN operacion.tipo_orden_adc ORD
         ON ORD.COD_TIPO_ORDEN = B.RESTV_TIPO_ORDEN
      WHERE TRUNC(B.RESTD_FECHA_GENERADA) = TRUNC(LD_TODAY) -1
      HAVING   COUNT(DISTINCT B.RESTN_NRO_SOLOT)>0;
   
   

     OPEN PO_CURSOR_DET FOR
     
           select correl AS COD_CTRL,
           cod_metodo cod_metodo,
            TOA.RESTV_NRO_ORDEN NRO_ORDEN,
            TOA.RESTN_NRO_SOLOT NRO_SOLOT,
            SO.TIPTRA TIP_TRA,
            ORD.TIPO_TECNOLOGIA TECNOLOGIA,
            NVL(TOA.RESTN_ID_ETA,0) ID_ETA,
            to_char(SYSDATE-1,'dd/mm/yyyy') FEC_RESERVA,            
            USER USUARIO,            
            ORD.TIPO_SERVICIO,
             '<NRO_SOT>'||TOA.RESTN_NRO_SOLOT||'<NRO_ORDEN>'||TOA.RESTV_NRO_ORDEN||
            '<ESTADO_RESERVA>'|| CASE WHEN TOA.RESTN_ESTADO ='1' THEN '1'
                                      WHEN TOA.RESTN_ESTADO ='2' THEN '2' END ERROR_DETALLE,
            to_char(sysdate,'dd/mm/yyyy  hh24:mi:ss') FEC_EJEC 
       from OPERACION.SGAT_RESERVA_TOA TOA
      INNER JOIN operacion.transaccion_ws_Adc ADC
         ON ADC.CODSOLOT = TOA.RESTN_NRO_SOLOT
      INNER JOIN OPERACION.SOLOT SO
         ON SO.CODSOLOT = TOA.RESTN_NRO_SOLOT
      INNER JOIN operacion.tipo_orden_adc ORD
         ON ORD.COD_TIPO_ORDEN = TOA.RESTV_TIPO_ORDEN
      where upper(ADC.METODO) like '%CANCELARORDENSGA%'
        AND ADC.IDERROR = 0
        AND TOA.RESTN_ESTADO IN ('1', '2')
        AND TRUNC(TOA.RESTD_FECHA_GENERADA) = TRUNC(LD_TODAY) -1
        
       
  
 UNION
 
   select DISTINCT correl AS COD_CTRL,
                   cod_metodo1 cod_metodo,
                   TOA.RESTV_NRO_ORDEN NRO_ORDEN,
                   TOA.RESTN_NRO_SOLOT NRO_SOLOT,
                   SO.TIPTRA TIP_TRA,
                   ORD.TIPO_TECNOLOGIA TECNOLOGIA,
                   NVL(TOA.RESTN_ID_ETA,0) ID_ETA,
                   to_char(SYSDATE-1,'dd/mm/yyyy') FEC_RESERVA,
                   USER USUARIO,
                   ORD.TIPO_SERVICIO,
                   CASE
                     WHEN AD.val = 0 THEN
                      'Ordenes duplicadas con diferente IDETA: ' ||
                      '<IDTRANSAC>' || AD.IDTRANSACCION || '<IDETA>' ||
                      AD.idETA
                     ELSE
                      'Ordenes duplicadas con diferente IDETA: ' ||
                      '<IDTRANSAC>' || AD.IDTRANSACCION || '<IDETA>' ||
                      AD.idETA || '<IDTRANSAC_DUPLI>' || ADC.IDTRANSACCION || '|' ||
                      '<IDETA_DUPLI>' || adc.idETA
                   END ERROR_DETALLE,
                   to_char(sysdate,'dd/mm/yyyy  hh24:mi:ss') FEC_EJEC
     from OPERACION.SGAT_RESERVA_TOA TOA
    INNER JOIN (select distinct CC.codsolot,
                                BB.IDTRANSACCION,
                                bb.ideta,
                                case
                                  when CC.cant > 1 then
                                   0
                                  else
                                   1
                                END val
                  FROM (select aa.codsolot, count(1) cant
                          from (select distinct codsolot,
                                                TO_NUMBER(f_obtener_tag_ipc('idETA',
                                                                            xmlrespuesta)) idETA
                                  from operacion.transaccion_ws_Adc
                                 where trim(metodo) = 'gestionarOrdenSGA'
                                   and xmlenvio like '%|update|%'
                                   and iderror = '0') aa
                         group by aa.codsolot) CC
                 INNER JOIN (select distinct AC.CODSOLOT,
                                            AC.IDTRANSACCION,
                                            TO_NUMBER(f_obtener_tag_ipc('idETA',
                                                                        AC.xmlrespuesta)) idETA
                              from operacion.transaccion_ws_Adc AC
                             where trim(AC.metodo) = 'gestionarOrdenSGA'
                               and AC.xmlenvio like '%|update|%'
                               and AC.iderror = '0') BB
                    ON BB.CODSOLOT = CC.CODSOLOT) ad
       ON AD.CODSOLOT = TOA.RESTN_NRO_SOLOT
    inner join (select distinct A.CODSOLOT,
                                A.IDTRANSACCION,
                                f_obtener_tag_ipc('idETA', a.xmlrespuesta) idETA
                  from operacion.transaccion_ws_Adc a
                 where trim(metodo) = 'gestionarOrdenSGA'
                   and iderror = '0') adc
       on adc.codsolot = ad.codsolot
    INNER JOIN OPERACION.SOLOT SO
       ON SO.CODSOLOT = TOA.RESTN_NRO_SOLOT
    INNER JOIN operacion.tipo_orden_adc ORD
       ON ORD.COD_TIPO_ORDEN = TOA.RESTV_TIPO_ORDEN
    where AD.idETA != ADC.idETA
      AND TRUNC(TOA.RESTD_FECHA_GENERADA) = TRUNC(LD_TODAY) - 1
      
       UNION
        
     SELECT correl AS COD_CTRL,
            cod_metodo2 cod_metodo,
            A.RESTV_NRO_ORDEN NRO_ORDEN,
            B.RESTN_NRO_SOLOT NRO_SOLOT,
            SO.TIPTRA TIP_TRA,
            ORD.TIPO_TECNOLOGIA TECNOLOGIA,
            NVL(B.RESTN_ID_ETA,0) ID_ETA,
            to_char(SYSDATE-1,'dd/mm/yyyy') FEC_RESERVA,           
            USER USUARIO,           
            ORD.TIPO_SERVICIO,
            '<NRO_ORDEN>'||A.RESTV_NRO_ORDEN||'<NRO_SOT>'||B.RESTN_NRO_SOLOT ERROR_DETALLE,
            to_char(sysdate,'dd/mm/yyyy  hh24:mi:ss') FEC_EJEC
       FROM (SELECT RESTV_NRO_ORDEN
               FROM (SELECT distinct RESTV_NRO_ORDEN, RESTN_NRO_SOLOT
                       FROM OPERACION.SGAT_RESERVA_TOA)
              GROUP BY RESTV_NRO_ORDEN
             HAVING COUNT(RESTN_NRO_SOLOT) > 1) A
      INNER JOIN OPERACION.SGAT_RESERVA_TOA B
         ON A.RESTV_NRO_ORDEN = B.RESTV_NRO_ORDEN
      INNER JOIN OPERACION.SOLOT SO
         ON SO.CODSOLOT = B.RESTN_NRO_SOLOT
      INNER JOIN operacion.tipo_orden_adc ORD
         ON ORD.COD_TIPO_ORDEN = B.RESTV_TIPO_ORDEN
       WHERE TRUNC(B.RESTD_FECHA_GENERADA) = TRUNC(LD_TODAY) -1
      ;
 
  PO_CODIGO_ERROR :=0;
  PO_DESC_ERROR := 'OK';
  
 
 

        EXCEPTION
        WHEN OTHERS THEN
          PO_CODIGO_ERROR := '-1';
          PO_DESC_ERROR    := SUBSTR(SQLERRM,1,400);
          ROLLBACK;
 
  END SGASS_ENV_DUP_AGE; 
   
END PKG_RESERVA_TOA;
/

