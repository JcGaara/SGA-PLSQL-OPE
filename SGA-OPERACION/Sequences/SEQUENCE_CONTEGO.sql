-- Create sequence 
create sequence OPERACION.SGASEQ_CONTEGO
minvalue 1
maxvalue 99999999999999999999
start with 1
increment by 1
nocache
order;

create sequence OPERACION.SGASEQ_LOGERR
minvalue 1
maxvalue 99999999999999999999
start with 1
increment by 1
nocache
order;

create sequence OPERACION.SGASEQ_TRANSCONTEGO
minvalue 1
maxvalue 99999999999999999999
start with 1
increment by 1
nocache
order
/