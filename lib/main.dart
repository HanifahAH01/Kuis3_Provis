import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UMKMModel {
  String id;
  String nama;
  String jenis;
  UMKMModel(
      {required this.id,
      required this.nama,
      required this.jenis}); //constructor
}

class UMKMCubit extends Cubit<List<UMKMModel>> {
  String url = "http://178.128.17.76:8000/daftar_umkm";
  UMKMCubit() : super([]);

  List<UMKMModel> ListUMKModel = <UMKMModel>[];
  //map dari json ke atribut
  void setFromJson(Map<String, dynamic> json) {
    var data = json["data"];
    for (var val in data) {
      String id = val['id'];
      String nama = val['nama'];
      String jenis = val['jenis'];

      ListUMKModel.add(UMKMModel(id: id, nama: nama, jenis: jenis));
    }
    emit(ListUMKModel);
  }

  void fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

class UMKMDetailModel {
  String id;
  String nama;
  String jenis;
  String omzetBulan;
  String lamaUsaha;
  String memberSejak;
  String jumlahPinjamanSukses;
  UMKMDetailModel(
      {required this.id,
      required this.nama,
      required this.jenis,
      required this.omzetBulan,
      required this.lamaUsaha,
      required this.memberSejak,
      required this.jumlahPinjamanSukses}); //constructor
}

class UMKMDetailCubit extends Cubit<UMKMDetailModel> {
  UMKMDetailCubit()
      : super(UMKMDetailModel(
            id: "",
            nama: "",
            jenis: "",
            omzetBulan: "",
            lamaUsaha: "",
            memberSejak: "",
            jumlahPinjamanSukses: ""));

  //map dari json ke atribut
  void setFromJson(Map<String, dynamic> json) {
    var id = json["id"];
    var nama = json["nama"];
    var jenis = json["jenis"];
    var omzetBulan = json["omzet_bulan"];
    var lamaUsaha = json["lama_usaha"];
    var memberSejak = json["member_sejak"];
    var jumlahPinjamanSukses = json["jumlah_pinjaman_sukses"];

    emit(UMKMDetailModel(
        id: id,
        nama: nama,
        jenis: jenis,
        omzetBulan: omzetBulan,
        lamaUsaha: lamaUsaha,
        memberSejak: memberSejak,
        jumlahPinjamanSukses: jumlahPinjamanSukses));
  }

  void fetchData(String id) async {
    String url = "http://178.128.17.76:8000/detil_umkm/$id";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UMKMCubit>(
          create: (_) => UMKMCubit(),
        ),
        BlocProvider<UMKMDetailCubit>(
          create: (_) => UMKMDetailCubit(),
        ),
      ],
      child: const MaterialApp(
        home: HalamanUtama(),
      ),
    );
  }
}

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("My App")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<UMKMCubit, List<UMKMModel>>(
                builder: (context, listUmkmModel) {
                  return Column(
                    children: [
                      const Text(
                          "NIM: 2008433, Nama: Aji Muhammad Zapar; NIM: 2000152, Nama: Hanifah Al Humaira; Saya berjanji tidak akan berbuat curang data atau membantu orang lain berbuat curang"),
                      const Padding(padding: EdgeInsets.all(80)),
                      ElevatedButton(
                        onPressed: () {
                          context.read<UMKMCubit>().fetchData();
                        },
                        child: const Text("Reload Daftar UMKM"),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (listUmkmModel.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: listUmkmModel.length,
                          itemBuilder: (context, index) {
                            var umkm = listUmkmModel[index];
                            return InkWell(
                              onTap: () => {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return DetailUMKM(
                                    id: umkm.id,
                                  );
                                }))
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                ),
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(umkm.nama),
                                    Text(umkm.jenis),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      if (listUmkmModel.isEmpty)
                        const Text('Data tidak ditemukan')
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailUMKM extends StatelessWidget {
  const DetailUMKM({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detil umkm'),
      ),
      body: Center(
        child: BlocBuilder<UMKMDetailCubit, UMKMDetailModel>(
          // ignore: avoid_types_as_parameter_names
          builder: (context, umkmmodel) {
            context.read<UMKMDetailCubit>().fetchData(id);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Nama: ${umkmmodel.nama}"),
                Text("Jenis: ${umkmmodel.jenis}"),
                Text("Member sejak: ${umkmmodel.memberSejak}"),
                Text("Omzet per bulan: ${umkmmodel.omzetBulan}"),
                Text("Lama usaha: ${umkmmodel.lamaUsaha}"),
                Text(
                    "Jumlah Pinjaman Sukses: ${umkmmodel.jumlahPinjamanSukses}"),
              ],
            );
          },
        ),
      ),
    );
  }
}
