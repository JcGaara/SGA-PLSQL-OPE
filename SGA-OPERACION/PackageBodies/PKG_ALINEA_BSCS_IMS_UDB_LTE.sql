create or replace package body OPERACION.PKG_ALINEA_BSCS_IMS_UDB_LTE IS
  /****************************************************************************************
   NOMBRE:      OPERACION.PKG_ALINEA_BSCS_IMS_UDB_LTE
   PROPOSITO:   solucion a desalineaciones BSCS-IMS-UDB para líneas LTE
  
     Ver        Fecha        Autor             Solicitado por    Descripcion
   ---------  ----------  ----------------  ----------------  ------------------------
   1.0        20/03/2018  Hitss             INC000001085123
  *****************************************************************************************/
  cn_tmcode constant number := 1817; -- en SP_INTERGRATIS, SP_LINEA_NOUDB, SP_BSCS_DISCT_PCRF
  cn_plcode constant number := 1000; -- en SP_HFC_NOIMS

  /******************************************************************************
  PROCEDURE SP_ALINEA
  ******************************************************************************/
  PROCEDURE SP_GENERA_DATA(lv_fecha IN VARCHAR2,
                           ln_error out number,
                           lv_error out varchar2) is
  BEGIN
    SP_DELETE;
  
    dbms_output.put_line('Ejecutando SP_LLENAR_PCRF ...');
    SP_LLENAR_PCRF(lv_fecha, ln_error, lv_error);
    if ln_error = -1 then
      dbms_output.put_line('SP_LLENAR_PCRF, error: ' || lv_error);
      goto fin;
    end if;
  
    dbms_output.put_line('Ejecutando SP_INTERGRATIS ...');
    SP_INTERGRATIS(ln_error, lv_error);
    if ln_error = -1 then
      dbms_output.put_line('SP_INTERGRATIS, error: ' || lv_error);
      goto fin;
    end if;
  
    dbms_output.put_line('Ejecutando SP_LINEA_NOUDB ...');
    SP_LINEA_NOUDB(lv_fecha, ln_error, lv_error);
    if ln_error = -1 then
      dbms_output.put_line('SP_LINEA_NOUDB, error: ' || lv_error);
      goto fin;
    end if;
  
    dbms_output.put_line('Ejecutando SP_HFC_NOIMS ...');
    SP_HFC_NOIMS(lv_fecha, ln_error, lv_error);
    if ln_error = -1 then
      dbms_output.put_line('SP_HFC_NOIMS, error: ' || lv_error);
      goto fin;
    end if;
  
    dbms_output.put_line('Ejecutando SP_BSCS_DISCT_PCRF ...');
    SP_BSCS_DISCT_PCRF(lv_fecha, ln_error, lv_error);
    if ln_error = -1 then
      dbms_output.put_line('SP_BSCS_DISCT_PCRF, error: ' || lv_error);
      goto fin;
    end if;
  
    COMMIT;
  
    <<fin>>
    null;
  END;

  /******************************************************************************
   PROCEDURE SP_DELETE
  ******************************************************************************/
  PROCEDURE SP_DELETE IS
  BEGIN
    DELETE FROM OPERACION.PREV_HFCACTSUS;
    DELETE FROM OPERACION.PREV_LTEACTSUS;
    DELETE FROM OPERACION.PREV_IMS_HFC;
    DELETE FROM OPERACION.PREV_IMS_LTE;
    DELETE FROM OPERACION.PREV_LTEINTERNETGRATIS;
    DELETE FROM OPERACION.PREV_PCRF;
    DELETE FROM OPERACION.PREV_UDB_LTE;
    DELETE FROM OPERACION.PREV_DIFPCRF;
  END;

  /******************************************************************************
   PROCEDURE SP_LLENAR_PCRF
   Llenar la PCRF, Esta tabla se actualiza con la fecha de carga a conciliar
  ******************************************************************************/
  PROCEDURE SP_LLENAR_PCRF(av_fecha IN VARCHAR2,
                           an_error OUT NUMBER,
                           av_error OUT VARCHAR2) IS
  BEGIN
    an_error := 0;
    INSERT INTO OPERACION.PREV_PCRF
      (subscriberidentifier,
       msisdn,
       homesrvzone,
       paidtype,
       category,
       station,
       masteridentifier,
       billingcycleday,
       servicename,
       subscribedatetime,
       validfromdatetime,
       expireddatetime,
       quotaname,
       initialvalue,
       balance,
       consumption,
       status,
       linea)
      SELECT PRCFV_SUBS_IDENTIFIER,
             PRCFV_MSISDN,
             PRCFV_HOMESRVZONE,
             PRCFV_PAIDTYPE,
             PRCFV_CATEGORY,
             PRCFV_STATION,
             PRCFV_MASTERIDENTIFIER,
             PRCFV_BILLCYCLYDAY,
             PRCFV_SERVICENAME,
             null as SUSCRIBEDATETIME,
             null as VALIDFROMDATETIME,
             null as EXPIREDDATETIME,
             PRCFV_QUOTANAME,
             PRCFV_INITIALVALUE,
             PRCFV_BALANCE,
             PRCFV_CONSUMPTION,
             PRCFV_STATUS,
             substr(PRCFV_MSISDN, 3)
        FROM DWS.SA_PCRF_HUAWEI@DBL_DWO DW,
             DWS.SA_HLR_UDB@DBL_DWO HLR
       WHERE dw.PRCFV_MSISDN = hlr.msisdn
         AND dw.transact_date = av_fecha
         AND hlr.fecha_carga = av_fecha
         AND hlr.imsi like '7161067%';     -- Filtrar lineas LTE
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      an_error := -1;
      av_error := sqlerrm;
  END;

  /******************************************************************************
   PROCEDURE SP_INTERGRATIS 
  ******************************************************************************/
  PROCEDURE SP_INTERGRATIS(an_error OUT NUMBER, av_error OUT VARCHAR2) IS
  BEGIN
    an_error := 0;
    INSERT INTO OPERACION.PREV_LTEINTERNETGRATIS
      (CICLO, CO_ID, DN_NUM, CUSTOMER_ID, CH_STATUS, CH_VALIDFROM)
      select c.billcycle ciclo,
             b.co_id,
             d.dn_num,
             a.customer_id,
             b.CH_STATUS,
             b.ch_validfrom
        FROM CONTRACT_ALL@DBL_BSCS_BF          A,
             CURR_CO_STATUS@DBL_BSCS_BF        B,
             CUSTOMER_ALL@DBL_BSCS_BF          C,
             TIM.PP_DATOS_CONTRATO@DBL_BSCS_BF D
       WHERE a.tmcode = cn_tmcode --  1817
         and a.co_id = b.co_id
         and c.customer_id = a.customer_id
         and d.customer_id = a.customer_id
         and b.ch_status in ('d')
         and exists (select 1
                FROM CURR_CO_STATUS@DBL_BSCS_BF        B,
                     TIM.PP_DATOS_CONTRATO@DBL_BSCS_BF DC
               where b.co_id = dc.co_id
                 and b.ch_status = 'a'
                 and dc.dn_num = d.dn_num);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      an_error := -1;
      av_error := sqlerrm;
  END;

  /******************************************************************************
   PROCEDURE SP_LINEA_NOUDB
  ******************************************************************************/
  PROCEDURE SP_LINEA_NOUDB(av_fecha IN VARCHAR2,
                           an_error OUT NUMBER,
                           av_error OUT VARCHAR2) IS
  BEGIN
    an_error := 0;
    INSERT INTO OPERACION.PREV_UDB_LTE
      (numero, num_modif)
      SELECT y.MSISDN, y.MSISDN - 5100000000
        FROM DWS.SA_HLR_UDB@DBL_DWO Y 
       where y.fecha_carga = av_fecha
         AND y.imsi like '7161067%'; -- Filtrar lineas LTE
  
    -- Clientes Activos y Suspendidos LTE
    INSERT INTO OPERACION.PREV_LTEACTSUS
      (co_id,
       numero,
       CUSTOMER_ID,
       TMCODE,
       CH_STATUS,
       CH_PENDING,
       CH_VALIDFROM)
      select a.co_id,
             d.dn_num numero,
             a.customer_id,
             a.tmcode,
             b.ch_status,
             b.ch_pending,
             b.ch_validfrom
        FROM CONTRACT_ALL@DBL_BSCS_BF          a,
             contract_history@DBL_BSCS_BF      b,
             tim.pp_datos_contrato@DBL_BSCS_BF d
       WHERE a.co_id = d.co_id
         and d.tmcode = cn_tmcode --  1817
         AND a.co_id = b.co_id
         and b.ch_seqno = (select max(cc.ch_seqno)
                             from contract_history@DBL_BSCS_BF cc
                            where cc.co_id = b.co_id)
         AND b.ch_status in ('a', 's')
         and trunc(b.CH_VALIDFROM) <= av_fecha;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      an_error := -1;
      av_error := sqlerrm;
  END;

  /******************************************************************************
   PROCEDURE SP_HFC_NOIMS
  ******************************************************************************/
  PROCEDURE SP_HFC_NOIMS(av_fecha IN VARCHAR2,
                         an_error OUT NUMBER,
                         av_error OUT VARCHAR2) IS
  BEGIN
    an_error := 0;
    INSERT INTO OPERACION.PREV_HFCACTSUS
      (co_id,
       NUMERO,
       customer_id,
       TMCODE,
       CH_STATUS,
       CH_PENDING,
       CH_VALIDFROM)
      select a.co_id,
             d.dn_num numero,
             a.customer_id,
             a.tmcode,
             b.ch_status,
             b.ch_pending,
             b.ch_validfrom
        FROM CONTRACT_ALL@DBL_BSCS_BF          A,
             CONTRACT_HISTORY@DBL_BSCS_BF      B,
             TIM.PP_DATOS_CONTRATO@DBL_BSCS_BF D
       WHERE a.co_id = d.co_id
         and a.plcode = cn_plcode -- 1000
         AND a.co_id = b.co_id
         and b.ch_seqno = (select max(cc.ch_seqno)
                             from contract_history@DBL_BSCS_BF cc
                            where cc.co_id = b.co_id)
         AND b.ch_status in ('a', 's')
         and trunc(b.CH_VALIDFROM) <= av_fecha;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      an_error := -1;
      av_error := sqlerrm;
  END;

  /******************************************************************************
   PROCEDURE SP_BSCS_DISCT_PCRF  -- carga Ciclo de facturación en BSCS distinto a PCRF
  ******************************************************************************/
  PROCEDURE SP_BSCS_DISCT_PCRF(av_fecha IN VARCHAR2,
                               an_error OUT NUMBER,
                               av_error OUT VARCHAR2) IS
  BEGIN
    an_error := 0;
    INSERT INTO OPERACION.PREV_DIFPCRF
      (ciclo,
       co_id,
       dn_num,
       customer_id,
       ch_status,
       ch_validfrom,
       linea,
       billingcycleday)
      select c.billcycle,
             b.co_id,
             d.dn_num,
             a.customer_id,
             b.CH_STATUS,
             b.ch_validfrom,
             d.dn_num,
             pcrf.billingcycleday
        FROM CONTRACT_ALL@Dbl_Bscs_Bf          a,
             curr_co_status@dbl_bscs_bf        b,
             customer_all@dbl_bscs_bf          c,
             tim.pp_datos_contrato@dbl_bscs_bf d,
             OPERACION.prev_pcrf               pcrf
       WHERE a.tmcode = cn_tmcode --  1817
         and a.co_id = b.co_id
         and c.customer_id = a.customer_id
         and d.customer_id = a.customer_id
         and TO_NUMBER(d.dn_num) = pcrf.linea
         and b.ch_status in ('a')
         and b.CH_VALIDFROM <= av_fecha
         AND TO_NUMBER(c.billcycle) <> pcrf.billingcycleday;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      an_error := -1;
      av_error := sqlerrm;
  END;

  -- reportes

  /******************************************************************************
   -- Ciclo de facturación en BSCS distinto a PCRF
  ******************************************************************************/
  PROCEDURE SP_REP_CICLO_FACTU_BSCS_DISTIN(av_salida out sys_refcursor,
                                           an_error  OUT NUMBER,
                                           av_error  OUT VARCHAR2) IS
  BEGIN
    an_error := 0;
    open av_salida for
      select ciclo ||','|| co_id ||','|| dn_num ||','|| customer_id ||','|| CH_STATUS ||','|| ch_validfrom ||','|| linea ||','|| billingcycleday
        FROM OPERACION.PREV_DIFPCRF;
  EXCEPTION
    WHEN OTHERS THEN
      an_error := -1;
      av_error := sqlerrm;
  END;

  /******************************************************************************
   Antiguos clientes LTE con Internet gratis 
  ******************************************************************************/
  PROCEDURE SP_REP_ANTIG_CLIENT_LTE_INTERN(av_salida out sys_refcursor,
                                           an_error  OUT NUMBER,
                                           av_error  OUT VARCHAR2) IS
  BEGIN
    an_error := 0;
    open av_salida for
      SELECT l.co_id ||','|| l.dn_num ||','|| l.customer_id ||','||l.ch_status ||','|| l.ch_validfrom ||','|| p.linea
        FROM OPERACION.PREV_LTEINTERNETGRATIS l
        LEFT JOIN OPERACION.PREV_PCRF p
          ON p.linea = l.dn_num
        LEFT JOIN OPERACION.PREV_WIMAXF3 w
          ON w.customer_id = l.customer_id
       WHERE p.linea IS NOT NULL
         AND w.customer_id IS NULL;
  EXCEPTION
    WHEN OTHERS THEN
      an_error := -1;
      av_error := sqlerrm;
  END;

  /******************************************************************************
   Cliente está facturando, pero no aparece en UDB  
  ******************************************************************************/
  PROCEDURE SP_REP_CLIENT_FACTU_NO_UDB(av_salida out sys_refcursor,
                                       an_error  OUT NUMBER,
                                       av_error  OUT VARCHAR2) IS
  BEGIN
    an_error := 0;
    open av_salida for
      SELECT l.numero ||','|| u.num_modif
        FROM OPERACION.prev_lteactsus l
        left JOIN OPERACION.PREV_UDB_LTE u
          on l.numero = u.num_modif
       WHERE u.numero is NULL
         and LENGTH(l.numero) = 8;
  EXCEPTION
    WHEN OTHERS THEN
      an_error := -1;
      av_error := sqlerrm;
  END;

  /******************************************************************************
   Cliente está facturando, pero no aparece en IMS(HFC)  
  ******************************************************************************/
  PROCEDURE SP_REP_CLIENT_FACTU_NO_IMS_HFC(av_salida out sys_refcursor,
                                           an_error  OUT NUMBER,
                                           av_error  OUT VARCHAR2) IS
  BEGIN
    an_error := 0;
    -- Reporte líneas hfc no inscritas en IMS
    open av_salida for
      select h.numero ||','|| h.ch_status ||','|| h.ch_pending ||','||h.ch_validfrom
        from OPERACION.prev_hfcactsus h
        left join OPERACION.prev_IMS_HFC i
          on h.numero = i.num_modif
       where i.num_modif is null;
  EXCEPTION
    WHEN OTHERS THEN
      an_error := -1;
      av_error := sqlerrm;
  END;

  /******************************************************************************
   Cliente está facturando, pero no aparece en IMS(LTE)   
  ******************************************************************************/
  PROCEDURE SP_REP_CLIENT_FACTU_NO_IMS_LTE(av_salida out sys_refcursor,
                                           an_error  OUT NUMBER,
                                           av_error  OUT VARCHAR2) IS
  BEGIN
    an_error := 0;
    -- Reporte líneas LTE no inscritas en IMS
    open av_salida for
      select h.numero ||','|| h.ch_status ||','|| h.ch_pending ||','|| h.ch_validfrom
        from OPERACION.prev_lteactsus h
        left join OPERACION.prev_IMS_LTE i
          on h.numero = i.num_modif
       where i.num_modif is null;
  EXCEPTION
    WHEN OTHERS THEN
      an_error := -1;
      av_error := sqlerrm;
  END;
  
  PROCEDURE SP_RES_LINEA_NO_INS_ENIMS (  av_salida OUT sys_refcursor,
                                an_error  OUT NUMBER,
                                av_error  OUT VARCHAR2)
  is
  begin
     an_error := 0;
    open av_salida for
         select 
         case when A.anio is null then B.anio else A.anio end anio ,
         case when A.mes is null then B.mes else A.mes end  mes ,
         A.activos ,  
         B.suspendidos,
        (NVL(A.activos,0) + NVL(B.suspendidos,0)) Total
