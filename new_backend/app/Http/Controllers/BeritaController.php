<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;

class BeritaController extends Controller
{   
    public function getBerita(Request $request)
    {
        // Ambil data dari API hosting
        $response = Http::get("http://api.ppatq-rf.id/api/berita");
        $data = $response->json();

        // Periksa apakah ada data yang diambil
        if (!isset($data['data'])) {
            return response()->json([
                'status' => 500,
                'message' => 'Gagal mengambil data dari server',
                'data' => []
            ], 500);
        }

        return response()->json([
            'status' => 200,
            'message' => 'Berhasil mengambil semua data berita',
            'data' => $data['data']
        ]);
    }
}