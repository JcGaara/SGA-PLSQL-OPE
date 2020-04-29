insert into OPERACION.constante(constante,descripcion,tipo,valor)
values('KEY_IW','Llave IW','C','6B65797367612D32303038');
insert into OPERACION.constante(constante,descripcion,tipo,valor)
values('IDEMPRESACRM','ID Empresa IW','C','121');
insert into OPERACION.constante(constante,descripcion,tipo,valor)
values('TARGET_URL_IW','Target URL de IW','C','http://172.19.74.68:8909/CargaEquiposWS/ebsCargaEquiposSB11');
insert into OPERACION.constante(constante,descripcion,tipo,valor)
values('ACTION_URL_IW','Target URL de IW','C','http://claro.com.pe/eai/ebs/ws/operaciones/cargaequipos/types');
COMMIT;
/
CREATE OR REPLACE TYPE OPERACION.REPORTOBJOUTPUT AS OBJECT --Servicio Cliente
( idempresa VARCHAR2(200),
  idclientecrm  VARCHAR2(200),
  tipocliente VARCHAR2(200),
  nombre VARCHAR2(400) );
/ 
CREATE OR REPLACE TYPE OPERACION.DOCSISREPORT AS OBJECT  --MTA
( idservicio VARCHAR2(200),
  idproducto VARCHAR2(200),
  hub VARCHAR2(200),
  nodo VARCHAR2(200),
  macaddress VARCHAR2(200),
  servicepackage VARCHAR2(200),
  activationcode VARCHAR2(200),
  ispMODEM VARCHAR2(200),
  ispCPE VARCHAR2(200),
  serialnumer VARCHAR2(200) );
/ 
CREATE OR REPLACE TYPE OPERACION.PACKETCABLEREPORT AS OBJECT --MTA
( idServicio VARCHAR2(200),
  idProducto VARCHAR2(200),
  idServicioPadre VARCHAR2(200),
  idProductoPadre VARCHAR2(200),
  Macaddress VARCHAR2(200),
  ispMTA VARCHAR2(200),
  activationcode VARCHAR2(200) ,
  mtaModel VARCHAR2(200)  );
/
    
CREATE OR REPLACE TYPE OPERACION.DAC AS OBJECT --Deco
(  idservicio VARCHAR2(200),
  idproducto VARCHAR2(200),
  serialnumer VARCHAR2(200) ,
  UnitAdrress VARCHAR2(200) ,
  ConvertType VARCHAR2(200) ,
  Controller VARCHAR2(200) ,
  activationcode VARCHAR2(200)  );
/ 
CREATE OR REPLACE TYPE OPERACION.ARR_REPORTOBJOUTPUT AS VARRAY(100) OF OPERACION.REPORTOBJOUTPUT;
/ 
CREATE OR REPLACE TYPE OPERACION.ARR_DOCSISREPORT AS VARRAY(100) OF OPERACION.DOCSISREPORT;
/ 
CREATE OR REPLACE TYPE OPERACION.ARR_PACKETCABLEREPORT AS VARRAY(100) OF OPERACION.PACKETCABLEREPORT;
/ 
CREATE OR REPLACE TYPE OPERACION.ARR_DAC AS VARRAY(100) OF OPERACION.DAC;
/ 