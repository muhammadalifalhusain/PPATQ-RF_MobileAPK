<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class KesehatanController extends Controller
{
    public function getDataKesehatan(Request $request)
    {
        // Ambil data dari API hosting
        $response = Http::get("http://api.ppatq-rf.id/api/kesehatan-santri");
        $data = $response->json();

        // Periksa apakah ada data yang diambil
        if (!isset($data['data'])) {
            return response()->json([
                'status' => 500,
                'message' => 'Gagal mengambil data dari server',
                'data' => []
            ], 500);
        }

        // Ambil parameter no_induk dari query parameter atau request body
        $noInduk = $request->query('no_induk') ?? $request->input('no_induk');

        // Jika ada no_induk, filter data berdasarkan no_induk
        if ($noInduk) {
            $filteredData = array_filter($data['data'], function ($item) use ($noInduk) {
                return isset($item['no_induk']) && $item['no_induk'] == $noInduk;
            });

            return response()->json([
                'status' => 200,
                'message' => 'Berhasil mengambil data berdasarkan no_induk',
                'data' => array_values($filteredData)
            ]);
        }

        // Jika tidak ada parameter, kembalikan semua data
        return response()->json([
            'status' => 200,
            'message' => 'Berhasil mengambil semua data kesehatan',
            'data' => $data['data']
        ]);
    }
}
