<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Response;


class SantriController extends Controller
{
    public function searchSantri(Request $request)
    {
        $nama = $request->input('nama');
        $kelas = $request->input('kelas');
        $photo = $request->input('photo');

        $santri = DB::table('santri_detail')
            ->when($nama, fn($query) => $query->where('nama', $nama))
            ->when($kelas, fn($query) => $query->where('kelas', $kelas))
            ->first();


        if (!$santri) {
            return response()->json([
                'success' => false,
                'message' => 'Santri dengan nama dan kelas tersebut tidak ditemukan'
            ], 404);
        }

        $kelasData = DB::table('ref_kelas')
            ->where('code', $kelas)
            ->first();

        if (!$kelasData || !$kelasData->employee_id) {
            return response()->json([
                'success' => false,
                'message' => 'Data kelas tidak valid atau tidak memiliki employee'
            ], 404);
        }

        $employee = DB::table('employee_new')
            ->where('id', $kelasData->employee_id)
            ->first();

        if (!$employee) {
            return response()->json([
                'success' => false,
                'message' => 'Data employee tidak ditemukan'
            ], 404);
        }

        $kamar = DB::table('ref_kamar')
            ->where('id', $santri->kamar_id)
            ->first();

        $murroby = [
            'nama' => 'Tidak Diketahui',
            'photo' => null
        ];

        if ($kamar && $kamar->employee_id) {
            $murrobyData = DB::table('employee_new')
                ->where('id', $kamar->employee_id)
                ->first();

            if ($murrobyData) {
                $murroby['nama'] = $murrobyData->nama;
                $murroby['photo'] = $murrobyData->photo;
            }
        }

        return response()->json([
            'success' => true,
            'data' => [
                'id' => $santri->id,
                'nama' => $santri->nama,
                'photo' => $santri->photo,
                'kelas' => $kelasData->name,
                'murroby' => $murroby,
                'employee' => [
                    'id' => $employee->id,
                    'nama' => $employee->nama,
                    'photo' => $employee->photo,
                ]
            ]
        ]);
    }

    public function getKelas()
    {
        $kelas = DB::table('ref_kelas')->select('code', 'name')->get();

        return response()->json([
            'success' => true,
            'data' => $kelas
        ]);
    }
}