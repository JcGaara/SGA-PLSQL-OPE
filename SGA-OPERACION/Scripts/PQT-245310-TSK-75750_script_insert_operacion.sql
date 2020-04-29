DECLARE
  ln_count NUMBER;
  ln_tipopedd NUMBER;
  ln_tiptra NUMBER;
  ln_idopedd NUMBER;
  LN_IDCAB NUMBER;
  LN_IDSEQ NUMBER;

  type t_desc is table of varchar2 (1000) index by binary_integer;
  v_desc t_desc;
  
  type t_caux is table of varchar2 (2) index by binary_integer;
  v_caux t_caux;

  type t_tiptrs is table of varchar2 (2) index by binary_integer;
  v_tiptrs t_tiptrs;
  
  type t_codigoc is table of varchar2 (2) index by binary_integer;
  v_codigoc  t_codigoc;
  
  type t_abrv is table of varchar2 (1000) index by binary_integer;
  v_abrv  t_abrv;
  
  lv_descripcion varchar2(1000); 
  ln_codigo_aux NUMBER;
  ln_TIPTRS NUMBER;
  lv_codigoc varchar2(2);
  lv_abreviacion varchar2(1000);
  
BEGIN
  ln_count := 0;
  ------------------------------------------------------------------------------------------
  -- Insercion del Tipo del listado de los tipo de datos de operaciones (tipopedd)
  ------------------------------------------------------------------------------------------

  SELECT COUNT(1)
  INTO ln_count
  FROM operacion.tipopedd
  where abrev = 'TIPO_TRANS_SIAC_LTE';

  IF ln_count = 0 THEN
    
    select max(tipopedd) + 1 into ln_tipopedd from operacion.tipopedd; 
    
    insert into operacion.tipopedd values
    (ln_tipopedd, 'Tipo de Transaccion SIAC-LTE', 'TIPO_TRANS_SIAC_LTE');
  ELSE
    select tipopedd into ln_tipopedd from operacion.tipopedd 
    where abrev = 'TIPO_TRANS_SIAC_LTE' and rownum = 1;
  END IF;
  
  ------------------------------------------------------------------------------------------
  -- Insercion del Tipo de Trabajo
  ------------------------------------------------------------------------------------------
   
  v_desc(1):= 'WLL/SIAC - MANTENIMIENTO'; v_caux(1) := '1'; v_tiptrs(1) := null; v_codigoc(1) := '1';
  v_desc(2):= 'WLL/SIAC - RETENCION'; v_caux(2) := '5'; v_tiptrs(2) := null; v_codigoc(2) := null;
  v_desc(3):= 'WLL/SIAC - RECLAMOS'; v_caux(3) := '1'; v_tiptrs(3) := null; v_codigoc(3) := '1';
  v_desc(4):= 'WLL/SIAC - CAMBIO DE PLAN'; v_caux(4) := '2'; v_tiptrs(4) := '1'; v_codigoc(4) := '4';
  v_desc(5):= 'WLL/SIAC - TRASLADO EXTERNO'; v_caux(5) := '3'; v_tiptrs(5) := '1'; v_codigoc(5) := '2';
  v_desc(6):= 'WLL/SIAC - TRASLADO INTERNO'; v_caux(6) := '4'; v_tiptrs(6) := '1'; v_codigoc(6) := '1';
  v_desc(7):= 'WLL/SIAC - DECO ADICIONAL'; v_caux(7) := '1'; v_tiptrs(7) := '1'; v_codigoc(7) := '3';
  v_desc(8):= 'WLL/SIAC - BAJA TOTAL DE SERVICIO'; v_caux(8) := null; v_tiptrs(8) := '5'; v_codigoc(8) := null;
  v_desc(9):= 'WLL/SIAC - SUSPENSION A SOLIC. DEL CLIENTE'; v_caux(9) := '5'; v_tiptrs(9) := '4'; v_codigoc(9) := null;
  v_desc(10):= 'WLL/SIAC - RECONEXION A SOLIC. DEL CLIENTE'; v_caux(10) := '5'; v_tiptrs(10) := '3'; v_codigoc(10) := null;
  v_desc(11):= 'WLL/SIAC - MANTENIMIENTO BABY SITTING'; v_caux(11) := 1; v_tiptrs(11) := null; v_codigoc(11) := '1';
  v_desc(12):= 'WLL/SIAC - FIDELIZACION'; v_caux(12) := 1; v_tiptrs(12) := null; v_codigoc(12) := '1';
  v_desc(13):= 'WLL/SIAC - PUNTO ADICIONAL'; v_caux(13) := 1; v_tiptrs(13) := null; v_codigoc(13) := '1';
  