from 
(SELECT to_char( h.ch_validfrom,'YYYY') anio , 
       to_char( h.ch_validfrom,'MM') mes,
       count(*) activos
 FROM (select h.*
        from OPERACION.prev_lteactsus h
        left join OPERACION.prev_IMS_LTE i
          on h.numero = i.num_modif
       where i.num_modif is null) h
 where h.ch_status = 'a'
group by to_char( h.ch_validfrom,'YYYY') ,  
         to_char( h.ch_validfrom,'MM') ) A

full join 
(SELECT to_char( h.ch_validfrom,'YYYY') anio , 
       to_char( h.ch_validfrom,'MM') mes,
       count(*) suspendidos
 FROM (select h.*
        from OPERACION.prev_lteactsus h
        left join OPERACION.prev_IMS_LTE i
          on h.numero = i.num_modif
       where i.num_modif is null) h
 where h.ch_status = 's'
group by to_char( h.ch_validfrom,'YYYY') ,  
         to_char( h.ch_validfrom,'MM')) B
on a.anio = b.anio and a.mes = b.mes;



EXCEPTION
    WHEN OTHERS THEN
      an_error := -1;
      av_error := sqlerrm;
  
  end;
  
  PROCEDURE SP_RES_LINEA_NO_UDB (  av_salida OUT sys_refcursor,
                                an_error  OUT NUMBER,
                                av_error  OUT VARCHAR2)
  is
  begin
     an_error := 0;
    open av_salida for
         select 
         case when A.anio is null then B.anio else A.anio end anio ,
         case when A.mes is null then B.mes else A.mes end  mes ,
         A.activos ,  
         B.suspendidos,
        (NVL(A.activos,0) + NVL(B.suspendidos,0)) Total
