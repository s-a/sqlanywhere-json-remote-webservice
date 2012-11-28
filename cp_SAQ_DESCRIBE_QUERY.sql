call sa_make_object('procedure','SAQ_DESCRIBE_QUERY');
ALTER PROCEDURE "DBA"."SAQ_DESCRIBE_QUERY"($sql long varchar)
begin
    select
        v.column_number as COL_ID,
        v.name as COL_NAME,
        cast(if isnull(c.PKEY,'N') ='Y' then 1 else 0 endif as bit) as PKEY,
        cast(if isnull(c.NULLS,'N') ='N' then 1 else 0 endif as bit) as NOTNULL,
        cast(if base_column_id is null then 1 else 0 endif as bit) as "READONLY",
        v.DOMAIN_ID,
        v.DOMAIN_NAME,
        v.WIDTH,
        v.SCALE,
        SAQ_GET_DOMAIN_LIMIT(v.DOMAIN_NAME,1,v.WIDTH,v.SCALE) as MIN_VALUE,
        SAQ_GET_DOMAIN_LIMIT(v.DOMAIN_NAME,0,v.WIDTH,v.SCALE) as MAX_VALUE,
        c."DEFAULT",
        '' as VALUE,
        //
        v.base_table_id,
        v.base_column_id,
        fk.*
     into #result from sa_describe_query($sql) v
            left outer join syscolumn c on v.base_table_id=c.table_id and v.Base_column_id = c.column_id
            left outer join SAQ_DESCRIBE_FOREIGNKEY fk on v.base_table_id=fk.foreign_table_id and v.Base_column_id = fk.foreign_column_id;
    insert into #result (col_id, col_name, pkey,notnull, "readonly", value, max_value, min_value)  values (0, 'ID',1,1,1,'', '', '');
    select * from #result order by col_id;
end