FOR i IN 1..13 LOOP    
  lv_descripcion := v_desc(i);
  ln_codigo_aux := v_caux(i);
  ln_tiptrs := v_tiptrs(i);
  lv_codigoc := v_codigoc(i);
  v_abrv(i) := TRIM( substr(lv_descripcion, 1, 30) );
  lv_abreviacion := v_abrv(i);
   
  SELECT COUNT(1)
  INTO ln_count
  FROM OPERACION.tiptrabajo
  where descripcion = lv_descripcion;
  IF ln_count = 0 THEN
  
    select max(tiptra) + 1 into ln_tiptra from OPERACION.tiptrabajo;
  
    INSERT INTO OPERACION.tiptrabajo
    (tiptra, TIPTRS, descripcion)
    VALUES
    (ln_tiptra, ln_tiptrs, lv_descripcion);
  END IF;
  
  --insercion operacion.opedd
  select count(1)INTO ln_count from OPERACION.opedd where descripcion = lv_descripcion
  and coalesce(abreviacion, 'nul11') = coalesce(lv_abreviacion, 'nul11')
  and coalesce(codigoc, 'null1') = coalesce(lv_codigoc, 'null1');
  
  IF ln_count = 0 THEN  
    select max(idopedd) + 1 into ln_idopedd from operacion.opedd; 
    
    insert into operacion.opedd
    (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
    values
    (ln_idopedd, lv_codigoc, ln_tiptra, lv_descripcion, lv_abreviacion, ln_tipopedd, ln_codigo_aux);
  END IF;
  
 END LOOP; 
 
 update OPERACION.tiptrabajo
 set flgcom = 1, flgpryint = 0, 
 sotfacturable = 0, horas = 1, 
 hora_ini = '09:00', hora_fin = '18:30',
 agendable = 1, num_reagenda = 3, horas_antes = 5,
 corporativo = 0, selpuntossot = 1
 where DESCRIPCION = 'WLL/SIAC - MANTENIMIENTO';
 
 /* ----------------------------------------------------------------------
              TIP_TRA_CSR 
 ----------------------------------------------------------------------*/
 
   SELECT COUNT(1)
  INTO ln_count
  FROM operacion.tipopedd
  where abrev = 'TIP_TRA_CSR';

  IF ln_count = 0 THEN
    
    select max(tipopedd) + 1 into ln_tipopedd from operacion.tipopedd; 
    
    insert into operacion.tipopedd values
    (ln_tipopedd, 'Config. Cx,Sx,Rx 3Play Inlm.', 'TIP_TRA_CSR');
  ELSE
    select tipopedd into ln_tipopedd from operacion.tipopedd 
    where abrev = 'TIP_TRA_CSR' and rownum = 1;
  END IF;

v_desc(1) := 'BAJA TOTAL 3PLAY INALAMBRICO'; v_codigoc(1) := '8'; v_abrv(1) := '188'; v_caux(1) := '1';
v_desc(2) := 'RECONEXION 3PLAY INALAMBRICO'; v_codigoc(2) := '9'; v_abrv(2) := '188'; v_caux(2) := '1';
v_desc(3) := 'RECONEXION 3PLAY INALAMBRICO'; v_codigoc(3) := '10'; v_abrv(3) := '188'; v_caux(3) := '1';
v_desc(4) := 'SUSPENSION 3PLAY INALAMBRICO'; v_codigoc(4) := '11'; v_abrv(4) := '188'; v_caux(4) := '1';
v_desc(5) := 'WLL/SIAC - BAJA TOTAL DE SERVICIO'; v_codigoc(5) := '8'; v_abrv(5) := '1002'; v_caux(5) := '2';
v_desc(6) := 'WLL/SIAC - RECONEXION A SOLIC. DEL CLIENTE'; v_codigoc(6) := '9'; v_abrv(6) := null; v_caux(6) := '2';
v_desc(7) := 'WLL/SIAC - SUSPENSION A SOLIC. DEL CLIENTE'; v_codigoc(7) := '10'; v_abrv(7) := null; v_caux(7) := '2';
v_desc(8) := 'WLL/SIAC - RECONEXION A SOLIC. DEL CLIENTE'; v_codigoc(8) := '11'; v_abrv(8) := null; v_caux(8) := '2';

FOR i IN 1..8 LOOP    
  lv_descripcion := v_desc(i);
  ln_codigo_aux := v_caux(i);
  ln_tiptrs := v_tiptrs(i);
  lv_codigoc := v_codigoc(i);
  lv_abreviacion := v_abrv(i);
  
  select count(1)INTO ln_count from OPERACION.opedd where descripcion = lv_descripcion
  and coalesce(abreviacion, 'nul11') = coalesce(lv_abreviacion, 'nul11')
  and codigoc = lv_codigoc;
  
  IF ln_count = 0 THEN
   select tiptra into  ln_tiptra from operacion.tiptrabajo where descripcion = lv_descripcion; 
   
    select max(idopedd) + 1 into ln_idopedd from operacion.opedd; 
    insert into operacion.opedd
    (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
    values
    (ln_idopedd, lv_codigoc, ln_tiptra, lv_descripcion, lv_abreviacion, ln_tipopedd, ln_codigo_aux);

  END IF;
END LOOP;      

commit;



---Instalacion de Configuraciones: 
INSERT INTO OPERACION.OPEDD ( CODIGON, DESCRIPCION, TIPOPEDD)
VALUES ( ( SELECT WFDEF FROM WFDEF WHERE DESCRIPCION = 'WLL/SIAC - TRASLADO EXTERNO' ), 'WLL/SIAC - TRASLADO EXTERNO',( SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE DESCRIPCION = 'OP-Asig Flujo Automaticos'));
COMMIT;
INSERT INTO OPERACION.OPEDD ( CODIGON, DESCRIPCION, TIPOPEDD)
VALUES ( ( SELECT WFDEF FROM WFDEF WHERE DESCRIPCION = 'WLL/SIAC - TRASLADO INTERNO' ), 'WLL/SIAC - TRASLADO INTERNO',( SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE DESCRIPCION = 'OP-Asig Flujo Automaticos'));
COMMIT;

INSERT INTO OPERACION.OPEDD ( CODIGON, DESCRIPCION, TIPOPEDD)
VALUES ( ( SELECT WFDEF FROM WFDEF WHERE DESCRIPCION = 'WLL/SIAC - CAMBIO DE PLAN' ), 'WLL/SIAC - CAMBIO DE PLAN',( SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE DESCRIPCION = 'OP-Asig Flujo Automaticos'));
COMMIT;


INSERT INTO OPERACION.TIPOPEDD ( DESCRIPCION, ABREV)
VALUES ( 'CONFIGURACION LTE: FLAG_ACCION', 'CONF_LTE_ACCION');
COMMIT;


INSERT INTO OPERACION.OPEDD ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ('A', 3, 'ALTA', 'VTA COMPL', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD  WHERE ABREV = 'CONF_LTE_ACCION'),3);

INSERT INTO OPERACION.OPEDD ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ('B', 0, 'BAJA', 'BAJA', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD  WHERE ABREV = 'CONF_LTE_ACCION'),5);

