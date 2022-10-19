import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

void main() async {
  final app = Router();
  app.get('/', _handleInicial);
  app.post('/user', _handleUser);
  app.get('/teste', _handleTeste);

  final pipeline = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(addJsonType())
      .addHandler(app);

  var server = await shelf_io.serve(
    pipeline,
    "localhost",
    8080,
  );
  print("Server funcionando em Http:: ${server.address.host}: ${server.port} ");
}

Middleware addJsonType() {
  return (handle) {
    return (request) async {
      var response = await handle(request);
      response = response.change(headers: {
        "content-type": "application/json",
      });
      return response;
    };
  };
}

Response _handle(Request request) {
  if (request.url.path == "/") {
    return Response.ok('Rota Inicial');
  } else if (request.url.path == "teste") {
    return Response.ok("Teste");
  }
  return Response.notFound("Pagina nao encontrada");
}

Response _handleInicial(Request request) {
  return Response.ok("Rota Inicial");
}

Response _handleTeste(Request request) {
  return Response.ok("Rota teste");
}

Response _handleUser(Request request) {
  final _json = {"nome": "Davi", "idade": "22"};

  return Response(201, body: jsonEncode(_json));
}
