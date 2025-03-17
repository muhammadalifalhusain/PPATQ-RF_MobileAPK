<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AgendaController extends Controller
{
    public function index(Request $request)
    {
        $perPage = $request->input('per_page', 5);

        $agenda = DB::table('agenda')
                    ->select('judul', 'tanggal_mulai', 'tanggal_selesai')
                    ->orderBy('tanggal_mulai', 'desc')
                    ->paginate($perPage);

        return response()->json([
            'success' => true,
            'message' => 'List Agenda',
            'data'    => $agenda
        ], 200);
    }
}
