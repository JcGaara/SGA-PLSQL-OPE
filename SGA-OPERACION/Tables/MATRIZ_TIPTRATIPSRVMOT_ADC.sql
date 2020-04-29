create table OPERACION.MATRIZ_TIPTRATIPSRVMOT_ADC
(
  id_matriz  NUMBER(10) not null,
  id_motivo  NUMBER(5) not null,
  gen_ot_aut CHAR(1) default 'A',
  estado     NUMBER(1) default 0,
  ipcre      VARCHAR2(20),
  ipmod      VARCHAR2(20),
  fecre      DATE default sysdate,
  fecmod     DATE,
  usucre     VARCHAR2(30) default user,
  usumod     VARCHAR2(30)
)
tablespace OPERACION_DAT;

-- Add comments to the table 
comment on column OPERACION.MATRIZ_TIPTRATIPSRVMOT_ADC.id_matriz
  is 'Codigo de Matriz';
comment on column OPERACION.MATRIZ_TIPTRATIPSRVMOT_ADC.id_motivo
  is 'Codigo de motivo';
comment on column OPERACION.MATRIZ_TIPTRATIPSRVMOT_ADC.gen_ot_aut
  is 'Indicador de generacion de Orden Automatico';
comment on column OPERACION.MATRIZ_TIPTRATIPSRVMOT_ADC.estado
  is 'Activo 1 : Si , 0 : No';
comment on column OPERACION.MATRIZ_TIPTRATIPSRVMOT_ADC.ipcre
  is 'IP creacion';
comment on column OPERACION.MATRIZ_TIPTRATIPSRVMOT_ADC.ipmod
  is 'IP modificacion';
comment on column OPERACION.MATRIZ_TIPTRATIPSRVMOT_ADC.fecre
  is 'fecha de creacion';
comment on column OPERACION.MATRIZ_TIPTRATIPSRVMOT_ADC.fecmod
  is 'fecha de modificacion';
comment on column OPERACION.MATRIZ_TIPTRATIPSRVMOT_ADC.usucre
  is 'usuario creacion';
comment on column OPERACION.MATRIZ_TIPTRATIPSRVMOT_ADC.usumod
  is 'usuario modificacion';