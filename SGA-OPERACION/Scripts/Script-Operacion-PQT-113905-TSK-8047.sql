alter table OPERACION.SOLOTPTOEQU add IDDET number(10);
alter table OPERACION.OPE_SRV_RECARGA_CAB add FLG_ENVIO_SISACT NUMBER;
comment on column OPERACION.OPE_SRV_RECARGA_CAB.FLG_ENVIO_SISACT is 'Flag de Envio a SISACT';

alter table OPERACION.OPE_SRV_RECARGA_CAB add NRO_CONTRATO VARCHAR2(500);
comment on column OPERACION.OPE_SRV_RECARGA_CAB.NRO_CONTRATO is 'Número de contrato';

alter table OPERACION.OPE_SRV_RECARGA_CAB add FLG_ENVIO_ACT VARCHAR2(500);
comment on column OPERACION.OPE_SRV_RECARGA_CAB.FLG_ENVIO_ACT is 'Flag de Envio a Activación';
--Grant operacion.PQ_INTEGRACION_DTH
grant execute on operacion.PQ_INTEGRACION_DTH to usrwebunipost;


declare
ln_tipope number;
begin
select max(tipopedd) into ln_tipope from operacion.tipopedd;
insert into operacion.tipopedd
  (tipopedd, descripcion, abrev )
  values
  (ln_tipope + 1, 'Soluciones de Paq Inalambr aut', 'DTH_AUTOMATICO');
     
insert into operacion.opedd
  (codigon, descripcion, tipopedd, abreviacion, codigon_aux)
values
  (67, 'TV Satelital', ln_tipope + 1, 'DTH_AUTOMATICO', 1);
  
  commit;
end;
/

--RQM 161362
-- Creacion del campo CODIGO_CLARIFY
alter table OPERACION.SOLOT add  CODIGO_CLARIFY  NUMBER(20);

---- Configuracion de los tipos de transaccion ----------
insert into OPERACION.TIPOPEDD (TIPOPEDD, DESCRIPCION, ABREV)
values ((select max(tipopedd) + 1 from TIPOPEDD), 'Tipo de Trans DTH PostPago', 'TIPO_TRANS_DTH');
COMMIT;
INSERT INTO OPERACION.OPEDD (tipopedd,CODIGON,Descripcion,Abreviacion) VALUES ((select max(tipopedd) from TIPOPEDD), 497,'Traslado Interno', 'TI_DTH');
INSERT INTO OPERACION.OPEDD (tipopedd,CODIGON,Descripcion,Abreviacion) VALUES ((select max(tipopedd) from TIPOPEDD), 498,'Mantenimiento', 'M_DTH');
INSERT INTO OPERACION.OPEDD (tipopedd,CODIGON,Descripcion,Abreviacion) VALUES ((select max(tipopedd) from TIPOPEDD), 612,'Traslado Externo', 'TE_DTH');
commit;
----- Configuracion del Area de Trabajo y Motivo de Trabajo -------------
insert into OPERACION.TIPOPEDD (TIPOPEDD, DESCRIPCION, ABREV)
values ((select max(tipopedd) + 1 from TIPOPEDD), 'Tipo de Datos SOLOT DTH', 'DATO_SOLOT_DTH');
COMMIT;
INSERT INTO OPERACION.OPEDD (tipopedd,CODIGON,Descripcion,Abreviacion) VALUES ((select max(tipopedd) from TIPOPEDD),61,'Area de Trabajo', 'AREA_TRA_DTH');
INSERT INTO OPERACION.OPEDD (tipopedd,CODIGON,Descripcion,Abreviacion) VALUES ((select max(tipopedd) from TIPOPEDD),61,'Motivo', 'MOTIVO_TRA_DTH');
commit;

-- Configuracion de las constantes
INSERT INTO OPERACION.CONSTANTE(CONSTANTE,DESCRIPCION,TIPO,VALOR)
VALUES('DTH_DIRSUC','Direccion de la Sucursal','C','DIRECCION DTH');
INSERT INTO OPERACION.CONSTANTE(CONSTANTE,DESCRIPCION,TIPO,VALOR)
VALUES('DTH_NOMSUC','Nombre de la Sucursal','C','SUCURSAL');
commit;



