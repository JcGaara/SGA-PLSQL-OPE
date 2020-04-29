CREATE OR REPLACE PROCEDURE OPERACION.P_GENERA_SCOREFIJA(p_mensaje IN OUT NUMBER) IS

/************************************************************************
  NOMBRE: P_GENERA_SCOREFIJA
  PROPOSITO: Genera informacion de las facturas de los clientes
  PROGRAMADO EN JOB: NO
  REVISIONES:
  Versión    Fecha           Autor            Descripción
  ---------  ----------      ---------------  -----------------------
  1.0        20/03/2013      Juan Carlos Ortiz <REQ 163949>. Creación
  2.0        23/05/2013      Roy Concepcion    SD-611066  
************************************************************************/

  CURSOR cur_aplinc IS
    SELECT a.idfac, trunc(MAX(fecusu)) aplinc
      FROM collections.TIM_FACT_CLIENT_HISTORY a, faccanfac b
     WHERE a.idfac = b.idfaccan
     GROUP BY a.idfac;

  CURSOR cur_scorefija IS
    SELECT v.idfac,
           to_number(v.codcli) codigo,
           v.doc_identidad,
           v.tipo,
           v.Instalacion,
           to_number(v.idfac) serie,
           v.numsut,
           v.fecemi,
           v.valtot,
           v.vencimiento,
           v.total,
           v.saldo,
           v.fecultimoPago,
           v.fecultimosusp,
           v.fecultimoDesb
      FROM collections.v_con_score_cobranza v
     WHERE v.valtot > 0
       AND v.tipdoc <> 'N/C'
       AND v.fecemi >= trunc(SYSDATE) - 365
     ORDER BY v.sersut || '-' || v.numsut;

  sf cur_scorefija%ROWTYPE;
  c  cur_aplinc%ROWTYPE;

BEGIN

  DELETE collections.TIM_FACT_CLIENT_HISTORY;
  COMMIT;
  --delete TIM_FACT_CLIENT_HISTORY@DBL_BSCS_BF where plataforma = 'FIJA';
  delete TIM.TIM_FACT_CLIENT_HISTORY@DBL_BSCS_BF where plataforma = 'FIJA';--2.0
  commit;

  OPEN cur_scorefija;
  LOOP
    FETCH cur_scorefija
      INTO sf;
    EXIT WHEN cur_scorefija%NOTFOUND;
    
    INSERT INTO collections.TIM_FACT_CLIENT_HISTORY
      (idfac,
       CUSTOMER_ID,
       RUC_DNI,
       TIPO_DOC,
       FEC_ACT_CTA,
       OHXACT,
       OHREFNUM,
       fecha_emision,
       FECHA_VENC,
       MONTO_FACTURADO,
       SALDO,
       FEC_ULT_PAGO,
       FEC_BLOQ,
       FEC_DESBLOQ)
    VALUES
      (sf.idfac,
       sf.codigo,
       sf.doc_identidad,
       sf.tipo,
       sf.instalacion,
       sf.serie,
       sf.numsut,
       sf.fecemi,
       sf.vencimiento,
       sf.total,
       sf.saldo,
       sf.fecultimopago,
       sf.fecultimosusp,
       sf.fecultimodesb);
    COMMIT;
  
  END LOOP;
  CLOSE cur_scorefija;
  --insert into TIM.TIM_FACT_CLIENT_HISTORY@DBL_BSCS_BF
  insert into TIM.TIM_FACT_CLIENT_HISTORY@DBL_BSCS_BF--2.0
    (CUSTOMER_ID,
     RUC_DNI,
     FEC_ACT_CTA,
     OHXACT,
     OHREFNUM,
     fecha_emision,
     FECHA_VENC,
     MONTO_FACTURADO,
     FEC_ULT_PAGO,
     FEC_BLOQ,
     FEC_DESBLOQ,
     PLATAFORMA)
    (select CUSTOMER_ID,
            RUC_DNI,
            FEC_ACT_CTA,
            OHXACT,
            OHREFNUM,
            fecha_emision,
            FECHA_VENC,
            MONTO_FACTURADO,
            FEC_ULT_PAGO,
            FEC_BLOQ,
            FEC_DESBLOQ,
            'FIJA' PLATAFORMA
       from collections.tim_fact_client_history);

  -- Aplicacion de Nota de Credito

  OPEN cur_aplinc;
  LOOP
    FETCH cur_aplinc
      INTO c;
    EXIT WHEN cur_aplinc%NOTFOUND;
  
    UPDATE collections.TIM_FACT_CLIENT_HISTORY T
       SET T.FECHAULT_APLINC = c.aplinc
     WHERE T.idfac = c.idfac;
    COMMIT;
  END LOOP;
  CLOSE cur_aplinc;
  p_mensaje := SQLCODE;
EXCEPTION
  WHEN OTHERS THEN
    p_mensaje := SQLCODE;
  
END;
/
