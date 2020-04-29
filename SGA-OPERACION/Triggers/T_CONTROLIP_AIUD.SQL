CREATE OR REPLACE TRIGGER OPERACION.T_CONTROLIP_AIUD
  AFTER INSERT OR UPDATE OR DELETE ON OPERACION.CONTROLIP
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
    DECLARE
    l_type CHAR(1);
    l_log  HISTORICO.CONTROLIP_LOG%ROWTYPE;
    ln_idlog number(10);

    FUNCTION get_user RETURN VARCHAR2 IS
      l_user VARCHAR2(30);
      BEGIN
        SELECT MAX(OSUSER)
        INTO l_user
        FROM V$SESSION
        WHERE audsid = (SELECT USERENV('SESSIONID') FROM dual);
        RETURN TRIM(RPAD(USER || '-' || l_user, 50));
      END;

    BEGIN

      IF :OLD.ips_cpe_fija <> :NEW.ips_cpe_fija OR :OLD.mac_cpe_fija <> :NEW.mac_cpe_fija OR :OLD.ips_cpe_fija <> :NEW.ips_cpe_fija OR :OLD.fec_alta <> :NEW.fec_alta OR
         :OLD.fec_baja <> :NEW.fec_baja OR :OLD.estado <> :NEW.estado THEN

         select historico.sq_controlip_log_id.nextval into ln_idlog  from dual;

        IF :NEW.estado = 1 and :OLD.estado = 0 THEN
          l_type := 'I';
          l_log.id_log           := ln_idlog;
          l_log.id_operacion    := l_type;
          l_log.user_reg        := get_user();
          l_log.date_reg        := SYSDATE;
          l_log.idcontrol       := :NEW.idcontrol;
          l_log.cod_cid         := :NEW.cod_cid;
          l_log.cod_solot       := :NEW.cod_solot;
          l_log.codinssrv       := :NEW.codinssrv;
          l_log.mac_address_cm  := :NEW.mac_address_cm;
          l_log.num_serie       := :NEW.num_serie;
          l_log.modelo          := :NEW.modelo;
          l_log.red_pc          := :NEW.red_pc;
          l_log.id_servicio     := :NEW.id_servicio;
          l_log.id_producto     := :NEW.id_producto;
          l_log.id_venta        := :NEW.id_venta;
          l_log.ips_cpe_fija    := :NEW.ips_cpe_fija;
          l_log.mac_cpe_fija    := :NEW.mac_cpe_fija;
          l_log.dispositivo     := :NEW.dispositivo;
          l_log.fec_alta        := :NEW.fec_alta;
          l_log.fec_baja        := :NEW.fec_baja;
          l_log.codusu          := :NEW.codusu;
          l_log.fecusu          := :NEW.fecusu;
          l_log.estado          := :NEW.estado;

          INSERT INTO HISTORICO.CONTROLIP_LOG VALUES l_log;
        ELSIF :NEW.estado =  0 and :old.estado = 1 THEN
          l_type := 'D';
          l_log.id_log           := ln_idlog;
          l_log.id_operacion    := l_type;
          l_log.user_reg        := get_user();
          l_log.date_reg        := SYSDATE;
          l_log.idcontrol       := :NEW.idcontrol;
          l_log.cod_cid         := :NEW.cod_cid;
          l_log.cod_solot       := :NEW.cod_solot;
          l_log.codinssrv       := :NEW.codinssrv;
          l_log.mac_address_cm  := :NEW.mac_address_cm;
          l_log.num_serie       := :NEW.num_serie;
          l_log.modelo          := :NEW.modelo;
          l_log.red_pc          := :NEW.red_pc;
          l_log.id_servicio     := :NEW.id_servicio;
          l_log.id_producto     := :NEW.id_producto;
          l_log.id_venta        := :NEW.id_venta;
          l_log.ips_cpe_fija    := :NEW.ips_cpe_fija;
          l_log.mac_cpe_fija    := :NEW.mac_cpe_fija;
          l_log.dispositivo     := :NEW.dispositivo;
          l_log.fec_alta        := :NEW.fec_alta;
          l_log.fec_baja        := :NEW.fec_baja;
          l_log.codusu          := :NEW.codusu;
          l_log.fecusu          := :NEW.fecusu;
          l_log.estado          := :NEW.estado;

          INSERT INTO HISTORICO.CONTROLIP_LOG VALUES l_log;
        END IF;
      END IF;
END;
/