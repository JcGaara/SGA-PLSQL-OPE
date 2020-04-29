/*INSSRV*/
ALTER TABLE operacion.inssrv ADD flgsolmedida NUMBER(1);
comment on column OPERACION.INSSRV.flgsolmedida
  is 'Flag que indica si el servicio es una solución a la medida.0:no 1:si';
/************* EFPTOEQU *****************/

ALTER TABLE operacion.EFPTOEQU ADD  flgsolmedida NUMBER(1);
comment on column OPERACION.EFPTOEQU.flgsolmedida
is 'Flag que indica si es una solución a la medida.0:no1:si';

ALTER TABLE operacion.EFPTOEQU ADD  codprovinstalacion VARCHAR2(30);
comment on column OPERACION.EFPTOEQU.codprovinstalacion
  is 'Codigo del proveedor de instalacion';
  
ALTER TABLE operacion.EFPTOEQU ADD  codprovmantenim VARCHAR2(30);  
comment on column OPERACION.EFPTOEQU.codprovmantenim
  is 'Codigo del proveedor de mantenimiento';
  
ALTER TABLE operacion.EFPTOEQU ADD  sla VARCHAR2(30); 
comment on column OPERACION.EFPTOEQU.sla
  is 'Codigo SLA de los rangos de tiempo registrados en la tabla tipopedd
Los códigos harán referencia a  los siguientes elementos:
-	0 - 4 hrs.
-	4 - 8 hrs.
-	8 - 24 hrs.
-	24 - 48 hrs.
-	Más de 48 hrs.';

/********* OPERACION.LICITACION   **********/
ALTER TABLE OPERACION.LICITACION ADD  adp_respo VARCHAR2(30); 
comment on column OPERACION.LICITACION.adp_respo
  is 'ADP Responsable';

ALTER TABLE OPERACION.LICITACION ADD  ampl_plazo NUMBER; 
comment on column OPERACION.LICITACION.ampl_plazo
  is 'Ampliación de Plazo';
 
ALTER TABLE OPERACION.LICITACION ADD  pend_preventa VARCHAR2(300);
comment on column OPERACION.LICITACION.pend_preventa
  is 'Pendiente Preventa/Factibilidad';

ALTER TABLE OPERACION.LICITACION ADD  pend_comercial VARCHAR2(300);
comment on column OPERACION.LICITACION.pend_comercial
  is 'Pendientes Comercial';
  
ALTER TABLE OPERACION.LICITACION ADD  pend_compras VARCHAR2(300);
comment on column OPERACION.LICITACION.pend_compras
  is 'Pendiente Compras';

ALTER TABLE OPERACION.LICITACION ADD  pend_legal VARCHAR2(300);  
comment on column OPERACION.LICITACION.pend_legal
  is 'Pendiente Legal';

ALTER TABLE OPERACION.LICITACION ADD  MONTOCONTR NUMBER(10,2);  
comment on column OPERACION.LICITACION.MONTOCONTR
  is 'Precio del contrato con el cliente';
-- A confirmar creacion de campo ADP RESPONSABLE
 /********* OPERACION.CONTRATA   **********/
ALTER TABLE OPERACION.CONTRATA ADD  flg_si_proveedor NUMBER(1);
comment on column OPERACION.CONTRATA.flg_si_proveedor
  is 'Flag que define si la contrata es de tipo proveedor 0:NO 1:SI';
  

