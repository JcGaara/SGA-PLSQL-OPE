-- Create table
create table OPERACION.WORK_SKILL_ADC
(
  id_work_skill  NUMBER(10) not null,
  cod_work_skill VARCHAR2(10),
  descripcion    VARCHAR2(100),
  estado         NUMBER(1) default 0,
  ipcre          VARCHAR2(20),
  ipmod          VARCHAR2(20),
  fecre          DATE default sysdate,
  fecmod         DATE,
  usucre         VARCHAR2(30) default user,
  usumod         VARCHAR2(30)
)
tablespace OPERACION_DAT;

-- Add comments to the columns 
COMMENT ON COLUMN OPERACION.WORK_SKILL_ADC.id_work_skill   IS 'codigo secuencial';
COMMENT ON COLUMN OPERACION.WORK_SKILL_ADC.cod_work_skill  IS 'codigo del wprk skill';
COMMENT ON COLUMN OPERACION.WORK_SKILL_ADC.descripcion  IS 'nombrel del tipo de orden';
COMMENT ON COLUMN OPERACION.WORK_SKILL_ADC.estado  IS 'acitvo = 1 , inactivo = 0';
COMMENT ON COLUMN OPERACION.WORK_SKILL_ADC.ipcre  IS 'ip de la pc que creo el tipo de orden';
COMMENT ON COLUMN OPERACION.WORK_SKILL_ADC.ipmod  IS 'ip de la pc que modifico el tipo de orden';
COMMENT ON COLUMN OPERACION.WORK_SKILL_ADC.fecre  IS 'fecha de la pc que creo el tipo de orden';
COMMENT ON COLUMN OPERACION.WORK_SKILL_ADC.fecmod  IS 'fecha de la pc que modifico el tipo de orden';
COMMENT ON COLUMN OPERACION.WORK_SKILL_ADC.usucre  IS 'usuario de la pc que creo el tipo de orden';
COMMENT ON COLUMN OPERACION.WORK_SKILL_ADC.usumod  IS 'usuario de la pc que modifico el tipo de orden';
