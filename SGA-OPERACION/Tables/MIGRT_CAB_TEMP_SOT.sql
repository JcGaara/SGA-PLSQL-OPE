create table OPERACION.MIGRT_CAB_TEMP_SOT
(  datan_id              NUMBER(10) not null,
  datac_tipo_persona    CHAR(1),
  datac_codcli          CHAR(8),
  datav_nomabr          VARCHAR2(200),
  datav_nomcli          VARCHAR2(200),
  datav_apepat          VARCHAR2(50),
  datav_apemat          VARCHAR2(50),
  datac_tipdoc          CHAR(3),
  datav_descdoc         VARCHAR2(10),
  datav_numdoc          VARCHAR2(15),
  datad_fecnac          DATE,
  datad_fechaini        DATE,
  datad_fechafin        DATE,
  datav_emailprinc      VARCHAR2(200),
  datav_email1          VARCHAR2(200),
  datav_email2          VARCHAR2(200),
  datac_tipsrv          CHAR(4),
  datav_desctipsrv      VARCHAR2(50),
  datan_codcamp         NUMBER(6),
  datav_descamp         VARCHAR2(200),
  datan_codplazo        NUMBER(4),
  datav_descplazo       VARCHAR2(80),
  datan_idsolucion      NUMBER(10),
  datav_solucion        VARCHAR2(100),
  datac_idproyecto      CHAR(10),
  datav_play            VARCHAR2(10),
  datac_codubi          CHAR(10),
  datac_codsucursal     CHAR(10),
  datav_direccion       VARCHAR2(480),
  datac_cod_ev          CHAR(8),
  datac_idtipdoc_ev     CHAR(3),
  datav_tipdoc_ev       VARCHAR2(10),
  datav_numdoc_ev       VARCHAR2(15),
  datav_nom_ev          VARCHAR2(60),
  datac_idtipven        CHAR(2),
  datav_tipven          VARCHAR2(50),
  datav_idcont          VARCHAR2(15),
  datan_nrocart         NUMBER(15),
  datac_codope          CHAR(2),
  datav_operador        VARCHAR2(30),
  datan_presus          NUMBER(1) default 0,
  datan_publi           NUMBER(1) default 0,
  datan_idtipenvio      NUMBER,
  datav_tipenvio        VARCHAR2(100),
  datav_corelec         VARCHAR2(100),
  datav_iddep_dircli    VARCHAR2(3),
  datac_idprov_dircli   CHAR(3),
  datac_iddist_dircli   CHAR(3),
  datav_depa_dircli     VARCHAR2(40),
  datav_prov_dircli     VARCHAR2(40),
  datav_dist_dircli     VARCHAR2(40),
  datav_dircli          VARCHAR2(480),
  datac_codubidir       CHAR(10),
  datac_ubigeodir       CHAR(6),
  datac_idtipoviadir    CHAR(2),
  datav_tipoviadir      VARCHAR2(30),
  datav_nomviadir       VARCHAR2(60),
  datav_numviadir       VARCHAR2(50),
  datan_idtipodomidir   NUMBER(2),
  datav_tipodomidir     VARCHAR2(50),
  datav_nomurbdir       VARCHAR2(50),
  datan_idzonadir       NUMBER(3),
  datav_zonadir         VARCHAR2(50),
  datav_referenciadir   VARCHAR2(340),
  datav_telf1dir        VARCHAR2(50),
  datav_telf2dir        VARCHAR2(50),
  datav_codposdir       VARCHAR2(20),
  datav_manzanadir      VARCHAR2(5),
  datav_lotedir         VARCHAR2(5),
  datav_sectordir       VARCHAR2(5),
  datan_codedifdir      NUMBER(8),
  datav_edificdir       VARCHAR2(50),
  datan_pisodir         NUMBER,
  datav_interiordir     VARCHAR2(60),
  datav_num_interiordir VARCHAR2(15),
  datav_idplanodir      VARCHAR2(10),
  datav_planodir        VARCHAR2(100),
  datav_iddepi          VARCHAR2(3),
  datac_idprovi         CHAR(3),
  datac_iddisti         CHAR(3),
  datav_departamentoi   VARCHAR2(40),
  datav_provinciai      VARCHAR2(40),
  datav_distritoi       VARCHAR2(40),
  datav_dirsuci         VARCHAR2(1000),
  datav_nomsuci         VARCHAR2(100),
  datac_ubisuci         CHAR(10),
  datac_ubigeoi         CHAR(6),
  datac_idtipoviai      CHAR(2),
  datav_tipoviai        VARCHAR2(30),
  datav_nomviai         VARCHAR2(60),
  datav_numviai         VARCHAR2(50),
  datan_idtipodomii     NUMBER(2),
  datav_tipodomii       VARCHAR2(50),
  datan_idtipurbi       NUMBER(4),
  datav_nomurbi         VARCHAR2(50),
  datan_idzonai         NUMBER(3),
  datav_zonai           VARCHAR2(50),
  datav_referenciai     VARCHAR2(340),
  datav_telf1i          VARCHAR2(50),
  datav_telf2i          VARCHAR2(50),
  datav_codposi         VARCHAR2(20),
  datav_manzanai        VARCHAR2(5),
  datav_lotei           VARCHAR2(5),
  datav_sectori         VARCHAR2(5),
  datan_codedifi        NUMBER(8),
  datav_edificioi       VARCHAR2(50),
  datan_pisoi           NUMBER(3),
  datav_interiori       VARCHAR2(60),
  datav_num_interiori   VARCHAR2(15),
  datav_idplanoi        VARCHAR2(10),
  datav_planoi          VARCHAR2(100),
  datav_iddepf          VARCHAR2(3),
  datac_idprovf         CHAR(3),
  datac_iddistf         CHAR(3),
  datav_departamentof   VARCHAR2(40),
  datav_provinciaf      VARCHAR2(40),
  datav_distritof       VARCHAR2(40),
  datav_dirsucf         VARCHAR2(1000),
  datav_nomsucf         VARCHAR2(100),
  datac_ubisucf         CHAR(10),
  datac_ubigeof         CHAR(6),
  datac_idtipoviaf      CHAR(2),
  datav_tipoviaf        VARCHAR2(30),
  datav_nomviaf         VARCHAR2(60),
  datav_numviaf         VARCHAR2(50),
  datan_idtipodomif     NUMBER(2),
  datav_tipodomif       VARCHAR2(50),
  datan_idtipurbf       NUMBER(4),
  datav_nomurbf         VARCHAR2(50),
  datan_idzonaf         NUMBER(3),
  datav_zonaf           VARCHAR2(50),
  datav_referenciaf     VARCHAR2(340),
  datav_telf1f          VARCHAR2(50),
  datav_telf2f          VARCHAR2(50),
  datav_codposf         VARCHAR2(20),
  datav_manzanaf        VARCHAR2(5),
  datav_lotef           VARCHAR2(5),
  datav_sectorf         VARCHAR2(5),
  datan_codediff        NUMBER(8),
  datav_edificiof       VARCHAR2(50),
  datan_pisof           NUMBER(3),
  datav_interiorf       VARCHAR2(60),
  datav_num_interiorf   VARCHAR2(15),
  datav_idplanof        VARCHAR2(10),
  datav_planof          VARCHAR2(100),
  datan_solotactv       NUMBER(8),
  datai_tipoagenda      INTEGER,
  datad_fecproc         DATE,
  datai_procesado       INTEGER default 0,
  datan_codsotbajaadm   NUMBER(8),
  datan_estsotbaja      NUMBER(2),
  datan_codsolot        NUMBER(8),
  datan_estsotalta      NUMBER(2),
  datan_cod_id          NUMBER,
  datan_customer_id     NUMBER,
  datan_numsec          NUMBER(20),
  datac_estsec          CHAR(2),
  datai_procsisact      INTEGER default 0,
  datad_fecprocsisact   DATE,
  datai_procagensga     INTEGER default 0,
  datad_fecprocagensga  DATE,
  datai_prociw          INTEGER default 0,
  datad_fecprociw       DATE,
  datan_idciclo         NUMBER(5),
  datav_desciclo        VARCHAR2(100),
  datai_tope            INTEGER default 0
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

alter table OPERACION.MIGRT_CAB_TEMP_SOT
  add constraint PK_MIGRT_IDCAB primary key (DATAN_ID)
  using index 
  tablespace OPERACION_DAT
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
