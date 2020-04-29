create table OPERACION.SGAT_COMPAR_SOT_ACT_NOACT
(
  idtrx            NUMBER not null,
  codsolot_noact   NUMBER,
  qty              NUMBER,
  tipsrv           VARCHAR2(35),
  tip_eq           VARCHAR2(35),
  flg_status       VARCHAR2(1),
  codsolot_act_ref NUMBER,
  flg_activo       VARCHAR2(1)
)
tablespace OPERACION_DAT
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

create table OPERACION.SGAT_IMPORTACION_MASIVA_CAB
(
  impcn_idcab          NUMBER(19),
  impcv_root_file_name VARCHAR2(100),
  impcv_tabla          VARCHAR2(40),
  impcv_observacion    VARCHAR2(200),
  impcv_estado         NUMBER(1) default 1,
  impcv_usercreation   VARCHAR2(40) default user,
  impcd_fechacreate    DATE default sysdate,
  impcv_usermodify     VARCHAR2(40),
  impcd_fechamodify    DATE,
  CONSTRAINT idcab_pk PRIMARY KEY(impcn_idcab)
);

create table OPERACION.SGAT_IMPORTACION_MASIVA_DET
(
  impdn_idimport     NUMBER(19),
  impcn_idcab        NUMBER(19),
  impdv_idplano      VARCHAR2(20),
  impdv_codubi       VARCHAR2(10),
  impdv_codzona      VARCHAR2(10),
  impdn_flg_adc      NUMBER(1) default 0,
  impdv_descripcion  VARCHAR2(100),
  impdv_estado       VARCHAR2(1) default '1',
  impdv_servicio     VARCHAR2(5),
  impdv_usercreation VARCHAR2(40) default user,
  impdd_fechacreate  DATE default sysdate,
  impdv_usermodify   VARCHAR2(40),
  impdd_fechamodify  DATE
);

GRANT ALL ON OPERACION.SGAT_IMPORTACION_MASIVA_CAB TO RPROD;
GRANT ALL ON OPERACION.SGAT_IMPORTACION_MASIVA_DET TO RPROD;
GRANT ALL ON OPERACION.SGAT_COMPAR_SOT_ACT_NOACT TO RPROD;
GRANT ALL ON OPERACION.SGAT_COMPAR_SOT_ACT_NOACT TO INTRAWAY;

create sequence OPERACION.SGASEQ_IMPORTMASIVACAB
minvalue 1
start with 1
increment by 1
nocache;

create sequence OPERACION.SGASEQ_IMPORTMASIVADET
minvalue 1
start with 1
increment by 1
nocache;

CREATE OR REPLACE TRIGGER operacion.sgatri_import_masiva_cab
  BEFORE INSERT ON operacion.sgat_importacion_masiva_cab
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
DECLARE
  ln_logerrn_idcab NUMBER;
BEGIN
  IF :new.impcn_idcab IS NULL THEN
    SELECT operacion.sgaseq_importmasivacab.nextval
      INTO ln_logerrn_idcab
      FROM dummy_ope;
    :new.impcn_idcab := ln_logerrn_idcab;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER operacion.sgatri_import_masiva_det
  BEFORE INSERT ON operacion.sgat_importacion_masiva_det
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
DECLARE
  ln_logerrn_iddet NUMBER;
BEGIN
  IF :new.impdn_idimport IS NULL THEN
    SELECT operacion.sgaseq_importmasivadet.nextval
      INTO ln_logerrn_iddet
      FROM dummy_ope;
    :new.impdn_idimport := ln_logerrn_iddet;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER operacion.t_sgat_compar_sot_act_noact_bi
  BEFORE INSERT ON operacion.sgat_compar_sot_act_noact
  FOR EACH ROW
DECLARE
  tmpvar NUMBER;
BEGIN
  IF :new.idtrx IS NULL THEN
    SELECT nvl(MAX(idtrx), 0) + 1
      INTO :new.idtrx
      FROM operacion.sgat_compar_sot_act_noact;
  END IF;
END;
/