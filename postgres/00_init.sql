    CREATE USER "pgreplication_username" WITH REPLICATION ENCRYPTED PASSWORD "replication_password";
    SELECT pg_create_physical_replication_slot('replication_slot');