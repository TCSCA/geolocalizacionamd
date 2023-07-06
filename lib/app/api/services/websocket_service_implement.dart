import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import '/app/api/constants/api_constants.dart';
import 'websocket_service.dart';

class WebSocketServiceImp extends WebSocketService {
  late StompClient? clientSocket;
  late int connectionValidateTime = 3;

  @override
  Future<bool> onConnect(String token) async {
    bool isConnect = false;
    final Map<String, String> headerWebSocket = {'token': token};

    try {
      clientSocket = StompClient(
          config: StompConfig.SockJS(
        url: ApiConstants.urlWebSocket,
        webSocketConnectHeaders: headerWebSocket,
        stompConnectHeaders: headerWebSocket,
        //connectionTimeout: const Duration(seconds: 5),
        reconnectDelay: const Duration(milliseconds: 0),
        onConnect: (StompFrame connectFrame) {
          if (kDebugMode) {
            print('Conexion exitosa');
          }
        },
        onDisconnect: (StompFrame disconnectFrame) {
          if (kDebugMode) {
            print('Desconexion exitosa');
          }
        },
        onStompError: (StompFrame onStompError) {
          if (kDebugMode) {
            print('Error en Stomp: $onStompError');
          }
        },
        onWebSocketError: (dynamic onWebSocketError) {
          if (kDebugMode) {
            print('Error en WebSocket: $onWebSocketError');
          }
        },
      ));

      if (clientSocket != null) {
        clientSocket!.activate();
        await Future.delayed(Duration(seconds: connectionValidateTime));
        if (clientSocket!.connected) {
          isConnect = true;
        }
      }
    } catch (error) {
      isConnect = false;
    }

    return isConnect;
  }

  @override
  Future<bool> onDisconnect() async {
    bool isDisconnect = false;

    try {
      if (clientSocket != null) {
        clientSocket!.deactivate();
        await Future.delayed(Duration(seconds: connectionValidateTime));
        if (!clientSocket!.isActive) {
          isDisconnect = true;
        }
      }
    } catch (error) {
      isDisconnect = false;
    } finally {
      clientSocket = null;
    }

    return isDisconnect;
  }
}
