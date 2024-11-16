DO $$
DECLARE
    func_record RECORD;
BEGIN
    FOR func_record IN
        SELECT n.nspname AS schema_name, p.proname AS function_name,
               pg_catalog.pg_get_function_identity_arguments(p.oid) AS arguments
        FROM pg_proc p
        JOIN pg_namespace n ON p.pronamespace = n.oid
        WHERE n.nspname = 'public'
          AND p.prokind = 'f'
    LOOP
        EXECUTE 'DROP FUNCTION IF EXISTS ' || func_record.schema_name || '.' || func_record.function_name || '(' || func_record.arguments || ');';
    END LOOP;
END $$;
