<?php

use Illuminate\Support\Facades\Route;

Route::get('install', 'InstallController@installation')->name('install.show');
Route::post('install', 'InstallController@install')->name('install.do');

Route::get('license', 'LicenseController@create')->name('license.create');
Route::post('license', 'LicenseController@store')->name('license.store');

// Lightweight health endpoint for Railway healthcheck
Route::get('health', function () {
    return response()->json(['status' => 'ok']);
})->withoutMiddleware(['web', 'localize', 'locale_session_redirect', 'localization_redirect']);
