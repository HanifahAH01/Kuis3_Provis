import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class ActivityModel {
  String id;
  String nama;
  String jenis;
  ActivityModel(
      {required this.id,
      required this.nama,
      required this.jenis}); //constructor
}

class ActivityCubit extends Cubit<List<ActivityModel>> {
  String url = "http://178.128.17.76:8000/daftar_umkm";
  ActivityCubit() : super([]);

  List<ActivityModel> ListActivityModel = <ActivityModel>[];
  //map dari json ke atribut
  void setFromJson(Map<String, dynamic> json) {
    var data = json["data"];
    for (var val in data) {
      String id = val['id'];
      String nama = val['nama'];
      String jenis = val['jenis'];

      ListActivityModel.add(ActivityModel(id: id, nama: nama, jenis: jenis));
    }
    emit(ListActivityModel);
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

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => ActivityCubit(),
        child: const HalamanUtama(),
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<ActivityCubit, List<ActivityModel>>(
                // ignore: non_constant_identifier_names
                builder: (context, ListActivityModel) {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<ActivityCubit>().fetchData();
                        },
                        child: const Text("Reload Daftar UMKM"),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (ListActivityModel.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: ListActivityModel.length,
                          itemBuilder: (context, index) {
                            var activity = ListActivityModel[index];
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(activity.id.toString()),
                                  Text(activity.nama),
                                  Text(activity.jenis),
                                ],
                              ),
                            );
                          },
                        ),
                      if (ListActivityModel.isEmpty)
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
