<?php

use App\Http\Controllers\BeritaController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\SantriController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use App\Http\Controllers\KesehatanController;
use App\Http\Controllers\AuthController;



Route::post('/login', [AuthController::class, 'index']);
Route::get('/santri', [SantriController::class, 'searchSantri']);
Route::get('/kelas', [SantriController::class, 'getKelas']);
Route::get('/data-santri', [SantriController::class, 'getSantri']);
Route::get('/kesehatan', [KesehatanController::class, 'getDataKesehatan']); // Menggunakan query parameter
Route::post('/kesehatan', [KesehatanController::class, 'getDataKesehatan']); // Menggunakan request body JSON
Route::get('/berita', [BeritaController::class, 'getBerita']); // Menggunakan query parameter

