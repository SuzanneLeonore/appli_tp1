import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:mysql_client/mysql_client.dart';

Future<MySQLConnection> initDb() async {
  final conn = await MySQLConnection.createConnection(
    host: 'localhost',
    port: 3306,
    userName: 'root',
    password: 'password',
    databaseName: 'art_collections',
  );
  await conn.connect();
  return conn;
}

Future<Response> getArtworks(Request request) async {
  final conn = await initDb();
  var results = await conn.execute("SELECT * FROM artworks");

  List<Map<String, dynamic>> artworks = results.rows
      .map((row) => {
            "id": row.colAt(0),
            "title": row.colAt(1),
            "artist": row.colAt(2),
            "year": row.colAt(3),
            "museum": row.colAt(4),
            "image_url": row.colAt(5),
          })
      .toList();

  await conn.close();
  return Response.ok(
    jsonEncode(artworks),
    headers: {'Content-Type': 'application/json'},
  );
}

void main() async {
  final handler = const Pipeline().addHandler(getArtworks);
  final server = await shelf_io.serve(handler, 'localhost', 8080);
  print('✅ Serveur démarré sur http://${server.address.host}:${server.port}');
}
