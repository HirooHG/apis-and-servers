import 'dart:io';
import 'package:api/controllers/abstract_controller.dart';
import 'package:api/controllers/api/admin/admin_controller.dart';
import 'package:api/controllers/api/japanimation/japanimation_controller.dart';
import 'package:api/controllers/ws/tictactoe/tictactoe_controller.dart';
import 'package:api/data/api/datasources/admin_datasource.dart';
import 'package:api/data/api/datasources/japanimation_datasource.dart';
import 'package:api/data/api/repositories/admin_repository.dart';
import 'package:api/data/api/repositories/japanimation_repository.dart';
import 'package:api/data/mongo_handler.dart';
import 'package:api/data/ws/tictactoe_datasource.dart';
import 'package:api/common/enums/api_type.dart';
import 'package:api/common/enums/request_type.dart';
import 'package:api/common/enums/websocket_type.dart';
import 'package:api/common/extension/list_helper.dart';
import 'package:api/server/middleware/audience.dart';
import 'package:api/server/middleware/entities/response.dart';

class GenController extends AbstractController {

  const GenController({
    required super.request,
    required super.authProvider
  });

  void handleRequest() async {
    final type = _getType();


    switch (type) {
      case RequestType.ws:
        if(!(await verifyAudience(Audience.service))) {
          break;
        }
        _handleWs();
        break;
      case RequestType.api:
        if(!(await verifyAudience(Audience.service))) {
          break;
        }
        _handleApi();
        break;
      case RequestType.login:
        _handleLogin();
        break;
      case RequestType.admin:
        _handleAdmin();
        break;
      default:
        notFound();
        break;
    }
  }

  void _handleLogin() async {
    final Response response = await authProvider.auth(request);
    if(response.isOk()) {
      success(response.token!);
    } else {
      forbidden();
    }
  }

  void _handleAdmin() async {
    if(!(await verifyAudience(Audience.admin))) {
      return;
    }

    AdminController(
      request: request,
      authProvider: authProvider,
      repository: AdminRepository(dataSource: AdminDataSource(mongoHandler: MongoHandler()))
    ).handlerRequest();
  }

  void _handleApi() async {
    if(!(await verifyAudience(Audience.api))) {
      return;
    }

    final type = _getApiType();

    switch (type) {
      case ApiType.japanimation:
        if(!(await verifyAudience(Audience.japanimation))) {
          break;
        }
        JapanimationController(
          request: request,
          authProvider: authProvider,
          repository: JapanimationRepository(
            dataSource: JapanimationDatasource(mongoHandler: MongoHandler())
          )
        ).handlerRequest();
        break;
      default:
        notFound();
        break;
    }
  }

  void _handleWs() async {
    if(!(await verifyAudience(Audience.ws))) {
      return;
    }
    final type = _getWsType();

    switch (type) {
      case WebsocketType.tictactoe:
        if(!(await verifyAudience(Audience.japanimation))) {
          break;
        }

        final socket = await testWs(request);
        if(socket != null) {
          TicTacToeController(
            request: request,
            authProvider: authProvider,
            socket: socket,
            dataSource: TicTacToeDataSource()
          ).listenToChannel();
        }
        break;
      default:
        notFound();
        break;
    }
  }

  Future<WebSocket?> testWs(HttpRequest req) async {
    try {
      return await WebSocketTransformer.upgrade(req);
    } catch(e) {
      return null;
    }
  }

  ApiType? _getApiType() {
    final segment = getSegment(1);
    if(segment == null) {
      return null;
    }
    return ApiType.values.nullWhere((e) => e.name == segment);
  }
  
  WebsocketType? _getWsType() {
    final segment = getSegment(1);
    if(segment == null) {
      return null;
    }
    return WebsocketType.values.nullWhere((e) => e.name == segment);
  }

  RequestType? _getType() {
    final segment = getSegment(0);
    if(segment == null) {
      return null;
    }
    return RequestType.values.nullWhere((e) => e.name == segment);
  }
}
