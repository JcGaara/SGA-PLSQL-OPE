-- Create table
create table OPERACION.SGAT_SRVEQU_INCOGNITO
(
  idsrvequ                NUMBER not null,
  idtrx                   NUMBER not null,
  customer_id             VARCHAR2(20),
  serviceid               NUMBER,
  serviceidentifier       VARCHAR2(100),
  servicename             VARCHAR2(100),
  servicetypeid           VARCHAR2(100),
  servicestatus           VARCHAR2(100),
  equipmentid             NUMBER,
  equipmentypedescription VARCHAR2(100),
  equipmentcodename       VARCHAR2(100),
  equipmentidentifier     VARCHAR2(100),
  tag                     VARCHAR2(100),
  id_producto             NUMBER,
  id_producto_padre       NUMBER,
  id_venta                NUMBER,
  id_venta_padre          NUMBER
);

-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_SRVEQU_INCOGNITO
  add constraint PK_SGAT_SRVEQU_INCOGNITO primary key (IDSRVEQU)
  using index 
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 128K
    next 1M
    minextents 1
    maxextents unlimited
  );

-- Grant/Revoke object privileges 
grant all on OPERACION.SGAT_SRVEQU_INCOGNITO to R_PROD;
grant all on OPERACION.SGAT_SRVEQU_INCOGNITO to INTRAWAY;

-- Trigger
CREATE OR REPLACE TRIGGER operacion.t_sgat_srvequ_incognito_bi
  BEFORE INSERT ON operacion.sgat_srvequ_incognito
  FOR EACH ROW
DECLARE
  tmpvar NUMBER;
BEGIN
  IF :new.idsrvequ IS NULL THEN
    SELECT nvl(MAX(idsrvequ), 0) + 1
      INTO :new.idsrvequ
      FROM operacion.sgat_srvequ_incognito;
  END IF;
END;
/