from 
(SELECT to_char( h.ch_validfrom,'YYYY') anio , 
       to_char( h.ch_validfrom,'MM') mes,
       count(*) activos
 FROM ( SELECT l.*
        FROM OPERACION.prev_lteactsus l
        left JOIN OPERACION.PREV_UDB_LTE u
          on l.numero = u.num_modif
       WHERE u.numero is NULL
         and LENGTH(l.numero) = 8) h
 where h.ch_status = 'a'
group by to_char( h.ch_validfrom,'YYYY') ,  
         to_char( h.ch_validfrom,'MM') ) A

full join 
(SELECT to_char( h.ch_validfrom,'YYYY') anio , 
       to_char( h.ch_validfrom,'MM') mes,
       count(*) suspendidos
 FROM (SELECT l.*
        FROM OPERACION.prev_lteactsus l
        left JOIN OPERACION.PREV_UDB_LTE u
          on l.numero = u.num_modif
       WHERE u.numero is NULL
         and LENGTH(l.numero) = 8) h
 where h.ch_status = 's'
group by to_char( h.ch_validfrom,'YYYY') ,  
         to_char( h.ch_validfrom,'MM')) B
on a.anio = b.anio and a.mes = b.mes;


EXCEPTION
    WHEN OTHERS THEN
      an_error := -1;
      av_error := sqlerrm;
  
