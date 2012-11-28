CALL sa_make_object('view', 'SAQ_DESCRIBE_FOREIGNKEY');
ALTER VIEW SAQ_DESCRIBE_FOREIGNKEY as
    select
        SYSFOREIGNKEY.FOREIGN_KEY_ID    as FKEY_ID,
        SYSFOREIGNKEY.ROLE              as FKEY_NAME,
        B0.table_ID                     as PRIMARY_TABLE_ID,
        B1.COLUMN_ID                    as PRIMARY_COLUMN_ID,
        B0.table_name                   as PRIMARY_TABLE_NAME,
        B1.column_name                  as PRIMARY_COLNAME,

        A0.table_ID                     as FOREIGN_TABLE_ID,
        A1.COLUMN_ID                    as FOREIGN_COLUMN_ID,
        A0.table_name                   as FOREIGN_TABLE_NAME,
        A1.column_name                  as FOREIGN_COLNAME
        from SYSFOREIGNKEY
        JOIN SYSFKCOL on
            SYSFKCOL.foreign_table_id = SYSFOREIGNKEY.foreign_table_id and
            SYSFKCOL.foreign_key_id   = SYSFOREIGNKEY.foreign_key_id
        JOIN SYSCOLUMN A1 on A1.table_id = SYSFOREIGNKEY.foreign_table_id and A1.COLUMN_ID = SYSFKCOL.foreign_column_id
        JOIN SYSTABLE A0 on A0.table_id = SYSFOREIGNKEY.foreign_table_id
        JOIN SYSCOLUMN B1 on B1.table_id = SYSFOREIGNKEY.primary_table_id and B1.COLUMN_ID = SYSFKCOL.primary_column_id
        JOIN SYSTABLE B0 on B0.table_id = SYSFOREIGNKEY.primary_table_id ;
