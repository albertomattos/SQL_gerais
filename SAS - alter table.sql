alter table hrm_jobs modify organization varchar(160);
alter table hrm_jobs modify reference varchar(160);

alter table hrm_mappings_scales modify name varchar(250);

alter table hrm_mapping_scale_options modify name varchar(250);

alter table hrm_pr_targets modify name varchar(250);

alter table hrm_pr_questionnaires modify name varchar(80);

alter table hrm_pr_questionnaire_topics modify name varchar(250);

alter table hrm_classifications_scales modify name varchar(250);

alter table hrm_matriculations modify serie varchar(24);

alter table hrm_cr_results modify "OPTION" varchar(80);

update cmn_properties set value=39.1 where name='SchemaVersion';
update cmn_properties set value=39.1 where name='hrm.schema';
