CREATE TABLE operacion.sgat_df_expresion_logica (
    exlon_idexplog     NUMBER NOT NULL,
    exlov_simbolo      VARCHAR2(10),
    exlov_abrev        VARCHAR2(40) NOT NULL,
    exlov_descripcion  VARCHAR2(300) NOT NULL,
    exlon_estado       NUMBER DEFAULT 1 NOT NULL,
    exloc_valscript    CLOB,
    exlod_fecreg       DATE DEFAULT sysdate,
    exlov_usureg       VARCHAR2(50) DEFAULT user,
    exlov_pcreg        VARCHAR2(50) DEFAULT sys_context('USERENV', 'TERMINAL'),
    exlov_ipreg        VARCHAR2(20) DEFAULT sys_context('USERENV', 'IP_ADDRESS'),
    exlod_fecmod       DATE,
    exlov_usumod       VARCHAR2(50),
    exlov_pcmod        VARCHAR2(50),
    exlov_ipmod        VARCHAR2(20)
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

COMMENT ON TABLE operacion.sgat_df_expresion_logica IS
    'Tabla maestra de tipos de expresiones lógicas para las condiciones';

COMMENT ON COLUMN operacion.sgat_df_expresion_logica.exlon_idexplog IS
    'Identificador de la expresión lógica';

COMMENT ON COLUMN operacion.sgat_df_expresion_logica.exlov_simbolo IS
    'Símbolo que representa expresión';

COMMENT ON COLUMN operacion.sgat_df_expresion_logica.exlov_abrev IS
    'Abreviación';

COMMENT ON COLUMN operacion.sgat_df_expresion_logica.exlov_descripcion IS
    'Descripción';

COMMENT ON COLUMN operacion.sgat_df_expresion_logica.exlon_estado IS
    'Estado (1: Activo - 0: Inactivo)';

COMMENT ON COLUMN operacion.sgat_df_expresion_logica.exloc_valscript IS
    'Script para validación';

COMMENT ON COLUMN operacion.sgat_df_expresion_logica.exlod_fecreg IS
    'Fecha de registro';

COMMENT ON COLUMN operacion.sgat_df_expresion_logica.exlov_usureg IS
    'Usuario que registró';

COMMENT ON COLUMN operacion.sgat_df_expresion_logica.exlov_pcreg IS
    'PC desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_expresion_logica.exlov_ipreg IS
    'Ip desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_expresion_logica.exlod_fecmod IS
    'Fecha de modificación';

COMMENT ON COLUMN operacion.sgat_df_expresion_logica.exlov_usumod IS
    'Usuario que modificó';

COMMENT ON COLUMN operacion.sgat_df_expresion_logica.exlov_pcmod IS
    'PC desde donde se modificó';

COMMENT ON COLUMN operacion.sgat_df_expresion_logica.exlov_ipmod IS
    'Ip desde donde se modificó';
