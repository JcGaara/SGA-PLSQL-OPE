-- Create table
create table operacion.dth_preasociacion_tmp
(
  codsolot NUMBER(8) not null,
  tipequ   NUMBER(6) not null,
  numserie VARCHAR2(2000),
  mac      VARCHAR2(30),
  iddet    NUMBER(10),
  grupo    NUMBER,
  idagenda NUMBER(8)
)
TABLESPACE OPERACION_DAT;

-- Add comments to the columns 
COMMENT ON COLUMN OPERACION.DTH_PREASOCIACION_TMP.codsolot IS 'Codigo de la solicitud de orden de trabajo';
COMMENT ON COLUMN OPERACION.DTH_PREASOCIACION_TMP.tipequ   IS 'Codigo del tipo de equipo';
COMMENT ON COLUMN OPERACION.DTH_PREASOCIACION_TMP.numserie IS 'Numero de serie';
COMMENT ON COLUMN OPERACION.DTH_PREASOCIACION_TMP.mac      IS 'Numero de mac';
