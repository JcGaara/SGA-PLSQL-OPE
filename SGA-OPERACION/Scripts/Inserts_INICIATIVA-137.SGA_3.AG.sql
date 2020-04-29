ALTER TABLE OPERACION.OPE_CAB_XML ADD (TIMEOUT NUMBER DEFAULT 180000);
comment on column OPERACION.OPE_CAB_XML.TIMEOUT
  is 'Tiempo de connexion del servicio';

ALTER TABLE OPERACION.OPE_WS_INCOGNITO ADD (TIPO_TRS NUMBER DEFAULT 1,EST_ENVIO NUMBER DEFAULT 0,METODO VARCHAR2(200),IDSEQ NUMBER,AGRUPADOR VARCHAR2(500));
comment on column OPERACION.OPE_WS_INCOGNITO.TIPO_TRS
  is 'Tipo de transaccion 1: Secuencial 2:Masivo';
comment on column OPERACION.OPE_WS_INCOGNITO.EST_ENVIO
  is 'Estado de envio';
comment on column OPERACION.OPE_WS_INCOGNITO.METODO
  is 'Metodo del servicio';
comment on column OPERACION.OPE_WS_INCOGNITO.IDSEQ
  is 'Id secuencial del WS';
comment on column OPERACION.OPE_WS_INCOGNITO.AGRUPADOR
  is 'Agrupador';
 
 
DECLARE
NEWSEQ NUMBER;
BEGIN
  SELECT MAX(IDSEQ)+1 INTO NEWSEQ FROM OPERACION.OPE_det_XML;
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (81, NEWSEQ, 'codmotot', 'select codmotot from OPERACION.SOLOT where codsolot = :pv_codsolot', 5, 1, null, 'proceso masivo');
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (82, NEWSEQ+1, 'codmotot', 'select codmotot from OPERACION.SOLOT where codsolot = :pv_codsolot', 5, 1, null, 'proceso masivo');
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (83, NEWSEQ+2, 'codmotot', 'select codmotot from OPERACION.SOLOT where codsolot = :pv_codsolot', 5, 1, null, 'proceso masivo');
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (84, NEWSEQ+3, 'codmotot', 'select codmotot from OPERACION.SOLOT where codsolot = :pv_codsolot', 5, 1, null, 'proceso masivo');
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (85, NEWSEQ+4, 'codmotot', 'select codmotot from OPERACION.SOLOT where codsolot = :pv_codsolot', 5, 1, null, 'proceso masivo');
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (86, NEWSEQ+5, 'codmotot', 'select codmotot from OPERACION.SOLOT where codsolot = :pv_codsolot', 5, 1, null, 'proceso masivo');
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (87, NEWSEQ+6, 'codmotot', 'select codmotot from OPERACION.SOLOT where codsolot = :pv_codsolot', 5, 1, null, 'proceso masivo');
END;
/


DECLARE
NEWSEQ NUMBER;
BEGIN
  SELECT MAX(IDSEQ)+1 INTO NEWSEQ FROM OPERACION.OPE_det_XML;
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (88, NEWSEQ, 'codmotot', 'select codmotot from OPERACION.SOLOT where codsolot = :pv_codsolot', 5, 1, null, 'proceso masivo');
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (89, NEWSEQ+1, 'codmotot', 'select codmotot from OPERACION.SOLOT where codsolot = :pv_codsolot', 5, 1, null, 'proceso masivo');
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (90, NEWSEQ+2, 'codmotot', 'select codmotot from OPERACION.SOLOT where codsolot = :pv_codsolot', 5, 1, null, 'proceso masivo');
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (91, NEWSEQ+3, 'codmotot', 'select codmotot from OPERACION.SOLOT where codsolot = :pv_codsolot', 5, 1, null, 'proceso masivo');
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (92, NEWSEQ+4, 'codmotot', 'select codmotot from OPERACION.SOLOT where codsolot = :pv_codsolot', 5, 1, null, 'proceso masivo');
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (93, NEWSEQ+5, 'codmotot', 'select codmotot from OPERACION.SOLOT where codsolot = :pv_codsolot', 5, 1, null, 'proceso masivo');
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (94, NEWSEQ+6, 'codmotot', 'select codmotot from OPERACION.SOLOT where codsolot = :pv_codsolot', 5, 1, null, 'proceso masivo');
END;
/


DECLARE
NEWSEQ NUMBER;
BEGIN
  SELECT MAX(IDSEQ)+1 INTO NEWSEQ FROM OPERACION.OPE_det_XML;
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (79, NEWSEQ, 'codmotot', 'select codmotot from OPERACION.SOLOT where codsolot = :pv_codsolot', 5, 1, null, 'proceso masivo');
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (80, NEWSEQ+1, 'codmotot', 'select codmotot from OPERACION.SOLOT where codsolot = :pv_codsolot', 5, 1, null, 'proceso masivo');
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (113, NEWSEQ+2, 'codmotot', 'select codmotot from OPERACION.SOLOT where codsolot = :pv_codsolot', 5, 1, null, 'proceso masivo');
END;
/


declare
  ln_max_tipopedd   number;
  ln_max_opedd      number;
begin
	select max(TIPOPEDD) + 1 into ln_max_tipopedd  from operacion.tipopedd;
	insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
	values (ln_max_tipopedd, 'Provisión Masiva Shell', 'PROV_MASIVA_SHELL');

	select max(IDOPEDD) + 1 into ln_max_opedd  from operacion.opedd;
	insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
	values ( ln_max_opedd, null, 50, 'Constante: Cantidad de registros para provisionar', 'CANT_REG_SHELL', ln_max_tipopedd, 0);
	
    insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
	values ( ln_max_opedd + 1, null, 20, 'Constante: Cantidad de hilos', 'CANT_HILOS_SHELL', ln_max_tipopedd, 0);
	
	insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
	values ( ln_max_opedd + 3, null, 1051, 'Constante: Migrasion Masiva', 'CONSTANTE_PROVISION_MASIVA', ln_max_tipopedd, 0);
	commit;
end;
/