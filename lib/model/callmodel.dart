class CallLog {
  String phoneNumber;
  String callType;
  int callDuration;

  CallLog(this.phoneNumber, this.callType, this.callDuration);

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'callType': callType,
      'callDuration': callDuration,
    };
  }
}
