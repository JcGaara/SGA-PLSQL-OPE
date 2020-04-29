create table operacion.control_contrato_bscs_lte
(
codsolot number not null,
idtransaccion varchar2(30),
fecreg date default sysdate,
usuareg varchar2(20) default user,
fecmod date default sysdate,
usuamod varchar2(20) default user
);

-- Add comments to the columns 
comment on column operacion.control_contrato_bscs_lte.codsolot
  is 'SOT LTE';
comment on column operacion.control_contrato_bscs_lte.idtransaccion
  is 'Identificador de Transaccion para Actualizar Contrato a estado a-x';
comment on column operacion.control_contrato_bscs_lte.fecreg
  is 'Fecha de Registro';
comment on column operacion.control_contrato_bscs_lte.usuareg
  is 'Usuario Registrador';
comment on column operacion.control_contrato_bscs_lte.fecmod
  is 'Fecha de Modificacion';
comment on column operacion.control_contrato_bscs_lte.usuamod
  is 'Usuario Modificador';