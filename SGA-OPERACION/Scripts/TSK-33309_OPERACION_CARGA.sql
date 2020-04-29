insert into operacion.AREAOPE
(AREA,DESCRIPCION,FLGDERPRV,ESTADO,CODUSU,FECUSU,FLGCC,CONTRATA)
values(350,'SOPORTE A LA ACTIVACION',0,1,'EASTULLE',SYSDATE,0,0);

INSERT INTO OPERACION.CONSTANTE (CONSTANTE,DESCRIPCION,TIPO,CODUSU,FECUSU,VALOR,OBS)
VALUES ('ESTPROCDEMO','Estado procesado del proyecto demo','C','EASTULLE',sysdate,'1','Estado procesado del proyecto demo');
INSERT INTO OPERACION.CONSTANTE (CONSTANTE,DESCRIPCION,TIPO,CODUSU,FECUSU,VALOR,OBS)
VALUES ('ESTNOPRODEMO','Estado pendiente de procesado','C','EASTULLE',sysdate,'0','Estado pendiente de procesado');
INSERT INTO OPERACION.CONSTANTE (CONSTANTE,DESCRIPCION,TIPO,CODUSU,FECUSU,VALOR,OBS)
VALUES ('TIPTRA','Tipo de trabajo','N','EASTULLE',sysdate,'444','Tipo de trabajo');

insert into operacion.opet_servxtrabajo 
(STRAC_TIPSRV,STRAN_TIPTRABAJO,STRAN_ESTSOL,STRAN_GRADO,STRAN_CODMOTOT,STRAN_AREA,STRAN_ESTADO,STRAV_USUREG,STRAD_FECREG) 
values ('0061',441,11,1,15,350,1,'EASTULLE',SYSDATE);
insert into operacion.opet_servxtrabajo 
(STRAC_TIPSRV,STRAN_TIPTRABAJO,STRAN_ESTSOL,STRAN_GRADO,STRAN_CODMOTOT,STRAN_AREA,STRAN_ESTADO,STRAV_USUREG,STRAD_FECREG)  
values ('0082',3,11,1,15,350,1,'EASTULLE',SYSDATE);
insert into operacion.opet_servxtrabajo 
(STRAC_TIPSRV,STRAN_TIPTRABAJO,STRAN_ESTSOL,STRAN_GRADO,STRAN_CODMOTOT,STRAN_AREA,STRAN_ESTADO,STRAV_USUREG,STRAD_FECREG)  
values ('0077',609,11,1,15,350,1,'EASTULLE',SYSDATE);
insert into operacion.opet_servxtrabajo 
(STRAC_TIPSRV,STRAN_TIPTRABAJO,STRAN_ESTSOL,STRAN_GRADO,STRAN_CODMOTOT,STRAN_AREA,STRAN_ESTADO,STRAV_USUREG,STRAD_FECREG)  
values ('0073',441,11,1,15,350,1,'EASTULLE',SYSDATE);
insert into operacion.opet_servxtrabajo 
(STRAC_TIPSRV,STRAN_TIPTRABAJO,STRAN_ESTSOL,STRAN_GRADO,STRAN_CODMOTOT,STRAN_AREA,STRAN_ESTADO,STRAV_USUREG,STRAD_FECREG)  
values ('0058',3,11,1,15,350,1,'EASTULLE',SYSDATE);
insert into operacion.opet_servxtrabajo 
(STRAC_TIPSRV,STRAN_TIPTRABAJO,STRAN_ESTSOL,STRAN_GRADO,STRAN_CODMOTOT,STRAN_AREA,STRAN_ESTADO,STRAV_USUREG,STRAD_FECREG)  
values ('0006',3,11,1,15,350,1,'EASTULLE',SYSDATE);
insert into operacion.opet_servxtrabajo 
(STRAC_TIPSRV,STRAN_TIPTRABAJO,STRAN_ESTSOL,STRAN_GRADO,STRAN_CODMOTOT,STRAN_AREA,STRAN_ESTADO,STRAV_USUREG,STRAD_FECREG)  
values ('0005',3,11,1,15,350,1,'EASTULLE',SYSDATE);
insert into operacion.opet_servxtrabajo 
(STRAC_TIPSRV,STRAN_TIPTRABAJO,STRAN_ESTSOL,STRAN_GRADO,STRAN_CODMOTOT,STRAN_AREA,STRAN_ESTADO,STRAV_USUREG,STRAD_FECREG)  
values ('0014',3,11,1,15,350,1,'EASTULLE',SYSDATE);
insert into operacion.opet_servxtrabajo 
(STRAC_TIPSRV,STRAN_TIPTRABAJO,STRAN_ESTSOL,STRAN_GRADO,STRAN_CODMOTOT,STRAN_AREA,STRAN_ESTADO,STRAV_USUREG,STRAD_FECREG)  
values ('0036',3,11,1,15,350,1,'EASTULLE',SYSDATE);
insert into operacion.opet_servxtrabajo 
(STRAC_TIPSRV,STRAN_TIPTRABAJO,STRAN_ESTSOL,STRAN_GRADO,STRAN_CODMOTOT,STRAN_AREA,STRAN_ESTADO,STRAV_USUREG,STRAD_FECREG)  
values ('0052',3,11,1,15,350,1,'EASTULLE',SYSDATE);
insert into operacion.opet_servxtrabajo 
(STRAC_TIPSRV,STRAN_TIPTRABAJO,STRAN_ESTSOL,STRAN_GRADO,STRAN_CODMOTOT,STRAN_AREA,STRAN_ESTADO,STRAV_USUREG,STRAD_FECREG)  
values ('0053',3,11,1,15,350,1,'EASTULLE',SYSDATE);
insert into operacion.opet_servxtrabajo 
(STRAC_TIPSRV,STRAN_TIPTRABAJO,STRAN_ESTSOL,STRAN_GRADO,STRAN_CODMOTOT,STRAN_AREA,STRAN_ESTADO,STRAV_USUREG,STRAD_FECREG)  
values ('0055',3,11,1,15,350,1,'EASTULLE',SYSDATE);



COMMIT;