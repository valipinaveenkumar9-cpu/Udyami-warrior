import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SendOtpEvent extends AuthEvent {
  final String mobileNumber;
  final bool isApplying;
  final String purpose;
  const SendOtpEvent(this.mobileNumber, {this.isApplying = false, this.purpose = 'LOGIN'});

  @override
  List<Object> get props => [mobileNumber, isApplying, purpose];
}

class VerifyOtpEvent extends AuthEvent {
  final String otp;
  final bool isApplying;
  const VerifyOtpEvent(this.otp, {this.isApplying = false});

  @override
  List<Object> get props => [otp, isApplying];
}

class LoginWithCpIdEvent extends AuthEvent {
  final String cpId;
  final String password;
  const LoginWithCpIdEvent(this.cpId, this.password);

  @override
  List<Object> get props => [cpId, password];
}

class ResetAuthEvent extends AuthEvent {}