end;


PROCEDURE SP_RES_BSCS_PCRF (  av_salida OUT sys_refcursor,
                                an_error  OUT NUMBER,
                                av_error  OUT VARCHAR2)
  is
  begin
     an_error := 0;
    open av_salida for
         select 
         case when A.anio is null then B.anio else A.anio end anio ,
         case when A.mes is null then B.mes else A.mes end  mes ,
         A.activos ,  
         B.suspendidos,
        (NVL(A.activos,0) + NVL(B.suspendidos,0)) Total
from 
(SELECT to_char( h.ch_validfrom,'YYYY') anio , 
       to_char( h.ch_validfrom,'MM') mes,
       count(*) activos
 FROM ( select * FROM OPERACION.PREV_DIFPCRF) h
 where h.ch_status = 'a'
group by to_char( h.ch_validfrom,'YYYY') ,  
         to_char( h.ch_validfrom,'MM') ) A

full join 
(SELECT to_char( h.ch_validfrom,'YYYY') anio , 
       to_char( h.ch_validfrom,'MM') mes,
       count(*) suspendidos
 FROM (select * FROM OPERACION.PREV_DIFPCRF) h
 where h.ch_status = 's'
group by to_char( h.ch_validfrom,'YYYY') ,  
         to_char( h.ch_validfrom,'MM')) B
