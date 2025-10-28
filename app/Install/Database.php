<?php

namespace FleetCart\Install;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Artisan;
use FleetCart\Support\EnvWriter;

class Database
{
    public function setup($request): void
    {
        $this->setupDatabaseConnection($request);
        $this->setEnvVariables($request);
        $this->migrateDatabase();
    }


    private function setupDatabaseConnection($request): void
    {
        DB::purge('mysql');
        $this->setupDatabaseConnectionConfig($request);
        DB::connection('mysql')->reconnect();
        DB::connection('mysql')->getPdo();
    }


    private function setupDatabaseConnectionConfig($request): void
    {
        config([
            'database.default' => 'mysql',
            'database.connections.mysql.host' => $request['db_host'],
            'database.connections.mysql.port' => $request['db_port'],
            'database.connections.mysql.database' => $request['db_database'],
            'database.connections.mysql.username' => $request['db_username'],
            'database.connections.mysql.password' => $request['db_password'],
        ]);
    }


    private function setEnvVariables($request): void
    {
        $env = EnvWriter::load();
        $env->setKey('DB_HOST', (string) $request['db_host'])
            ->setKey('DB_PORT', (string) $request['db_port'])
            ->setKey('DB_DATABASE', (string) $request['db_database'])
            ->setKey('DB_USERNAME', (string) $request['db_username'])
            ->setKey('DB_PASSWORD', (string) $request['db_password'])
            ->save();
    }


    private function migrateDatabase(): void
    {
        Artisan::call('migrate', ['--force' => true]);
    }
}
