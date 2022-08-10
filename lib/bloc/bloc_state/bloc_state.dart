abstract class BlocState {}

class InitializeBlocState extends BlocState {}

class BlocStateHappened extends BlocState {}

class BlocStateDecrease extends BlocState {}

class BlocStateIncrease extends BlocState {}

class ChangeScreenBottomNavBar extends BlocState {}

class SuccessGetAllUsersStateHome extends BlocState {}
class AddPostScreenSuccess extends BlocState {}

class LoadingGetDataStateHome extends BlocState {}

class SuccessGetDataStateHome extends BlocState {}

class ErrorGetDataStateHome extends BlocState {
  final error;
  ErrorGetDataStateHome(this.error);
}

class InitializeBlocStateMap extends BlocState {}

class ChangeMapLocation extends BlocState {}

class GoToPlaceEmit extends BlocState {}

class ChooseCoverPickerScreenError extends BlocState {}

class RemoveImageSenderSuccess extends BlocState {}

class SuccessSendAllChatsDetailsStateHome extends BlocState {}

class ErrorSendAllChatsDetailsStateHome extends BlocState {
  final error;

  ErrorSendAllChatsDetailsStateHome(this.error);
}

class ErrorGetAllUsersStateHome extends BlocState {
  final error;

  ErrorGetAllUsersStateHome(this.error);
}

class SuccessGetAllChatsDetailsStateHome extends BlocState {}
class GoToMyCurrentPosition extends BlocState {}
class GetMyCurrentLocation extends BlocState {}

class ChooseCoverPickerScreenSuccess extends BlocState {}

class ErrorGetImageSendDetailsStateHome extends BlocState {
  final error;

  ErrorGetImageSendDetailsStateHome(this.error);
}


class ChangeCurrentScreen extends BlocState {}
class ChangeInfo extends BlocState {}
class GetUserField extends BlocState {}
class GetUserToken extends BlocState {}
class Camera extends BlocState {}
class Gallery extends BlocState {}