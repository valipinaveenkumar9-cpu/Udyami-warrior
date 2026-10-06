import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSentState extends AuthState {
  final String mobileNumber;
  final String? providedOtp;
  const OtpSentState(this.mobileNumber, {this.providedOtp});

  @override
  List<Object?> get props => [mobileNumber, providedOtp];
}

class OtpVerifiedState extends AuthState {}

class OtpVerifiedForApplicationState extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class OtpVerificationError extends AuthState {
  final String message;
  final String mobileNumber;
  const OtpVerificationError(this.message, this.mobileNumber);

  @override
  List<Object> get props => [message, mobileNumber];
}
