create table OPERACION.MIGRT_DET_TEMP_SOT
(
  datan_id              NUMBER(10) not null,
  datan_idcab           NUMBER(10),
  datan_idpaq           NUMBER(10),
  datav_paquete         VARCHAR2(4000),
  datac_tipprod         CHAR(4),
  datav_desctipprod     VARCHAR2(50),
  datan_idprod          NUMBER(10),
  datav_prod            VARCHAR2(100),
  datac_codsrv          CHAR(4),
  datav_servicio        VARCHAR2(50),
  datav_descplan        VARCHAR2(200),
  datav_tiposervicio    VARCHAR2(50),
  datan_idestserv       NUMBER(2),
  datav_descestserv     VARCHAR2(100),
  datan_idtipinss       NUMBER(2),
  datav_tipinss         VARCHAR2(100),
  datan_codinssrv       NUMBER(10),
  datan_pid             NUMBER(10),
  datan_idmarcaequipo   NUMBER(2),
  datav_marcaequipo     VARCHAR2(50),
  datac_codtipequ       CHAR(15),
  datan_tipequ          NUMBER(6),
  datav_tipo_equipo     VARCHAR2(100),
  datav_equ_tipo        VARCHAR2(30),
  datac_cod_equipo      CHAR(4),
  datav_modelo_equipo   VARCHAR2(200),
  datav_tipo            VARCHAR2(10),
  datav_numero          VARCHAR2(20),
  datan_control         NUMBER(1) default 0,
  datan_cargofijo       NUMBER(18,4),
  datan_cantidad        NUMBER(10),
  datac_publicar        CHAR(2),
  datan_bw              NUMBER(10,2),
  datan_cid             NUMBER(10),
  datac_codsucursal     CHAR(10),
  datav_descventa       VARCHAR2(100),
  datav_dirventa        VARCHAR2(480),
  datac_codubi          CHAR(10),
  datav_codpostal       VARCHAR2(30),
  datav_idplano         VARCHAR2(10),
  datav_eq_idsrv_sisact VARCHAR2(5),
  datan_monto_sisact    NUMBER(18,4),
  datan_eq_plan_sisact  NUMBER,
  datan_monto_sga       NUMBER(18,4),
  datac_eq_idsrv_sga    CHAR(4),
  datav_eq_idequ_sisact VARCHAR2(10),
  datan_migrar          NUMBER(1) default 0
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

alter table OPERACION.MIGRT_DET_TEMP_SOT
  add constraint PK_MIGRT_IDDET primary key (DATAN_ID);
