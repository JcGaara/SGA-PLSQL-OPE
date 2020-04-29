/*Se agregan campos a la tabla OPERACION.OPE_SOL_SIAC*/
alter table OPERACION.OPE_SOL_SIAC add estado number;
alter table OPERACION.OPE_SOL_SIAC add servi_cod number;
alter table OPERACION.OPE_SOL_SIAC add fecmod date;
alter table OPERACION.OPE_SOL_SIAC add usumod VARCHAR2(100);
alter table OPERACION.OPE_SOL_SIAC add flgfideliza number;
alter table OPERACION.OPE_SOL_SIAC add codinteracion varchar2(40);
alter table OPERACION.OPE_SOL_SIAC add fecha_prog date;

/*Se crea la cabecera de los parametros en la tipopedd*/
insert into tipopedd (DESCRIPCION, ABREV)
values ('HFC/SIAC DECO ADICIONAL', 'HFC_SIAC_DEC_ADICIONAL');


/*Se crean variables en la opedd*/
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 2240, 'CODIGO OCC - HFC/SIAC DECO ADICIONAL', 'COD_OCC', (select tipopedd 
                               from tipopedd 
                              where abrev = 'HFC_SIAC_DEC_ADICIONAL'),null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 1, 'NUMERO CUOTAS - HFC/SIAC DECO ADICIONAL', 'NUM_CUOTAS', (select tipopedd 
                               from tipopedd 
                              where abrev = 'HFC_SIAC_DEC_ADICIONAL'),null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('41,53', null, 'MONTO OCC - HFC/SIAC DECO ADICIONAL', 'MONT_OCC', (select tipopedd 
                               from tipopedd 
                              where abrev = 'HFC_SIAC_DEC_ADICIONAL'),null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 689, 'TIPO TRABAJO DECO ADICIONAL', 'TIPTRA', (select tipopedd 
                               from tipopedd 
                              where abrev = 'HFC_SIAC_DEC_ADICIONAL'),null);



/*Se crea un valor en la tabla constante*/

insert into constante (CONSTANTE, DESCRIPCION, TIPO, CODUSU, FECUSU, VALOR, OBS)
values ('REMARK_OCC', 'REMARK - HFC/SIAC DECO ADICIONAL', 'C', USER, SYSDATE, 'Instalación - Inst. Deco Adicional Post Instalación', null);

COMMIT;
/