alter table OPERACION.RECONEXION_APC add customer_id number;
alter table OPERACION.SOLOTPTOEQU add semana_liq varchar2(40);
alter table OPERACION.SOLOTPTOEQU add cant_despacho number(10,2);
alter table OPERACION.SOLOTPTOEQU add saldo_despacho number(10,2);
alter table OPERACION.SOLOTPTOEQU add doc_sap_despacho varchar2(40);
alter table OPERACION.SOLOTPTOEQU add fecha_despacho date;
alter table OPERACION.SECUENCIA_ESTADOS_AGENDA add estsol number;
alter table OPERACION.CONTRATA add tipo_contrata number default 4;
alter table OPERACION.SOLOT add revisado NUMBER(2)  null;


comment on column OPERACION.RECONEXION_APC.customer_id  is 'Customer_ID';
comment on column OPERACION.SOLOTPTOEQU.semana_liq   is 'Semana liquidacion';
comment on column OPERACION.SOLOTPTOEQU.cant_despacho   is 'Cantidad de despacho';
comment on column OPERACION.SOLOTPTOEQU.saldo_despacho  is 'Saldo del despacho';
comment on column OPERACION.SOLOTPTOEQU.doc_sap_despacho  is 'Documento sap de despacho';
comment on column OPERACION.SOLOTPTOEQU.fecha_despacho  is 'Fecha que se realizo el despacho';
comment on column OPERACION.SECUENCIA_ESTADOS_AGENDA.estsol  is 'Estado de SOT';
comment on column OPERACION.CONTRATA.tipo_contrata  is '1: Tipo A 2: Tipo B 3:Premium 4:Otros';
comment on column OPERACION.SOLOT.revisado  is '0 No revisado, 1 revisado';
