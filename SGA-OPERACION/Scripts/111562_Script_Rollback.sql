-- Drop columns 
alter table OPERACION.SOLOTPTOEQU drop column CANLIQ;

-- Drop indexes 
drop index OPERACION.IDK_CODUBIFECAGENDA_AGENDA;

delete operacion.ope_cuadrillaxdistrito_det;

commit;



