-- Create/Recreate primary, unique and foreign key constraints 
alter table ATCCORP.ATCINCIDENCEXSOLOT
  add constraint IDX_ATCINCIDENCESOLOT foreign key (CODINCIDENCE)
  references atccorp.incidence (CODINCIDENCE);
