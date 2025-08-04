// // lib/features/teacher/bloc/follow_up_event.dart
// part of 'follow_up_bloc.dart';

// abstract class FollowUpEvent {}

// class LoadInitialData extends FollowUpEvent {}
// class SavedPagesChanged extends FollowUpEvent {
//   final String count;
//   SavedPagesChanged(this.count);
// }
// class ReviewedPagesChanged extends FollowUpEvent {
//   final String count;
//   ReviewedPagesChanged(this.count);
// }
// class MemorizationScoreChanged extends FollowUpEvent {
//   final int score;
//   MemorizationScoreChanged(this.score);
// }
// class ReviewScoreChanged extends FollowUpEvent {
//   final int score;
//   ReviewScoreChanged(this.score);
// }
// class SaveFollowUpData extends FollowUpEvent {}
// class DutyFromPageChanged extends FollowUpEvent {
//   final String value;
//   DutyFromPageChanged(this.value);
// }

// class DutyToPageChanged extends FollowUpEvent {
//   final String value;
//   DutyToPageChanged(this.value);
// }

// class DutyRequiredPartsChanged extends FollowUpEvent {
//   final String value;
//   DutyRequiredPartsChanged(this.value);
// }
// class SubmitFollowUp extends FollowUpEvent {}
part of 'follow_up_bloc.dart';

abstract class FollowUpEvent {}

class LoadInitialData extends FollowUpEvent {}

// أحداث المتابعة
class SavedPagesChanged extends FollowUpEvent { final String count; SavedPagesChanged(this.count); }
class ReviewedPagesChanged extends FollowUpEvent { final String count; ReviewedPagesChanged(this.count); }
class MemorizationScoreChanged extends FollowUpEvent { final int score; MemorizationScoreChanged(this.score); }
class ReviewScoreChanged extends FollowUpEvent { final int score; ReviewScoreChanged(this.score); }

// أحداث الواجب
class DutyFromPageChanged extends FollowUpEvent { final String value; DutyFromPageChanged(this.value); }
class DutyToPageChanged extends FollowUpEvent { final String value; DutyToPageChanged(this.value); }
class DutyRequiredPartsChanged extends FollowUpEvent { final String value; DutyRequiredPartsChanged(this.value); }

// حدث الحفظ
class SaveFollowUpData extends FollowUpEvent {}
