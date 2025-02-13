<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\SantriController;

Route::get('/santri', [SantriController::class, 'searchSantri']);

