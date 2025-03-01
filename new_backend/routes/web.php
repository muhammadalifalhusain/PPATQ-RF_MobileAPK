<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\SantriController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;



Route::get('/santri', [SantriController::class, 'searchSantri']);
Route::get('/kelas', [SantriController::class, 'getKelas']);
Route::get('/data-santri', [SantriController::class, 'getSantri']);

Route::get('/kesehatan', function () {
    $response = Http::get("http://api.ppatq-rf.id/api/kesehatan-santri");
    return $response->json();
});

