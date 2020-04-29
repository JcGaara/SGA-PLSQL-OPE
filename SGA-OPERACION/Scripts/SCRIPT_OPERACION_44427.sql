-- valida 15 dias en estado Rechazado

insert into OPERACION.TIPOPEDD(DESCRIPCION,ABREV) values ('parametros de TPI GSM','TPI_GSM_LIBERACION');

insert into OPERACION.OPEDD(codigon,descripcion,abreviacion,tipopedd) values (15,'Dias de Rechazo SOT TPI GSM','DRS_TPI_GSM',(select tp.tipopedd from operacion.tipopedd tp where tp.abrev='TPI_GSM_LIBERACION'));
commit;

--- VALIDA EL WFDEF SEA INSTALACION TPI GSM 
-- wfdef= HIDES =1150 , wfdef= QA= 11157, wfdef= UAT = 1150 
insert into OPERACION.TIPOPEDD(DESCRIPCION,ABREV) values ('WORKFLOW INSTALACION TPI GSM','WF_TPI_GSM');
insert into OPERACION.OPEDD(codigon,descripcion,abreviacion,tipopedd) VALUES (1150,'WORKFLOW INSTALACION','WF_INST_TPI_GSM',(select tp.tipopedd from operacion.tipopedd tp where tp.abrev='WF_TPI_GSM'));
commit;


DECLARE
  LI_COUNT    NUMBER;
  LI_TIPOPEDD NUMBER;
  LI_OPEDD    NUMBER;
BEGIN
  SELECT COUNT(1)
    INTO LI_COUNT
    FROM TIPOPEDD
   WHERE ABREV = 'Tiptrabajo_TPIGSM';

  IF LI_COUNT = 0 THEN
    SELECT MAX(TIPOPEDD) + 1 INTO LI_TIPOPEDD FROM TIPOPEDD;
    INSERT INTO TIPOPEDD
      (TIPOPEDD, DESCRIPCION, ABREV)
    VALUES
      (LI_TIPOPEDD, 'Tipo de trabajo para TPI- GSM', 'Tiptrabajo_TPIGSM');

    SELECT MAX(IDOPEDD) + 1 INTO LI_OPEDD FROM OPEDD;
    INSERT INTO OPEDD
      (IDOPEDD,
       CODIGOC,
       CODIGON,
       DESCRIPCION,
       ABREVIACION,
       TIPOPEDD,
       CODIGON_AUX)
    VALUES
      (LI_OPEDD,
       NULL,
       661,
       'Tipo de trabajo para TPI',
       'TRABAJO_TPI',
       LI_TIPOPEDD,
       NULL);
   END IF;
END;
/

COMMIT;


