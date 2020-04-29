create table operacion.franja_horaria
(
  idfranja     NUMBER,
  codigo       VARCHAR2(10),
  descripcion  VARCHAR2(30),
  franja       VARCHAR2(20),
  franja_ini   VARCHAR2(5),
  ind_merid_fi VARCHAR2(3),
  franja_fin   VARCHAR2(5),
  ind_merid_ff VARCHAR2(3),
  flg_ap_ctr   NUMBER(1)
)
TABLESPACE OPERACION_DAT;