insert into OPERACION.SGA_AP_PARAMETRO (PRMTC_TIPO_PARAM,PRMTN_CODIGO_PARAM,PRMTV_DESCRIPCION,PRMTC_ESTADO,PRMTV_VALOR) VALUES('WSDTH',1,'Namespace',1,'http://claro.com.pe/eai/ActivacionmientoDTH');
insert into OPERACION.SGA_AP_PARAMETRO (PRMTC_TIPO_PARAM,PRMTN_CODIGO_PARAM,PRMTV_DESCRIPCION,PRMTC_ESTADO,PRMTV_VALOR) VALUES('WSDTH',2,'Url',1,'http://172.19.74.156:8909/ActivacionDTHWS/EbsActivacionDTHSoapPort');
insert into OPERACION.SGA_AP_PARAMETRO (PRMTC_TIPO_PARAM,PRMTN_CODIGO_PARAM,PRMTV_DESCRIPCION,PRMTC_ESTADO,PRMTV_VALOR) VALUES('WSDTH',3,'Accion',1,'http://claro.com.pe/eai/ActivacionDTH/ejecutaActivacionDTH');
insert into OPERACION.SGA_AP_PARAMETRO (PRMTC_TIPO_PARAM,PRMTN_CODIGO_PARAM,PRMTV_DESCRIPCION,PRMTC_ESTADO,PRMTV_VALOR) VALUES('WSDTH',4,'Trama',1,'<act:ActivacionDTHRequest xmlns:act="@namespace"><act:idTransaccion>@idTransaccion</act:idTransaccion><act:ipAplicacion>@ipAplicacion</act:ipAplicacion><act:aplicacion>@aplicacion</act:aplicacion><act:contrato>@contrato</act:contrato><act:servicio>@servicio</act:servicio><act:usuario>@usuario</act:usuario></act:ActivacionDTHRequest>');
insert into OPERACION.SGA_AP_PARAMETRO (PRMTC_TIPO_PARAM,PRMTN_CODIGO_PARAM,PRMTV_DESCRIPCION,PRMTC_ESTADO,PRMTV_VALOR) VALUES('WSDTH',5,'idTransaccion',1,'/ActivacionDTHResponse/idTransaccion/text()');
insert into OPERACION.SGA_AP_PARAMETRO (PRMTC_TIPO_PARAM,PRMTN_CODIGO_PARAM,PRMTV_DESCRIPCION,PRMTC_ESTADO,PRMTV_VALOR) VALUES('WSDTH',6,'codRpta',1,'/ActivacionDTHResponse/codRpta/text()');
insert into OPERACION.SGA_AP_PARAMETRO (PRMTC_TIPO_PARAM,PRMTN_CODIGO_PARAM,PRMTV_DESCRIPCION,PRMTC_ESTADO,PRMTV_VALOR) VALUES('WSDTH',7,'msgRpta',1,'/ActivacionDTHResponse/msgRpta/text()');
insert into OPERACION.SGA_AP_PARAMETRO (PRMTC_TIPO_PARAM,PRMTN_CODIGO_PARAM,PRMTV_DESCRIPCION,PRMTC_ESTADO,PRMTV_VALOR) VALUES('WSDTH',8,'Aplicacion',1,'DTH');
insert into OPERACION.SGA_AP_PARAMETRO (PRMTC_TIPO_PARAM,PRMTN_CODIGO_PARAM,PRMTV_DESCRIPCION,PRMTC_ESTADO,PRMTV_VALOR) VALUES('WSDTH',9,'Operacion',1,'S_PVU_ACTIVACION_DTH');
insert into OPERACION.SGA_AP_PARAMETRO (PRMTC_TIPO_PARAM,PRMTN_CODIGO_PARAM,PRMTV_DESCRIPCION,PRMTC_ESTADO,PRMTV_VALOR) VALUES('WSDTH',10,'Usuario',1,'SISACT');
commit;



declare
ln_tipope number;
begin
select max(tipopedd) into ln_tipope from operacion.tipopedd;
insert into operacion.tipopedd
  (tipopedd, descripcion, abrev )
  values
  (ln_tipope + 1, 'Parametros-DTH Postpago', 'WSDTH');
     
insert into operacion.opedd
  (codigon, descripcion, tipopedd, abreviacion, codigon_aux)
values
  (1, '172.19.36.30', ln_tipope + 1, 'IPAPLICACION', 1);
insert into operacion.opedd
  (codigon, descripcion, tipopedd, abreviacion, codigon_aux)
values
  (2, 'SGA', ln_tipope + 1, 'APLICACION', 1); 
insert into operacion.opedd
  (codigon, descripcion, tipopedd, abreviacion, codigon_aux)
values
  (3, 'S_PVU_ACTIVACION_DTH', ln_tipope + 1, 'SERVICIO', 1);
insert into operacion.opedd
  (codigon, descripcion, tipopedd, abreviacion, codigon_aux)
values
  (4, 'USRSGA', ln_tipope + 1, 'USUARIO', 1);    
  commit;
end;
/