CREATE OR REPLACE TRIGGER OPERACION.T_SIAC_NEGOCIO_REGLA_AIUD
  AFTER INSERT OR UPDATE OR DELETE ON OPERACION.SIAC_NEGOCIO_REGLA
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
  /***************************************************************************************************
    NAME:       OPERACION.T_CONFIG_BI
    REVISIONS:
    Ver          Date         Author          Description
    ---------    ----------  -------------  --------------------------------------------------------
    1.0          10/10/2013  Carlos Chamache  Req 164619 Proyecto Post venta HFC en SIAC
***************************************************************************************************/
    DECLARE  
    l_type CHAR(1);
    l_log  HISTORICO.SIAC_NEGOCIO_REGLA_LOG%ROWTYPE;
    
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
      IF INSERTING THEN
        l_type := 'I';
        l_log.log_type := l_type;
        l_log.user_reg := get_user();
        l_log.date_reg := SYSDATE;
        l_log.IDREGLA := :NEW.IDREGLA;
        l_log.IDNEGOCIO := :NEW.IDNEGOCIO;
        l_log.ORDEN := :NEW.ORDEN;
        l_log.DESCRIPCION := :NEW.DESCRIPCION;
        l_log.SENTENCIA := :NEW.SENTENCIA;
        l_log.TIPO := :NEW.TIPO;
        l_log.FLG_ACTIVO := :NEW.FLG_ACTIVO;        
        
        INSERT INTO HISTORICO.SIAC_NEGOCIO_REGLA_LOG VALUES l_log;    
      ELSIF UPDATING OR DELETING THEN
        IF UPDATING THEN
          l_type := 'U';
        ELSIF DELETING THEN
          l_type := 'D';
        END IF;
        
        l_log.log_type := l_type;
        l_log.user_reg := get_user();
        l_log.date_reg := SYSDATE;          
        l_log.IDREGLA := :OLD.IDREGLA;
        l_log.IDNEGOCIO := :OLD.IDNEGOCIO;
        l_log.ORDEN := :OLD.ORDEN;
        l_log.DESCRIPCION := :OLD.DESCRIPCION;
        l_log.SENTENCIA := :OLD.SENTENCIA;
        l_log.TIPO := :OLD.TIPO;
        l_log.FLG_ACTIVO := :OLD.FLG_ACTIVO;
        
        INSERT INTO HISTORICO.SIAC_NEGOCIO_REGLA_LOG VALUES l_log;
      END IF;
END;
/