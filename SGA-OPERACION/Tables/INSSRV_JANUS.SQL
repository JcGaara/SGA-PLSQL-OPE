CREATE TABLE "OPERACION"."INSSRV_JANUS" 
   (	"CODINSSRV" NUMBER(10,0) NOT NULL ENABLE, 
	"NUMERO" VARCHAR2(20 BYTE), 
	"NUMSLC_ORI" CHAR(10 BYTE)
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "OPERACION_DAT" ;
 