on a.anio = b.anio and a.mes = b.mes;



EXCEPTION
    WHEN OTHERS THEN
      an_error := -1;
      av_error := sqlerrm;
  
end;


PROCEDURE SP_RES_INT_GRATIS (  av_salida OUT sys_refcursor,
                                an_error  OUT NUMBER,
                                av_error  OUT VARCHAR2)
  is
  begin
     an_error := 0;
    open av_salida for
         select 
         case when A.anio is null then B.anio else A.anio end anio ,
         case when A.mes is null then B.mes else A.mes end  mes ,
         A.activos ,  
         B.suspendidos,
        (NVL(A.activos,0) + NVL(B.suspendidos,0)) Total
from 
(SELECT to_char( h.ch_validfrom,'YYYY') anio , 
       to_char( h.ch_validfrom,'MM') mes,
       count(*) activos
 FROM ( SELECT l.*
        FROM OPERACION.PREV_LTEINTERNETGRATIS l
        LEFT JOIN OPERACION.PREV_PCRF p
          ON p.linea = l.dn_num
        LEFT JOIN OPERACION.PREV_WIMAXF3 w
          ON w.customer_id = l.customer_id
       WHERE p.linea IS NOT NULL
         AND w.customer_id IS NULL) h
 where h.ch_status = 'a'
group by to_char( h.ch_validfrom,'YYYY') ,  
         to_char( h.ch_validfrom,'MM') ) A