INSERT INTO OPERACION.OPEDD ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ('M', 2, 'MODIFICACION', 'UP/DWN/CP EQ', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD  WHERE ABREV = 'CONF_LTE_ACCION'),4);

INSERT INTO OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ('I', 1, 'IGUAL', 'RENOVACION', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD  WHERE ABREV = 'CONF_LTE_ACCION'),4);
COMMIT;

  ln_count:=0;
  select count(*) into ln_count from OPERACION.OPE_CAB_XML where PROGRAMA = 'actualizarDIRFAC';
  IF ln_count = 0 THEN
    SELECT MAX(IDCAB) + 1 INTO LN_IDCAB FROM OPERACION.OPE_CAB_XML;
    INSERT INTO OPERACION.OPE_CAB_XML
      (IDCAB, PROGRAMA, RFC, METODO, DESCRIPCION, XML, TARGET_URL)
    VALUES
      (LN_IDCAB,
       'actualizarDIRFAC',
       'Actualizar DIRFAC',
       'Actualizar DIRFAC',
       'Actualizar DIRFAC',
       '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://pe/com/claro/siacpostpago/ws" xmlns:bscs="http://claro.com/SIACPostpago/bscs_cambioDireccionPostal_request.xsd">
     <soapenv:Header/>
     <soapenv:Body>
        <ws:cambioDireccionPostal>
           <bscs:bscs_cambioDireccionPostal_request>
           @body
           </bscs:bscs_cambioDireccionPostal_request>
        </ws:cambioDireccionPostal>
     </soapenv:Body>
  </soapenv:Envelope>',
       'http://172.19.74.202:8909/SIACPostpagoWS/SIACPostpagoTxWS?WSDL');
    COMMIT;
    SELECT MAX(IDSEQ) + 1 INTO LN_IDSEQ FROM OPERACION.OPE_DET_XML;
    INSERT INTO OPERACION.OPE_DET_XML
      (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO)
    VALUES
      (LN_IDCAB,
       LN_IDSEQ,
       'cambioDireccionPostal',
       'ws:cambioDireccionPostal');
    SELECT MAX(IDSEQ) + 1 INTO LN_IDSEQ FROM OPERACION.OPE_DET_XML;
    INSERT INTO OPERACION.OPE_DET_XML
      (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO)
    VALUES
      (LN_IDCAB,
       LN_IDSEQ,
       'cambioDireccionPostal',
       'bscs:bscs_cambioDireccionPostal_request');
  end if ;

  ln_count:=0;
  select count(*) into ln_count from OPERACION.OPE_CAB_XML where PROGRAMA = 'insertarOCC';
  IF ln_count = 0 THEN
    SELECT MAX(IDCAB) + 1 INTO LN_IDCAB FROM OPERACION.OPE_CAB_XML;
    INSERT INTO OPERACION.OPE_CAB_XML
      (IDCAB, PROGRAMA, RFC, METODO, DESCRIPCION, XML, TARGET_URL)
    VALUES
      (LN_IDCAB,
       'insertarOCC',
       'Insertar OCC LTE',
       'insertarOCC_LTE',
       'Insertar OCC',
       '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
    xmlns:tran="http://claro.com.pe/eai/billingservices/bscs/transaccionocc/">
       <soapenv:Header/>
       <soapenv:Body>
          <tran:generaOCCReq>
          @body
          </tran:generaOCCReq>
       </soapenv:Body>
    </soapenv:Envelope>',
       'http://172.19.74.139:8909/Billing_Services/BSCS/Transaction/TransaccionOCC?wsdl');
    COMMIT;
    SELECT MAX(IDSEQ) + 1 INTO LN_IDSEQ FROM OPERACION.OPE_DET_XML;
    INSERT INTO OPERACION.OPE_DET_XML
      (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO)
    VALUES
      (LN_IDCAB, LN_IDSEQ, 'consultarrequest', 'typ:cancelarOrdenSGARequest');
    SELECT MAX(IDSEQ) + 1 INTO LN_IDSEQ FROM OPERACION.OPE_DET_XML;
    INSERT INTO OPERACION.OPE_DET_XML
      (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO)
    VALUES
      (LN_IDCAB, LN_IDSEQ, 'request', 'typ:cadenaRequest');
    COMMIT;
  end if ;
END;
/