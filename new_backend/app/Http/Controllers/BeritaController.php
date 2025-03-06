<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class BeritaController extends Controller
{
    public function getBerita()
    {
        // Hanya ambil data yang thumbnail-nya tidak null
        $berita = DB::table('berita')
            ->select('judul', 'thumbnail', 'isi_berita')
            ->whereNotNull('thumbnail') // Filter data yang thumbnail-nya tidak null
            ->get();

        return response()->json([
            'success' => true,
            'data' => $berita
        ]);
    }
}