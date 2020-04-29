
---------------------------------------------------------------------------------
--anhos_tabla
---------------------------------------------------------------------------------
     INSERT INTO tipopedd
     (tipopedd, descripcion, abrev )
     VALUES
     ((SELECT MAX(tipopedd)+1 FROM tipopedd)  , 'dth parametros', 'anhos_tabla' );
   
   
   
INSERT INTO opedd VALUES
( (SELECT MAX (idopedd)+1 FROM opedd) ,    '2030'   , null     , '8'    , 100       , (SELECT d.tipopedd from tipopedd d WHERE d.descripcion='dth parametros') ,null );
INSERT INTO opedd VALUES
( (SELECT MAX (idopedd)+1 FROM opedd) ,    '2020'   ,  null    , '6'    , 011        , (SELECT d.tipopedd from tipopedd d WHERE d.descripcion='dth parametros') ,null  );
INSERT INTO opedd VALUES
( (SELECT MAX (idopedd)+1 FROM opedd) ,    '2010'      ,  null    , '4'         , 010     , (SELECT d.tipopedd from tipopedd d WHERE d.descripcion='dth parametros') , null );
INSERT INTO opedd VALUES
( (SELECT MAX (idopedd)+1 FROM opedd) ,    '2000'       ,  null    , '2'        , 001     , (SELECT d.tipopedd from tipopedd d WHERE d.descripcion='dth parametros') ,  null);
INSERT INTO opedd VALUES
( (SELECT MAX (idopedd)+1 FROM opedd) ,    '1990'      , null     , '0'         , 000     , (SELECT d.tipopedd from tipopedd d WHERE d.descripcion='dth parametros') ,  null);
INSERT INTO opedd VALUES
( (SELECT MAX (idopedd)+1 FROM opedd) ,    '2060'       , null     ,  'e'        , 111     , (SELECT d.tipopedd from tipopedd d WHERE d.descripcion='dth parametros') , null);
INSERT INTO opedd VALUES
( (SELECT MAX (idopedd)+1 FROM opedd) ,    '2050'       , null     , 'c'         , 110     , (SELECT d.tipopedd from tipopedd d WHERE d.descripcion='dth parametros') ,  null);
INSERT INTO opedd VALUES
( (SELECT MAX (idopedd)+1 FROM opedd) ,    '2040'       ,  null    , 'a'         , 101     , (SELECT d.tipopedd from tipopedd d WHERE d.descripcion='dth parametros') ,null);

--------------------------------------
--conexiones
--------------------------------------

     INSERT INTO tipopedd
     (tipopedd, descripcion, abrev )
     VALUES
     (  (SELECT MAX(tipopedd)+1 FROM tipopedd)   , 'conexiones', 'conexiones' );


INSERT INTO opedd VALUES
( (SELECT MAX (idopedd)+1 FROM opedd) ,    'RUTA_ENVIO'   , null     , '/home/oracle/Cancerbero/Req'    ,  null    ,  (SELECT d.tipopedd from tipopedd d WHERE d.descripcion='conexiones')       ,  null);
INSERT INTO opedd VALUES
( (SELECT MAX (idopedd)+1 FROM opedd) ,    'RUTA_LOCAL'   ,   null   ,  'REQENVIO'                      ,   null   ,  (SELECT d.tipopedd from tipopedd d WHERE d.descripcion='conexiones')      ,  null );
INSERT INTO opedd VALUES
( (SELECT MAX (idopedd)+1 FROM opedd) ,    'PASWORD'      ,  null    ,  'oracle'                        ,   null   ,   (SELECT d.tipopedd from tipopedd d WHERE d.descripcion='conexiones')     ,   null );
INSERT INTO opedd VALUES
( (SELECT MAX (idopedd)+1 FROM opedd) ,    'USUARIO'      ,   null   ,  'oracle'                        ,   null   ,   (SELECT d.tipopedd from tipopedd d WHERE d.descripcion='conexiones')      , null );
INSERT INTO opedd VALUES
( (SELECT MAX (idopedd)+1 FROM opedd) ,    'PUERTO'       ,  null    , '21'                              ,  null    ,  (SELECT d.tipopedd from tipopedd d WHERE d.descripcion='conexiones')      , null );
INSERT INTO opedd VALUES
(  (SELECT MAX (idopedd)+1 FROM opedd),    'HOST'         ,  null    ,  '172.19.74.105'                   ,  null    ,    (SELECT d.tipopedd from tipopedd d WHERE d.descripcion='conexiones')    ,  null  );
INSERT INTO opedd VALUES
( (SELECT MAX (idopedd)+1 FROM opedd) ,    'DIRECTORIO_LOCAL' , null,  '/home/oracle/envio'              ,  null    ,  (SELECT d.tipopedd from tipopedd d WHERE d.descripcion='conexiones')      ,  null  );
INSERT INTO opedd VALUES
( (SELECT MAX (idopedd)+1 FROM opedd) ,    'RUTA_ERROR'      , null    ,'/home/oracle/Cancerbero/Error'    ,  null    , (SELECT d.tipopedd from tipopedd d WHERE d.descripcion='conexiones')        , null );
INSERT INTO opedd VALUES
( (SELECT MAX (idopedd)+1 FROM opedd) ,    'RUTA_OK'      ,  null      ,'/home/oracle/Cancerbero/Ok'          ,  null    ,  (SELECT d.tipopedd from tipopedd d WHERE d.descripcion='conexiones')       , null );



