create table operacion.opet_servxtrabajo(
strac_tipsrv      char(4)       NOT NULL,
stran_tiptrabajo  number(4)     NULL,
stran_estsol      number(2)     NULL,
stran_grado       number(2)     NULL,
stran_codmotot    number(3)     NULL,
stran_area        number(4)     NULL,
stran_estado      number(1)     NULL,
strav_usureg      varchar2(30)  default user,
strad_fecreg      date default  sysdate );

COMMENT ON TABLE  operacion.opet_servxtrabajo IS 'Tabla de configuración de Tipos de servicio vs tipo de trabajo para generar SOT demo de suspención';
COMMENT ON COLUMN operacion.opet_servxtrabajo.strac_tipsrv     IS 'Tipo de servicio';
COMMENT ON COLUMN operacion.opet_servxtrabajo.stran_tiptrabajo IS 'Tipo de trabajo';
COMMENT ON COLUMN operacion.opet_servxtrabajo.stran_estsol     IS 'Estado solicitud';
COMMENT ON COLUMN operacion.opet_servxtrabajo.stran_grado      IS 'Grado de solicitud';
COMMENT ON COLUMN operacion.opet_servxtrabajo.stran_codmotot   IS 'Codigo de motivo';
COMMENT ON COLUMN operacion.opet_servxtrabajo.stran_area       IS 'Area';
COMMENT ON COLUMN operacion.opet_servxtrabajo.stran_estado     IS 'Estado del registro';
COMMENT ON COLUMN operacion.opet_servxtrabajo.strav_usureg     IS 'Usuario de registro';
COMMENT ON COLUMN operacion.opet_servxtrabajo.strad_fecreg     IS 'Fecha de registro';

ALTER TABLE operacion.opet_servxtrabajo
add CONSTRAINT strac_tipsrv_pk PRIMARY KEY (strac_tipsrv);

commit;




