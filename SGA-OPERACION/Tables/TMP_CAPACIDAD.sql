-- Create table
create table OPERACION.TMP_CAPACIDAD
(
  ubicacion        VARCHAR2(1000),
  fecha            VARCHAR2(20),
  espaciotiempo    VARCHAR2(30),
  habilidadtrabajo VARCHAR2(30),
  cuota            NUMBER,
  disponible       NUMBER,
  id_agenda        NUMBER(8),
  feccre		   DATE			DEFAULT SYSDATE,
  codsolot		   NUMBER(8)
)
tablespace OPERACION_DAT;

-- Add comments to the columns 
comment on column OPERACION.TMP_CAPACIDAD.ubicacion is 'id bucket';
comment on column OPERACION.TMP_CAPACIDAD.fecha is 'fecha de la capacidad';
comment on column OPERACION.TMP_CAPACIDAD.espaciotiempo is 'franja horaria';
comment on column OPERACION.TMP_CAPACIDAD.habilidadtrabajo is 'work skill ';
comment on column OPERACION.TMP_CAPACIDAD.cuota is 'cuota en minutos';
comment on column OPERACION.TMP_CAPACIDAD.disponible is 'disponible de la cuota en minutos';
comment on column OPERACION.TMP_CAPACIDAD.id_agenda is 'id agenda';
