
import 'package:api/controllers/abstract_controller.dart';
import 'package:api/domain/enums/api/api_method_type.dart';

abstract class AbstractApiController extends AbstractController {
  
  const AbstractApiController({
    required super.request,
    required super.authProvider
  });
  
  void handlerRequest() {
    final apiMethodType = ApiMethodType.getType(request.method);

    switch (apiMethodType) {
      case ApiMethodType.get:
        get();
        break;
      case ApiMethodType.post:
        post();
        break;
      case ApiMethodType.delete:
        delete();
        break;
      case ApiMethodType.put:
        put();
        break;
      case ApiMethodType.patch:
        patch();
        break;
      default:
        methodNotAllowed();
        break;
    }
  }

  void get();
  void post();
  void put();
  void delete();
  void patch();
}
