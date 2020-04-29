CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_BSCS_IW IS
  /*******************************************************************************************************
   NOMBRE:       OPERACION.
   PROPOSITO:    Registrar Informacion en la Tablas de Intraway
   REVISIONES:
   Version    Fecha       Autor            Solicitado por    Descripcion
   ---------  ----------  ---------------  --------------    -----------------------------------------
    1.0       04/07/2014  Dorian Sucasaca  Hector Huaman     Registrar Informacion de  SISACT en INTRAWAY
  *******************************************************************************************************/
  PROCEDURE P_GEN_IW_SRV(A_IDTAREAWF IN NUMBER,
                         A_IDWF      IN NUMBER,
                         A_TAREA     IN NUMBER,
                         A_TAREADEF  IN NUMBER) IS                                                
    N_CODSOLOT    OPERACION.SOLOT.CODSOLOT%TYPE;
    V_MENSAJE     VARCHAR2(200);
    V_ESTADO      VARCHAR2(50);
    N_ESTADO      VARCHAR2(50);
    N_EXISTE      NUMBER;
    I_INT_MSJ_IW  INT_MENSAJE_INTRAWAY%ROWTYPE;
    I_INT_SRV_IW  INT_SERVICIO_INTRAWAY%ROWTYPE;
    ERR_PROC      EXCEPTION;

    /* Declaracion de  Cursor */
    CURSOR C_INT_MSJ IS
      SELECT IDTRS,
             ID_INTERFASE,
             MODELO,
             MAC_ADDRESS,
             UNIT_ADDRESS,
             CODIGO_EXT,
             ID_PRODUCTO,
             ID_PRODUCTO_PADRE,
             ID_SERVICIO_PADRE,
             CODCLI,
             CODSOLOT,
             CODINSSRV,
             PIDSGA,
             ID_SERVICIO,
             ESTADO,
             CODACTIVACION,
             FECUSU,
             CODUSU
      FROM   OPERACION.TRS_INTERFACE_IW 
     WHERE   CODSOLOT = N_CODSOLOT;
     
  BEGIN
      
    SELECT CODSOLOT INTO N_CODSOLOT 
      FROM WF WHERE IDWF = A_IDWF;
    
    N_ESTADO       := INTRAWAY.PQ_FND_UTILITARIO_INTERFAZ.FND_ESTADO_CARGADO;
    
    /* Asignacion de Control de Equipos */
    OPERACION.PQ_OPE_INS_EQUIPO.P_GEN_CARGA_INICIAL(N_CODSOLOT,
                                                    N_ESTADO,
                                                    V_MENSAJE);
    /* Control de Errores */                                                    
    IF N_ESTADO = 'OK' THEN 
       COMMIT;
    ELSE
       RAISE ERR_PROC;
    END IF;
      
    FOR C_IMI IN C_INT_MSJ LOOP
      
      /* Generacion de Secuenciales */   
      SELECT ID_INTERFAZ_INTRAWAY_S.NEXTVAL INTO I_INT_MSJ_IW.ID_INTERFAZ FROM DUAL;
      SELECT INT_LOTE_PROCESO_ITW.NEXTVAL   INTO I_INT_MSJ_IW.ID_LOTE     FROM DUAL;
        
      /* Asignacion de valores a INT_MENSAJE_INTRAWAY */
      I_INT_MSJ_IW.ID_SISTEMA        :=  FND_IDSISTEMA;
      I_INT_MSJ_IW.ID_CONEXION       :=  FND_IDCONEXION;
      I_INT_MSJ_IW.ID_EMPRESA        :=  FND_IDEMPRESA;
      I_INT_MSJ_IW.ID_INTERFASE      :=  C_IMI.ID_INTERFASE;
      I_INT_MSJ_IW.ID_ESTADO         :=  C_IMI.ESTADO;
      I_INT_MSJ_IW.ID_CLIENTE        :=  C_IMI.CODCLI;
      I_INT_MSJ_IW.ID_SERVICIO       :=  C_IMI.ID_SERVICIO;
      I_INT_MSJ_IW.ID_PRODUCTO       :=  C_IMI.ID_PRODUCTO;
      I_INT_MSJ_IW.ID_PRODUCTO_PADRE :=  C_IMI.ID_PRODUCTO_PADRE;
      I_INT_MSJ_IW.ID_SERVICIO_PADRE :=  C_IMI.ID_SERVICIO_PADRE;
      I_INT_MSJ_IW.MENSAJE           :=  'Operation Success';
      I_INT_MSJ_IW.FECHA_CREACION    :=  C_IMI.FECUSU;
      I_INT_MSJ_IW.CREADO_POR        :=  C_IMI.CODUSU;
      I_INT_MSJ_IW.PROCESO           :=  3; 
      I_INT_MSJ_IW.CODSOLOT          :=  C_IMI.CODSOLOT;
      I_INT_MSJ_IW.PIDSGA            :=  C_IMI.PIDSGA;
      I_INT_MSJ_IW.CODINSSRV         :=  C_IMI.CODINSSRV;
      I_INT_MSJ_IW.ESTADO            :=  N_ESTADO;
        
      /* Grabar Informacion en int_mensaje_intraway */
      P_REG_INT_MSJ_IW( I_INT_MSJ_IW, V_ESTADO, V_MENSAJE);
        
      /* Control de Errores */ 
      IF V_ESTADO = 'ERROR' THEN 
         RAISE ERR_PROC;  
      END IF;

      -- Asignacion de variables de la tabla INT_SERVICIO_INTRAWAY
      I_INT_SRV_IW.ID_PRODUCTO      :=  C_IMI.ID_PRODUCTO;
      I_INT_SRV_IW.ID_INTERFASE     :=  C_IMI.ID_INTERFASE;
      I_INT_SRV_IW.ID_CLIENTE       :=  C_IMI.CODCLI;
      I_INT_SRV_IW.ID_ACTIVACION    :=  C_IMI.CODACTIVACION;
      I_INT_SRV_IW.MACADDRESS       :=  C_IMI.MAC_ADDRESS;
      I_INT_SRV_IW.SERIALNUMBER     :=  C_IMI.UNIT_ADDRESS;
      I_INT_SRV_IW.MODELO           :=  C_IMI.MODELO;
      I_INT_SRV_IW.CODIGO_EXT       :=  C_IMI.CODIGO_EXT;
      I_INT_SRV_IW.CODSOLOT         :=  C_IMI.CODSOLOT;
      I_INT_SRV_IW.PID_SGA          :=  C_IMI.PIDSGA;
      I_INT_SRV_IW.ESTADO           :=  1;
      I_INT_SRV_IW.FECHA_CREACION   :=  C_IMI.FECUSU;
      I_INT_SRV_IW.CODINSSRV        :=  C_IMI.CODINSSRV;
      I_INT_SRV_IW.FECUSU           :=  C_IMI.FECUSU;
      I_INT_SRV_IW.CODUSU           :=  C_IMI.CODUSU;
        
      /* Validacion de Duplicidad de Informacion en Intraway */
      BEGIN
        SELECT COUNT(*)
          INTO N_EXISTE
          FROM INTRAWAY.INT_SERVICIO_INTRAWAY S
         WHERE S.ID_PRODUCTO  = I_INT_SRV_IW.PID_SGA
           AND S.ID_INTERFASE = I_INT_SRV_IW.ID_INTERFASE;
      EXCEPTION
         WHEN OTHERS THEN
           N_EXISTE := 0;
      END;
        
      /* llamado a procedimientos Especificos para cada Reserva */  
      IF  N_EXISTE = 0 THEN 
        IF  C_IMI.ID_INTERFASE =  FND_IDINTERFACE_CM THEN
          P_INT_CM(I_INT_SRV_IW,  C_IMI.IDTRS, V_ESTADO, V_MENSAJE);
        ELSIF C_IMI.ID_INTERFASE =  FND_IDINTERFACE_MTA THEN
          P_INT_MTA(I_INT_SRV_IW, C_IMI.IDTRS, V_ESTADO, V_MENSAJE);
        ELSIF C_IMI.ID_INTERFASE =  FND_IDINTERFACE_EP THEN
          P_INT_EP(I_INT_SRV_IW,  C_IMI.IDTRS, V_ESTADO, V_MENSAJE);
        ELSIF C_IMI.ID_INTERFASE =  FND_IDINTERFACE_CF THEN
          P_INT_CF(I_INT_SRV_IW,  C_IMI.IDTRS, V_ESTADO, V_MENSAJE);
        ELSIF C_IMI.ID_INTERFASE =  FND_IDINTERFACE_STB THEN
          P_INT_STB(I_INT_SRV_IW, C_IMI.IDTRS, V_ESTADO, V_MENSAJE);
        ELSIF C_IMI.ID_INTERFASE =  FND_IDINTERFACE_STB_SA THEN
          P_INT_STB_SA(I_INT_SRV_IW, C_IMI.IDTRS, V_ESTADO, V_MENSAJE);
        ELSIF C_IMI.ID_INTERFASE =  FND_IDINTERFACE_STB_VOD THEN
          P_INT_STB_VOD(I_INT_SRV_IW, C_IMI.IDTRS, V_ESTADO, V_MENSAJE);
        END IF;
      END IF;
         
      /* Control de Errores */ 
      IF V_ESTADO = 'ERROR' THEN 
         RAISE ERR_PROC;  
      END IF;
        
     END LOOP;     
     COMMIT;
  EXCEPTION
    WHEN ERR_PROC THEN
      V_MENSAJE := V_MENSAJE;
      P_REG_ERROR(A_IDTAREAWF,V_MENSAJE);
      ROLLBACK;
    WHEN OTHERS THEN
      V_MENSAJE :=  SQLERRM;
      P_REG_ERROR(A_IDTAREAWF,V_MENSAJE);
      ROLLBACK;
  END;

  PROCEDURE P_INT_CM(CM_IMI  IN INT_SERVICIO_INTRAWAY%ROWTYPE,
                     CM_ID   IN OPERACION.TRS_INTERFACE_IW.IDTRS%TYPE,
                     CM_EST  OUT VARCHAR2,
                     CM_MSJ  OUT VARCHAR2) IS
                      
    N_HUB        INTRAWAY.OPE_HUB.NOMBRE%TYPE;
    N_NODO       MARKETING.VTASUCCLI.IDPLANO%TYPE;
    N_CANT_CPE   NUMBER;
    ERR_SRV_IW   EXCEPTION;

  BEGIN
    /* Consultas */
    BEGIN
      SELECT VALOR INTO N_HUB 
        FROM OPERACION.TRS_INTERFACE_IW_DET 
       WHERE IDTRS    = CM_ID
         AND ATRIBUTO = 'Hub';
    EXCEPTION
      WHEN OTHERS THEN 
       N_HUB := NULL;  
    END;
    
    BEGIN
     SELECT VALOR INTO N_NODO 
       FROM OPERACION.TRS_INTERFACE_IW_DET 
      WHERE IDTRS    = CM_ID
        AND ATRIBUTO = 'Nodo';
    EXCEPTION
      WHEN OTHERS THEN 
       N_NODO := NULL;  
    END;
      
    BEGIN
     SELECT VALOR INTO N_CANT_CPE 
       FROM OPERACION.TRS_INTERFACE_IW_DET 
      WHERE IDTRS    = CM_ID
        AND ATRIBUTO = 'CantCPE';
    EXCEPTION
      WHEN OTHERS THEN 
       N_CANT_CPE := NULL;  
    END;
      
    /* Asignacion de Variables */   
    N_INT_SRV_IW         := CM_IMI;
    N_INT_SRV_IW.CANTCPE := N_CANT_CPE;
    N_INT_SRV_IW.MODELO  := N_HUB;
    N_INT_SRV_IW.NUMERO  := N_NODO;
      
    /* Grabar Informacion */ 
    P_REG_INT_SRV_IW( N_INT_SRV_IW, CM_EST, CM_MSJ);  
      
    /* Control de Errores */
    IF  CM_EST = 'ERROR' THEN 
      RAISE ERR_SRV_IW;
    END IF;
      
  EXCEPTION
    WHEN ERR_SRV_IW THEN
      CM_EST  := 'ERROR';
      CM_MSJ  := CM_MSJ;    
    WHEN OTHERS THEN
      CM_EST  := 'ERROR';
      CM_MSJ  := SQLERRM;                              
  END;
 
  PROCEDURE P_INT_MTA(MTA_IMI  IN INT_SERVICIO_INTRAWAY%ROWTYPE,
                      MTA_ID   IN OPERACION.TRS_INTERFACE_IW.IDTRS%TYPE,
                      MTA_EST  OUT VARCHAR2,
                      MTA_MSJ  OUT VARCHAR2) IS
                       
    N_IDCMTS       OPE_CMTS.DESCCMTS%TYPE;
    N_IDINS_EQUIPO OPE_INS_EQUIPO_CAB.IDINS_EQUIPO%TYPE;
    N_ID_VALOR     VARCHAR2(100);
    ERR_SRV_IW     EXCEPTION;
   
  BEGIN
     /* Consultas */
    BEGIN  
      SELECT S.IDPLANO
      INTO   N_IDCMTS
      FROM   VTASUCCLI S, OPE_HUB H, VTATABGEOREF V,OPE_CMTS X
      WHERE  S.IDHUB  = H.IDHUB 
        AND  S.CODSUC IN ( SELECT DISTINCT CODSUC 
                                 FROM VTADETPTOENL 
                                WHERE NUMSLC IN ( SELECT NUMSLC 
                                                    FROM SOLOT 
                                                   WHERE CODSOLOT = MTA_IMI.CODSOLOT))
        AND  S.IDPLANO = V.IDPLANO(+)
        AND  S.UBISUC  = V.CODUBI(+)
        AND  S.IDCMTS  = X.IDCMTS 
        AND  H.IDHUB   = X.IDHUB;  
    EXCEPTION
       WHEN OTHERS THEN
          N_IDCMTS:=NULL;
    END;
     
    BEGIN
     SELECT VALOR INTO N_ID_VALOR 
       FROM OPERACION.TRS_INTERFACE_IW_DET 
      WHERE IDTRS    = MTA_ID
        AND ATRIBUTO = 'ProfileCrmId';
    EXCEPTION
      WHEN OTHERS THEN 
       N_ID_VALOR := NULL;  
    END;
     
    BEGIN
     SELECT IDINS_EQUIPO INTO N_IDINS_EQUIPO
       FROM OPE_INS_EQUIPO_CAB 
      WHERE CODSOLOT = MTA_IMI.CODSOLOT;
    EXCEPTION
     WHEN OTHERS THEN 
       N_IDINS_EQUIPO :=NULL;
    END;
     
    /* Asignacion de Variables */
    N_INT_SRV_IW              := MTA_IMI;
    N_INT_SRV_IW.ID_VENTA     := NULL;
    N_INT_SRV_IW.MACADDRESS   := NULL;
    N_INT_SRV_IW.SERIALNUMBER := NULL;
    N_INT_SRV_IW.MODELO       := NULL;
    N_INT_SRV_IW.CODIGO_EXT   := N_IDCMTS;
    N_INT_SRV_IW.CMSCRMID     := N_ID_VALOR;
    N_INT_SRV_IW.IDINS_EQUIPO := N_IDINS_EQUIPO;
     
    /* Grabacion de Informacion */
    P_REG_INT_SRV_IW(N_INT_SRV_IW, MTA_EST, MTA_MSJ);
     
    /* Control de Errores */ 
    IF MTA_EST = 'ERROR' THEN 
       RAISE ERR_SRV_IW;  
    END IF;
      
  EXCEPTION
    WHEN ERR_SRV_IW THEN
      MTA_EST  := 'ERROR';
      MTA_MSJ  := MTA_MSJ;   
    WHEN OTHERS THEN
      MTA_EST  := 'ERROR';
      MTA_MSJ  := SQLERRM;                              
  END; 
 
  PROCEDURE P_INT_EP(EP_IMI  IN INT_SERVICIO_INTRAWAY%ROWTYPE,
                     EP_ID   IN OPERACION.TRS_INTERFACE_IW.IDTRS%TYPE,
                     EP_EST  OUT VARCHAR2,
                     EP_MSJ  OUT VARCHAR2) IS
                      
    N_HOMEEXCHANGECRMID  VARCHAR2(100);
    N_NUMERO             OPERACION.INSSRV.NUMERO%TYPE;
    N_PUERTO             NUMBER;
    N_ID_VALOR           VARCHAR2(100);
    ERR_SRV_IW           EXCEPTION;
  
  BEGIN
    /* Consultas */
    BEGIN
      SELECT VALOR INTO N_HOMEEXCHANGECRMID 
        FROM OPERACION.TRS_INTERFACE_IW_DET 
       WHERE IDTRS    = EP_ID
         AND ATRIBUTO = 'HomeExchangeCrmId';
    EXCEPTION
      WHEN OTHERS THEN 
       N_HOMEEXCHANGECRMID := NULL;  
    END;
      
    BEGIN
      SELECT VALOR INTO N_PUERTO 
        FROM OPERACION.TRS_INTERFACE_IW_DET 
       WHERE IDTRS    = EP_ID
         AND ATRIBUTO = 'EndPointNumber';
    EXCEPTION
      WHEN OTHERS THEN 
       N_PUERTO := NULL;  
    END;
      
    BEGIN
      SELECT VALOR INTO N_NUMERO 
        FROM OPERACION.TRS_INTERFACE_IW_DET 
       WHERE IDTRS    = EP_ID
         AND ATRIBUTO = 'TN';
    EXCEPTION
      WHEN OTHERS THEN 
       N_NUMERO := NULL;  
    END;
     
    BEGIN
     SELECT ID_VALOR
       INTO N_ID_VALOR
       FROM INT_INTERFACE_PARAMETRO
      WHERE ID_INTERFACE = EP_IMI.ID_INTERFASE
        AND ID_PARAMETRO = 'CmsCrmId';
    EXCEPTION
     WHEN OTHERS THEN 
       N_ID_VALOR := NULL;
    END;         
   
    /* Asignacion de Variables */
    N_INT_SRV_IW                    := EP_IMI;
    N_INT_SRV_IW.ID_ACTIVACION      := NULL;
    N_INT_SRV_IW.MACADDRESS         := NULL;
    N_INT_SRV_IW.SERIALNUMBER       := NULL;
    N_INT_SRV_IW.MODELO             := NULL;
    N_INT_SRV_IW.FECHA_ACTIVACION   := NULL;
    N_INT_SRV_IW.FECHA_MODIFICACION := NULL;
    N_INT_SRV_IW.CODIGO_EXT         := N_HOMEEXCHANGECRMID;
    N_INT_SRV_IW.NUMERO             := N_NUMERO;
    N_INT_SRV_IW.NROENDPOINT        := N_PUERTO;
    N_INT_SRV_IW.CMSCRMID           := N_ID_VALOR;
   
    /* Grabar en int_servicio_iw */
    P_REG_INT_SRV_IW(N_INT_SRV_IW, EP_EST, EP_MSJ);
   
    /* Control de Errores */ 
    IF EP_EST = 'ERROR' THEN 
       RAISE ERR_SRV_IW;  
    END IF;
    
  EXCEPTION
    WHEN ERR_SRV_IW THEN
       EP_EST  := 'ERROR';
       EP_MSJ  := EP_MSJ; 
    WHEN OTHERS THEN
       EP_EST  := 'ERROR';
       EP_MSJ  := SQLERRM;                              
  END; 
 
  PROCEDURE P_INT_CF(CF_IMI  IN INT_SERVICIO_INTRAWAY%ROWTYPE,
                     CF_ID   IN OPERACION.TRS_INTERFACE_IW.IDTRS%TYPE,
                     CF_EST  OUT VARCHAR2,
                     CF_MSJ  OUT VARCHAR2) IS

    N_PID       OPERACION.SOLOTPTO.PID%TYPE;
    ERR_SRV_IW  EXCEPTION;
    
  BEGIN
    /* Consultas */
    BEGIN
      SELECT VALOR INTO N_PID 
        FROM OPERACION.TRS_INTERFACE_IW_DET 
       WHERE IDTRS    = CF_ID
         AND ATRIBUTO = 'FeatureCrmId';
    EXCEPTION
      WHEN OTHERS THEN 
       N_PID := NULL;  
    END;
    
    /* Asignar Variables */ 
    N_INT_SRV_IW               := CF_IMI;
    N_INT_SRV_IW.ID_ACTIVACION := NULL;
    N_INT_SRV_IW.MACADDRESS    := NULL;
    N_INT_SRV_IW.SERIALNUMBER  := NULL;
    N_INT_SRV_IW.MODELO        := NULL;
    N_INT_SRV_IW.CODIGO_EXT    := N_PID;
    
    /* Grabar en int_servicio_iw */
    P_REG_INT_SRV_IW(N_INT_SRV_IW, CF_EST, CF_MSJ);
    
    /* Control de Errores */ 
    IF CF_EST = 'ERROR' THEN 
       RAISE ERR_SRV_IW;  
    END IF;
    
  EXCEPTION
    WHEN ERR_SRV_IW THEN
     CF_EST  := 'ERROR';
     CF_MSJ  := CF_MSJ; 
    WHEN OTHERS THEN
     CF_EST  := 'ERROR';
     CF_MSJ  := SQLERRM;                              
  END; 
 
  PROCEDURE P_INT_STB(STB_IMI   IN INT_SERVICIO_INTRAWAY%ROWTYPE,
                      STB_ID    IN OPERACION.TRS_INTERFACE_IW.IDTRS%TYPE,
                      STB_EST   OUT VARCHAR2,
                      STB_MSJ   OUT VARCHAR2) IS
                       
    N_CONFIGCRMID  VARCHAR2(100);                     
    N_COD_EXT_STB  TYSTABSRV.CODIGO_EXT%TYPE;
    ERR_SRV_IW     EXCEPTION;
   
  BEGIN
    /* Consultas */
    BEGIN
     SELECT VALOR INTO N_COD_EXT_STB 
       FROM OPERACION.TRS_INTERFACE_IW_DET 
      WHERE IDTRS    = STB_ID
        AND ATRIBUTO = 'defaultProductCRMId';
    EXCEPTION
      WHEN OTHERS THEN 
       N_COD_EXT_STB := NULL;  
    END;
    
    BEGIN
     SELECT VALOR INTO N_CONFIGCRMID 
       FROM OPERACION.TRS_INTERFACE_IW_DET 
      WHERE IDTRS    = STB_ID
        AND ATRIBUTO = 'defaultConfigCRMId';
    EXCEPTION
      WHEN OTHERS THEN 
       N_CONFIGCRMID := NULL;  
    END;
    
    /* Asignacion de Variables */
    N_INT_SRV_IW              := STB_IMI;
    N_INT_SRV_IW.MACADDRESS   := NULL;
    N_INT_SRV_IW.SERIALNUMBER := NULL;
    N_INT_SRV_IW.CODIGO_EXT   := N_COD_EXT_STB;
    N_INT_SRV_IW.MODELO       := N_CONFIGCRMID;
    
    /* Grabar en int_servicio_iw */
    P_REG_INT_SRV_IW(N_INT_SRV_IW, STB_EST, STB_MSJ);
    
    /* Control de Errores */ 
    IF STB_EST = 'ERROR' THEN 
       RAISE ERR_SRV_IW;  
    END IF;
  EXCEPTION
    WHEN ERR_SRV_IW THEN
     STB_EST  := 'ERROR';
     STB_MSJ  := STB_MSJ; 
   WHEN OTHERS THEN
     STB_EST  := 'ERROR';
     STB_MSJ  := SQLERRM;                              
  END;
 
  PROCEDURE P_INT_STB_SA(STB_SA_IMI  IN INT_SERVICIO_INTRAWAY%ROWTYPE,
                         STB_SA_ID   IN OPERACION.TRS_INTERFACE_IW.IDTRS%TYPE,
                         STB_SA_EST  OUT VARCHAR2,
                         STB_SA_MSJ  OUT VARCHAR2) IS
                          
    N_PID      OPERACION.SOLOTPTO.PID%TYPE;
    ERR_SRV_IW EXCEPTION;
    
  BEGIN
    /* Consultas */
    BEGIN
      SELECT VALOR INTO N_PID 
        FROM OPERACION.TRS_INTERFACE_IW_DET 
       WHERE IDTRS    = STB_SA_ID
         AND ATRIBUTO = 'defaultProductCRMId';
    EXCEPTION
       WHEN OTHERS THEN 
        N_PID := NULL;  
    END;
    
    /* Asignacion de Variables */   
    N_INT_SRV_IW                   := STB_SA_IMI;
    N_INT_SRV_IW.ID_ACTIVACION     := NULL;
    N_INT_SRV_IW.MACADDRESS        := NULL;
    N_INT_SRV_IW.SERIALNUMBER      := NULL;
    N_INT_SRV_IW.MODELO            := NULL;
    N_INT_SRV_IW.CODIGO_EXT        := N_PID;
    N_INT_SRV_IW.FECHA_ACTIVACION  := NULL;
    N_INT_SRV_IW.FECHA_MODIFICACION:= NULL;
    
    /* Grabar en int_servicio_iw */
    P_REG_INT_SRV_IW(N_INT_SRV_IW, STB_SA_EST, STB_SA_MSJ);
    
    /* Control de Errores */ 
    IF STB_SA_EST = 'ERROR' THEN 
       RAISE ERR_SRV_IW;  
    END IF;
  EXCEPTION
    WHEN ERR_SRV_IW THEN
     STB_SA_EST  := 'ERROR';
     STB_SA_MSJ  := STB_SA_MSJ; 
   WHEN OTHERS THEN
     STB_SA_MSJ  := 'ERROR';
     STB_SA_MSJ  := SQLERRM;                              
  END; 
  
  PROCEDURE P_INT_STB_VOD(STB_VOD_IMI  IN INT_SERVICIO_INTRAWAY%ROWTYPE,
                          STB_VOD_ID   IN OPERACION.TRS_INTERFACE_IW.IDTRS%TYPE,
                          STB_VOD_EST  OUT VARCHAR2,
                          STB_VOD_MSJ  OUT VARCHAR2) IS
                           
    N_PID      OPERACION.SOLOTPTO.PID%TYPE;
    ERR_SRV_IW EXCEPTION;
  
  BEGIN
    /* Consultas */
    BEGIN
      SELECT VALOR INTO N_PID 
        FROM OPERACION.TRS_INTERFACE_IW_DET 
       WHERE IDTRS    = STB_VOD_ID
         AND ATRIBUTO = 'VODProfileCRMId';
    EXCEPTION
      WHEN OTHERS THEN 
           N_PID := NULL;  
    END;

    /* Asignacion de Variables */
    N_INT_SRV_IW                    := STB_VOD_IMI;
    N_INT_SRV_IW.ID_ACTIVACION      := NULL;
    N_INT_SRV_IW.MACADDRESS         := NULL;
    N_INT_SRV_IW.SERIALNUMBER       := NULL;
    N_INT_SRV_IW.MODELO             := NULL;
    N_INT_SRV_IW.FECHA_ACTIVACION   := NULL;
    N_INT_SRV_IW.FECHA_MODIFICACION := NULL;
    N_INT_SRV_IW.CODIGO_EXT         := N_PID;
    
    /* Grabar en int_servicio_iw */
    P_REG_INT_SRV_IW(N_INT_SRV_IW, STB_VOD_EST, STB_VOD_MSJ);
    
    /* Control de Errores */ 
    IF STB_VOD_EST = 'ERROR' THEN 
       RAISE ERR_SRV_IW;  
    END IF;
    
  EXCEPTION
    WHEN ERR_SRV_IW THEN
      STB_VOD_EST  := 'ERROR';
      STB_VOD_MSJ  := STB_VOD_MSJ; 
    WHEN OTHERS THEN
      STB_VOD_EST  := 'ERROR';
      STB_VOD_MSJ  := SQLERRM;                              
  END; 

  PROCEDURE P_REG_INT_MSJ_IW(M_INT_MENSAJE_IW  IN INT_MENSAJE_INTRAWAY%ROWTYPE,
                             M_ESTADO          OUT VARCHAR2,
                             M_MENSAJE         OUT VARCHAR2) IS
  BEGIN
   INSERT INTO INT_MENSAJE_INTRAWAY VALUES M_INT_MENSAJE_IW;
  EXCEPTION
   WHEN OTHERS THEN
     M_ESTADO   := 'ERROR';
     M_MENSAJE  := SQLERRM;                              
  END; 
 
  PROCEDURE P_REG_INT_SRV_IW(S_INT_MENSAJE_IW  IN INT_SERVICIO_INTRAWAY%ROWTYPE,
                             S_ESTADO          OUT VARCHAR2,
                             S_MENSAJE         OUT VARCHAR2) IS
  BEGIN
   INSERT INTO INT_SERVICIO_INTRAWAY VALUES S_INT_MENSAJE_IW;
  EXCEPTION
   WHEN OTHERS THEN
     S_ESTADO   := 'ERROR';
     S_MENSAJE  := SQLERRM;                              
  END;
  
  PROCEDURE P_REG_ERROR(S_IDTAREAWF  IN TAREAWFSEG.IDTAREAWF%TYPE,
                        S_MENSAJE    IN TAREAWFSEG.OBSERVACION%TYPE) IS 
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    INSERT INTO TAREAWFSEG(IDTAREAWF,OBSERVACION)
         VALUES(S_IDTAREAWF,S_MENSAJE);   
    COMMIT;                         
  END;
END;
/