full join 
(SELECT to_char( h.ch_validfrom,'YYYY') anio , 
       to_char( h.ch_validfrom,'MM') mes,
       count(*) suspendidos
 FROM (SELECT l.*
        FROM OPERACION.PREV_LTEINTERNETGRATIS l
        LEFT JOIN OPERACION.PREV_PCRF p
          ON p.linea = l.dn_num
        LEFT JOIN OPERACION.PREV_WIMAXF3 w
          ON w.customer_id = l.customer_id
       WHERE p.linea IS NOT NULL
         AND w.customer_id IS NULL) h
 where h.ch_status = 's'
group by to_char( h.ch_validfrom,'YYYY') ,  
         to_char( h.ch_validfrom,'MM')) B
on a.anio = b.anio and a.mes = b.mes;



EXCEPTION
    WHEN OTHERS THEN
      an_error := -1;
      av_error := sqlerrm;
  
end;
  

PROCEDURE SP_REP_VAL_INCOGNITO( av_salida OUT sys_refcursor,
                                an_error out number,
                                av_error out varchar2) is

begin
   an_error := 0;
   INTRAWAY.SP_GET_DATA_REPORTE(av_salida, an_error, av_error);
EXCEPTION
    WHEN OTHERS THEN
      an_error := -1;
      av_error := sqlerrm;
end;

end PKG_ALINEA_BSCS_IMS_UDB_LTE;
/