CREATE OR REPLACE TRIGGER OPERACION.T_RANGOSIP_AIUD
/************************************************************
NOMBRE:     OPERACION.T_RANGOSIP_AIUD
PROPOSITO:  Guarda los cambios de la tabla RANGOSIP

REVISIONES:
Version      Fecha        Autor           Descripción
---------  ----------  ---------------  ------------------------
1.0        17/11/2009  José Robles    REQ.108156-Creación
*****************************************************************/
AFTER INSERT OR UPDATE OR DELETE
ON TRAFFICVIEW.RANGOSIP
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
  V_USUARIO_LOG VARCHAR2(50);
  V_DATE_LOG    DATE;
  V_TIPO_LOG    CHAR(1);
BEGIN
  SELECT MAX(OSUSER)
    INTO V_USUARIO_LOG
    FROM V$SESSION
   WHERE AUDSID = (SELECT USERENV('SESSIONID') FROM DUAL);

  V_USUARIO_LOG := V_USUARIO_LOG || '-' || USER;

  SELECT SYSDATE INTO V_DATE_LOG FROM DUAL;

  IF INSERTING THEN
    V_TIPO_LOG := 'I';
    insert into HISTORICO.RANGOSIP_LOG
      (IDRANGO,
       RANGO,
       TIPO,
       CID,
       IPLAN,
       IPLAN_MASK,
       IPWAN,
       IPWAN_MASK,
       INTEFACE,
       VELOCIDAD,
       NIVEL,
       CANTIDAD,
       ESTADO,
       FECINI,
       FECFIN,
       IPLANFIN,
       OBSERVACION,
       CODINSSRV,
       IPLOOPBACK_GESTION,
       IPLOOPBACK_VOZ,
       IPLOOPBACK_OTROS,
       IPLBGESTIONMASK,
       IPLBVOZMASK,
       IPLBOTROSMASK,
       --ini 3.0
       iplan_alamb,
       iplanmask_alamb,
       iplan_gestion,
       iplanmask_gestion,
       iplb_tunel,
       iplbmask_tunel,
       --fin 3.0
       USUARIO_LOG,
       DATE_LOG,
       TIPO_LOG)
    values
      (:new.idrango,
       :new.rango,
       :new.tipo,
       :new.cid,
       :new.iplan,
       :new.iplan_mask,
       :new.ipwan,
       :new.ipwan_mask,
       :new.inteface,
       :new.velocidad,
       :new.nivel,
       :new.cantidad,
       :new.estado,
       :new.fecini,
       :new.fecfin,
       :new.iplanfin,
       :new.observacion,
       :new.codinssrv,
       :new.iploopback_gestion,
       :new.iploopback_voz,
       :new.iploopback_otros,
       :new.iplbgestionmask,
       :new.iplbvozmask,
       :new.iplbotrosmask,
       --ini 3.0
       :new.iplan_alamb,
       :new.iplanmask_alamb,
       :new.iplan_gestion,
       :new.iplanmask_gestion,
       :new.iplb_tunel,
       :new.iplbmask_tunel,
       --fin 3.0
       V_USUARIO_LOG,
       V_DATE_LOG,
       V_TIPO_LOG);
  
  ELSIF UPDATING THEN
    V_TIPO_LOG := 'U';
    insert into HISTORICO.RANGOSIP_LOG
      (IDRANGO,
       RANGO,
       TIPO,
       CID,
       IPLAN,
       IPLAN_MASK,
       IPWAN,
       IPWAN_MASK,
       INTEFACE,
       VELOCIDAD,
       NIVEL,
       CANTIDAD,
       ESTADO,
       FECINI,
       FECFIN,
       IPLANFIN,
       OBSERVACION,
       CODINSSRV,
       IPLOOPBACK_GESTION,
       IPLOOPBACK_VOZ,
       IPLOOPBACK_OTROS,
       IPLBGESTIONMASK,
       IPLBVOZMASK,
       IPLBOTROSMASK,
       --ini 3.0
       iplan_alamb, 
       iplanmask_alamb, 
       iplan_gestion, 
       iplanmask_gestion,
       iplb_tunel,
       iplbmask_tunel,
       --fin 3.0
       USUARIO_LOG,
       DATE_LOG,
       TIPO_LOG)
    values
      (:new.idrango,
       :new.rango,
       :new.tipo,
       :new.cid,
       :new.iplan,
       :new.iplan_mask,
       :new.ipwan,
       :new.ipwan_mask,
       :new.inteface,
       :new.velocidad,
       :new.nivel,
       :new.cantidad,
       :new.estado,
       :new.fecini,
       :new.fecfin,
       :new.iplanfin,
       :new.observacion,
       :new.codinssrv,
       :new.iploopback_gestion,
       :new.iploopback_voz,
       :new.iploopback_otros,
       :new.iplbgestionmask,
       :new.iplbvozmask,
       :new.iplbotrosmask,
       --ini 3.0
       :new.iplan_alamb,
       :new.iplanmask_alamb,
       :new.iplan_gestion,
       :new.iplanmask_gestion,
       :new.iplb_tunel,
       :new.iplbmask_tunel,
       --fin 3.0
       V_USUARIO_LOG,
       V_DATE_LOG,
       V_TIPO_LOG);
  
  ELSIF DELETING THEN
    V_TIPO_LOG := 'D';
    insert into HISTORICO.RANGOSIP_LOG
      (IDRANGO,
       RANGO,
       TIPO,
       CID,
       IPLAN,
       IPLAN_MASK,
       IPWAN,
       IPWAN_MASK,
       INTEFACE,
       VELOCIDAD,
       NIVEL,
       CANTIDAD,
       ESTADO,
       FECINI,
       FECFIN,
       IPLANFIN,
       OBSERVACION,
       CODINSSRV,
       IPLOOPBACK_GESTION,
       IPLOOPBACK_VOZ,
       IPLOOPBACK_OTROS,
       IPLBGESTIONMASK,
       IPLBVOZMASK,
       IPLBOTROSMASK,
       --ini 3.0
       iplan_alamb,
       iplanmask_alamb,
       iplan_gestion,
       iplanmask_gestion,
       iplb_tunel,
       iplbmask_tunel,
       --fin 3.0
       USUARIO_LOG,
       DATE_LOG,
       TIPO_LOG)
    values
      (:old.idrango,
       :old.rango,
       :old.tipo,
       :old.cid,
       :old.iplan,
       :old.iplan_mask,
       :old.ipwan,
       :old.ipwan_mask,
       :old.inteface,
       :old.velocidad,
       :old.nivel,
       :old.cantidad,
       :old.estado,
       :old.fecini,
       :old.fecfin,
       :old.iplanfin,
       :old.observacion,
       :old.codinssrv,
       :old.iploopback_gestion,
       :old.iploopback_voz,
       :old.iploopback_otros,
       :old.iplbgestionmask,
       :old.iplbvozmask,
       :old.iplbotrosmask,
       --ini 3.0
       :old.iplan_alamb,
       :old.iplanmask_alamb,
       :old.iplan_gestion,
       :old.iplanmask_gestion,
       :old.iplb_tunel,
       :old.iplbmask_tunel,
       --fin 3.0
       V_USUARIO_LOG,
       V_DATE_LOG,
       V_TIPO_LOG);
  
  END IF;

END;
/
