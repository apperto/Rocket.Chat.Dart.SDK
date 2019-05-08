part of realtime;

abstract class _ClientChannelsMixin implements _DdpClientWrapper {
  Future<String> createDirectMessage(String username) {
    Completer<String> completer = Completer();
    this
        ._getDdpClient()
        .call('createDirectMessage', [username])
        .then((call) => completer.complete(call.reply["rid"] as String))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<String> getChannelId(String name) {
    Completer<String> completer = Completer();
    this
        ._getDdpClient()
        .call('getRoomIdByNameOrId', [name])
        .then((call) => completer.complete(call.reply as String))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  // getRooms gets all updates made to rooms since the lastUpdate. It returns a list of lists of channels.
  // It must always return a list of 2 lists. The first list contains the updates and the second the removes
  Future<List<List<Channel>>> getRooms({DateTime lastUpdate}) {
    var timestamp = "";
    if (lastUpdate != null) {
      timestamp = lastUpdate.toIso8601String();
    }
    print(timestamp);
    Completer<List<List<Channel>>> completer = Completer();
    this._getDdpClient().call('rooms/get', [
      <String, dynamic>{"\$date": timestamp}
    ]).then((call) {
      List<Channel> updates = [];
      (call.reply['update'] as List<dynamic>).forEach((chan) => updates.add(
          Channel()
            ..id = '${chan['_id']}'
            ..name = '${chan['name']}'
            ..type = '${chan['t']}'
            ..lastMessage = chan['lastMessage'] == null
                ? null
                : Message.fromJson(chan['lastMessage'])));

      List<Channel> removes = [];

      (call.reply['remove'] as List<dynamic>).forEach((chan) => removes.add(
          Channel()
            ..id = '${chan['_id']}'
            ..name = '${chan['name']}'
            ..type = '${chan['t']}'
            ..lastMessage = chan['lastMessage'] == null
                ? null
                : Message.fromJson(chan['lastMessage'])));
      completer.complete([updates, removes]);
    }).catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<List<ChannelSubscription>> getChannelSubscriptions(
      {DateTime lastUpdate}) {
    var timestamp = "";
    if (lastUpdate != null) {
      timestamp = lastUpdate.toIso8601String();
    }
    Completer<List<ChannelSubscription>> completer = Completer();
    this._getDdpClient().call('subscriptions/get', [
      <String, dynamic>{'\$date': timestamp}
    ]).then((call) {
      List<ChannelSubscription> subscriptions = [];
      (call.reply['update'] as List<dynamic>).forEach((s) => subscriptions.add(
          ChannelSubscription()
            ..id = '${s['_id']}'
            ..alert = s['alert']
            ..name = '${s['name']}'
            ..roomId = '${s['rid']}'
            ..displayName = '${s['fname']}'
            ..open = s['open']
            ..type = '${s['t']}'
            ..user = (User()
              ..id = '${s['u']['_id']}'
              ..userName = '${s['u']['username']}')
            ..unread = s['unread']
            ..roles = (s['roles'] ?? [])
                .map<String>((role) => role as String)
                .toList()));
      completer.complete(subscriptions);
    }).catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<void> createChannel(String name, List<String> users) {
    Completer<void> completer = Completer();
    this
        ._getDdpClient()
        .call('createPrivateGroup', [name, users])
        .then((call) => completer.complete(null))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<void> joinChannel(String roomId) {
    Completer<void> completer = Completer();
    this
        ._getDdpClient()
        .call('joinRoom', [roomId])
        .then((value) => completer.complete(null))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<void> archiveChannel(String roomId) {
    Completer<void> completer = Completer();
    this
        ._getDdpClient()
        .call('archiveRoom', [roomId])
        .then((value) => completer.complete(null))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<void> unArchiveChannel(String roomId) {
    Completer<void> completer = Completer();
    this
        ._getDdpClient()
        .call('unarchiveRoom', [roomId])
        .then((value) => completer.complete(null))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<void> deleteChannel(String roomId) {
    Completer<void> completer = Completer();
    this
        ._getDdpClient()
        .call('eraseRoom', [roomId])
        .then((value) => completer.complete(null))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<void> setChannelTopic(String roomId, String topic) {
    Completer<void> completer = Completer();
    this
        ._getDdpClient()
        .call('saveRoomSettings', [roomId, 'roomTopic', topic])
        .then((value) => completer.complete(null))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<void> setChannelType(String roomId, String roomType) {
    Completer<void> completer = Completer();
    this
        ._getDdpClient()
        .call('saveRoomSettings', [roomId, 'roomType', roomType])
        .then((value) => completer.complete(null))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<void> setChannelJoinCode(String roomId, String joinCode) {
    Completer<void> completer = Completer();
    this
        ._getDdpClient()
        .call('saveRoomSettings', [roomId, 'joinCode', joinCode])
        .then((value) => completer.complete(null))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<void> setChannelReadOnly(String roomId, bool readOnly) {
    Completer<void> completer = Completer();
    this
        ._getDdpClient()
        .call('saveRoomSettings', [roomId, 'readOnly', readOnly])
        .then((value) => completer.complete(null))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<void> setChannelDescription(String roomId, String description) {
    Completer<void> completer = Completer();
    this
        ._getDdpClient()
        .call('saveRoomSettings', [roomId, 'roomDescription', description])
        .then((value) => completer.complete(null))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }
}
