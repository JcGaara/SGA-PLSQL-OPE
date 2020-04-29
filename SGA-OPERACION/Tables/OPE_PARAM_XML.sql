create table OPERACION.OPE_PARAM_XML
(
  idcab       NUMBER not null,
  idseq       NUMBER not null,
  campo       VARCHAR2(200),
  valor       CLOB, --cambio
  ipapp       VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  usuarioapp  VARCHAR2(30) default USER,
  fecusu      DATE default SYSDATE,
  pcapp       VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  tipo        NUMBER default 1,
  estado      NUMBER default 1,
  orden       NUMBER,
  descripcion VARCHAR2(300)
);

    comment on column OPERACION.OPE_PARAM_XML.idcab
      is 'ID Cabecera';
    comment on column OPERACION.OPE_PARAM_XML.idseq
      is 'ID Detalle';
    comment on column OPERACION.OPE_PARAM_XML.campo
      is 'Campo';
    comment on column OPERACION.OPE_PARAM_XML.valor
      is 'Valor del campo. Constante o Query';
    comment on column OPERACION.OPE_PARAM_XML.ipapp
      is 'IP Aplicacion';
    comment on column OPERACION.OPE_PARAM_XML.usuarioapp
      is 'Usuario APP';
    comment on column OPERACION.OPE_PARAM_XML.fecusu
      is 'Fecha de Registro';
    comment on column OPERACION.OPE_PARAM_XML.pcapp
      is 'PC Aplicacion';
    comment on column OPERACION.OPE_PARAM_XML.tipo
      is '1:Constante 2:Execute 3:Exec. Parámetros';
    comment on column OPERACION.OPE_PARAM_XML.estado
      is 'Estado 1: Activo 0: Desactivo';
    comment on column OPERACION.OPE_PARAM_XML.orden
      is 'Orden relativo de ejecución - Null';
    comment on column OPERACION.OPE_PARAM_XML.descripcion
      is 'Descripcion Breve';