---------------------------------------------
--maximos envios
----------------------------------------

     INSERT INTO tipopedd
     (tipopedd, descripcion, abrev )
     VALUES
     ( (SELECT MAX(tipopedd)+1 FROM tipopedd)    , 'maximos envios', 'envio_dth_parametros' );
     
   
   INSERT INTO opedd VALUES
    ( (SELECT MAX (idopedd)+1 FROM opedd) ,    'MAXIMO_ENVIOS'   ,   5   ,  null      ,  null    ,  (SELECT d.tipopedd from tipopedd d WHERE d.descripcion='maximos envios')      , null);

----------------------------------------
--OPERACION.TIP_MENSAJE
----------------------------------------
 INSERT INTO OPERACION.TIP_MENSAJE VALUES
    ( 1 , 'Mensaje único inmediato'  ,sysdate , user ,'MUIN' );
 INSERT INTO OPERACION.TIP_MENSAJE VALUES
    ( 2 , 'Mensaje único con fecha y hora especificada'  ,sysdate , user ,'MUFYH' );
 INSERT INTO OPERACION.TIP_MENSAJE VALUES
    ( 3 , 'Mensaje repetitivo inmediato'  ,sysdate , user ,'MREIN' );
 INSERT INTO OPERACION.TIP_MENSAJE VALUES
    ( 4 , 'Mensaje repetitivo con fecha y hora especificada'  ,sysdate , user ,'MRFYH' );
 INSERT INTO OPERACION.TIP_MENSAJE VALUES
    ( 5 , 'Mensaje de correo'  ,sysdate , user ,'MCORR' );

COMMIT;


----------------------------------------
--CREACION DE TYPES
----------------------------------------

CREATE OR REPLACE TYPE OPERACION.cliente_dth AS OBJECT
  (
     CODCLI CHAR(8),
     NOMCLI      VARCHAR2(200),
     DIRCLI      VARCHAR2(480),
     DISTRITO    VARCHAR2(100)
  );
/

CREATE OR REPLACE TYPE OPERACION.cliente_dth_tbl AS TABLE OF cliente_dth;
/

CREATE OR REPLACE TYPE OPERACION.tarjeta_cliente_dth AS OBJECT
 (
    NRO_TARJETA VARCHAR2(30)
 );
/

CREATE OR REPLACE TYPE OPERACION.tarjeta_cliente_dth_tbl AS TABLE OF tarjeta_cliente_dth;
/

CREATE OR REPLACE TYPE OPERACION.ty_envdth AS OBJECT
  ( id_archivo         number,
    tipmensaje         number,
    Tipo_de_mensaje    varchar2(50) ,
    cod_msgdth         number,
    descripcion        varchar(4000),
    mensaje            varchar2(60),
    fecha_de_creacion  date ,
    fecha_envio        date,
    Num_de_Tarjetas    number,
    Estado             varchar2(60), 
    flg                number(1));
/
   
CREATE OR REPLACE TYPE OPERACION.ty_ienvdth_tbl AS TABLE OF ty_envdth;
/






