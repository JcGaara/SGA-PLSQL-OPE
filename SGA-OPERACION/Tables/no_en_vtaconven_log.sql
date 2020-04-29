-- Create table

CREATE TABLE "SALES"."NO_EN_VTACONVEN_LOG" 
   (  "SECUENCIA" NUMBER(10,0) NOT NULL ENABLE,
"NUMSLC" CHAR(10) NOT NULL ENABLE, 
  PERIODO   CHAR(6),
  "DET_ERROR" VARCHAR2(2800), 
  "FECUSU" DATE DEFAULT sysdate, 
  "CODUSU" VARCHAR2(30) DEFAULT user );

 
 ALTER TABLE "SALES"."NO_EN_VTACONVEN_LOG" ADD CONSTRAINT "PK_NO_VTACONVEN_LOG" PRIMARY KEY ("SECUENCIA");

-- Add comments to the table  

  COMMENT ON COLUMN "SALES"."NO_EN_VTACONVEN_LOG"."SECUENCIA" IS 'Secuencia';

   COMMENT ON COLUMN "SALES"."NO_EN_VTACONVEN_LOG"."NUMSLC" IS 'Numero del Proyecto';
   
 
 
   COMMENT ON COLUMN "SALES"."NO_EN_VTACONVEN_LOG"."DET_ERROR" IS 'Descripción del Error';   
  
   COMMENT ON COLUMN "SALES"."NO_EN_VTACONVEN_LOG"."FECUSU" IS 'Fecha de modificación';
 
   COMMENT ON COLUMN "SALES"."NO_EN_VTACONVEN_LOG"."CODUSU" IS 'Usuario de Modificación';
 
   COMMENT ON TABLE "SALES"."NO_EN_VTACONVEN_LOG"  IS 'Log de Errores cuando no se Genera el Consolidado de Ventas';


-- Create index 

create index SALES.ID_NUMSLC on SALES.NO_EN_VTACONVEN_LOG (NUMSLC)
  tablespace SALES_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );





